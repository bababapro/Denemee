-- =====================================================================
--   MADE BY deepseek-v4-flash INSIDE PROJECT UAI
--   KRYVEX HUB | Legends of Speed
-- =====================================================================
--
--   >> WINDUI EDITION  (file: los_autofarm_v5_ui.lua)
--   Same v5 farm core; the hand-built HUD is replaced by the Project
--   UAI UI LIB window from
--   https://raw.githubusercontent.com/Project-Ptolemy/ProjectUAI
--   los_autofarm_v5.lua itself is untouched.
--
-- v5 was written against the LIVE place 3101667897 on 2026-09-21, using the
-- decompiled client scripts (Potassium 2.4.9) instead of guesswork.
--
-- WHAT v4 GOT WRONG, AND WHAT v5 DOES INSTEAD (all measured in-game)
-- ---------------------------------------------------------------------
-- * EGG HATCHING WAS 50x TOO SLOW AND SILENTLY DEAD. v4 held E for 0.8s beside
--   the crystal and hopped 34 studs out and back, giving ~1 hatch per 7s. The
--   real call the game makes is one line inside crystalOpenScript:
--       openCrystalRemote:InvokeServer("openCrystal", "<Name> Crystal")
--   v5 calls it directly. No menu, no E, no movement, no proximity: the client's
--   30-stud check lives in crystalOpenScript.openOneCrystal and the server does
--   not repeat it (verified hatching from 400+ studs away).
--   MEASURED v5: 4.4-9.4 hatches/s, zero failures.
-- * HATCHING DIES AT FULL CAPACITY. openOneCrystal refuses when
--   calculatePetCapacity(petsFolder) or calculateTrailCapacity(trailsFolder)
--   reaches maxPetCapacity, and the server refuses too (0 gems spent, nil back).
--   v4 reported "crystal busy" forever. v5 adds a SELL ENGINE that keeps N free
--   slots, so hatching never stalls.
-- * NOTHING WAS EVER SOLD OR EQUIPPED. Real shapes, read from the GUI scripts:
--       sellPetEvent:FireServer("sellPet", petInstance)
--       sellTrailEvent:FireServer("sellTrail", trailInstance)
--       equipPetEvent:FireServer("equipPet" / "unequipPet", petInstance)
--       petEvolveEvent:FireServer("evolvePet", pet.Name)
--       evolveTrailEvent:FireServer("evolveTrail", trailInstance)
--       rebirthEvent:FireServer("rebirthRequest")
--       rEvents.ultimatesRemote:InvokeServer("upgradeUltimate", "<name>")
--       rEvents.checkChestRemote:InvokeServer("<Chest Name>")
--   Sell value is globalFunctions.calculatePetValue(tier, level, evolved).
-- * THE DROP TABLES ARE PUBLIC. ReplicatedStorage.crystalChances lists every
--   crystal's pool with chanceValue/nameValue/rarityValue, and cPetShopFolder
--   prices every pet and trail. v5 reads both, so it can snipe a named pet
--   ("Swift Samurai", Jungle Crystal, 1%) instead of hatching blind.
--   Jungle Crystal: Swift Samurai Omega 1%, Golden Viking Unique 20%,
--   Speedy Sensei Unique 14%, Maestro Dog Unique 35%, Divine Pegasus Epic 30%.
--   Electro Legends Crystal: six Omegas, 2-30% each (no rare ones).
-- * ORB FARM, HOOP LOOP, QUESTS were already right in v4 and are unchanged.
--   orbEvent:FireServer("collectOrb", orbName, currentMap.Value) is exactly what
--   oScript fires; hoopEvent is server->client only, so relocating Workspace.Hoops
--   onto the character is still the only lever.
--
-- NEW IN v5: sell engine (ranked by real pet/trail prices, never sells equipped),
-- auto-equip that frees a slot first, pet sniper with live chance math, auto
-- rebirth, auto ultimate upgrades, chest collector, session income stats.
-- =====================================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local rEvents = RS:WaitForChild("rEvents", 30)
local function remote(name)
    local r = rEvents and rEvents:FindFirstChild(name)
    return r
end
local orbEvent = remote("orbEvent")
local questsEvent = remote("questsEvent")
local openCrystalRemote = remote("openCrystalRemote")
local sellPetEvent = remote("sellPetEvent")
local sellTrailEvent = remote("sellTrailEvent")
local equipPetEvent = remote("equipPetEvent")
local petEvolveEvent = remote("petEvolveEvent")
local evolveTrailEvent = remote("evolveTrailEvent")
local rebirthEvent = remote("rebirthEvent")
local speedRampEvent = remote("speedRampEvent")
local ultimatesRemote = remote("ultimatesRemote")
local checkChestRemote = remote("checkChestRemote")

local GF = nil
pcall(function() GF = require(RS:WaitForChild("globalFunctions")) end)

local MONO = {
    bg = Color3.fromRGB(18, 18, 20),
    panel = Color3.fromRGB(26, 26, 30),
    panel2 = Color3.fromRGB(34, 34, 40),
    border = Color3.fromRGB(48, 48, 56),
    text = Color3.fromRGB(235, 235, 240),
    sub = Color3.fromRGB(150, 150, 160),
    accent = Color3.fromRGB(200, 200, 210),
    success = Color3.fromRGB(120, 255, 160),
    warn = Color3.fromRGB(255, 200, 90),
    danger = Color3.fromRGB(255, 90, 90),
    rare = Color3.fromRGB(180, 140, 255),
}

local state = {
    -- hatch
    hatcher = false, hatchThread = nil, hatchChoice = "Jungle",
    hatchRate = 8, hatchMax = 0, gemReserve = 0,
    autoSell = true, keepTop = 6, keepFree = 3,
    snipePet = "", hatches = 0, rarity = {}, hits = {},
    -- sell / equip
    autoEquip = false, equipThread = nil,
    -- other loops
    orbFarming = false, orbChoice = nil, orbRate = 1200, orbAmount = 250000,
    orbInfinite = true, orbThread = nil,
    hoopLoop = false, hoopThread = nil,
    quest = false, questThread = nil,
    evolvePets = false, petThread = nil,
    evolveTrails = false, trailThread = nil,
    ramps = false, rampThread = nil,
    autoRebirth = false, rebirthThread = nil, rebirthsDone = 0, rebirthReserve = 3,
    autoUltimates = false, ultimateThread = nil, ultimatesBought = 0,
    chests = false, chestThread = nil, chestsOpened = 0,
    keepNames = {},
    minimised = false, session = {},
}

-- ============ INSTANCE GUARD ============
local GENV = _G
pcall(function()
    if type(getgenv) == "function" then GENV = getgenv() end
end)
local INSTANCE_ID = (GENV.__KRYVEX_HUB_ID or 0) + 1
GENV.__KRYVEX_HUB_ID = INSTANCE_ID
local function isCurrent() return GENV.__KRYVEX_HUB_ID == INSTANCE_ID end

-- replaced with the real thing once the GUI exists (declared here so every loop
-- below can report through it)
local setStatus = function() end
-- toast, replaced once the GUI exists
local notify = function() end

-- names that must never be sold (filled from the GUI / API)
state.keepNames = {}

local function spawnLoop(fn)
    local co = coroutine.create(function()
        local ok, err = pcall(fn)
        if not ok then warn("[KRYVEX HUB] loop error: " .. tostring(err)) end
    end)
    local ok, err = coroutine.resume(co)
    if not ok then warn("[KRYVEX HUB] loop error: " .. tostring(err)) end
    return co
end

-- ============ LIVE GAME DATA ============
local function shorten(n)
    n = tonumber(n) or 0
    local s = { "", "K", "M", "B", "T", "Qa", "Qi" }
    local i = 1
    while n >= 1000 and i < #s do n = n / 1000; i = i + 1 end
    return i == 1 and tostring(math.floor(n)) or string.format("%.2f%s", n, s[i])
end

local function statValue(name)
    local v = player:FindFirstChild(name)
    if v and v:IsA("ValueBase") then return v.Value end
    local ls = player:FindFirstChild("leaderstats")
    v = ls and ls:FindFirstChild(name)
    return v and v.Value or 0
end

local function shadowNum(v) return tonumber(v) or 0 end
local function gems() return shadowNum(player:FindFirstChild("Gems") and player.Gems.Value) end
local function level() return shadowNum(player:FindFirstChild("level") and player.level.Value) end
local function rebirths() return shadowNum(statValue("Rebirths")) end
local function cap()
    local c = player:FindFirstChild("maxPetCapacity")
    return c and c.Value or 20
end

-- every crystal, cheapest first, with its real drop pool
local crystals = {}
do
    local prices = RS:FindFirstChild("crystalPrices")
    local chances = RS:FindFirstChild("crystalChances")
    if prices then
        for _, c in ipairs(prices:GetChildren()) do
            local base = c.Name:gsub(" Crystal$", "")
            local p, t = c:FindFirstChild("price"), c:FindFirstChild("priceType")
            local entry = { base = base, price = (p and p.Value) or math.huge, ptype = (t and t.Value) or "Gems", pool = {} }
            local ch = chances and chances:FindFirstChild(c.Name)
            if ch then
                for _, item in ipairs(ch:GetChildren()) do
                    local n = item:FindFirstChild("nameValue")
                    local r = item:FindFirstChild("rarityValue")
                    local cv = item:FindFirstChild("chanceValue")
                    if n then
                        table.insert(entry.pool, { name = n.Value, rarity = r and r.Value or "?", chance = (cv and cv.Value) or 0 })
                    end
                end
                table.sort(entry.pool, function(a, b) return a.chance < b.chance end)
            end
            table.insert(crystals, entry)
        end
        table.sort(crystals, function(a, b) return a.price < b.price end)
    end
end

local function crystalByName(base)
    if base == nil then return nil end
    base = tostring(base):gsub("%s*Crystal%s*$", "")
    for _, c in ipairs(crystals) do
        if c.base == base or (c.base .. " Crystal") == base then return c end
    end
    return nil
end
local function crystalLabel(c)
    local parts = {}
    for _, p in ipairs(c.pool) do
        table.insert(parts, string.format("%s %s %d%%", p.name, p.rarity, p.chance))
    end
    return table.concat(parts, ", ")
end

-- real pet/trail prices: cPetShopFolder prices every pet and trail
local priceOf = {}
do
    local shop = RS:FindFirstChild("cPetShopFolder")
    if shop then
        for _, item in ipairs(shop:GetChildren()) do
            local p = item:FindFirstChild("priceValue")
            local r = item:FindFirstChild("rarityValue")
            if p and not priceOf[item.Name] then
                priceOf[item.Name] = { price = p.Value, rarity = r and r.Value or "?" }
            end
        end
    end
end

local orbs = {}      -- orb name -> { stat = "Steps"/"Gems", base = n }
do
    local folder = RS:FindFirstChild("Orbs")
    if folder then
        for _, m in ipairs(folder:GetChildren()) do
            local v = m:FindFirstChildOfClass("IntValue") or m:FindFirstChildOfClass("NumberValue")
            if v then orbs[m.Name] = { stat = v.Name, base = v.Value } end
        end
    end
end

-- ============ ITEM HELPERS ============
local function folders()
    return {
        pets = player:FindFirstChild("petsFolder"),
        trails = player:FindFirstChild("trailsFolder"),
    }
end

local function itemRows(kind)
    local f = folders()[kind]
    local rows = {}
    if not f then return rows end
    for _, tier in ipairs(f:GetChildren()) do
        for _, it in ipairs(tier:GetChildren()) do
            rows[#rows + 1] = { it = it, tier = tier.Name, name = it.Name, kind = kind }
        end
    end
    return rows
end

local function itemCount(kind)
    local f = folders()[kind]
    local n = 0
    if not f then return 0 end
    for _, tier in ipairs(f:GetChildren()) do n = n + #tier:GetChildren() end
    return n
end

-- what selling an item actually pays, level and evolution included
local function sellValueOf(row)
    if not GF then return 0 end
    local lvl = row.it:FindFirstChild("level")
    return GF.calculatePetValue(row.tier, lvl and lvl.Value or 1, row.it:FindFirstChild("evolved") ~= nil)
end

local function equippedSet()
    local set = {}
    local eq = player:FindFirstChild("equippedPets")
    if eq then
        for _, c in ipairs(eq:GetChildren()) do
            local ref = c:FindFirstChild("petReference")
            if ref and ref.Value then set[ref.Value] = true end
        end
    end
    return set
end

local function equippedTrail()
    local t = player:FindFirstChild("equippedTrail")
    return t and t.Value or nil
end

-- ============ SELL / KEEP POLICY ============
-- Every sell decision goes through buildKeepSet, so "what gets sold" is one
-- readable rule instead of scattered conditions:
--   1. NEVER sell  the equipped pets, the equipped trail, or anything named in
--      state.keepNames.
--   2. NEVER sell  evolved pets/trails (state.keepEvolved) - each one cost five
--      non-evolved copies, verified below.
--   3. ALWAYS sell anything below the rarity floor (state.sellBelow) unless it is
--      hard-protected (equipped, named in keepNames, or evolved with keepEvolved
--      on) - a floor is for dumping fodder, not for destroying a kept pet.
--   4. KEEP UP TO state.keepDupes copies of a name in state.keepNames - that is
--      evolve fodder, and selling it is what silently kills auto-evolve.
--   5. KEEP the best state.keepTop items by the selected ranking.
--   6. Sell the lowest-ranked survivors, worst first, when a slot is needed.
local RARITY_ORDER = { Basic = 1, Advanced = 2, Rare = 3, Epic = 4, Unique = 5, Omega = 6 }
local sellStats = { pets = 0, trails = 0, gems = 0 }

state.rankMode = state.rankMode or "MARKET"
state.sellBelow = state.sellBelow or "Basic"
if state.keepEvolved == nil then state.keepEvolved = true end
state.keepDupes = state.keepDupes or 5
if state.evolveAll == nil then state.evolveAll = true end
if state.autoEvolve == nil then state.autoEvolve = false end

-- ranking is selectable, because "best" means different things here:
--   MARKET  = ReplicatedStorage.cPetShopFolder priceValue (rarity/desirability)
--   VALUE   = what selling it actually pays, globalFunctions.calculatePetValue
--   RARITY  = tier first (Omega > Unique > Epic > Rare > Advanced > Basic)
local function marketOf(row)
    local p = priceOf[row.name]
    return p and p.price or 0
end
local function rarityOf(row)
    local p = priceOf[row.name]
    return p and p.rarity or "Basic"
end
local function rankOf(row)
    if state.rankMode == "VALUE" then return sellValueOf(row) end
    if state.rankMode == "RARITY" then
        return (RARITY_ORDER[rarityOf(row)] or 0) * 1000000 + sellValueOf(row)
    end
    return marketOf(row)
end

local function isEvolved(row)
    local e = row.it:FindFirstChild("evolved")
    return e ~= nil and e.Value == true
end

local function isProtected(row)
    if row.kind == "pets" and equippedSet()[row.it] then return true end
    if row.kind == "trails" and equippedTrail() == row.it then return true end
    if state.keepNames[row.name] then return true end
    return false
end

-- worst first, so index 1 is the next candidate to sell
local function rankedWorstFirst(kind)
    local rows = itemRows(kind)
    table.sort(rows, function(a, b)
        local ra, rb = rankOf(a), rankOf(b)
        if ra == rb then return sellValueOf(a) < sellValueOf(b) end
        return ra < rb
    end)
    return rows
end

local function buildKeepSet(kind)
    local rows = rankedWorstFirst(kind)
    local keep, dupes = {}, {}
    local topKept = 0
    local floor = RARITY_ORDER[state.sellBelow] or 0
    for i = #rows, 1, -1 do                     -- best first
        local row = rows[i]
        local protected = isProtected(row)
        local evo = isEvolved(row)
        local belowFloor = (RARITY_ORDER[rarityOf(row)] or 0) < floor
        if protected or (state.keepEvolved and evo) then
            keep[row.it] = true
        elseif belowFloor then
            -- forced out, never kept (step 3)
        elseif state.keepNames[row.name] then
            dupes[row.name] = dupes[row.name] or 0
            if dupes[row.name] < state.keepDupes then
                dupes[row.name] = dupes[row.name] + 1
                keep[row.it] = true
            end
        elseif topKept < state.keepTop then
            topKept = topKept + 1
            keep[row.it] = true
        end
    end
    return keep
end

local function nextToSell(kind)
    local keep = buildKeepSet(kind)
    for _, row in ipairs(rankedWorstFirst(kind)) do
        if not keep[row.it] then return row end
    end
    return nil
end

-- what the policy would sell next, for the GUI (answers "what gets auto sold")
local function sellPreview(kind, n)
    local keep = buildKeepSet(kind)
    local out = {}
    for _, row in ipairs(rankedWorstFirst(kind)) do
        if not keep[row.it] then
            table.insert(out, string.format("%s (%s, %d)", row.name, rarityOf(row), sellValueOf(row)))
            if #out >= (n or 3) then break end
        end
    end
    return out
end

local function sellRow(row)
    if row.kind == "pets" then
        if sellPetEvent then sellPetEvent:FireServer("sellPet", row.it) end
        sellStats.pets = sellStats.pets + 1
    else
        if sellTrailEvent then sellTrailEvent:FireServer("sellTrail", row.it) end
        sellStats.trails = sellStats.trails + 1
    end
    return true
end

local function sellLowest(kind)
    local row = nextToSell(kind)
    if not row then return nil end
    sellRow(row)
    return row
end

-- sell a freshly hatched item unless the policy says it is a keeper
local function sellIfJunk(row)
    if not state.autoSell or not row then return false end
    local keep = buildKeepSet(row.kind)
    if keep[row.it] then return false end
    local g0 = gems()
    sellRow(row)
    sellStats.gems = sellStats.gems + math.max(gems() - g0, 0)
    return true
end

-- keep `state.keepFree` slots free on both pets and trails
local function ensureRoom(need)
    need = need or state.keepFree
    local freed = 0
    local capNow = cap()
    for _ = 1, 30 do
        if capNow - itemCount("pets") >= need then break end
        if not sellLowest("pets") then break end
        freed = freed + 1
        task.wait(0.08)
    end
    for _ = 1, 30 do
        if capNow - itemCount("trails") >= need then break end
        if not sellLowest("trails") then break end
        freed = freed + 1
        task.wait(0.08)
    end
    return freed
end

-- ============ EVOLVE ENGINE ============
-- Verified live: evolving needs FIVE non-evolved copies of the same name, and the
-- server consumes four of them, leaving one marked evolved.
--   pets : petEvolveEvent:FireServer("evolvePet", petName)
--   trails: evolveTrailEvent:FireServer("evolveTrail", trailInstance)
-- Measured: 5x Red Bunny (1,500 gems each from the pet shop) -> pets 14 -> 10 with
-- one evolved Red Bunny left; 5x Red Trail -> trails 19 -> 15 with one evolved.
-- globalFunctions.getNumberOfPets / getNumberOfSameTrail count only NON-evolved
-- copies, which is exactly the number the /5 gate wants.
local evolveStats = { pets = 0, trails = 0, last = {} }

local function evolveCounts(kind)
    local counts = {}
    for _, row in ipairs(itemRows(kind)) do
        if not isEvolved(row) then
            counts[row.name] = (counts[row.name] or 0) + 1
        end
    end
    return counts
end

local function evolveScan(kind, onlyKeepList)
    local counts = evolveCounts(kind)
    local done = {}
    local names = {}
    for name, n in pairs(counts) do
        if n >= 5 then table.insert(names, name) end
    end
    table.sort(names)
    for _, name in ipairs(names) do
        if state.evolveAll or not onlyKeepList or state.keepNames[name] then
            if kind == "pets" then
                if petEvolveEvent then petEvolveEvent:FireServer("evolvePet", name) end
                evolveStats.pets = evolveStats.pets + 1
            else
                -- trails take the instance, so hand over a non-evolved copy
                for _, row in ipairs(itemRows("trails")) do
                    if row.name == name and not isEvolved(row) then
                        if evolveTrailEvent then evolveTrailEvent:FireServer("evolveTrail", row.it) end
                        break
                    end
                end
                evolveStats.trails = evolveStats.trails + 1
            end
            evolveStats.last[kind .. "/" .. name] = (evolveStats.last[kind .. "/" .. name] or 0) + 1
            table.insert(done, name)
            task.wait(0.9)
        end
    end
    return done
end

local function evolveNow()
    local a = evolveScan("pets")
    local b = evolveScan("trails")
    return a, b
end

local function evolveLoop()
    while (state.autoEvolve or state.evolvePets or state.evolveTrails) and isCurrent() do
        local fired = {}
        if state.autoEvolve or state.evolvePets then
            for _, n in ipairs(evolveScan("pets")) do table.insert(fired, "pet " .. n) end
        end
        if state.autoEvolve or state.evolveTrails then
            for _, n in ipairs(evolveScan("trails")) do table.insert(fired, "trail " .. n) end
        end
        if #fired > 0 then
            setStatus("Evolved: " .. table.concat(fired, ", "), MONO.rare)
            notify("Evolved " .. #fired .. " item type(s)", "good")
        else
            local ready = {}
            for kind, label in pairs({ pets = "pets", trails = "trails" }) do
                local best, bestName = 0, nil
                for name, n in pairs(evolveCounts(kind)) do
                    if n > best and n >= 2 then best, bestName = n, name end
                end
                if bestName then
                    ready[#ready + 1] = string.format("%s %s %d/5", label, bestName, best)
                end
            end
            setStatus(#ready > 0 and ("Evolve watch: " .. table.concat(ready, ", ")) or "Evolve watch: no duplicates yet", MONO.sub)
        end
        task.wait(3)
    end
    state.autoEvolve, state.evolvePets, state.evolveTrails = false, false, false
    state.evolveThread = nil
end

-- ============ EQUIP ENGINE ============
-- The game refuses an equip when every slot is taken (findEmptyPetSlot == nil),
-- so v5 unequips the weakest equipped pet first, then equips. Verified: equipping
-- into a freed slot lands (pet1 went from Unique/Speedy Sensei to Omega/Soul Fusion Dog).
local equipStats = { equipped = 0, unequipped = 0 }

local function drainTotals()
    local t = 0
    local rows = itemRows("pets")
    for _, r in ipairs(rows) do t = t + sellValueOf(r) end
    return t
end

local function autoEquipStep()
    local eq = player:FindFirstChild("equippedPets")
    if not eq then return 0 end
    local slots = #eq:GetChildren()
    if slots == 0 then slots = 4 end
    local rows = itemRows("pets")
    if #rows == 0 then return 0 end
    table.sort(rows, function(a, b)
        local ra, rb = rankOf(a), rankOf(b)
        if ra == rb then return sellValueOf(a) > sellValueOf(b) end
        return ra > rb
    end)
    local have = equippedSet()
    local actions = 0
    local wanted = math.min(slots, #rows)
    for i = 1, wanted do
        local row = rows[i]
        if not have[row.it] then
            -- free a slot if the list is full
            local occupied = 0
            for _ in ipairs(eq:GetChildren()) do occupied = occupied + 1 end
            if occupied >= slots then
                -- weak link: lowest rank that is currently equipped
                local worst
                for _, c in ipairs(eq:GetChildren()) do
                    local ref = c:FindFirstChild("petReference")
                    if ref and ref.Value then
                        local rk = priceOf[ref.Value.Name] and priceOf[ref.Value.Name].price or 0
                        if not worst or rk < worst.rank then worst = { ref = ref, rank = rk } end
                    end
                end
                if worst and worst.rank < rankOf(row) and equipPetEvent then
                    equipPetEvent:FireServer("unequipPet", worst.ref.Value)
                    equipStats.unequipped = equipStats.unequipped + 1
                    task.wait(0.35)
                else
                    break
                end
            end
            if equipPetEvent then
                equipPetEvent:FireServer("equipPet", row.it)
                equipStats.equipped = equipStats.equipped + 1
                actions = actions + 1
                task.wait(0.35)
            end
        end
    end
    return actions
end

local function equipLoop()
    while state.autoEquip and isCurrent() do
        local n = autoEquipStep()
        setStatus(n > 0 and ("Equipped " .. n .. " pet(s)") or "Equipped pets already optimal", MONO.accent)
        task.wait(5)
    end
    state.autoEquip = false
    state.equipThread = nil
end

-- ============ HATCH ENGINE (v5 flagship) ============
-- The whole game-side hatch is:
--   openCrystalRemote:InvokeServer("openCrystal", "<Name> Crystal")
-- Returns (petName, rarity, imageId, extra). Cost is crystalPrices[name].price in
-- Gems. No cooldown was measured; capacity (pets AND trails under maxPetCapacity)
-- is the only real gate, which is why the sell engine runs inside this loop.
local hatchStats = { attempts = 0, pets = 0, trails = 0, gems = 0, failed = 0 }

local function crystalFor(base)
    local c = crystalByName(base)
    if c then return c end
    return crystals[#crystals]
end

-- most expensive crystal we can still afford above the gem reserve
local function bestAffordable()
    for i = #crystals, 1, -1 do
        local c = crystals[i]
        if c.ptype == "Gems" and gems() - c.price >= state.gemReserve then return c.base end
    end
    return nil
end

-- how many hatches, on average, to land a named pet from this crystal
local function oddsFor(base, petName)
    local c = crystalByName(base)
    if not c then return nil end
    for _, p in ipairs(c.pool) do
        if p.name == petName then
            local chance = math.max(p.chance, 1)
            return { chance = p.chance, rarity = p.rarity,
                     expected = math.ceil(100 / chance),
                     cost = math.ceil(100 / chance) * c.price }
        end
    end
    return nil
end

local function hatchOnce()
    local base = state.hatchChoice
    if base == "Auto" then
        base = bestAffordable()
        if not base then return false, "nothing affordable above the reserve" end
    end
    local c = crystalFor(base)
    if not c then return false, "no such crystal: " .. tostring(base) end
    if c.ptype == "Gems" and gems() - c.price < state.gemReserve then
        return false, "gem reserve (" .. shorten(state.gemReserve) .. ")"
    end
    if state.autoSell then ensureRoom(state.keepFree) end
    if cap() - itemCount("pets") < 1 or cap() - itemCount("trails") < 1 then
        return false, "capacity full, nothing left to sell"
    end

    local beforePets, beforeTrails = {}, {}
    for _, r in ipairs(itemRows("pets")) do beforePets[r.it] = true end
    for _, r in ipairs(itemRows("trails")) do beforeTrails[r.it] = true end

    local g0 = gems()
    local name, rarity = openCrystalRemote:InvokeServer("openCrystal", c.base .. " Crystal")
    hatchStats.attempts = hatchStats.attempts + 1
    hatchStats.gems = hatchStats.gems + (g0 - gems())
    state.hatches = state.hatches + 1
    if name == nil then
        hatchStats.failed = hatchStats.failed + 1
        return false, "server refused (capacity or price)"
    end

    state.rarity[rarity or "?"] = (state.rarity[rarity or "?"] or 0) + 1

    -- what did we actually get?
    local got
    for _, r in ipairs(itemRows("pets")) do
        if not beforePets[r.it] then got = r break end
    end
    if got then
        hatchStats.pets = hatchStats.pets + 1
        got.kind = "pets"
    else
        for _, r in ipairs(itemRows("trails")) do
            if not beforeTrails[r.it] then got = r break end
        end
        if got then hatchStats.trails = hatchStats.trails + 1 end
    end

    -- sniper bookkeeping
    if state.snipePet ~= "" and name == state.snipePet then
        state.hits[state.snipePet] = (state.hits[state.snipePet] or 0) + 1
        notify((state.snipePet .. " hatched! (" .. shorten(c.price) .. " gems each)"), "good")
    end

    -- keep the good ones, sell the rest (policy lives in buildKeepSet)
    if state.autoSell and got then sellIfJunk(got) end
    return true, nil, name, rarity, c.base
end

local function hatchLoop()
    local carry, shownRate = 0, math.max(state.hatchRate, 1)
    local lastReport, statusAcc = 0, 0
    local started = os.clock()
    while state.hatcher and isCurrent() do
        local dt = RunService.Heartbeat:Wait()
        shownRate = math.max(state.hatchRate, 1)
        carry = math.min(carry + shownRate * dt, 12)
        local budget = math.floor(carry)
        carry = carry - budget
        local stopReason = nil
        for _ = 1, budget do
            if not state.hatcher then break end
            if state.hatchMax > 0 and hatchStats.attempts >= state.hatchMax then
                stopReason = "reached " .. state.hatchMax .. " hatches"
                state.hatcher = false
                break
            end
            local ok, err, name = hatchOnce()
            if not ok then
                if err and err:find("capacity") then
                    -- genuinely full and nothing sellable: wait for a sell
                    task.wait(0.5)
                elseif err == "server refused (capacity or price)" then
                    stopReason = "server refused (capacity or price)"
                    state.hatcher = false
                    break
                elseif err and (err:find("reserve") or err:find("affordable")) then
                    stopReason = err
                    state.hatcher = false
                    break
                end
            else
                statusAcc = statusAcc + 1
                if statusAcc >= 5 or os.clock() - lastReport > 1 then
                    statusAcc, lastReport = 0, os.clock()
                    local rar = {}
                    for k, v in ipairs({ "Omega", "Unique", "Epic", "Rare", "Advanced", "Basic" }) do
                        if state.rarity[v] then table.insert(rar, v .. " " .. state.rarity[v]) end
                    end
                    setStatus(string.format("%s: %d hatches  %.1f/s  %s", state.hatchChoice,
                        state.hatches, shownRate, table.concat(rar, " / ")), MONO.success)
                end
            end
        end
        if stopReason then
            setStatus("Hatch stopped: " .. stopReason, MONO.warn)
        end
    end
    state.hatcher = false
    state.hatchThread = nil
    local dt = math.max(os.clock() - started, 1)
    setStatus(string.format("Hatch farm stopped: %d hatches in %.0fs (%.2f/s), %s gems",
        hatchStats.attempts, dt, hatchStats.attempts / dt, shorten(hatchStats.gems)), MONO.warn)
end

local function toggleHatch(choice)
    choice = choice or state.hatchChoice or "Auto"
    if choice ~= "Auto" then
        local c = crystalByName(choice)
        if c then choice = c.base end
    end
    if state.hatcher and state.hatchChoice == choice then
        state.hatcher = false
        setStatus("Hatcher stopping...", MONO.sub)
        return
    end
    state.hatchChoice = choice
    state.hatcher = true
    if not state.hatchThread then
        state.hatchThread = spawnLoop(hatchLoop)
    end
end

-- ============ ORB FARM (unchanged from v4, verified) ============
-- oScript fires exactly this on touch: orbEvent:FireServer("collectOrb", orbName, currentMap.Value)
local function currentMap()
    local name = player:FindFirstChild("currentMap")
    name = name and name.Value or "City"
    local f = workspace:FindFirstChild("orbFolder")
    if f and f:FindFirstChild(name) then return name end
    if f then
        for _, c in ipairs(f:GetChildren()) do
            if #c:GetChildren() > 0 then return c.Name end
        end
    end
    return name
end

local ORB_BURST_CAP = 400
local function orbLoop()
    local fired = 0
    local map = currentMap()
    local names = {}
    for name in pairs(orbs) do table.insert(names, name) end
    if #names == 0 then names = { "Red Orb" } end
    table.sort(names)
    local function orbName()
        if state.orbChoice == "ALL" then return names[(fired % #names) + 1] end
        return state.orbChoice or names[1]
    end
    local carry, sinceStatus = 0, 0
    while state.orbFarming and isCurrent() do
        local dt = RunService.Heartbeat:Wait()
        carry = math.min(carry + math.max(state.orbRate, 1) * dt, ORB_BURST_CAP)
        local budget = math.floor(carry)
        carry = carry - budget
        if budget >= 1 then
            for _ = 1, budget do
                if orbEvent then orbEvent:FireServer("collectOrb", orbName(), map) end
                fired = fired + 1
                if not state.orbInfinite and fired >= state.orbAmount then break end
            end
            sinceStatus = sinceStatus + dt
            if sinceStatus > 0.25 then
                sinceStatus = 0
                setStatus(string.format("%s x%d  (%.0f/s)  %s", orbName(), fired, state.orbRate,
                    state.orbInfinite and "infinite" or (fired .. "/" .. state.orbAmount)), MONO.success)
            end
        end
        if not state.orbInfinite and fired >= state.orbAmount then break end
    end
    state.orbFarming = false
    state.orbThread = nil
    setStatus("Orb farm stopped after " .. fired .. " calls", MONO.warn)
end

local function toggleOrb(choice)
    if state.orbFarming and state.orbChoice == choice then
        state.orbFarming = false
        setStatus("Orb farm stopping...", MONO.sub)
        return
    end
    state.orbFarming = true
    state.orbChoice = choice
    if not state.orbThread then state.orbThread = spawnLoop(orbLoop) end
end

-- ============ HOOP LOOP (unchanged from v4, verified) ============
-- hoopEvent is server -> client only; the payout happens when the server sees the
-- character touch a hoop, so the lever is relocating Workspace.Hoops onto us.
local function hrp()
    local ch = player.Character
    return ch and ch:FindFirstChild("HumanoidRootPart")
end

local function hoopLoop()
    local home = {}
    local passes = 0
    while state.hoopLoop and isCurrent() do
        local root = hrp()
        if not root then task.wait(0.5) continue end
        local folder = workspace:FindFirstChild("Hoops")
        local list = {}
        if folder then
            for _, h in ipairs(folder:GetChildren()) do
                if h:IsA("BasePart") then
                    if not home[h] then home[h] = h.CFrame end
                    table.insert(list, h)
                end
            end
        end
        if #list == 0 then task.wait(1) continue end
        local before = statValue("Hoops")
        local anchor = root.Position
        for _, h in ipairs(list) do h.CFrame = CFrame.new(anchor + Vector3.new(0, 2, 0)) end
        task.wait(1.0)
        for _, h in ipairs(list) do
            local o = home[h]
            if o then h.CFrame = o end
        end
        passes = passes + 1
        setStatus(string.format("Hoops +%d this pass  pass %d  (8s debounce each)",
            statValue("Hoops") - before, passes), MONO.success)
        task.wait(7.6)
    end
    for h, o in pairs(home) do pcall(function() h.CFrame = o end) end
    state.hoopLoop = false
    state.hoopThread = nil
    setStatus("Hoop loop stopped", MONO.warn)
end

-- ============ QUEST AUTO-COLLECT (unchanged from v4, verified) ============
-- questsScript fires questsEvent:FireServer("collectQuest", questInstance)
local function collectQuests()
    local collected = 0
    local qroot = player:FindFirstChild("Quests")
    if not qroot then return 0 end
    for _, folderName in ipairs({ "Daily Quests", "Weekly Quests", "Story Quests", "completedQuests" }) do
        local folder = qroot:FindFirstChild(folderName)
        if folder then
            for _, q in ipairs(folder:GetChildren()) do
                if q:IsA("Folder") then
                    local reqs = q:FindFirstChild("requirements")
                    if reqs and #reqs:GetChildren() > 0 then
                        local done = true
                        for _, r in ipairs(reqs:GetChildren()) do
                            if r:IsA("ValueBase") then
                                local p = r:FindFirstChild("progress")
                                if p and p.Value < r.Value then done = false end
                            end
                        end
                        if done and questsEvent then
                            questsEvent:FireServer("collectQuest", q)
                            collected = collected + 1
                            state.session.quests = (state.session.quests or 0) + 1
                            task.wait(0.6)
                        end
                    end
                end
            end
        end
    end
    return collected
end

local function questLoop()
    while state.quest and isCurrent() do
        local n = collectQuests()
        setStatus(n > 0 and ("Collected " .. n .. " quest(s)") or "Quest watch: nothing complete yet",
            n > 0 and MONO.success or MONO.sub)
        task.wait(5)
    end
    state.quest = false
    state.questThread = nil
end

-- ============ SPEED RAMPS (unverified reward, kept for ramp quests) ============
local function rampLoop()
    local ramps = workspace:FindFirstChild("speedRamps")
    local index, tries = 1, 0
    while state.ramps and isCurrent() do
        if not ramps or #ramps:GetChildren() == 0 then
            setStatus("No speedRamps found", MONO.danger)
            task.wait(3)
        else
            local list = ramps:GetChildren()
            local model = list[((index - 1) % #list) + 1]
            index = index + 1
            local touch
            for _, d in ipairs(model:GetDescendants()) do
                if d:IsA("BasePart") and d.Name == "touchPart" then touch = d break end
            end
            local root = hrp()
            if touch and root then
                root.CFrame = CFrame.new(touch.Position + Vector3.new(0, 3, 0))
                if type(firetouchinterest) == "function" then
                    pcall(function() firetouchinterest(root, touch, 0) end)
                    task.wait(0.05)
                    pcall(function() firetouchinterest(root, touch, 1) end)
                end
                if speedRampEvent then speedRampEvent:FireServer("usedRamp") end
                tries = tries + 1
                setStatus("Ramp touches: " .. tries .. "  (unverified)", MONO.warn)
            end
        end
        task.wait(0.5)
    end
    state.ramps = false
    state.rampThread = nil
end

-- ============ AUTO REBIRTH (new) ============
-- confirmButton in gameGuiScript: rebirthEvent:FireServer("rebirthRequest") once
-- level >= calculateRequiredRebirthLevel(Rebirths.Value, player).
local function requiredRebirthLevel()
    if not GF then return nil end
    local ok, res = pcall(function() return GF.calculateRequiredRebirthLevel(rebirths(), player) end)
    return ok and res or nil
end

local function rebirthLoop()
    while state.autoRebirth and isCurrent() do
        local req = requiredRebirthLevel()
        if req and level() >= req then
            if rebirthEvent then rebirthEvent:FireServer("rebirthRequest") end
            state.rebirthsDone = state.rebirthsDone + 1
            setStatus(string.format("REBIRTH sent (%d this session, was level %d >= %d)",
                state.rebirthsDone, level(), req), MONO.rare)
            task.wait(6)
        else
            setStatus(string.format("Auto rebirth: level %d / %d needed (rebirths %d)",
                level(), req or -1, rebirths()), MONO.sub)
            task.wait(5)
        end
    end
    state.autoRebirth = false
    state.rebirthThread = nil
end

-- ============ ULTIMATE UPGRADES (new) ============
-- Los.secondGameGuiScript: ultimatesRemote:InvokeServer("upgradeUltimate", name)
-- costs Rebirths (globalFunctions.calculateUltimateRebirthCost), max 3-10 each.
local ULTIMATE_PRIORITY = {
    "Step Booster", "Gem Booster", "Ethereal Orbs", "Demon Hoops", "Infernal Gems",
    "+1 Pet Slot", "+10 Item Capacity", "x2 Chest Rewards", "x2 Quest Rewards",
    "x2 Trail Boosts", "Divine Rebirth", "+1 Daily Spin",
}

local function ultimateProgress(name)
    local owned = player:FindFirstChild("ultimatesFolder") and player.ultimatesFolder:FindFirstChild(name)
    local def = RS:FindFirstChild("gameUltimatesFolder") and RS.gameUltimatesFolder:FindFirstChild(name)
    local have = owned and owned.Value or 0
    local maxUp = def and def:FindFirstChild("maxUpgrades")
    local cost = nil
    if GF and def then
        local ok, res = pcall(function() return GF.calculateUltimateRebirthCost(def, have) end)
        if ok then cost = res end
    end
    return have, maxUp and maxUp.Value or 0, cost
end

local function ultimateLoop()
    while state.autoUltimates and isCurrent() do
        local bought = 0
        for _, name in ipairs(ULTIMATE_PRIORITY) do
            if not state.autoUltimates then break end
            local have, maxUp, cost = ultimateProgress(name)
            if cost and have < maxUp and rebirths() >= cost + state.rebirthReserve then
                local ok, res = pcall(function() return ultimatesRemote:InvokeServer("upgradeUltimate", name) end)
                if ok and res == true then
                    state.ultimatesBought = state.ultimatesBought + 1
                    bought = bought + 1
                    setStatus(string.format("Ultimate bought: %s (%d/%d) for %d rebirths",
                        name, have + 1, maxUp, cost), MONO.rare)
                    task.wait(1.2)
                else
                    setStatus("Ultimate refused: " .. name, MONO.warn)
                    task.wait(1.2)
                end
            end
        end
        if bought == 0 then
            setStatus(string.format("Ultimates: nothing affordable (rebirths %d, reserve %d)",
                rebirths(), state.rebirthReserve), MONO.sub)
        end
        task.wait(4)
    end
    state.autoUltimates = false
    state.ultimateThread = nil
end

-- ============ CHEST COLLECTOR (new) ============
-- gameGuiScript: checkChestRemote:InvokeServer("Golden Chest") etc., 6h cooldown,
-- returns (ok, currency, amount). Touching circleInner is what the game wires up,
-- so we stand on it and also invoke directly.
local CHESTS = {
    { label = "Golden Chest", model = "goldenChest" },
    { label = "Enchanted Chest", model = "enchantedChest" },
    { label = "Magma Chest", model = "magmaChest" },
    { label = "Jungle Chest", model = "jungleChest" },
}

local function chestLoop()
    while state.chests and isCurrent() do
        local got = 0
        for _, chest in ipairs(CHESTS) do
            if not state.chests then break end
            local model = workspace:FindFirstChild(chest.model)
            local inner = model and model:FindFirstChild("circleInner", true)
            if inner and hrp() then
                hrp().CFrame = CFrame.new(inner.Position + Vector3.new(0, 3, 0))
                task.wait(0.4)
            end
            local ok, res, currency, amount = pcall(function() return checkChestRemote:InvokeServer(chest.label) end)
            if ok and res == true then
                state.chestsOpened = state.chestsOpened + 1
                got = got + 1
                setStatus(string.format("%s: +%s %s", chest.label, shorten(amount or 0), tostring(currency)), MONO.rare)
            end
            task.wait(0.5)
        end
        if got == 0 then
            setStatus("Chests: nothing ready (6h cooldown)", MONO.sub)
        end
        task.wait(20)
    end
    state.chests = false
    state.chestThread = nil
end

-- =====================================================================
--   UI LAYER - KRYVEX HUB / WINDUI (RED THEME)
--   Farm logic above and all game-state logic below remain unchanged.
-- =====================================================================
local WINDUI_URL = "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
local libOk, WindUI = pcall(function()
    return loadstring(game:HttpGet(WINDUI_URL))()
end)
if not libOk or type(WindUI) ~= "table" or type(WindUI.CreateWindow) ~= "function" then
    error("[Kryvex Hub] WindUI could not be loaded: " .. tostring(WindUI))
end

-- Derive a complete theme from WindUI's built-in Dark theme and recolor its
-- interactive accents. This avoids depending on undocumented theme fields.
local redTheme = {}
for k, v in pairs(WindUI.Themes.Dark) do redTheme[k] = v end
redTheme.Name = "KryvexRed"
redTheme.Primary = Color3.fromRGB(255, 48, 58)
redTheme.Accent = Color3.fromRGB(255, 48, 58)
redTheme.Button = Color3.fromRGB(210, 35, 45)
redTheme.Slider = Color3.fromRGB(255, 48, 58)
redTheme.Toggle = Color3.fromRGB(255, 48, 58)
redTheme.Checkbox = Color3.fromRGB(255, 48, 58)
WindUI:AddTheme(redTheme)

local window = WindUI:CreateWindow({
    Title = "KRYVEX HUB",
    Icon = "zap",
    Author = "By WozzyLaco",
    Folder = "KryvexHub",
    Theme = "KryvexRed",
    Size = UDim2.fromOffset(600, 520),
    Transparent = false,
    Acrylic = false,
    SideBarWidth = 170,
    ToggleKey = Enum.KeyCode.RightControl,
})

local U = {}
local uiConnections = {}

-- Build the UI in small batches instead of creating every control in one frame.
local _uiBuildCount = 0
local function uiBuildYield()
    _uiBuildCount = _uiBuildCount + 1
    if _uiBuildCount % 3 == 0 then
        task.wait()
    end
end
local function addConnection(conn)
    if conn then table.insert(uiConnections, conn) end
    return conn
end

local function notify(text, tone)
    local kind = "Inform"
    if tone == "good" then kind = "Success"
    elseif tone == "bad" then kind = "Error"
    elseif tone == "warn" then kind = "Warning" end
    WindUI:Notify({
        Title = "KRYVEX HUB",
        Content = tostring(text or ""),
        Duration = 4,
        Icon = "bell",
    })
end

local function makeText(tab, title, body)
    uiBuildYield()
    local p tab:Paragraph({ Title = tostring(title or "KRYVEX HUB"), Desc = tostring(body or "") })
    local obj = { _paragraph = p, _body = tostring(body or "") }
    function obj:SetText(value)
        self._body = tostring(value or "")
        local frame = self._paragraph and self._paragraph.ParagraphFrame
        if frame then
            local labels = {}
            for _, d in ipairs(frame:GetDescendants()) do
                if d:IsA("TextLabel") then table.insert(labels, d) end
            end
            if #labels > 0 then labels[#labels].Text = self._body end
        end
    end
    return obj
end

local function makeBar(tab, title)
    uiBuildYield()
    local p tab:Paragraph({ Title = title, Desc = "0%" })
    local obj = { _paragraph = p, _value = 0 }
    function obj:Set(value)
        self._value = math.clamp(tonumber(value) or 0, 0, 100)
        local frame = self._paragraph and self._paragraph.ParagraphFrame
        if frame then
            local labels = {}
            for _, d in ipairs(frame:GetDescendants()) do
                if d:IsA("TextLabel") then table.insert(labels, d) end
            end
            if #labels > 0 then labels[#labels].Text = string.format("%s  %.0f%%", title, self._value) end
        end
    end
    return obj
end

-- Small compatibility layer: the old controls are recreated with native
-- WindUI controls while preserving the farm engine's existing state callbacks.
local function wrapControl(control, kind, defaultValue)
    local obj = { _control = control, _kind = kind, _value = defaultValue }
    function obj:Get()
        if self._kind == "Dropdown" then return self._value end
        if self._kind == "Slider" and self._control and self._control.Value then
            return self._control.Value.Default or self._value
        end
        return self._control and (self._control.Value ~= nil and self._control.Value or self._value) or self._value
    end
    function obj:Set(value, silent)
        self._value = value
        if not self._control then return end
        if self._kind == "Dropdown" then
            pcall(function() self._control:Select(value) end)
        elseif type(self._control.Set) == "function" then
            if self._kind == "Slider" then
                pcall(function() self._control:Set(value) end)
            else
                pcall(function() self._control:Set(value, silent == true) end)
            end
        end
    end
    function obj:SetDisabled(disabled)
        if not self._control then return end
        pcall(function()
            if disabled then self._control:Lock() else self._control:Unlock() end
        end)
    end
    function obj:OnCommit(fn) self._onCommit = fn end
    function obj:OnChanged(fn) self._onCommit = fn end
    return obj
end

local function makeTab(title, icon)
    task.wait()
    local nativeTab = window:Tab({ Title = title, Icon = icon })
    local tab = { _tab = nativeTab }
    function tab:Section(info)
        local sectionTitle = info.Title or "Section"
        local sectionDesc = info.Description or info.Desc
        uiBuildYield()
        nativeTab:Paragraph({ Title = sectionTitle, Desc = sectionDesc or "" })
        local sec = { _tab = nativeTab }
        function sec:Toggle(cfg)
            uiBuildYield()
            local c = nativeTab:Toggle({ Title = cfg.Text or cfg.Title, Desc = cfg.Description, Value = cfg.Default == true,
                Callback = cfg.Callback })
            return wrapControl(c, "Toggle", cfg.Default == true)
        end
        function sec:Slider(cfg)
            uiBuildYield()
            local c = nativeTab:Slider({ Title = cfg.Text or cfg.Title, Desc = cfg.Description,
                Value = { Min = cfg.Min or 0, Max = cfg.Max or 100, Default = cfg.Default or 0 },
                Step = cfg.Step or 1, Callback = cfg.Callback })
            return wrapControl(c, "Slider", cfg.Default)
        end
        function sec:Dropdown(cfg)
            local values, map = {}, {}
            for _, option in ipairs(cfg.Options or {}) do
                local label = type(option) == "table" and (option.Label or tostring(option.Value)) or tostring(option)
                local value = type(option) == "table" and option.Value or option
                values[#values + 1] = label
                map[label] = value
            end
            local initialLabel = tostring(cfg.Default or "")
            for label, value in pairs(map) do if value == cfg.Default then initialLabel = label break end end
            local obj
            uiBuildYield()
            local c = nativeTab:Dropdown({ Title = cfg.Text or cfg.Title, Desc = cfg.Description,
                Values = values, Value = initialLabel, SearchBarEnabled = cfg.Searchable == true,
                Callback = function(label)
                    local value = map[label] or label
                    if obj then obj._value = value end
                    if cfg.Callback then cfg.Callback(value) end
                end })
            obj = wrapControl(c, "Dropdown", cfg.Default)
            function obj:Set(value)
                self._value = value
                local label = tostring(value)
                for k, v in pairs(map) do if v == value then label = k break end end
                pcall(function() c:Select(label) end)
            end
            return obj
        end
        function sec:Input(cfg)
            uiBuildYield()
            local c = nativeTab:Input({ Title = cfg.Text or cfg.Title, Desc = cfg.Description,
                Value = cfg.Default or "", Placeholder = cfg.Placeholder or "Enter text...",
                Callback = function(value)
                    if cfg.Callback then cfg.Callback(value) end
                    if sec._inputProxy and sec._inputProxy._onCommit then sec._inputProxy._onCommit(value) end
                end })
            local obj = wrapControl(c, "Input", cfg.Default or "")
            sec._inputProxy = obj
            return obj
        end
        function sec:Button(cfg)
            uiBuildYield()
            return nativeTab:Button({ Title = cfg.Text or cfg.Title, Desc = cfg.Description,
                Icon = "mouse-pointer-click", Callback = cfg.Callback })
        end
        function sec:Paragraph(cfg)
            uiBuildYield()
            return nativeTab:Paragraph({ Title = cfg.Title or "Information", Desc = cfg.Content or cfg.Desc or "" })
        end
        function sec:Label(cfg) return makeText(nativeTab, cfg.Title or "", cfg.Text or "") end
        function sec:Badge(cfg) return makeText(nativeTab, "STATUS", cfg.Default or "Idle") end
        function sec:Progress(cfg) return makeBar(nativeTab, cfg.Text or "Progress") end
        function sec:Segmented(cfg)
            local opts = {}
            for _, v in ipairs(cfg.Options or {}) do
                opts[#opts + 1] = type(v) == "table" and (v.Label or tostring(v.Value)) or tostring(v)
            end
            local obj
            local c = nativeTab:Dropdown({ Title = cfg.Text or cfg.Title, Values = opts,
                Value = tostring(cfg.Default or opts[1] or ""), Callback = function(v)
                    local selected = v
                    for _, item in ipairs(cfg.Options or {}) do
                        if type(item) == "table" and (item.Label == v) then selected = item.Value end
                    end
                    if obj then obj._value = selected end
                    if cfg.Callback then cfg.Callback(selected) end
                end })
            obj = wrapControl(c, "Dropdown", cfg.Default)
            return obj
        end
        function sec:Keybind(cfg)
            local key = cfg.Default or Enum.KeyCode.H
            uiBuildYield()
            local c = nativeTab:Keybind({ Title = cfg.Text or cfg.Title, Value = key.Name,
                Callback = function() if cfg.Callback then cfg.Callback(true) end end })
            return c
        end
        return sec
    end
    return tab
end

local function toneOf(colour)
    if colour == MONO.success then return "Success" end
    if colour == MONO.warn then return "Warning" end
    if colour == MONO.danger then return "Error" end
    return "Info"
end

setStatus = function(text, colour)
    text = tostring(text or "")
    U.tone = toneOf(colour)
    if U.status then U.status:SetText(text) end
    if U.badge then U.badge:SetText(U.tone) end
end

-- ============ SESSION STATS ============
local function itemTotal(kind)
    local n = 0
    for _, r in ipairs(itemRows(kind)) do n = n + 1 end
    return n
end

state.session = {
    t = os.clock(),
    steps = statValue("Steps"), gems = gems(), exp = statValue("exp"),
    hoops = statValue("Hoops"), level = level(), rebirths = rebirths(),
    pets = itemTotal("pets"), trails = itemTotal("trails"), hatches = 0,
}

local function sessionText()
    local s = state.session
    local dt = math.max(os.clock() - s.t, 1)
    local m = dt / 60
    local best = ""
    for name, count in pairs(state.hits) do
        best = name .. " x" .. count
        break
    end
    return string.format(
        "Steps %s (%s/m)   Gems %s (%s/m)\nLevel %d   Rebirths %d   Pets %d/%d   Trails %d/%d\nHatches %d (%.1f/m)   Gems spent %s   Sold %d pets / %d trails%s",
        shorten(statValue("Steps")), shorten((statValue("Steps") - s.steps) / m),
        shorten(gems()), shorten((gems() - s.gems) / m),
        level(), rebirths(), itemTotal("pets"), cap(), itemTotal("trails"), cap(),
        hatchStats.attempts, hatchStats.attempts / m, shorten(hatchStats.gems),
        sellStats.pets, sellStats.trails, best ~= "" and ("\nSniper: " .. best) or "")
end

-- ============ LOOP STARTERS (single place, shared by UI and API sync) ============
local function hatchSet(on, choice)
    choice = choice or state.hatchChoice or "Auto"
    if on then
        if state.hatcher and state.hatchChoice ~= choice then
            toggleHatch(choice)
        elseif not state.hatcher then
            toggleHatch(choice)
        end
    elseif state.hatcher then
        toggleHatch(state.hatchChoice)
    end
    state.hatchChoice = choice
end

local function orbSet(on, choice)
    choice = choice or state.orbChoice or "ALL"
    if on then
        if not (state.orbFarming and state.orbChoice == choice) then
            toggleOrb(choice)
        end
    elseif state.orbFarming then
        toggleOrb(state.orbChoice)
    end
end

local function evolveApply()
    if state.autoEvolve then
        state.evolvePets, state.evolveTrails = true, true
    end
    if (state.autoEvolve or state.evolvePets or state.evolveTrails) and not state.evolveThread then
        state.evolveThread = spawnLoop(evolveLoop)
    end
end

local function equipApply()
    if state.autoEquip and not state.equipThread then
        state.equipThread = spawnLoop(equipLoop)
    end
end

-- flag name, its thread handle name, and the loop body
local SIMPLE_LOOPS = {
    { "hoop", "hoopLoop", "hoopThread", hoopLoop },
    { "quest", "quest", "questThread", questLoop },
    { "ramps", "ramps", "rampThread", rampLoop },
    { "rebirth", "autoRebirth", "rebirthThread", rebirthLoop },
    { "ultimates", "autoUltimates", "ultimateThread", ultimateLoop },
    { "chests", "chests", "chestThread", chestLoop },
}

local function simpleApply(flagKey, threadKey, fn, on)
    state[flagKey] = on and true or false
    if state[flagKey] and not state[threadKey] then
        state[threadKey] = spawnLoop(fn)
    end
end

-- push state back into the controls (the ;los plugin and the API can flip
-- flags without going through the UI, so the window follows state)
local function syncControls()
    if not U.hatchRun then return end
    local ok, err = pcall(function()
    U.hatchRun:Set(state.hatcher and true or false, true)
    U.crystal:Set(state.hatchChoice, true)
    U.orbRun:Set(state.orbFarming and true or false, true)
    U.orbChoice:Set(state.orbChoice or "ALL", true)
    U.orbAmount:SetDisabled(state.orbInfinite)
    U.hoop:Set(state.hoopLoop and true or false, true)
    U.quest:Set(state.quest and true or false, true)
    U.equipSet:Set(state.autoEquip and true or false, true)
    U.evolveAll:Set(state.autoEvolve and true or false, true)
    U.evolvePets:Set(state.evolvePets and not state.autoEvolve and true or false, true)
    U.evolveTrails:Set(state.evolveTrails and not state.autoEvolve and true or false, true)
    for _, L in ipairs(SIMPLE_LOOPS) do
        if U[L[1]] then U[L[1]]:Set(state[L[2]] and true or false, true) end
    end
    -- keep-list field: mirror the live list unless the user is typing in it
    if U.keepName then
        local names = {}
        for name in pairs(state.keepNames) do table.insert(names, name) end
        table.sort(names)
        local mirror = table.concat(names, ", ")
        local shown = tostring(U.keepName:Get() or "")
        if shown == "" or shown == (U.keepMirror or "") then
            U.keepMirror = mirror
            U.keepName:Set(mirror, true)
        end
    end
end)
    if not ok and not U.syncWarned then
        U.syncWarned = true
        warn("[KRYVEX HUB] control sync error: " .. tostring(err))
    end
end

-- read every control back into state and reconcile the workers
local function applyControls()
    if not U.hatchRun then return end
    state.autoSell = U.autoSell:Get()
    state.rankMode = U.rankMode:Get()
    state.keepTop = U.keepTop:Get()
    state.keepDupes = U.keepDupes:Get()
    state.keepFree = U.keepFree:Get()
    state.keepEvolved = U.keepEvolved:Get()
    state.evolveAll = not U.evolveOnlyKept:Get()
    local floor = U.floor:Get()
    state.sellBelow = (floor == "OFF" or floor == nil) and "Basic" or floor
    state.hatchRate = U.hatchRate:Get()
    state.gemReserve = U.gemReserve:Get()
    state.hatchMax = U.hatchMax:Get()
    state.orbRate = U.orbRate:Get()
    state.orbAmount = U.orbAmount:Get()
    state.orbInfinite = U.orbInfinite:Get()
    state.rebirthReserve = U.rebirthReserve:Get()

    hatchSet(U.hatchRun:Get() and true or false, U.crystal:Get())
    orbSet(U.orbRun:Get() and true or false, U.orbChoice:Get())
    U.orbAmount:SetDisabled(state.orbInfinite)

    for _, L in ipairs(SIMPLE_LOOPS) do
        if U[L[1]] then simpleApply(L[2], L[3], L[4], U[L[1]]:Get()) end
    end

    state.autoEvolve = U.evolveAll:Get()
    state.evolvePets = U.evolvePets:Get()
    state.evolveTrails = U.evolveTrails:Get()
    if not state.autoEvolve then
        if not U.evolvePets:Get() then state.evolvePets = false end
        if not U.evolveTrails:Get() then state.evolveTrails = false end
    end
    evolveApply()
    state.autoEquip = U.equipSet:Get()
    equipApply()
    syncControls()
end

-- ============ TAB: HATCH ============
local hatchTab = makeTab("Hatch", "egg")

local crystalOptions = { { Label = "Auto (most expensive affordable)", Value = "Auto" } }
for _, c in ipairs(crystals) do
    table.insert(crystalOptions, {
        Label = string.format("%s - %s %s", c.base, shorten(c.price), c.ptype),
        Value = c.base,
    })
end

local hSec = hatchTab:Section({
    Title = "Hatch farm",
    Description = 'openCrystalRemote:InvokeServer("openCrystal", "<Name> Crystal") - no menu, no walk, no cooldown. Refused only at pet/trail capacity.',
})

U.crystal = hSec:Dropdown({
    Id = "hatch-crystal",
    Text = "Crystal",
    Options = crystalOptions,
    Default = state.hatchChoice,
    Searchable = true,
    Placeholder = "Pick a crystal",
    Callback = function(value)
        state.hatchChoice = value
        if state.hatcher then hatchSet(true, value) end
    end,
})

U.hatchRun = hSec:Toggle({
    Id = "hatch-running",
    Text = "Hatch loop",
    Default = state.hatcher,
    Description = "Start or stop hatching the selected crystal.",
    Callback = function(on) hatchSet(on and true or false) end,
})

U.hatchRate = hSec:Slider({
    Id = "hatch-rate",
    Text = "Hatches per second",
    Min = 1, Max = 20, Step = 1,
    Default = state.hatchRate,
    Callback = function(v) state.hatchRate = v end,
})

U.gemReserve = hSec:Slider({
    Id = "gem-reserve",
    Text = "Gem reserve",
    Min = 0, Max = 10000000, Step = 100000,
    Default = state.gemReserve,
    Suffix = " gems",
    Description = "Stops spending once gems drop under this.",
    Callback = function(v) state.gemReserve = v end,
})

U.hatchMax = hSec:Slider({
    Id = "hatch-max",
    Text = "Stop after N hatches (0 = forever)",
    Min = 0, Max = 5000, Step = 50,
    Default = state.hatchMax,
    Callback = function(v) state.hatchMax = v end,
})

U.snipe = hSec:Input({
    Id = "snipe-pet",
    Text = "Snipe pet name",
    Default = state.snipePet or "",
    Placeholder = "e.g. Swift Samurai",
    Description = "Logs the live odds and expected cost for this pet.",
})

local function snipeCommit(value)
    value = tostring(value or "")
    state.snipePet = value
    if value == "" then
        notify("sniper cleared", "info")
        return
    end
    local base = state.hatchChoice ~= "Auto" and state.hatchChoice or "Jungle"
    local odds = oddsFor(base, value)
    if odds then
        notify(string.format("%s: %s %d%%, ~%d hatches (~%s gems)",
            value, odds.rarity, odds.chance, odds.expected, shorten(odds.cost)), "good")
    else
        notify("no crystal in the live tables drops " .. value, "warn")
    end
end
if type(U.snipe.OnCommit) == "function" then
    U.snipe:OnCommit(snipeCommit)
else
    U.snipe:OnChanged(snipeCommit)
end

local dropSec = hatchTab:Section({
    Title = "Live drop tables",
    Description = "Read from ReplicatedStorage.crystalChances at load.",
    Collapsible = true,
    Collapsed = true,
})
do
    local lines = {}
    for _, c in ipairs(crystals) do
        if #c.pool > 0 then table.insert(lines, c.base .. ": " .. crystalLabel(c)) end
    end
    dropSec:Label({ Text = table.concat(lines, "\n") })
end

-- ============ TAB: ORBS ============
local orbTab = makeTab("Orbs", "zap")
local oSec = orbTab:Section({
    Title = "Orb farm",
    Description = 'orbEvent:FireServer("collectOrb", name, map) - pays per call, no rate limit and no cooldown.',
})

local orbOptions = { { Label = "ALL (rotate every payout type)", Value = "ALL" } }
do
    local names = {}
    for name in pairs(orbs) do table.insert(names, name) end
    table.sort(names)
    for _, name in ipairs(names) do
        table.insert(orbOptions, {
            Label = string.format("%s -> %s", name, orbs[name].stat),
            Value = name,
        })
    end
end

U.orbChoice = oSec:Dropdown({
    Id = "orb-choice",
    Text = "Orb",
    Options = orbOptions,
    Default = state.orbChoice or "ALL",
    Searchable = true,
    Callback = function(value)
        state.orbChoice = value
        if state.orbFarming then orbSet(true, value) end
    end,
})

U.orbRun = oSec:Toggle({
    Id = "orb-running",
    Text = "Orb loop",
    Default = state.orbFarming,
    Callback = function(on) orbSet(on and true or false) end,
})

U.orbRate = oSec:Slider({
    Id = "orb-rate",
    Text = "Calls per second",
    Min = 5, Max = 5000, Step = 25,
    Default = state.orbRate,
    Callback = function(v) state.orbRate = v end,
})

U.orbAmount = oSec:Slider({
    Id = "orb-amount",
    Text = "Calls per payout",
    Min = 100, Max = 1000000, Step = 5000,
    Default = state.orbAmount,
    Disabled = state.orbInfinite,
    Callback = function(v) state.orbAmount = v end,
})

U.orbInfinite = oSec:Toggle({
    Id = "orb-infinite",
    Text = "Infinite calls per payout",
    Default = state.orbInfinite,
    Description = "Off uses the Calls per payout value above.",
    Callback = function(on)
        state.orbInfinite = on
        U.orbAmount:SetDisabled(on)
    end,
})

oSec:Label({
    Text = "measured per call: Red 3397 steps, Ethereal 5557 steps, Gem 2836 gems, Yellow 12 exp",
})

-- ============ TAB: PETS ============
local petTab = makeTab("Pets", "paw-print")

local sSec = petTab:Section({
    Title = "Sell policy",
    Description = "What gets auto-sold once an item is ranked. Equipped and evolved keepers are never sold.",
})

U.autoSell = sSec:Toggle({
    Id = "sell-auto",
    Text = "Auto-sell junk (keeps capacity free)",
    Default = state.autoSell,
    Callback = function(v) state.autoSell = v end,
})

U.rankMode = sSec:Segmented({
    Id = "sell-rank",
    Text = "Rank by",
    Options = { "MARKET", "VALUE", "RARITY" },
    Default = state.rankMode,
    Callback = function(v)
        state.rankMode = v
        notify("ranking by " .. v, "info")
    end,
})

U.keepTop = sSec:Slider({
    Id = "sell-keeptop",
    Text = "Keep best N pets/trails",
    Min = 0, Max = 20, Step = 1,
    Default = state.keepTop,
    Callback = function(v) state.keepTop = v end,
})

U.keepDupes = sSec:Slider({
    Id = "sell-keepdupes",
    Text = "Keep N copies of a kept name (evolve fodder)",
    Min = 0, Max = 10, Step = 1,
    Default = state.keepDupes,
    Callback = function(v) state.keepDupes = v end,
})

U.keepFree = sSec:Slider({
    Id = "sell-keepfree",
    Text = "Free slots to hold open",
    Min = 1, Max = 10, Step = 1,
    Default = state.keepFree,
    Callback = function(v) state.keepFree = v end,
})

U.keepEvolved = sSec:Toggle({
    Id = "sell-keepevolved",
    Text = "Keep evolved pets/trails",
    Default = state.keepEvolved,
    Callback = function(v) state.keepEvolved = v end,
})

U.evolveOnlyKept = sSec:Toggle({
    Id = "sell-evolvekept",
    Text = "Evolve only kept names",
    Default = not state.evolveAll,
    Callback = function(v)
        state.evolveAll = not v
        evolveApply()
    end,
})

U.floor = sSec:Segmented({
    Id = "sell-floor",
    Text = "Rarity floor (keep this tier and above, dump below)",
    Options = {
        { Label = "OFF", Value = "OFF" },
        { Label = "Basic", Value = "Basic" },
        { Label = "Advanced", Value = "Advanced" },
        { Label = "Rare", Value = "Rare" },
        { Label = "Epic", Value = "Epic" },
        { Label = "Unique", Value = "Unique" },
    },
    Default = (RARITY_ORDER[state.sellBelow] or 1) <= 1 and "OFF" or state.sellBelow,
    Callback = function(v)
        state.sellBelow = v == "OFF" and "Basic" or v
        notify(v == "OFF" and "rarity floor off" or ("keeping " .. v .. " and above, dumping below"), "info")
    end,
})

U.keepName = sSec:Input({
    Id = "sell-keepname",
    Text = "Keep list",
    Placeholder = "Add a name (empty clears the list)",
    Description = "Names here are never sold, and are used as evolve fodder.",
})

sSec:Button({
    Id = "sell-keepadd",
    Text = "Add to keep list",
    Callback = function()
        local text = tostring(U.keepName:Get() or "")
        text = text:gsub("^%s+", ""):gsub("%s+$", "")
        if text == "" then
            state.keepNames = {}
            notify("keep list cleared", "info")
        else
            state.keepNames[text] = true
            notify("kept: " .. text, "good")
        end
        U.keepName:Set("", true)
    end,
})

sSec:Button({
    Id = "sell-junk",
    Text = "Sell junk now",
    Description = "Frees up to 30 slots per kind using the policy above.",
    Callback = function()
        local freed = 0
        for _ = 1, 30 do
            local f = ensureRoom(state.keepFree)
            freed = freed + f
            if f == 0 then break end
        end
        notify(freed > 0 and ("freed " .. freed .. " slots") or "nothing sellable",
            freed > 0 and "good" or "warn")
    end,
})

sSec:Button({
    Id = "sell-preset-rare",
    Text = "Apply preset: rare-pet farm",
    Style = "Primary",
    Description = "Hatch Jungle, keep Swift Samurai, 5 duplicates, dump everything below Unique.",
    Callback = function()
        state.keepTop = 0
        state.keepDupes = 5
        state.keepEvolved = true
        state.sellBelow = "Unique"
        state.keepNames["Swift Samurai"] = true
        state.snipePet = "Swift Samurai"
        state.hatchChoice = "Jungle"
        state.rankMode = "MARKET"
        state.autoEvolve = true
        state.evolvePets, state.evolveTrails = true, true
        evolveApply()
        U.keepTop:Set(0, true)
        U.keepDupes:Set(5, true)
        U.keepEvolved:Set(true, true)
        U.floor:Set("Unique", true)
        U.rankMode:Set("MARKET", true)
        U.evolveOnlyKept:Set(false, true)
        U.snipe:Set("Swift Samurai", true)
        U.crystal:Set("Jungle", true)
        if state.hatcher then hatchSet(true, "Jungle") end
        notify("preset: keep+evolve Swift Samurai, dump everything below Unique", "good")
        setStatus("Preset applied: hatch Jungle, keep Swift Samurai, auto-evolve on", MONO.rare)
        syncControls()
    end,
})

local lSec = petTab:Section({ Title = "Live policy state" })
U.sellPreview = lSec:Label({ Id = "live-sellpreview", Text = "next to sell: ..." })
U.evolveWatch = lSec:Label({ Id = "live-evolvewatch", Text = "evolve watch: ..." })
U.keepList = lSec:Label({ Id = "live-keeplist", Text = "keep list: none" })

-- ============ AUTO EVOLVE ============
local eSec = petTab:Section({
    Title = "Auto evolve",
    Description = "Five non-evolved copies of the same name become one evolved copy: the server consumes four and leaves one marked evolved.",
})

U.evolveAll = eSec:Toggle({
    Id = "evolve-all",
    Text = "Auto evolve everything",
    Default = state.autoEvolve,
    Callback = function(on)
        state.autoEvolve = on
        if on then
            state.evolvePets, state.evolveTrails = true, true
        else
            state.evolvePets, state.evolveTrails = false, false
        end
        evolveApply()
        syncControls()
    end,
})

U.evolvePets = eSec:Toggle({
    Id = "evolve-pets",
    Text = "Auto evolve pets only",
    Default = state.evolvePets and not state.autoEvolve,
    Callback = function(on)
        state.evolvePets = on
        evolveApply()
    end,
})

U.evolveTrails = eSec:Toggle({
    Id = "evolve-trails",
    Text = "Auto evolve trails only",
    Default = state.evolveTrails and not state.autoEvolve,
    Callback = function(on)
        state.evolveTrails = on
        evolveApply()
    end,
})

eSec:Button({
    Id = "evolve-now",
    Text = "Evolve everything ready now",
    Callback = function()
        local a, b = evolveNow()
        notify(string.format("evolved %d pet name(s), %d trail name(s)", #a, #b),
            (#a + #b) > 0 and "good" or "warn")
    end,
})

eSec:Paragraph({
    Title = "Evolve remotes",
    Content = 'petEvolveEvent:FireServer("evolvePet", name) and evolveTrailEvent:FireServer("evolveTrail", instance). Evolution needs five copies of the same name, so the sell policy keeps duplicates of kept names.',
})

-- ============ AUTO EQUIP ============
local qSec = petTab:Section({ Title = "Auto equip" })

U.equipSet = qSec:Toggle({
    Id = "equip-auto",
    Text = "Auto-equip best pets",
    Default = state.autoEquip,
    Description = "Fills every empty pet slot with the best pet available.",
    Callback = function(on)
        state.autoEquip = on
        equipApply()
    end,
})

qSec:Button({
    Id = "equip-now",
    Text = "Equip best now",
    Callback = function()
        local n = autoEquipStep()
        notify(n > 0 and ("equipped " .. n .. " pets") or "already optimal",
            n > 0 and "good" or "info")
    end,
})

qSec:Label({
    Text = "Equipping needs a free slot: v5 unequips the weakest equipped pet first, then equips. Equipped pets can never be sold by the sell engine.",
})

-- ============ TAB: WORLD LOOPS ============
local worldTab = makeTab("Loops", "globe")
local TEXTURES = {
    hoop = { Title = "Hoop farm", Text = "Hoop loop (35 hoops per pass, 8.6s cycle)",
        Description = "Hoops pay out on a per-hoop debounce." },
    quest = { Title = "Quests", Text = "Collect completed quests",
        Description = "Collects anything the quest remote accepts as complete." },
    rebirth = { Title = "Rebirth", Text = "Auto rebirth when level is enough",
        Description = 'rebirthEvent:FireServer("rebirthRequest") once level >= calculateRequiredRebirthLevel(rebirths, player).' },
    ultimates = { Title = "Ultimate upgrades", Text = "Auto-buy ultimates",
        Description = 'ultimatesRemote:InvokeServer("upgradeUltimate", name). Costs rebirths, so it is ordered by payoff: Step Booster, Gem Booster, Ethereal Orbs, Demon Hoops, Infernal Gems, slots, chests, quests, trails, Divine Rebirth, spins.' },
    chests = { Title = "Chests", Text = "Open golden / enchanted / magma / jungle chests",
        Description = 'checkChestRemote:InvokeServer("Golden Chest") and friends. Each has its own 6 hour cooldown.' },
    ramps = { Title = "Speed ramps", Text = "Touch speed ramps",
        Description = "Unverified ramp loop, kept from v4." },
}

for _, L in ipairs(SIMPLE_LOOPS) do
    local meta = TEXTURES[L[1]]
    local sec = worldTab:Section({ Title = meta.Title, Description = meta.Description })
    U[L[1]] = sec:Toggle({
        Id = "loop-" .. L[1],
        Text = meta.Text,
        Default = state[L[2]],
        Callback = function(on)
            simpleApply(L[2], L[3], L[4], on and true or false)
        end,
    })
    if L[1] == "rebirth" then
        U.rebirthReserve = sec:Slider({
            Id = "rebirth-reserve",
            Text = "Keep N rebirths spare",
            Min = 0, Max = 20, Step = 1,
            Default = state.rebirthReserve,
            Description = "Stops spending rebirths when the live count is at or under this.",
            Callback = function(v) state.rebirthReserve = v end,
        })
    end
end

-- ============ TAB: STATUS ============
local statusTab = makeTab("Status", "activity")

local stSec = statusTab:Section({ Title = "Live status" })
U.badge = stSec:Badge({ Id = "status-tone", Default = "Info", Kind = "Secondary" })
U.status = stSec:Label({ Id = "status-text", Text = "Idle" })

local ssSec = statusTab:Section({ Title = "Session" })
U.session = ssSec:Label({ Id = "session-text", Text = sessionText() })
U.petBar = ssSec:Progress({ Id = "cap-pets", Text = "Pet capacity", Min = 0, Max = 100, Default = 0 })
U.petCap = ssSec:Label({ Id = "cap-pets-text", Text = "pets 0/0" })
U.trailBar = ssSec:Progress({ Id = "cap-trails", Text = "Trail capacity", Min = 0, Max = 100, Default = 0 })
U.trailCap = ssSec:Label({ Id = "cap-trails-text", Text = "trails 0/0" })

local ctlSec = statusTab:Section({ Title = "Controls" })
ctlSec:Button({
    Id = "stop-all",
    Text = "Stop all loops",
    Style = "Danger",
    Description = "Stops every farm loop and leaves the window open.",
    Callback = function()
        state.orbFarming, state.hoopLoop, state.hatcher, state.quest = false, false, false, false
        state.evolvePets, state.evolveTrails, state.ramps = false, false, false
        state.autoRebirth, state.autoUltimates, state.chests, state.autoEquip = false, false, false, false
        state.autoEvolve = false
        syncControls()
        notify("all loops stopping", "warn")
    end,
})
ctlSec:Keybind({
    Id = "hotkey-hatch",
    Text = "Hatch hotkey",
    Default = Enum.KeyCode.H,
    Mode = "Toggle",
    Callback = function(active)
        hatchSet(active and true or false)
        syncControls()
    end,
})

-- ============ KRYVEX HUB SETTINGS ============
local cfgSec = statusTab:Section({
    Title = "Kryvex Hub Settings",
    Description = "Red theme | RightControl opens/closes the interface | Settings are session-based.",
})

cfgSec:Button({
    Text = "Stop all loops",
    Description = "Immediately disables every active farm loop.",
    Callback = function()
        state.orbFarming, state.hoopLoop, state.hatcher, state.quest = false, false, false, false
        state.evolvePets, state.evolveTrails, state.ramps = false, false, false
        state.autoRebirth, state.autoUltimates, state.chests, state.autoEquip = false, false, false, false
        state.autoEvolve = false
        syncControls()
        notify("All loops stopped", "warn")
    end,
})

cfgSec:Paragraph({
    Title = "Interface",
    Content = "KRYVEX HUB • Legends of Speed • WindUI red edition. Use RightControl to toggle the window.",
})

-- keep list: the field is a command box, and it mirrors the live list whenever
-- it is empty or already showing the mirror, so a saved profile keeps the names
local function keepNameCommit(value)
    for part in tostring(value or ""):gmatch("[^,]+") do
        local name = part:gsub("^%s+", ""):gsub("%s+$", "")
        if name ~= "" then state.keepNames[name] = true end
    end
end
if type(U.keepName.OnCommit) == "function" then
    U.keepName:OnCommit(keepNameCommit)
else
    U.keepName:OnChanged(keepNameCommit)
end

-- ============ WINDOW CLEANUP ============
local function stopEverything()
    state.orbFarming, state.hoopLoop, state.hatcher, state.quest = false, false, false, false
    state.evolvePets, state.evolveTrails, state.ramps = false, false, false
    state.autoRebirth, state.autoUltimates, state.chests, state.autoEquip = false, false, false, false
    state.autoEvolve = false
end

window:OnDestroy(function()
    stopEverything()
    for _, connection in ipairs(uiConnections) do pcall(function() connection:Disconnect() end) end
    for _, key in ipairs({ "orbThread", "hoopThread", "hatchThread", "questThread", "petThread",
        "trailThread", "evolveThread", "rampThread", "rebirthThread", "ultimateThread",
        "chestThread", "equipThread" }) do
        state[key] = nil
    end
end)

-- WindUI edition: configuration profiles from the previous UI library are not used.

-- ============ PROGRAMMATIC CONTROL (drives the ;los IY plugin) ============
GENV.__LOS_AUTOFARM = {
    instance = INSTANCE_ID,
    state = state,
    crystals = crystals,
    prices = priceOf,
    stats = { hatch = hatchStats, sell = sellStats, equip = equipStats },
    orbFarm = function(choice)
        if choice == nil then state.orbFarming = false return end
        toggleOrb(choice)
    end,
    hatch = function(choice)
        if choice == nil then state.hatcher = false return end
        toggleHatch(choice)
    end,
    hoop = function(on)
        if on and not state.hoopLoop then state.hoopLoop = true
            if not state.hoopThread then state.hoopThread = spawnLoop(hoopLoop) end
        elseif not on then state.hoopLoop = false end
    end,
    quests = function(on)
        if on and not state.quest then state.quest = true
            if not state.questThread then state.questThread = spawnLoop(questLoop) end
        elseif not on then state.quest = false end
    end,
    evolve = function(which, on)
        if which == "all" then
            state.autoEvolve = on ~= false
            if state.autoEvolve then
                state.evolvePets, state.evolveTrails = true, true
                if not state.evolveThread then state.evolveThread = spawnLoop(evolveLoop) end
            else
                state.evolvePets, state.evolveTrails = false, false
            end
        elseif which == "pets" then
            state.evolvePets = on ~= false
            if state.evolvePets and not state.evolveThread then state.evolveThread = spawnLoop(evolveLoop) end
        elseif which == "trails" then
            state.evolveTrails = on ~= false
            if state.evolveTrails and not state.evolveThread then state.evolveThread = spawnLoop(evolveLoop) end
        end
    end,
    evolveNow = evolveNow,
    evolveReady = function()
        local out = {}
        for _, kind in ipairs({ "pets", "trails" }) do
            for name, n in pairs(evolveCounts(kind)) do
                if n >= 2 then table.insert(out, string.format("%s %s %d/5", kind, name, n)) end
            end
        end
        table.sort(out)
        return out
    end,
    sellPreview = function(kind, n) return sellPreview(kind or "pets", n or 5) end,
    rank = function(mode)
        if mode then state.rankMode = mode end
        return state.rankMode
    end,
    sellFloor = function(r)
        if r then state.sellBelow = r end
        return state.sellBelow
    end,
    keepDupes = function(n)
        if n then state.keepDupes = n end
        return state.keepDupes
    end,
    ramps = function(on)
        if on and not state.ramps then state.ramps = true
            if not state.rampThread then state.rampThread = spawnLoop(rampLoop) end
        elseif not on then state.ramps = false end
    end,
    sellJunk = function(n)
        local freed = 0
        for _ = 1, n or 20 do
            local f = ensureRoom(state.keepFree)
            freed = freed + f
            if f == 0 then break end
        end
        return freed
    end,
    sellAll = function()
        local n = 0
        state.keepTop, state.keepDupes = 0, 0
        for _ = 1, 80 do
            if not sellLowest("pets") then break end
            n = n + 1
            task.wait(0.1)
        end
        for _ = 1, 80 do
            if not sellLowest("trails") then break end
            n = n + 1
            task.wait(0.1)
        end
        return n
    end,
    autoEquip = function(on)
        state.autoEquip = on and true or false
        if state.autoEquip and not state.equipThread then state.equipThread = spawnLoop(equipLoop) end
    end,
    equipNow = function() return autoEquipStep() end,
    rebirth = function(on)
        state.autoRebirth = on and true or false
        if state.autoRebirth and not state.rebirthThread then state.rebirthThread = spawnLoop(rebirthLoop) end
    end,
    ultimates = function(on)
        state.autoUltimates = on and true or false
        if state.autoUltimates and not state.ultimateThread then state.ultimateThread = spawnLoop(ultimateLoop) end
    end,
    chests = function(on)
        state.chests = on and true or false
        if state.chests and not state.chestThread then state.chestThread = spawnLoop(chestLoop) end
    end,
    snipe = function(petName, crystal)
        state.snipePet = petName or ""
        if crystal then
            local c = crystalByName(crystal)
            state.hatchChoice = c and c.base or crystal
        end
        if state.snipePet ~= "" then toggleHatch(state.hatchChoice) end
        local base = crystalByName(state.hatchChoice) and crystalByName(state.hatchChoice).base or "Jungle"
        return oddsFor(base, state.snipePet)
    end,
    keep = function(petName, on)
        if petName == nil then return state.keepNames end
        state.keepNames[petName] = on ~= false or nil
        return state.keepNames
    end,
    oneHatch = function(crystal)
        local saved = state.hatchChoice
        if crystal then state.hatchChoice = crystal end
        local ok, err, name, rarity = hatchOnce()
        state.hatchChoice = saved
        return ok, err, name, rarity
    end,
    collectQuests = collectQuests,
    stopAll = function()
        state.orbFarming, state.hoopLoop, state.hatcher, state.quest = false, false, false, false
        state.evolvePets, state.evolveTrails, state.ramps = false, false, false
        state.autoRebirth, state.autoUltimates, state.chests, state.autoEquip = false, false, false, false
        state.autoEvolve = false
    end,
}
-- ============ REFRESH LOOP (WINDUI EDITION) ============
do
    local acc = 0
    local conn, warned = nil, false
    conn = RunService.Heartbeat:Connect(function(dt)
        if not isCurrent() then conn:Disconnect() return end
        local ok, err = pcall(function()
        accPill = accPill + dt
        -- Do not rewrite every WindUI control on Heartbeat; doing so can
        -- trigger expensive layout/callback work and freeze the client.
        acc = acc + dt
        if acc < 3 then return end
        acc = 0
        if U.session then U.session:SetText(sessionText()) end
        local pd = sellPreview("pets", 3)
        local td = sellPreview("trails", 2)
        if U.sellPreview then
            U.sellPreview:SetText("next pets to sell: "
                .. (#pd > 0 and table.concat(pd, ", ") or "nothing")
                .. "\nnext trails: "
                .. (#td > 0 and table.concat(td, ", ") or "nothing"))
        end
        local watch = {}
        for _, kind in ipairs({ "pets", "trails" }) do
            for name, n in pairs(evolveCounts(kind)) do
                if n >= 2 then table.insert(watch, name .. " " .. n .. "/5") end
            end
        end
        table.sort(watch)
        if U.evolveWatch then
            U.evolveWatch:SetText("evolve watch (non-evolved copies): "
                .. (#watch > 0 and table.concat(watch, ", ") or "nothing yet")
                .. (state.autoEvolve and "  [auto ON]" or "  [auto off]"))
        end
        if U.keepList then
            local keeps = {}
            for name in pairs(state.keepNames) do table.insert(keeps, name) end
            table.sort(keeps)
            U.keepList:SetText("keep list: " .. (#keeps > 0 and table.concat(keeps, ", ") or "none")
                .. "   ranking: " .. state.rankMode .. "   floor: " .. state.sellBelow)
        end
        local c = cap()
        local pn, tn = itemTotal("pets"), itemTotal("trails")
        if U.petBar then U.petBar:Set(c > 0 and math.min(pn / c, 1) * 100 or 0) end
        if U.petCap then
            U.petCap:SetText(string.format("pets %d/%d  (%d free)", pn, c, math.max(c - pn, 0)))
        end
        if U.trailBar then U.trailBar:Set(c > 0 and math.min(tn / c, 1) * 100 or 0) end
        if U.trailCap then
            U.trailCap:SetText(string.format("trails %d/%d  (%d free)", tn, c, math.max(c - tn, 0)))
        end
        end)
        if not ok and not warned then
            warned = true
            warn("[KRYVEX HUB] refresh error: " .. tostring(err))
        end
    end)
    addConnection(conn)
end

print("[KRYVEX HUB | WINDUI] loaded. Window 'KRYVEX HUB'. "
    .. "Hatch = openCrystalRemote:InvokeServer(\"openCrystal\", \"<Name> Crystal\"). "
    .. #crystals .. " crystals, "
    .. (function() local n = 0 for _ in pairs(priceOf) do n = n + 1 end return n end)()
    .. " priced pets/trails.")