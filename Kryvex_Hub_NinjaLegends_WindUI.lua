-- =====================================================================
--   KRYVEX HUB - Ninja Legends Autofarm v2
--   WindUI Edition | Red Theme | Single File | All English
-- =====================================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

-- ============ WINDUI ============
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local RedTheme = {
    Name = "KryvexRed",
    Accent = Color3.fromHex("#8B0000"),
    Dialog = Color3.fromHex("#1a0505"),
    Outline = Color3.fromHex("#ff3333"),
    Text = Color3.fromHex("#ffffff"),
    Placeholder = Color3.fromHex("#cc6666"),
    Background = Color3.fromHex("#0d0000"),
    Button = Color3.fromHex("#cc0000"),
    Icon = Color3.fromHex("#ff4444"),
    Toggle = Color3.fromHex("#ff0000"),
    Slider = Color3.fromHex("#ff3333"),
    Checkbox = Color3.fromHex("#ff0000"),
    ElementBackground = Color3.fromHex("#1f0a0a"),
    ElementBackgroundTransparency = 0,
    PanelBackground = Color3.fromHex("#0a0000"),
    PanelBackgroundTransparency = 0.95,
}
WindUI:AddTheme(RedTheme)
WindUI:SetTheme("KryvexRed")

-- ============ HELPERS ============
local function hrp()
    local ch = player.Character
    return ch and ch:FindFirstChild("HumanoidRootPart")
end

local function humanoid()
    local ch = player.Character
    return ch and ch:FindFirstChildOfClass("Humanoid")
end

local function notify(title, content, icon, duration)
    WindUI:Notify({Title = title, Content = content, Icon = icon or "info", Duration = duration or 3})
end

local function spawnLoop(fn)
    local co = coroutine.create(function()
        local ok, err = pcall(fn)
        if not ok then warn("[Kryvex] " .. tostring(err)) end
    end)
    coroutine.resume(co)
    return co
end

-- ============ STATE ============
local State = {
    autoBuyRanks = false,
    autoBuyBelts = false,
    autoBuySwords = false,
    autoBuySkills = false,
    autoSell = false,
    autoSwing = false,
    autoOpenCrystals = false,
    autoClaimChests = false,
    autoCollectHoops = false,
    autoElementMastery = false,
    autoSellPets = false,
    autoRankSell = false,
    antiAFK = false,
    selectedCrystal = nil,
    rankDelay = 0.1,
    beltDelay = 0.5,
    swordDelay = 0.5,
    skillDelay = 0.5,
    swingDelay = 0.05,
    ranks = {},
    crystalsList = {},
    elementsList = {},
    petToggles = {},
}

-- ============ DATA COLLECTION ============
pcall(function()
    for _, v in ipairs(RS.Ranks.Ground:GetChildren()) do
        table.insert(State.ranks, v.Name)
    end
end)

pcall(function()
    for _, v in ipairs(Workspace.mapCrystalsFolder:GetChildren()) do
        table.insert(State.crystalsList, v.Name)
    end
    table.sort(State.crystalsList, function(a, b)
        local pa = RS.crystalPrices:FindFirstChild(a)
        local pb = RS.crystalPrices:FindFirstChild(b)
        if pa and pb then return pa.price.Value < pb.price.Value end
        return a < b
    end)
end)

pcall(function()
    local elFolder = RS:FindFirstChild("Elements")
    if elFolder then
        for _, v in ipairs(elFolder:GetChildren()) do
            table.insert(State.elementsList, v.Name)
        end
    end
end)

-- ============ WINDOW ============
local Window = WindUI:CreateWindow({
    Title = "Kryvex Hub",
    Author = "Kryvex | Ninja Legends v2",
    Icon = "rbxassetid://127808655828763",
    IconThemed = true,
    Folder = "KryvexHub",
    Size = UDim2.fromOffset(640, 560),
    Transparent = true,
    Theme = "KryvexRed",
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function() notify("Kryvex Hub", "Ninja Legends Autofarm v2", "info", 3) end,
    },
    Topbar = {Height = 52, ButtonsType = "Default"},
    SideBarWidth = 190,
    HideSearchBar = false,
    Resizable = true,
    MinSize = Vector2.new(520, 420),
    MaxSize = Vector2.new(950, 720),
    KeySystem = false,
})

-- =====================================================================
--   TAB: AUTOFARM
-- =====================================================================
local FarmTab = Window:Tab({Title = "Autofarm", Icon = "sword"})

FarmTab:Toggle({
    Title = "Auto Buy All Ranks",
    Desc = "Automatically purchase every rank",
    Value = false,
    Callback = function(v)
        State.autoBuyRanks = v
        if v then
            spawnLoop(function()
                while State.autoBuyRanks do
                    for i = 1, #State.ranks do
                        pcall(function()
                            player.ninjaEvent:FireServer("buyRank", State.ranks[i])
                        end)
                    end
                    task.wait(State.rankDelay)
                end
            end)
        end
    end,
})

FarmTab:Toggle({
    Title = "Auto Buy All Belts",
    Desc = "Automatically purchase every belt",
    Value = false,
    Callback = function(v)
        State.autoBuyBelts = v
        if v then
            spawnLoop(function()
                while State.autoBuyBelts do
                    pcall(function()
                        player.ninjaEvent:FireServer("buyAllBelts", "Inner Peace Island")
                    end)
                    task.wait(State.beltDelay)
                end
            end)
        end
    end,
})

FarmTab:Toggle({
    Title = "Auto Buy All Skills",
    Desc = "Automatically purchase every skill",
    Value = false,
    Callback = function(v)
        State.autoBuySkills = v
        if v then
            spawnLoop(function()
                while State.autoBuySkills do
                    pcall(function()
                        player.ninjaEvent:FireServer("buyAllSkills", "Inner Peace Island")
                    end)
                    task.wait(State.skillDelay)
                end
            end)
        end
    end,
})

FarmTab:Toggle({
    Title = "Auto Buy All Swords",
    Desc = "Automatically purchase every sword",
    Value = false,
    Callback = function(v)
        State.autoBuySwords = v
        if v then
            spawnLoop(function()
                while State.autoBuySwords do
                    pcall(function()
                        player.ninjaEvent:FireServer("buyAllSwords", "Inner Peace Island")
                    end)
                    task.wait(State.swordDelay)
                end
            end)
        end
    end,
})

FarmTab:Toggle({
    Title = "Auto Sell",
    Desc = "Automatically sells by teleporting the sell area to your character",
    Value = false,
    Callback = function(v)
        State.autoSell = v
        if v then
            spawnLoop(function()
                while State.autoSell do
                    pcall(function()
                        local area = Workspace.sellAreaCircles:FindFirstChild("sellAreaCircle16")
                        if area and hrp() then
                            area.circleInner.CFrame = hrp().CFrame
                            task.wait(0.1)
                            area.circleInner.CFrame = CFrame.new(0, 0, 0)
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end,
})

FarmTab:Toggle({
    Title = "Auto Swing",
    Desc = "Automatically swings your sword",
    Value = false,
    Callback = function(v)
        State.autoSwing = v
        if v then
            spawnLoop(function()
                while State.autoSwing do
                    local bp = player:FindFirstChild("Backpack")
                    if bp and humanoid() then
                        for _, tool in ipairs(bp:GetChildren()) do
                            if tool:FindFirstChild("ninjitsuGain") then
                                pcall(function() humanoid():EquipTool(tool) end)
                                break
                            end
                        end
                    end
                    pcall(function() player.ninjaEvent:FireServer("swingKatana") end)
                    task.wait(State.swingDelay)
                end
            end)
        end
    end,
})

FarmTab:Toggle({
    Title = "Auto Open Chests",
    Desc = "Automatically opens every chest in the world",
    Value = false,
    Callback = function(v)
        State.autoClaimChests = v
        if v then
            spawnLoop(function()
                while State.autoClaimChests do
                    for _, v2 in ipairs(Workspace:GetChildren()) do
                        if v2:FindFirstChild("Chest") then
                            local inner = v2:FindFirstChild("circleInner")
                            if inner and inner:FindFirstChildWhichIsA("TouchTransmitter") and hrp() then
                                pcall(function()
                                    firetouchinterest(hrp(), inner, 0)
                                    task.wait()
                                    firetouchinterest(hrp(), inner, 1)
                                end)
                                task.wait(3)
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end,
})

FarmTab:Toggle({
    Title = "Auto Collect Hoops",
    Desc = "Automatically collects every hoop",
    Value = false,
    Callback = function(v)
        State.autoCollectHoops = v
        if v then
            spawnLoop(function()
                while State.autoCollectHoops do
                    pcall(function()
                        local hoops = Workspace:FindFirstChild("Hoops")
                        if hoops and hrp() then
                            for _, hoop in ipairs(hoops:GetChildren()) do
                                if hoop:IsA("MeshPart") and hoop:FindFirstChild("touchPart") then
                                    hoop.touchPart.CFrame = hrp().CFrame
                                    task.wait(0.15)
                                    hoop.touchPart.CFrame = CFrame.new(0, 0, 0)
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end,
})

FarmTab:Toggle({
    Title = "Auto Element Mastery",
    Desc = "Automatically masters every element",
    Value = false,
    Callback = function(v)
        State.autoElementMastery = v
        if v then
            spawnLoop(function()
                while State.autoElementMastery do
                    pcall(function()
                        local eEvent = RS.rEvents:FindFirstChild("elementMasteryEvent")
                        if eEvent then
                            for _, elName in ipairs(State.elementsList) do
                                eEvent:FireServer(elName)
                            end
                        end
                    end)
                    task.wait(5)
                end
            end)
        end
    end,
})

FarmTab:Slider({
    Title = "Rank Buy Delay",
    Desc = "Time between rank purchases (seconds)",
    Value = {Min = 0, Max = 1, Default = 0.1},
    Step = 0.05,
    Callback = function(v) State.rankDelay = v end,
})

FarmTab:Slider({
    Title = "Swing Delay",
    Desc = "Time between swings (seconds)",
    Value = {Min = 0, Max = 0.5, Default = 0.05},
    Step = 0.01,
    Callback = function(v) State.swingDelay = v end,
})

-- =====================================================================
--   TAB: CRYSTALS
-- =====================================================================
local CrystalTab = Window:Tab({Title = "Crystals", Icon = "diamond"})

if #State.crystalsList > 0 then
    CrystalTab:Dropdown({
        Title = "Select Crystal",
        Desc = "Choose which crystal to open",
        Values = State.crystalsList,
        Value = State.crystalsList[1] or "",
        Callback = function(v) State.selectedCrystal = v end,
    })
end

CrystalTab:Button({
    Title = "Open Once",
    Desc = "Opens the selected crystal once",
    Callback = function()
        if State.selectedCrystal then
            pcall(function()
                RS.rEvents.openCrystalRemote:InvokeServer("openCrystal", State.selectedCrystal)
            end)
            notify("Crystal", "Opened: " .. State.selectedCrystal, "check", 2)
        else
            notify("Error", "Select a crystal first", "x", 2)
        end
    end,
})

CrystalTab:Toggle({
    Title = "Auto Open Crystals",
    Desc = "Automatically opens the selected crystal",
    Value = false,
    Callback = function(v)
        State.autoOpenCrystals = v
        if v then
            spawnLoop(function()
                while State.autoOpenCrystals do
                    if State.selectedCrystal then
                        pcall(function()
                            RS.rEvents.openCrystalRemote:InvokeServer("openCrystal", State.selectedCrystal)
                        end)
                    end
                    task.wait(0.5)
                end
            end)
        end
    end,
})

-- =====================================================================
--   TAB: PETS
-- =====================================================================
local PetTab = Window:Tab({Title = "Pets", Icon = "paw-print"})

local petFolder = player:FindFirstChild("petsFolder")
if petFolder then
    for _, tier in ipairs(petFolder:GetChildren()) do
        PetTab:Toggle({
            Title = "AutoSell: " .. tier.Name,
            Desc = "Automatically sells all pets in this tier",
            Value = false,
            Callback = function(v)
                State.petToggles[tier.Name] = v
                if v then
                    spawnLoop(function()
                        while State.petToggles[tier.Name] do
                            pcall(function()
                                for _, pet in ipairs(tier:GetChildren()) do
                                    RS.rEvents.sellPetEvent:FireServer("sellPet", pet)
                                end
                            end)
                            task.wait(0.2)
                        end
                    end)
                end
            end,
        })
    end
else
    PetTab:Paragraph({Title = "Pets", Content = "Pet folder not found. Re-run the script after joining the game."})
end

PetTab:Button({
    Title = "Sell All Pets (One Time)",
    Desc = "Sells every pet in your inventory",
    Callback = function()
        local count = 0
        pcall(function()
            local folder = player:FindFirstChild("petsFolder")
            if folder then
                for _, tier in ipairs(folder:GetChildren()) do
                    for _, pet in ipairs(tier:GetChildren()) do
                        RS.rEvents.sellPetEvent:FireServer("sellPet", pet)
                        count = count + 1
                        task.wait(0.05)
                    end
                end
            end
        end)
        notify("Pets", count .. " pets sold", "check", 3)
    end,
})

-- =====================================================================
--   TAB: TELEPORT
-- =====================================================================
local TpTab = Window:Tab({Title = "Teleport", Icon = "map-pin"})

local Islandslist = {
    "Enchanted Island", "Astral Island", "Mystical Island", "Space Island",
    "Tundra Island", "Eternal Island", "Sandstorm", "Thunderstorm",
    "Ancient Inferno Island", "Midnight Shadow Island", "Mythical Souls Island",
    "Winter Wonder Island", "Golden Master Island", "Dragon Legend Island",
    "Cybernetic Legends Island", "Skystorm Ultraus Island", "Chaos Legends Island",
    "Soul Fusion Island", "Dark Elements Island", "Inner Peace Island",
    "Blazing Vortex Island"
}

TpTab:Dropdown({
    Title = "Teleport to Island",
    Desc = "Teleport to the selected island",
    Values = Islandslist,
    Callback = function(v)
        pcall(function()
            if hrp() and Workspace.islandUnlockParts:FindFirstChild(v) then
                hrp().CFrame = Workspace.islandUnlockParts[v].CFrame
                notify("Teleport", "Teleported to " .. v, "check", 2)
            end
        end)
    end,
})

local TrainingList = {
    "Mystical Waters", "Lava Pit", "Tornado", "Sword of Legends",
    "Sword of Ancients", "Elemental Tornado", "Fallen Infinity Blade", "Zen Master's Blade"
}

local TrainingCFrames = {
    ["Mystical Waters"] = CFrame.new(343.933624, 8824.41309, 116.454231, 0.296236873, 3.43450957e-08, -0.955114484, 4.83460703e-08, 1, 5.09540854e-08, 0.955114484, -6.12705122e-08, 0.296236873),
    ["Lava Pit"] = CFrame.new(-126.416206, 12952.4131, 273.149292, -0.276711583, -5.23082626e-08, 0.960952997, 2.41545077e-08, 1, 6.13891586e-08, -0.960952997, 4.01984366e-08, -0.276711583),
    ["Tornado"] = CFrame.new(313.673065, 16871.9688, -14.7217541, 0.994922996, 7.48534461e-08, -0.100639053, -7.66444046e-08, 1, -1.39292826e-08, 0.100639053, 2.15719833e-08, 0.994922996),
    ["Sword of Legends"] = CFrame.new(1847.01306, 38.5793152, -139.799545, 0.940122247, 1.6319289e-08, 0.340837389, 1.772184e-08, 1, -9.67616387e-08, -0.340837389, 9.70080336e-08, 0.940122247),
    ["Sword of Ancients"] = CFrame.new(608.698364, 38.5796623, 2425.60474, -0.0159091037, -4.19558752e-08, -0.999873459, -6.51419052e-09, 1, -4.18575361e-08, 0.999873459, 5.84745008e-09, -0.0159091037),
    ["Elemental Tornado"] = CFrame.new(323.196381, 30382.9707, 0.835642278, -0.906975925, -6.70449865e-08, 0.421182454, -2.82923036e-08, 1, 9.82580062e-08, -0.421182454, 7.72014275e-08, -0.906975925),
    ["Fallen Infinity Blade"] = CFrame.new(1883.16479, 66.9705124, -6811.90771, 0.91395551, -4.90655268e-08, -0.405814409, 5.31859889e-09, 1, -1.08928035e-07, 0.405814409, 9.73970131e-08, 0.91395551),
}

TpTab:Dropdown({
    Title = "Teleport to Training Area",
    Desc = "Teleport to the selected training area",
    Values = TrainingList,
    Callback = function(v)
        pcall(function()
            if hrp() then
                local cf = TrainingCFrames[v]
                if cf then
                    hrp().CFrame = cf
                    notify("Teleport", "Teleported to " .. v, "check", 2)
                else
                    notify("Error", "No coordinates for " .. v, "x", 2)
                end
            end
        end)
    end,
})

TpTab:Button({
    Title = "Unlock All Islands",
    Desc = "Unlocks every island by touching each one",
    Callback = function()
        local count = 0
        pcall(function()
            for _, v in ipairs(Workspace.islandUnlockParts:GetChildren()) do
                if hrp() then
                    firetouchinterest(hrp(), v, 0)
                    firetouchinterest(hrp(), v, 1)
                    count = count + 1
                end
            end
        end)
        notify("Unlock", count .. " islands unlocked", "check", 3)
    end,
})

TpTab:Button({
    Title = "Open Shop",
    Callback = function()
        pcall(function()
            local shop = Workspace.shopAreaCircles:FindFirstChild("shopAreaCircle19")
            if shop and hrp() then
                shop.circleInner.CFrame = hrp().CFrame
                task.wait(0.4)
                shop.circleInner.CFrame = CFrame.new(0, 0, 0)
                notify("Shop", "Shop opened", "check", 2)
            end
        end)
    end,
})

-- =====================================================================
--   TAB: LOCAL PLAYER
-- =====================================================================
local PlayerTab = Window:Tab({Title = "Player", Icon = "user"})

PlayerTab:Slider({
    Title = "WalkSpeed",
    Desc = "Character walk speed",
    Value = {Min = 16, Max = 500, Default = 16},
    Step = 1,
    Callback = function(v)
        if humanoid() then humanoid().WalkSpeed = v end
    end,
})

PlayerTab:Slider({
    Title = "JumpPower",
    Desc = "Character jump power",
    Value = {Min = 50, Max = 400, Default = 50},
    Step = 1,
    Callback = function(v)
        if humanoid() then humanoid().JumpPower = v end
    end,
})

PlayerTab:Button({
    Title = "Infinite Double Jumps",
    Callback = function()
        pcall(function()
            if player:FindFirstChild("multiJumpCount") then
                player.multiJumpCount.Value = 999999999
                notify("Player", "Infinite double jumps enabled", "check", 2)
            end
        end)
    end,
})

PlayerTab:Button({
    Title = "Toggle Popups",
    Callback = function()
        pcall(function()
            local pg = player.PlayerGui
            if pg.statEffectsGui then pg.statEffectsGui.Enabled = not pg.statEffectsGui.Enabled end
            if pg.hoopGui then pg.hoopGui.Enabled = not pg.hoopGui.Enabled end
            notify("Player", "Popups toggled", "check", 2)
        end)
    end,
})

-- =====================================================================
--   TAB: MISC
-- =====================================================================
local MiscTab = Window:Tab({Title = "Misc", Icon = "settings"})

MiscTab:Toggle({
    Title = "Anti-AFK",
    Desc = "Prevents the 20-minute idle kick",
    Value = false,
    Callback = function(v)
        State.antiAFK = v
        if v then
            player.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
            notify("Anti-AFK", "Enabled", "check", 2)
        end
    end,
})

MiscTab:Button({
    Title = "Open All Chests (One Time)",
    Desc = "Opens every chest around you",
    Callback = function()
        local count = 0
        pcall(function()
            for _, v in ipairs(Workspace:GetChildren()) do
                if v:FindFirstChild("Chest") then
                    local inner = v:FindFirstChild("circleInner")
                    if inner and inner:FindFirstChildWhichIsA("TouchTransmitter") and hrp() then
                        firetouchinterest(hrp(), inner, 0)
                        task.wait()
                        firetouchinterest(hrp(), inner, 1)
                        count = count + 1
                        task.wait(1)
                    end
                end
            end
        end)
        notify("Chest", count .. " chests opened", "check", 3)
    end,
})

MiscTab:Button({
    Title = "Collect All Hoops (One Time)",
    Callback = function()
        local count = 0
        pcall(function()
            local hoops = Workspace:FindFirstChild("Hoops")
            if hoops and hrp() then
                for _, hoop in ipairs(hoops:GetChildren()) do
                    if hoop:IsA("MeshPart") and hoop:FindFirstChild("touchPart") then
                        hoop.touchPart.CFrame = hrp().CFrame
                        task.wait(0.2)
                        hoop.touchPart.CFrame = CFrame.new(0, 0, 0)
                        count = count + 1
                    end
                end
            end
        end)
        notify("Hoops", count .. " hoops collected", "check", 3)
    end,
})

MiscTab:Button({
    Title = "Master All Elements (One Time)",
    Callback = function()
        local count = 0
        pcall(function()
            local eEvent = RS.rEvents:FindFirstChild("elementMasteryEvent")
            if eEvent then
                for _, el in ipairs(State.elementsList) do
                    eEvent:FireServer(el)
                    count = count + 1
                    task.wait(0.2)
                end
            end
        end)
        notify("Elements", count .. " elements mastered", "check", 3)
    end,
})

MiscTab:Toggle({
    Title = "FPS Boost",
    Desc = "Lowers graphics settings to increase FPS",
    Value = false,
    Callback = function(v)
        pcall(function()
            local lighting = game:GetService("Lighting")
            if v then
                lighting.GlobalShadows = false
                lighting.FogEnd = 9e9
                for _, e in ipairs(lighting:GetChildren()) do
                    if e:IsA("PostEffect") then e.Enabled = false end
                end
                for _, d in ipairs(Workspace:GetDescendants()) do
                    if d:IsA("BasePart") then d.Material = Enum.Material.SmoothPlastic end
                    if d:IsA("Decal") then d:Destroy() end
                    if d:IsA("ParticleEmitter") then d.Enabled = false end
                end
                notify("FPS", "FPS boost enabled", "check", 2)
            else
                lighting.GlobalShadows = true
                lighting.FogEnd = 1000
                notify("FPS", "FPS boost disabled", "info", 2)
            end
        end)
    end,
})

MiscTab:Button({
    Title = "Server Hop",
    Desc = "Teleport to a less crowded server",
    Callback = function()
        notify("Server Hop", "Switching servers...", "info", 2)
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        local servers = {}
        pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local response = game:HttpGet(url)
            local data = HttpService:JSONDecode(response)
            for _, s in ipairs(data.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    table.insert(servers, s.id)
                end
            end
        end)
        if #servers > 0 then
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
            end)
        else
            notify("Error", "No servers found", "x", 2)
        end
    end,
})

MiscTab:Button({
    Title = "Respawn Character",
    Callback = function()
        pcall(function()
            if humanoid() then
                humanoid().Health = 0
                task.wait(0.5)
                player:LoadCharacter()
            end
        end)
    end,
})

-- =====================================================================
--   TAB: STATUS
-- =====================================================================
local StatusTab = Window:Tab({Title = "Status", Icon = "activity"})

StatusTab:Paragraph({
    Title = "Kryvex Hub",
    Content = "Ninja Legends Autofarm v2 | Red Theme",
})

StatusTab:Button({
    Title = "Stop All",
    Desc = "Stops every running loop",
    Callback = function()
        State.autoBuyRanks = false
        State.autoBuyBelts = false
        State.autoBuySwords = false
        State.autoBuySkills = false
        State.autoSell = false
        State.autoSwing = false
        State.autoOpenCrystals = false
        State.autoClaimChests = false
        State.autoCollectHoops = false
        State.autoElementMastery = false
        for k in pairs(State.petToggles) do
            State.petToggles[k] = false
        end
        notify("Kryvex", "All loops stopped", "check", 3)
    end,
})

StatusTab:Button({
    Title = "Shortcut Info",
    Desc = "Use the X button at the top right to close the panel",
    Callback = function()
        notify("Shortcut", "Re-run the script to reopen the panel", "info", 5)
    end,
})

-- =====================================================================
--   LOADED
-- =====================================================================
notify("Kryvex Hub", "Ninja Legends Autofarm v2 loaded!", "check", 5)
print("[Kryvex] Ninja Legends Autofarm v2 successfully loaded.")
