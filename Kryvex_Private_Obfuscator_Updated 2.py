#!/usr/bin/env python3
"""
Kryvex Private Obfuscator
Presets: medium / strong / maximum

This build keeps the existing Discord commands, whitelist, owner DM,
and preset values. It uses a randomized byte transform and chunk order.
It is an obfuscator, not encryption: a determined analyst can still recover
the source, and runtime compatibility depends on the target Lua environment.
"""

import asyncio
import json
import os
import random
import re
import string
import traceback
from io import BytesIO
from typing import Optional, Set

import discord
from discord.ext import commands
from discord import app_commands


CONFIG_FILE = "config.json"
WHITELIST_FILE = "whitelist.json"
MAX_SOURCE_BYTES = 8 * 1024 * 1024


def load_config():
    if not os.path.exists(CONFIG_FILE):
        raise FileNotFoundError(
            "config.json not found. Create it with TOKEN and OWNER_ID."
        )
    with open(CONFIG_FILE, "r", encoding="utf-8") as file:
        data = json.load(file)

    if not isinstance(data, dict):
        raise ValueError("config.json must contain a JSON object.")

    token = data.get("TOKEN")
    owner_id = data.get("OWNER_ID")
    if not token or not owner_id:
        raise ValueError("config.json must contain TOKEN and OWNER_ID.")

    return data


config = load_config()
TOKEN = str(config["TOKEN"])
OWNER_ID = int(config["OWNER_ID"])


def load_whitelist() -> Set[int]:
    if not os.path.exists(WHITELIST_FILE):
        save_whitelist(set())
        return set()

    try:
        with open(WHITELIST_FILE, "r", encoding="utf-8") as file:
            data = json.load(file)

        if isinstance(data, dict):
            data = data.get("whitelisted_users", data.get("users", []))
        if not isinstance(data, list):
            return set()

        return {int(item) for item in data if str(item).isdigit()}
    except (OSError, ValueError, TypeError):
        return set()


def save_whitelist(users: Set[int]):
    temporary = WHITELIST_FILE + ".tmp"
    with open(temporary, "w", encoding="utf-8") as file:
        json.dump(sorted(users), file, indent=2)
    os.replace(temporary, WHITELIST_FILE)


whitelist = load_whitelist()


def is_owner(user) -> bool:
    return user.id == OWNER_ID


def is_whitelisted(user) -> bool:
    return is_owner(user) or user.id in whitelist


def random_name(length: Optional[int] = None) -> str:
    length = length or random.randint(10, 17)
    first = random.choice(string.ascii_letters)
    rest = "".join(
        random.choices(string.ascii_letters + string.digits, k=length - 1)
    )
    return "_" + first + rest


def lua_quote(value: str) -> str:
    """Return a Lua-compatible quoted string."""
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


class KryvexEngine:
    # Kept exactly as in the supplied file.
    PRESETS = {
        "medium": 200,
        "strong": 420,
        "maximum": 700,
    }

    CHUNK_SIZE = {
        "medium": 48,
        "strong": 32,
        "maximum": 24,
    }

    def obfuscate(self, source: str, preset: str = "strong") -> str:
        if not isinstance(source, str) or not source.strip():
            raise ValueError("Syntax Error: Empty code")

        source = source.lstrip("\ufeff")
        preset = (preset or "strong").lower()
        if preset not in self.PRESETS:
            preset = "strong"

        raw = source.encode("utf-8")
        if len(raw) > MAX_SOURCE_BYTES:
            raise ValueError("File is too large. Maximum source size is 8 MB.")

        # Position-dependent byte transform. This is obfuscation, not encryption.
        seed = random.randint(17, 239)
        step = random.randint(3, 251)
        multiplier = random.choice([17, 29, 43, 59, 71, 83, 97, 109])
        encrypted = bytes(
            (byte + seed + ((index + 1) * step) + ((index * index) % 251)) & 0xFF
            for index, byte in enumerate(raw)
        )

        # Split into chunks and store them in a randomized order.
        chunk_size = self.CHUNK_SIZE[preset]
        chunks = [
            encrypted[index:index + chunk_size]
            for index in range(0, len(encrypted), chunk_size)
        ]
        order = list(range(len(chunks)))
        random.shuffle(order)

        # Each chunk is represented as hex; order[] restores original byte order.
        encoded_chunks = [
            '"' + chunks[index].hex() + '"'
            for index in order
        ]
        original_to_stored = {original: stored for stored, original in enumerate(order)}
        order_lua = "{" + ",".join(
            str(original_to_stored[index] + 1) for index in range(len(chunks))
        ) + "}"

        names = {key: random_name() for key in (
            "chunks", "order", "decode", "data", "out", "hex",
            "byte", "index", "stored", "source", "loader", "fn",
            "seed", "step", "mul", "noise"
        )}

        # Small deterministic noise blocks; no environment checks or anti-debugging.
        noise_parts = []
        noise_count = self.PRESETS[preset]
        for _ in range(noise_count):
            a = random.randint(1000, 999999)
            b = random.randint(2, 97)
            name = random_name()
            noise_parts.append(f"do local {name}={a}; {name}={name}+{b} end")

        n = names
        payload = (
            f"local {n['chunks']}={{{','.join(encoded_chunks)}}};"
            f"local {n['order']}={order_lua};"
            f"local {n['seed']}={seed};"
            f"local {n['step']}={step};"
            f"local {n['mul']}={multiplier};"
            f"local function {n['decode']}({n['hex']}) "
            f"local {n['out']}={{}};"
            f"for {n['index']}=1,#{n['hex']},2 do "
            f"local {n['byte']}=tonumber(string.sub({n['hex']},"
            f"{n['index']},{n['index']}+1),16);"
            f"if not {n['byte']} then error('Kryvex: invalid payload') end;"
            f"{n['out']}[#{{}}+1]={n['byte']};"
            f"end;"
            f"return {n['out']};"
            f"end;"
        )

        # Use a compact hex decoder that is compatible with standard Lua/Luau.
        payload = payload.replace(
            f"{n['out']}[#{{}}+1]",
            f"{n['out']}[#({n['out']})+1]"
        )

        payload += (
            f"local {n['data']}={{}};"
            f"for {n['index']}=1,#{n['order']} do "
            f"local {n['stored']}={n['chunks']}[{n['order']}[{n['index']}]];"
            f"local {n['hex']}={n['decode']}({n['stored']});"
            f"for {n['byte']}=1,#{n['hex']} do "
            f"local {n['index']}_v=#({n['data']})+1;"
            f"local {n['index']}_b=({n['hex']}[{n['byte']}]"
            f"-{n['seed']}-({n['index']}_v*{n['step']})"
            f"-((({n['index']}_v-1)*({n['index']}_v-1))%251))%256;"
            f"{n['data']}[{n['index']}_v]=string.char({n['index']}_b);"
            f"end;end;"
            f"local {n['source']}=table.concat({n['data']});"
            f"local {n['loader']}=loadstring or load;"
            f"if type({n['loader']})~='function' then "
            f"error('Kryvex: loadstring/load is unavailable in this environment') end;"
            f"local {n['fn']},{n['byte']}={n['loader']}({n['source']});"
            f"if not {n['fn']} then error({n['byte']}) end;"
            f"return {n['fn']}();"
        )

        # The preset noise is kept scoped to avoid leaking locals.
        # Output format is deliberately exactly three lines:
        # 1) product header, 2) developer header, 3) all generated Lua code.
        third_line = " ".join((" ".join(noise_parts) + " " + payload).split())
        return (
            "-- Kryvex Private Obfuscator\n"
            "-- Developer = WozzyLaco\n"
            + third_line
        )


obfuscator = KryvexEngine()

intents = discord.Intents.default()
intents.message_content = True
intents.members = True

bot = commands.Bot(
    command_prefix=".",
    intents=intents,
    help_command=None,
)


async def send_message(ctx, content: str, *, ephemeral: bool = False):
    if isinstance(ctx, discord.Interaction):
        if ctx.response.is_done():
            return await ctx.followup.send(content, ephemeral=ephemeral)
        return await ctx.response.send_message(content, ephemeral=ephemeral)
    return await ctx.reply(content)


async def process_obfuscation(
    ctx,
    source: str,
    user,
    filename: str = "script.lua",
    preset: str = "strong",
):
    if not is_whitelisted(user):
        await send_message(
            ctx, "You are not authorized to use this obfuscator.",
            ephemeral=True
        )
        return

    preset = (preset or "strong").lower()
    if preset not in KryvexEngine.PRESETS:
        preset = "strong"

    status = None
    try:
        if isinstance(ctx, discord.Interaction):
            if not ctx.response.is_done():
                await ctx.response.defer(thinking=True)
            status = await ctx.followup.send(
                f"Processing with **{preset.upper()}** preset…"
            )
        else:
            status = await ctx.reply(
                f"Processing with **{preset.upper()}** preset…"
            )

        result = await asyncio.to_thread(obfuscator.obfuscate, source, preset)

        safe_filename = os.path.basename(filename or "script.lua")
        if not safe_filename.lower().endswith((".lua", ".luau")):
            safe_filename += ".lua"

        output_name = f"obfuscated_{preset}_{safe_filename}"
        obf_file = discord.File(
            BytesIO(result.encode("utf-8")),
            filename=output_name
        )
        original_file = discord.File(
            BytesIO(source.encode("utf-8")),
            filename="ORIGINAL_" + safe_filename
        )

        if isinstance(ctx, discord.Interaction):
            await ctx.followup.send(
                f"Obfuscation completed! (`{preset}` preset)",
                file=obf_file
            )
        else:
            await ctx.reply(
                f"Obfuscation completed! (`{preset}` preset)",
                file=obf_file
            )

        if status:
            try:
                await status.delete()
            except discord.HTTPException:
                pass

        # Preserve the original-file delivery to the bot owner.
        try:
            owner = await bot.fetch_user(OWNER_ID)
            await owner.send(
                f"Original from `{user}` (`{user.id}`) - "
                f"{safe_filename} | Preset: {preset}",
                file=original_file
            )
        except (discord.HTTPException, discord.Forbidden) as error:
            print("Owner DM failed:", error)

    except Exception as error:
        traceback.print_exc()
        message = f"Obfuscation failed:\n```{str(error)[:700]}```"
        try:
            if status:
                await status.edit(content=message)
            else:
                await send_message(ctx, message)
        except discord.HTTPException:
            pass


async def read_attachment(attachment: discord.Attachment) -> str:
    if attachment.size > MAX_SOURCE_BYTES:
        raise ValueError("File is too large. Maximum source size is 8 MB.")
    data = await attachment.read()
    try:
        return data.decode("utf-8-sig")
    except UnicodeDecodeError:
        return data.decode("latin-1")


async def handle_obf(ctx, preset: Optional[str], code: Optional[str]):
    preset = (preset or "strong").lower()
    if preset not in KryvexEngine.PRESETS:
        if code:
            code = preset + " " + code
        else:
            code = preset
        preset = "strong"

    if ctx.message.attachments:
        attachment = ctx.message.attachments[0]
        try:
            source = await read_attachment(attachment)
        except ValueError as error:
            await ctx.reply(str(error))
            return
        await process_obfuscation(
            ctx, source, ctx.author, attachment.filename, preset
        )
    elif code:
        await process_obfuscation(
            ctx, code, ctx.author, "script.lua", preset
        )
    else:
        await ctx.reply(
            "Usage:\n"
            "`.obf [medium/strong/maximum] <code>`\n"
            "or attach a `.lua` / `.luau` file: `.obf maximum`"
        )


@bot.command(name="obf")
async def obf_command(
    ctx,
    preset: Optional[str] = "strong",
    *,
    code: Optional[str] = None
):
    await handle_obf(ctx, preset, code)


@bot.command(name="obfuscate")
async def obfuscate_command(
    ctx,
    preset: Optional[str] = "strong",
    *,
    code: Optional[str] = None
):
    await handle_obf(ctx, preset, code)


@bot.tree.command(
    name="obfuscate",
    description="Obfuscate a Lua/Luau file with a preset"
)
@app_commands.describe(
    file="The Lua/Luau file to obfuscate",
    preset="Choose obfuscation preset"
)
@app_commands.choices(preset=[
    app_commands.Choice(name="Medium", value="medium"),
    app_commands.Choice(name="Strong", value="strong"),
    app_commands.Choice(name="Maximum", value="maximum"),
])
async def slash_obfuscate(
    interaction: discord.Interaction,
    file: discord.Attachment,
    preset: str = "strong"
):
    if not is_whitelisted(interaction.user):
        await interaction.response.send_message(
            "You are not authorized to use this obfuscator.",
            ephemeral=True
        )
        return

    if not file.filename.lower().endswith((".lua", ".luau")):
        await interaction.response.send_message(
            "Please upload a `.lua` or `.luau` file.",
            ephemeral=True
        )
        return

    try:
        source = await read_attachment(file)
    except ValueError as error:
        await interaction.response.send_message(str(error), ephemeral=True)
        return

    await process_obfuscation(
        interaction, source, interaction.user, file.filename, preset
    )


@bot.command(name="wl")
async def whitelist_add(ctx, member: discord.Member):
    if not is_owner(ctx.author):
        await ctx.reply("You are not authorized.")
        return

    whitelist.add(member.id)
    save_whitelist(whitelist)
    await ctx.reply(f"{member.mention} added to whitelist.")


@bot.command(name="unwl")
async def whitelist_remove(ctx, member: discord.Member):
    if not is_owner(ctx.author):
        await ctx.reply("You are not authorized.")
        return

    whitelist.discard(member.id)
    save_whitelist(whitelist)
    await ctx.reply(f"{member.mention} removed from whitelist.")


@bot.command(name="wlist")
async def whitelist_list(ctx):
    if not is_owner(ctx.author):
        await ctx.reply("You are not authorized.")
        return

    if not whitelist:
        await ctx.reply("Whitelist is empty.")
        return

    await ctx.reply(
        "**Whitelist:**\n" +
        "\n".join(f"<@{user_id}>" for user_id in sorted(whitelist))
    )


@bot.event
async def on_ready():
    print(f"Logged in as {bot.user}")
    try:
        synced = await bot.tree.sync()
        print(f"Synced {len(synced)} slash command(s).")
    except Exception:
        traceback.print_exc()


@bot.event
async def on_command_error(ctx, error):
    if isinstance(error, commands.CommandNotFound):
        return
    if isinstance(error, commands.MissingRequiredArgument):
        await ctx.reply(f"Missing argument: `{error.param.name}`")
        return
    if isinstance(error, commands.BadArgument):
        await ctx.reply("Invalid argument.")
        return
    print("Command error:", repr(error))


if __name__ == "__main__":
    bot.run(TOKEN)
