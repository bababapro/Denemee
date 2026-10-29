local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- BURAYA Pastebin'in "RAW" (Ham) linkini yapıştırın
local pastebinUrl = "https://pastebin.com/raw/h9vu11sE"

local success, result = pcall(function()
    return game:HttpGet(pastebinUrl)
end)

if not success then
    LocalPlayer:Kick("⛔ Whitelist sunucusuna bağlanılamadı! Lütfen daha sonra tekrar deneyin.")
    return
end

local Whitelist = {}
for username in result:gmatch("[^\r\n]+") do
    username = username:match("^%s*(.-)%s*$")
    if username ~= "" then
        Whitelist[username] = true
    end
end

if not Whitelist[LocalPlayer.Name] then
    LocalPlayer:Kick("⛔ You are not authorized to use this script!")
    return
end

print("✅ Whitelist onaylandı!")

local library = loadstring(game:HttpGet("https://github.com/KryvexOnTop/Kryvex-paid/raw/refs/heads/main/KryvexGui%20(3).txt", true))()

local window = library:AddWindow("##############", {
    title_bar = {
        Color3.fromRGB(175, 20, 230),
        Color3.fromRGB(85, 10, 115),
        Color3.fromRGB(25, 0, 30)
    },
    title_bar_transparency = 0.1,
    background = {
        Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(8, 5, 10),
        Color3.fromRGB(18, 10, 20)
    },
    background_transparency = 0.1,
    main_color = Color3.fromRGB(175, 20, 230),
    min_size = Vector2.new(420, 350),
    can_resize = true
})

local tabRebirth = window:AddTab("Fast Rebirth")
local tabStrength = window:AddTab("Fast Strength")

tabRebirth:AddLabel("👀 Fast Rebirth").TextSize = 21

--// SERVICES
local lp = {
    player = game:GetService("Players").LocalPlayer
}

local services = {
    players = game:GetService("Players"),
    replicatedstorage = game:GetService("ReplicatedStorage"),
    runservice = game:GetService("RunService"),
    muscleEvent = lp.player:WaitForChild("muscleEvent")
}

--// EKSİK DEĞİŞKENLER (DÜZELTME)
local replicatedStorage = services.replicatedstorage
local rebirths = tabRebirth

--// FORMAT NUMBER
local function formatNumber(value)
    value = tonumber(value) or 0

    local absValue = math.abs(value)
    local suffixes = {
        {1e18, "Qi"},
        {1e15, "Qa"},
        {1e12, "T"},
        {1e9, "B"},
        {1e6, "M"},
        {1e3, "K"}
    }

    for _, data in ipairs(suffixes) do
        local divisor, suffix = data[1], data[2]
        if absValue >= divisor then
            local formatted = value / divisor
            if math.abs(formatted) >= 100 then
                return string.format("%.0f%s", formatted, suffix)
            elseif math.abs(formatted) >= 10 then
                return string.format("%.1f%s", formatted, suffix)
            else
                return string.format("%.2f%s", formatted, suffix)
            end
        end
    end

    if math.floor(value) == value then
        return tostring(value)
    end

    return string.format("%.2f", value)
end

--// STATE
local function makePackFarmState(uiTab)
    local state = {}
    function state:AddLabel(...) return uiTab:AddLabel(...) end
    function state:AddSwitch(...) return uiTab:AddSwitch(...) end
    function state:AddTextBox(...) return uiTab:AddTextBox(...) end
    return state
end

local tabs = {
    rebirths = makePackFarmState(tabRebirth),
    strength = makePackFarmState(tabStrength)
}

--==================================================
-- FAST REBIRTH
--==================================================

tabs.rebirths.leaderstats = lp.player:WaitForChild("leaderstats")
tabs.rebirths.rebirths = tabs.rebirths.leaderstats:WaitForChild("Rebirths")
tabs.rebirths.strength = tabs.rebirths.leaderstats:WaitForChild("Strength")

tabs.rebirths.running = false
tabs.rebirths.workerActive = false
tabs.rebirths.startedAt = 0
tabs.rebirths.timerStarted = false
tabs.rebirths.hasStarted = false
tabs.rebirths.totalElapsed = 0

tabs.rebirths.startRebirths = tabs.rebirths.rebirths.Value
tabs.rebirths.gainedBaselineSet = false

tabs.rebirths.lastRebirthAt = tick()
tabs.rebirths.lastRebirthValue = tabs.rebirths.rebirths.Value
tabs.rebirths.paceBaselineReady = false

tabs.rebirths.petFolders = {}
tabs.rebirths.pets = {}
tabs.rebirths.uniquePets = {}
tabs.rebirths.omegas = {}
tabs.rebirths.swifts = {}
tabs.rebirths.hounds = {}
tabs.rebirths.hydras = {}
tabs.rebirths.tribals = {}

tabs.rebirths.folderIndex = 1
tabs.rebirths.petIndex = 1
tabs.rebirths.repIndex = 1
tabs.rebirths.equippedCount = 0
tabs.rebirths.currentPercent = 0

tabs.rebirths.maxSlots = 9
tabs.rebirths.strengthTarget = 0
tabs.rebirths.repsPerBurst = 12
tabs.rebirths.rebirthValueBefore = tabs.rebirths.rebirths.Value

tabs.rebirths.Status = tabs.rebirths:AddLabel("Status: Inactive")
tabs.rebirths.Runtime = tabs.rebirths:AddLabel("Runtime: 0d 0h 0m 0s")
tabs.rebirths.RebirthStats = tabs.rebirths:AddLabel("Rebirths: " .. formatNumber(tabs.rebirths.rebirths.Value) .. " | Gained: 0")
tabs.rebirths.Pace = tabs.rebirths:AddLabel("Pace: -- / Hour | -- / Day | -- / Week")
tabs.rebirths.AveragePace = tabs.rebirths:AddLabel("Average: -- / Hour | -- / Day | -- / Week")

tabs.rebirths.Status.TextColor3 = Color3.fromRGB(255, 80, 80)

tabs.rebirths.updateStats = function()
    tabs.rebirths.RebirthStats.Text = "Rebirths: " .. formatNumber(tabs.rebirths.rebirths.Value) .. " | Gained: " .. formatNumber(tabs.rebirths.rebirths.Value - tabs.rebirths.startRebirths)
end

tabs.rebirths.updateRuntime = function()
    tabs.rebirths.elapsed = tabs.rebirths.totalElapsed
    if tabs.rebirths.running and tabs.rebirths.timerStarted then
        tabs.rebirths.elapsed = tabs.rebirths.elapsed + tick() - tabs.rebirths.startedAt
    end
    tabs.rebirths.Runtime.Text = string.format("Runtime: %dd %dh %dm %ds",
        math.floor(tabs.rebirths.elapsed / 86400),
        math.floor((tabs.rebirths.elapsed % 86400) / 3600),
        math.floor((tabs.rebirths.elapsed % 3600) / 60),
        math.floor(tabs.rebirths.elapsed % 60))
end

tabs.rebirths.updatePace = function()
    if not tabs.rebirths.running then return end
    if not tabs.rebirths.paceBaselineReady then
        tabs.rebirths.paceBaselineReady = true
        tabs.rebirths.timerStarted = true
        tabs.rebirths.startedAt = tick()
        tabs.rebirths.lastRebirthAt = tick()
        tabs.rebirths.lastRebirthValue = tabs.rebirths.rebirths.Value
        tabs.rebirths.averageStartedAt = tick()
        tabs.rebirths.averageStartRebirths = tabs.rebirths.rebirths.Value
        return
    end
    if tabs.rebirths.rebirths.Value <= tabs.rebirths.lastRebirthValue then return end
    local gain = tabs.rebirths.rebirths.Value - tabs.rebirths.lastRebirthValue
    local seconds = (tick() - tabs.rebirths.lastRebirthAt) / gain
    local hourly = 3600 / seconds
    local daily = 86400 / seconds
    local weekly = 604800 / seconds
    tabs.rebirths.Pace.Text = string.format("Pace: %s / Hour | %s / Day | %s / Week", formatNumber(hourly), formatNumber(daily), formatNumber(weekly))
    local averageElapsed = tick() - tabs.rebirths.averageStartedAt
    if averageElapsed > 0 then
        local averageHourly = (tabs.rebirths.rebirths.Value - tabs.rebirths.averageStartRebirths) / averageElapsed * 3600
        tabs.rebirths.AveragePace.Text = string.format("Average: %s / Hour | %s / Day | %s / Week", formatNumber(averageHourly), formatNumber(averageHourly * 24), formatNumber(averageHourly * 168))
    end
    tabs.rebirths.lastRebirthAt = tick()
    tabs.rebirths.lastRebirthValue = tabs.rebirths.rebirths.Value
end

tabs.rebirths.unequipAllPets = function()
    tabs.rebirths.petFolders = lp.player.petsFolder:GetChildren()
    for _, folder in ipairs(tabs.rebirths.petFolders) do
        if folder:IsA("Folder") then
            for _, pet in ipairs(folder:GetChildren()) do
                services.replicatedstorage.rEvents.equipPetEvent:FireServer("unequipPet", pet)
            end
        end
    end
    task.wait(0.001)
end

tabs.rebirths.equipFarmingPets = function()
    tabs.rebirths.unequipAllPets()
    tabs.rebirths.omegas = {}
    tabs.rebirths.swifts = {}
    tabs.rebirths.hounds = {}
    tabs.rebirths.uniquePets = lp.player.petsFolder.Unique:GetChildren()
    for _, pet in ipairs(tabs.rebirths.uniquePets) do
        if pet.Name == "Omega Overlord" then table.insert(tabs.rebirths.omegas, pet)
        elseif pet.Name == "Swift Samurai" then table.insert(tabs.rebirths.swifts, pet)
        elseif pet.Name == "Powercore Hound" then table.insert(tabs.rebirths.hounds, pet) end
    end
    tabs.rebirths.equippedCount = 0
    tabs.rebirths.currentPercent = 0
    for i = #tabs.rebirths.omegas, 1, -1 do
        if tabs.rebirths.equippedCount < tabs.rebirths.maxSlots and tabs.rebirths.currentPercent < 100 then
            local pet = tabs.rebirths.omegas[i]
            services.replicatedstorage.rEvents.equipPetEvent:FireServer("equipPet", pet)
            tabs.rebirths.currentPercent += 20
            tabs.rebirths.equippedCount += 1
        end
    end
    for i = #tabs.rebirths.swifts, 1, -1 do
        if tabs.rebirths.equippedCount < tabs.rebirths.maxSlots and tabs.rebirths.currentPercent < 100 then
            local pet = tabs.rebirths.swifts[i]
            services.replicatedstorage.rEvents.equipPetEvent:FireServer("equipPet", pet)
            tabs.rebirths.currentPercent += 15
            tabs.rebirths.equippedCount += 1
        end
    end
    if tabs.rebirths.currentPercent >= 100 then
        for i = #tabs.rebirths.hounds, 1, -1 do
            if tabs.rebirths.equippedCount < tabs.rebirths.maxSlots then
                local pet = tabs.rebirths.hounds[i]
                services.replicatedstorage.rEvents.equipPetEvent:FireServer("equipPet", pet)
                tabs.rebirths.equippedCount += 1
            end
        end
    end
end

tabs.rebirths.equipRebirthPets = function()
    tabs.rebirths.unequipAllPets()
    tabs.rebirths.hydras = {}
    tabs.rebirths.tribals = {}
    local unique = lp.player.petsFolder.Unique:GetChildren()
    for _, pet in ipairs(unique) do
        if pet.Name == "Titanium Hydra" then table.insert(tabs.rebirths.hydras, pet)
        elseif pet.Name == "Tribal Overlord" then table.insert(tabs.rebirths.tribals, pet) end
    end
    tabs.rebirths.equippedCount = 0
    for _, pet in ipairs(tabs.rebirths.hydras) do
        if tabs.rebirths.equippedCount >= tabs.rebirths.maxSlots then break end
        services.replicatedstorage.rEvents.equipPetEvent:FireServer("equipPet", pet)
        tabs.rebirths.equippedCount += 1
    end
    for _, pet in ipairs(tabs.rebirths.tribals) do
        if tabs.rebirths.equippedCount >= tabs.rebirths.maxSlots then break end
        services.replicatedstorage.rEvents.equipPetEvent:FireServer("equipPet", pet)
        tabs.rebirths.equippedCount += 1
    end
end

tabs.rebirths.performRebirth = function()
    tabs.rebirths.strengthTarget = 5000 + tabs.rebirths.rebirths.Value * 2550
    tabs.rebirths.repsPerBurst = lp.player.MembershipType == Enum.MembershipType.Premium and 6 or 12
    while tabs.rebirths.running and tabs.rebirths.strength.Value < tabs.rebirths.strengthTarget do
        for i = 1, tabs.rebirths.repsPerBurst do
            if not tabs.rebirths.running then break end
            services.muscleEvent:FireServer("rep")
        end
        task.wait(0.01)
    end
    if tabs.rebirths.running and tabs.rebirths.strength.Value >= tabs.rebirths.strengthTarget then
        tabs.rebirths.equipRebirthPets()
        task.wait(0.01)
        tabs.rebirths.rebirthValueBefore = tabs.rebirths.rebirths.Value
        repeat
            services.replicatedstorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
            task.wait(0.01)
        until tabs.rebirths.rebirths.Value > tabs.rebirths.rebirthValueBefore or not tabs.rebirths.running
    end
end

tabs.rebirths.startWorker = function()
    if tabs.rebirths.workerActive then return end
    tabs.rebirths.workerActive = true
    task.spawn(function()
        while tabs.rebirths.running do
            tabs.rebirths.equipFarmingPets()
            tabs.rebirths.performRebirth()
            task.wait(0.01)
        end
        tabs.rebirths.workerActive = false
    end)
end

tabs.rebirths.rebirths:GetPropertyChangedSignal("Value"):Connect(function()
    tabs.rebirths.updatePace()
    tabs.rebirths.updateStats()
end)

tabs.rebirths:AddSwitch("👀 Fast Rebirth", function(state)
    tabs.rebirths.running = state
    if state then
        tabs.rebirths.hasStarted = true
        tabs.rebirths.startedAt = 0
        tabs.rebirths.timerStarted = false
        if not tabs.rebirths.gainedBaselineSet then
            tabs.rebirths.startRebirths = tabs.rebirths.rebirths.Value
            tabs.rebirths.gainedBaselineSet = true
        end
        tabs.rebirths.lastRebirthAt = tick()
        tabs.rebirths.lastRebirthValue = tabs.rebirths.rebirths.Value
        tabs.rebirths.paceBaselineReady = false
        tabs.rebirths.Status.Text = "Status: Rebirthing"
        tabs.rebirths.Status.TextColor3 = Color3.fromRGB(80, 255, 120)
        tabs.rebirths.updateStats()
        tabs.rebirths.startWorker()
    else
        if tabs.rebirths.timerStarted and tabs.rebirths.startedAt > 0 then
            tabs.rebirths.totalElapsed = tabs.rebirths.totalElapsed + tick() - tabs.rebirths.startedAt
            tabs.rebirths.startedAt = 0
            tabs.rebirths.timerStarted = false
        end
        tabs.rebirths.Status.Text = tabs.rebirths.hasStarted and "Status: Paused" or "Status: Inactive"
        tabs.rebirths.Status.TextColor3 = tabs.rebirths.hasStarted and Color3.fromRGB(255, 180, 70) or Color3.fromRGB(255, 80, 80)
        tabs.rebirths.updateRuntime()
    end
end):Set(false)

task.spawn(function()
    while true do
        tabs.rebirths.updateRuntime()
        task.wait(1)
    end
end)

--==================================================
-- FAST STRENGTH
--==================================================
tabStrength:AddLabel("💪 Fast Strength").TextSize = 21

tabs.strength.leaderstats = lp.player:WaitForChild("leaderstats")
tabs.strength.strength = tabs.strength.leaderstats:WaitForChild("Strength")
tabs.strength.durability = lp.player:WaitForChild("Durability")

tabs.strength.running = false
tabs.strength.workerActive = false
tabs.strength.startedAt = 0
tabs.strength.totalElapsed = 0
tabs.strength.timerStarted = false
tabs.strength.gainedBaselineSet = false
tabs.strength.startStrength = tabs.strength.strength.Value
tabs.strength.startDurability = tabs.strength.durability.Value
tabs.strength.lastSampleAt = tick()
tabs.strength.lastStrength = tabs.strength.strength.Value
tabs.strength.lastDurability = tabs.strength.durability.Value
tabs.strength.calculationInterval = 10
tabs.strength.lastCalculationAt = tick()
tabs.strength.lastCalculatedStrength = tabs.strength.strength.Value
tabs.strength.lastCalculatedDurability = tabs.strength.durability.Value
tabs.strength.repSpeed = 200
tabs.strength.maxSendRate = 1200
tabs.strength.sendRate = tabs.strength.repSpeed
tabs.strength.sendTokens = 0
tabs.strength.maxBurst = 24
tabs.strength.lastLoopAt = os.clock()
tabs.strength.repIndex = 1

tabs.strength.Status = tabs.strength:AddLabel("Status: Inactive")
tabs.strength.Runtime = tabs.strength:AddLabel("Runtime: 0d 0h 0m 0s")
tabs.strength.StrengthStats = tabs.strength:AddLabel("Strength: " .. formatNumber(tabs.strength.strength.Value) .. " | Gained: 0")
tabs.strength.DurabilityStats = tabs.strength:AddLabel("Durability: " .. formatNumber(tabs.strength.durability.Value) .. " | Gained: 0")
tabs.strength.StrengthPace = tabs.strength:AddLabel("Strength Pace: -- / Hour | -- / Day")
tabs.strength.DurabilityPace = tabs.strength:AddLabel("Durability Pace: -- / Hour | -- / Day")
tabs.strength.StrengthAverage = tabs.strength:AddLabel("Strength Average: -- / Hour | -- / Day")
tabs.strength.DurabilityAverage = tabs.strength:AddLabel("Durability Average: -- / Hour | -- / Day")
tabs.strength.Status.TextColor3 = Color3.fromRGB(255, 80, 80)

tabs.strength:AddTextBox("⚡ Rep Speed:", function(value)
    local speed = tonumber(value)
    if speed then
        speed = math.floor(speed)
        speed = math.clamp(speed, 1, tabs.strength.maxSendRate)
        tabs.strength.repSpeed = speed
        if tabs.strength.running then
            tabs.strength.sendRate = speed
            tabs.strength.sendTokens = 0
            tabs.strength.Status.Text = "Status: Farming | " .. formatNumber(speed) .. " reps/s"
            tabs.strength.Status.TextColor3 = Color3.fromRGB(80, 255, 120)
        end
    end
end)

tabs.strength.updateRuntime = function()
    local elapsed = tabs.strength.totalElapsed
    if tabs.strength.running and tabs.strength.timerStarted then
        elapsed = elapsed + tick() - tabs.strength.startedAt
    end
    tabs.strength.Runtime.Text = string.format("Runtime: %dd %dh %dm %ds",
        math.floor(elapsed / 86400),
        math.floor((elapsed % 86400) / 3600),
        math.floor((elapsed % 3600) / 60),
        math.floor(elapsed % 60))
end

tabs.strength.updateStats = function()
    tabs.strength.StrengthStats.Text = "Strength: " .. formatNumber(tabs.strength.strength.Value) .. " | Gained: " .. formatNumber(tabs.strength.strength.Value - tabs.strength.startStrength)
    tabs.strength.DurabilityStats.Text = "Durability: " .. formatNumber(tabs.strength.durability.Value) .. " | Gained: " .. formatNumber(tabs.strength.durability.Value - tabs.strength.startDurability)
end

tabs.strength.updatePace = function()
    if not tabs.strength.running then return end
    if not tabs.strength.timerStarted then
        if tabs.strength.strength.Value == tabs.strength.startStrength and tabs.strength.durability.Value == tabs.strength.startDurability then return end
        tabs.strength.timerStarted = true
        tabs.strength.startedAt = tick()
        tabs.strength.lastCalculationAt = tick()
        tabs.strength.lastCalculatedStrength = tabs.strength.strength.Value
        tabs.strength.lastCalculatedDurability = tabs.strength.durability.Value
    end
end

tabs.strength.calculatePace = function()
    if not tabs.strength.running or not tabs.strength.timerStarted then return end
    local now = tick()
    if now - tabs.strength.lastCalculationAt < tabs.strength.calculationInterval then return end
    local elapsed = now - tabs.strength.lastCalculationAt
    local strengthDelta = tabs.strength.strength.Value - tabs.strength.lastCalculatedStrength
    local durabilityDelta = tabs.strength.durability.Value - tabs.strength.lastCalculatedDurability
    if elapsed > 0 then
        if strengthDelta > 0 then
            local hourly = strengthDelta / elapsed * 3600
            tabs.strength.StrengthPace.Text = "Strength Pace: " .. formatNumber(hourly) .. " / Hour | " .. formatNumber(hourly * 24) .. " / Day"
        end
        if durabilityDelta > 0 then
            local hourly = durabilityDelta / elapsed * 3600
            tabs.strength.DurabilityPace.Text = "Durability Pace: " .. formatNumber(hourly) .. " / Hour | " .. formatNumber(hourly * 24) .. " / Day"
        end
    end
    local averageElapsed = tabs.strength.totalElapsed + now - tabs.strength.startedAt
    if averageElapsed > 0 then
        local averageStrength = (tabs.strength.strength.Value - tabs.strength.startStrength) / averageElapsed * 3600
        local averageDurability = (tabs.strength.durability.Value - tabs.strength.startDurability) / averageElapsed * 3600
        tabs.strength.StrengthAverage.Text = "Strength Average: " .. formatNumber(averageStrength) .. " / Hour | " .. formatNumber(averageStrength * 24) .. " / Day"
        tabs.strength.DurabilityAverage.Text = "Durability Average: " .. formatNumber(averageDurability) .. " / Hour | " .. formatNumber(averageDurability * 24) .. " / Day"
    end
    tabs.strength.lastCalculationAt = now
    tabs.strength.lastCalculatedStrength = tabs.strength.strength.Value
    tabs.strength.lastCalculatedDurability = tabs.strength.durability.Value
end

tabs.strength.workerLoop = function()
    tabs.strength.lastLoopAt = os.clock()
    while tabs.strength.running do
        local now = os.clock()
        local elapsed = math.min(0.01, now - tabs.strength.lastLoopAt)
        tabs.strength.lastLoopAt = now
        tabs.strength.sendRate = tabs.strength.repSpeed
        tabs.strength.sendTokens = math.min(tabs.strength.maxBurst, tabs.strength.sendTokens + tabs.strength.sendRate * elapsed)
        tabs.strength.burstLimit = math.max(1, math.min(tabs.strength.maxBurst, math.ceil(tabs.strength.sendRate * 0.01)))
        tabs.strength.sendCount = math.min(math.floor(tabs.strength.sendTokens), tabs.strength.burstLimit)
        tabs.strength.repIndex = 0.01
        while tabs.strength.repIndex <= tabs.strength.sendCount do
            if not tabs.strength.running then break end
            services.muscleEvent:FireServer("rep")
            tabs.strength.repIndex += 0.01
        end
        tabs.strength.sendTokens = tabs.strength.sendTokens - tabs.strength.sendCount
        services.runservice.Heartbeat:Wait()
    end
    tabs.strength.workerActive = false
end

tabs.strength.startWorker = function()
    if tabs.strength.workerActive then return end
    tabs.strength.workerActive = true
    task.spawn(tabs.strength.workerLoop)
end

tabs.strength.strength:GetPropertyChangedSignal("Value"):Connect(function()
    tabs.strength.updateStats()
    tabs.strength.updatePace()
end)

tabs.strength.durability:GetPropertyChangedSignal("Value"):Connect(function()
    tabs.strength.updateStats()
    tabs.strength.updatePace()
end)

tabs.strength.FastRepToggle = tabs.strength:AddSwitch("⚡️ Fast Rep", function(state)
    tabs.strength.running = state
    if state then
        if not tabs.strength.gainedBaselineSet then
            tabs.strength.startStrength = tabs.strength.strength.Value
            tabs.strength.startDurability = tabs.strength.durability.Value
            tabs.strength.gainedBaselineSet = true
        end
        tabs.strength.timerStarted = false
        tabs.strength.startedAt = 0
        tabs.strength.lastSampleAt = tick()
        tabs.strength.lastStrength = tabs.strength.strength.Value
        tabs.strength.lastDurability = tabs.strength.durability.Value
        tabs.strength.sendRate = tabs.strength.repSpeed
        tabs.strength.sendTokens = 0
        tabs.strength.lastLoopAt = os.clock()
        tabs.strength.Status.Text = "Status: Farming | " .. formatNumber(tabs.strength.repSpeed) .. " reps/s"
        tabs.strength.Status.TextColor3 = Color3.fromRGB(80, 255, 120)
        tabs.strength.startWorker()
    else
        if tabs.strength.timerStarted and tabs.strength.startedAt > 0 then
            tabs.strength.totalElapsed = tabs.strength.totalElapsed + tick() - tabs.strength.startedAt
            tabs.strength.startedAt = 0
            tabs.strength.timerStarted = false
        end
        tabs.strength.sendTokens = 0
        tabs.strength.Status.Text = tabs.strength.gainedBaselineSet and "Status: Paused" or "Status: Inactive"
        tabs.strength.Status.TextColor3 = tabs.strength.gainedBaselineSet and Color3.fromRGB(255, 180, 70) or Color3.fromRGB(255, 80, 80)
        tabs.strength.updateRuntime()
    end
end)
tabs.strength.FastRepToggle:Set(false)

task.spawn(function()
    while true do
        tabs.strength.updateRuntime()
        tabs.strength.calculatePace()
        task.wait(0.01)
    end
end)

--==================================================
-- Shared Fast Farm miscellaneous controls
--==================================================
local function addFastMiscLabel(...)
    local a = tabRebirth:AddLabel(...)
    tabStrength:AddLabel(...)
    return a
end
local function addFastMiscSwitch(...)
    local a = tabRebirth:AddSwitch(...)
    tabStrength:AddSwitch(...)
    return a
end
local function addFastMiscButton(...)
    local a = tabRebirth:AddButton(...)
    tabStrength:AddButton(...)
    return a
end
local function addFastMiscTextBox(...)
    local a = tabRebirth:AddTextBox(...)
    tabStrength:AddTextBox(...)
    return a
end

-- MISC
addFastMiscLabel("============================")
addFastMiscLabel("🎮 MISC").TextSize = 21

addFastMiscSwitch("🔒 Lock Position", function(Value)
    local player = game:GetService("Players").LocalPlayer
    if Value then
        local character = player.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local savedPosition = root.Position
        if _G.LockPositionConnection then _G.LockPositionConnection:Disconnect() end
        _G.LockPositionConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not Value then return end
            local currentCharacter = player.Character
            local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
            if currentRoot then
                currentRoot.CFrame = CFrame.new(savedPosition) * (currentRoot.CFrame - currentRoot.Position)
                currentRoot.AssemblyLinearVelocity = Vector3.zero
            end
        end)
    elseif _G.LockPositionConnection then
        _G.LockPositionConnection:Disconnect()
        _G.LockPositionConnection = nil
    end
end)

addFastMiscButton("⚡ Anti Lag", function()
    local Workspace = game:GetService("Workspace")
    local Lighting = game:GetService("Lighting")
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("PostEffect") then
            obj.Enabled = false
        end
    end
    for _, obj in ipairs(Lighting:GetDescendants()) do
        if obj:IsA("PostEffect") then obj.Enabled = false end
    end
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
end)

addFastMiscSwitch("🥚 Auto Eat Egg 30min", function(Value)
    _G.AutoEatEgg = Value
    if not Value then return end
    task.spawn(function()
        while _G.AutoEatEgg do
            local Player = game:GetService("Players").LocalPlayer
            local Backpack = Player:FindFirstChild("Backpack")
            local Character = Player.Character
            if Backpack and Character then
                local Egg = nil
                for _, item in ipairs(Backpack:GetChildren()) do
                    if item:IsA("Tool") and string.find(string.lower(item.Name), "egg") then
                        Egg = item
                        break
                    end
                end
                if Egg then
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    if Humanoid then
                        Humanoid:EquipTool(Egg)
                        task.wait(0.5)
                        Egg:Activate()
                        task.wait(0.5)
                        local PlayerGui = Player:FindFirstChild("PlayerGui")
                        if PlayerGui then
                            for _, obj in ipairs(PlayerGui:GetDescendants()) do
                                if obj:IsA("TextButton") then
                                    local text = string.lower(obj.Text or "")
                                    if text == "evet" or text == "yes" then
                                        pcall(function() obj:Activate() end)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(1800)
        end
    end)
end)

addFastMiscSwitch("📏 Auto Size 2", function(bool)
    _G.AutoSize2 = bool
    if bool then
        task.spawn(function()
            while _G.AutoSize2 do
                pcall(function()
                    game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2)
                end)
                task.wait(0.1)
            end
        end)
    end
end, "Size 2")

--==================================================
-- MISC TAB
--==================================================
local Misc = window:AddTab("Miscellaneous")

-- SET SPEED
Misc:AddTextBox("⚡️ Set Speed", function(Value)
    local Speed = tonumber(Value)
    if Speed then _G.SetSpeedValue = Speed end
end)

Misc:AddSwitch("⚡️ Set Speed", function(Value)
    _G.SetSpeedEnabled = Value
    local Character = game.Players.LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        if Value then
            Humanoid.WalkSpeed = _G.SetSpeedValue or 16
        else
            Humanoid.WalkSpeed = 16
        end
    end
end)

-- SET SIZE
Misc:AddTextBox("📏 Set Size", function(Value)
    local Size = tonumber(Value)
    if Size then _G.SetSizeValue = Size end
end)

Misc:AddSwitch("📏 Set Size", function(Value)
    _G.SetSizeEnabled = Value
    local Character = game.Players.LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart then
        if Value then
            _G.OriginalSize = HumanoidRootPart.Size
            local Size = _G.SetSizeValue or 2
            HumanoidRootPart.Size = Vector3.new(Size, Size, Size)
        else
            HumanoidRootPart.Size = _G.OriginalSize or Vector3.new(2, 2, 1)
        end
    end
end)

-- AUTO CLAIM CHEST
local function claimChests()
    local lp = game:GetService("Players").LocalPlayer
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local oldCF = root.CFrame
        local chests = {
            Vector3.new(42.25, 1.5, 408.91),
            Vector3.new(-138.43, 1.5, -276.86),
            Vector3.new(-2569.81, 1.5, -554.07),
            Vector3.new(2206.88, 1.5, 910.50),
            Vector3.new(-6713.64, 1.5, -1456.67),
            Vector3.new(4666.53, 995.0, -3692.08),
            Vector3.new(-7913.11, -1.5, 3019.15)
        }
        for _, pos in ipairs(chests) do
            root.CFrame = CFrame.new(pos)
            task.wait(0.15)
        end
        root.CFrame = oldCF
    end
end

Misc:AddButton("📦 Auto Claim Chest", function()
    claimChests()
end)

-- HIDE ALL FRAMES (DÜZELTİLDİ: tabRebirth kullanıldı)
local blockedFrames = {
    "strengthFrame",
    "durabilityFrame",
    "agilityFrame",
    "evilKarmaFrame",
    "goodKarmaFrame",
}

local frameSwitch = tabRebirth:AddSwitch("👁️‍🗨️ Hide All Frames", function(bool)
    if bool then
        for _, name in ipairs(blockedFrames) do
            local frame = replicatedStorage:FindFirstChild(name)
            if frame and frame:IsA("GuiObject") then
                frame.Visible = false
            end
        end
        if not _G.frameMonitorConnection then
            _G.frameMonitorConnection = replicatedStorage.ChildAdded:Connect(function(child)
                for _, name in ipairs(blockedFrames) do
                    if child.Name == name and child:IsA("GuiObject") then
                        child.Visible = false
                    end
                end
            end)
        end
    else
        for _, name in ipairs(blockedFrames) do
            local frame = replicatedStorage:FindFirstChild(name)
            if frame and frame:IsA("GuiObject") then
                frame.Visible = true
            end
        end
        if _G.frameMonitorConnection then
            _G.frameMonitorConnection:Disconnect()
            _G.frameMonitorConnection = nil
        end
    end
end)
frameSwitch:Set(false)

-- LOCK POSITION (Misc)
local switch = Misc:AddSwitch("🔒 Lock Position", function(Value)
    if Value then
        local currentPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        getgenv().posLock = game:GetService("RunService").Heartbeat:Connect(function()
            if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = currentPos
            end
        end)
    else
        if getgenv().posLock then
            getgenv().posLock:Disconnect()
            getgenv().posLock = nil
        end
    end
end)

-- AUTO FORTUNE WHEEL
Misc:AddSwitch("🎰 Auto Fortune Wheel", function(Value)
    _G.autoFortuneWheelActive = Value
    if Value then
        task.spawn(function()
            while _G.autoFortuneWheelActive do
                pcall(function()
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    local wheelRemote = ReplicatedStorage.rEvents:FindFirstChild("openFortuneWheelRemote")
                    local wheelChance = ReplicatedStorage:FindFirstChild("shared")
                        and ReplicatedStorage.shared:FindFirstChild("catalogs")
                        and ReplicatedStorage.shared.catalogs:FindFirstChild("fortuneWheelChances")
                        and ReplicatedStorage.shared.catalogs.fortuneWheelChances:FindFirstChild("Fortune Wheel")
                    if wheelRemote and wheelChance then
                        wheelRemote:InvokeServer("openFortuneWheel", wheelChance)
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
end)

--==================================================
-- ANTI AFK
--==================================================
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local AntiAfkEnabled = false
local AntiAfkThread = nil
local AntiAfkStartTime = 0

local AntiAfkGui = Instance.new("ScreenGui")
AntiAfkGui.Name = "KryvexAntiAfk"
AntiAfkGui.ResetOnSpawn = false
AntiAfkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AntiAfkGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Name = "AntiAfkFrame"
Frame.Size = UDim2.new(0, 190, 0, 115)
Frame.Position = UDim2.new(0.5, -95, 0, 20)
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Visible = false
Frame.Parent = AntiAfkGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Frame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 35, 35)
Stroke.Thickness = 2
Stroke.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "KRYVEX // AFK"
Title.TextColor3 = Color3.fromRGB(255, 45, 45)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.Active = true
Title.Parent = Frame

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Position = UDim2.new(0, 0, 0, 29)
TimeLabel.Size = UDim2.new(1, 0, 0, 30)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "00:00:00"
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.TextSize = 21
TimeLabel.Font = Enum.Font.GothamBold
TimeLabel.Active = true
TimeLabel.Parent = Frame

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Position = UDim2.new(0, 5, 0, 61)
FPSLabel.Size = UDim2.new(0.5, -5, 0, 25)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: 0"
FPSLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
FPSLabel.TextSize = 14
FPSLabel.Font = Enum.Font.GothamSemibold
FPSLabel.Active = true
FPSLabel.Parent = Frame

local MSLabel = Instance.new("TextLabel")
MSLabel.Position = UDim2.new(0.5, 0, 0, 61)
MSLabel.Size = UDim2.new(0.5, -5, 0, 25)
MSLabel.BackgroundTransparency = 1
MSLabel.Text = "MS: 0"
MSLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
MSLabel.TextSize = 14
MSLabel.Font = Enum.Font.GothamSemibold
MSLabel.Active = true
MSLabel.Parent = Frame

local Status = Instance.new("TextLabel")
Status.Position = UDim2.new(0, 0, 0, 87)
Status.Size = UDim2.new(1, 0, 0, 22)
Status.BackgroundTransparency = 1
Status.Text = "● ACTIVE"
Status.TextColor3 = Color3.fromRGB(255, 45, 45)
Status.TextSize = 12
Status.Font = Enum.Font.Gotham
Status.Active = true
Status.Parent = Frame

-- Drag
local Dragging = false
local DragInput = nil
local DragStart = nil
local StartPosition = nil

local function UpdateDrag(Input)
    if not Dragging then return end
    local Delta = Input.Position - DragStart
    Frame.Position = UDim2.new(
        StartPosition.X.Scale,
        StartPosition.X.Offset + Delta.X,
        StartPosition.Y.Scale,
        StartPosition.Y.Offset + Delta.Y
    )
end

local function StartDrag(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPosition = Frame.Position
        DragInput = Input
        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
                DragInput = nil
            end
        end)
    end
end

Frame.InputBegan:Connect(StartDrag)
Title.InputBegan:Connect(StartDrag)
TimeLabel.InputBegan:Connect(StartDrag)
FPSLabel.InputBegan:Connect(StartDrag)
MSLabel.InputBegan:Connect(StartDrag)
Status.InputBegan:Connect(StartDrag)

UserInputService.InputChanged:Connect(function(Input)
    if Input == DragInput
        or Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then
        UpdateDrag(Input)
    end
end)

-- FPS
local FPS = 0
local FrameCount = 0
local LastFPSTime = os.clock()

RunService.RenderStepped:Connect(function()
    FrameCount += 1
    local Now = os.clock()
    if Now - LastFPSTime >= 1 then
        FPS = FrameCount
        FrameCount = 0
        LastFPSTime = Now
        if AntiAfkEnabled then
            FPSLabel.Text = "FPS: " .. FPS
        end
    end
end)

-- Ping
local function GetPing()
    local Ping = 0
    pcall(function()
        local Network = Stats:FindFirstChild("Network")
        if Network then
            local ServerStats = Network:FindFirstChild("ServerStatsItem")
            if ServerStats then
                local DataPing = ServerStats:FindFirstChild("Data Ping")
                if DataPing then
                    Ping = math.floor(DataPing:GetValue())
                end
            end
        end
    end)
    return Ping
end

-- Timer
task.spawn(function()
    while true do
        task.wait(1)
        if AntiAfkEnabled then
            local Elapsed = math.floor(os.clock() - AntiAfkStartTime)
            local Days = math.floor(Elapsed / 86400)
            local Hours = math.floor((Elapsed % 86400) / 3600)
            local Minutes = math.floor((Elapsed % 3600) / 60)
            local Seconds = Elapsed % 60
            if Days > 0 then
                TimeLabel.Text = string.format("%02d:%02d:%02d:%02d", Days, Hours, Minutes, Seconds)
            else
                TimeLabel.Text = string.format("%02d:%02d:%02d", Hours, Minutes, Seconds)
            end
            MSLabel.Text = "MS: " .. GetPing()
        end
    end
end)

-- Anti AFK Switch
Misc:AddSwitch("⏰ Anti Afk", function(Value)
    AntiAfkEnabled = Value
    Frame.Visible = Value
    if Value then
        AntiAfkStartTime = os.clock()
        TimeLabel.Text = "00:00:00"
        FPSLabel.Text = "FPS: " .. FPS
        MSLabel.Text = "MS: " .. GetPing()
        Status.Text = "● ACTIVE"
        if AntiAfkThread then task.cancel(AntiAfkThread) end
        AntiAfkThread = task.spawn(function()
            while AntiAfkEnabled do
                task.wait(600)
                if AntiAfkEnabled then
                    pcall(function()
                        local Camera = workspace.CurrentCamera
                        if Camera then
                            local Viewport = Camera.ViewportSize
                            local X = Viewport.X / 2
                            local Y = Viewport.Y / 2
                            VirtualInputManager:SendMouseButtonEvent(X, Y, 0, true, game, 0)
                            task.wait(0.1)
                            VirtualInputManager:SendMouseButtonEvent(X, Y, 0, false, game, 0)
                        end
                    end)
                end
            end
        end)
    else
        Status.Text = "● DISABLED"
        if AntiAfkThread then task.cancel(AntiAfkThread) AntiAfkThread = nil end
    end
end)

-- FPS Boost
local FPSBoostEnabled = false
Misc:AddButton("⚡ FPS Boost", function()
    local Lighting = game:GetService("Lighting")
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    FPSBoostEnabled = not FPSBoostEnabled
    if FPSBoostEnabled then
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") then v.Enabled = false end
        end
        if Terrain then
            pcall(function()
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
                Terrain.WaterTransparency = 1
                Terrain.Decoration = false
            end)
        end
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then pcall(function() v.CastShadow = false end) end
        end
        print("⚡ FPS Boost: ON")
    else
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic end)
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") then v.Enabled = true end
        end
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then pcall(function() v.CastShadow = true end) end
        end
        print("⚡ FPS Boost: OFF")
    end
end)

-- Hide Effects
Misc:AddButton("👻 Hide Effects", function()
    local Workspace = game:GetService("Workspace")
    local Lighting = game:GetService("Lighting")
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = false
        end
    end
    for _, obj in ipairs(Lighting:GetDescendants()) do
        if obj:IsA("PostEffect") then obj.Enabled = false end
    end
end)

-- Change Time
Misc:AddLabel(" 🌦️ Change Time ")
local timeDropdown = Misc:AddDropdown("Change Time", function(selection)
    local lighting = game:GetService("Lighting")
    if selection == "Night" then
        lighting.ClockTime = 0
    elseif selection == "Day" then
        lighting.ClockTime = 12
    elseif selection == "Midnight" then
        lighting.ClockTime = 6
    end
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Changed Time",
        Text = "the time has been changed: " .. selection,
        Duration = 0
    })
end)
timeDropdown:Add("Night")
timeDropdown:Add("Day")
timeDropdown:Add("Midnight")

-- Gamepass AutoLift
Misc:AddButton("💎 Gamepass AutoLift", function()
    local gamepassFolder = game:GetService("ReplicatedStorage").gamepassIds
    local player = game:GetService("Players").LocalPlayer
    for _, gamepass in pairs(gamepassFolder:GetChildren()) do
        local value = Instance.new("IntValue")
        value.Name = gamepass.Name
        value.Value = gamepass.Value
        value.Parent = player.ownedGamepasses
    end
end, "🔓 Unlock AutoLift Pass")

-- Walk on Water (EKSİK FONKSİYONLAR EKLENDİ)
local function createParts()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local waterPart = Instance.new("Part")
    waterPart.Name = "WaterWalkPart"
    waterPart.Size = Vector3.new(10, 1, 10)
    waterPart.Transparency = 1
    waterPart.CanCollide = true
    waterPart.Anchored = true
    waterPart.Parent = workspace
    waterPart.CFrame = CFrame.new(hrp.Position.X, 0.5, hrp.Position.Z)
    
    _G.WaterWalkConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if character and character:FindFirstChild("HumanoidRootPart") then
            local pos = character.HumanoidRootPart.Position
            waterPart.CFrame = CFrame.new(pos.X, 0.5, pos.Z)
        end
    end)
end

local function makePartsWalkthrough()
    if _G.WaterWalkConnection then
        _G.WaterWalkConnection:Disconnect()
        _G.WaterWalkConnection = nil
    end
    local part = workspace:FindFirstChild("WaterWalkPart")
    if part then part:Destroy() end
end

Misc:AddSwitch("🌊 Full Walk on Water", function(bool)
    if bool then
        createParts()
    else
        makePartsWalkthrough()
    end
end)

-- Rejoin
Misc:AddButton("🔄 Rejoin Game", function()
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    local YesButton = Instance.new("TextButton")
    local NoButton = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")

    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.Name = "RejoinConfirm"

    Frame.Name = "MainFrame"
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
    Frame.Size = UDim2.new(0, 250, 0, 150)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

    TextLabel.Parent = Frame
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0, 10, 0, 20)
    TextLabel.Size = UDim2.new(0, 230, 0, 50)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Text = "Are you sure you want to rejoin?"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 16
    TextLabel.TextWrapped = true

    YesButton.Name = "YesButton"
    YesButton.Parent = Frame
    YesButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    YesButton.Position = UDim2.new(0, 25, 0, 90)
    YesButton.Size = UDim2.new(0, 85, 0, 35)
    YesButton.Font = Enum.Font.GothamBold
    YesButton.Text = "YES"
    YesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    YesButton.TextSize = 14
    Instance.new("UICorner", YesButton).CornerRadius = UDim.new(0, 6)

    NoButton.Name = "NoButton"
    NoButton.Parent = Frame
    NoButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    NoButton.Position = UDim2.new(0, 140, 0, 90)
    NoButton.Size = UDim2.new(0, 85, 0, 35)
    NoButton.Font = Enum.Font.GothamBold
    NoButton.Text = "NO"
    NoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoButton.TextSize = 14
    Instance.new("UICorner", NoButton).CornerRadius = UDim.new(0, 6)

    YesButton.MouseButton1Click:Connect(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end)
    NoButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
end)

-- Anti Knockback
Misc:AddSwitch("🧱 Anti Knockback", function(Value)
    if Value then
        local playerName = game.Players.LocalPlayer.Name
        local char = game.Workspace:FindFirstChild(playerName)
        if char then
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.P = 1250
                bodyVelocity.Parent = rootPart
            end
        end
    else
        local playerName = game.Players.LocalPlayer.Name
        local char = game.Workspace:FindFirstChild(playerName)
        if char then
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local existingVelocity = rootPart:FindFirstChild("BodyVelocity")
                if existingVelocity and existingVelocity.MaxForce == Vector3.new(100000, 0, 100000) then
                    existingVelocity:Destroy()
                end
            end
        end
    end
end)

-- No Clip
local RunService2 = game:GetService("RunService")
local Players2 = game:GetService("Players")
local player2 = Players2.LocalPlayer
local noclipEnabled = false
local noclipConnection = nil

local function startNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    noclipConnection = RunService2.Stepped:Connect(function()
        if noclipEnabled and player2.Character then
            for _, part in pairs(player2.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

Misc:AddSwitch("👻 No Clip", function(bool)
    noclipEnabled = bool
    if noclipEnabled then
        startNoclip()
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        if player2.Character then
            for _, part in pairs(player2.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

player2.CharacterAdded:Connect(function()
    if noclipEnabled then
        task.wait(0.1)
        startNoclip()
    end
end)

--==================================================
-- CREDITS TAB
--==================================================
local credits = window:AddTab("Credits")

local title = credits:AddLabel("✨ KRYVEX PAID")
title.TextColor3 = Color3.fromRGB(255, 215, 0)

local dev = credits:AddLabel("👤 Developer: WozzyLaco🏴")
dev.TextColor3 = Color3.fromRGB(255, 50, 50)

credits:AddLabel("--------------------------")

local thanks = credits:AddLabel("🤝 Special Thanks to: Halis & Henne & RuLing")
thanks.TextColor3 = Color3.fromRGB(0, 255, 255)

local support = credits:AddLabel("❤️ Thanks for the support!")
support.TextColor3 = Color3.fromRGB(255, 105, 180)

credits:AddLabel("--------------------------")

local useMsg = credits:AddLabel("🙏 Thank you for using Kryvex Hub!")
useMsg.TextColor3 = Color3.fromRGB(255, 255, 255)

credits:AddLabel("👇 My Discord Server Link Here")

credits:AddButton("Discord Link", function()
    setclipboard("https://discord.gg/DbAU5Z6HPd")
end)

credits:AddLabel(" ")
credits:AddLabel("==================================")

local bigTitle = credits:AddLabel("🚀 KRYVEX PRİVATE V2 🚀")
pcall(function()
    bigTitle.TextSize = 25
    bigTitle.Font = Enum.Font.GothamBold
end)

task.spawn(function()
    while true do
        for i = 0, 1, 0.005 do
            bigTitle.TextColor3 = Color3.fromHSV(i, 1, 1)
            task.wait()
        end
    end
end)

credits:AddLabel("==================================")
