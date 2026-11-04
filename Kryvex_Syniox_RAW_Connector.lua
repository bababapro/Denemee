local services = {
    players = game:GetService("Players"),
    replicatedstorage = game:GetService("ReplicatedStorage"),
    runservice = game:GetService("RunService"),
    tws = game:GetService("TweenService"),
    userinputservice = game:GetService("UserInputService"),
    httpservice = game:GetService("HttpService"),
    virtualinputmanager = game:GetService("VirtualInputManager"),
    lighting = game:GetService("Lighting"),
    startergui = game:GetService("StarterGui"),
    collectionservice = game:GetService("CollectionService")
}



local runtime = {Connections = {}}

function runtime:Spawn(callback, ...)
    return task.spawn(callback, ...)
end

function runtime:Connect(signal, callback)
    local connection = signal:Connect(callback)
    self.Connections[connection] = true
    return connection
end


local lp = {
    player = services.players.LocalPlayer,
    userid = services.players.LocalPlayer.UserId,
    username = services.players.LocalPlayer.Name,
    displayname = services.players.LocalPlayer.DisplayName
}

services.muscleEvent = lp.player:WaitForChild("muscleEvent")
services.touchParts = function(part, hand, state)
    if type(firetouchinterest) ~= "function" or not part or not hand then return false end
    return pcall(firetouchinterest, part, hand, state)
end

local function greeting(hour)
    hour = hour or os.date("*t").hour
    if hour >= 6 and hour < 12 then return "Good Morning!"
    elseif hour >= 12 and hour < 13 then return "Good Noon!"
    elseif hour >= 13 and hour < 19 then return "Good Afternoon!"
    elseif hour >= 19 and hour < 22 then return "Good Evening!"
    else return "Good Night!" end
end


-- Load your Syniox GUI library from its RAW link.
-- Replace the URL below with your own Syniox GUI RAW URL.
local Library = loadstring(game:HttpGet("https://github.com/bababapro/Denemee/raw/refs/heads/main/SynioxGui%20(3).txt"))()




local accent = Color3.fromRGB(210, 35, 45)
local window = Library:AddWindow("Kryvex Hub", {
    main_color = accent,
    title_bar = {accent},
    background = {Color3.fromRGB(15, 15, 18)},
    min_size = Vector2.new(500, 560),
    toggle_key = Enum.KeyCode.RightShift,
    can_resize = true
})

local tabs = {
    rebirths = window:AddTab("Fast Rebirth"),
    strength = window:AddTab("Fast Strength")
}

tabs.rebirths:Show()


function formatNumber(num)
    if num >= 1e18 then return string.format("%.2fQi", num/1e18) end
    if num >= 1e15 then return string.format("%.2fQa", num/1e15) end
    if num >= 1e12 then return string.format("%.2fT", num/1e12) end
    if num >= 1e9 then return string.format("%.2fB", num/1e9) end
    if num >= 1e6 then return string.format("%.2fM", num/1e6) end
    if num >= 1e3 then return string.format("%.2fK", num/1e3) end
    return string.format("%.0f", num)
end


local function formatCurrentStat(value)
    return formatNumber(value)
end

function formatRate(ratePerSecond)
    return formatNumber(ratePerSecond) .. "/s | "
        .. formatNumber(ratePerSecond * 60) .. "/min | "
        .. formatNumber(ratePerSecond * 3600) .. "/h | "
        .. formatNumber(ratePerSecond * 86400) .. "/d"
end

local PETS = {
    ["Omega Overlord"] = {
        repSpeed = 20,
        strength = 0,
        durability = 0,
        rebirth = 0,
    },

    ["Swift Samurai"] = {
        repSpeed = 15,
        strength = 0,
        durability = 0,
        rebirth = 0,
    },

    ["Powercore Hound"] = {
        repSpeed = 0,
        strength = 25,
        durability = 15,
        rebirth = 0,
    },

    ["Titanium Hydra"] = {
        repSpeed = 0,
        strength = 0,
        durability = 0,
        rebirth = 2,
    },

    ["Tribal Overlord"] = {
        repSpeed = 0,
        strength = 0,
        durability = 0,
        rebirth = 2,
    },
	["Inferno Unicorn"] = {
		repSpeed = 0,
		strength = 25,
		durability = 25,
		rebirth = 0,
	},
	["Common Boss Pet"] = {
		repSpeed = 5,
		strength = 0,
		durability = 0,
		rebirth = 0,
	},
	["Rare Boss Pet"] = {
		repSpeed = 7,
		strength = 0,
		durability = 0,
		rebirth = 0,
	},
	["Epic Boss Pet"] = {
		repSpeed = 10,
		strength = 0,
		durability = 0,
		rebirth = 0,
	},
	["Rainbow Boss Pet"] = {
		repSpeed = 10,
		strength = 7,
		durability = 0,
		rebirth = 0,
	},
	["Legendary Boss Pet"] = {
		repSpeed = 10,
		strength = 10,
		durability = 0,
		rebirth = 0,
	},
	["Mythic Boss Pet"] = {
		repSpeed = 10,
		strength = 20,
		durability = 0,
		rebirth = 0,
	},
    ["Inferno Drake"] = {
        repSpeed = 40,
        strength = 0,
        durability = 0,
        rebirth = 0,
    },
}

local MAX_PET_SLOTS = 12
local TARGET_REP_SPEED = 100

local function applyPetLoadout(selected, isCurrent)
    local remote = services.replicatedstorage.rEvents.equipPetEvent
    for _, folder in ipairs(lp.player.petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in ipairs(folder:GetChildren()) do
                if isCurrent and not isCurrent() then return false end
                remote:FireServer("unequipPet", pet)
            end
        end
    end
    task.wait(0.1)
    for _, pet in ipairs(selected) do
        if isCurrent and not isCurrent() then return false end
        remote:FireServer("equipPet", pet)
    end
    task.wait(0.1)
    return not isCurrent or isCurrent()
end

local function sendTrainingReps(state, rate, maxBurst, canSend)
    local now = os.clock()
    local elapsed = math.clamp(now - (state.LastAt or now), 0, 0.1)
    state.LastAt = now
    state.Tokens = math.min(maxBurst, (state.Tokens or 0) + rate * elapsed)
    local sent = 0
    while state.Tokens >= 1 and canSend() do
        services.muscleEvent:FireServer("rep")
        state.Tokens = state.Tokens - 1
        sent = sent + 1
    end
    return sent
end


local function getElapsed(tab)
    return tab.totalElapsed + (tab.timerStarted and os.clock() - tab.startedAt or 0)
end

local function setTimerRunning(tab, enabled)
    tab.totalElapsed = getElapsed(tab)
    tab.startedAt = os.clock()
    tab.timerStarted = enabled
end

local function recordStatGain(tab, key, value)
    local previous = tab.statSamples[key]
    tab.statSamples[key] = value
    if tab.running and tab.timerStarted and previous then
        tab.statGains[key] = tab.statGains[key] + math.max(0, value - previous)
    end
end

local function updateRuntimeLabel(tab)
    local elapsed = getElapsed(tab)
    tab.Runtime.Text = string.format("Runtime: %dd %dh %dm %ds",
        math.floor(elapsed / 86400), math.floor(elapsed % 86400 / 3600),
        math.floor(elapsed % 3600 / 60), math.floor(elapsed % 60))
end

local function resetCalculations(tab)
    tab.totalElapsed = 0
    tab.startedAt = os.clock()
    tab.timerStarted = tab.running and tab.timerStarted
    tab.nextAverageElapsed = 10
    for key in pairs(tab.statGains) do
        tab.statGains[key] = 0
    end
    for key, stat in pairs({Rebirths = tab.rebirths, Strength = tab.strength, Durability = tab.durability}) do
        if tab.statSamples[key] ~= nil then tab.statSamples[key] = stat.Value end
    end
    if tab.AverageRate then
        tab.baselineReady = false
        tab.timerStarted = false
        tab.measuredCycles = 0
        tab.AverageRate.Text = "Average: -- / Hour | -- / Day | -- / Week"
    else
        tab.StrengthAverage.Text = "Str Ø: --/s | --/min | --/h | --/d"
        tab.DurabilityAverage.Text = "Dura Ø: --/s | --/min | --/h | --/d"
    end
    tab.updateStats()
    tab.updateRuntime()
end


local function getOwnedConfiguredPets()
    local ownedPets = {}

    for _, folder in ipairs(lp.player.petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in ipairs(folder:GetChildren()) do
                local config = PETS[pet.Name]
                if config then
                    table.insert(ownedPets, {
                        instance = pet,
                        name = pet.Name,
                        repSpeed = config.repSpeed or 0,
                        strength = config.strength or 0,
                        durability = config.durability or 0,
                        rebirth = config.rebirth or 0,
                    })
                end
            end
        end
    end

    return ownedPets
end

local function equipBestFarmingPets(isCurrent)
    if isCurrent and not isCurrent() then return end

    local pets = getOwnedConfiguredPets()
    local selected = {}
    local equipped = {}
    local equippedCount = 0
    local currentRepSpeed = 0

    table.sort(pets, function(a, b)
        return a.repSpeed > b.repSpeed
    end)

    for _, pet in ipairs(pets) do
        if equippedCount >= MAX_PET_SLOTS or currentRepSpeed >= TARGET_REP_SPEED then
            break
        end

        if pet.repSpeed > 0 then
            table.insert(selected, pet.instance)
            equipped[pet.instance] = true
            equippedCount = equippedCount + 1
            currentRepSpeed = currentRepSpeed + pet.repSpeed
        end
    end

    local remainingPets = {}

    for _, pet in ipairs(pets) do
        if not equipped[pet.instance] then
            table.insert(remainingPets, pet)
        end
    end

    table.sort(remainingPets, function(a, b)
        local scoreA = a.strength + a.durability
        local scoreB = b.strength + b.durability
        return scoreA > scoreB
    end)

    for _, pet in ipairs(remainingPets) do
        if equippedCount >= MAX_PET_SLOTS then
            break
        end

        if pet.strength > 0 or pet.durability > 0 then
            table.insert(selected, pet.instance)
            equipped[pet.instance] = true
            equippedCount = equippedCount + 1
        end
    end

    applyPetLoadout(selected, isCurrent)
    return currentRepSpeed, equippedCount
end

local function equipBestRebirthPets(isCurrent)
    if isCurrent and not isCurrent() then return end

    local pets = getOwnedConfiguredPets()
    local selected = {}

    table.sort(pets, function(a, b)
        return a.rebirth > b.rebirth
    end)

    local equippedCount = 0
    local totalRebirthMultiplier = 0

    for _, pet in ipairs(pets) do
        if equippedCount >= MAX_PET_SLOTS then
            break
        end

        if pet.rebirth > 0 then
            table.insert(selected, pet.instance)
            equippedCount = equippedCount + 1
            totalRebirthMultiplier = totalRebirthMultiplier + pet.rebirth
        end
    end

    applyPetLoadout(selected, isCurrent)
    return totalRebirthMultiplier, equippedCount
end


tabs.rebirths.leaderstats = lp.player:WaitForChild("leaderstats")
tabs.rebirths.rebirths = tabs.rebirths.leaderstats:WaitForChild("Rebirths")
tabs.rebirths.strength = tabs.rebirths.leaderstats:WaitForChild("Strength")
tabs.rebirths.running = false
tabs.rebirths.workerActive = false
tabs.rebirths.startedAt = 0
tabs.rebirths.timerStarted = false
tabs.rebirths.hasStarted = false
tabs.rebirths.baselineReady = false
tabs.rebirths.measuredCycles = 0
tabs.rebirths.lastConfirmedAt = nil
tabs.rebirths.nextRequestAt = 0
tabs.rebirths.cooldown = 6
tabs.rebirths.totalElapsed = 0
tabs.rebirths.statSamples = {Rebirths = tabs.rebirths.rebirths.Value}
tabs.rebirths.statGains = {Rebirths = 0}
tabs.rebirths.generation = 0
tabs.rebirths.adaptive = {
    TargetSeconds = 3,
    MinRate = 3,
    MaxRate = 50,
    SendRate = 10,
    ProbeRate = 10,
    ProbeReps = 10,
    FeedbackTimeout = 1,
    StrengthPerRep = nil,
    LastTrainingSeconds = nil
}
tabs.rebirths.Status = tabs.rebirths:AddLabel("Status: Inactive")
tabs.rebirths.Runtime = tabs.rebirths:AddLabel("Runtime: 0d 0h 0m 0s")
tabs.rebirths.RebirthStats = tabs.rebirths:AddLabel("Rebirths: " .. formatCurrentStat(tabs.rebirths.rebirths.Value) .. " | Gained: 0")
tabs.rebirths.RebirthStats:SetAttribute("EleriumUpdateInterval", 0.05)
tabs.rebirths.AverageRate = tabs.rebirths:AddLabel("Average: -- / Hour | -- / Day | -- / Week")
tabs.rebirths.Status.TextColor3 = Color3.fromRGB(255, 80, 80)

tabs.rebirths.updateStats = function()
    tabs.rebirths.RebirthStats.Text = "Rebirths: " .. formatCurrentStat(tabs.rebirths.rebirths.Value)
        .. " | Gained: " .. formatNumber(tabs.rebirths.statGains.Rebirths)
end

tabs.rebirths.updateRuntime = function()
    updateRuntimeLabel(tabs.rebirths)
end

tabs.rebirths.updateAverage = function()
    local elapsed = getElapsed(tabs.rebirths)
    if elapsed <= 0 then return end
    local hourly = tabs.rebirths.statGains.Rebirths / elapsed * 3600
    tabs.rebirths.AverageRate.Text = string.format("Average: %s / Hour | %s / Day | %s / Week",
        formatNumber(hourly), formatNumber(hourly * 24), formatNumber(hourly * 168))
end

tabs.rebirths:AddButton("Reset Calcs", function()
    resetCalculations(tabs.rebirths)
end)

tabs.rebirths.isCurrent = function(generation)
    return tabs.rebirths.running and tabs.rebirths.generation == generation
end

tabs.rebirths.equipFarmingPets = function(generation)
    equipBestFarmingPets(function() return tabs.rebirths.isCurrent(generation) end)
end

tabs.rebirths.equipRebirthPets = function(generation)
    equipBestRebirthPets(function() return tabs.rebirths.isCurrent(generation) end)
end

tabs.rebirths.updateAdaptiveSpeed = function(cycle, finalSample)
    local adaptive = tabs.rebirths.adaptive
    local now = os.clock()
    if not finalSample and now - cycle.SampleAt < 0.25 then return end
    local strength = tabs.rebirths.strength.Value
    local gain = strength - cycle.StartStrength
    if gain > 0 and cycle.Sent > 0 and (finalSample or strength > cycle.SampleStrength) then
        adaptive.StrengthPerRep = gain / cycle.Sent
        cycle.SampleStrength = strength
    end
    if adaptive.StrengthPerRep and adaptive.StrengthPerRep > 0 then
        local reps = math.max(1, math.ceil(math.max(0, cycle.Target - cycle.StartStrength) / adaptive.StrengthPerRep))
        adaptive.SendRate = math.clamp(reps / adaptive.TargetSeconds, adaptive.MinRate, adaptive.MaxRate)
    else
        adaptive.SendRate = adaptive.ProbeRate
    end
    cycle.SampleAt = now
end

tabs.rebirths.performRebirth = function(generation)
    local adaptive = tabs.rebirths.adaptive
    local cycle = {
        Target = 5000 + tabs.rebirths.rebirths.Value * 2550,
        Rebirths = tabs.rebirths.rebirths.Value,
        SampleAt = os.clock(),
        StartStrength = tabs.rebirths.strength.Value,
        SampleStrength = tabs.rebirths.strength.Value,
        LastSentAt = os.clock(),
        Sent = 0,
        Tokens = 0,
        LastAt = os.clock(),
        StatusAt = -math.huge,
        TrainingSeconds = 0
    }
    adaptive.SendRate = adaptive.StrengthPerRep and math.clamp(
        math.max(0, cycle.Target - cycle.StartStrength) / adaptive.StrengthPerRep / adaptive.TargetSeconds,
        adaptive.MinRate, adaptive.MaxRate) or adaptive.ProbeRate
    cycle.RepBudget = adaptive.StrengthPerRep and math.max(adaptive.ProbeReps, math.ceil(
        math.max(0, cycle.Target - cycle.StartStrength) / adaptive.StrengthPerRep)) or adaptive.ProbeReps
    local lastTrainingAt = os.clock()
    local function needsTraining()
        return tabs.rebirths.isCurrent(generation)
            and tabs.rebirths.rebirths.Value == cycle.Rebirths
            and tabs.rebirths.strength.Value < cycle.Target
    end
    while needsTraining() do
        local now = os.clock()
        local character = lp.player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            cycle.TrainingSeconds = cycle.TrainingSeconds + math.max(0, now - lastTrainingAt)
            tabs.rebirths.updateAdaptiveSpeed(cycle)
            if cycle.Sent >= cycle.RepBudget then
                cycle.Tokens = 0
                cycle.LastAt = now
                if now - cycle.LastSentAt >= adaptive.FeedbackTimeout then
                    local missing = math.max(0, cycle.Target - tabs.rebirths.strength.Value)
                    local extra = adaptive.StrengthPerRep and math.ceil(missing / adaptive.StrengthPerRep) or adaptive.ProbeReps
                    cycle.RepBudget = cycle.Sent + math.clamp(extra, math.ceil(adaptive.ProbeReps / 2), adaptive.ProbeReps)
                end
            else
                local budget = cycle.RepBudget - cycle.Sent
                local sent = sendTrainingReps(cycle, adaptive.SendRate, 5, function()
                    if budget <= 0 or not needsTraining() then return false end
                    budget = budget - 1
                    return true
                end)
                cycle.Sent = cycle.Sent + sent
                if sent > 0 then cycle.LastSentAt = now end
            end
            if now - cycle.StatusAt >= 0.25 then
                tabs.rebirths.Status.Text = (cycle.Sent >= cycle.RepBudget and "Status: Waiting for Strength Update | " or "Status: Strength Training | ")
                    .. string.format("%.1fs", cycle.TrainingSeconds) .. " | " .. formatNumber(adaptive.SendRate) .. " reps/s"
                cycle.StatusAt = now
            end
        else
            cycle.Tokens = 0
            cycle.LastAt = now
            tabs.rebirths.Status.Text = "Status: Waiting for Respawn"
        end
        lastTrainingAt = now
        services.runservice.Heartbeat:Wait()
    end
    if not tabs.rebirths.isCurrent(generation) or tabs.rebirths.rebirths.Value ~= cycle.Rebirths then return end
    tabs.rebirths.updateAdaptiveSpeed(cycle, true)
    adaptive.LastTrainingSeconds = cycle.TrainingSeconds
    tabs.rebirths.Status.Text = "Status: Switching to Rebirth Pets"
    tabs.rebirths.equipRebirthPets(generation)
    task.wait(0.25)
    while tabs.rebirths.isCurrent(generation) and tabs.rebirths.rebirths.Value == cycle.Rebirths do
        local remaining = tabs.rebirths.nextRequestAt - os.clock()
        if remaining > 0 then
            tabs.rebirths.Status.Text = "Status: Rebirth Cooldown | " .. string.format("%.1fs", remaining)
            task.wait(math.min(remaining, 0.1))
        else
            tabs.rebirths.nextRequestAt = os.clock() + tabs.rebirths.cooldown
            services.replicatedstorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
            tabs.rebirths.recordRebirth()
        end
    end
end

tabs.rebirths.startWorker = function()
    if tabs.rebirths.workerActive then return end
    tabs.rebirths.workerActive = true
    runtime:Spawn(function(generation, success)
        success = pcall(function()
            while tabs.rebirths.isCurrent(generation) do
                tabs.rebirths.equipFarmingPets(generation)
                if not tabs.rebirths.isCurrent(generation) then break end
                tabs.rebirths.performRebirth(generation)
                task.wait()
            end
        end)
        tabs.rebirths.workerActive = false
        if not success then task.wait(0.5) end
        if tabs.rebirths.running then tabs.rebirths.startWorker() end
    end, tabs.rebirths.generation)
end

tabs.rebirths.recordRebirth = function()
    local current = tabs.rebirths.rebirths.Value
    local previous = tabs.rebirths.statSamples.Rebirths
    if current > previous then
        tabs.rebirths.lastConfirmedAt = os.clock()
        tabs.rebirths.nextRequestAt = tabs.rebirths.lastConfirmedAt + tabs.rebirths.cooldown
        if tabs.rebirths.running then
            if not tabs.rebirths.baselineReady then
                tabs.rebirths.baselineReady = true
                tabs.rebirths.statSamples.Rebirths = current
                setTimerRunning(tabs.rebirths, true)
            else
                recordStatGain(tabs.rebirths, "Rebirths", current)
                tabs.rebirths.measuredCycles = tabs.rebirths.measuredCycles + 1
                if tabs.rebirths.measuredCycles >= 2 then tabs.rebirths.updateAverage() end
            end
        end
    end
    tabs.rebirths.statSamples.Rebirths = current
    tabs.rebirths.updateStats()
end

runtime:Connect(tabs.rebirths.rebirths:GetPropertyChangedSignal("Value"), tabs.rebirths.recordRebirth)

tabs.rebirths.Switch = tabs.rebirths:AddSwitch("Fast Rebirth", function(state)
    tabs.rebirths.recordRebirth()
    setTimerRunning(tabs.rebirths, state and tabs.rebirths.baselineReady)
    tabs.rebirths.statSamples.Rebirths = tabs.rebirths.rebirths.Value
    tabs.rebirths.generation = tabs.rebirths.generation + 1
    tabs.rebirths.running = state
    if state then
        if tabs.strength.running then tabs.strength.FastRepToggle:Set(false) end
        tabs.rebirths.hasStarted = true
        tabs.rebirths.Status.Text = "Status: Rebirthing"
        tabs.rebirths.Status.TextColor3 = Color3.fromRGB(80, 255, 120)
        tabs.rebirths.updateStats()
        tabs.rebirths.startWorker()
    else
        tabs.rebirths.Status.Text = tabs.rebirths.hasStarted and "Status: Paused" or "Status: Inactive"
        tabs.rebirths.Status.TextColor3 = tabs.rebirths.hasStarted and Color3.fromRGB(255, 180, 70) or Color3.fromRGB(255, 80, 80)
    end
    tabs.rebirths.updateRuntime()
end)

tabs.strength.leaderstats = lp.player:WaitForChild("leaderstats")
tabs.strength.strength = tabs.strength.leaderstats:WaitForChild("Strength")
tabs.strength.durability = lp.player:WaitForChild("Durability")
tabs.strength.running = false
tabs.strength.workerActive = false
tabs.strength.startedAt = 0
tabs.strength.totalElapsed = 0
tabs.strength.timerStarted = false
tabs.strength.gainedBaselineSet = false
tabs.strength.statSamples = {Strength = tabs.strength.strength.Value, Durability = tabs.strength.durability.Value}
tabs.strength.statGains = {Strength = 0, Durability = 0}
tabs.strength.initialSendRate = 200
tabs.strength.maxSendRate = 200
tabs.strength.sendRate = math.min(tabs.strength.initialSendRate, tabs.strength.maxSendRate)
tabs.strength.maxBurst = 24
tabs.strength.Tokens = 0
tabs.strength.controlInterval = 0.5
tabs.strength.lastControlAt = tick()
tabs.strength.lastControlStrength = tabs.strength.strength.Value
tabs.strength.lastControlDurability = tabs.strength.durability.Value
tabs.strength.stalledIntervals = 0
tabs.strength.LastAt = os.clock()
tabs.strength.Status = tabs.strength:AddLabel("Status: Inactive")
tabs.strength.Runtime = tabs.strength:AddLabel("Runtime: 0d 0h 0m 0s")
tabs.strength.StrengthStats = tabs.strength:AddLabel("Strength: " .. formatCurrentStat(tabs.strength.strength.Value) .. " | Gained: 0")
tabs.strength.StrengthStats:SetAttribute("EleriumUpdateInterval", 0.02)
tabs.strength.DurabilityStats = tabs.strength:AddLabel("Durability: " .. formatCurrentStat(tabs.strength.durability.Value) .. " | Gained: 0")
tabs.strength.DurabilityStats:SetAttribute("EleriumUpdateInterval", 0.02)
tabs.strength.StrengthAverage = tabs.strength:AddLabel("Str Ø: --/s | --/min | --/h | --/d")
tabs.strength.DurabilityAverage = tabs.strength:AddLabel("Dura Ø: --/s | --/min | --/h | --/d")
tabs.strength.Status.TextColor3 = Color3.fromRGB(255, 80, 80)

tabs.strength.updateRuntime = function()
    updateRuntimeLabel(tabs.strength)
end

tabs.strength.updateStats = function()
    tabs.strength.StrengthStats.Text = "Strength: " .. formatCurrentStat(tabs.strength.strength.Value)
        .. " | Gained: " .. (tabs.strength.running and not tabs.strength.timerStarted
            and "Preparing" or formatNumber(tabs.strength.statGains.Strength))
    tabs.strength.DurabilityStats.Text = "Durability: " .. formatCurrentStat(tabs.strength.durability.Value)
        .. " | Gained: " .. (tabs.strength.running and not tabs.strength.timerStarted
            and "Preparing" or formatNumber(tabs.strength.statGains.Durability))
end

tabs.strength.updateAverage = function()
    local elapsed = getElapsed(tabs.strength)
    if elapsed <= 0 then return end
    tabs.strength.StrengthAverage.Text = "Str Ø: " .. formatRate(tabs.strength.statGains.Strength / elapsed)
    tabs.strength.DurabilityAverage.Text = "Dura Ø: " .. formatRate(tabs.strength.statGains.Durability / elapsed)
end

tabs.strength:AddButton("Reset Calcs", function()
    resetCalculations(tabs.strength)
end)

tabs.strength.startMeasurement = function()
    if not tabs.strength.running or tabs.strength.timerStarted
        or tabs.strength.sendRate < tabs.strength.maxSendRate then return end
    tabs.strength.statSamples.Strength = tabs.strength.strength.Value
    tabs.strength.statSamples.Durability = tabs.strength.durability.Value
    setTimerRunning(tabs.strength, true)
    tabs.strength.nextAverageElapsed = getElapsed(tabs.strength) + 10
    tabs.strength.updateStats()
end

tabs.strength.updateAdaptiveRate = function()
    tabs.strength.controlNow = tick()
    tabs.strength.controlElapsed = tabs.strength.controlNow - tabs.strength.lastControlAt
    if tabs.strength.controlElapsed < tabs.strength.controlInterval then
        return
    end

    tabs.strength.serverProgress = tabs.strength.strength.Value > tabs.strength.lastControlStrength
        or tabs.strength.durability.Value > tabs.strength.lastControlDurability

    if tabs.strength.serverProgress then
        tabs.strength.stalledIntervals = 0
        tabs.strength.sendRate = math.min(tabs.strength.maxSendRate, tabs.strength.sendRate * 1.12)
        tabs.strength.Status.Text = (tabs.strength.sendRate >= tabs.strength.maxSendRate
            and "Status: Farming | " or "Status: Preparing | ") .. formatNumber(tabs.strength.sendRate) .. " reps/s"
        tabs.strength.Status.TextColor3 = Color3.fromRGB(80, 255, 120)
    else
        tabs.strength.stalledIntervals = tabs.strength.stalledIntervals + 1
    end

    if tabs.strength.stalledIntervals >= 2 then
        tabs.strength.sendRate = math.max(math.min(tabs.strength.initialSendRate, tabs.strength.maxSendRate), tabs.strength.sendRate * 0.65)
        tabs.strength.Tokens = 0
        tabs.strength.Status.Text = "Status: Slowing for server | "
            .. formatNumber(tabs.strength.sendRate) .. " reps/s"
        tabs.strength.Status.TextColor3 = Color3.fromRGB(255, 180, 70)
    end

    tabs.strength.lastControlAt = tabs.strength.controlNow
    tabs.strength.lastControlStrength = tabs.strength.strength.Value
    tabs.strength.lastControlDurability = tabs.strength.durability.Value
end

tabs.strength.workerLoop = function()
    tabs.strength.LastAt = os.clock()
    local function isRunning()
        return tabs.strength.running
    end
    while tabs.strength.running do
        tabs.strength.updateAdaptiveRate()
        tabs.strength.startMeasurement()
        sendTrainingReps(tabs.strength, tabs.strength.sendRate, tabs.strength.maxBurst, isRunning)

        services.runservice.Heartbeat:Wait()
    end

    tabs.strength.workerActive = false
    if tabs.strength.running then
        tabs.strength.startWorker()
    end
end

tabs.strength.startWorker = function()
    if tabs.strength.workerActive then
        return
    end

    tabs.strength.workerActive = true
    runtime:Spawn(tabs.strength.workerLoop)
end

runtime:Connect(tabs.strength.strength:GetPropertyChangedSignal("Value"), function()
    recordStatGain(tabs.strength, "Strength", tabs.strength.strength.Value)
    tabs.strength.updateStats()
end)

runtime:Connect(tabs.strength.durability:GetPropertyChangedSignal("Value"), function()
    recordStatGain(tabs.strength, "Durability", tabs.strength.durability.Value)
    tabs.strength.updateStats()
end)

tabs.strength:AddTextBox("Max reps/s (default 200)", function(inputText)
    local value = tonumber(inputText)
    if not value or value ~= value or value == math.huge or value == -math.huge then return end
    value = math.max(1, value)
    if value ~= tabs.strength.maxSendRate and tabs.strength.running then
        recordStatGain(tabs.strength, "Strength", tabs.strength.strength.Value)
        recordStatGain(tabs.strength, "Durability", tabs.strength.durability.Value)
        setTimerRunning(tabs.strength, false)
        tabs.strength.updateStats()
    end
    tabs.strength.maxSendRate = value
    tabs.strength.sendRate = math.min(tabs.strength.sendRate, tabs.strength.maxSendRate)
end, {clear = false})

tabs.strength:AddLabel("Default Speed: 200 reps/s | Enter a custom maximum above.")

tabs.strength.FastRepToggle = tabs.strength:AddSwitch("Fast Rep", function(state)
    recordStatGain(tabs.strength, "Strength", tabs.strength.strength.Value)
    recordStatGain(tabs.strength, "Durability", tabs.strength.durability.Value)
    setTimerRunning(tabs.strength, false)
    tabs.strength.statSamples.Strength = tabs.strength.strength.Value
    tabs.strength.statSamples.Durability = tabs.strength.durability.Value
    tabs.strength.running = state
    tabs.strength.Tokens = 0
    if state then
        if tabs.rebirths.running then tabs.rebirths.Switch:Set(false) end
        tabs.strength.gainedBaselineSet = true
        tabs.strength.sendRate = math.min(tabs.strength.initialSendRate, tabs.strength.maxSendRate)
        tabs.strength.LastAt = os.clock()
        tabs.strength.lastControlAt = tick()
        tabs.strength.lastControlStrength = tabs.strength.strength.Value
        tabs.strength.lastControlDurability = tabs.strength.durability.Value
        tabs.strength.stalledIntervals = 0
        tabs.strength.Status.Text = "Status: Preparing | " .. formatNumber(tabs.strength.sendRate) .. " reps/s"
        tabs.strength.Status.TextColor3 = Color3.fromRGB(80, 255, 120)
        tabs.strength.startWorker()
    else
        tabs.strength.Status.Text = tabs.strength.gainedBaselineSet and "Status: Paused" or "Status: Inactive"
        tabs.strength.Status.TextColor3 = tabs.strength.gainedBaselineSet and Color3.fromRGB(255, 180, 70) or Color3.fromRGB(255, 80, 80)
        tabs.strength.updateRuntime()
    end
    tabs.strength.updateStats()
end)

tabs.strength.FastRepToggle:Set(false)

runtime:Spawn(function()
    while true do
        tabs.rebirths.updateRuntime()
        tabs.strength.updateRuntime()
        if tabs.strength.timerStarted and getElapsed(tabs.strength) >= tabs.strength.nextAverageElapsed then
            tabs.strength.updateAverage()
            tabs.strength.nextAverageElapsed = getElapsed(tabs.strength) + 10
        end
        task.wait(0.1)
    end
end)
