-- _G.Key = "KEYLESS"
do
  local _tok = "vtok_24b613c3064ad3d53e3ef4c86a690338884e5f091ce0a494"
  local _ver = "v1.0.5"
  local _lp = game:GetService("Players").LocalPlayer
  local _uid = _lp and tostring(_lp.UserId) or "0"
  local _uname = _lp and tostring(_lp.Name) or "Unknown"
  local _pid = tostring(game.PlaceId)
  local _exec = "Unknown"
  pcall(function()
    if identifyexecutor then _exec = tostring(identifyexecutor())
    elseif getexecutorname then _exec = tostring(getexecutorname()) end
  end)

  local _hs = game:GetService("HttpService")
  local _url = "https://api.valincsyndicate.com/v1/tokens/verify?token=" .. _tok
    .. "&version=" .. _hs:UrlEncode(_ver)
    .. "&roblox_id=" .. _hs:UrlEncode(_uid)
    .. "&roblox_username=" .. _hs:UrlEncode(_uname)
    .. "&place_id=" .. _hs:UrlEncode(_pid)
    .. "&executor=" .. _hs:UrlEncode(_exec)

  local _ok, _res = pcall(function() return game:HttpGet(_url) end)
  if not _ok or _res:find("REVOKED") then
    error("[VALINC Security] Protection fault: Token is revoked or invalid. Execution terminated.")
  elseif _res:find("OUTDATED") then
    local _latest = _res:match("OUTDATED:(.+)") or "newer"
    warn("[VALINC Security] WARNING: You are running an outdated version of this script (" .. _ver .. "). Latest is " .. _latest .. ". Please update from VALINC Syndicate!")
  end
end

_G.__sae_generation = (_G.__sae_generation or 0) + 1
local CURRENT_GEN: number = _G.__sae_generation

local function alive(): boolean
    return _G.__sae_generation == CURRENT_GEN
end

local State: any
local Features: any = {}
local LocomotionController: any
local PlotAdapter: any
local DataAdapter: any
local NetworkGateway: any
local SecureHttpGet: (string) -> (boolean, string)
local MountUI: () -> ()
local StartWorkers: () -> ()

if typeof(_G.StealAnEggCleanup) == "function" then
    pcall(_G.StealAnEggCleanup)
    _G.StealAnEggCleanup = nil
end
local cleanupKey = "__sae_active_cleanup"
if typeof(_G[cleanupKey]) == "function" then
    pcall(_G[cleanupKey])
    _G[cleanupKey] = nil
end

type JanitorTask = (() -> ()) | RBXScriptConnection | Instance | { Destroy: (any) -> () } | { Disconnect: (any) -> () }

local RootJanitor = {
    _tasks = {} :: { JanitorTask }
}

function RootJanitor:Add(task: JanitorTask)
    table.insert(self._tasks, task)
    return task
end

function RootJanitor:SafeConnect(signal: any, callback: (...any) -> ()): RBXScriptConnection?
    if not signal or typeof(signal) ~= "RBXScriptSignal" then
        return nil
    end
    local ok, conn = pcall(function()
        return signal:Connect(callback)
    end)
    if ok and conn then
        self:Add(conn)
        return conn
    end
    return nil
end

function RootJanitor:TrackInstance(instance: Instance?)
    if instance and typeof(instance) == "Instance" then
        self:Add(instance)
    end
    return instance
end

function RootJanitor:Cleanup()
    for _, task in ipairs(self._tasks) do
        pcall(function()
            if typeof(task) == "function" then
                task()
            elseif typeof(task) == "RBXScriptConnection" then
                task:Disconnect()
            elseif typeof(task) == "Instance" then
                task:Destroy()
            elseif typeof(task) == "table" then
                if type((task :: any).Destroy) == "function" then
                    (task :: any):Destroy()
                elseif type((task :: any).Disconnect) == "function" then
                    (task :: any):Disconnect()
                end
            end
        end)
    end
    table.clear(self._tasks)
end

local function rootCleanup()
    if type(State) == "table" and type(State.Reset) == "function" then
        State.Reset()
    end
    pcall(function()
        if LocomotionController and typeof(LocomotionController.ApplyStealProtection) == "function" then
            LocomotionController:ApplyStealProtection(false)
        end
        if LocomotionController and typeof(LocomotionController.StopMovement) == "function" then
            LocomotionController:StopMovement()
        end
    end)
    RootJanitor:Cleanup()
    _G[cleanupKey] = nil
    _G.StealAnEggCleanup = nil
    _G.StealAnEggScriptActive = false
end

_G[cleanupKey] = rootCleanup
_G.StealAnEggCleanup = rootCleanup
_G.StealAnEggScriptActive = true

local function spawnWorker(name: string, interval: number, workerFn: () -> ())
    task.spawn(function()
        while alive() do
            local ok, err = pcall(workerFn)
            if not ok and err then
                warn("[Worker Error: " .. name .. "]", err)
            end
            if not alive() then break end
            task.wait(interval)
        end
    end)
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local GameContext = {
    EXPECTED_PLACE_ID = 107778070777162,

    Players = Players,
    ReplicatedStorage = ReplicatedStorage,
    RunService = RunService,
    Lighting = Lighting,
    Workspace = Workspace,
    TeleportService = TeleportService,
    StarterGui = StarterGui,
    CoreGui = CoreGui,
    LocalPlayer = LocalPlayer,

    Remotes = nil :: any,
    Save = nil :: any,
    AssetsDirectory = nil :: any,
    TrailsDirectory = nil :: any,
    TreadmillsDirectory = nil :: any,
    BasesDirectory = nil :: any,
    AreaEggSlotIdentity = nil :: any,
    AreaEggResetWall = nil :: any,
    AreaEggCycle = nil :: any,
    PlacedEggRenderer = nil :: any,
    PlacedEggGrowthPresentationPolicy = nil :: any,
    PlotState = nil :: any,
    EggState = nil :: any,
    Window = nil :: any,
}

function GameContext:Validate(): boolean
    if game.PlaceId ~= self.EXPECTED_PLACE_ID then
        pcall(function()
            self.StarterGui:SetCore("SendNotification", {
                Title = "VALINC SYNDICATE",
                Text = "Unauthorized Game! This script only supports Steal An Egg 🥚",
                Duration = 7
            })
        end)
        return false
    end
    return true
end

local MODULE_PATH_ALIASES: { [string]: { string } } = {
    ["Assets"]         = {"Data", "Assets"},
    ["Network"]        = {"Packages", "Networking"},
    ["Networking"]     = {"Packages", "Networking"},
    ["Remotes"]        = {"Shared", "Remotes"},
    ["Trails"]         = {"Data", "Trails"},
    ["Treadmills"]     = {"Data", "Treadmills"},
    ["Bases"]          = {"Data", "Bases"},
    ["Gears"]          = {"Data", "Gears"},
    ["Areas"]          = {"Data", "Areas"},
    ["Rarity"]         = {"Data", "Rarity"},
    ["SettingsCmds"]   = {"Shared", "SettingsCmds"},
    ["Save"]           = {"Shared", "Save"},
    ["EggState"]       = {"Client", "EggState"},
    ["PlotState"]      = {"Client", "PlotState"},
}

function GameContext:RequireModule(name: string): any?
    if MODULE_PATH_ALIASES[name] then
        local node: any = self.ReplicatedStorage
        for _, step in ipairs(MODULE_PATH_ALIASES[name]) do
            node = node and node:FindFirstChild(step)
        end
        if node and node:IsA("ModuleScript") then
            local ok, res = pcall(require, node)
            if ok and res then return res end
        end
    end

    local mod = self.ReplicatedStorage:FindFirstChild(name, true)
    if mod and mod:IsA("ModuleScript") then
        local ok, res = pcall(require, mod)
        if ok and res then return res end
    end
    return nil
end

function GameContext:EnsureModules(): boolean
    if self.Remotes and self.Remotes.EggWorld and self.Save and self.AssetsDirectory then
        return true
    end

    pcall(function()
        local sharedFolder = self.ReplicatedStorage:WaitForChild("Shared", 8)
        local dataFolder = self.ReplicatedStorage:WaitForChild("Data", 8)
        local clientFolder = self.ReplicatedStorage:WaitForChild("Client", 8)

        if sharedFolder:FindFirstChild("Remotes") then
            self.Remotes = require(sharedFolder.Remotes)
        end
        if sharedFolder:FindFirstChild("Save") then
            self.Save = require(sharedFolder.Save)
        end
        if dataFolder:FindFirstChild("Assets") then
            self.AssetsDirectory = require(dataFolder.Assets)
        end
        if dataFolder:FindFirstChild("Trails") then
            self.TrailsDirectory = require(dataFolder.Trails)
        end
        if dataFolder:FindFirstChild("Treadmills") then
            self.TreadmillsDirectory = require(dataFolder.Treadmills)
        end
        if dataFolder:FindFirstChild("Bases") then
            self.BasesDirectory = require(dataFolder.Bases)
        end

        local utilFolder = sharedFolder:FindFirstChild("Util")
        if utilFolder then
            if utilFolder:FindFirstChild("AreaEggSlotIdentity") then
                self.AreaEggSlotIdentity = require(utilFolder.AreaEggSlotIdentity)
            end
            if utilFolder:FindFirstChild("AreaEggCycle") then
                self.AreaEggCycle = require(utilFolder.AreaEggCycle)
            end
        end

        if clientFolder:FindFirstChild("AreaEggResetWall") then
            self.AreaEggResetWall = require(clientFolder.AreaEggResetWall)
        end
        if clientFolder:FindFirstChild("PlotState") then
            self.PlotState = require(clientFolder.PlotState)
        end
        if clientFolder:FindFirstChild("EggState") then
            self.EggState = require(clientFolder.EggState)
        end
    end)

    if not self.Remotes then
        pcall(function()
            local lib = self.ReplicatedStorage:FindFirstChild("Library")
            local dir = self.ReplicatedStorage:FindFirstChild("Directory")
            if lib and dir then
                self.Save = require(lib.Client.Save)
                self.AssetsDirectory = require(dir.Assets)
                self.TrailsDirectory = require(dir.Trails)
                self.TreadmillsDirectory = require(dir.Treadmills)
                self.BasesDirectory = require(dir.Bases)
                self.AreaEggSlotIdentity = require(lib.Util.AreaEggSlotIdentity)
                self.AreaEggResetWall = require(lib.Client.AreaEggResetWall)
                self.PlacedEggRenderer = require(lib.Client.Eggs.PlacedEggRenderer)
                self.PlacedEggGrowthPresentationPolicy = require(lib.Client.Eggs.PlacedEggGrowthPresentationPolicy)
            end
        end)
    end

    return self.Remotes ~= nil and self.Remotes.EggWorld ~= nil
end

function SecureHttpGet(targetUrl: string): (boolean, string)
    local ok, res = pcall(game.HttpGet, game, targetUrl)
    if ok and typeof(res) == "string" and #res > 0 then
        return true, res
    end
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if req then
        local ok2, res2 = pcall(req, { Url = targetUrl, Method = "GET" })
        if ok2 and typeof(res2) == "table" and res2.Body and typeof(res2.Body) == "string" and #res2.Body > 0 then
            return true, res2.Body
        end
    end
    return false, ""
end

local DEFAULT_AREAS = {
    "Cosmic", "Cherry Blossom", "Titan Temple"
}

local DEFAULT_RARITIES = {
    "Common", "Uncommon", "Rare", "SuperRare", "Epic", "Legendary",
    "Mythic", "Rainbow", "Celestial", "Exotic", "Secret", "Cosmic",
    "Exclusive", "Limited", "Eternal", "Superior", "Divine", "Titan", "BrainrotGod"
}

local DEFAULT_MUTATIONS = {
    "Normal", "Silver", "Golden", "Rainbow", "Bloom", "Spirit Bloom"
}

local DEFAULT_SELL_RARITIES = { "Common", "Uncommon", "Rare" }
local DEFAULT_SELL_EGG_RARITIES = { "Common", "Uncommon", "Rare" }

local AREA_TIER_RANK: { [string]: number } = {
    Forest = 1,
    Lake = 2,
    Desert = 3,
    Jungle = 4,
    Snow = 5,
    Volcano = 6,
    ["Abyss Ocean"] = 7,
    Prehistoric = 8,
    Cosmic = 9,
    ["Cherry Blossom"] = 10,
    ["Titan Temple"] = 11,
}

local RARITY_TIER_RANK: { [string]: number } = {
    Common = 1,
    Basic = 1,
    Uncommon = 2,
    Rare = 3,
    SuperRare = 4,
    Epic = 5,
    Legendary = 6,
    Mythic = 7,
    Mythical = 7,
    Rainbow = 8,
    Prismatic = 8,
    Celestial = 9,
    Exotic = 10,
    Secret = 11,
    Cosmic = 12,
    Exclusive = 13,
    Admin = 13,
    Limited = 14,
    Eternal = 15,
    Superior = 16,
    Transcendent = 16,
    Divine = 17,
    Titan = 18,
    BrainrotGod = 19,
    ["Squishy God"] = 19,
}

local CDN_UI_URL = "https://cdn.vinzhub.com/scripts/Liblery%20Ui/VALINC-QUARTZ/51682b2d83dd6e0a7aa24ebb4713d755/ba5ddf0396398532a2244941aa2445885a9add10038ad8b9.lua"

local _SCRIPT_VERSION = "1.0.5"

local SCRIPT_CONFIG = {
    Title = "VALINC SYNDICATE",
    Subtitle = "Steal An Egg v" .. _SCRIPT_VERSION,
    Logo = "rbxassetid://107101390544126",
    ToggleKey = Enum.KeyCode.RightControl,
    ConfigFolder = "steal_an_egg_config"
}

local GLIDE_MAX_STEP = 6.5
local GLIDE_ROLLBACK_TOLERANCE = 22
local GLIDE_MAX_ROLLBACKS = 8

local SAFEZONE_POSITION = { X = 525.0, Y = 70.5, Z_BASE = -364.5 }
local CORRIDOR_BOUNDS = { Z_MIN = -415, Z_MAX = -315 }
local GATE_EXIT_X = 560.0
local ARENA_BOUNDS = { X = { 450, 5500 }, Y = { -30, 300 }, Z = { -600, -100 } }

local CARRY_REMOTE_THROTTLE = 0.2
local CLAIM_ATTEMPT_TIMEOUT = 1.5
local FAILED_EGG_COOLDOWN = 4.0
local MAX_DELIVERY_TIMEOUT = 35.0
local MAX_DROP_RETRY_COUNT = 8

local function listToLookup(list: { string }): { [string]: boolean }
    local lookup: { [string]: boolean } = {}
    for _, item in ipairs(list) do
        lookup[item] = true
    end
    return lookup
end

local function isLookupEmpty(tbl: { [string]: boolean }): boolean
    return next(tbl) == nil
end

local RARITY_ALIAS_MAP: { [string]: string } = {
    basic = "common",
    common = "common",
    uncommon = "uncommon",
    rare = "rare",
    superrare = "superrare",
    epic = "epic",
    legendary = "legendary",
    mythic = "mythic",
    mythical = "mythic",
    rainbow = "rainbow",
    prismatic = "rainbow",
    celestial = "celestial",
    exotic = "exotic",
    secret = "secret",
    cosmic = "cosmic",
    exclusive = "exclusive",
    admin = "exclusive",
    limited = "limited",
    eternal = "eternal",
    superior = "superior",
    transcendent = "superior",
    divine = "divine",
    titan = "titan",
    brainrotgod = "brainrotgod",
    squishygod = "brainrotgod",
}

local function _normalizeRarityString(str: string): string
    local clean = string.gsub(string.lower(str), "[%s%-_]", "")
    return RARITY_ALIAS_MAP[clean] or clean
end

local function matchesRarityLookup(rarity: string?, lookup: { [string]: boolean }?): boolean
    if not lookup or isLookupEmpty(lookup) then return true end
    if not rarity or typeof(rarity) ~= "string" or rarity == "" then return false end
    if lookup[rarity] == true then return true end

    local normRarity = _normalizeRarityString(rarity)
    for key, enabled in pairs(lookup) do
        if enabled == true then
            if key == rarity then return true end
            if _normalizeRarityString(key) == normRarity then return true end
        end
    end
    return false
end

local function matchesSellRarityLookup(rarity: string?, lookup: { [string]: boolean }?): boolean
    if not rarity or typeof(rarity) ~= "string" or rarity == "" then
        return false
    end
    if not lookup or isLookupEmpty(lookup) then
        return false
    end

    if lookup[rarity] == true then return true end
    local clean = string.gsub(string.lower(rarity), "[%s%-_]", "")
    for key, enabled in pairs(lookup) do
        if enabled == true then
            local cleanKey = string.gsub(string.lower(key), "[%s%-_]", "")
            if clean == cleanKey then return true end

            if (clean == "squishygod" and cleanKey == "brainrotgod") or (clean == "brainrotgod" and cleanKey == "squishygod") then return true end
            if (clean == "transcendent" and cleanKey == "superior") or (clean == "superior" and cleanKey == "transcendent") then return true end
            if (clean == "mythical" and cleanKey == "mythic") or (clean == "mythic" and cleanKey == "mythical") then return true end
            if (clean == "basic" and cleanKey == "common") or (clean == "common" and cleanKey == "basic") then return true end
            if (clean == "prismatic" and cleanKey == "rainbow") or (clean == "rainbow" and cleanKey == "prismatic") then return true end
            if (clean == "admin" and cleanKey == "exclusive") or (clean == "exclusive" and cleanKey == "admin") then return true end
        end
    end
    return false
end

local function matchesAreaLookup(areaName: string, lookup: { [string]: boolean }): boolean
    if isLookupEmpty(lookup) then return true end
    if lookup[areaName] then return true end
    local clean = string.gsub(string.lower(areaName), "[%s%-_]", "")
    for key, enabled in pairs(lookup) do
        if enabled then
            local cleanKey = string.gsub(string.lower(key), "[%s%-_]", "")
            if clean == cleanKey or string.find(clean, cleanKey, 1, true) or string.find(cleanKey, clean, 1, true) then
                return true
            end
        end
    end
    return false
end

local function matchesMutationLookup(mutations: { string }, lookup: { [string]: boolean }): boolean
    if isLookupEmpty(lookup) then return true end
    if #mutations == 0 then
        return lookup["Normal"] == true or lookup["None"] == true
    end
    for _, mut in ipairs(mutations) do
        if lookup[mut] then return true end
        local clean = string.gsub(string.lower(mut), "[%s%-_]", "")
        for key, enabled in pairs(lookup) do
            if enabled then
                local cleanKey = string.gsub(string.lower(key), "[%s%-_]", "")
                if clean == cleanKey then return true end
                if (clean == "sakura" and cleanKey == "bloom") or (clean == "bloom" and cleanKey == "sakura") then return true end
                if (clean == "greatbloom" and (cleanKey == "spiritbloom" or cleanKey == "greatbloom"))
                or (clean == "spiritbloom" and (cleanKey == "spiritbloom" or cleanKey == "greatbloom")) then
                    return true
                end
            end
        end
    end
    return false
end

State = {
    IsReady = false,

    AutoSteal = false,
    AutoDeliver = true,
    MovementMode = "Glide Lerp (Smooth & Fast)",
    GlideSpeed = 275,
    TargetAreas = listToLookup(DEFAULT_AREAS),
    TargetRarities = listToLookup(DEFAULT_RARITIES),
    TargetMutations = listToLookup(DEFAULT_MUTATIONS),
    StealDelay = 0.15,

    AutoSellPets = false,
    AutoSellEggs = false,
    AutoSellRarities = listToLookup(DEFAULT_SELL_RARITIES),
    AutoSellEggRarities = listToLookup(DEFAULT_SELL_EGG_RARITIES),

    AutoPlaceEgg = false,
    TargetPlaceRarities = listToLookup(DEFAULT_RARITIES),
    AutoHatchEgg = false,
    AutoHatchRarities = listToLookup(DEFAULT_RARITIES),
    AutoFusePets = false,
    AutoFuseRarities = listToLookup(DEFAULT_RARITIES),
    AutoEquipBestPets = false,

    AutoUpgradeBase = false,
    AutoUpgradeTreadmill = false,
    AutoTrainTreadmill = false,
    AutoBuyTrail = false,
    AutoEquipBestTrail = false,

    AntiAfk = false,
    FpsBoost = false,
}

function State.Reset()
    State.AutoSteal = false
    State.AutoSellPets = false
    State.AutoSellEggs = false
    State.AutoPlaceEgg = false
    State.AutoHatchEgg = false
    State.AutoFusePets = false
    State.AutoEquipBestPets = false
    State.AutoUpgradeBase = false
    State.AutoUpgradeTreadmill = false
    State.AutoTrainTreadmill = false
    State.AutoBuyTrail = false
    State.AutoEquipBestTrail = false
    State.AntiAfk = false
    State.FpsBoost = false
    State.IsReady = false
end

Features = Features or {}

NetworkGateway = {
    IsCarryingEgg = false,
    CarryingEggUid = nil :: string?,
    LastStolenEggUid = nil :: string?,
    LastStolenSlotKey = nil :: string?,
    _listenersAttached = false,
}

local function safeInvoke(remote: any, ...: any): (boolean, any)
    if not remote or typeof(remote) ~= "Instance" or not remote:IsA("RemoteFunction") then

        return false, nil
    end

    local ok, res = pcall(remote.InvokeServer, remote, ...)

    return ok, res
end

local function safeFire(remote: any, ...: any): boolean
    if not remote or typeof(remote) ~= "Instance" or not remote:IsA("RemoteEvent") then

        return false
    end

    local ok, err = pcall(remote.FireServer, remote, ...)

    return ok
end

function NetworkGateway:EnsureListeners()
    if self._listenersAttached then return end
    if not GameContext:EnsureModules() or not GameContext.Remotes or not GameContext.Remotes.EggWorld then return end
    self._listenersAttached = true

    if GameContext.Remotes.EggWorld.FieldEggCarry then
        RootJanitor:SafeConnect(GameContext.Remotes.EggWorld.FieldEggCarry.OnClientEvent, function(payload: any)
            if type(payload) == "table" then
                local isCarrying = payload.IsCarrying == true
                self.IsCarryingEgg = isCarrying
                if isCarrying and payload.Uid then
                    self.CarryingEggUid = payload.Uid
                    self.LastStolenEggUid = payload.Uid
                else
                    self.CarryingEggUid = nil
                end

            end
        end)
    end

    if GameContext.Remotes.EggWorld.FieldEggRedeemVerdict then
        RootJanitor:SafeConnect(GameContext.Remotes.EggWorld.FieldEggRedeemVerdict.OnClientEvent, function()
            self.IsCarryingEgg = false
            self.CarryingEggUid = nil
            self.LastStolenEggUid = nil
            self.LastStolenSlotKey = nil

            task.spawn(function()
                task.wait(0.1)
                if State.AutoHatchEgg and alive() and Features and Features.Pets then
                    Features.Pets:HatchEggBatch()
                end
                task.wait(0.1)
                if State.AutoPlaceEgg and alive() and Features and Features.Pets then
                    Features.Pets:PlaceEggBatch()
                end
            end)
        end)
    end
end

local _carryThrottle = 0

function NetworkGateway:GetFieldEggSnapshot(): any?
    if not GameContext.Remotes or not GameContext.Remotes.EggWorld or not GameContext.Remotes.EggWorld.AskFieldEggSnapshot then
        return nil
    end
    local ok, snapshot = safeInvoke(GameContext.Remotes.EggWorld.AskFieldEggSnapshot)
    return ok and snapshot or nil
end

function NetworkGateway:TriggerEggPrompt(targetUid: string)
    pcall(function()
        local slotsFolder = GameContext.Workspace:FindFirstChild("AreaEggSlotsClient")
        local eggInst = (slotsFolder and slotsFolder:FindFirstChild(targetUid)) or GameContext.Workspace:FindFirstChild(targetUid)
        if eggInst then
            local prompt = eggInst:FindFirstChildOfClass("ProximityPrompt", true) or eggInst:FindFirstChild("CarryAreaEgg", true)
            if prompt and prompt:IsA("ProximityPrompt") then
                prompt.Enabled = true
                prompt.HoldDuration = 0
                prompt.RequiresLineOfSight = false
                prompt.MaxActivationDistance = 9999
                local fpp = (fireproximityprompt :: any) or (typeof((_G :: any).fireproximityprompt) == "function" and (_G :: any).fireproximityprompt)
                if type(fpp) == "function" then
                    fpp(prompt)
                end
            end
        end
    end)
end

function NetworkGateway:AskFieldEggCarry(payload: { Uid: string, FirstAreaSlotKey: string? }): boolean
    self:TriggerEggPrompt(payload.Uid)

    local remote = (GameContext.Remotes and GameContext.Remotes.EggWorld and GameContext.Remotes.EggWorld.AskFieldEggCarry)
        or (GameContext.ReplicatedStorage:FindFirstChild("Network") and GameContext.ReplicatedStorage.Network:FindFirstChild("Eggs: RequestAreaEggCarry"))

    if remote then
        local ok, res = safeInvoke(remote, payload)
        if ok and (res == true or (type(res) == "table" and (res.Success or res.IsCarrying))) then
            self.IsCarryingEgg = true
            self.CarryingEggUid = payload.Uid
            self.LastStolenEggUid = payload.Uid
            return true
        end
    end

    pcall(function()
        local eggCmds = GameContext:RequireModule("EggCmds")
        if eggCmds and type(eggCmds.RequestCarryAreaEgg) == "function" then
            eggCmds.RequestCarryAreaEgg(payload.Uid)
        end
    end)

    return self.IsCarryingEgg == true
end

function NetworkGateway:WearEggTool(eggUid: string): boolean
    if not GameContext.Remotes or not GameContext.Remotes.EggWorld or not GameContext.Remotes.EggWorld.AskWearTool then
        return false
    end
    local ok, res = safeInvoke(GameContext.Remotes.EggWorld.AskWearTool, eggUid)
    return ok and res ~= false
end

function NetworkGateway:DoffEggTool(): boolean
    if not GameContext.Remotes or not GameContext.Remotes.EggWorld or not GameContext.Remotes.EggWorld.AskDoffTool then
        return false
    end
    local ok, res = safeInvoke(GameContext.Remotes.EggWorld.AskDoffTool, nil)
    return ok and res ~= false
end

function NetworkGateway:PlaceEgg(eggUid: string, localCF: CFrame): boolean
    if not GameContext.Remotes or not GameContext.Remotes.EggWorld or not GameContext.Remotes.EggWorld.AskPlaceEgg then
        return false
    end
    local ok, res = safeInvoke(GameContext.Remotes.EggWorld.AskPlaceEgg, {
        Uid = eggUid,
        LocalCFrame = localCF
    })
    return ok and res == true
end

function NetworkGateway:HatchEgg(eggUid: string): boolean
    if not GameContext.Remotes or not GameContext.Remotes.EggWorld or not GameContext.Remotes.EggWorld.AskHatch then
        return false
    end
    local ok1, res1 = safeInvoke(GameContext.Remotes.EggWorld.AskHatch, eggUid)
    if ok1 and (res1 == true or typeof(res1) == "string") then
        task.wait(0.06)
        local ok2, res2 = safeInvoke(GameContext.Remotes.EggWorld.AskFinishHatch, eggUid)
        return ok2 and (res2 == true or typeof(res2) == "string")
    end
    return false
end

function NetworkGateway:SellPet(petUid: string): boolean
    if not GameContext.Remotes or not GameContext.Remotes.PenRoster or not GameContext.Remotes.PenRoster.AskSale then
        return false
    end
    local ok, res = safeInvoke(GameContext.Remotes.PenRoster.AskSale, petUid)
    return ok and res == true
end

function NetworkGateway:EquipBestPets(): boolean
    if not GameContext.Remotes then return false end
    local ok, res = false, nil
    if GameContext.Remotes.Haul and GameContext.Remotes.Haul.WearBest then
        ok, res = safeInvoke(GameContext.Remotes.Haul.WearBest)
    elseif GameContext.Remotes.PenRoster and GameContext.Remotes.PenRoster.AskWearBest then
        ok, res = safeInvoke(GameContext.Remotes.PenRoster.AskWearBest)
    end
    return ok and res ~= false
end

function NetworkGateway:DoffPet(petUid: string): boolean
    if not GameContext.Remotes or not GameContext.Remotes.PenRoster or not GameContext.Remotes.PenRoster.AskDoff then
        return false
    end
    local ok, res = safeInvoke(GameContext.Remotes.PenRoster.AskDoff, petUid)
    return ok and res ~= false
end

function NetworkGateway:LoadFusePet(petUid: string): boolean
    if not GameContext.Remotes or not GameContext.Remotes.Fusery or not GameContext.Remotes.Fusery.LoadPet then
        return false
    end
    local ok, res = safeInvoke(GameContext.Remotes.Fusery.LoadPet, petUid)
    return ok and res ~= false
end

function NetworkGateway:BeginFuse(): boolean
    if not GameContext.Remotes or not GameContext.Remotes.Fusery or not GameContext.Remotes.Fusery.BeginFuse then
        return false
    end
    local ok, res = safeInvoke(GameContext.Remotes.Fusery.BeginFuse)
    return ok and res == true
end

function NetworkGateway:FinishRevealFuse()
    if GameContext.Remotes and GameContext.Remotes.Fusery and GameContext.Remotes.Fusery.FinishReveal then
        safeInvoke(GameContext.Remotes.Fusery.FinishReveal)
    end
end

function NetworkGateway:EjectFusePet(petUid: string)
    if GameContext.Remotes and GameContext.Remotes.Fusery and GameContext.Remotes.Fusery.EjectPet then
        safeInvoke(GameContext.Remotes.Fusery.EjectPet, petUid)
    end
end

function NetworkGateway:UpgradeBase(): boolean
    if not GameContext.Remotes or not GameContext.Remotes.Homestead or not GameContext.Remotes.Homestead.AskBaseTierRaise then
        return false
    end
    return safeFire(GameContext.Remotes.Homestead.AskBaseTierRaise)
end

function NetworkGateway:UpgradeTreadmill(tierId: string): boolean
    if not GameContext.Remotes or not GameContext.Remotes.Treadmill or not GameContext.Remotes.Treadmill.AskTierRaise then
        return false
    end
    local ok, res = safeInvoke(GameContext.Remotes.Treadmill.AskTierRaise, tierId)
    return ok and res == true
end

function NetworkGateway:BuyTrail(trailId: string): boolean
    if not GameContext.Remotes or not GameContext.Remotes.Trailwear or not GameContext.Remotes.Trailwear.AskPurchase then
        return false
    end
    local ok, res = safeInvoke(GameContext.Remotes.Trailwear.AskPurchase, trailId)
    return ok and res == true
end

function NetworkGateway:EquipTrail(trailId: string): boolean
    if not GameContext.Remotes or not GameContext.Remotes.Trailwear or not GameContext.Remotes.Trailwear.AskChoose then
        return false
    end
    local ok, res = safeInvoke(GameContext.Remotes.Trailwear.AskChoose, trailId)
    return ok and res == true
end

function NetworkGateway:DoffTreadmill()
    if not State or not State.IsReady then return end
    local now = os.clock()
    if (now - (self._lastDoffAt or 0)) < 2.5 then return end
    self._lastDoffAt = now

    if not GameContext:EnsureModules() or not GameContext.Remotes or not GameContext.Remotes.Treadmill or not GameContext.Remotes.Treadmill.AskDoff then
        return
    end
    safeInvoke(GameContext.Remotes.Treadmill.AskDoff)
end

function NetworkGateway:WearStillTreadmill()
    if not State or not State.IsReady then return end
    local now = os.clock()
    if (now - (self._lastWearStillAt or 0)) < 2.5 then return end
    self._lastWearStillAt = now

    if not GameContext:EnsureModules() or not GameContext.Remotes or not GameContext.Remotes.Treadmill or not GameContext.Remotes.Treadmill.AskWearStill then
        return
    end
    safeInvoke(GameContext.Remotes.Treadmill.AskWearStill)
end

function NetworkGateway:WriteAutoSell(raritiesMap: { [string]: boolean }?)
    if not State or not State.IsReady then return end
    if not GameContext:EnsureModules() or not GameContext.Remotes or not GameContext.Remotes.Haul or not GameContext.Remotes.Haul.WriteAutoSell then
        return
    end

    local serverMap: { [string]: boolean } = {}
    if raritiesMap and type(raritiesMap) == "table" and State.AutoSellPets then
        for rName, enabled in pairs(raritiesMap) do
            if enabled == true and (rName == "Common" or rName == "Uncommon" or rName == "Rare") then
                serverMap[rName] = true
            end
        end
    end

    safeInvoke(GameContext.Remotes.Haul.WriteAutoSell, serverMap)
end

export type ParsedEgg = {
    Uid: string,
    Category: string,
    DisplayName: string,
    Rarity: string,
    RarityRank: number,
    Mutations: { string },
    BaseMutation: string?,
    HasMutation: boolean,
    IsFavorite: boolean,
    IsPlaced: boolean,
    Placement: any?,
    PlacedAt: number?,
    GrowthTime: number,
    GrowthCreditSeconds: number,
    NightGrowthCreditSeconds: number,
    IsReadyToHatch: boolean,
    AssetScale: number,
    Raw: any,
}

export type ParsedPet = {
    Uid: string,
    Category: string,
    DisplayName: string,
    Rarity: string,
    RarityRank: number,
    Mutations: { string },
    BaseMutation: string?,
    HasMutation: boolean,
    IsFavorite: boolean,
    IsEquipped: boolean,
    InFuse: boolean,
    IsLocked: boolean,
    Scale: number,
    Personality: string?,
    Raw: any,
}

PlotAdapter = {}
local _plotCache: { plot: any?, at: number } = { plot = nil, at = 0 }

function PlotAdapter:GetMyPlot(): { Slot: string, Model: Model, PetArea: BasePart?, CenterPoint: BasePart?, TreadmillBottom: BasePart? }?
    local now = os.clock()
    if _plotCache.plot and (now - _plotCache.at) < 20 then
        return _plotCache.plot
    end
    if not _plotCache.plot and (now - _plotCache.at) < 3 then
        return nil
    end

    local mySlot: string? = nil

    if GameContext.PlotState and type(GameContext.PlotState.ResolveLocalSlot) == "function" then
        local ok, s = pcall(GameContext.PlotState.ResolveLocalSlot)
        if ok and s then
            mySlot = tostring(s)
        end
    end

    if not mySlot and GameContext.Remotes and GameContext.Remotes.Homestead and GameContext.Remotes.Homestead.AskState then
        local ok, state = pcall(function() return GameContext.Remotes.Homestead.AskState:InvokeServer() end)
        if ok and state and state.OwnersBySlot then
            for slot, uid in pairs(state.OwnersBySlot) do
                if uid == GameContext.LocalPlayer.UserId then
                    mySlot = tostring(slot)
                    break
                end
            end
        end
    end

    if not mySlot then
        _plotCache.at = now
        return nil
    end

    local plotModel = GameContext.Workspace.Plots:FindFirstChild(mySlot)
    if not plotModel then
        _plotCache.at = now
        return nil
    end

    local centerPoint = (plotModel:FindFirstChild("CenterPoint", true) or plotModel:FindFirstChild("SpawnPoint", true) or plotModel.PrimaryPart) :: BasePart?
    local petArea = (plotModel:FindFirstChild("PetArea", true) or centerPoint) :: BasePart?
    local treadmillBottom = plotModel:FindFirstChild("TreadmillBottom", true) :: BasePart?

    local plot = {
        Slot = mySlot,
        Model = plotModel,
        PetArea = petArea,
        CenterPoint = centerPoint,
        TreadmillBottom = treadmillBottom
    }
    _plotCache = { plot = plot, at = now }
    return plot
end

function PlotAdapter:GetSafeZonePosition(currentPos: Vector3?): Vector3
    local targetZ = -364.5
    local targetY = 70.5

    if currentPos then

        targetZ = math.clamp(currentPos.Z, -385.0, -345.0)
        targetY = math.clamp(currentPos.Y, 68.0, 75.0)
    end

    return Vector3.new(525.0, targetY, targetZ)
end

function PlotAdapter:IsNearSafezoneOrStand(hrp: BasePart): boolean
    local pos = hrp.Position
    if pos.X <= 548 and pos.X >= 350 then
        local plot = self:GetMyPlot()
        if plot then
            local pivot = (plot.CenterPoint and plot.CenterPoint.Position) or (plot.Model and plot.Model:GetPivot().Position)
            if pivot and math.abs(pos.Z - pivot.Z) <= 80 then
                return true
            end
        end
        return pos.Z >= -520 and pos.Z <= -200
    end
    return false
end

function PlotAdapter:IsResetWallClosed(): boolean
    if not GameContext.AreaEggResetWall then return false end
    if type(GameContext.AreaEggResetWall.IsSealed) == "function" then
        local ok, sealed = pcall(GameContext.AreaEggResetWall.IsSealed)
        return ok and sealed == true
    elseif type(GameContext.AreaEggResetWall.IsClosed) == "function" then
        local ok, closed = pcall(GameContext.AreaEggResetWall.IsClosed)
        return ok and closed == true
    end
    return false
end

local RARITY_RANK_MAP: { [string]: number } = {
    Common = 1, Basic = 1,
    Uncommon = 2,
    Rare = 3,
    SuperRare = 4, ["Super Rare"] = 4,
    Epic = 5,
    Legendary = 6,
    Mythic = 7, Mythical = 7,
    Rainbow = 8, Prismatic = 8,
    Celestial = 9,
    Exotic = 10,
    Secret = 11,
    Cosmic = 12,
    Exclusive = 13, Admin = 13,
    Limited = 14,
    Eternal = 15,
    Superior = 16, Transcendent = 16,
    Divine = 17,
    Titan = 18,
    BrainrotGod = 19, ["Squishy God"] = 19,
}

DataAdapter = {
    _reverseDisplayNameMap = {} :: { [string]: any },
    _cleanKeyMap = {} :: { [string]: any },
    _indexesBuilt = false,
}

function DataAdapter:_EnsureIndexes()
    if self._indexesBuilt and GameContext.AssetsDirectory and GameContext.AssetsDirectory.Directory then
        return
    end

    if not GameContext.AssetsDirectory or not GameContext.AssetsDirectory.Directory then
        pcall(function()
            local dataFolder = GameContext.ReplicatedStorage:FindFirstChild("Data")
            if dataFolder and dataFolder:FindFirstChild("Assets") then
                GameContext.AssetsDirectory = require(dataFolder.Assets)
            end
        end)
    end

    if not GameContext.AssetsDirectory or not GameContext.AssetsDirectory.Directory then
        return
    end

    local dir = GameContext.AssetsDirectory.Directory
    table.clear(self._reverseDisplayNameMap)
    table.clear(self._cleanKeyMap)

    for id, entry in pairs(dir) do
        if typeof(entry) == "table" then
            if entry.DisplayName and typeof(entry.DisplayName) == "string" then
                self._reverseDisplayNameMap[string.lower(entry.DisplayName)] = entry
            end
            local clean = string.gsub(string.lower(tostring(id)), "[%s%-_]", "")
            self._cleanKeyMap[clean] = entry
        end
    end

    self._indexesBuilt = true
end

function DataAdapter:GetSaveData(): any?
    local data: any = nil
    pcall(function()
        if GameContext.Save and GameContext.Save.Get then
            data = GameContext.Save.Get()
        elseif GameContext.Save and GameContext.Save.LocalProfile then
            data = GameContext.Save.LocalProfile
        end
    end)
    return data
end

function DataAdapter:GetAssetEntry(categoryOrName: string?): any?
    if not categoryOrName or typeof(categoryOrName) ~= "string" or categoryOrName == "" then
        return nil
    end

    self:_EnsureIndexes()

    if not GameContext.AssetsDirectory or not GameContext.AssetsDirectory.Directory then
        return nil
    end

    local dir = GameContext.AssetsDirectory.Directory
    if dir[categoryOrName] then
        return dir[categoryOrName]
    end

    local lower = string.lower(categoryOrName)
    if self._reverseDisplayNameMap[lower] then
        return self._reverseDisplayNameMap[lower]
    end

    local clean = string.gsub(lower, "[%s%-_]", "")
    if self._cleanKeyMap[clean] then
        return self._cleanKeyMap[clean]
    end

    return nil
end

function DataAdapter:NormalizeRarity(rawRarity: any): string
    if not rawRarity then return "Common" end
    local rStr = "Common"
    if typeof(rawRarity) == "table" then
        rStr = rawRarity.DisplayName or rawRarity._id or "Common"
    elseif typeof(rawRarity) == "string" and rawRarity ~= "" then
        rStr = rawRarity
    end

    local clean = string.gsub(string.lower(rStr), "[%s%-_]", "")
    if clean == "basic" then return "Common"
    elseif clean == "mythical" then return "Mythic"
    elseif clean == "prismatic" then return "Rainbow"
    elseif clean == "transcendent" then return "Superior"
    elseif clean == "squishygod" then return "BrainrotGod"
    elseif clean == "admin" then return "Exclusive"
    elseif clean == "superrare" then return "SuperRare"
    end

    return rStr
end

function DataAdapter:GetRarityRank(rarityName: string?): number
    if not rarityName then return 1 end
    local norm = self:NormalizeRarity(rarityName)
    return RARITY_RANK_MAP[norm] or 1
end

function DataAdapter:GetAssetRarity(assetCategory: string?): string?
    if not assetCategory or typeof(assetCategory) ~= "string" or assetCategory == "" then
        return nil
    end

    local entry = self:GetAssetEntry(assetCategory)
    if not entry or not entry.Rarity then
        return nil
    end

    return self:NormalizeRarity(entry.Rarity)
end

function DataAdapter:GetEggGrowthDuration(categoryOrName: string?, placement: any?): number
    if placement and typeof(placement) == "table" and placement.GrowthDuration and typeof(placement.GrowthDuration) == "number" and placement.GrowthDuration > 0 then
        return placement.GrowthDuration
    end

    local entry = self:GetAssetEntry(categoryOrName)
    if entry and entry.Egg and typeof(entry.Egg.GrowthTime) == "number" and entry.Egg.GrowthTime > 0 then
        return entry.Egg.GrowthTime
    end

    return 60
end

function DataAdapter:ResolveRecordRarity(record: any): string
    if not record or typeof(record) ~= "table" then return "Common" end
    if record.Rarity then
        return self:NormalizeRarity(record.Rarity)
    end
    local cat = record.AssetCategory or record.Category or record.AssetId
    if cat then
        local r = self:GetAssetRarity(tostring(cat))
        if r then return r end
    end
    return "Common"
end

function DataAdapter:ResolveRecordArea(record: any): string
    if not record or typeof(record) ~= "table" then return "Forest" end
    if record.AreaId and typeof(record.AreaId) == "string" and record.AreaId ~= "" then
        return record.AreaId
    end
    local cf = record.BoundsCFrame or record.BottomCFrame
    if cf and typeof(cf) == "CFrame" then
        local x = cf.Position.X
        if x < 660 then return "Forest"
        elseif x < 810 then return "Lake"
        elseif x < 1010 then return "Desert"
        elseif x < 1265 then return "Jungle"
        elseif x < 1580 then return "Snow"
        elseif x < 1960 then return "Volcano"
        elseif x < 2400 then return "Abyss Ocean"
        elseif x < 2920 then return "Prehistoric"
        elseif x < 3560 then return "Cosmic"
        elseif x < 4400 then return "Cherry Blossom"
        else return "Titan Temple" end
    end
    return "Forest"
end

function DataAdapter:GetEggMutations(record: any): { string }
    local muts: { string } = {}
    if not record or typeof(record) ~= "table" then return muts end

    if record.Mutations and typeof(record.Mutations) == "table" then
        for _, m in ipairs(record.Mutations) do
            local ms = tostring(m)
            if ms ~= "" and ms ~= "None" and not table.find(muts, ms) then
                table.insert(muts, ms)
            end
        end
    end
    if record.BaseMutation and typeof(record.BaseMutation) == "string" then
        local bs = record.BaseMutation
        if bs ~= "" and bs ~= "None" and not table.find(muts, bs) then
            table.insert(muts, bs)
        end
    end
    return muts
end

function DataAdapter:GetMutationBonus(record: any): number
    local eggMuts = self:GetEggMutations(record)
    if #eggMuts == 0 then return 0 end
    local maxBonus = 200
    for _, m in ipairs(eggMuts) do
        local clean = string.gsub(string.lower(m), "[%s%-_]", "")
        local bonus = 200
        if clean == "rainbow" then
            bonus = 500
        elseif clean == "golden" or clean == "greatbloom" or clean == "spiritbloom" then
            bonus = 350
        elseif clean == "sakura" or clean == "bloom" then
            bonus = 250
        end
        if bonus > maxBonus then maxBonus = bonus end
    end
    if #eggMuts > 1 then maxBonus = maxBonus + 150 end
    return maxBonus
end

function DataAdapter:ParseEgg(uid: string, rawEgg: any): ParsedEgg?
    if not rawEgg or typeof(rawEgg) ~= "table" then return nil end

    local category = tostring(rawEgg.AssetCategory or rawEgg.Category or rawEgg.AssetId or "Unknown")
    local entry = self:GetAssetEntry(category)
    local displayName = entry and entry.DisplayName or (entry and entry.Egg and entry.Egg.DisplayName) or category
    local rarity = (entry and entry.Rarity and self:NormalizeRarity(entry.Rarity)) or self:ResolveRecordRarity(rawEgg)
    local rarityRank = self:GetRarityRank(rarity)

    local mutations = self:GetEggMutations(rawEgg)
    local baseMutation = rawEgg.BaseMutation and typeof(rawEgg.BaseMutation) == "string" and rawEgg.BaseMutation ~= "" and rawEgg.BaseMutation or nil
    local hasMutation = #mutations > 0 or (baseMutation ~= nil and baseMutation ~= "Normal" and baseMutation ~= "")

    local isPlaced = rawEgg.Placement ~= nil and typeof(rawEgg.Placement) == "table"
    local placement = isPlaced and rawEgg.Placement or nil
    local placedAt = placement and typeof(placement.PlacedAt) == "number" and placement.PlacedAt or nil
    local growthCredit = placement and typeof(placement.GrowthCreditSeconds) == "number" and placement.GrowthCreditSeconds or 0
    local nightGrowthCredit = placement and typeof(placement.NightGrowthCreditSeconds) == "number" and placement.NightGrowthCreditSeconds or 0
    local growthTime = self:GetEggGrowthDuration(category, placement)

    local isReady = false
    if isPlaced then

        if GameContext.EggState and GameContext.EggState.IsReadyToHatch then
            local ok, r = pcall(GameContext.EggState.IsReadyToHatch, uid)
            if ok and r == true then
                isReady = true
            end
        end

        if not isReady and placement then
            if typeof(placement.ReadyAt) == "number" then

                local now = GameContext.Workspace:GetServerTimeNow()
                if now >= placement.ReadyAt then
                    isReady = true
                end
            elseif placedAt then

                local now = GameContext.Workspace:GetServerTimeNow()
                if (now - placedAt) + growthCredit + nightGrowthCredit >= growthTime then
                    isReady = true
                end
            end
        end
    end

    local parsed: ParsedEgg = {
        Uid = tostring(uid),
        Category = category,
        DisplayName = displayName,
        Rarity = rarity,
        RarityRank = rarityRank,
        Mutations = mutations,
        BaseMutation = baseMutation,
        HasMutation = hasMutation,
        IsFavorite = rawEgg.IsFavorite == true,
        IsPlaced = isPlaced,
        Placement = placement,
        PlacedAt = placedAt,
        GrowthTime = growthTime,
        GrowthCreditSeconds = growthCredit,
        NightGrowthCreditSeconds = nightGrowthCredit,
        IsReadyToHatch = isReady,
        AssetScale = typeof(rawEgg.AssetScale) == "number" and rawEgg.AssetScale or 1.0,
        Raw = rawEgg,
    }

    return parsed
end

function DataAdapter:ParsePet(uid: string, rawPet: any, equippedMap: { [string]: boolean }?): ParsedPet?
    if not rawPet or typeof(rawPet) ~= "table" then return nil end

    local category = tostring(rawPet.Category or rawPet.AssetCategory or rawPet.AssetId or "Unknown")
    local entry = self:GetAssetEntry(category)
    local displayName = entry and entry.DisplayName or category
    local rarity = (entry and entry.Rarity and self:NormalizeRarity(entry.Rarity)) or self:ResolveRecordRarity(rawPet)
    local rarityRank = self:GetRarityRank(rarity)

    local mutations = self:GetEggMutations(rawPet)
    local baseMutation = rawPet.BaseMutation and typeof(rawPet.BaseMutation) == "string" and rawPet.BaseMutation ~= "" and rawPet.BaseMutation or nil
    local hasMutation = #mutations > 0 or (baseMutation ~= nil and baseMutation ~= "Normal" and baseMutation ~= "")

    local isEquipped = false
    if equippedMap then
        isEquipped = equippedMap[tostring(uid)] == true
    end

    local parsed: ParsedPet = {
        Uid = tostring(uid),
        Category = category,
        DisplayName = displayName,
        Rarity = rarity,
        RarityRank = rarityRank,
        Mutations = mutations,
        BaseMutation = baseMutation,
        HasMutation = hasMutation,
        IsFavorite = rawPet.IsFavorite == true,
        IsEquipped = isEquipped,
        InFuse = rawPet.InFuse == true,
        IsLocked = rawPet.Locked == true,
        Scale = typeof(rawPet.Scale) == "number" and rawPet.Scale or 1.0,
        Personality = rawPet.Personality and typeof(rawPet.Personality) == "string" and rawPet.Personality or nil,
        Raw = rawPet,
    }

    return parsed
end

function DataAdapter:GetAllEggs(onlyUnplaced: boolean?): { ParsedEgg }
    local data = self:GetSaveData()
    local list: { ParsedEgg } = {}
    if not data or not data.EggInventory then return list end

    for uid, rawEgg in pairs(data.EggInventory) do
        local egg = self:ParseEgg(tostring(uid), rawEgg)
        if egg then
            if onlyUnplaced == true then
                if not egg.IsPlaced then
                    table.insert(list, egg)
                end
            else
                table.insert(list, egg)
            end
        end
    end

    return list
end

function DataAdapter:GetAllPets(onlyUnequipped: boolean?): { ParsedPet }
    local data = self:GetSaveData()
    local list: { ParsedPet } = {}
    if not data or not data.Inventory then return list end

    local equippedMap: { [string]: boolean } = {}
    for _, uid in pairs(data.EquippedAssets or {}) do
        if type(uid) == "string" or type(uid) == "number" then
            equippedMap[tostring(uid)] = true
        end
    end

    for uid, rawPet in pairs(data.Inventory) do
        local pet = self:ParsePet(tostring(uid), rawPet, equippedMap)
        if pet then
            if onlyUnequipped == true then
                if not pet.IsEquipped then
                    table.insert(list, pet)
                end
            else
                table.insert(list, pet)
            end
        end
    end

    return list
end

local GLIDE_MAX_STEP = 6.5
local GLIDE_ROLLBACK_TOLERANCE = 22
local GLIDE_MAX_ROLLBACKS = 8

local function isSolidObstacle(hit: RaycastResult?): boolean
    if not hit or not hit.Instance then return false end
    local part = hit.Instance
    if not part:IsA("BasePart") then return false end
    if not part.CanCollide then return false end
    if part.Transparency >= 0.95 then return false end
    return true
end

local function checkObstacleSensors(hrp: BasePart, rayParams: RaycastParams): (boolean, Vector3?)
    local origin = hrp.Position
    local look   = hrp.CFrame.LookVector
    local right  = hrp.CFrame.RightVector

    local REACH = 5.5
    local fwdHit = GameContext.Workspace:Raycast(origin + Vector3.new(0, 0.5, 0), look * REACH, rayParams)
    if not isSolidObstacle(fwdHit) then
        return false, nil
    end

    local candidates: { { dir: Vector3, dist: number } } = {}
    local function testDir(dir: Vector3)
        local PROBE = 8.0
        local hit = GameContext.Workspace:Raycast(origin, dir.Unit * PROBE, rayParams)
        local clearDist = isSolidObstacle(hit) and (hit.Position - origin).Magnitude or PROBE
        table.insert(candidates, { dir = dir.Unit, dist = clearDist })
    end

    testDir((look - right * 0.7).Unit)
    testDir((look + right * 0.7).Unit)
    testDir(-right)
    testDir(right)

    local best: { dir: Vector3, dist: number }? = nil
    for _, c in ipairs(candidates) do
        if not best or c.dist > best.dist then best = c end
    end

    if best and best.dist > 2.5 then
        return true, origin + best.dir * math.min(best.dist, 7.0)
    end

    return true, origin - look * 3.0
end

LocomotionController = {
    IsGlideActive = false,
    _glideGen = 0,
    _antiFlipGyro = nil :: BodyGyro?,
    _cachedGroundRayParams = nil :: RaycastParams?,
    _cachedRayParams = nil :: RaycastParams?,
    _isHumanoidProtected = false,
    _steppedConn = nil :: RBXScriptConnection?,
    _guardAddedConn = nil :: RBXScriptConnection?,
    _guardTouchOff = setmetatable({}, { __mode = "k" }) :: { [BasePart]: boolean },
    _initialized = false,
}

function LocomotionController:NeutralizePushback(char: Model?)
    if not char then return end
    for _, name in ipairs({ "AntiCollisionHighSeedPushBack", "FixCollisions" }) do
        local s = char:FindFirstChild(name)
        if s and (s:IsA("LocalScript") or s:IsA("Script")) then
            s.Enabled = false
        end
    end
end

local _immModulesHooked = false

function LocomotionController:HookImmunityModules()
    if _immModulesHooked then return end
    _immModulesHooked = true

    pcall(function()
        local ragdollMod = GameContext:RequireModule("Ragdoll")
        if type(ragdollMod) == "table" then
            for _, fnName in ipairs({ "ApplyClientRagdoll", "Ragdoll", "TimedRagdoll", "TimedRagdollAsync", "NpcRagdoll" }) do
                local origFn = ragdollMod[fnName]
                if type(origFn) == "function" then
                    ragdollMod[fnName] = function(...)
                        if State.AutoSteal then return end
                        return origFn(...)
                    end
                end
            end
            local origIsRag = ragdollMod.IsRagdolled
            if type(origIsRag) == "function" then
                ragdollMod.IsRagdolled = function(...)
                    if State.AutoSteal then return false end
                    return origIsRag(...)
                end
            end
        end
    end)

    pcall(function()
        local eggCmds = GameContext:RequireModule("EggCmds")
        if type(eggCmds) == "table" and type(eggCmds.RequestDropHeldAreaEgg) == "function" then
            local origDrop = eggCmds.RequestDropHeldAreaEgg
            eggCmds.RequestDropHeldAreaEgg = function(reason: any, ...)
                if State.AutoSteal and reason ~= nil and reason ~= "PlayerRequest" then
                    return false, "Blocked guard drop"
                end
                return origDrop(reason, ...)
            end
        end
    end)
end

function LocomotionController:SetGuardImmunity(enabled: boolean)
    self:HookImmunityModules()

    if enabled then

        local objects = GameContext.Workspace:FindFirstChild("__OBJECTS")
        local guardAreas = objects and objects:FindFirstChild("Areas") and objects.Areas:FindFirstChild("GuardAreas")
        if guardAreas then
            for _, child in ipairs(guardAreas:GetChildren()) do
                local guard = child:FindFirstChild("Guard")
                if guard then
                    for _, desc in ipairs(guard:GetDescendants()) do
                        if desc:IsA("BasePart") and desc.CanTouch then
                            self._guardTouchOff[desc] = true
                            desc.CanTouch = false
                        end
                    end
                end
            end
        end

        for _, desc in ipairs(GameContext.Workspace:GetDescendants()) do
            if desc:IsA("BasePart") and desc.CanTouch then
                local name = desc.Name:lower()
                local pName = desc.Parent and desc.Parent.Name:lower() or ""
                if name:find("guard") or pName:find("guard") then
                    self._guardTouchOff[desc] = true
                    desc.CanTouch = false
                end
            end
        end

        if not self._guardAddedConn then
            self._guardAddedConn = GameContext.Workspace.DescendantAdded:Connect(function(desc)
                if State.AutoSteal and desc:IsA("BasePart") then
                    local name = desc.Name:lower()
                    local pName = desc.Parent and desc.Parent.Name:lower() or ""
                    if name:find("guard") or pName:find("guard") then
                        self._guardTouchOff[desc] = true
                        desc.CanTouch = false
                    end
                end
            end)
        end

        pcall(function()
            local getconn = (type(getconnections) == "function" and getconnections)
                or (type((_G :: any).getconnections) == "function" and (_G :: any).getconnections)
            if type(getconn) == "function" then
                local netMod = GameContext.ReplicatedStorage:FindFirstChild("Network")
                if netMod then
                    for _, rName in ipairs({ "Guards: SpeedHitOffer", "Guards: SpeedHitWarning", "Guards: WakeUp" }) do
                        local rem = netMod:FindFirstChild(rName)
                        if rem and rem:IsA("RemoteEvent") then
                            for _, conn in ipairs(getconn(rem.OnClientEvent)) do
                                if conn.Disable then conn:Disable() end
                            end
                        end
                    end
                end
                local ragMod = GameContext:RequireModule("Ragdoll")
                if type(ragMod) == "table" and typeof(ragMod.ClientRagdollRemote) == "Instance" then
                    for _, conn in ipairs(getconn(ragMod.ClientRagdollRemote.OnClientEvent)) do
                        if conn.Disable then conn:Disable() end
                    end
                end
            end
        end)
    else
        if self._guardAddedConn then
            self._guardAddedConn:Disconnect()
            self._guardAddedConn = nil
        end
        for part in pairs(self._guardTouchOff) do
            if part and part.Parent then
                pcall(function() part.CanTouch = true end)
            end
        end
        table.clear(self._guardTouchOff)
    end
end

function LocomotionController:SetHumanoidProtection(hum: Humanoid?, protect: boolean)
    if not hum then return end
    self._isHumanoidProtected = protect

    local char = hum.Parent
    if char and char:IsA("Model") then
        self:NeutralizePushback(char)
    end

    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not protect)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not protect)
        hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, not protect)
        hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
    end)
end

function LocomotionController:SetCharacterNoClip(char: Model?, enabled: boolean)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.CanCollide ~= not enabled then
            part.CanCollide = not enabled
        end
    end
end

function LocomotionController:EnsureBodyGyro(_hrp: BasePart)

end

function LocomotionController:RemoveBodyGyro()
    if self._antiFlipGyro then
        pcall(function() self._antiFlipGyro:Destroy() end)
        self._antiFlipGyro = nil
    end
    local char = GameContext.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local old = hrp:FindFirstChild("__ValincGyro")
        if old then pcall(function() old:Destroy() end) end
    end
end

function LocomotionController:FreezeHRP(hrp: BasePart)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

function LocomotionController:StopRagdollAnimations(hum: Humanoid?)
    if not hum then return end
    local anim = hum:FindFirstChildOfClass("Animator")
    if anim then
        for _, track in ipairs(anim:GetPlayingAnimationTracks()) do
            local name = (track.Name or ""):lower()
            local id = (track.Animation and track.Animation.AnimationId) or ""
            if id:find("122257458498464")
                or name:find("ragdoll") or name:find("fall") or name:find("trip") or name:find("knock")
                or name:find("hit") or name:find("freefall") or name:find("flail") then
                pcall(function() track:Stop(0) end)
            end
        end
    end
end

function LocomotionController:ResetCharacterPhysics()
    local char = GameContext.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if hrp then
        hrp.Anchored = false
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    if hum and hrp then
        pcall(function() hum:MoveTo(hrp.Position) end)
    end
    self:SetCharacterNoClip(char, false)
end

function LocomotionController:GetGroundElevation(targetPos: Vector3): Vector3
    local char = GameContext.LocalPlayer.Character
    if not self._cachedGroundRayParams then
        self._cachedGroundRayParams = RaycastParams.new()
        self._cachedGroundRayParams.FilterType = Enum.RaycastFilterType.Exclude
        self._cachedGroundRayParams.IgnoreWater = true
    end
    local rayParams = self._cachedGroundRayParams

    local ignoreList: { Instance } = {}
    if char then table.insert(ignoreList, char) end
    for _, p in ipairs(GameContext.Players:GetPlayers()) do
        if p ~= GameContext.LocalPlayer and p.Character then
            table.insert(ignoreList, p.Character)
        end
    end
    if GameContext.Workspace:FindFirstChild("__OBJECTS") and GameContext.Workspace.__OBJECTS:FindFirstChild("Areas") then
        local guardAreas = GameContext.Workspace.__OBJECTS.Areas:FindFirstChild("GuardAreas")
        if guardAreas then
            for _, child in ipairs(guardAreas:GetChildren()) do
                local nests = child:FindFirstChild("Nests")
                if nests then table.insert(ignoreList, nests) end
                local guard = child:FindFirstChild("Guard")
                if guard then table.insert(ignoreList, guard) end
            end
        end
    end
    if GameContext.Workspace:FindFirstChild("AreaEggSlotsClient") then
        table.insert(ignoreList, GameContext.Workspace.AreaEggSlotsClient)
    end
    rayParams.FilterDescendantsInstances = ignoreList

    local rayHit = GameContext.Workspace:Raycast(targetPos + Vector3.new(0, 20, 0), Vector3.new(0, -120, 0), rayParams)
    if rayHit and rayHit.Position then
        local floorY = rayHit.Position.Y
        if math.abs(floorY - targetPos.Y) <= 6 then
            return Vector3.new(targetPos.X, floorY + 3.2, targetPos.Z)
        end
    end
    return Vector3.new(targetPos.X, targetPos.Y, targetPos.Z)
end

function LocomotionController:BuildObstacleRayParams(char: Model): RaycastParams
    if not self._cachedRayParams then
        self._cachedRayParams = RaycastParams.new()
        self._cachedRayParams.FilterType = Enum.RaycastFilterType.Exclude
        self._cachedRayParams.IgnoreWater = true
    end
    local rayParams = self._cachedRayParams

    local ignoreList: { Instance } = { char }
    for _, p in ipairs(GameContext.Players:GetPlayers()) do
        if p ~= GameContext.LocalPlayer and p.Character then
            table.insert(ignoreList, p.Character)
        end
    end
    if GameContext.Workspace:FindFirstChild("__OBJECTS") and GameContext.Workspace.__OBJECTS:FindFirstChild("Areas") then
        local guardAreas = GameContext.Workspace.__OBJECTS.Areas:FindFirstChild("GuardAreas")
        if guardAreas then
            for _, child in ipairs(guardAreas:GetChildren()) do
                local nests = child:FindFirstChild("Nests")
                if nests then table.insert(ignoreList, nests) end
            end
        end
    end
    if GameContext.Workspace:FindFirstChild("AreaEggSlotsClient") then
        table.insert(ignoreList, GameContext.Workspace.AreaEggSlotsClient)
    end
    rayParams.FilterDescendantsInstances = ignoreList
    return rayParams
end

function LocomotionController:_AttachPhysicsHooks()
    if self._steppedConn or self._heartbeatConn then return end

    self._steppedConn = GameContext.RunService.Stepped:Connect(function()
        if not State.AutoSteal then return end
        local char = GameContext.LocalPlayer.Character
        if char then
            self:NeutralizePushback(char)
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)

    self._heartbeatConn = GameContext.RunService.Heartbeat:Connect(function()
        if not State.AutoSteal then return end
        local char = GameContext.LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart") :: BasePart?
        if not hrp then return end

        local nowScan = os.clock()
        if nowScan - (self._lastImmuneScan or 0) >= 0.1 then
            self._lastImmuneScan = nowScan

            for _, desc in ipairs(char:GetDescendants()) do
                if desc:IsA("Motor6D") then
                    if not desc.Enabled then desc.Enabled = true end
                elseif desc:IsA("BallSocketConstraint") or desc:IsA("HingeConstraint") or desc:IsA("Attachment") then
                    local dName = desc.Name:lower()
                    if dName:find("ragdoll") or desc:GetAttribute("RagdollConstraint") or desc:GetAttribute("RagdollAttachment") then
                        pcall(function() desc:Destroy() end)
                    end
                end
            end
        end

        if hum then
            if hum.Sit then hum.Sit = false end
            if hum.PlatformStand then hum.PlatformStand = false end

            local humState = hum:GetState()
            if humState == Enum.HumanoidStateType.Ragdoll
                or humState == Enum.HumanoidStateType.FallingDown
                or humState == Enum.HumanoidStateType.PlatformStanding
                or humState == Enum.HumanoidStateType.Physics
                or humState == Enum.HumanoidStateType.Seated then
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end

            self:StopRagdollAnimations(hum)
        end

        hrp.AssemblyAngularVelocity = Vector3.zero
        local vel = hrp.AssemblyLinearVelocity
        if vel.Y > 30 then
            hrp.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
        elseif vel.Magnitude > 350 then
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end

function LocomotionController:_DetachPhysicsHooks()
    if self._steppedConn then
        self._steppedConn:Disconnect()
        self._steppedConn = nil
    end
    if self._heartbeatConn then
        self._heartbeatConn:Disconnect()
        self._heartbeatConn = nil
    end
    self:RemoveBodyGyro()
end

function LocomotionController:StopMovement()
    self._glideGen = self._glideGen + 1
    self.IsGlideActive = false
    local char = GameContext.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    if hum and hrp then
        pcall(function() hum:MoveTo(hrp.Position) end)
    end
end

function LocomotionController:ApplyStealProtection(enabled: boolean)
    local char = GameContext.LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?

    self:SetGuardImmunity(enabled)
    if hum then
        self:SetHumanoidProtection(hum, enabled)
        if not enabled and hrp then
            pcall(function() hum:MoveTo(hrp.Position) end)
        end
    end

    if enabled then
        self:_AttachPhysicsHooks()
    else
        self:StopMovement()
        self:_DetachPhysicsHooks()
        self:ResetCharacterPhysics()
        self._isHumanoidProtected = false
    end
end

function LocomotionController:GlideTo(targetPos: Vector3, stopDistance: number?, maxTimeout: number?, shouldCancel: (() -> boolean)?, exactTarget: boolean?): boolean
    local char = GameContext.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end

    self._glideGen = self._glideGen + 1
    local currentGen = self._glideGen
    self.IsGlideActive = true

    local distStop = stopDistance or 1.5
    local adjustedTargetPos = exactTarget and targetPos or self:GetGroundElevation(targetPos)
    local startTime = os.clock()
    local timeout = maxTimeout or math.max(15, (adjustedTargetPos - hrp.Position).Magnitude / 40)

    local flatDir = Vector3.new(0, 0, -1)
    local lastActual = hrp.Position
    local rollbackCount = 0

    while (os.clock() - startTime < timeout) do
        if not State.AutoSteal or currentGen ~= self._glideGen or not alive() then break end
        if shouldCancel and shouldCancel() then break end

        if PlotAdapter:IsResetWallClosed() and not NetworkGateway.IsCarryingEgg and (adjustedTargetPos.X - hrp.Position.X) > 0 then break end

        char = GameContext.LocalPlayer.Character
        if not char then break end
        hrp = char:FindFirstChild("HumanoidRootPart") :: BasePart?
        hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then break end

        local dt = GameContext.RunService.Heartbeat:Wait()
        if currentGen ~= self._glideGen or not hrp.Parent or not alive() then break end

        local curPos = hrp.Position

        local backwardJump = (lastActual - curPos).Magnitude
        local movedBackward = (curPos - adjustedTargetPos).Magnitude > (lastActual - adjustedTargetPos).Magnitude
        if backwardJump > GLIDE_ROLLBACK_TOLERANCE and movedBackward then
            rollbackCount = rollbackCount + 1
            if rollbackCount > GLIDE_MAX_ROLLBACKS then break end
            lastActual = curPos
            continue
        end
        lastActual = curPos

        local diff = adjustedTargetPos - curPos
        local remaining = diff.Magnitude
        if remaining <= distStop then break end

        local freshFlat = diff * Vector3.new(1, 0, 1)
        if freshFlat.Magnitude > 0.05 then flatDir = freshFlat.Unit end

        local speed = (State and State.GlideSpeed) or 275
        local clampedDt = math.min(dt, 0.05)
        local step = speed * clampedDt
        if step > GLIDE_MAX_STEP then step = GLIDE_MAX_STEP end
        if step > remaining then step = remaining end

        local nextPos = curPos + diff.Unit * step

        hrp.CFrame = CFrame.lookAt(nextPos, nextPos + flatDir)

        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hum.PlatformStand = false
        hum.Sit = false
        self:StopRagdollAnimations(hum)
    end

    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    local arrived = hrp and ((adjustedTargetPos - hrp.Position).Magnitude <= (distStop + 1.0)) or false
    self.IsGlideActive = false
    return arrived
end

function LocomotionController:WalkTo(targetPos: Vector3, stopDistance: number?, maxTimeout: number?, shouldCancel: (() -> boolean)?): boolean
    local char = GameContext.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end

    local distStop = stopDistance or 3.5
    local calculatedTimeout = math.max(30, (targetPos - hrp.Position).Magnitude / 40)
    local timeout = maxTimeout or calculatedTimeout
    local startTime = os.clock()
    local lastMoveTo = 0
    local lastStuckCheck = os.clock()
    local lastStuckPos = hrp.Position

    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        if hum.JumpPower == 0 and hum.JumpHeight == 0 then
            hum.JumpPower = 50
        end
    end)

    while (os.clock() - startTime < timeout) do
        if not State.AutoSteal or currentGen ~= self._glideGen or not alive() then
            hum:MoveTo(hrp.Position)
            return false
        end
        if shouldCancel and shouldCancel() then
            hum:MoveTo(hrp.Position)
            return false
        end

        if PlotAdapter:IsResetWallClosed() and not NetworkGateway.IsCarryingEgg and (targetPos - hrp.Position).X > 0 then
            hum:MoveTo(hrp.Position)
            return false
        end

        char = GameContext.LocalPlayer.Character
        if not char then return false end
        hrp = char:FindFirstChild("HumanoidRootPart") :: BasePart?
        hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return false end

        local curPos = hrp.Position
        local diff = (targetPos - curPos) * Vector3.new(1, 0, 1)
        local dist = diff.Magnitude

        if dist <= distStop then
            hum:MoveTo(curPos)
            return true
        end

        local hasObstacle, steerPos = false, nil
        if dist > 8.0 then
            hasObstacle, steerPos = checkObstacleSensors(hrp, self:BuildObstacleRayParams(char))
        end
        local moveTarget = (hasObstacle and steerPos) or targetPos

        if os.clock() - lastMoveTo >= 0.1 or hasObstacle then
            hum:MoveTo(moveTarget)
            lastMoveTo = os.clock()
        end

        if os.clock() - lastStuckCheck >= 0.4 then
            if (curPos - lastStuckPos).Magnitude < 1.0 and dist > distStop then
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    hum.Jump = true
                    hum:MoveTo(moveTarget)
                end)
            end
            lastStuckPos = curPos
            lastStuckCheck = os.clock()
        end

        task.wait(0.04)
    end

    return true
end

function LocomotionController:MoveToTarget(targetPos: Vector3, stopDistance: number?, maxTimeout: number?, shouldCancel: (() -> boolean)?, exactTarget: boolean?): boolean
    local mode = State.MovementMode
    if mode == "Walk (Fast Pathing)" then
        return self:WalkTo(targetPos, stopDistance, maxTimeout, shouldCancel)
    else
        return self:GlideTo(targetPos, stopDistance, maxTimeout, shouldCancel, exactTarget)
    end
end

local StealFeature = {
    _failedEggCooldowns = {} :: { [string]: number },
    _lastCarriedPos = nil :: Vector3?,
}

function StealFeature:SpawnPostClaimActions()
    task.spawn(function()
        task.wait(0.2)
        if State.AutoHatchEgg and alive() then (Features :: any).Pets:HatchEggBatch() end
        task.wait(0.2)
        if State.AutoPlaceEgg and alive() then (Features :: any).Pets:PlaceEggBatch() end
        task.wait(0.2)
        if State.AutoFusePets and alive() then (Features :: any).Pets:FusePetsBatch() end
        task.wait(0.2)
        if State.AutoEquipBestPets and alive() then (Features :: any).Pets:EquipBestPets() end
        task.wait(0.2)
        if (State.AutoUpgradeBase or State.AutoUpgradeTreadmill) and alive() then (Features :: any).Economy:ExecuteAutoUpgrades() end
    end)
end

function StealFeature:SpawnSellBatch()
    task.spawn(function()
        task.wait(0.1)
        if alive() then (Features :: any).Economy:SellBatch() end
    end)
end

function StealFeature:Step()
    if not State.AutoSteal or not alive() then return end

    local char = GameContext.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
    if not hrp then
        task.wait(0.25)
        return
    end

    if not GameContext:EnsureModules() or not GameContext.Remotes or not GameContext.Remotes.EggWorld then
        task.wait(0.25)
        return
    end

    if PlotAdapter:IsResetWallClosed() then
        if not NetworkGateway.IsCarryingEgg and hrp and hrp.Position.X > 545 then
            local safePos = PlotAdapter:GetSafeZonePosition(hrp.Position)
            LocomotionController:MoveToTarget(safePos, 2.5, 5)
        end
        task.wait(1.0)
        return
    end

    if NetworkGateway.IsCarryingEgg and State.AutoDeliver and hrp then
        local safePos = PlotAdapter:GetSafeZonePosition(hrp.Position)
        LocomotionController:MoveToTarget(safePos, 2.0, 15)
        self:SpawnSellBatch()
        self:SpawnPostClaimActions()
        task.wait(0.1)
        return
    end

    if not NetworkGateway.IsCarryingEgg and hrp.Position.X < 520 then
        local frontCorridorPos = Vector3.new(530.0, hrp.Position.Y, hrp.Position.Z)
        LocomotionController:MoveToTarget(frontCorridorPos, 2.0, 5)
        char = GameContext.LocalPlayer.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
        if not hrp or not alive() then return end
    end

    local snapshot = NetworkGateway:GetFieldEggSnapshot()
    if not snapshot or not snapshot.Records then
        task.wait(0.1)
        return
    end

    char = GameContext.LocalPlayer.Character
    hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
    if not hrp or not alive() then return end

    local targetRecord: any = nil
    local bestTargetScore = -math.huge
    local myPos = hrp.Position

    local targetAreas = State.TargetAreas
    local targetRarities = State.TargetRarities
    local targetMutations = State.TargetMutations

    for _, record in pairs(snapshot.Records) do
        if record.State ~= "Slot" and record.State ~= "Dropped" then continue end
        if self._failedEggCooldowns[record.Uid] then
            if os.clock() < self._failedEggCooldowns[record.Uid] then
                continue
            else
                self._failedEggCooldowns[record.Uid] = nil
            end
        end

        local areaName = DataAdapter:ResolveRecordArea(record)
        if not matchesAreaLookup(areaName, targetAreas) then continue end

        local rarity = DataAdapter:ResolveRecordRarity(record)
        if not matchesRarityLookup(rarity, targetRarities) then continue end

        local eggMuts = DataAdapter:GetEggMutations(record)
        if not matchesMutationLookup(eggMuts, targetMutations) then continue end

        local cf = record.BottomCFrame or record.BoundsCFrame
        if cf then
            local eggPos = cf.Position
            if eggPos.X < 450 or eggPos.X > 5500 or eggPos.Y < -30 or eggPos.Y > 300 or eggPos.Z < -600 or eggPos.Z > -100 then
                continue
            end

            local dist = (eggPos - myPos).Magnitude
            local areaTier = AREA_TIER_RANK[areaName] or 1
            local rarityTier = RARITY_TIER_RANK[rarity] or 1
            local mutationBonus = DataAdapter:GetMutationBonus(record)
            local droppedBonus = (record.State == "Dropped") and 500 or 0

            local score = (areaTier * 150) + (rarityTier * 80) + mutationBonus + droppedBonus - (dist * 0.35)
            if score > bestTargetScore then
                bestTargetScore = score
                targetRecord = record
            end
        end
    end

    if targetRecord then
        local eggCFrame = targetRecord.BottomCFrame or targetRecord.BoundsCFrame
        if eggCFrame then
            local eggPos = eggCFrame.Position
            local slotKey: string? = nil
            if targetRecord.State == "Slot" and GameContext.AreaEggSlotIdentity then
                if GameContext.AreaEggSlotIdentity.SlotKey then
                    slotKey = GameContext.AreaEggSlotIdentity.SlotKey(targetRecord.AreaId, targetRecord.NestId)
                elseif GameContext.AreaEggSlotIdentity.BuildSlotKey then
                    slotKey = GameContext.AreaEggSlotIdentity.BuildSlotKey(targetRecord.AreaId, targetRecord.NestId)
                end
            end
            local targetUid = targetRecord.Uid

            char = GameContext.LocalPlayer.Character
            hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
            if not hrp or not alive() then return end

            local actualEggPos = eggPos
            local eggModel = (targetUid and GameContext.Workspace:FindFirstChild(targetUid))
                or (GameContext.Workspace:FindFirstChild("AreaEggSlotsClient") and GameContext.Workspace.AreaEggSlotsClient:FindFirstChild(targetUid))
            if eggModel and eggModel:IsA("Model") then
                actualEggPos = eggModel:GetPivot().Position
            end

            local eggGroundPos: Vector3
            local isExactTarget = false
            if targetRecord.State == "Slot" and targetRecord.BottomCFrame then
                eggGroundPos = targetRecord.BottomCFrame.Position + Vector3.new(0, 3.0, 0)
                isExactTarget = true
            else
                eggGroundPos = Vector3.new(actualEggPos.X, actualEggPos.Y + 3.0, actualEggPos.Z)
                isExactTarget = true
            end

            LocomotionController:MoveToTarget(eggGroundPos, 2.0, 30, function()
                if NetworkGateway.IsCarryingEgg or not State.AutoSteal or not alive() then return true end
                local c = GameContext.LocalPlayer.Character
                local h = c and c:FindFirstChild("HumanoidRootPart") :: BasePart?
                if h then
                    local d = (eggGroundPos - h.Position).Magnitude
                    if d <= 12.0 then
                        NetworkGateway:AskFieldEggCarry({
                            Uid = targetUid,
                            FirstAreaSlotKey = slotKey
                        })
                    end
                end
                return NetworkGateway.IsCarryingEgg == true
            end, isExactTarget)

            char = GameContext.LocalPlayer.Character
            hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
            if not hrp or not alive() then return end

            local horizDist = Vector2.new(eggGroundPos.X - hrp.Position.X, eggGroundPos.Z - hrp.Position.Z).Magnitude
            local totalDist = (eggGroundPos - hrp.Position).Magnitude
            if not NetworkGateway.IsCarryingEgg and (horizDist <= 12.0 and totalDist <= 16.0) then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum:UnequipTools() end

                local claimStart = os.clock()
                local claimNextAt = 0
                while State.AutoSteal and not NetworkGateway.IsCarryingEgg and os.clock() - claimStart < 1.2 and alive() do
                    local c = GameContext.LocalPlayer.Character
                    local root = c and c:FindFirstChild("HumanoidRootPart") :: BasePart?
                    if not root then break end

                    local rot2 = root.CFrame - root.Position
                    root.CFrame = rot2 + eggGroundPos
                    LocomotionController:FreezeHRP(root)

                    if os.clock() >= claimNextAt then
                        claimNextAt = os.clock() + 0.05
                        local success = NetworkGateway:AskFieldEggCarry({
                            Uid = targetUid,
                            FirstAreaSlotKey = slotKey
                        })
                        if success or NetworkGateway.IsCarryingEgg then
                            break
                        end
                    end
                    task.wait(0.01)
                end
            end

            if not NetworkGateway.IsCarryingEgg then
                self._failedEggCooldowns[targetUid] = os.clock() + 4
            else
                if State.AutoDeliver and State.AutoSteal then
                    local deliverTimeout = os.clock() + 35
                    local dropRetryCount = 0

                    while State.AutoSteal and os.clock() < deliverTimeout and alive() do
                        char = GameContext.LocalPlayer.Character
                        hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                        if not hrp or not hum or hum.Health <= 0 then break end

                        if not NetworkGateway.IsCarryingEgg and PlotAdapter:IsNearSafezoneOrStand(hrp) then
                            break
                        end

                        local safePos = PlotAdapter:GetSafeZonePosition(hrp.Position)

                        if NetworkGateway.IsCarryingEgg then
                            dropRetryCount = 0
                            self._lastCarriedPos = hrp.Position
                            LocomotionController:MoveToTarget(safePos, 2.0, 20, function()
                                local c = GameContext.LocalPlayer.Character
                                local h = c and c:FindFirstChild("HumanoidRootPart") :: BasePart?
                                if h then self._lastCarriedPos = h.Position end
                                return not NetworkGateway.IsCarryingEgg or not State.AutoSteal or (h and h.Position.X <= 530) or not alive()
                            end)
                        else

                            if not hrp then task.wait(0.01) continue end
                            hum.PlatformStand = false
                            hum.Sit = false
                            hum:ChangeState(Enum.HumanoidStateType.Running)

                            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                                local tName = string.lower(track.Name)
                                if string.find(tName, "ragdoll") or string.find(tName, "fall") or string.find(tName, "hit") or string.find(tName, "trip") then
                                    pcall(track.Stop, track, 0)
                                end
                            end

                            local dropUid = targetUid or NetworkGateway.LastStolenEggUid
                            local dropPos = self._lastCarriedPos or hrp.Position

                            local eggModel = dropUid and GameContext.Workspace:FindFirstChild(dropUid)
                            if eggModel and eggModel:IsA("Model") then
                                dropPos = eggModel:GetPivot().Position
                            end

                            local dropGround = Vector3.new(dropPos.X, hrp.Position.Y, dropPos.Z)

                            local success = NetworkGateway:AskFieldEggCarry({
                                Uid = dropUid or "",
                                FirstAreaSlotKey = nil
                            })

                            if not success then

                                task.wait(0.02)
                                success = NetworkGateway:AskFieldEggCarry({
                                    Uid = dropUid or "",
                                    FirstAreaSlotKey = nil
                                })
                            end

                            if not success and (hrp.Position - dropGround).Magnitude > 1.5 then
                                LocomotionController:MoveToTarget(dropGround, 1.0, 1.2, function()
                                    local c = GameContext.LocalPlayer.Character
                                    local h = c and c:FindFirstChild("HumanoidRootPart") :: BasePart?
                                    return NetworkGateway.IsCarryingEgg or not State.AutoSteal or (h and (dropGround - h.Position).Magnitude <= 3.0) or not alive()
                                end)
                                success = NetworkGateway:AskFieldEggCarry({
                                    Uid = dropUid or "",
                                    FirstAreaSlotKey = nil
                                })
                            end

                            if not success then
                                dropRetryCount = dropRetryCount + 1
                                if dropRetryCount > 8 then
                                    self._failedEggCooldowns[targetUid] = os.clock() + 4
                                    break
                                end
                                task.wait(0.05)
                            else
                                dropRetryCount = 0
                            end
                        end

                        task.wait(0.01)
                    end

                    if hrp and (PlotAdapter:IsNearSafezoneOrStand(hrp) or NetworkGateway.IsCarryingEgg) then
                        self:SpawnSellBatch()
                        self:SpawnPostClaimActions()
                    end
                end
            end
        end
        task.wait(math.max(0.05, State.StealDelay or 0.15))
    else
        char = GameContext.LocalPlayer.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
        if hrp and NetworkGateway.IsCarryingEgg and State.AutoDeliver and hrp.Position.X > 535 then
            local safePos = PlotAdapter:GetSafeZonePosition(hrp.Position)
            LocomotionController:MoveToTarget(safePos, 2.0, 10)
            self:SpawnSellBatch()
            self:SpawnPostClaimActions()
        end
        task.wait(0.3)
    end
end

Features = Features or {}
Features.Steal = StealFeature

local PetsFeature = {
    _isPlacingInProgress = false,
    _isHatchingInProgress = false,
    _isFusingInProgress = false,
}

function PetsFeature:PlaceEggBatch(forceRun: boolean?)
    if self._isPlacingInProgress or not alive() then return end
    if not forceRun and not State.AutoPlaceEgg then return end

    local char = GameContext.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?

    if not hrp or NetworkGateway.IsCarryingEgg then
        if forceRun and GameContext.Window and GameContext.Window.Notify then
            GameContext.Window:Notify("Place", "Cannot place eggs while carrying an egg!", 3)
        end
        return
    end

    local myPlot = PlotAdapter:GetMyPlot()
    if not myPlot or not myPlot.Model then return end

    local targetPlaceRarities = State.TargetPlaceRarities
    local unplacedEggs = DataAdapter:GetAllEggs(true)
    local eggsToPlace: { { uid: string, rarity: string } } = {}

    for _, egg in ipairs(unplacedEggs) do
        if matchesRarityLookup(egg.Rarity, targetPlaceRarities) then
            table.insert(eggsToPlace, { uid = egg.Uid, rarity = egg.Rarity })
        end
    end

    if #eggsToPlace == 0 then
        if forceRun and GameContext.Window and GameContext.Window.Notify then
            GameContext.Window:Notify("Place", "No unplaced eggs match your Place Rarities filter!", 3)
        end
        return
    end

    self._isPlacingInProgress = true
    local placedSuccessCount = 0

    local centerPoint: BasePart? = myPlot.CenterPoint or (myPlot.Model and myPlot.Model:FindFirstChild("SpawnPoint", true))
    local didStepToCenter = false
    local origCF = hrp.CFrame

    if centerPoint and (hrp.Position - centerPoint.Position).Magnitude > 28 then

        hrp.CFrame = centerPoint.CFrame + Vector3.new(0, 3, 0)
        didStepToCenter = true
        task.wait(0.08)
    end

    local data = DataAdapter:GetSaveData()
    local existingPositions: { Vector3 } = {}
    if data and data.EggInventory then
        for _, egg in pairs(data.EggInventory) do
            if egg.Placement and egg.Placement.LocalCFrame then
                local lcf = egg.Placement.LocalCFrame
                if typeof(lcf) == "table" and #lcf >= 3 then
                    table.insert(existingPositions, Vector3.new(lcf[1], lcf[2], lcf[3]))
                elseif typeof(lcf) == "CFrame" then
                    table.insert(existingPositions, lcf.Position)
                end
            end
        end
    end

    local function findFreeGridSpot(): CFrame
        for x = -14, 14, 3.5 do
            for z = -14, 14, 3.5 do
                local cand = Vector3.new(x, 0, z)
                local tooClose = false
                for _, ex in ipairs(existingPositions) do
                    if (cand - ex).Magnitude < 3.0 then
                        tooClose = true
                        break
                    end
                end
                if not tooClose then
                    table.insert(existingPositions, cand)
                    return CFrame.new(cand)
                end
            end
        end
        return CFrame.new((math.random() - 0.5) * 16, 0, (math.random() - 0.5) * 16)
    end

    for _, item in ipairs(eggsToPlace) do
        if not alive() then break end
        if not forceRun and not State.AutoPlaceEgg then break end

        local localCF = findFreeGridSpot()
        local placed = NetworkGateway:PlaceEgg(item.uid, localCF)
        if placed then
            placedSuccessCount = placedSuccessCount + 1
        end
        task.wait(0.08)
    end

    if didStepToCenter and alive() then
        local freshChar = GameContext.LocalPlayer.Character
        local freshHrp = freshChar and freshChar:FindFirstChild("HumanoidRootPart") :: BasePart?
        if freshHrp then
            freshHrp.CFrame = origCF
        end
    end

    if placedSuccessCount > 0 and forceRun then
        if GameContext.Window and GameContext.Window.Notify then
            GameContext.Window:Notify("Place", "Placed " .. tostring(placedSuccessCount) .. " Eggs in base!", 3)
        end
    end

    self._isPlacingInProgress = false
end

function PetsFeature:HatchEggBatch(forceRun: boolean?)
    if self._isHatchingInProgress or not alive() then return end
    if not forceRun and not State.AutoHatchEgg then return end

    local allEggs = DataAdapter:GetAllEggs(false)
    local autoHatchRarities = State.AutoHatchRarities
    local readyEggsToHatch: { { uid: string, category: string, rarity: string } } = {}

    for _, egg in ipairs(allEggs) do
        if egg.IsPlaced and egg.IsReadyToHatch then
            if matchesRarityLookup(egg.Rarity, autoHatchRarities) then
                table.insert(readyEggsToHatch, { uid = egg.Uid, category = egg.DisplayName, rarity = egg.Rarity })
            end
        end
    end

    if #readyEggsToHatch == 0 then
        if forceRun and GameContext.Window and GameContext.Window.Notify then
            GameContext.Window:Notify("Hatch", "No placed eggs are currently ready to hatch!", 3)
        end
        return
    end

    self._isHatchingInProgress = true
    local hatchedCount = 0

    for _, eggInfo in ipairs(readyEggsToHatch) do
        if not alive() then break end
        if not forceRun and not State.AutoHatchEgg then break end

        local hatched = NetworkGateway:HatchEgg(eggInfo.uid)
        if hatched then
            hatchedCount = hatchedCount + 1
        end
        task.wait(0.12)
    end

    if hatchedCount > 0 then
        if forceRun and GameContext.Window and GameContext.Window.Notify then
            GameContext.Window:Notify("Hatch", "Auto Hatched " .. tostring(hatchedCount) .. " Ready Eggs!", 3)
        end
        if State.AutoFusePets or State.AutoEquipBestPets or State.AutoSellPets then
            task.spawn(function()
                task.wait(0.25)
                if State.AutoFusePets and alive() then
                    self:FusePetsBatch()
                    task.wait(0.25)
                end
                if State.AutoEquipBestPets and alive() then
                    self:EquipBestPets()
                    task.wait(0.25)
                end
                if State.AutoSellPets and alive() then
                    (Features :: any).Economy:SellBatch()
                end
            end)
        end
    end

    self._isHatchingInProgress = false
end

function PetsFeature:FusePetsBatch(forceRun: boolean?)
    if self._isFusingInProgress or not alive() then return end
    if not forceRun and not State.AutoFusePets then return end

    local data = DataAdapter:GetSaveData()
    if not data or not data.Inventory then return end

    self._isFusingInProgress = true

    if data.FusionSlots and #data.FusionSlots > 0 then
        for _, uid in ipairs(data.FusionSlots) do
            NetworkGateway:EjectFusePet(uid)
        end
        task.wait(0.15)
        local fresh = DataAdapter:GetSaveData()
        if fresh then data = fresh end
    end

    local allPets = DataAdapter:GetAllPets(false)
    local autoFuseRarities = State.AutoFuseRarities
    local categoryGroups: { [string]: { unequipped: { string }, equipped: { string }, rarity: string } } = {}

    for _, pet in ipairs(allPets) do
        if not pet.IsLocked and not pet.InFuse and not pet.IsFavorite then
            local assetConf = DataAdapter:GetAssetEntry(pet.Category)
            if not (assetConf and assetConf.CannotFuse == true) then
                if matchesRarityLookup(pet.Rarity, autoFuseRarities) then
                    local catKey = pet.Category
                    categoryGroups[catKey] = categoryGroups[catKey] or { unequipped = {}, equipped = {}, rarity = pet.Rarity }
                    if pet.IsEquipped then
                        table.insert(categoryGroups[catKey].equipped, pet.Uid)
                    else
                        table.insert(categoryGroups[catKey].unequipped, pet.Uid)
                    end
                end
            end
        end
    end

    local fusedCount = 0
    for _, group in pairs(categoryGroups) do
        if not alive() then break end
        local totalAvailable = #group.unequipped + #group.equipped
        while totalAvailable >= 3 do
            if not alive() then break end
            if not forceRun and not State.AutoFusePets then break end

            local fuseUids: { string } = {}
            while #fuseUids < 3 and #group.unequipped > 0 do
                table.insert(fuseUids, table.remove(group.unequipped, 1))
            end
            while #fuseUids < 3 and #group.equipped > 0 do
                local eqUid = table.remove(group.equipped, 1)
                NetworkGateway:DoffPet(eqUid)
                table.insert(fuseUids, eqUid)
            end

            if #fuseUids < 3 then break end

            local l1 = NetworkGateway:LoadFusePet(fuseUids[1])
            task.wait(0.08)
            local l2 = NetworkGateway:LoadFusePet(fuseUids[2])
            task.wait(0.08)
            local l3 = NetworkGateway:LoadFusePet(fuseUids[3])
            task.wait(0.12)

            if l1 and l2 and l3 then
                local fuseSuccess = NetworkGateway:BeginFuse()
                if fuseSuccess then
                    fusedCount = fusedCount + 1
                    task.wait(0.4)
                    NetworkGateway:FinishRevealFuse()
                else
                    NetworkGateway:EjectFusePet(fuseUids[1])
                    NetworkGateway:EjectFusePet(fuseUids[2])
                    NetworkGateway:EjectFusePet(fuseUids[3])
                    break
                end
            else
                NetworkGateway:EjectFusePet(fuseUids[1])
                NetworkGateway:EjectFusePet(fuseUids[2])
                NetworkGateway:EjectFusePet(fuseUids[3])
                break
            end

            totalAvailable = #group.unequipped + #group.equipped
            task.wait(0.2)
        end
    end

    if fusedCount > 0 then
        if State.AutoEquipBestPets then
            task.spawn(function() self:EquipBestPets() end)
        end
        if GameContext.Window and GameContext.Window.Notify then
            GameContext.Window:Notify("Fuse", "Auto Fused " .. tostring(fusedCount) .. " Pet Sets (3x)!", 3)
        end
    elseif forceRun and GameContext.Window and GameContext.Window.Notify then
        GameContext.Window:Notify("Fuse", "No sets of 3x identical unfused pets available!", 3)
    end

    self._isFusingInProgress = false
end

function PetsFeature:EquipBestPets()
    NetworkGateway:EquipBestPets()
end

Features = Features or {}
Features.Pets = PetsFeature

local EconomyFeature = {
    _isSellingInProgress = false,
    _isUpgradingInProgress = false,
}

function EconomyFeature:TrailStep()
    if not alive() then return end
    local data = DataAdapter:GetSaveData()
    if not data then return end
    local money: number = data.Money or 0
    local owned: { [string]: boolean } = data.TrailInventory or {}
    local equipped: string? = data.EquippedTrail

    if State.AutoBuyTrail and GameContext.TrailsDirectory and GameContext.TrailsDirectory.Directory then
        local bestBuyId: string? = nil
        local bestBuyMult = 0
        for id, info in pairs(GameContext.TrailsDirectory.Directory) do
            if not owned[id] and info.Price and info.Price <= money then
                local mult = info.SpeedMultiplier or 0
                if mult > bestBuyMult then
                    bestBuyMult = mult
                    bestBuyId = id
                end
            end
        end
        if bestBuyId then
            NetworkGateway:BuyTrail(bestBuyId)
            local displayName = GameContext.TrailsDirectory.Directory[bestBuyId].DisplayName or bestBuyId
            if GameContext.Window and GameContext.Window.Notify then
                GameContext.Window:Notify("Shop", "Auto Purchased: " .. displayName, 3)
            end
            task.wait(0.5)
        end
    end

    if State.AutoEquipBestTrail and GameContext.TrailsDirectory and GameContext.TrailsDirectory.Directory then
        local bestEquipId: string? = nil
        local bestEquipMult = 0
        for id, isOwned in pairs(owned) do
            if isOwned then
                local info = GameContext.TrailsDirectory.Directory[id]
                if info then
                    local mult = info.SpeedMultiplier or 0
                    if mult > bestEquipMult then
                        bestEquipMult = mult
                        bestEquipId = id
                    end
                end
            end
        end
        if bestEquipId and bestEquipId ~= equipped then
            NetworkGateway:EquipTrail(bestEquipId)
            local displayName = GameContext.TrailsDirectory.Directory[bestEquipId].DisplayName or bestEquipId
            if GameContext.Window and GameContext.Window.Notify then
                GameContext.Window:Notify("Shop", "Auto Equipped Best: " .. displayName, 3)
            end
        end
    end
end

function EconomyFeature:SellBatch(forcePets: boolean?, forceEggs: boolean?)
    if self._isSellingInProgress or not alive() then return end
    if not forcePets and not forceEggs and not State.AutoSellPets and not State.AutoSellEggs then return end

    local char = GameContext.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
    if not hrp or NetworkGateway.IsCarryingEgg then return end

    self._isSellingInProgress = true

    if forcePets or State.AutoSellPets then
        local petSellLookup = State.AutoSellRarities

        local unequippedPets = DataAdapter:GetAllPets(true)
        local petsToSell: { { uid: string, rarity: string, name: string } } = {}

        for _, pet in ipairs(unequippedPets) do
            if not forcePets and not State.AutoSellPets then break end
            if not pet.IsFavorite and not pet.InFuse and not pet.IsLocked and not pet.HasMutation then
                if matchesSellRarityLookup(pet.Rarity, petSellLookup) then
                    table.insert(petsToSell, { uid = pet.Uid, rarity = pet.Rarity, name = pet.DisplayName })
                end
            end
        end

        if #petsToSell > 0 then
            local soldCount = 0
            for _, petInfo in ipairs(petsToSell) do
                if not alive() then break end
                if not forcePets and not State.AutoSellPets then break end
                local success = NetworkGateway:SellPet(petInfo.uid)
                if success then
                    soldCount = soldCount + 1
                end
                task.wait(0.08)
            end
            if soldCount > 0 and GameContext.Window and GameContext.Window.Notify then
                GameContext.Window:Notify("Sell", "Auto Sold " .. tostring(soldCount) .. " Filtered Pets!", 2)
            end
        elseif forcePets and GameContext.Window and GameContext.Window.Notify then
            GameContext.Window:Notify("Sell", "No unequipped pets match your selected Pet Sell Rarities!", 3)
        end
    end

    if forceEggs or State.AutoSellEggs then
        local eggSellLookup = State.AutoSellEggRarities

        if not eggSellLookup or isLookupEmpty(eggSellLookup) then
            if forceEggs and GameContext.Window and GameContext.Window.Notify then
                GameContext.Window:Notify("Sell", "No Egg Sell Rarities selected in filter!", 3)
            end
            self._isSellingInProgress = false
            return
        end

        local standPrompts = GameContext.Workspace:FindFirstChild("Stands") and GameContext.Workspace.Stands:FindFirstChild("Prompts")
        local sellPart = standPrompts and standPrompts:FindFirstChild("SellHeldAsset") :: BasePart?
        local standPrompt = sellPart and sellPart:FindFirstChildOfClass("ProximityPrompt")

        local isNearStand = hrp and sellPart and ((hrp.Position - sellPart.Position).Magnitude <= 35 or PlotAdapter:IsNearSafezoneOrStand(hrp))
        if not isNearStand then
            if forceEggs and GameContext.Window and GameContext.Window.Notify then
                GameContext.Window:Notify("Sell", "Must be physically near the Sell Stand to sell eggs!", 3)
            end
            self._isSellingInProgress = false
            return
        end

        local unplacedEggs = DataAdapter:GetAllEggs(true)
        local eggsToSell: { { uid: string, rarity: string, name: string } } = {}

        for _, egg in ipairs(unplacedEggs) do
            if not forceEggs and not State.AutoSellEggs then break end
            if not egg.IsFavorite and not egg.HasMutation then
                if matchesSellRarityLookup(egg.Rarity, eggSellLookup) then
                    table.insert(eggsToSell, { uid = egg.Uid, rarity = egg.Rarity, name = egg.DisplayName })
                end
            end
        end

        if #eggsToSell > 0 and standPrompt then
            local soldEggCount = 0

            for _, eggInfo in ipairs(eggsToSell) do
                if not alive() then break end
                if not forceEggs and not State.AutoSellEggs then break end
                local wearOk = NetworkGateway:WearEggTool(eggInfo.uid)
                if wearOk then
                    task.wait(0.12)
                    local fpp = (fireproximityprompt :: any)
                    if typeof(fpp) == "function" then
                        fpp(standPrompt, 0)
                    else
                        standPrompt:InputHoldBegin()
                        task.wait(0.05)
                        standPrompt:InputHoldEnd()
                    end
                    task.wait(0.08)

                    local pgui = GameContext.LocalPlayer:FindFirstChild("PlayerGui")
                    local messageGui = pgui and pgui:FindFirstChild("Message")
                    if messageGui and (messageGui :: any).Enabled then
                        local frame = messageGui:FindFirstChild("Frame")
                        local contents = frame and frame:FindFirstChild("Contents")
                        local yesBtn = contents and contents:FindFirstChild("Yes") :: any
                        if yesBtn then
                            local fs = (firesignal :: any)
                            if typeof(fs) == "function" then
                                fs(yesBtn.Activated)
                            end
                            local gc = (getconnections :: any)
                            if typeof(gc) == "function" then
                                for _, c in ipairs(gc(yesBtn.Activated)) do
                                    if c.Fire then c:Fire() elseif c.Function then pcall(c.Function) end
                                end
                            end
                        end
                    end

                    task.wait(0.25)
                    soldEggCount = soldEggCount + 1
                end
            end

            NetworkGateway:DoffEggTool()
            if soldEggCount > 0 and GameContext.Window and GameContext.Window.Notify then
                GameContext.Window:Notify("Sell", "Auto Sold " .. tostring(soldEggCount) .. " Filtered Eggs!", 2)
            end
        elseif forceEggs and GameContext.Window and GameContext.Window.Notify then
            GameContext.Window:Notify("Sell", "No unplaced eggs match your selected Egg Sell Rarities!", 3)
        end
    end

    self._isSellingInProgress = false
end

function EconomyFeature:ExecuteAutoUpgrades()
    if self._isUpgradingInProgress or not alive() then return end
    if not State.AutoUpgradeBase and not State.AutoUpgradeTreadmill then return end

    local data = DataAdapter:GetSaveData()
    if not data then return end

    self._isUpgradingInProgress = true

    if State.AutoUpgradeBase and GameContext.BasesDirectory and GameContext.BasesDirectory.BASES then
        local currentLvl = data.BaseUpgradeLevel or 0
        local nextLvl = currentLvl + 1
        local nextBaseConfig = GameContext.BasesDirectory.BASES[nextLvl]
        if nextBaseConfig and nextBaseConfig.Cost and data.Money and data.Money >= nextBaseConfig.Cost then
            NetworkGateway:UpgradeBase()
            if GameContext.Window and GameContext.Window.Notify then
                GameContext.Window:Notify("Upgrade", "Upgraded Base to Level " .. tostring(nextLvl) .. "!", 3)
            end
            task.wait(0.4)
        end
    end

    if State.AutoUpgradeTreadmill and GameContext.TreadmillsDirectory and GameContext.TreadmillsDirectory.GetByUpgradeLevel then
        local currentLvl = data.TreadmillUpgradeLevel or 0
        local nextLvl = currentLvl + 1
        local nextTreadmillConfig = GameContext.TreadmillsDirectory.GetByUpgradeLevel(nextLvl)
        if nextTreadmillConfig and nextTreadmillConfig.Price and data.Money and data.Money >= nextTreadmillConfig.Price then
            local success = NetworkGateway:UpgradeTreadmill(nextTreadmillConfig._id)
            if success and GameContext.Window and GameContext.Window.Notify then
                GameContext.Window:Notify("Upgrade", "Upgraded Treadmill to Level " .. tostring(nextLvl) .. "!", 3)
            end
            task.wait(0.4)
        end
    end

    self._isUpgradingInProgress = false
end

function EconomyFeature:TrainTreadmill()
    if State.AutoSteal or NetworkGateway.IsCarryingEgg or not alive() then return end
    if not GameContext.Remotes or not GameContext.Remotes.Treadmill then return end

    local plot = PlotAdapter:GetMyPlot()
    if not plot or not plot.TreadmillBottom then return end

    local char = GameContext.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    local targetPos = plot.TreadmillBottom.Position + Vector3.new(0, 3.5, 0)
    local dist = (hrp.Position - targetPos).Magnitude

    if dist > 3.0 then
        LocomotionController:MoveToTarget(targetPos, 1.5, 15, function()
            return not State.AutoTrainTreadmill or State.AutoSteal or NetworkGateway.IsCarryingEgg or not alive()
        end, true)
        task.wait(0.2)
    end

    char = GameContext.LocalPlayer.Character
    hrp = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
    if hrp and (hrp.Position - targetPos).Magnitude <= 4.5 then
        NetworkGateway:WearStillTreadmill()
    end
end

Features = Features or {}
Features.Economy = EconomyFeature

local UtilityFeature = {
    _antiAfkConn = nil :: RBXScriptConnection?,
    _originalLighting = {} :: { [string]: any },
    _fpsMaterials = nil :: { [BasePart]: Enum.Material }?,
    _fpsShadow = nil :: { [BasePart]: boolean }?,
    _fpsMeshTextures = nil :: { [MeshPart]: string }?,
    _fpsReparent = nil :: { [Instance]: Instance }?,
    _fpsTransparencies = nil :: { [Instance]: number }?,
    _fpsDisabled = nil :: { [Instance]: boolean }?,
    _fpsBoostConn = nil :: RBXScriptConnection?,
}

function UtilityFeature:SetAntiAfk(enabled: boolean)
    if enabled then
        if not self._antiAfkConn then
            self._antiAfkConn = RootJanitor:SafeConnect(GameContext.LocalPlayer.Idled, function()
                pcall(function()
                    local cam = GameContext.Workspace.CurrentCamera
                    if cam then
                        local orig = cam.CFrame
                        cam.CFrame = orig * CFrame.Angles(0, 0.0001, 0)
                        task.defer(function() cam.CFrame = orig end)
                    end
                end)
            end)
        end
    else
        if self._antiAfkConn then
            self._antiAfkConn:Disconnect()
            self._antiAfkConn = nil
        end
    end
end

function UtilityFeature:SetFpsBoost(enabled: boolean)
    if enabled then
        pcall(function()
            local lighting = GameContext.Lighting
            self._originalLighting.GlobalShadows = lighting.GlobalShadows
            self._originalLighting.FogEnd = lighting.FogEnd
            self._originalLighting.FogStart = lighting.FogStart
            self._originalLighting.EnvironmentDiffuseScale = lighting.EnvironmentDiffuseScale
            self._originalLighting.EnvironmentSpecularScale = lighting.EnvironmentSpecularScale

            lighting.GlobalShadows = false
            lighting.FogEnd = 999999
            lighting.FogStart = 999998
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

            for _, v in ipairs(lighting:GetDescendants()) do
                self:ProcessFpsBoostInstance(v)
            end
            for _, v in ipairs(GameContext.Workspace:GetDescendants()) do
                self:ProcessFpsBoostInstance(v)
            end

            if not self._fpsBoostConn then
                self._fpsBoostConn = GameContext.Workspace.DescendantAdded:Connect(function(obj: Instance)
                    if State.FpsBoost then
                        self:ProcessFpsBoostInstance(obj)
                    end
                end)
            end
        end)
    else
        pcall(function()
            local lighting = GameContext.Lighting
            if self._fpsBoostConn then
                self._fpsBoostConn:Disconnect()
                self._fpsBoostConn = nil
            end

            if self._originalLighting.GlobalShadows ~= nil then
                lighting.GlobalShadows = self._originalLighting.GlobalShadows
                lighting.FogEnd = self._originalLighting.FogEnd
                lighting.FogStart = self._originalLighting.FogStart
                lighting.EnvironmentDiffuseScale = self._originalLighting.EnvironmentDiffuseScale
                lighting.EnvironmentSpecularScale = self._originalLighting.EnvironmentSpecularScale
            end

            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic

            for part, mat in pairs(self._fpsMaterials or {}) do
                if part and part.Parent then
                    part.Material = mat
                    if self._fpsShadow and self._fpsShadow[part] ~= nil then part.CastShadow = self._fpsShadow[part] end
                end
            end
            for mesh, tex in pairs(self._fpsMeshTextures or {}) do
                if mesh and mesh.Parent then mesh.TextureID = tex end
            end
            for sa, parent in pairs(self._fpsReparent or {}) do
                if sa and parent and parent.Parent then sa.Parent = parent end
            end
            for decal, trans in pairs(self._fpsTransparencies or {}) do
                if decal and decal.Parent then decal.Transparency = trans end
            end
            for effect, _ in pairs(self._fpsDisabled or {}) do
                if effect and effect.Parent then pcall(function() (effect :: any).Enabled = true end) end
            end

            self._fpsMaterials = nil
            self._fpsShadow = nil
            self._fpsMeshTextures = nil
            self._fpsReparent = nil
            self._fpsTransparencies = nil
            self._fpsDisabled = nil
        end)
    end
end

function UtilityFeature:ProcessFpsBoostInstance(obj: Instance)
    if obj:IsA("BasePart") then
        if not (self._fpsMaterials or {})[obj] then
            self._fpsMaterials = self._fpsMaterials or setmetatable({}, { __mode = "k" }) :: any
            self._fpsShadow = self._fpsShadow or setmetatable({}, { __mode = "k" }) :: any
            ;(self._fpsMaterials :: any)[obj] = obj.Material
            ;(self._fpsShadow :: any)[obj] = obj.CastShadow
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
        end
        if obj:IsA("MeshPart") and obj.TextureID ~= "" then
            if not (self._fpsMeshTextures or {})[obj] then
                self._fpsMeshTextures = self._fpsMeshTextures or setmetatable({}, { __mode = "k" }) :: any
                ;(self._fpsMeshTextures :: any)[obj] = obj.TextureID
                obj.TextureID = ""
            end
        end
    elseif obj:IsA("SurfaceAppearance") or obj:IsA("Clouds") or obj:IsA("Sky") then
        if not (self._fpsReparent or {})[obj] and obj.Parent then
            self._fpsReparent = self._fpsReparent or setmetatable({}, { __mode = "k" }) :: any
            ;(self._fpsReparent :: any)[obj] = obj.Parent
            obj.Parent = nil
        end
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        if not (self._fpsTransparencies or {})[obj] then
            self._fpsTransparencies = self._fpsTransparencies or setmetatable({}, { __mode = "k" }) :: any
            ;(self._fpsTransparencies :: any)[obj] = obj.Transparency
            obj.Transparency = 1
        end
    elseif obj:IsA("PostEffect") or obj:IsA("Atmosphere") or
           obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or
           obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Light") or obj:IsA("Highlight") then
        if (obj :: any).Enabled then
            self._fpsDisabled = self._fpsDisabled or setmetatable({}, { __mode = "k" }) :: any
            ;(self._fpsDisabled :: any)[obj] = true
            ;(obj :: any).Enabled = false
        end
    end
end

function UtilityFeature:RejoinServer()
    local success = pcall(function()
        GameContext.TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            game.JobId,
            GameContext.LocalPlayer
        )
    end)
    if not success then
        pcall(function()
            GameContext.TeleportService:Teleport(game.PlaceId, GameContext.LocalPlayer)
        end)
    end
end

Features = Features or {}
Features.Utility = UtilityFeature

local function acquireUi(): any?
    if type(_G.ValincUi) == "table" then
        return _G.ValincUi
    end

    local ui: any = nil
    local ok, code = SecureHttpGet(CDN_UI_URL)
    if ok and code and #code > 0 then
        local f = loadstring(code)
        if f then
            ui = f()
            if type(ui) == "table" then
                _G.ValincUi = ui
            end
        end
    end

    return ui
end

local function safeSetClipboard(text: string)
    pcall(function()
        local fn = (setclipboard :: any) or (toclipboard :: any) or (set_clipboard :: any) or (Clipboard and (Clipboard :: any).set)
        if type(fn) == "function" then
            fn(text)
        end
    end)
end

function MountUI()
    local ValincUi = acquireUi()
    if not ValincUi then
        warn("[Valinc UI] Gagal memuat library UI Quartz dari CDN.")
        return
    end

    local Window = ValincUi.CreateWindow(SCRIPT_CONFIG)
    GameContext.Window = Window
    RootJanitor:TrackInstance(Window)

    local tabListLayout = Window.TabList and Window.TabList:FindFirstChildOfClass("UIListLayout")
    if tabListLayout then
        tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    end

    local Watermark = Window:Watermark()
    RootJanitor:TrackInstance(Watermark)

    local infoTab = Window:CreateTab("Info", "info", "navigation")

    local infoSection = infoTab:CreateSection("Information")
    infoSection:CreateLabel("VALINC SYNDICATE - Steal An Egg")
    infoSection:CreateButton("Copy Website URL", function()
        safeSetClipboard("https://valincsyndicate.com")
        Window:Notify("System", "Website URL copied to clipboard!", 3)
    end)

    local creditsSection = infoTab:CreateSection("Credits")
    creditsSection:CreateLabel("Developer: VALINC SYNDICATE")

    local settingsSection = infoTab:CreateSection("Menu Settings")
    settingsSection:CreateButton("Unload Script", function()
        rootCleanup()
    end)

    local autoTab = Window:CreateTab("Automatic", "bot", "modules")

    local stealSec = autoTab:CreateSection("Auto Steal Egg")
    stealSec:CreateToggle("Auto Steal Egg", false, function(enabled: boolean)
        State.AutoSteal = enabled
        LocomotionController:ApplyStealProtection(enabled)
        if enabled then
            NetworkGateway:EnsureListeners()
        end
        Window:Notify("Steal", "Auto Steal Egg: " .. tostring(enabled) .. (enabled and " (Kekebalan Aktif)" or ""), 2)
    end)

    local movementOptions = {
        "Glide Lerp (Smooth & Fast)",
        "Walk (Fast Pathing)"
    }
    stealSec:CreateDropdown("Movement Mode", movementOptions, "Glide Lerp (Smooth & Fast)", function(value: string)
        State.MovementMode = value
        Window:Notify("Steal", "Movement Mode: " .. tostring(value), 2)
    end)

    stealSec:CreateSlider("Glide Speed", 50, 1000, State.GlideSpeed or 275, false, function(value: number)
        State.GlideSpeed = value
    end)

    local areaOptions = {
        "Forest", "Lake", "Desert", "Jungle", "Snow", "Volcano",
        "Abyss Ocean", "Prehistoric", "Cosmic", "Cherry Blossom", "Titan Temple"
    }
    stealSec:CreateMultiDropdown("Target Area", areaOptions, DEFAULT_AREAS, function(selectedList: { string })
        State.TargetAreas = listToLookup(selectedList)
        Window:Notify("Target", "Areas: " .. table.concat(selectedList, ", "), 2)
    end)

    local rarityOptions = DEFAULT_RARITIES
    stealSec:CreateMultiDropdown("Target Rarity", rarityOptions, DEFAULT_RARITIES, function(selectedList: { string })
        State.TargetRarities = listToLookup(selectedList)
        Window:Notify("Target", "Rarities: " .. table.concat(selectedList, ", "), 2)
    end)

    local mutationOptions = DEFAULT_MUTATIONS
    stealSec:CreateMultiDropdown("Target Mutation", mutationOptions, DEFAULT_MUTATIONS, function(selectedList: { string })
        State.TargetMutations = listToLookup(selectedList)
        Window:Notify("Target", "Mutations: " .. table.concat(selectedList, ", "), 2)
    end)

    stealSec:CreateToggle("Auto Return to Safezone", true, function(enabled: boolean)
        State.AutoDeliver = enabled
        Window:Notify("Steal", "Auto Return to Safezone: " .. tostring(enabled), 2)
    end)

    local trainSec = autoTab:CreateSection("Auto Training (Treadmill)")
    trainSec:CreateToggle("Auto Train Treadmill", false, function(enabled: boolean)
        State.AutoTrainTreadmill = enabled
        Window:Notify("Train", "Auto Train Treadmill: " .. tostring(enabled), 2)
    end)

    local petsTab = Window:CreateTab("Pets", "egg", "modules")

    local placeSec = petsTab:CreateSection("Auto Place Egg")
    placeSec:CreateToggle("Auto Place Egg", false, function(enabled: boolean)
        State.AutoPlaceEgg = enabled
        if enabled then
            task.spawn(function()
                Features.Pets:PlaceEggBatch(true)
            end)
        end
        Window:Notify("Place", "Auto Place Egg: " .. tostring(enabled), 2)
    end)

    placeSec:CreateMultiDropdown("Target Place Rarities", rarityOptions, DEFAULT_RARITIES, function(selectedList: { string })
        State.TargetPlaceRarities = listToLookup(selectedList)
        Window:Notify("Place", "Place Rarities: " .. table.concat(selectedList, ", "), 2)
    end)

    placeSec:CreateButton("Place All Eggs Now", function()
        task.spawn(function()
            Window:Notify("Place", "Placing eggs in base...", 2)
            Features.Pets:PlaceEggBatch(true)
        end)
    end)

    local hatchSec = petsTab:CreateSection("Auto Hatch Egg")
    hatchSec:CreateToggle("Auto Hatch Ready Eggs", false, function(enabled: boolean)
        State.AutoHatchEgg = enabled
        if enabled then
            task.spawn(function()
                Features.Pets:HatchEggBatch(true)
            end)
        end
        Window:Notify("Hatch", "Auto Hatch: " .. tostring(enabled), 2)
    end)

    hatchSec:CreateMultiDropdown("Target Hatch Rarities", rarityOptions, DEFAULT_RARITIES, function(selectedList: { string })
        State.AutoHatchRarities = listToLookup(selectedList)
        Window:Notify("Hatch", "Hatch Rarities: " .. table.concat(selectedList, ", "), 2)
    end)

    hatchSec:CreateButton("Hatch All Ready Eggs Now", function()
        task.spawn(function()
            Window:Notify("Hatch", "Hatching all ready eggs...", 2)
            Features.Pets:HatchEggBatch(true)
        end)
    end)

    local petSec = petsTab:CreateSection("Pet Management")
    petSec:CreateToggle("Auto Equip Best Pets", false, function(enabled: boolean)
        State.AutoEquipBestPets = enabled
        if enabled then Features.Pets:EquipBestPets() end
        Window:Notify("Pets", "Auto Equip Best Pets: " .. tostring(enabled), 2)
    end)

    petSec:CreateButton("Equip Best Pets Now", function()
        task.spawn(function()
            Features.Pets:EquipBestPets()
            Window:Notify("Pets", "Equipped best pets!", 2)
        end)
    end)

    local fuseSec = petsTab:CreateSection("Auto Fuse Pets")
    fuseSec:CreateToggle("Auto Fuse Pets (3x Same)", false, function(enabled: boolean)
        State.AutoFusePets = enabled
        if enabled then
            task.spawn(function()
                Features.Pets:FusePetsBatch(true)
            end)
        end
        Window:Notify("Fuse", "Auto Fuse Pets: " .. tostring(enabled), 2)
    end)

    fuseSec:CreateMultiDropdown("Target Fuse Rarities", rarityOptions, DEFAULT_RARITIES, function(selectedList: { string })
        State.AutoFuseRarities = listToLookup(selectedList)
        Window:Notify("Fuse", "Fuse Rarities: " .. table.concat(selectedList, ", "), 2)
    end)

    fuseSec:CreateButton("Fuse 3x Pets Now", function()
        task.spawn(function()
            Window:Notify("Fuse", "Scanning & fusing 3x identical pets...", 2)
            Features.Pets:FusePetsBatch(true)
        end)
    end)

    local sellSec = petsTab:CreateSection("Auto Sell Settings (Zero-Loss Protected)")
    sellSec:CreateToggle("Auto Sell Pets", false, function(enabled: boolean)
        State.AutoSellPets = enabled
        if GameContext.Remotes and GameContext.Remotes.Haul then
            local currentPetSellRarities = State.AutoSellRarities or {}
            NetworkGateway:WriteAutoSell(currentPetSellRarities)
        end
        Window:Notify("Sell", "Auto Sell Pets: " .. tostring(enabled), 2)
    end)

    sellSec:CreateMultiDropdown("Target Pet Sell Rarities", rarityOptions, DEFAULT_SELL_RARITIES, function(selectedList: { string })
        State.AutoSellRarities = listToLookup(selectedList)
        Window:Notify("Sell", "Pet Sell Rarities: " .. table.concat(selectedList, ", "), 2)
    end)

    sellSec:CreateToggle("Auto Sell Eggs", false, function(enabled: boolean)
        State.AutoSellEggs = enabled
        if enabled then
            task.spawn(function()
                Features.Economy:SellBatch(false, true)
            end)
        end
        Window:Notify("Sell", "Auto Sell Eggs: " .. tostring(enabled), 2)
    end)

    sellSec:CreateMultiDropdown("Target Egg Sell Rarities", rarityOptions, DEFAULT_SELL_EGG_RARITIES, function(selectedList: { string })
        State.AutoSellEggRarities = listToLookup(selectedList)
        Window:Notify("Sell", "Egg Sell Rarities: " .. table.concat(selectedList, ", "), 2)
    end)

    sellSec:CreateButton("Sell Filtered Pets Now", function()
        task.spawn(function()
            Window:Notify("Sell", "Selling filtered pets...", 2)
            Features.Economy:SellBatch(true, false)
        end)
    end)

    sellSec:CreateButton("Sell Filtered Eggs Now", function()
        task.spawn(function()
            Window:Notify("Sell", "Selling filtered eggs at stand...", 2)
            Features.Economy:SellBatch(false, true)
        end)
    end)

    local shopTab = Window:CreateTab("Shop", "shopping-bag", "modules")

    local upgradeSec = shopTab:CreateSection("Base & Treadmill Upgrades")
    upgradeSec:CreateToggle("Auto Upgrade Base", false, function(enabled: boolean)
        State.AutoUpgradeBase = enabled
        if enabled then
            task.spawn(function()
                Features.Economy:ExecuteAutoUpgrades()
            end)
        end
        Window:Notify("Shop", "Auto Upgrade Base: " .. tostring(enabled), 2)
    end)

    upgradeSec:CreateToggle("Auto Upgrade Treadmill", false, function(enabled: boolean)
        State.AutoUpgradeTreadmill = enabled
        if enabled then
            task.spawn(function()
                Features.Economy:ExecuteAutoUpgrades()
            end)
        end
        Window:Notify("Shop", "Auto Upgrade Treadmill: " .. tostring(enabled), 2)
    end)

    local trailShopSec = shopTab:CreateSection("Trails Shop")
    trailShopSec:CreateToggle("Auto Buy Trail", false, function(enabled: boolean)
        State.AutoBuyTrail = enabled
        if enabled then
            task.spawn(function()
                Features.Economy:TrailStep()
            end)
        end
        Window:Notify("Shop", "Auto Buy Trail: " .. tostring(enabled), 2)
    end)

    trailShopSec:CreateToggle("Auto Equip Best Trail", false, function(enabled: boolean)
        State.AutoEquipBestTrail = enabled
        if enabled then
            task.spawn(function()
                Features.Economy:TrailStep()
            end)
        end
        Window:Notify("Shop", "Auto Equip Best Trail: " .. tostring(enabled), 2)
    end)

    local miscTab = Window:CreateTab("Misc", "settings", "modules")

    local miscSec = miscTab:CreateSection("General")
    miscSec:CreateToggle("Anti AFK", false, function(enabled: boolean)
        State.AntiAfk = enabled
        Features.Utility:SetAntiAfk(enabled)
        Window:Notify("Misc", "Anti AFK: " .. tostring(enabled), 2)
    end)

    miscSec:CreateToggle("FPS Boosts", false, function(enabled: boolean)
        State.FpsBoost = enabled
        Features.Utility:SetFpsBoost(enabled)
        Window:Notify("Misc", "FPS Boosts: " .. tostring(enabled), 2)
    end)

    miscSec:CreateButton("Rejoin Server", function()
        Features.Utility:RejoinServer()
    end)

    Window:Notify("Steal An Egg", "Script Loaded.", 4)
end

function StartWorkers()

    spawnWorker("StealWorker", 0.05, function()
        if State.IsReady and State.AutoSteal then
            Features.Steal:Step()
        end
    end)

    spawnWorker("PetEggWorker", 1.5, function()
        if not State.IsReady then return end
        if State.AutoHatchEgg then
            Features.Pets:HatchEggBatch()
        end
        if State.AutoPlaceEgg then
            Features.Pets:PlaceEggBatch()
        end
        if State.AutoFusePets then
            Features.Pets:FusePetsBatch()
        end
        if State.AutoEquipBestPets then
            Features.Pets:EquipBestPets()
        end
    end)

    spawnWorker("EconomyWorker", 2.5, function()
        if not State.IsReady then return end
        if State.AutoSellPets or State.AutoSellEggs then
            Features.Economy:SellBatch()
        end
        if State.AutoUpgradeBase or State.AutoUpgradeTreadmill then
            Features.Economy:ExecuteAutoUpgrades()
        end
        if State.AutoTrainTreadmill and not State.AutoSteal then
            Features.Economy:TrainTreadmill()
        end
    end)

    spawnWorker("TrailWorker", 1.5, function()
        if not State.IsReady then return end
        if State.AutoBuyTrail or State.AutoEquipBestTrail then
            Features.Economy:TrailStep()
        end
    end)

    RootJanitor:SafeConnect(GameContext.LocalPlayer.CharacterAdded, function(char)
        LocomotionController._antiFlipGyro = nil
        LocomotionController._isHumanoidProtected = false
        if State.AutoSteal then
            LocomotionController:SetGuardImmunity(true)
            local hum = char:WaitForChild("Humanoid", 5) :: Humanoid?
            if hum then
                LocomotionController:SetHumanoidProtection(hum, true)
            end
            LocomotionController:_AttachPhysicsHooks()
        end
    end)
end

if not GameContext:Validate() then
    return
end

GameContext:EnsureModules()
NetworkGateway:EnsureListeners()

MountUI()

StartWorkers()

State.IsReady = true

warn("[VALINC SYNDICATE] Steal An Egg v" .. _SCRIPT_VERSION .. " Loaded Cleanly")
