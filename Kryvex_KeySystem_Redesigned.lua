--[[
    Kryvex - Loader
    by Wozzy @wozzylaco
    (Live Clock, Auto-Focused Search, Favorites, Server Hop & Quick Actions)
]]
local KeySystem = {}
KeySystem.__index = KeySystem

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer

local isVerifying = false

-- THEME VARIABLES
local SelectedThemeColor = Color3.fromRGB(224, 38, 55)
local SelectedThemeName = "Crimson"
local IsRainbow = false
local IsChristmas = false

local MinimizedImageId = "rbxassetid://87864407653342"

local function GetExecutorName()
    if identifyexecutor then
        local ok, name = pcall(identifyexecutor)
        if ok and name and tostring(name) ~= "" then
            return tostring(name)
        end
    end
    if getexecutorname then
        local ok, name = pcall(getexecutorname)
        if ok and name and tostring(name) ~= "" then
            return tostring(name)
        end
    end
    if RunService:IsStudio() then
        return "Roblox Studio"
    end
    return "Unknown"
end

local function ValidateKey(inputKey, validKeys)
    for _, validKey in pairs(validKeys) do
        if inputKey == validKey then
            return true
        end
    end
    return false
end

local function Create(className, properties, parent)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    if parent then
        instance.Parent = parent
    end
    return instance
end

local function GetGameIconUrl(placeId)
    if not placeId or tonumber(placeId) == 0 then
        return ""
    end
    return "rbxthumb://type=GameIcon&id=" .. tostring(placeId) .. "&w=150&h=150"
end

-- =======================================================
-- SOFT NOTIFICATION SYSTEM
-- =======================================================
local function ShowNotification(text)
    local parentGui = RunService:IsStudio() and Player.PlayerGui or (gethui and gethui() or game:GetService("CoreGui"))
    local NotifyGui = parentGui:FindFirstChild("KryvexNotifyGui")
    if not NotifyGui then
        NotifyGui = Create("ScreenGui", {Name = "KryvexNotifyGui", ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, parentGui)
    end

    local NotifyFrame = Create("Frame", {
        Size = UDim2.new(0, 300, 0, 44),
        Position = UDim2.new(0.5, -150, 0.82, 40),
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        BorderSizePixel = 0,
        ZIndex = 120
    }, NotifyGui)
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}, NotifyFrame)
    Create("UIStroke", {Color = SelectedThemeColor, Thickness = 1.5}, NotifyFrame)

    Create("TextLabel", {
        Text = "✓",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 10, 0.5, -12),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = SelectedThemeColor,
        ZIndex = 121
    }, NotifyFrame)

    Create("TextLabel", {
        Text = text,
        Size = UDim2.new(1, -45, 1, 0),
        Position = UDim2.new(0, 38, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 121
    }, NotifyFrame)

    TweenService:Create(NotifyFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -150, 0.85, 0)
    }):Play()

    task.wait(2.2)

    TweenService:Create(NotifyFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -150, 0.82, 40),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.4)
    if NotifyFrame.Parent then NotifyFrame:Destroy() end
end

-- =======================================================
-- 5 FIREWORKS + 2 GIFTS EACH (NO EMOJIS, 3s FADE)
-- =======================================================
local function CreateCustomGiftBox(parent, posXScale, posYScale, boxColor, ribbonColor)
    local GiftBox = Create("Frame", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(posXScale, -12, posYScale, -12),
        BackgroundColor3 = boxColor,
        BorderSizePixel = 0,
        ZIndex = 85
    }, parent)
    Create("UICorner", {CornerRadius = UDim.new(0, 5)}, GiftBox)
    local boxStroke = Create("UIStroke", {Color = Color3.fromRGB(245, 250, 255), Thickness = 1.2}, GiftBox)

    local vRibbon = Create("Frame", {
        Size = UDim2.new(0, 4, 1, 0),
        Position = UDim2.new(0.5, -2, 0, 0),
        BackgroundColor3 = ribbonColor,
        BorderSizePixel = 0,
        ZIndex = 86
    }, GiftBox)

    local hRibbon = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 4),
        Position = UDim2.new(0, 0, 0.5, -2),
        BackgroundColor3 = ribbonColor,
        BorderSizePixel = 0,
        ZIndex = 86
    }, GiftBox)

    local bowLeft = Create("Frame", {
        Size = UDim2.new(0, 7, 0, 4),
        Position = UDim2.new(0.5, -7, 0, -3.5),
        BackgroundColor3 = ribbonColor,
        BorderSizePixel = 0,
        Rotation = -18,
        ZIndex = 87
    }, GiftBox)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, bowLeft)

    local bowRight = Create("Frame", {
        Size = UDim2.new(0, 7, 0, 4),
        Position = UDim2.new(0.5, 0, 0, -3.5),
        BackgroundColor3 = ribbonColor,
        BorderSizePixel = 0,
        Rotation = 18,
        ZIndex = 87
    }, GiftBox)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, bowRight)

    return GiftBox, boxStroke, vRibbon, hRibbon, bowLeft, bowRight
end

local function LaunchSingleFirework(Stage, launchX, burstY, accentColor)
    if not Stage.Parent then return end

    local Rocket = Create("Frame", {
        Size = UDim2.new(0, 6, 0, 18),
        Position = UDim2.new(launchX, -3, 1.02, 0),
        BackgroundColor3 = Color3.fromRGB(250, 252, 255),
        BorderSizePixel = 0,
        ZIndex = 82
    }, Stage)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, Rocket)
    Create("UIStroke", {Color = accentColor, Thickness = 1.5}, Rocket)

    task.spawn(function()
        while Rocket.Parent and Rocket.Position.Y.Scale > burstY + 0.03 do
            local trail = Create("Frame", {
                Size = UDim2.new(0, 5, 0, 5),
                Position = UDim2.new(Rocket.Position.X.Scale, 0.5, Rocket.Position.Y.Scale + 0.02, 0),
                BackgroundColor3 = accentColor,
                BackgroundTransparency = 0.25,
                BorderSizePixel = 0,
                ZIndex = 81
            }, Stage)
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}, trail)

            TweenService:Create(trail, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 1, 0, 1),
                BackgroundTransparency = 1
            }):Play()

            task.delay(0.75, function()
                if trail.Parent then trail:Destroy() end
            end)
            task.wait(0.09)
        end
    end)

    local riseTween = TweenService:Create(Rocket, TweenInfo.new(2.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(launchX, -3, burstY, 0)
    })
    riseTween:Play()
    riseTween.Completed:Wait()

    if not Stage.Parent then return end
    if Rocket.Parent then Rocket:Destroy() end

    local sparkColors = {
        accentColor,
        Color3.fromRGB(245, 252, 255),
        Color3.fromRGB(255, 215, 90),
        Color3.fromRGB(90, 235, 160)
    }

    local sparkCount = 12
    for i = 1, sparkCount do
        local angle = ((i - 1) / sparkCount) * math.pi * 2
        local distX = math.cos(angle) * 0.12
        local distY = math.sin(angle) * 0.12
        local sColor = sparkColors[(i % #sparkColors) + 1]

        local Spark = Create("Frame", {
            Size = UDim2.new(0, 7, 0, 7),
            Position = UDim2.new(launchX, -3.5, burstY, -3.5),
            BackgroundColor3 = sColor,
            BorderSizePixel = 0,
            ZIndex = 83
        }, Stage)
        Create("UICorner", {CornerRadius = UDim.new(1, 0)}, Spark)

        TweenService:Create(Spark, TweenInfo.new(1.0, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(math.clamp(launchX + distX, 0.05, 0.95), -3.5, math.clamp(burstY + distY, 0.06, 0.85), -3.5),
            Size = UDim2.new(0, 2, 0, 2),
            BackgroundTransparency = 0.85
        }):Play()

        task.delay(1.05, function()
            if Spark.Parent then Spark:Destroy() end
        end)
    end

    local pairGifts = {
        {offset = -0.045, landY = 0.81, color = Color3.fromRGB(35, 195, 105), ribbon = Color3.fromRGB(250, 252, 255)},
        {offset = 0.045,  landY = 0.84, color = Color3.fromRGB(24, 155, 84),  ribbon = Color3.fromRGB(255, 215, 90)}
    }

    for gIdx, gSpec in ipairs(pairGifts) do
        local startX = math.clamp(launchX + gSpec.offset, 0.08, 0.92)
        local box, bStroke, vRib, hRib, bLeft, bRight = CreateCustomGiftBox(Stage, startX, burstY, gSpec.color, gSpec.ribbon)

        TweenService:Create(box, TweenInfo.new(1.35, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
            Position = UDim2.new(startX, -12, gSpec.landY, -12),
            Rotation = (gIdx == 1) and -6 or 6
        }):Play()

        task.delay(3.0, function()
            if box.Parent then
                local fadeInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                TweenService:Create(box, fadeInfo, {BackgroundTransparency = 1}):Play()
                TweenService:Create(bStroke, fadeInfo, {Transparency = 1}):Play()
                TweenService:Create(vRib, fadeInfo, {BackgroundTransparency = 1}):Play()
                TweenService:Create(hRib, fadeInfo, {BackgroundTransparency = 1}):Play()
                TweenService:Create(bLeft, fadeInfo, {BackgroundTransparency = 1}):Play()
                TweenService:Create(bRight, fadeInfo, {BackgroundTransparency = 1}):Play()
                task.wait(0.5)
                if box.Parent then box:Destroy() end
            end
        end)
    end
end

local function PlayFireworkAndGiftsAnimation(parentGui)
    if not parentGui then return end

    local Stage = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 80,
        ClipsDescendants = true
    }, parentGui)

    local fireworks = {
        {x = 0.22, y = 0.25, delay = 0.0,  color = Color3.fromRGB(35, 195, 105)},
        {x = 0.40, y = 0.20, delay = 0.65, color = Color3.fromRGB(55, 215, 125)},
        {x = 0.56, y = 0.24, delay = 1.30, color = Color3.fromRGB(28, 175, 95)},
        {x = 0.72, y = 0.19, delay = 1.95, color = Color3.fromRGB(70, 225, 140)},
        {x = 0.85, y = 0.26, delay = 2.60, color = Color3.fromRGB(35, 195, 105)}
    }

    for _, fw in ipairs(fireworks) do
        task.delay(fw.delay, function()
            LaunchSingleFirework(Stage, fw.x, fw.y, fw.color)
        end)
    end

    task.delay(9.5, function()
        if Stage.Parent then Stage:Destroy() end
    end)
end

-- =======================================================
-- THEME SELECTOR
-- =======================================================
local function OpenThemeSelector(onComplete)
    local parentGui = RunService:IsStudio() and Player.PlayerGui or (gethui and gethui() or game:GetService("CoreGui"))

    local ThemeGui = Create("ScreenGui", {ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true, Name = "ThemeSelectorGui"}, parentGui)

    Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0
    }, ThemeGui)

    local MainFrame = Create("Frame", {
        Size = UDim2.new(0, 700, 0, 500),
        Position = UDim2.new(0.5, -350, 0.5, -250),
        BackgroundColor3 = Color3.fromRGB(15, 15, 18),
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, ThemeGui)
    Create("UICorner", {CornerRadius = UDim.new(0, 16)}, MainFrame)
    Create("UIStroke", {Color = Color3.fromRGB(50, 50, 60), Thickness = 1.5}, MainFrame)

    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 700, 0, 500)}):Play()

    Create("TextLabel", {
        Text = "Choose your theme",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        TextSize = 22,
        TextColor3 = Color3.fromRGB(255, 255, 255),
    }, MainFrame)

    Create("TextLabel", {
        Text = "Select a look for Kryvex Hub. You can change it later any time.",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 55),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(150, 150, 150),
    }, MainFrame)

    local Themes = {
        {Name = "Crimson", Desc = "Deep dark red", Color = Color3.fromRGB(224, 38, 55), IsRainbow = false, IsChristmas = false},
        {Name = "Obsidian Violet", Desc = "Deep night purple", Color = Color3.fromRGB(153, 86, 255), IsRainbow = false, IsChristmas = false},
        {Name = "Azure", Desc = "Cold blue", Color = Color3.fromRGB(48, 133, 255), IsRainbow = false, IsChristmas = false},
        {Name = "Gold", Desc = "Shiny yellow", Color = Color3.fromRGB(226, 171, 52), IsRainbow = false, IsChristmas = false},
        {Name = "Rainbow", Desc = "Animated colors", Color = Color3.fromRGB(255, 0, 0), IsRainbow = true, IsChristmas = false},
        {Name = "Christmas", Desc = "Green winter snow & fireworks", Color = Color3.fromRGB(35, 195, 105), IsRainbow = false, IsChristmas = true}
    }

    local Grid = Create("Frame", {
        Size = UDim2.new(1, -40, 0, 350),
        Position = UDim2.new(0, 20, 0, 90),
        BackgroundTransparency = 1
    }, MainFrame)
    Create("UIGridLayout", {CellSize = UDim2.new(0.5, -10, 0, 100), CellPadding = UDim2.new(0, 20, 0, 20), SortOrder = Enum.SortOrder.LayoutOrder}, Grid)

    local SelectedFrame = nil

    for _, themeData in ipairs(Themes) do
        local Btn = Create("TextButton", {
            BackgroundColor3 = Color3.fromRGB(25, 25, 30),
            BorderSizePixel = 0,
            Text = "",
            ClipsDescendants = true,
            AutoButtonColor = false
        }, Grid)
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}, Btn)
        local stroke = Create("UIStroke", {Color = Color3.fromRGB(40, 40, 45), Thickness = 1}, Btn)

        local ColorBar = Create("Frame", {
            Size = UDim2.new(0, 8, 1, 0),
            BackgroundColor3 = themeData.Color,
            BorderSizePixel = 0
        }, Btn)
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}, ColorBar)

        local DotsFrame = Create("Frame", {
            Size = UDim2.new(0, 40, 0, 15),
            Position = UDim2.new(1, -50, 0.5, -7.5),
            BackgroundTransparency = 1
        }, Btn)
        local dot1 = Create("Frame", {Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0, 0, 0.5, -4), BackgroundColor3 = themeData.Color, BorderSizePixel = 0}, DotsFrame)
        Create("UICorner", {CornerRadius = UDim.new(1, 0)}, dot1)
        local dot2 = Create("Frame", {Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0, 12, 0.5, -4), BackgroundColor3 = themeData.Color, BorderSizePixel = 0, BackgroundTransparency = 0.5}, DotsFrame)
        Create("UICorner", {CornerRadius = UDim.new(1, 0)}, dot2)
        local dot3 = Create("Frame", {Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0, 24, 0.5, -4), BackgroundColor3 = themeData.Color, BorderSizePixel = 0, BackgroundTransparency = 0.8}, DotsFrame)
        Create("UICorner", {CornerRadius = UDim.new(1, 0)}, dot3)

        Create("TextLabel", {
            Text = themeData.Name,
            Size = UDim2.new(1, -60, 0, 20),
            Position = UDim2.new(0, 20, 0, 20),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left
        }, Btn)

        Create("TextLabel", {
            Text = themeData.Desc,
            Size = UDim2.new(1, -60, 0, 15),
            Position = UDim2.new(0, 20, 0, 40),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextXAlignment = Enum.TextXAlignment.Left
        }, Btn)

        if themeData.IsChristmas then
            Create("TextLabel", {
                Text = "",
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(1, -40, 0, 10),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold,
                TextSize = 20
            }, Btn)
        end

        if themeData.IsRainbow then
            task.spawn(function()
                local hue = 0
                while Btn.Parent do
                    hue = (hue + 0.02) % 1
                    local rainbowColor = Color3.fromHSV(hue, 1, 1)
                    ColorBar.BackgroundColor3 = rainbowColor
                    dot1.BackgroundColor3 = rainbowColor
                    dot2.BackgroundColor3 = rainbowColor
                    dot3.BackgroundColor3 = rainbowColor
                    task.wait(0.05)
                end
            end)
        end

        Btn.MouseEnter:Connect(function()
            TweenService:Create(stroke, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Color = Color3.fromRGB(100, 100, 100)}):Play()
            TweenService:Create(Btn, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        end)

        Btn.MouseLeave:Connect(function()
            if SelectedFrame ~= Btn then
                TweenService:Create(stroke, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Color = Color3.fromRGB(40, 40, 45)}):Play()
                TweenService:Create(Btn, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
            end
        end)

        Btn.MouseButton1Click:Connect(function()
            if SelectedFrame then
                local oldStroke = SelectedFrame:FindFirstChildOfClass("UIStroke")
                if oldStroke then oldStroke.Color = Color3.fromRGB(40, 40, 45) end
            end
            SelectedFrame = Btn
            stroke.Color = themeData.Color

            SelectedThemeColor = themeData.Color
            SelectedThemeName = themeData.Name
            IsRainbow = themeData.IsRainbow or false
            IsChristmas = themeData.IsChristmas or false

            local originalColor = Btn.BackgroundColor3
            TweenService:Create(Btn, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundColor3 = themeData.Color}):Play()
            task.wait(0.3)
            TweenService:Create(Btn, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {BackgroundColor3 = originalColor}):Play()

            task.wait(0.4)
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            task.wait(0.3)
            ThemeGui:Destroy()
            onComplete()
        end)
    end
end

-- =======================================================
-- KRYVEX HUB - LOADER MENU
-- =======================================================
local function OpenKryvexHubLoader()
    local parentGui = RunService:IsStudio() and Player.PlayerGui or
       (gethui and gethui() or game:GetService("CoreGui"))

    local LoaderGui = Create("ScreenGui", {
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Name = "KryvexHubLoaderGui"
    }, parentGui)

    local currentAccent = SelectedThemeColor
    local dynamicColorObjects = {}

    local function registerAccent(obj, prop)
        table.insert(dynamicColorObjects, {obj = obj, prop = prop})
        obj[prop] = currentAccent
    end

    if IsRainbow then
        task.spawn(function()
            local h = 0
            while LoaderGui.Parent do
                h = (h + 0.02) % 1
                currentAccent = Color3.fromHSV(h, 1, 1)
                for _, item in ipairs(dynamicColorObjects) do
                    if item.obj and item.obj.Parent then
                        item.obj[item.prop] = currentAccent
                    end
                end
                task.wait(0.05)
            end
        end)
    end

    local LoaderFrameSize = UDim2.new(0, 800, 0, 495)
    local LoaderFrame = Create("Frame", {
        Size = LoaderFrameSize,
        Position = UDim2.new(0.5, -400, 0.5, -247.5),
        BackgroundColor3 = Color3.fromRGB(14, 11, 12),
        BorderSizePixel = 0,
        Visible = true,
        Active = true,
        ClipsDescendants = true,
        Name = "LoaderFrame"
    }, LoaderGui)
    Create("UICorner", {CornerRadius = UDim.new(0, 14)}, LoaderFrame)
    local mainFrameStroke = Create("UIStroke", {Color = currentAccent, Thickness = 2}, LoaderFrame)
    registerAccent(mainFrameStroke, "Color")

    -- Clean, static background; theme accent is handled by the shared palette.

    -- TOP HEADER
    local Header = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Color3.fromRGB(20, 14, 16),
        BorderSizePixel = 0,
        ZIndex = 5
    }, LoaderFrame)
    Create("UICorner", {CornerRadius = UDim.new(0, 14)}, Header)

    local headerLine = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1.5),
        Position = UDim2.new(0, 0, 1, -1.5),
        BackgroundColor3 = currentAccent,
        BorderSizePixel = 0,
        ZIndex = 6
    }, Header)
    registerAccent(headerLine, "BackgroundColor3")

    local HeaderBadge = Create("Frame", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 14, 0.5, -14),
        BackgroundColor3 = Color3.fromRGB(32, 20, 24),
        BorderSizePixel = 0,
        ZIndex = 6
    }, Header)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, HeaderBadge)
    local badgeStroke = Create("UIStroke", {Color = currentAccent, Thickness = 1.2}, HeaderBadge)
    registerAccent(badgeStroke, "Color")

    local badgeIcon = Create("TextLabel", {
        Text = "K",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        TextSize = 14,
        TextColor3 = currentAccent,
        ZIndex = 7
    }, HeaderBadge)
    registerAccent(badgeIcon, "TextColor3")

    Create("TextLabel", {
        Text = "KRYVEX HUB",
        Size = UDim2.new(0, 140, 0, 18),
        Position = UDim2.new(0, 50, 0, 8),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6
    }, Header)

    local HeaderSubLabel = Create("TextLabel", {
        Text = "Theme: " .. tostring(SelectedThemeName) .. "  |  Place ID: " .. tostring(game.PlaceId),
        Size = UDim2.new(0, 420, 0, 14),
        Position = UDim2.new(0, 50, 0, 26),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(165, 155, 160),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6
    }, Header)

    local LoaderMinBtn = Create("TextButton", {
        Text = "-",
        Font = Enum.Font.GothamBlack,
        TextSize = 18,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundColor3 = Color3.fromRGB(28, 20, 24),
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -76, 0.5, -14),
        BorderSizePixel = 0,
        ZIndex = 6
    }, Header)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, LoaderMinBtn)
    local minBtnStroke = Create("UIStroke", {Color = currentAccent, Thickness = 1}, LoaderMinBtn)
    registerAccent(minBtnStroke, "Color")

    local LoaderCloseBtn = Create("TextButton", {
        Text = "X",
        Font = Enum.Font.GothamBlack,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundColor3 = Color3.fromRGB(28, 20, 24),
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -42, 0.5, -14),
        BorderSizePixel = 0,
        ZIndex = 6
    }, Header)
    Create("UICorner", {CornerRadius = UDim.new(0, 7)}, LoaderCloseBtn)
    local closeBtnStroke = Create("UIStroke", {Color = currentAccent, Thickness = 1}, LoaderCloseBtn)
    registerAccent(closeBtnStroke, "Color")

    -- MINIMIZED FLOATING BUTTON
    local LoaderMinimized = Create("ImageButton", {
        Image = MinimizedImageId,
        BackgroundColor3 = currentAccent,
        Size = UDim2.new(0, 72, 0, 72),
        Position = UDim2.new(0, 50, 0, 50),
        BorderSizePixel = 0,
        Visible = false,
        Active = true,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 50
    }, LoaderGui)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, LoaderMinimized)
    local loaderMinStroke = Create("UIStroke", {Color = currentAccent, Thickness = 2}, LoaderMinimized)
    registerAccent(LoaderMinimized, "BackgroundColor3")
    registerAccent(loaderMinStroke, "Color")

    -- DRAG LOGIC
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = LoaderFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            LoaderFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local lmDragging, lmDragInput, lmDragStart, lmStartPos, lmMoved
    LoaderMinimized.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            lmDragging = true; lmMoved = false; lmDragStart = input.Position; lmStartPos = LoaderMinimized.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then lmDragging = false end
            end)
        end
    end)
    LoaderMinimized.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            lmDragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == lmDragInput and lmDragging then
            local delta = input.Position - lmDragStart
            if delta.Magnitude > 4 then lmMoved = true end
            LoaderMinimized.Position = UDim2.new(lmStartPos.X.Scale, lmStartPos.X.Offset + delta.X, lmStartPos.Y.Scale, lmStartPos.Y.Offset + delta.Y)
        end
    end)

    LoaderMinBtn.MouseButton1Click:Connect(function()
        LoaderFrame.Visible = false
        LoaderMinimized.Visible = true
        LoaderMinimized.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(LoaderMinimized, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 72, 0, 72)}):Play()
    end)

    LoaderMinimized.MouseButton1Click:Connect(function()
        if lmMoved then return end
        TweenService:Create(LoaderMinimized, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.25)
        LoaderMinimized.Visible = false
        LoaderFrame.Visible = true
    end)

    LoaderCloseBtn.MouseButton1Click:Connect(function()
        LoaderGui:Destroy()
    end)

    -- LEFT PANEL
    local LeftSection = Create("Frame", {
        Size = UDim2.new(0, 495, 1, -64),
        Position = UDim2.new(0, 14, 0, 56),
        BackgroundColor3 = Color3.fromRGB(19, 14, 16),
        BorderSizePixel = 0,
        ZIndex = 4
    }, LoaderFrame)
    Create("UICorner", {CornerRadius = UDim.new(0, 10)}, LeftSection)
    Create("UIStroke", {Color = Color3.fromRGB(45, 34, 38), Thickness = 1}, LeftSection)

    local scripts = {
        {
            Name = "Muscle Legends",
            PlaceId = 3623096087,
            URL = "https://github.com/WozzyLaco/Kryvex-Public/raw/refs/heads/main/Kryvexpublic.txt"
        },
        {
            Name = "Sell A Lemons",
            PlaceId = 0,
            URL = "https://github.com/WozzyLaco/Kryvex-Public/raw/refs/heads/main/obfuscated_Rayfield_Sell_a_Lemon.lua_2.txt"
        },
        {
            Name = "+1 Speed Monkey Escape",
            PlaceId = 0,
            URL = "https://github.com/WozzyLaco/Kryvex-Public/raw/refs/heads/main/obfuscated_1.txt"
        },
        {
            Name = "Survive A Million Monkeys",
            PlaceId = 0,
            URL = "https://github.com/WozzyLaco/Kryvex-Public/raw/refs/heads/main/obfuscated_Monkey.txt"
        },
        {
            Name = "Evade",
            PlaceId = 9872472334,
            URL = "https://github.com/WozzyLaco/Kryvex-Public/raw/refs/heads/main/obfuscated_evade.txt"
        },
        {
            Name = "Lumber Tycoon 2",
            PlaceId = 13822889,
            URL = "https://github.com/WozzyLaco/Kryvex-Public/raw/refs/heads/main/obfuscated_limber_tycon_2.txt"
        },
        {
            Name = "Legends Of Speed",
            PlaceId = 3101667897,
            URL = "https://github.com/WozzyLaco/Kryvex-Public/raw/refs/heads/main/obfuscated_Kryvex_Hub_WindUI_Optimized.lua.txt"
        },
        {
            Name = "Ninja Legends",
            PlaceId = 3956818381,
            URL = "https://github.com/WozzyLaco/Kryvex-Public/raw/refs/heads/main/obfuscated_Kryvex_Hub_NinjaLegends_WindUI.lua.txt"
        },
        {
            Name = "Anime Dice",
            PlaceId = 0,
            URL = "https://github.com/WozzyLaco/Kryvex-Public/raw/refs/heads/main/obfuscated_Anime_dice.txt"
        }
    }

    local totalSupportedGames = #scripts
    local favorites = {}

    local function executeScriptUrl(url)
        local shrink = TweenService:Create(LoaderFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        shrink:Play()
        shrink.Completed:Connect(function()
            LoaderGui:Destroy()
            pcall(function()
                loadstring(game:HttpGet(url))()
            end)
        end)
    end

    -- AUTO-DETECTED CURRENT GAME BANNER
    local matchedScript = nil
    for _, sData in ipairs(scripts) do
        if sData.PlaceId and tonumber(sData.PlaceId) > 0 and tonumber(sData.PlaceId) == tonumber(game.PlaceId) then
            matchedScript = sData
            break
        end
    end

    local DetectedBanner = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 68),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(27, 19, 22),
        BorderSizePixel = 0,
        ZIndex = 5
    }, LeftSection)
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}, DetectedBanner)
    local bannerStroke = Create("UIStroke", {Color = currentAccent, Thickness = 1.2}, DetectedBanner)
    registerAccent(bannerStroke, "Color")

    local DetectedIcon = Create("ImageLabel", {
        Size = UDim2.new(0, 46, 0, 46),
        Position = UDim2.new(0, 10, 0.5, -23),
        BackgroundColor3 = Color3.fromRGB(38, 28, 32),
        Image = matchedScript and GetGameIconUrl(matchedScript.PlaceId) or GetGameIconUrl(game.PlaceId),
        BorderSizePixel = 0,
        ZIndex = 6
    }, DetectedBanner)
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}, DetectedIcon)

    if matchedScript then
        Create("TextLabel", {
            Text = matchedScript.Name,
            Size = UDim2.new(1, -175, 0, 22),
            Position = UDim2.new(0, 66, 0, 12),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6
        }, DetectedBanner)

        local detectedSub = Create("TextLabel", {
            Text = "Auto-matched script ready to run",
            Size = UDim2.new(1, -175, 0, 18),
            Position = UDim2.new(0, 66, 0, 34),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextColor3 = currentAccent,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6
        }, DetectedBanner)
        registerAccent(detectedSub, "TextColor3")

        local ExecNowBtn = Create("TextButton", {
            Text = "EXECUTE",
            Size = UDim2.new(0, 96, 0, 36),
            Position = UDim2.new(1, -108, 0.5, -18),
            BackgroundColor3 = currentAccent,
            Font = Enum.Font.GothamBlack,
            TextSize = 12,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            ZIndex = 6
        }, DetectedBanner)
        Create("UICorner", {CornerRadius = UDim.new(0, 7)}, ExecNowBtn)
        registerAccent(ExecNowBtn, "BackgroundColor3")

        ExecNowBtn.MouseButton1Click:Connect(function()
            executeScriptUrl(matchedScript.URL)
        end)
    else
        Create("TextLabel", {
            Text = "This game is not found in the script",
            Size = UDim2.new(1, -80, 0, 22),
            Position = UDim2.new(0, 66, 0, 13),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6
        }, DetectedBanner)

        Create("TextLabel", {
            Text = "Pick a supported game below or search scripts",
            Size = UDim2.new(1, -80, 0, 18),
            Position = UDim2.new(0, 66, 0, 35),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextColor3 = Color3.fromRGB(165, 155, 160),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6
        }, DetectedBanner)
    end

    -- SEARCH BAR + DYNAMIC SUPPORTED GAMES COUNTER
    local SearchRow = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 36),
        Position = UDim2.new(0, 10, 0, 86),
        BackgroundTransparency = 1,
        ZIndex = 5
    }, LeftSection)

    local SearchBoxFrame = Create("Frame", {
        Size = UDim2.new(1, -152, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(25, 19, 22),
        BorderSizePixel = 0,
        ZIndex = 5
    }, SearchRow)
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}, SearchBoxFrame)
    Create("UIStroke", {Color = Color3.fromRGB(50, 38, 44), Thickness = 1}, SearchBoxFrame)

    local SearchBox = Create("TextBox", {
        Size = UDim2.new(1, -18, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        PlaceholderText = "Search scripts",
        PlaceholderColor3 = Color3.fromRGB(130, 120, 125),
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ZIndex = 6
    }, SearchBoxFrame)

    local CountPill = Create("Frame", {
        Size = UDim2.new(0, 144, 1, 0),
        Position = UDim2.new(1, -144, 0, 0),
        BackgroundColor3 = Color3.fromRGB(27, 19, 22),
        BorderSizePixel = 0,
        ZIndex = 5
    }, SearchRow)
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}, CountPill)
    local countStroke = Create("UIStroke", {Color = currentAccent, Thickness = 1}, CountPill)
    registerAccent(countStroke, "Color")

    local CountLabel = Create("TextLabel", {
        Text = tostring(totalSupportedGames) .. " supported games",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = currentAccent,
        ZIndex = 6
    }, CountPill)
    registerAccent(CountLabel, "TextColor3")

    -- SCROLLABLE SCRIPT LIST WITH FAVORITES, GAME ICON & QUICK COPY
    local ScrollContainer = Create("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -138),
        Position = UDim2.new(0, 10, 0, 130),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = currentAccent,
        BorderSizePixel = 0,
        ZIndex = 5
    }, LeftSection)
    registerAccent(ScrollContainer, "ScrollBarImageColor3")

    Create("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 7),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, ScrollContainer)
    Create("UIPadding", {PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 4)}, ScrollContainer)

    local allRows = {}
    local refreshListOrder

    local function CreateScriptRow(sData, index)
        local row = Create("Frame", {
            Size = UDim2.new(1, -6, 0, 52),
            BackgroundColor3 = Color3.fromRGB(25, 19, 22),
            BorderSizePixel = 0,
            LayoutOrder = index * 10,
            ZIndex = 6
        }, ScrollContainer)
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}, row)
        Create("UIStroke", {Color = Color3.fromRGB(45, 34, 38), Thickness = 1}, row)

        local gameImgId = GetGameIconUrl(sData.PlaceId)
        local GameThumb = Create("ImageLabel", {
            Size = UDim2.new(0, 38, 0, 38),
            Position = UDim2.new(0, 8, 0.5, -19),
            BackgroundColor3 = Color3.fromRGB(36, 26, 30),
            Image = gameImgId,
            BorderSizePixel = 0,
            ZIndex = 7
        }, row)
        Create("UICorner", {CornerRadius = UDim.new(0, 7)}, GameThumb)

        if gameImgId == "" then
            Create("TextLabel", {
                Text = string.sub(sData.Name, 1, 1),
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBlack,
                TextSize = 15,
                TextColor3 = Color3.fromRGB(220, 210, 215),
                ZIndex = 8
            }, GameThumb)
        end

        Create("TextLabel", {
            Text = sData.Name,
            Size = UDim2.new(1, -155, 0, 18),
            Position = UDim2.new(0, 54, 0, 8),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 7
        }, row)

        local placeStr = (sData.PlaceId and tonumber(sData.PlaceId) > 0) and tostring(sData.PlaceId) or "Universal"
        local subInfo = (sData.PlaceId and tonumber(sData.PlaceId) > 0) and ("Place ID: " .. placeStr) or "Universal / Multi-Place"
        Create("TextLabel", {
            Text = subInfo,
            Size = UDim2.new(1, -155, 0, 15),
            Position = UDim2.new(0, 54, 0, 27),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextColor3 = Color3.fromRGB(155, 145, 150),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 7
        }, row)

        local favBtn = Create("TextButton", {
            Text = "☆",
            Size = UDim2.new(0, 28, 0, 28),
            Position = UDim2.new(1, -112, 0.5, -14),
            BackgroundColor3 = Color3.fromRGB(32, 22, 26),
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(170, 160, 165),
            BorderSizePixel = 0,
            ZIndex = 7
        }, row)
        Create("UICorner", {CornerRadius = UDim.new(0, 7)}, favBtn)

        local copyUrlBtn = Create("TextButton", {
            Text = "URL",
            Size = UDim2.new(0, 34, 0, 28),
            Position = UDim2.new(1, -78, 0.5, -14),
            BackgroundColor3 = Color3.fromRGB(32, 22, 26),
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextColor3 = Color3.fromRGB(210, 200, 205),
            BorderSizePixel = 0,
            ZIndex = 7
        }, row)
        Create("UICorner", {CornerRadius = UDim.new(0, 7)}, copyUrlBtn)

        copyUrlBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard('loadstring(game:HttpGet("' .. sData.URL .. '"))()')
                ShowNotification(sData.Name .. " loadstring copied!")
            end
        end)

        local runBtn = Create("TextButton", {
            Text = "▶",
            Size = UDim2.new(0, 32, 0, 28),
            Position = UDim2.new(1, -38, 0.5, -14),
            BackgroundColor3 = Color3.fromRGB(34, 24, 28),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = currentAccent,
            BorderSizePixel = 0,
            ZIndex = 7
        }, row)
        Create("UICorner", {CornerRadius = UDim.new(0, 7)}, runBtn)
        local rStroke = Create("UIStroke", {Color = currentAccent, Thickness = 1}, runBtn)
        registerAccent(rStroke, "Color")
        registerAccent(runBtn, "TextColor3")

        runBtn.MouseButton1Click:Connect(function()
            executeScriptUrl(sData.URL)
        end)

        local itemEntry = {
            Row = row,
            Name = sData.Name,
            PlaceIdStr = string.lower(placeStr),
            BaseIndex = index,
            FavBtn = favBtn
        }

        favBtn.MouseButton1Click:Connect(function()
            favorites[sData.Name] = not favorites[sData.Name]
            if favorites[sData.Name] then
                favBtn.Text = "★"
                favBtn.TextColor3 = currentAccent
                ShowNotification("Pinned " .. sData.Name .. " to top")
            else
                favBtn.Text = "☆"
                favBtn.TextColor3 = Color3.fromRGB(170, 160, 165)
                ShowNotification("Unpinned " .. sData.Name)
            end
            refreshListOrder()
        end)

        return itemEntry
    end

    local listLayout = ScrollContainer:FindFirstChildOfClass("UIListLayout")

    refreshListOrder = function()
        local query = string.lower(SearchBox.Text)
        local visibleCount = 0
        for _, item in ipairs(allRows) do
            local isFav = favorites[item.Name] == true
            item.Row.LayoutOrder = (isFav and 0 or 100) + item.BaseIndex
            if isFav then
                item.FavBtn.TextColor3 = currentAccent
            end
            local matches = (query == "" or string.find(string.lower(item.Name), query, 1, true) ~= nil or string.find(item.PlaceIdStr, query, 1, true) ~= nil)
            item.Row.Visible = matches
            if matches then
                visibleCount += 1
            end
        end
        if query == "" then
            CountLabel.Text = tostring(totalSupportedGames) .. " supported games"
        else
            CountLabel.Text = tostring(visibleCount) .. " / " .. tostring(totalSupportedGames) .. " found"
        end
        ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end

    for idx, sData in ipairs(scripts) do
        table.insert(allRows, CreateScriptRow(sData, idx))
    end
    refreshListOrder()

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        refreshListOrder()
    end)

    -- RIGHT PANEL: SERVER DETAILS + LIVE CLOCK + COPY ALL & SERVER HOP
    local RightSection = Create("Frame", {
        Size = UDim2.new(0, 266, 1, -64),
        Position = UDim2.new(0, 520, 0, 56),
        BackgroundColor3 = Color3.fromRGB(19, 14, 16),
        BorderSizePixel = 0,
        ZIndex = 4
    }, LoaderFrame)
    Create("UICorner", {CornerRadius = UDim.new(0, 10)}, RightSection)
    Create("UIStroke", {Color = Color3.fromRGB(45, 34, 38), Thickness = 1}, RightSection)

    local GamePreview = Create("ImageLabel", {
        Size = UDim2.new(1, -20, 0, 96),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(28, 20, 24),
        Image = GetGameIconUrl(game.PlaceId),
        ScaleType = Enum.ScaleType.Crop,
        BorderSizePixel = 0,
        ZIndex = 5
    }, RightSection)
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}, GamePreview)

    local CurrentGameBadge = Create("Frame", {
        Size = UDim2.new(0, 92, 0, 18),
        Position = UDim2.new(0, 8, 1, -24),
        BackgroundColor3 = Color3.fromRGB(14, 11, 12),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ZIndex = 6
    }, GamePreview)
    Create("UICorner", {CornerRadius = UDim.new(0, 5)}, CurrentGameBadge)

    Create("TextLabel", {
        Text = "CURRENT GAME",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        TextSize = 8,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 7
    }, CurrentGameBadge)

    local GameTitleLabel = Create("TextLabel", {
        Text = "Loading Game...",
        Size = UDim2.new(1, -20, 0, 18),
        Position = UDim2.new(0, 10, 0, 110),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 5
    }, RightSection)

    Create("TextLabel", {
        Text = "Server details & quick actions",
        Size = UDim2.new(1, -20, 0, 14),
        Position = UDim2.new(0, 10, 0, 127),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = Color3.fromRGB(155, 145, 150),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5
    }, RightSection)

    task.spawn(function()
        local ok, info = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if ok and info and info.Name then
            GameTitleLabel.Text = info.Name
        else
            GameTitleLabel.Text = "Place #" .. tostring(game.PlaceId)
        end
    end)

    local function CreateDetailCard(yPos, titleText, valueText, showCopyBtn)
        local card = Create("Frame", {
            Size = UDim2.new(1, -20, 0, 42),
            Position = UDim2.new(0, 10, 0, yPos),
            BackgroundColor3 = Color3.fromRGB(25, 19, 22),
            BorderSizePixel = 0,
            ZIndex = 5
        }, RightSection)
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}, card)
        Create("UIStroke", {Color = Color3.fromRGB(45, 34, 38), Thickness = 1}, card)

        local rightPad = (showCopyBtn == false) and 16 or 48

        Create("TextLabel", {
            Text = titleText,
            Size = UDim2.new(1, -rightPad, 0, 13),
            Position = UDim2.new(0, 10, 0, 5),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 9,
            TextColor3 = Color3.fromRGB(155, 145, 150),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6
        }, card)

        local valLabel = Create("TextLabel", {
            Text = tostring(valueText),
            Size = UDim2.new(1, -rightPad, 0, 17),
            Position = UDim2.new(0, 10, 0, 19),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 6
        }, card)

        if showCopyBtn ~= false then
            local copyBtn = Create("TextButton", {
                Text = "Copy",
                Size = UDim2.new(0, 36, 0, 22),
                Position = UDim2.new(1, -44, 0.5, -11),
                BackgroundColor3 = Color3.fromRGB(34, 24, 28),
                Font = Enum.Font.GothamBold,
                TextSize = 10,
                TextColor3 = currentAccent,
                BorderSizePixel = 0,
                ZIndex = 6
            }, card)
            Create("UICorner", {CornerRadius = UDim.new(0, 6)}, copyBtn)
            registerAccent(copyBtn, "TextColor3")

            copyBtn.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(tostring(valLabel.Text))
                    ShowNotification(titleText .. " copied!")
                end
            end)
        end

        return valLabel
    end

    local jobIdStr = (game.JobId and game.JobId ~= "") and tostring(game.JobId) or "Studio / Local"
    local executorStr = GetExecutorName()

    CreateDetailCard(147, "PLACE ID", tostring(game.PlaceId), true)
    CreateDetailCard(194, "JOB ID", jobIdStr, true)
    CreateDetailCard(241, "EXECUTOR", executorStr, true)
    local liveClockLabel = CreateDetailCard(288, "CURRENT TIME", os.date("%H:%M:%S"), false)

    task.spawn(function()
        while LoaderGui.Parent do
            local now = os.date("*t")
            liveClockLabel.Text = string.format("%02d:%02d:%02d", now.hour, now.min, now.sec)
            task.wait(1)
        end
    end)

    -- BOTTOM ACTION ROW: COPY ALL GAME INFO + SERVER HOP
    local CopyAllBtn = Create("TextButton", {
        Text = "Copy all game info",
        Size = UDim2.new(0.58, -13, 0, 36),
        Position = UDim2.new(0, 10, 1, -46),
        BackgroundColor3 = currentAccent,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 6
    }, RightSection)
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}, CopyAllBtn)
    registerAccent(CopyAllBtn, "BackgroundColor3")

    local HopBtn = Create("TextButton", {
        Text = "Server Hop",
        Size = UDim2.new(0.42, -12, 0, 36),
        Position = UDim2.new(0.58, 2, 1, -46),
        BackgroundColor3 = Color3.fromRGB(28, 20, 24),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = currentAccent,
        BorderSizePixel = 0,
        ZIndex = 6
    }, RightSection)
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}, HopBtn)
    local hopStroke = Create("UIStroke", {Color = currentAccent, Thickness = 1.2}, HopBtn)
    registerAccent(hopStroke, "Color")
    registerAccent(HopBtn, "TextColor3")

    CopyAllBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            local allInfo = string.format(
                "Game: %s\nPlace ID: %s\nJob ID: %s\nExecutor: %s\nTime: %s",
                GameTitleLabel.Text,
                tostring(game.PlaceId),
                jobIdStr,
                executorStr,
                liveClockLabel.Text
            )
            setclipboard(allInfo)
            ShowNotification("All game info copied!")
        end
    end)

    HopBtn.MouseButton1Click:Connect(function()
        ShowNotification("Finding a new server...")
        pcall(function()
            local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)
            local raw = game:HttpGet(url)
            local decoded = HttpService:JSONDecode(raw)
            if decoded and decoded.data then
                for _, srv in ipairs(decoded.data) do
                    if srv.id ~= game.JobId and tonumber(srv.playing) < tonumber(srv.maxPlayers) then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, Player)
                        return
                    end
                end
            end
            TeleportService:Teleport(game.PlaceId, Player)
        end)
    end)

    local openTween = TweenService:Create(LoaderFrame, TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = LoaderFrameSize
    })
    openTween:Play()
    openTween.Completed:Connect(function()
        if SearchBox and SearchBox.Parent then
            pcall(function()
                SearchBox:CaptureFocus()
            end)
        end
    end)
end

-- =======================================================
-- KRYVEX KEY SYSTEM
-- =======================================================
function KeySystem:CreateKeySystem(Config)
    local Keys = Config.Keys or {"", "", ""}
    local MainScriptCallback = Config.MainScriptCallback or function(success) end
    local DiscordLink = "https://discord.gg/prVF5TY5W"

    local ThemeColor = SelectedThemeColor
    local WhiteColor = Color3.fromRGB(255, 255, 255)
    local DarkBg = Color3.fromRGB(8, 8, 10)
    local PanelBg = Color3.fromRGB(13, 13, 16)
    local ExecutorName = GetExecutorName()

    local KContainerSize = UDim2.new(0, 860, 0, 455)

    local KeySystemGui = Create("ScreenGui", {
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true, Name = "KeySystemGui"
    }, RunService:IsStudio() and Player.PlayerGui or (gethui and gethui() or game:GetService("CoreGui")))

    local KeyContainer = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = DarkBg, BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0), Size = KContainerSize, Active = true, Name = "KeyContainer", ClipsDescendants = true
    }, KeySystemGui)

    Create("UICorner", {CornerRadius = UDim.new(0, 15)}, KeyContainer)
    local MainStroke = Create("UIStroke", {Color = ThemeColor, Thickness = 1.6}, KeyContainer)
    Create("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 16, 19)), ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 7, 9))}), Rotation = 90}, KeyContainer)

    if IsRainbow then
        task.spawn(function()
            local h = 0
            while KeySystemGui.Parent do
                h = (h + 0.02) % 1
                MainStroke.Color = Color3.fromHSV(h, 1, 1)
                task.wait(0.05)
            end
        end)
    end

    -- Clean verification surface: no particles or seasonal overlays.

    local dragging, dragInput, dragStart, startPos
    KeyContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = KeyContainer.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    KeyContainer.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            KeyContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local HeaderFrame = Create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, ZIndex = 2}, KeyContainer)

    local MainTitle = Create("TextLabel", {
        Text = "KRYVEX HUB",
        Size = UDim2.new(0, 250, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        TextSize = 16,
        TextColor3 = ThemeColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 2
    }, HeaderFrame)
    Create("Frame", {Size = UDim2.new(1, -30, 0, 1), Position = UDim2.new(0, 15, 1, -1), BackgroundColor3 = ThemeColor, BackgroundTransparency = 0.38, BorderSizePixel = 0, ZIndex = 2}, HeaderFrame)

    if IsRainbow then
        task.spawn(function()
            local h = 0
            while KeySystemGui.Parent do
                h = (h + 0.02) % 1
                MainTitle.TextColor3 = Color3.fromHSV(h, 1, 1)
                task.wait(0.05)
            end
        end)
    end

    local TopRightFrame = Create("Frame", {Size = UDim2.new(0, 100, 1, 0), Position = UDim2.new(1, -105, 0, 0), BackgroundTransparency = 1, ZIndex = 2}, HeaderFrame)

    local MinimizeBtn = Create("TextButton", {
        Text = "−", Font = Enum.Font.GothamBlack, TextSize = 20, TextColor3 = WhiteColor,
        BackgroundColor3 = Color3.fromRGB(170, 116, 28), Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(0, 0, 0.5, -13), BorderSizePixel = 0, ZIndex = 2
    }, TopRightFrame)
    Create("UICorner", {CornerRadius = UDim.new(0, 6)}, MinimizeBtn)

    local CloseButton = Create("TextButton", {
        Text = "×", Font = Enum.Font.GothamBlack, TextSize = 17, TextColor3 = WhiteColor,
        BackgroundColor3 = Color3.fromRGB(190, 39, 54), Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(0, 33, 0.5, -13), BorderSizePixel = 0, ZIndex = 2
    }, TopRightFrame)
    Create("UICorner", {CornerRadius = UDim.new(0, 6)}, CloseButton)

    if IsRainbow then
        task.spawn(function()
            local h = 0
            while KeySystemGui.Parent do
                h = (h + 0.02) % 1
                local c = Color3.fromHSV(h, 1, 1)
                MinimizeBtn.BackgroundColor3 = c
                CloseButton.BackgroundColor3 = c
                task.wait(0.05)
            end
        end)
    end

    local LeftPanel = Create("Frame", {Size = UDim2.new(0, 300, 1, -60), Position = UDim2.new(0, 15, 0, 50), BackgroundColor3 = Color3.fromRGB(12, 12, 15), BorderSizePixel = 0, ZIndex = 2}, KeyContainer)
    Create("UICorner", {CornerRadius = UDim.new(0, 12)}, LeftPanel)
    local LeftStroke = Create("UIStroke", {Color = ThemeColor, Transparency = 0.62, Thickness = 1.1}, LeftPanel)

    if IsRainbow then
        task.spawn(function()
            local h = 0
            while KeySystemGui.Parent do
                h = (h + 0.02) % 1
                LeftStroke.Color = Color3.fromHSV(h, 1, 1)
                task.wait(0.05)
            end
        end)
    end

    local AvatarFrame = Create("Frame", {Size = UDim2.new(0, 130, 0, 130), Position = UDim2.new(0.5, -65, 0, 12), BackgroundColor3 = Color3.fromRGB(40, 20, 25), BorderSizePixel = 0, ZIndex = 2}, LeftPanel)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, AvatarFrame)
    local AvatarStroke = Create("UIStroke", {Color = ThemeColor, Thickness = 3}, AvatarFrame)
    local Headshot = Create("ImageLabel", {Size = UDim2.new(1, -6, 1, -6), Position = UDim2.new(0, 3, 0, 3), BackgroundTransparency = 1, Image = "rbxthumb://type=AvatarHeadShot&id="..Player.UserId.."&w=420&h=420", ZIndex = 2}, AvatarFrame)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, Headshot)

    if IsRainbow then
        task.spawn(function()
            local h = 0
            while KeySystemGui.Parent do
                h = (h + 0.02) % 1
                AvatarStroke.Color = Color3.fromHSV(h, 1, 1)
                task.wait(0.05)
            end
        end)
    end

    if IsChristmas then
        local HatContainer = Create("Frame", {
            Size = UDim2.new(0, 96, 0, 72),
            Position = UDim2.new(0.5, -30, -0.34, 0),
            BackgroundTransparency = 1,
            ZIndex = 7,
            Rotation = 16
        }, AvatarFrame)

        local HatCone = Create("Frame", {
            Size = UDim2.new(0, 68, 0, 44),
            Position = UDim2.new(0, 12, 0, 8),
            BackgroundColor3 = ThemeColor,
            BorderSizePixel = 0,
            ZIndex = 7
        }, HatContainer)
        Create("UICorner", {CornerRadius = UDim.new(0.65, 0)}, HatCone)

        local HatFurTrim = Create("Frame", {
            Size = UDim2.new(0, 76, 0, 14),
            Position = UDim2.new(0, 8, 0, 44),
            BackgroundColor3 = Color3.fromRGB(250, 252, 255),
            BorderSizePixel = 0,
            ZIndex = 8
        }, HatContainer)
        Create("UICorner", {CornerRadius = UDim.new(1, 0)}, HatFurTrim)

        local HatPomPom = Create("Frame", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 68, 0, 12),
            BackgroundColor3 = Color3.fromRGB(250, 252, 255),
            BorderSizePixel = 0,
            ZIndex = 8
        }, HatContainer)
        Create("UICorner", {CornerRadius = UDim.new(1, 0)}, HatPomPom)
    end

    local OnlineDot = Create("Frame", {Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -20, 1, -20), BackgroundColor3 = ThemeColor, BorderSizePixel = 0, ZIndex = 3}, AvatarFrame)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, OnlineDot)
    Create("UIStroke", {Color = PanelBg, Thickness = 3}, OnlineDot)

    Create("TextLabel", {Text = Player.DisplayName, Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0, 148), BackgroundTransparency = 1, Font = Enum.Font.GothamBlack, TextSize = 17, TextColor3 = WhiteColor, ZIndex = 2}, LeftPanel)
    local UsernameLabel = Create("TextLabel", {Text = "@" .. Player.Name, Size = UDim2.new(1, 0, 0, 18), Position = UDim2.new(0, 0, 0, 170), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = ThemeColor, ZIndex = 2}, LeftPanel)

    if IsRainbow then
        task.spawn(function()
            local h = 0
            while KeySystemGui.Parent do
                h = (h + 0.02) % 1
                local c = Color3.fromHSV(h, 1, 1)
                UsernameLabel.TextColor3 = c
                OnlineDot.BackgroundColor3 = c
                task.wait(0.05)
            end
        end)
    end

    local function CreateInfoBox(yPos, iconText, labelText, valueText, showCopy)
        local Box = Create("Frame", {Size = UDim2.new(1, -20, 0, 32), Position = UDim2.new(0, 10, 0, yPos), BackgroundColor3 = Color3.fromRGB(19, 15, 18), BorderSizePixel = 0, ZIndex = 2}, LeftPanel)
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}, Box)
        local boxStroke = Create("UIStroke", {Color = ThemeColor, Transparency = 0.68, Thickness = 1}, Box)
        local IconLabel = Create("TextLabel", {Text = iconText, Size = UDim2.new(0, 30, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = ThemeColor, ZIndex = 2}, Box)
        if IsRainbow then
            task.spawn(function()
                local h = 0
                while KeySystemGui.Parent do
                    h = (h + 0.02) % 1
                    local c = Color3.fromHSV(h, 1, 1)
                    IconLabel.TextColor3 = c
                    boxStroke.Color = c
                    task.wait(0.05)
                end
            end)
        end
        Create("TextLabel", {Text = labelText .. ": " .. valueText, Size = UDim2.new(1, showCopy ~= false and -70 or -35, 1, 0), Position = UDim2.new(0, 25, 0, 0), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Color3.fromRGB(180, 180, 180), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2}, Box)

        if showCopy ~= false then
            local CopyBtn = Create("TextButton", {Text = "COPY", Size = UDim2.new(0, 34, 0, 25), Position = UDim2.new(1, -38, 0.5, -12.5), BackgroundColor3 = Color3.fromRGB(34, 27, 31), Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = WhiteColor, BorderSizePixel = 0, ZIndex = 2}, Box)
            Create("UICorner", {CornerRadius = UDim.new(0, 6)}, CopyBtn)

            CopyBtn.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(tostring(valueText))
                    CopyBtn.Text = "OK"; CopyBtn.BackgroundColor3 = ThemeColor
                    ShowNotification(labelText .. " copied!")
                    task.wait(1)
                    CopyBtn.Text = "COPY"; CopyBtn.BackgroundColor3 = Color3.fromRGB(34, 27, 31)
                end
            end)
        end
    end

    CreateInfoBox(194, "#", "Account ID", Player.UserId, true)
    CreateInfoBox(231, "@", "Username", Player.Name, true)
    CreateInfoBox(268, "👤", "Display Name", Player.DisplayName, true)
    CreateInfoBox(305, "⚙️", "Executor", ExecutorName, false)

    local RightPanel = Create("Frame", {Size = UDim2.new(1, -335, 1, -60), Position = UDim2.new(0, 320, 0, 50), BackgroundTransparency = 1, ZIndex = 2}, KeyContainer)
    Create("TextLabel", {Text = "KEY VERIFICATION", Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Font = Enum.Font.GothamBlack, TextSize = 16, TextColor3 = WhiteColor, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2}, RightPanel)
    Create("TextLabel", {Text = "Paste your copied key into the field below", Size = UDim2.new(1, 0, 0, 15), Position = UDim2.new(0, 0, 0, 20), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Color3.fromRGB(150, 145, 151), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2}, RightPanel)

    local StatusBox = Create("Frame", {Size = UDim2.new(0, 112, 0, 28), Position = UDim2.new(1, -112, 0, 0), BackgroundColor3 = Color3.fromRGB(30, 20, 22), BorderSizePixel = 0, ZIndex = 2}, RightPanel)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, StatusBox)
    local statusStroke = Create("UIStroke", {Color = ThemeColor, Thickness = 1.15}, StatusBox)
    local StatusText = Create("TextLabel", {Text = "● IDLE", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = ThemeColor, ZIndex = 2}, StatusBox)

    if IsRainbow then
        task.spawn(function()
            local h = 0
            while KeySystemGui.Parent do
                h = (h + 0.02) % 1
                local c = Color3.fromHSV(h, 1, 1)
                statusStroke.Color = c
                if StatusText.Text == "● IDLE" then
                    StatusText.TextColor3 = c
                end
                task.wait(0.05)
            end
        end)
    end

    local InputFrame = Create("Frame", {BackgroundColor3 = Color3.fromRGB(15, 11, 14), BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 48), Size = UDim2.new(1, 0, 0, 58), ClipsDescendants = true, ZIndex = 2}, RightPanel)
    Create("UICorner", {CornerRadius = UDim.new(0, 10)}, InputFrame)
    local inputStroke = Create("UIStroke", {Color = ThemeColor, Thickness = 1.35}, InputFrame)

    if IsRainbow then
        task.spawn(function()
            local h = 0
            while KeySystemGui.Parent do
                h = (h + 0.02) % 1
                inputStroke.Color = Color3.fromHSV(h, 1, 1)
                task.wait(0.05)
            end
        end)
    end

    local KeyInput = Create("TextBox", {Font = Enum.Font.GothamBold, PlaceholderText = "Enter your key here...", PlaceholderColor3 = Color3.fromRGB(135, 132, 140), Text = "", TextColor3 = WhiteColor, TextSize = 14, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(1, -80, 1, 0), TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ZIndex = 3}, InputFrame)

    local PasteBtn = Create("TextButton", {Text = "↧", Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -70, 0.5, -15), BackgroundColor3 = Color3.fromRGB(27, 21, 25), Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = WhiteColor, BorderSizePixel = 0, ZIndex = 3}, InputFrame)
    Create("UICorner", {CornerRadius = UDim.new(0, 6)}, PasteBtn)
    local ClearBtn = Create("TextButton", {Text = "×", Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -35, 0.5, -15), BackgroundColor3 = Color3.fromRGB(27, 21, 25), Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = WhiteColor, BorderSizePixel = 0, ZIndex = 3}, InputFrame)
    Create("UICorner", {CornerRadius = UDim.new(0, 6)}, ClearBtn)

    ClearBtn.MouseButton1Click:Connect(function() KeyInput.Text = "" end)
    PasteBtn.MouseButton1Click:Connect(function() KeyInput:CaptureFocus() end)

    local VerifyBtn = Create("TextButton", {Text = "VERIFY & ENTER", Font = Enum.Font.GothamBlack, TextSize = 15, TextColor3 = WhiteColor, BackgroundColor3 = ThemeColor, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 116), Size = UDim2.new(1, 0, 0, 54), ZIndex = 2}, RightPanel)
    Create("UICorner", {CornerRadius = UDim.new(0, 10)}, VerifyBtn)
    Create("UIStroke", {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.72, Thickness = 1}, VerifyBtn)

    if IsRainbow then
        task.spawn(function()
            local h = 0
            while KeySystemGui.Parent do
                h = (h + 0.02) % 1
                VerifyBtn.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                task.wait(0.05)
            end
        end)
    end

    local function CreateSubBtn(text, iconText, xPos)
        local btn = Create("TextButton", {Text = iconText .. "  " .. text, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = WhiteColor, BackgroundColor3 = Color3.fromRGB(17, 15, 18), BorderSizePixel = 0, Position = UDim2.new(xPos, 0, 0, 184), Size = UDim2.new(0.48, 0, 0, 48), ZIndex = 2, AutoButtonColor = false}, RightPanel)
        Create("UICorner", {CornerRadius = UDim.new(0, 10)}, btn)
        local stroke = Create("UIStroke", {Color = ThemeColor, Transparency = 0.5, Thickness = 1.1}, btn)

        if IsRainbow then
            task.spawn(function()
                local h = 0
                while btn.Parent do
                    h = (h + 0.02) % 1
                    stroke.Color = Color3.fromHSV(h, 1, 1)
                    task.wait(0.05)
                end
            end)
        end

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {BackgroundColor3 = Color3.fromRGB(25, 19, 22)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {BackgroundColor3 = Color3.fromRGB(17, 15, 18)}):Play()
        end)
        return btn
    end

    local DiscordBtn = CreateSubBtn("DISCORD", "◉", 0)
    local GetKeyBtn = CreateSubBtn("GET KEY", "↗", 0.52)

    local BottomPanel = Create("Frame", {Size = UDim2.new(1, 0, 0, 75), Position = UDim2.new(0, 0, 0, 246), BackgroundColor3 = Color3.fromRGB(12, 11, 14), BorderSizePixel = 0, ZIndex = 2}, RightPanel)
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}, BottomPanel)
    local bottomStroke = Create("UIStroke", {Color = ThemeColor, Transparency = 0.58, Thickness = 1.1}, BottomPanel)

    local GameIcon = Create("ImageLabel", {Size = UDim2.new(0, 55, 0, 55), Position = UDim2.new(0, 10, 0.5, -27.5), BackgroundColor3 = Color3.fromRGB(20, 18, 21), Image = "", BorderSizePixel = 0, ZIndex = 3}, BottomPanel)
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}, GameIcon)
    local GameNameLabel = Create("TextLabel", {Text = "Loading Game...", Size = UDim2.new(1, -140, 0, 20), Position = UDim2.new(0, 75, 0, 8), BackgroundTransparency = 1, Font = Enum.Font.GothamBlack, TextSize = 13, TextColor3 = WhiteColor, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3}, BottomPanel)

    task.spawn(function()
        local success, gameName, gameIcon = pcall(function()
            local info = MarketplaceService:GetProductInfo(game.PlaceId)
            return info.Name, "rbxassetid://" .. info.IconImageAssetId
        end)
        if success then GameNameLabel.Text = "🎮 " .. gameName; GameIcon.Image = gameIcon else GameNameLabel.Text = "🎮 Unknown Game" end
    end)

    local BottomTimeLabel = Create("TextLabel", {Text = "00:00:00", Size = UDim2.new(1, -140, 0, 15), Position = UDim2.new(0, 75, 0, 28), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = ThemeColor, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3}, BottomPanel)
    task.spawn(function()
        while KeySystemGui.Parent do
            local t = os.date("*t")
            BottomTimeLabel.Text = "🕒 " .. string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
            task.wait(1)
        end
    end)

    Create("TextLabel", {Text = "🏆 Best Owner | ⚡ Best Script", Size = UDim2.new(1, -140, 0, 15), Position = UDim2.new(0, 75, 0, 45), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = ThemeColor, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3}, BottomPanel)

    local BrandLabel = Create("TextLabel", {Text = "Kryvex Hub On Top", Size = UDim2.new(0, 150, 0, 20), Position = UDim2.new(1, -160, 0.5, -10), BackgroundTransparency = 1, Font = Enum.Font.GothamBlack, TextSize = 14, TextColor3 = ThemeColor, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 3}, BottomPanel)
    if IsRainbow then
        task.spawn(function()
            local h = 0
            while KeySystemGui.Parent do
                h = (h + 0.02) % 1
                local c = Color3.fromHSV(h, 1, 1)
                bottomStroke.Color = c
                BottomTimeLabel.TextColor3 = c
                BrandLabel.TextColor3 = c
                task.wait(0.05)
            end
        end)
    end

    local MinimizedBtn = Create("ImageButton", {
        Image = MinimizedImageId, BackgroundColor3 = ThemeColor,
        Size = UDim2.new(0, 75, 0, 75), Position = UDim2.new(0, 50, 0, 50),
        BorderSizePixel = 0, Visible = false, Active = true, ScaleType = Enum.ScaleType.Crop
    }, KeySystemGui)
    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, MinimizedBtn)
    local minStroke = Create("UIStroke", {Color = ThemeColor, Thickness = 2}, MinimizedBtn)

    if IsRainbow then
        task.spawn(function()
            local h = 0
            while KeySystemGui.Parent do
                h = (h + 0.02) % 1
                local c = Color3.fromHSV(h, 1, 1)
                MinimizedBtn.BackgroundColor3 = c
                minStroke.Color = c
                task.wait(0.05)
            end
        end)
    end

    local mDragging, mDragInput, mDragStart, mStartPos, mMoved
    MinimizedBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            mDragging = true; mMoved = false; mDragStart = input.Position; mStartPos = MinimizedBtn.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then mDragging = false end end)
        end
    end)
    MinimizedBtn.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then mDragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == mDragInput and mDragging then
            local delta = input.Position - mDragStart
            if delta.Magnitude > 4 then mMoved = true end
            MinimizedBtn.Position = UDim2.new(mStartPos.X.Scale, mStartPos.X.Offset + delta.X, mStartPos.Y.Scale, mStartPos.Y.Offset + delta.Y)
        end
    end)

    local function showStatus(text, color)
        StatusBox.BackgroundColor3 = Color3.fromRGB(30, 20, 22)
        StatusText.Text = text; StatusText.TextColor3 = color or ThemeColor
        task.wait(2.5)
        StatusText.Text = "● IDLE"; StatusText.TextColor3 = ThemeColor
    end

    DiscordBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(DiscordLink); ShowNotification("Discord link copied!") end
    end)
    GetKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(DiscordLink); ShowNotification("Discord link copied!") end
    end)

    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(KeyContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)}):Play()
        task.wait(0.3); KeySystemGui:Destroy()
    end)

    MinimizeBtn.MouseButton1Click:Connect(function()
        KeyContainer.Visible = false; MinimizedBtn.Visible = true
        MinimizedBtn.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MinimizedBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 75, 0, 75)}):Play()
    end)
    MinimizedBtn.MouseButton1Click:Connect(function()
        if mMoved then return end
        TweenService:Create(MinimizedBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.3); MinimizedBtn.Visible = false; KeyContainer.Visible = true
        KeyContainer.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(KeyContainer, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = KContainerSize}):Play()
    end)

    VerifyBtn.MouseButton1Click:Connect(function()
        if isVerifying then return end
        local inputKey = KeyInput.Text
        if inputKey == "" then
            showStatus("⚠️ Empty key!", ThemeColor)
            local origInputPos = InputFrame.Position
            for i = 1, 6 do InputFrame.Position = origInputPos + UDim2.new(0, (i % 2 == 0 and 8 or -8), 0, 0); task.wait(0.04) end
            InputFrame.Position = origInputPos
            return
        end

        isVerifying = true; VerifyBtn.Text = "🔄 VERIFYING..."
        task.wait(0.8)

        if ValidateKey(inputKey, Keys) then
            showStatus("✅ SUCCESS", ThemeColor)
            VerifyBtn.BackgroundColor3 = ThemeColor; VerifyBtn.Text = "✅ SUCCESS"
            task.wait(1); KeySystemGui:Destroy(); MainScriptCallback(true)
        else
            showStatus("❌ Invalid key!", ThemeColor)
            VerifyBtn.Text = "🔓 VERIFY & ENTER"
            local origPos = KeyContainer.Position
            for i = 1, 8 do KeyContainer.Position = origPos + UDim2.new(0, (i % 2 == 0 and 12 or -12), 0, 0); task.wait(0.04) end
            KeyContainer.Position = origPos
        end
        isVerifying = false
    end)

    KeyContainer.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(KeyContainer, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = KContainerSize}):Play()
end

-- =======================================================
-- LAUNCHER
-- =======================================================
OpenThemeSelector(function()
    KeySystem:CreateKeySystem({
        Keys = {"KryvexWozzy", "KryvexOnTop", "KryvexHub"},
        MainScriptCallback = function(success)
            if success then
                OpenKryvexHubLoader()
            end
        end
    })
end)
