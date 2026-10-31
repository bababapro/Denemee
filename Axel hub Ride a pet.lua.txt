local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local httpService = game:GetService("HttpService")
local virtualUser = game:GetService("VirtualUser")
local starterGui = game:GetService("StarterGui")
local workspaceService = game:GetService("Workspace")
local teleportService = game:GetService("TeleportService")
local localPlayer = players.LocalPlayer
local waitForChild = replicatedStorage:WaitForChild("Remotes", 10)
local waitForChild2 = waitForChild and waitForChild:WaitForChild("Game", 10)
local waitForChild3 = waitForChild2 and waitForChild2:WaitForChild("EggPickup", 5)
local waitForChild4 = waitForChild2 and waitForChild2:WaitForChild("EggPlaced", 5)
local waitForChild5 = waitForChild2 and waitForChild2:WaitForChild("Hatch", 5)
local waitForChild6 = waitForChild2 and waitForChild2:WaitForChild("Mounting", 5)
local waitForChild7 = waitForChild2 and waitForChild2:WaitForChild("PlacePet", 5)

if not waitForChild7 and waitForChild then
  pcall(function() waitForChild7 = waitForChild:FindFirstChild("PlacePet", true) end)
end

local waitForChild8 = waitForChild2 and waitForChild2:WaitForChild("BuyWithCash", 5)

if waitForChild2 then
  waitForChild2:WaitForChild("Restock", 5)
end

local function f1()
  if waitForChild8 and waitForChild8.Parent then
    return waitForChild8
  end

  pcall(function() waitForChild8 = replicatedStorage.Remotes.Game.BuyWithCash end)

  if not waitForChild8 and waitForChild then
    waitForChild8 = waitForChild:FindFirstChild("BuyWithCash", true)
      or waitForChild:FindFirstChild("BuyCash", true)
      or waitForChild:FindFirstChild("Buy", true)
  end

  return waitForChild8
end

local upgrades

local function f2()
  if upgrades and upgrades.Parent then
    return upgrades
  end

  pcall(function() upgrades = replicatedStorage.Remotes.Game.Plot.Upgrades end)

  if not upgrades and waitForChild then
    upgrades = waitForChild:FindFirstChild("Upgrades", true)
  end

  return upgrades
end

local waitForChild9 = waitForChild2 and waitForChild2:WaitForChild("FeedPet", 5)

if not waitForChild9 and waitForChild then
  pcall(function() waitForChild9 = waitForChild:FindFirstChild("FeedPet", true) end)
end

local function f3()
  if waitForChild9 and waitForChild9.Parent then
    return waitForChild9
  end

  pcall(function() waitForChild9 = replicatedStorage.Remotes.Game.FeedPet end)

  if not waitForChild9 and waitForChild then
    waitForChild9 = waitForChild:FindFirstChild("FeedPet", true)
  end

  return waitForChild9
end

local v1 = {}
local v2 = {}

local v3 = {
  Common = 1,
  Uncommon = 2,
  Rare = 3,
  Epic = 4,
  Legendary = 5,
  Mythic = 6,
  Ethereal = 7,
  Divine = 8,
  Celestial = 9,
  Secret = 10,
}

local v4 = {
  "Secret", "Celestial", "Divine", "Ethereal", "Mythic", "Legendary", "Epic", "Rare",
  "Uncommon", "Common",
}

local function f4(p1)
  if not p1 then
    return nil
  else
    local lower = tostring(p1):lower()

    for index, value in ipairs(v4) do
      if lower:find(value:lower(), 1, true) then
        return value
      end
    end

    return nil
  end
end

local function f5()
  local v5 = {}

  for key, value2 in pairs(v1) do
    table.insert(v5, key)
  end

  table.sort(v5)
  return v5
end

local function f6()
  local v6 = {}
  local v7 = {}

  for key2, value3 in pairs(v1) do
    local rarity = value3.Rarity

    if rarity and not v7[rarity] then
      v7[rarity] = true
      table.insert(v6, rarity)
    end
  end

  table.sort(v6, function(p2, p3) return (v3[p2] or 0) < (v3[p3] or 0) end)
  return v6
end

local values = f6()
local v8 = f5()

local v9 = {
  "All", "Advanced Radar", "Angelic Radar", "Eternal Radar", "Golden Egg Radar", "Jewel Radar",
  "Lightning Rod", "Magic Radar", "Pet Magnet", "Royal Radar", "Shiny Charm", "Super Magnet",
}

local v10 = { "All", "Bone", "Dragonfruit", "Grass", "Magic Apple", "Meat" }

local v11 = {
  AutoFarm = false,
  MovementMode = "Instant",
  FarmMethod = "Selected Rarities",
  SelectedRarities = { "Ethereal", "Divine", "Mythic" },
  SelectedEgg = v8[1] or "Basic Egg",
  TweenSpeed = 250,
  ReturnSpeed = 300,
  CooldownBetweenEggs = 1,
  AutoPlaceEgg = true,
  AutoHatch = true,
  AutoPlacePet = false,
  AutoPlaceBestPet = false,
  SelectedPets = {},
  AutoUpgradeLuck = false,
  UpgradeLuckMethod = "Max",
  AutoFeed = false,
  SelectedFeedFoods = { "Meat" },
  AutoBuyFoodAndGear = false,
  AutoBuyGears = false,
  AutoBuyFoods = false,
  AutoBuyDelay = 2,
  SelectedGears = {},
  SelectedFoods = {},
  AntiAFK = true,
  AutoSave = true,
}

local v12 = {}

for key3, value4 in pairs(v11) do
  if type(value4) == "table" then
    local v13 = {}

    for index2, value5 in ipairs(value4) do
      table.insert(v13, value5)
    end

    v12[key3] = v13
  else
    v12[key3] = value4
  end
end

local function f7()
  local v14 = getgenv and getgenv() or _G or {}

  local v15 = writefile or v14.writefile or syn and syn.write_file
    or fluxus and fluxus.write_file

  return v15, readfile or v14.readfile or syn and syn.read_file or fluxus and fluxus.read_file, isfile or v14.isfile or syn and syn.is_file or fluxus and fluxus.is_file, isfolder or v14.isfolder or syn and syn.is_folder or fluxus and fluxus.is_folder, makefolder or v14.makefolder or syn and syn.make_folder
    or fluxus and fluxus.make_folder
end

local function f8()
  if localPlayer and localPlayer.Name and localPlayer.Name ~= "" then
    return localPlayer.Name
  end

  return "DefaultUser"
end

local v16 = false

local function f9()
  local v17 = {}

  for key4, value6 in pairs(v11) do
    local v18 = v12[key4]

    if v18 ~= nil then
      local v19 = type(v18)

      if v19 == "boolean" or v19 == "string" or v19 == "number" then
        v17[key4] = v18
      elseif v19 == "table" then
        local v20 = {}

        for key5, value7 in pairs(v18) do
          if type(value7) == "string" or type(value7) == "number" or type(value7) == "boolean" then
            table.insert(v20, value7)
          end
        end

        v17[key4] = v20
      end
    else
      v17[key4] = value6
    end
  end

  return v17
end

local function f10()
  return localPlayer.Character
end

local v21 = {}

local function f11()
  return localPlayer:GetAttribute("InVolcano") == true
end

local function f12(p4)
  if not p4 or p4 == "" then
    return true
  else
    local v22, v23, v24, v25, v26 = f7()

    if not v26 then
      return false
    else
      local v27 = string.split(p4, "/")
      local v28 = ""

      for index3, value8 in ipairs(v27) do
        if value8 and #value8 > 0 then
          v28 = v28 == "" and value8 or v28 .. "/" .. value8
          local v29 = false

          if v25 then
            local v30, v31 = pcall(v25, v28)

            if v30 and v31 == true then
              v29 = true
            end
          end

          if not v29 then
            pcall(v26, v28)
          end
        end
      end

      return true
    end
  end
end

local function f13()
  local v32 = f8()

  return {
    {
      folder = "AxelHub/RideAPet/Settings",
      file = "AxelHub/RideAPet/Settings/Axel_User-" .. v32 .. ".json",
    },
    {
      folder = "AxelHub/Ride A Pet/Settings",
      file = "AxelHub/Ride A Pet/Settings/Axel_User-" .. v32 .. ".json",
    },
    { folder = "AxelHub", file = "AxelHub/RideAPet_" .. v32 .. ".json" },
    { folder = nil, file = "Axel_RideAPet_" .. v32 .. ".json" },
    { folder = nil, file = "AxelHub_RideAPet_Settings.json" },
  }
end

local function f14()
  local basket = localPlayer:FindFirstChild("Basket")
  return basket ~= nil and #basket:GetChildren() > 0
end

local function f15()
  local v33, v34, v35 = f7()

  if not v34 then
    return false, "Executor does not support readfile"
  end

  for index4, value9 in ipairs((f13())) do
    local v36 = false

    if v35 then
      local v37, v38 = pcall(v35, value9.file)

      if v37 and v38 == true then
        v36 = true
      end
    else
      v36 = true
    end

    if v36 then
      local v39, v40 = pcall(v34, value9.file)

      if v39 and type(v40) == "string" and #v40 > 2 then
        local v41, v42 = pcall(function() return httpService:JSONDecode(v40) end)

        if v41 and type(v42) == "table" then
          for key6, value10 in pairs(v11) do
            if v42[key6] ~= nil then
              if type(value10) == "table" and type(v42[key6]) == "table" then
                local v43 = {}

                for key7, value11 in pairs(v42[key6]) do
                  if type(value11) == "string" or type(value11) == "number"
                    or type(value11) == "boolean" then
                    table.insert(v43, value11)
                  end
                end

                v12[key6] = v43
              elseif type(v42[key6]) == type(value10) then
                v12[key6] = v42[key6]
              end
            end
          end

          return true, value9.file
        end
      end
    end
  end

  return false, "No saved configuration file found"
end

local function f16(p5)
  local v44, v45, v46 = f7()
  local v47, v48

  if not v44 then
    return false, "Executor does not support writefile"
  else
    v47 = f9()

    local v49
    v49, v48 = pcall(function() return httpService:JSONEncode(v47) end)

    if not v49 or not v48 or #v48 == 0 then
      return false, "Failed to encode configuration to JSON"
    else
      local v50 = nil

      for index5, value12 in ipairs((f13())) do
        local v51 = value12

        if v51.folder then
          f12(v51.folder)
        end

        local v52, v53 = pcall(function() v44(v51.file, v48) end)

        if v52 then
          local v54 = true

          if v46 then
            local v55, v56 = pcall(v46, v51.file)

            if v55 and not v56 then
              v54 = false
            end
          end

          if v54 then
            return true, v51.file
          end
        else
          v50 = v53
        end
      end

      return false, tostring(v50 or "Unable to write configuration file")
    end
  end
end

local function f17(p6, p7)
  if not p6 then
    return nil
  else
    local getAttribute = p6:GetAttribute(p7)

    if getAttribute ~= nil then
      return getAttribute
    else
      local findFirstChild = p6:FindFirstChild(p7)

      if findFirstChild then
        if findFirstChild:IsA("ValueBase") then
          return findFirstChild.Value
        end

        return findFirstChild.Name
      end

      return nil
    end
  end
end

local v57

local function f18()
  if v16 then
    return
  elseif not v12.AutoSave then
    return
  else
    if v57 then
      return
    end

    v57 = task.delay(0.4, function()
      v57 = nil

      if not v16 and v12.AutoSave then
        f16(true)
      end
    end)

    return
  end
end

local function f19()
  local character = localPlayer.Character
  local humanoid = character and character:FindFirstChildOfClass("Humanoid")
  local v58 = not character
  local backpack = localPlayer:FindFirstChild("Backpack")

  if v58 or not humanoid then
    return nil
  end

  for index6, value13 in ipairs(character:GetChildren()) do
    if value13:IsA("Tool")
      and (value13:HasTag("Egg") or value13.Name:lower():find("egg")
        or value13:GetAttribute("Egg")) then
      return value13
    end
  end

  if backpack then
    for index7, value14 in ipairs(backpack:GetChildren()) do
      local v59 = value14

      if v59:IsA("Tool")
        and (v59:HasTag("Egg") or v59.Name:lower():find("egg") or v59:GetAttribute("Egg")) then
        pcall(function() humanoid:EquipTool(v59) end)
        task.wait(0.12)
        return v59
      end
    end

    return nil
  end

  return nil
end

f15()

local function f20()
  local backpack2 = localPlayer:FindFirstChild("Backpack")
  local v60

  if not backpack2 then
    return
  else
    local v61 = nil
    local huge = math.huge

    for index8, value15 in ipairs(backpack2:GetChildren()) do
      if value15:IsA("Tool") and value15:GetAttribute("PetName") ~= nil then
        local weight = value15:GetAttribute("Weight")

        if type(weight) == "number" and weight < huge then
          v61 = value15
          huge = weight
        end
      end
    end

    if not v61 then
      return
    else
      v61.Parent = localPlayer.Character
      local v62 = os.clock()

      repeat
        task.wait()
        local character2 = localPlayer.Character

        local findFirstChild2 = character2
        findFirstChild2 = character2 and localPlayer.Character:FindFirstChild(v61.Name)

        v60 = findFirstChild2
        v60 = findFirstChild2 or os.clock() - v62 > 1.5
      until v60

      task.wait(0.1)

      if waitForChild6 then
        waitForChild6:FireServer()
      end

      return
    end
  end
end

local function f21()
  local v63 = f10()
  return v63 and (v63.PrimaryPart or v63:FindFirstChild("HumanoidRootPart"))
end

local function f22()
  local v64 = f10()
  return v64 and v64:FindFirstChildOfClass("Humanoid")
end

local v65

local function f23(p8, p9)
  local v66 = f10()
  local v67 = f21()
  local v68 = f22()
  local v69 = not v67 or not v68
  local v70

  if v69 then
    return false
  else
    local cframe = typeof(p8) == "CFrame" and p8 or CFrame.new(p8)

    if v65 then
      v65:Cancel()
    end

    v70 = {}
    local autoRotate = v68.AutoRotate

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
    bodyGyro.P = 90000
    bodyGyro.D = 1000
    bodyGyro.CFrame = cframe
    bodyGyro.Parent = v67

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(0, 9000000000, 0)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = v67

    v68.AutoRotate = false

    local connect = runService.Stepped:Connect(function()
      if not v66.Parent then
        return
      end

      for index9, value16 in ipairs(v66:GetDescendants()) do
        if value16:IsA("BasePart") then
          if v70[value16] == nil then
            v70[value16] = value16.CanCollide
          end

          value16.CanCollide = false
        end
      end
    end)

    local v71 = math.clamp((v67.Position - cframe.Position).Magnitude / (p9 or 250), 0.05, 8)

    local create = tweenService:Create(v67, TweenInfo.new(v71, Enum.EasingStyle.Linear), {
      CFrame = cframe,
    })

    v65 = create
    create:Play()
    local v72 = create.Completed:Wait()
    connect:Disconnect()

    for key8, value17 in pairs(v70) do
      if key8.Parent then
        key8.CanCollide = value17
      end
    end

    if bodyGyro.Parent then
      bodyGyro:Destroy()
    end

    if bodyVelocity.Parent then
      bodyVelocity:Destroy()
    end

    if v68.Parent then
      v68.AutoRotate = autoRotate
    end

    if v65 == create then
      v65 = nil
    end

    return v72 == Enum.PlaybackState.Completed
  end
end

local function f24(p10)
  local v73 = f21()

  if v73 then
    v73.AssemblyLinearVelocity = Vector3.zero
    v73.AssemblyAngularVelocity = Vector3.zero
    v73.CFrame = typeof(p10) == "CFrame" and p10 or CFrame.new(p10)
  end
end

local function f25(p11, p12)
  local character3 = localPlayer.Character
  local v74, humanoid2

  if not character3 then
    return nil
  else
    humanoid2 = character3:FindFirstChildOfClass("Humanoid")
    local backpack3 = localPlayer:FindFirstChild("Backpack")

    local function f26(p13)
      if not p13 or not p13:IsA("Tool") then
        return false
      else
        local lower2 = p13.Name:lower()

        if lower2:find("egg") or lower2:find("radar") or lower2:find("basket") then
          return false
        end

        if p12 and tostring(p12) ~= "" then
          local uuid = p13:GetAttribute("UUID") or p13:GetAttribute("PetUUID")
            or p13:GetAttribute("PetId") or p13:GetAttribute("Id")

          if uuid and tostring(uuid) == tostring(p12) then
            return true
          elseif p13.Name == tostring(p12) then
            return true
          end
        end

        if p11 and tostring(p11) ~= "" then
          if p13.Name == tostring(p11) then
            return true
          else
            local pet = p13:GetAttribute("Pet") or p13:GetAttribute("PetName")

            if pet and tostring(pet) == tostring(p11) then
              return true
            end

            return false
          end
        else
          return false
        end
      end
    end

    for index10, value18 in ipairs(character3:GetChildren()) do
      if f26(value18) then
        return value18
      end
    end

    if backpack3 then
      for index11, value19 in ipairs(backpack3:GetChildren()) do
        local v75 = value19

        if f26(v75) then
          if humanoid2 then
            pcall(function() humanoid2:EquipTool(v75) end)
            local v76 = os.clock()

            repeat
              task.wait(0.04)
              local v77 = v75.Parent == character3

              v74 = v77
              v74 = v77 or os.clock() - v76 > 0.4
            until v74
          end

          return v75
        end
      end

      return nil
    end

    return nil
  end
end

local function f27(p14, p15)
  if v12.MovementMode == "Instant" then
    f24(p14)
    return true
  end

  return f23(p14, p15 or v12.TweenSpeed)
end

local f28

local function f29()
  local v78 = f28()

  if not v78 then
    return
  else
    local getPivot = v78:GetPivot()

    if v12.MovementMode == "Tween" then
      f23(getPivot + Vector3.new(0, 3, 0), v12.ReturnSpeed)
    else
      f24(getPivot + Vector3.new(0, 3, 0))
    end

    return
  end
end

local function f30()
  local v79 = f3()
  local v80

  if not v79 then
    return 0
  else
    local v81 = f28()

    if not v81 then
      return 0
    else
      local pets = v81:FindFirstChild("Pets")

      if not pets then
        return 0
      else
        local v82 = {}

        if type(v12.SelectedFeedFoods) == "table" and #v12.SelectedFeedFoods > 0 then
          if table.find(v12.SelectedFeedFoods, "All") then
            for index12, value20 in ipairs(v10) do
              if value20 ~= "All" then
                table.insert(v82, value20)
              end
            end
          else
            for index13, value21 in ipairs(v12.SelectedFeedFoods) do
              if value21 ~= "All" then
                table.insert(v82, value21)
              end
            end
          end
        elseif type(v12.SelectedFeedFoods) == "string" and v12.SelectedFeedFoods ~= "" then
          if v12.SelectedFeedFoods == "All" then
            for index14, value22 in ipairs(v10) do
              if value22 ~= "All" then
                table.insert(v82, value22)
              end
            end
          else
            table.insert(v82, v12.SelectedFeedFoods)
          end
        end

        if #v82 == 0 then
          table.insert(v82, "Meat")
        end

        local count = 0

        for index15, value23 in ipairs(pets:GetChildren()) do
          local ownerUserId = value23:GetAttribute("OwnerUserId")
            or value23:GetAttribute("OwnerId") or value23:GetAttribute("Owner")
            or value23:GetAttribute("UserId")

          if ownerUserId ~= nil then
            v80 = tonumber(ownerUserId) == localPlayer.UserId
          else
            v80 = true
          end

          if v80 then
            local petKey = value23:GetAttribute("PetKey") or value23:GetAttribute("UUID")
              or value23:GetAttribute("PetUUID") or value23:GetAttribute("PetId")
              or value23:GetAttribute("Id")

            if not petKey
              and value23.Name:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
              petKey = value23.Name
            end

            if petKey then
              for index16, value24 in ipairs(v82) do
                local v83 = value24
                pcall(function() v79:FireServer(tostring(petKey), v83) end)
                count = count + 1
                task.wait(0.1)
              end
            end
          end
        end

        return count
      end
    end
  end
end

function f28()
  local plots = workspaceService:FindFirstChild("Plots")

  if not plots then
    return nil
  end

  for index17, value25 in ipairs(plots:GetChildren()) do
    if value25:GetAttribute("NestsOwnerLoaded") == localPlayer.UserId then
      return value25
    end
  end

  return nil
end

local function f31()
  return localPlayer:GetAttribute("IsRiding") == true
end

local function f32(p16)
  local v84 = p16

  if not v84 then
    v84 = f28()
  end

  if not v84 then
    return nil
  else
    local baseplate = v84:FindFirstChild("Baseplate") or v84:FindFirstChild("BasePlate")
      or v84:FindFirstChild("Base")

    if baseplate then
      return baseplate
    end

    for index18, value26 in ipairs(v84:GetChildren()) do
      if value26.Name:lower():find("base") then
        return value26
      end
    end

    for index19, value27 in ipairs(v84:GetDescendants()) do
      if value27:IsA("BasePart") and value27.Name:lower():find("base") then
        return value27
      end
    end

    return v84:FindFirstChildWhichIsA("BasePart", true)
  end
end

local f33

local function f34(p17)
  local v85 = f28()

  if not v85 then
    return false
  else
    local character4 = localPlayer.Character
    local humanoidRootPart = character4 and character4:FindFirstChild("HumanoidRootPart")

    if not humanoidRootPart then
      return false
    else
      local v86 = f33(v85)

      if v86 then
        return (humanoidRootPart.Position - v86).Magnitude <= (p17 or 55)
      end

      return false
    end
  end
end

function f33(p18)
  local v87 = f32(p18)

  if not v87 then
    local v88 = p18 or f28()
    return v88 and v88:GetPivot().Position
  elseif v87:IsA("BasePart") then
    return v87.Position
  elseif v87:IsA("Model") then
    local primaryPart = v87.PrimaryPart or v87:FindFirstChildWhichIsA("BasePart")

    if primaryPart then
      return primaryPart.Position
    end

    return v87:GetPivot().Position
  else
    return nil
  end
end

local function f35(p19)
  if not p19 then
    return 0
  else
    local rarity2 = p19.Rarity or p19.rarity
    local name = p19.Name or p19.name

    if (not rarity2 or rarity2 == "Common") and v2 and name and v2[name] then
      local v89 = v2[name]
      rarity2 = type(v89) == "table" and (v89.Rarity or v89.rarity) or rarity2
    end

    if (not rarity2 or rarity2 == "Common") and name then
      rarity2 = f4(name)
    end

    local v90 = rarity2 and v3[rarity2]
    local v91 = tonumber
    local v92 = v90 or 1

    local v93 = v91(p19.Weight or p19.weight or p19.Multiplier or p19.multiplier or p19.Power
        or p19.power or p19.Speed or p19.speed)
      or 0

    if v2 and name and v2[name] then
      local v94 = v2[name]

      if type(v94) == "table" then
        local v95 = tonumber
        local multiplier = v94.Multiplier
        local v96 = multiplier

        if not multiplier then
          local multiplier2 = v94.multiplier
          local v97 = multiplier2

          if not multiplier2 then
            local weight2 = v94.Weight
            local v98 = weight2

            if not weight2 then
              local weight3 = v94.weight

              local power = weight3 or v94.Power or v94.power or v94.Speed or v94.speed
                or v94.RideSpeed or v94.CoinsMultiplier or v94.Boost or v94.Tier

              v98 = power
            end

            v97 = v98
          end

          v96 = v97
        end

        local v99 = v95(v96)

        if v99 and v99 > v93 then
          v93 = v99
        end

        if (not rarity2 or rarity2 == "Common") and (v94.Rarity or v94.rarity) then
          v92 = v3[v94.Rarity or v94.rarity] or v92
        end
      end
    end

    return v92 * 10000000 + v93
  end
end

local function f36()
  local v100 = f28()

  if not v100 or not waitForChild5 then
    return
  else
    local eggs = v100:FindFirstChild("Eggs")

    if not eggs then
      return
    end

    for index20, value28 in ipairs(eggs:GetChildren()) do
      local eggKey = value28:GetAttribute("EggKey") or value28:GetAttribute("Key")
        or value28.Name

      if eggKey then
        pcall(function() waitForChild5:FireServer({ EggKey = tostring(eggKey) }) end)
        task.wait(0.12)
      end
    end

    return
  end
end

local v101 = 0
local f37

local function f38()
  local v102, v103

  if not f14() then
    return false
  else
    local v104 = f28()

    if not v104 or not waitForChild4 then
      return false
    else
      f19()
      task.wait(0.1)
      local nests = v104:FindFirstChild("Nests")

      if nests then
        for index21, value29 in ipairs(nests:GetChildren()) do
          if value29:GetAttribute("Unlocked") == true and not value29:GetAttribute("Occupied") then
            waitForChild4:FireServer({ NestId = value29.Name })
            local v105 = os.clock()

            repeat
              task.wait(0.06)
              local v106 = not f14()

              v103 = v106
              v103 = v106 or os.clock() - v105 > 0.8
            until v103

            if not f14() then
              return true
            end
          end
        end
      end

      local v107 = f33(v104)

      if v107 then
        waitForChild4:FireServer({ PlantPosition = v107 + f37() })
        local v108 = os.clock()

        repeat
          task.wait(0.06)
          local v109 = not f14()

          v102 = v109
          v102 = v109 or os.clock() - v108 > 0.8
        until v102

        if not f14() then
          return true
        end
      end

      if nests then
        for index22, value30 in ipairs(nests:GetChildren()) do
          waitForChild4:FireServer({ NestId = value30.Name })
          task.wait(0.06)

          if not f14() then
            return true
          end
        end

        return not f14()
      end

      return not f14()
    end
  end
end

function f37()
  local v110 = v101
  local v111 = math.floor(v101 / 4)
  v101 = (v101 + 1) % 16
  return Vector3.new((v110 % 4 - 1.5) * 5, 1.5, (v111 % 4 - 1.5) * 5)
end

local v112 = nil

local function f39()
  v12.AutoFarm = false

  if v65 then
    v65:Cancel()
    v65 = nil
  end

  if v112 then
    pcall(function() task.cancel(v112) end)
    v112 = nil
  end
end

local f40

local function f41()
  local activeEggs = replicatedStorage:FindFirstChild("ServerData")
    and replicatedStorage.ServerData:FindFirstChild("ActiveEggs")

  if not activeEggs then
    return {}
  else
    local v113 = {}
    local v114 = f21()
    local position = v114 and v114.Position or Vector3.zero

    for index23, value31 in ipairs(activeEggs:GetChildren()) do
      if value31:IsA("Configuration") then
        local egg = value31:GetAttribute("Egg")
        local position2 = value31:GetAttribute("Position")

        if egg and position2 then
          local v115 = typeof(position2) == "Vector3" and position2

          local vector = v115
          vector = v115 or Vector3.new(position2.X or 0, position2.Y or 0, position2.Z or 0)

          local v116 = f40(egg)

          table.insert(v113, {
            Instance = value31,
            UID = value31.Name,
            Name = egg,
            Rarity = v116,
            Position = vector,
            Distance = (position - vector).Magnitude,
            Weight = value31:GetAttribute("Weight") or 0,
            Priority = v3[v116] or 0,
          })
        end
      end
    end

    return v113
  end
end

function f40(p20)
  local v117 = v1[p20]
  return v117 and v117.Rarity or "Unknown"
end

local f42, f43, f44, f45

local function f46()
  local v118

  if f14() then
    f29()
    task.wait(0.25)

    if v12.AutoPlaceEgg then
      f38()
    end

    if v12.AutoHatch then
      f36()
    end

    task.wait(v12.CooldownBetweenEggs)
    return
  else
    local v119 = f45()

    if not v119 or not v119.Instance or not v119.Instance.Parent then
      task.wait(0.5)
      return
    end

    if v119.Name == "Volcanic Egg" and not f11() then
      if not f31() then
        f20()
        task.wait(1.5)
        return
      else
        local volcano = workspaceService:FindFirstChild("Volcano")
        local volcanoEntrance = volcano and volcano:FindFirstChild("VolcanoEntrance")
        local volcanoValidate = volcano and volcano:FindFirstChild("VolcanoValidate")

        if volcanoEntrance and volcanoValidate then
          f24(CFrame.new(-4924.9, 41287.5, -3700.9))
          task.wait(0.5)
          f23(volcanoValidate.CFrame, 100)
          task.wait(0.5)
        end

        return
      end
    else
      local position3 = v119.Position
      local v120 = f21()

      if not v120 then
        return
      else
        if (v120.Position - position3).Magnitude > 15 then
          f27(CFrame.new(position3 + Vector3.new(0, 1.5, 0)), v12.TweenSpeed)
        end

        v120.AssemblyLinearVelocity = Vector3.zero
        v120.AssemblyAngularVelocity = Vector3.zero

        task.wait(0.08)
        local v121 = os.clock()

        repeat
          if not v12.AutoFarm then
            break
          end

          if not v119.Instance or not v119.Instance.Parent then
            break
          else
            if waitForChild3 then
              waitForChild3:FireServer(v119.UID)
            end

            task.wait(0.12)
            local v122 = f14()

            v118 = v122
            v118 = v122 or os.clock() - v121 > 2.5
          end
        until v118

        if f14() and f11() then
          local volcano2 = workspaceService:FindFirstChild("Volcano")
          local volcanoValidate2 = volcano2 and volcano2:FindFirstChild("VolcanoValidate")

          if volcanoValidate2 then
            f24(volcanoValidate2.CFrame)
            task.wait(0.2)
            f23(CFrame.new(-4924.9, 41287.5, -3700.9), 100)
            task.wait(0.5)
          end
        end

        if f14() then
          f29()
          task.wait(0.25)

          if v12.AutoPlaceEgg then
            f38()
          end

          if v12.AutoHatch then
            f36()
          end

          if v12.AutoPlaceBestPet and f44 then
            pcall(function() f44(true, false) end)
          elseif v12.AutoPlacePet and f44 then
            pcall(function() f44(false, false) end)
          end

          if (v12.AutoBuyFoodAndGear or v12.AutoBuyGears) and f42 then
            task.spawn(function() pcall(f42) end)
          end

          if (v12.AutoBuyFoodAndGear or v12.AutoBuyFoods) and f43 then
            task.spawn(function() pcall(f43) end)
          end

          task.wait(v12.CooldownBetweenEggs)
        end

        return
      end
    end
  end
end

function f45()
  local v123 = f41()

  if #v123 == 0 then
    return nil
  else
    local farmMethod = v12.FarmMethod
    local v124 = {}

    if farmMethod == "Selected Rarities" then
      local v125 = {}

      for index24, value32 in ipairs(v12.SelectedRarities) do
        v125[value32] = true
      end

      for index25, value33 in ipairs(v123) do
        if v125[value33.Rarity] then
          table.insert(v124, value33)
        end
      end

      if #v124 == 0 then
        return nil
      end

      table.sort(v124, function(p21, p22)
        if p21.Priority ~= p22.Priority then
          return p21.Priority > p22.Priority
        end

        return p21.Distance < p22.Distance
      end)

      return v124[1]
    elseif farmMethod == "Selected Egg" then
      for index26, value34 in ipairs(v123) do
        if value34.Name == v12.SelectedEgg then
          table.insert(v124, value34)
        end
      end

      if #v124 == 0 then
        return nil
      end

      table.sort(v124, function(p23, p24)
        if p23.Priority ~= p24.Priority then
          return p23.Priority > p24.Priority
        end

        return p23.Distance < p24.Distance
      end)

      return v124[1]
    else
      if farmMethod == "Nearby" then
        table.sort(v123, function(p25, p26) return p25.Distance < p26.Distance end)
        return v123[1]
      end

      v124 = v123

      if #v124 == 0 then
        return nil
      end

      table.sort(v124, function(p27, p28)
        if p27.Priority ~= p28.Priority then
          return p27.Priority > p28.Priority
        end

        return p27.Distance < p28.Distance
      end)

      return v124[1]
    end
  end
end

local function f47()
  if v112 then
    return
  end

  v112 = task.spawn(function()
    while v12.AutoFarm do
      local v126, v127 = pcall(f46)

      if not v126 then
        warn("[Axel Hub Farm Error]:", v127)
        task.wait(1)
      end

      task.wait(0.05)
    end

    v112 = nil
  end)
end

local v128 = 0

local function f48(p29)
  if not p29 then
    return false
  else
    local name2 = p29.Name
    local lower3 = name2:lower()

    if lower3:find("egg") or lower3:find("radar") or lower3:find("basket")
      or lower3:find("magnet") or lower3:find("rod") or lower3:find("charm") then
      return false
    end

    if p29:GetAttribute("Pet") or p29:GetAttribute("PetName") or p29:GetAttribute("PetUUID")
      or p29:GetAttribute("UUID") or p29:GetAttribute("PetId") then
      return true
    end

    if p29:FindFirstChild("PetName") or p29:FindFirstChild("Pet")
      or p29:FindFirstChild("Weight") or p29:FindFirstChild("Multiplier") then
      return true
    end

    if v2 and (v2[name2] or p29:GetAttribute("Type") and v2[p29:GetAttribute("Type")]) then
      return true
    end

    if name2:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
      return true
    end

    return false
  end
end

local v129 = {}

local function f49()
  local v130 = {}
  local v131 = f28()

  if not v131 then
    return v130
  else
    local function f50(p30)
      if not p30 then
        return
      else
        local name3 = f17(p30, "UUID") or f17(p30, "PetUUID") or f17(p30, "PetId")
          or f17(p30, "Id") or f17(p30, "Key")

        if not name3
          and p30.Name:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
          name3 = p30.Name
        end

        if name3 then
          v130[tostring(name3)] = true
        end

        local v132 = f17(p30, "Pet") or f17(p30, "PetName")

        if v132 then
          v130[tostring(v132)] = true
        end

        if p30.Name and v2 and v2[p30.Name] then
          v130[p30.Name] = true
        end

        return
      end
    end

    for index27, value35 in ipairs({ "Pets", "PlacedPets", "Placed", "ActivePets", "PetModels" }) do
      local findFirstChild3 = v131:FindFirstChild(value35)

      if findFirstChild3 then
        for index28, value36 in ipairs(findFirstChild3:GetChildren()) do
          f50(value36)
        end
      end
    end

    for index29, value37 in ipairs(v131:GetChildren()) do
      if value37:IsA("Model") or value37:IsA("Folder") then
        f50(value37)

        for index30, value38 in ipairs(value37:GetChildren()) do
          if value38:IsA("Model") then
            f50(value38)
          end
        end
      end
    end

    return v130
  end
end

local v133, f51

local function f52(p31)
  local v134 = not p31
  local v135 = os.clock()

  if v134 and v133 and v135 - v128 < 2 then
    return v133
  end

  v128 = v135
  local v136 = {}
  local v137 = {}

  local f53

  function f53(p32)
    local v138 = f51(p32)

    if v138 and v138.Id and not v137[v138.Id] then
      v137[v138.Id] = true
      table.insert(v136, v138)
    end
  end

  local f54

  function f54(p33)
    if not p33 then
      return
    end

    for index31, value39 in ipairs(p33:GetChildren()) do
      f53(value39)
    end
  end

  pcall(function()
    for index32, value40 in ipairs({
      replicatedStorage:FindFirstChild("PlayerData"),
      replicatedStorage:FindFirstChild("ServerData"), localPlayer:FindFirstChild("Data"),
      localPlayer:FindFirstChild("SavedData"), localPlayer,
    }) do
      if value40 then
        local findFirstChild4 = value40:FindFirstChild(localPlayer.Name)

        local findFirstChild5 = findFirstChild4

        findFirstChild5 = findFirstChild4
          or value40:FindFirstChild(tostring(localPlayer.UserId)) or value40

        if findFirstChild5 then
          for index33, value41 in ipairs({
            "Pets", "Inventory", "PetInventory", "OwnedPets", "PlayerPets",
          }) do
            local findFirstChild6 = findFirstChild5:FindFirstChild(value41)

            if findFirstChild6 then
              f54(findFirstChild6)
            end
          end

          f54(findFirstChild5)
        end
      end
    end
  end)

  pcall(function()
    local backpack4 = localPlayer:FindFirstChild("Backpack")

    if backpack4 then
      f54(backpack4)
    end

    if localPlayer.Character then
      f54(localPlayer.Character)
    end
  end)

  if #v136 == 0 then
    pcall(function()
      local playerGui = localPlayer:FindFirstChild("PlayerGui")

      if playerGui then
        for index34, value42 in ipairs(playerGui:GetChildren()) do
          local lower4 = value42.Name:lower()

          if lower4:find("pet") or lower4:find("inv") then
            for index35, value43 in ipairs(value42:GetDescendants()) do
              local uuid2 = value43:GetAttribute("UUID") or value43:GetAttribute("PetUUID")
                or value43:GetAttribute("PetId")

              if not uuid2
                and value43.Name:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
                uuid2 = value43.Name
              end

              if uuid2 and not v137[tostring(uuid2)] then
                local pet2 = value43:GetAttribute("Pet")

                local petName = pet2
                petName = pet2 or value43:GetAttribute("PetName")

                if not petName then
                  for index36, value44 in ipairs(value43:GetChildren()) do
                    if value44:IsA("TextLabel") and value44.Text ~= ""
                      and not value44.Text:find("^%d") then
                      petName = value44.Text
                      break
                    end
                  end
                end

                local weight4 = value43:GetAttribute("Weight") or 0
                local rarity3 = value43:GetAttribute("Rarity") or "Common"

                local v139 = {
                  Id = tostring(uuid2),
                  id = tostring(uuid2),
                  Name = tostring(petName or value43.Name),
                  name = tostring(petName or value43.Name),
                  Weight = tonumber(weight4) or 0,
                  weight = tonumber(weight4) or 0,
                  Rarity = tostring(rarity3),
                  rarity = tostring(rarity3),
                  Priority = v3[rarity3] or 1,
                }

                v139.rank = f35(v139)
                v139.Rank = v139.rank

                v137[tostring(uuid2)] = true
                table.insert(v136, v139)
              end
            end
          end
        end
      end
    end)
  end

  v133 = v136
  return v136
end

local function f55(p34, p35)
  if not p34 then
    return true
  else
    local v140 = tostring(p34)

    if p35 and p35[v140] then
      return true
    else
      local v141 = v129[v140]

      if v141 and os.clock() - v141 < 20 then
        return true
      end

      return false
    end
  end
end

function f51(p36)
  if not p36 or not f48(p36) then
    return nil
  else
    local name4 = f17(p36, "UUID") or f17(p36, "PetUUID") or f17(p36, "PetId")
      or f17(p36, "PetKey") or f17(p36, "Id") or f17(p36, "Key") or f17(p36, "UID")

    if not name4
      and p36.Name:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
      name4 = p36.Name
    end

    local name5 = f17(p36, "Pet") or f17(p36, "PetName") or f17(p36, "Type")
      or name4 and name4 ~= p36.Name and p36.Name or p36:GetAttribute("Name")

    if not name5 or name5 == "" or name5 == name4 then
      if v2 and v2[p36.Name] then
        name5 = p36.Name
      else
        name5 = p36.Name
      end
    end

    if not name4 or name4 == "" then
      name4 = p36.Name
    end

    local v142 = tonumber(f17(p36, "Weight")) or 0
    local v143 = tonumber(f17(p36, "Multiplier") or f17(p36, "Boost") or f17(p36, "Coins")) or 0
    local v144 = tonumber(f17(p36, "Power") or f17(p36, "Damage")) or 0
    local v145 = tonumber(f17(p36, "Speed") or f17(p36, "RideSpeed")) or 0
    local rarity4 = f17(p36, "Rarity")

    if (not rarity4 or rarity4 == "Common") and v2 and v2[name5] then
      local v146 = v2[name5]

      if type(v146) == "table" then
        rarity4 = v146.Rarity or v146.rarity
      end
    end

    if not rarity4 or rarity4 == "Common" then
      rarity4 = f4(name5) or "Common"
    end

    if v2 and v2[name5] and type(v2[name5]) == "table" then
      local v147 = v2[name5]

      if v142 == 0 and v147.Weight then
        v142 = tonumber(v147.Weight) or 0
      end

      if v143 == 0 and v147.Multiplier then
        v143 = tonumber(v147.Multiplier) or 0
      end

      if v144 == 0 and v147.Power then
        v144 = tonumber(v147.Power) or 0
      end

      if v145 == 0 and (v147.Speed or v147.RideSpeed) then
        v145 = tonumber(v147.Speed or v147.RideSpeed) or 0
      end
    end

    local v148 = {
      Instance = p36,
      Tool = p36:IsA("Tool") and p36 or nil,
      Id = tostring(name4),
      id = tostring(name4),
      Name = tostring(name5),
      name = tostring(name5),
      Weight = v142,
      weight = v142,
      Multiplier = v143,
      multiplier = v143,
      Power = v144,
      power = v144,
      Speed = v145,
      speed = v145,
      Rarity = tostring(rarity4),
      rarity = tostring(rarity4),
      Priority = v3[rarity4] or 1,
    }

    v148.rank = f35(v148)
    v148.Rank = v148.rank

    return v148
  end
end

local function f56()
  local v149 = { "All" }
  local v150 = { All = true }

  if v2 and type(v2) == "table" then
    for key9 in pairs(v2) do
      if not v150[key9] then
        v150[key9] = true
        table.insert(v149, tostring(key9))
      end
    end
  end

  for index37, value45 in ipairs(f52()) do
    local name6 = value45.Name or value45.name

    if name6 and not v150[name6] then
      v150[name6] = true
      table.insert(v149, name6)
    end
  end

  table.sort(v149, function(p37, p38)
    if p37 == "All" then
      return true
    end

    if p38 == "All" then
      return false
    end

    return p37 < p38
  end)

  return v149
end

function f44(p39, p40)
  local v151 = f28()

  if not v151 then
    if p40 then
      notify("Pets", "Could not locate your plot!", 2.5)
    end

    return 0
  end

  if not waitForChild7 then
    if waitForChild then
      waitForChild7 = waitForChild:FindFirstChild("PlacePet", true)
    end
  end

  if not waitForChild7 then
    if p40 then
      notify("Pets", "PlacePet remote not found!", 2.5)
    end

    return 0
  end

  if p40 and not f34(60) then
    f29()
    task.wait(0.5)
  end

  local v152

  if not f33(v151) then
    if p40 then
      notify("Pets", "Baseplate not found on plot!", 2.5)
    end

    return 0
  else
    local v153 = f52(true)

    if not v153 or #v153 == 0 then
      if p40 then
        notify("Pets", "No owned pets found in your inventory!", 2.5)
      end

      return 0
    else
      local v154 = #v153
      local v155 = {}
      local count2 = 0

      while true do
        count2 = 1 + count2

        if not (v154 >= count2) then
          break
        end

        local v156 = count2
        v155[v156] = v153[v156]
      end

      if p39 then
        table.sort(v155, function(p41, p42)
          return (p41.rank or p41.Rank or 0) > (p42.rank or p42.Rank or 0)
        end)
      end

      local v157 = f49()
      local count3 = 0

      for index38, value46 in ipairs(v155) do
        if not p40 then
          if p39 then
            if not v12.AutoPlaceBestPet and not v12.AutoFarm then
              break
            end
          elseif not v12.AutoPlacePet and not v12.AutoFarm then
            break
          end
        end

        local id = value46.Id or value46.id
        local name7 = value46.Name or value46.name

        if not p39 then
          if v12.SelectedPets and #v12.SelectedPets > 0
            and not table.find(v12.SelectedPets, "All") then
            local v158 = false

            for index39, value47 in ipairs(v12.SelectedPets) do
              if value47 ~= "All" and value47 ~= "--"
                and (value47 == name7 or value47:lower() == name7:lower()) then
                v158 = true
                break
              end
            end

            if not v158 then
            else
              ::L7372736::
              ::L9954991::

              if p40 then
                v152 = (v157 and (v157[tostring(id)] or v157[tostring(name7)])) == true
              else
                v152 = f55(id, v157) or v157 and v157[tostring(name7)] == true
              end

              if not v152 then
                f25(name7, id)
                task.wait(0.12)
                local v159 = math.floor(count3 / 3)
                Vector3.new((count3 % 3 - 1) * 5, 2, v159 * 5)
                v129[tostring(id)] = os.clock()
                v157[tostring(id)] = true
                count3 = count3 + 1
                task.wait(0.2)

                if count3 >= 6 then
                  break
                end
              end
            end
          else
            goto L7372736
          end
        else
          goto L9954991
        end
      end

      return count3
    end
  end
end

function f42()
  local v160 = f1()

  if not v160 then
    return 0
  else
    local v161 = {}

    if not v12.SelectedGears or #v12.SelectedGears == 0 or table.find(v12.SelectedGears, "All") then
      for index40, value48 in ipairs(v9) do
        if value48 ~= "All" then
          table.insert(v161, value48)
        end
      end
    else
      for index41, value49 in ipairs(v12.SelectedGears) do
        if value49 ~= "All" then
          table.insert(v161, value49)
        end
      end
    end

    local count4 = 0

    for index42, value50 in ipairs(v161) do
      local v162 = value50

      if not (v12.AutoBuyFoodAndGear or v12.AutoBuyGears) then
        break
      end

      pcall(function() v160:FireServer("Gears", v162) end)
      count4 = count4 + 1
      task.wait(0.12)
    end

    return count4
  end
end

function f43()
  local v163 = f1()

  if not v163 then
    return 0
  else
    local v164 = {}

    if not v12.SelectedFoods or #v12.SelectedFoods == 0 or table.find(v12.SelectedFoods, "All") then
      for index43, value51 in ipairs(v10) do
        if value51 ~= "All" then
          table.insert(v164, value51)
        end
      end
    else
      for index44, value52 in ipairs(v12.SelectedFoods) do
        if value52 ~= "All" then
          table.insert(v164, value52)
        end
      end
    end

    local count5 = 0

    for index45, value53 in ipairs(v164) do
      local v165 = value53

      if not (v12.AutoBuyFoodAndGear or v12.AutoBuyFoods) then
        break
      end

      pcall(function() v163:FireServer("Food", v165) end)
      count5 = count5 + 1
      task.wait(0.12)
    end

    return count5
  end
end

task.spawn(function()
  while true do
    task.wait(tonumber(v12.AutoBuyDelay) or 2)
    local v166 = v12.AutoBuyFoodAndGear == true or v12.AutoBuyGears == true
    local v167 = v12.AutoBuyFoodAndGear == true or v12.AutoBuyFoods == true

    if v166 and f42 then
      pcall(f42)
    end

    if v167 and f43 then
      pcall(f43)
    end
  end
end)

task.spawn(function()
  while true do
    task.wait(0.5)

    if v12.AutoPlaceEgg and f14() and f34(55) then
      pcall(f38)
    end
  end
end)

task.spawn(function()
  while true do
    task.wait(3)

    if f34(60) then
      if v12.AutoPlaceBestPet and not v12.AutoFarm and f44 then
        pcall(function() f44(true, false) end)
      elseif v12.AutoPlacePet and not v12.AutoFarm and f44 then
        pcall(function() f44(false, false) end)
      end
    end
  end
end)

localPlayer.Idled:Connect(function()
  if v12.AntiAFK then
    virtualUser:Button2Down(Vector2.new(0, 0), workspaceService.CurrentCamera.CFrame)
    task.wait(1)
    virtualUser:Button2Up(Vector2.new(0, 0), workspaceService.CurrentCamera.CFrame)
  end
end)

local windUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local window = windUI:CreateWindow({
  Title = "Axel Hub | Ride A Pet",
  Icon = "egg",
  Author = "by x2Alphix",
  Folder = "AxelHub",
  Size = UDim2.fromOffset(580, 460),
  MinSize = Vector2.new(500, 350),
  MaxSize = Vector2.new(850, 600),
  ToggleKey = Enum.KeyCode.LeftShift,
  Transparent = true,
  Theme = "Dark",
  Resizable = true,
  SideBarWidth = 200,
  BackgroundImageTransparency = 0.42,
  HideSearchBar = true,
  ScrollBarEnabled = false,
})

window:EditOpenButton({
  Title = "Open Axel UI",
  Icon = "rbxassetid://86949082023913",
  CornerRadius = UDim.new(0, 16),
  StrokeThickness = 2,
  Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
  OnlyMobile = false,
  Enabled = true,
  Draggable = true,
})

windUI:AddTheme({
  Name = "AxelSunset",
  Accent = Color3.fromHex("#ff8c00"),
  Background = Color3.fromHex("#14110b"),
  BackgroundTransparency = 0,
  Outline = Color3.fromHex("#ffb300"),
  Text = Color3.fromHex("#fff7e6"),
  Placeholder = Color3.fromHex("#ffb84d"),
  Button = Color3.fromHex("#2a1f0f"),
  Icon = Color3.fromHex("#ffcc00"),
  Hover = Color3.fromHex("#ffd580"),
  WindowBackground = Color3.fromHex("#14110b"),
  WindowShadow = Color3.fromHex("#000000"),
  WindowTopbarButtonIcon = Color3.fromHex("#ffcc00"),
  WindowTopbarTitle = Color3.fromHex("#fff7e6"),
  WindowTopbarAuthor = Color3.fromHex("#ffb84d"),
  WindowTopbarIcon = Color3.fromHex("#ffe066"),
  TabBackground = Color3.fromHex("#2a1f0f"),
  TabTitle = Color3.fromHex("#fff7e6"),
  TabIcon = Color3.fromHex("#ffcc00"),
  ElementBackground = Color3.fromHex("#241c10"),
  ElementTitle = Color3.fromHex("#fff7e6"),
  ElementDesc = Color3.fromHex("#ffcc80"),
  ElementIcon = Color3.fromHex("#ffb300"),
})

windUI:SetTheme("AxelSunset")

local function f57(title, p43, p44)
  pcall(function()
    if windUI and windUI.Notify then
      windUI:Notify({ Title = title, Content = p43, Duration = p44 or 3 })
    elseif starterGui then
      starterGui:SetCore("SendNotification", { Title = title, Text = p43, Duration = p44 or 3 })
    end
  end)
end

local mainTabTab = window:Tab({ Title = "Main Tab", Icon = "egg" })
local petsTabTab = window:Tab({ Title = "Pets Tab", Icon = "paw-print" })
local shopTabTab = window:Tab({ Title = "Shop Tab", Icon = "shopping-cart" })
local trackTabTab = window:Tab({ Title = "Track Tab", Icon = "radar" })
local settingsTab = window:Tab({ Title = "Settings", Icon = "settings" })
local section = mainTabTab.Section

local function f58(p45, p46)
  if not p45 or p46 == nil then
    return
  end

  pcall(function()
    if p45.SetValue then
      p45:SetValue(p46)
    elseif p45.Set then
      p45:Set(p46)
    elseif p45.Select then
      p45:Select(p46)
    end
  end)
end

local function f59()
  v16 = true

  f58(v21.AutoFarm, v12.AutoFarm)
  f58(v21.MovementMode, v12.MovementMode)
  f58(v21.FarmMethod, v12.FarmMethod)
  f58(v21.SelectedRarities, v12.SelectedRarities)
  f58(v21.SelectedEgg, v12.SelectedEgg)
  f58(v21.AutoPlaceEgg, v12.AutoPlaceEgg)
  f58(v21.AutoHatch, v12.AutoHatch)
  f58(v21.TweenSpeed, v12.TweenSpeed)
  f58(v21.ReturnSpeed, v12.ReturnSpeed)
  f58(v21.CooldownBetweenEggs, v12.CooldownBetweenEggs)
  f58(v21.AutoPlaceBestPet, v12.AutoPlaceBestPet)
  f58(v21.AutoPlacePet, v12.AutoPlacePet)
  f58(v21.SelectedPets, v12.SelectedPets)
  f58(v21.AutoFeed, v12.AutoFeed)
  f58(v21.SelectedFeedFoods, v12.SelectedFeedFoods)
  f58(v21.AutoUpgradeLuck, v12.AutoUpgradeLuck)
  f58(v21.UpgradeLuckMethod, v12.UpgradeLuckMethod)
  f58(v21.AutoBuyFoodAndGear, v12.AutoBuyFoodAndGear)
  f58(v21.AutoBuyFoodAndGearFarm, v12.AutoBuyFoodAndGear)
  f58(v21.AutoBuyGears, v12.AutoBuyGears)
  f58(v21.AutoBuyFoods, v12.AutoBuyFoods)
  f58(v21.AutoBuyDelay, v12.AutoBuyDelay)
  f58(v21.SelectedGears, v12.SelectedGears)
  f58(v21.SelectedFoods, v12.SelectedFoods)
  f58(v21.AntiAFK, v12.AntiAFK)
  f58(v21.AutoSave, v12.AutoSave)

  task.delay(0.15, function() v16 = false end)
end

local v168 = section(mainTabTab, { Title = "🥚 Instant Still Farming" })

v21.AutoFarm = v168:Toggle({
  Title = "Auto Farm Egg",
  Desc = "100% bug-free egg farming with zero egg returning",
  Value = v12.AutoFarm,
  Callback = function(value54)
    v12.AutoFarm = value54

    if value54 then
      f47()
      f57("Auto Farm", "Started Instant Still Farm [" .. v12.FarmMethod .. "]", 2.5)
    else
      f39()
    end

    f18()
  end,
})

v168:Button({
  Title = "Minimize UI",
  Desc = "Hides the window. Click the floating 'Open Axel UI' button or press LeftShift to open it back.",
  Callback = function()
    pcall(function()
      if window.Close then
        window:Close()
      elseif window.Toggle then
        window:Toggle()
      end
    end)
  end,
})

v21.MovementMode = v168:Dropdown({
  Title = "Movement Mode",
  Desc = "Instant (Teleport) is fastest; Smooth (Tween) bypasses movement flags",
  Values = { "Instant", "Tween" },
  Value = v12.MovementMode,
  Callback = function(value55)
    v12.MovementMode = value55
    f18()
  end,
})

v21.FarmMethod = v168:Dropdown({
  Title = "Farm Method",
  Desc = "Targeting criteria for egg collection",
  Values = { "Selected Rarities", "Selected Egg", "Nearby", "All" },
  Value = v12.FarmMethod,
  Callback = function(value56)
    v12.FarmMethod = value56
    f18()
  end,
})

v21.SelectedRarities = v168:Dropdown({
  Title = "Select Rarities",
  Desc = "Rarities to collect when method is 'Selected Rarities'",
  Values = values,
  Value = v12.SelectedRarities,
  Multi = true,
  Callback = function(value57)
    v12.SelectedRarities = value57 or {}
    f18()
  end,
})

v21.SelectedEgg = v168:Dropdown({
  Title = "Select Egg",
  Desc = "Specific egg to collect when method is 'Selected Egg'",
  Values = v8,
  Value = v12.SelectedEgg,
  Callback = function(value58)
    v12.SelectedEgg = value58
    f18()
  end,
})

local plotAutomationSection = mainTabTab:Section({ Title = "🏡 Plot Automation" })

v21.AutoPlaceEgg = plotAutomationSection:Toggle({
  Title = "Auto Place Carried Egg",
  Desc = "Instantly plants carried egg into empty nest upon returning",
  Value = v12.AutoPlaceEgg,
  Callback = function(value59)
    v12.AutoPlaceEgg = value59
    f18()
  end,
})

plotAutomationSection:Button({
  Title = "Place Egg Now",
  Desc = "Equips and plants your carried egg onto your plot/nest right now",
  Callback = function()
    if not f14() then
      return
    end

    if f38() then
    end
  end,
})

v21.AutoHatch = plotAutomationSection:Toggle({
  Title = "Auto Hatch Plot Eggs",
  Desc = "Instantly hatches all eggs on your plot nests",
  Value = v12.AutoHatch,
  Callback = function(value60)
    v12.AutoHatch = value60
    f18()
  end,
})

plotAutomationSection:Button({
  Title = "Manual Hatch All",
  Desc = "Fire hatch remote on all eggs on your plot now",
  Callback = function() f36() end,
})

v21.AutoBuyFoodAndGearFarm = plotAutomationSection:Toggle({
  Title = "Auto Buy Food & Gear (During Farm)",
  Desc = "Purchases selected foods & gears every time you return to plot",
  Value = v12.AutoBuyFoodAndGear,
  Callback = function(value61)
    v12.AutoBuyFoodAndGear = value61

    if v21.AutoBuyFoodAndGear then
      f58(v21.AutoBuyFoodAndGear, value61)
    end

    f18()
  end,
})

local speedsDelaysSection = mainTabTab:Section({ Title = "⚡ Speeds & Delays" })

v21.TweenSpeed = speedsDelaysSection:Slider({
  Title = "Tween Speed",
  Desc = "Speed when moving to eggs in Tween mode",
  Min = 50,
  Max = 500,
  Default = v12.TweenSpeed,
  Callback = function(value62)
    v12.TweenSpeed = value62
    f18()
  end,
})

v21.ReturnSpeed = speedsDelaysSection:Slider({
  Title = "Return Speed",
  Desc = "Speed when returning to base in Tween mode",
  Min = 50,
  Max = 500,
  Default = v12.ReturnSpeed,
  Callback = function(value63)
    v12.ReturnSpeed = value63
    f18()
  end,
})

v21.CooldownBetweenEggs = speedsDelaysSection:Slider({
  Title = "Egg Cooldown (s)",
  Desc = "Wait delay after returning/planting before taking next egg",
  Min = 0.2,
  Max = 4,
  Step = 0.1,
  Default = v12.CooldownBetweenEggs,
  Callback = function(value64)
    v12.CooldownBetweenEggs = value64
    f18()
  end,
})

local petAutomationSection = petsTabTab:Section({ Title = "🐾 Pet Automation" })

v21.AutoPlaceBestPet = petAutomationSection:Toggle({
  Title = "Auto Place Best Pet",
  Desc = "Periodically places your highest weight/tier pets on plot",
  Value = v12.AutoPlaceBestPet,
  Callback = function(value65)
    v12.AutoPlaceBestPet = value65

    if value65 then
      if v12.AutoPlacePet then
        v12.AutoPlacePet = false
        f58(v21.AutoPlacePet, false)
      end

      task.spawn(function() pcall(function() f44(true, false) end) end)
    end

    f18()
  end,
})

v21.AutoPlacePet = petAutomationSection:Toggle({
  Title = "Auto Place Selected Pets",
  Desc = "Periodically places pets matching your selected pets list",
  Value = v12.AutoPlacePet,
  Callback = function(value66)
    v12.AutoPlacePet = value66

    if value66 then
      if v12.AutoPlaceBestPet then
        v12.AutoPlaceBestPet = false
        f58(v21.AutoPlaceBestPet, false)
      end

      task.spawn(function() pcall(function() f44(false, false) end) end)
    end

    f18()
  end,
})

local dropdown = petAutomationSection:Dropdown({
  Title = "Select Pet(s)",
  Desc = "Pets to place when using 'Auto Place Selected Pets'",
  Values = f56(),
  Value = v12.SelectedPets,
  Multi = true,
  Callback = function(value67)
    v12.SelectedPets = value67 or {}
    f18()
  end,
})

v21.SelectedPets = dropdown

petAutomationSection:Button({
  Title = "Place Best Pets Now",
  Desc = "Instantly equip and place your strongest pets on plot",
  Callback = function() local v169 = f44(true, true) end,
})

petAutomationSection:Button({
  Title = "Place Selected Pets Now",
  Desc = "Instantly equip and place selected pets on plot",
  Callback = function() local v170 = f44(false, true) end,
})

petAutomationSection:Button({
  Title = "Refresh Pets List",
  Desc = "Re-scan backpack and data for newly hatched pets",
  Callback = function()
    if dropdown and dropdown.SetValues then
      dropdown:SetValues(f56())
    end
  end,
})

local careUpgradesSection = petsTabTab:Section({ Title = "🍖 Care & Upgrades" })

v21.AutoFeed = careUpgradesSection:Toggle({
  Title = "Auto Feed",
  Desc = "Continuously keeps your active plot pets well-fed with selected food",
  Value = v12.AutoFeed,
  Callback = function(value68)
    v12.AutoFeed = value68

    if value68 then
      task.spawn(function() pcall(f30) end)
    end

    f18()
  end,
})

v21.SelectedFeedFoods = careUpgradesSection:Dropdown({
  Title = "Select Food to Feed",
  Desc = "Food items to feed your plot pets (same as food shop list)",
  Values = v10,
  Value = v12.SelectedFeedFoods or { "Meat" },
  Multi = true,
  Callback = function(value69)
    v12.SelectedFeedFoods = value69 or { "Meat" }
    f18()
  end,
})

careUpgradesSection:Button({
  Title = "Feed Plot Pets Now",
  Desc = "Instantly feeds all your placed plot pets with selected food",
  Callback = function() local v171 = f30() end,
})

v21.AutoUpgradeLuck = careUpgradesSection:Toggle({
  Title = "Auto Upgrade Luck",
  Desc = "Automatically spends coins on egg luck upgrades",
  Value = v12.AutoUpgradeLuck,
  Callback = function(value70)
    v12.AutoUpgradeLuck = value70

    if value70 then
      task.spawn(function()
        pcall(function()
          local v172 = f2()

          if v172 then
            if v12.UpgradeLuckMethod == "Step by Step" then
              v172:FireServer()
            else
              v172:FireServer("Max")
            end
          end
        end)
      end)
    end

    f18()
  end,
})

v21.UpgradeLuckMethod = careUpgradesSection:Dropdown({
  Title = "Upgrade Luck Method",
  Desc = "Choose whether to buy Max upgrades at once or Step by Step",
  Values = { "Max", "Step by Step" },
  Value = v12.UpgradeLuckMethod or "Max",
  Callback = function(value71)
    v12.UpgradeLuckMethod = value71 or "Max"
    f18()
  end,
})

careUpgradesSection:Button({
  Title = "Upgrade Luck Now",
  Desc = "Purchases egg luck upgrade immediately using selected method",
  Callback = function()
    local v173 = f2()

    if v173 then
      if v12.UpgradeLuckMethod == "Step by Step" then
        v173:FireServer()
      else
        v173:FireServer("Max")
      end
    end
  end,
})

task.spawn(function()
  while true do
    task.wait(2.5)

    if v12.AutoUpgradeLuck then
      pcall(function()
        local v174 = f2()

        if v174 then
          if v12.UpgradeLuckMethod == "Step by Step" then
            v174:FireServer()
          else
            v174:FireServer("Max")
          end
        end
      end)
    end

    if v12.AutoFeed then
      pcall(f30)
    end
  end
end)

local section2 = shopTabTab:Section({ Title = "🛒 Auto Buy Automation" })

v21.AutoBuyFoodAndGear = section2:Toggle({
  Title = "Auto Buy Food & Gear (Loop)",
  Desc = "Continuously buys both selected foods and gears in a background loop",
  Value = v12.AutoBuyFoodAndGear,
  Callback = function(value72)
    v12.AutoBuyFoodAndGear = value72

    if v21.AutoBuyFoodAndGearFarm then
      f58(v21.AutoBuyFoodAndGearFarm, value72)
    end

    f18()
  end,
})

v21.AutoBuyDelay = section2:Slider({
  Title = "Auto Buy Delay (s)",
  Desc = "Time to wait between repeated buy loop iterations",
  Min = 1,
  Max = 10,
  Step = 0.5,
  Default = v12.AutoBuyDelay or 2,
  Callback = function(value73)
    v12.AutoBuyDelay = value73
    f18()
  end,
})

local gearItemsSection = shopTabTab:Section({ Title = "🛡️ Gear Items" })

v21.AutoBuyGears = gearItemsSection:Toggle({
  Title = "Auto Buy Gears (Loop)",
  Desc = "Automatically buys selected gears continuously in a loop",
  Value = v12.AutoBuyGears,
  Callback = function(value74)
    v12.AutoBuyGears = value74
    f18()
  end,
})

v21.SelectedGears = gearItemsSection:Dropdown({
  Title = "Select Gear(s)",
  Desc = "Gear items to purchase with cash",
  Values = v9,
  Value = v12.SelectedGears,
  Multi = true,
  Callback = function(value75)
    v12.SelectedGears = value75 or {}
    f18()
  end,
})

gearItemsSection:Button({
  Title = "Buy Selected Gears Now",
  Desc = "Immediately purchases all selected gear items",
  Callback = function() local v175 = f42 and f42() end,
})

local foodItemsSection = shopTabTab:Section({ Title = "🍎 Food Items" })

v21.AutoBuyFoods = foodItemsSection:Toggle({
  Title = "Auto Buy Foods (Loop)",
  Desc = "Automatically buys selected food items continuously in a loop",
  Value = v12.AutoBuyFoods,
  Callback = function(value76)
    v12.AutoBuyFoods = value76
    f18()
  end,
})

v21.SelectedFoods = foodItemsSection:Dropdown({
  Title = "Select Food(s)",
  Desc = "Food items to purchase with cash",
  Values = v10,
  Value = v12.SelectedFoods,
  Multi = true,
  Callback = function(value77)
    v12.SelectedFoods = value77 or {}
    f18()
  end,
})

foodItemsSection:Button({
  Title = "Buy Selected Foods Now",
  Desc = "Immediately purchases all selected food items",
  Callback = function() v5891 = f43 and f43() end,
})

local activeStatusParagraph = trackTabTab:Section({ Title = "📊 Live Game Tracker" }):Paragraph({
  Title = "Active Status",
  Desc = "Loading active world eggs...",
})

task.spawn(function()
  while task.wait(1.5) do
    local v176 = f41()
    local v177 = f14()
    local v178 = f28()
    local count6 = 0

    if v178 and v178:FindFirstChild("Nests") then
      for index46, value78 in ipairs(v178.Nests:GetChildren()) do
        if value78:GetAttribute("Unlocked") == true and not value78:GetAttribute("Occupied") then
          count6 = count6 + 1
        end
      end
    end

    local v179 = string.format([[
Active World Eggs: %d
Carrying Egg (Basket): %s
Plot Found: %s
Empty Nests: %d
In Volcano: %s]], #v176, v177 and "YES (In Basket)" or "NO", v178 and "YES (" .. v178.Name .. ")" or "NO", count6, f11() and "YES" or "NO")

    pcall(function()
      if activeStatusParagraph and activeStatusParagraph.SetDesc then
        activeStatusParagraph:SetDesc(v179)
      end
    end)
  end
end)

local configurationUtilitiesSection = settingsTab:Section({
  Title = "⚙️ Configuration & Utilities",
})

v21.AntiAFK = configurationUtilitiesSection:Toggle({
  Title = "Anti-AFK",
  Desc = "Prevents 20-minute idle disconnects",
  Value = v12.AntiAFK,
  Callback = function(value79)
    v12.AntiAFK = value79
    f18()
  end,
})

v21.AutoSave = configurationUtilitiesSection:Toggle({
  Title = "Auto Save Settings",
  Desc = "Saves your configuration changes automatically to JSON",
  Value = v12.AutoSave,
  Callback = function(value80)
    v12.AutoSave = value80

    if value80 then
      f18()
    end
  end,
})

configurationUtilitiesSection:Button({
  Title = "Save Settings Now",
  Desc = "Force write config to disk immediately",
  Callback = function() local v180 = { f16(false) } end,
})

configurationUtilitiesSection:Button({
  Title = "Reload Settings",
  Desc = "Reload configuration from disk and update UI controls",
  Callback = function()
    if f15() then
      f59()
    end
  end,
})

configurationUtilitiesSection:Button({
  Title = "Reset to Defaults",
  Desc = "Restore all settings to original hub defaults",
  Callback = function()
    for key10, value81 in pairs(v11) do
      if type(value81) == "table" then
        local v181 = {}

        for index47, value82 in ipairs(value81) do
          table.insert(v181, value82)
        end

        v12[key10] = v181
      else
        v12[key10] = value81
      end
    end

    f59()

    if v12.AutoSave then
      f16(true)
    end
  end,
})

configurationUtilitiesSection:Button({
  Title = "Rejoin Server",
  Desc = "Reconnects you to the same server",
  Callback = function()
    task.delay(1, function()
      pcall(function()
        teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
      end)
    end)
  end,
})

configurationUtilitiesSection:Button({
  Title = "Minimize UI",
  Desc = "Hides the window. Click 'Open Axel UI' button or press LeftShift to open it back.",
  Callback = function()
    pcall(function()
      if window.Close then
        window:Close()
      elseif window.Toggle then
        window:Toggle()
      end
    end)
  end,
})

configurationUtilitiesSection:Button({
  Title = "Unload Axel Hub",
  Desc = "Stops all loops and closes interface",
  Callback = function()
    f39()

    v12.AutoBuyFoodAndGear = false
    v12.AutoBuyGears = false
    v12.AutoBuyFoods = false

    pcall(function() window:Destroy() end)
  end,
})

if v12.AutoFarm then
  task.spawn(function()
    task.wait(1)
    f47()
  end)
end

if v12.AutoBuyFoodAndGear or v12.AutoBuyGears or v12.AutoBuyFoods then
  task.spawn(function() task.wait(1.5) end)
end