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


local Syniox = (function()
local a = {
    main_color = Color3.fromRGB(41, 74, 122),
    min_size = Vector2.new(400, 300),
    toggle_key = Enum.KeyCode.RightShift,
    can_resize = true
}
do
    local b = game:GetService("CoreGui"):FindFirstChild("imgui")
    if b then
        b:Destroy()
    end
end
local b = Instance.new("ScreenGui")
local c = Instance.new("Frame")
local d = Instance.new("TextLabel")
local e = Instance.new("ImageLabel")
local f = Instance.new("Frame")
local g = Instance.new("Frame")
local h = Instance.new("ImageButton")
local i = Instance.new("ImageLabel")
local j = Instance.new("ImageLabel")
local k = Instance.new("Frame")
local l = Instance.new("TextLabel")
local m = Instance.new("ImageLabel")
local n = Instance.new("ScrollingFrame")
local o = Instance.new("Frame")
local p = Instance.new("UIListLayout")
local q = Instance.new("Frame")
local r = Instance.new("Frame")
local s = Instance.new("UIListLayout")
local t = Instance.new("TextBox")
local u = Instance.new("ImageLabel")
local v = Instance.new("ImageLabel")
local w = Instance.new("TextLabel")
local x = Instance.new("ImageLabel")
local y = Instance.new("TextLabel")
local z = Instance.new("TextLabel")
local A = Instance.new("TextLabel")
local B = Instance.new("ImageLabel")
local C = Instance.new("UIListLayout")
local D = Instance.new("TextButton")
local E = Instance.new("ImageLabel")
local F = Instance.new("ImageButton")
local G = Instance.new("ScrollingFrame")
local H = Instance.new("UIListLayout")
local I = Instance.new("ImageLabel")
local J = Instance.new("TextButton")
local K = Instance.new("ImageLabel")
local L = Instance.new("ImageLabel")
local M = Instance.new("TextButton")
local N = Instance.new("ImageLabel")
local O = Instance.new("ImageLabel")
local P = Instance.new("Frame")
local Q = Instance.new("UIListLayout")
local R = Instance.new("Frame")
local S = Instance.new("UIListLayout")
local T = Instance.new("ImageLabel")
local U = Instance.new("ScrollingFrame")
local V = Instance.new("TextBox")
local W = Instance.new("TextLabel")
local X = Instance.new("TextLabel")
local Y = Instance.new("TextLabel")
local Z = Instance.new("TextLabel")
local _ = Instance.new("TextLabel")
local a0 = Instance.new("TextLabel")
local a1 = Instance.new("TextLabel")
local a2 = Instance.new("TextLabel")
local a3 = Instance.new("TextLabel")
local a4 = Instance.new("ImageLabel")
local a5 = Instance.new("ImageLabel")
local a6 = Instance.new("ImageLabel")
local a7 = Instance.new("ImageLabel")
local a8 = Instance.new("ImageLabel")
local a9 = Instance.new("Frame")
local aa = Instance.new("TextButton")
local ab = Instance.new("ImageLabel")
local ac = Instance.new("TextLabel")
local ad = Instance.new("TextButton")
local ae = Instance.new("ImageLabel")
local af = Instance.new("TextButton")
local ag = Instance.new("ImageLabel")
local ah = Instance.new("TextLabel")
local ai = Instance.new("TextButton")
local aj = Instance.new("ImageLabel")
local ak = Instance.new("Frame")
b.Name = "imgui"
b.Parent = game:GetService("CoreGui") or gethui()
c.Name = "Prefabs"
c.Parent = b
c.BackgroundColor3 = Color3.new(1, 1, 1)
c.Size = UDim2.new(0, 100, 0, 100)
c.Visible = false
d.Name = "Label"
d.Parent = c
d.BackgroundColor3 = Color3.new(1, 1, 1)
d.BackgroundTransparency = 1
d.Size = UDim2.new(0, 200, 0, 20)
d.Font = Enum.Font.Bodoni
d.Text = "Hello, world 123"
d.TextColor3 = Color3.new(1, 1, 1)
d.TextSize = 16
d.TextXAlignment = Enum.TextXAlignment.Left
e.Name = "Window"
e.Parent = c
e.Active = true
e.BackgroundColor3 = Color3.new(1, 1, 1)
e.BackgroundTransparency = 1
e.ClipsDescendants = true
e.Position = UDim2.new(0, 20, 0, 20)
e.Selectable = true
e.Size = UDim2.new(0, 200, 0, 200)
e.Image = "rbxassetid://2851926732"
e.ImageColor3 = Color3.new(0.0823529, 0.0862745, 0.0901961)
e.ScaleType = Enum.ScaleType.Slice
e.SliceCenter = Rect.new(12, 12, 12, 12)
f.Name = "Resizer"
f.Parent = e
f.Active = true
f.BackgroundColor3 = Color3.new(1, 1, 1)
f.BackgroundTransparency = 1
f.BorderSizePixel = 0
f.Position = UDim2.new(1, -20, 1, -20)
f.Size = UDim2.new(0, 20, 0, 20)
g.Name = "Bar"
g.Parent = e
g.BackgroundColor3 = Color3.new(0.160784, 0.290196, 0.478431)
g.BorderSizePixel = 0
g.Position = UDim2.new(0, 0, 0, 5)
g.Size = UDim2.new(1, 0, 0, 15)
h.Name = "Toggle"
h.Parent = g
h.BackgroundColor3 = Color3.new(1, 1, 1)
h.BackgroundTransparency = 1
h.Position = UDim2.new(0, 5, 0, -2)
h.Rotation = 0
h.Size = UDim2.new(0, 20, 0, 20)
h.ZIndex = 2
h.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId=76687702924360"
i.Name = "Base"
i.Parent = g
i.BackgroundColor3 = Color3.new(0.160784, 0.290196, 0.478431)
i.BorderSizePixel = 0
i.Position = UDim2.new(0, 0, 0.800000012, 0)
i.Size = UDim2.new(1, 0, 0, 10)
i.Image = "rbxassetid://2851926732"
i.ImageColor3 = Color3.new(0.160784, 0.290196, 0.478431)
i.ScaleType = Enum.ScaleType.Slice
i.SliceCenter = Rect.new(12, 12, 12, 12)
j.Name = "Top"
j.Parent = g
j.BackgroundColor3 = Color3.new(1, 1, 1)
j.BackgroundTransparency = 1
j.Position = UDim2.new(0, 0, 0, -5)
j.Size = UDim2.new(1, 0, 0, 10)
j.Image = "rbxassetid://2851926732"
j.ImageColor3 = Color3.new(0.160784, 0.290196, 0.478431)
j.ScaleType = Enum.ScaleType.Slice
j.SliceCenter = Rect.new(12, 12, 12, 12)
k.Name = "Tabs"
k.Parent = e
k.BackgroundColor3 = Color3.new(1, 1, 1)
k.BackgroundTransparency = 1
k.Position = UDim2.new(0, 15, 0, 60)
k.Size = UDim2.new(1, -30, 1, -60)
k.ClipsDescendants = true
l.Name = "Title"
l.Parent = e
l.BackgroundColor3 = Color3.new(1, 1, 1)
l.BackgroundTransparency = 1
l.Position = UDim2.new(0, 30, 0, 3)
l.Size = UDim2.new(0, 200, 0, 20)
l.Font = Enum.Font.Bodoni
l.Text = "Gamer Time"
l.TextColor3 = Color3.new(1, 1, 1)
l.TextSize = 16
l.TextXAlignment = Enum.TextXAlignment.Left
m.Name = "TabSelection"
m.Parent = e
m.BackgroundColor3 = Color3.new(1, 1, 1)
m.BackgroundTransparency = 1
m.Position = UDim2.new(0, 15, 0, 30)
m.Size = UDim2.new(1, -30, 0, 25)
m.Visible = false
m.Image = "rbxassetid://2851929490"
m.ImageColor3 = Color3.new(0.145098, 0.14902, 0.156863)
m.ScaleType = Enum.ScaleType.Slice
m.SliceCenter = Rect.new(4, 4, 4, 4)
n.Name = "TabScrolling"
n.Parent = m
n.BackgroundTransparency = 1
n.BorderSizePixel = 0
n.Size = UDim2.new(1, 0, 1, 0)
n.CanvasSize = UDim2.new(0, 0, 1, 0)
n.ScrollBarThickness = 0
n.ScrollingDirection = Enum.ScrollingDirection.X
o.Name = "TabButtons"
o.Parent = n
o.BackgroundColor3 = Color3.new(1, 1, 1)
o.BackgroundTransparency = 1
o.Size = UDim2.new(0, 0, 1, 0)
o.ClipsDescendants = true
p.Parent = o
p.FillDirection = Enum.FillDirection.Horizontal
p.SortOrder = Enum.SortOrder.LayoutOrder
p.Padding = UDim.new(0, 2)
q.Parent = m
q.BackgroundColor3 = Color3.new(0.12549, 0.227451, 0.372549)
q.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
q.BorderSizePixel = 0
q.Position = UDim2.new(0, 0, 1, 0)
q.Size = UDim2.new(1, 0, 0, 2)
r.Name = "Tab"
r.Parent = c
r.BackgroundColor3 = Color3.new(1, 1, 1)
r.BackgroundTransparency = 1
r.Size = UDim2.new(1, 0, 1, 0)
r.Visible = false
s.Parent = r
s.SortOrder = Enum.SortOrder.LayoutOrder
s.Padding = UDim.new(0, 5)
t.Parent = c
t.BackgroundColor3 = Color3.new(1, 1, 1)
t.BackgroundTransparency = 1
t.BorderSizePixel = 0
t.Size = UDim2.new(1, 0, 0, 20)
t.ZIndex = 2
t.Font = Enum.Font.Bodoni
t.PlaceholderColor3 = Color3.new(0.698039, 0.698039, 0.698039)
t.PlaceholderText = "Input Text"
t.Text = ""
t.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
t.TextSize = 14
u.Name = "TextBox_Roundify_4px"
u.Parent = t
u.BackgroundColor3 = Color3.new(1, 1, 1)
u.BackgroundTransparency = 1
u.Size = UDim2.new(1, 0, 1, 0)
u.Image = "rbxassetid://2851929490"
u.ImageColor3 = Color3.new(0.203922, 0.207843, 0.219608)
u.ScaleType = Enum.ScaleType.Slice
u.SliceCenter = Rect.new(4, 4, 4, 4)
v.Name = "Slider"
v.Parent = c
v.BackgroundColor3 = Color3.new(1, 1, 1)
v.BackgroundTransparency = 1
v.Position = UDim2.new(0, 0, 0.178571433, 0)
v.Size = UDim2.new(1, 0, 0, 20)
v.Image = "rbxassetid://2851929490"
v.ImageColor3 = Color3.new(0.145098, 0.14902, 0.156863)
v.ScaleType = Enum.ScaleType.Slice
v.SliceCenter = Rect.new(4, 4, 4, 4)
w.Name = "Title"
w.Parent = v
w.BackgroundColor3 = Color3.new(1, 1, 1)
w.BackgroundTransparency = 1
w.Position = UDim2.new(0.5, 0, 0.5, -10)
w.Size = UDim2.new(0, 0, 0, 20)
w.ZIndex = 2
w.Font = Enum.Font.Bodoni
w.Text = "Slider"
w.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
w.TextSize = 14
x.Name = "Indicator"
x.Parent = v
x.BackgroundColor3 = Color3.new(1, 1, 1)
x.BackgroundTransparency = 1
x.Size = UDim2.new(0, 0, 0, 20)
x.Image = "rbxassetid://2851929490"
x.ImageColor3 = Color3.new(0.254902, 0.262745, 0.278431)
x.ScaleType = Enum.ScaleType.Slice
x.SliceCenter = Rect.new(4, 4, 4, 4)
y.Name = "Value"
y.Parent = v
y.BackgroundColor3 = Color3.new(1, 1, 1)
y.BackgroundTransparency = 1
y.Position = UDim2.new(1, -55, 0.5, -10)
y.Size = UDim2.new(0, 50, 0, 20)
y.Font = Enum.Font.Bodoni
y.Text = "0%"
y.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
y.TextSize = 14
z.Parent = v
z.BackgroundColor3 = Color3.new(1, 1, 1)
z.BackgroundTransparency = 1
z.Position = UDim2.new(1, -20, -0.75, 0)
z.Size = UDim2.new(0, 26, 0, 50)
z.Font = Enum.Font.Bodoni
z.Text = "]"
z.TextColor3 = Color3.new(0.627451, 0.627451, 0.627451)
z.TextSize = 14
A.Parent = v
A.BackgroundColor3 = Color3.new(1, 1, 1)
A.BackgroundTransparency = 1
A.Position = UDim2.new(1, -65, -0.75, 0)
A.Size = UDim2.new(0, 26, 0, 50)
A.Font = Enum.Font.Bodoni
A.Text = "["
A.TextColor3 = Color3.new(0.627451, 0.627451, 0.627451)
A.TextSize = 14
B.Name = "Circle"
B.Parent = c
B.BackgroundColor3 = Color3.new(1, 1, 1)
B.BackgroundTransparency = 1
B.Image = "rbxassetid://266543268"
B.ImageTransparency = 0.5
C.Parent = c
C.FillDirection = Enum.FillDirection.Horizontal
C.SortOrder = Enum.SortOrder.LayoutOrder
C.Padding = UDim.new(0, 20)
D.Name = "Dropdown"
D.Parent = c
D.BackgroundColor3 = Color3.new(1, 1, 1)
D.BackgroundTransparency = 1
D.BorderSizePixel = 0
D.Position = UDim2.new(-0.055555556, 0, 0.0833333284, 0)
D.Size = UDim2.new(0, 200, 0, 20)
D.ZIndex = 2
D.Font = Enum.Font.Bodoni
D.Text = "      Dropdown"
D.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
D.TextSize = 14
D.TextXAlignment = Enum.TextXAlignment.Left
E.Name = "Indicator"
E.Parent = D
E.BackgroundColor3 = Color3.new(1, 1, 1)
E.BackgroundTransparency = 1
E.Position = UDim2.new(0.899999976, -10, 0.100000001, 0)
E.Rotation = -90
E.Size = UDim2.new(0, 15, 0, 15)
E.ZIndex = 2
E.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId=4744658743"
F.Name = "Box"
F.Parent = D
F.BackgroundColor3 = Color3.new(1, 1, 1)
F.BackgroundTransparency = 1
F.Position = UDim2.new(0, 0, 0, 25)
F.Size = UDim2.new(1, 0, 0, 150)
F.ZIndex = 3
F.Image = "rbxassetid://2851929490"
F.ImageColor3 = Color3.new(0.129412, 0.133333, 0.141176)
F.ScaleType = Enum.ScaleType.Slice
F.SliceCenter = Rect.new(4, 4, 4, 4)
G.Name = "Objects"
G.Parent = F
G.BackgroundColor3 = Color3.new(1, 1, 1)
G.BackgroundTransparency = 1
G.BorderSizePixel = 0
G.Size = UDim2.new(1, 0, 1, 0)
G.ZIndex = 3
G.CanvasSize = UDim2.new(0, 0, 0, 0)
G.ScrollBarThickness = 4
G.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
H.Parent = G
H.SortOrder = Enum.SortOrder.LayoutOrder
I.Name = "TextButton_Roundify_4px"
I.Parent = D
I.BackgroundColor3 = Color3.new(1, 1, 1)
I.BackgroundTransparency = 1
I.Size = UDim2.new(1, 0, 1, 0)
I.Image = "rbxassetid://2851929490"
I.ImageColor3 = Color3.new(0.203922, 0.207843, 0.219608)
I.ScaleType = Enum.ScaleType.Slice
I.SliceCenter = Rect.new(4, 4, 4, 4)
J.Name = "TabButton"
J.Parent = c
J.BackgroundColor3 = Color3.new(0.160784, 0.290196, 0.478431)
J.BackgroundTransparency = 1
J.BorderSizePixel = 0
J.Position = UDim2.new(0.185185179, 0, 0, 0)
J.Size = UDim2.new(0, 71, 0, 20)
J.ZIndex = 2
J.Font = Enum.Font.Bodoni
J.Text = "Test tab"
J.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
J.TextSize = 14
K.Name = "TextButton_Roundify_4px"
K.Parent = J
K.BackgroundColor3 = Color3.new(1, 1, 1)
K.BackgroundTransparency = 1
K.Size = UDim2.new(1, 0, 1, 0)
K.Image = "rbxassetid://2851929490"
K.ImageColor3 = Color3.new(0.203922, 0.207843, 0.219608)
K.ScaleType = Enum.ScaleType.Slice
K.SliceCenter = Rect.new(4, 4, 4, 4)
L.Name = "Folder"
L.Parent = c
L.BackgroundColor3 = Color3.new(1, 1, 1)
L.BackgroundTransparency = 1
L.Position = UDim2.new(0, 0, 0, 50)
L.Size = UDim2.new(1, 0, 0, 20)
L.Image = "rbxassetid://2851929490"
L.ImageColor3 = Color3.new(0.0823529, 0.0862745, 0.0901961)
L.ScaleType = Enum.ScaleType.Slice
L.SliceCenter = Rect.new(4, 4, 4, 4)
M.Name = "Button"
M.Parent = L
M.BackgroundColor3 = Color3.new(0.160784, 0.290196, 0.478431)
M.BackgroundTransparency = 1
M.BorderSizePixel = 0
M.Size = UDim2.new(1, 0, 0, 20)
M.ZIndex = 2
M.Font = Enum.Font.Bodoni
M.Text = "      Folder"
M.TextColor3 = Color3.new(1, 1, 1)
M.TextSize = 14
M.TextXAlignment = Enum.TextXAlignment.Left
N.Name = "TextButton_Roundify_4px"
N.Parent = M
N.BackgroundColor3 = Color3.new(1, 1, 1)
N.BackgroundTransparency = 1
N.Size = UDim2.new(1, 0, 1, 0)
N.Image = "rbxassetid://2851929490"
N.ImageColor3 = Color3.new(0.160784, 0.290196, 0.478431)
N.ScaleType = Enum.ScaleType.Slice
N.SliceCenter = Rect.new(4, 4, 4, 4)
O.Name = "Toggle"
O.Parent = M
O.BackgroundColor3 = Color3.new(1, 1, 1)
O.BackgroundTransparency = 1
O.Position = UDim2.new(0, 5, 0, 0)
O.Size = UDim2.new(0, 20, 0, 20)
O.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId=4731371541"
P.Name = "Objects"
P.Parent = L
P.BackgroundColor3 = Color3.new(1, 1, 1)
P.BackgroundTransparency = 1
P.Position = UDim2.new(0, 10, 0, 25)
P.Size = UDim2.new(1, -10, 1, -25)
P.Visible = false
Q.Parent = P
Q.SortOrder = Enum.SortOrder.LayoutOrder
Q.Padding = UDim.new(0, 5)
R.Name = "HorizontalAlignment"
R.Parent = c
R.BackgroundColor3 = Color3.new(1, 1, 1)
R.BackgroundTransparency = 1
R.Size = UDim2.new(1, 0, 0, 20)
S.Parent = R
S.FillDirection = Enum.FillDirection.Horizontal
S.SortOrder = Enum.SortOrder.LayoutOrder
S.Padding = UDim.new(0, 5)
T.Name = "Console"
T.Parent = c
T.BackgroundColor3 = Color3.new(1, 1, 1)
T.BackgroundTransparency = 1
T.Size = UDim2.new(1, 0, 0, 200)
T.Image = "rbxassetid://2851928141"
T.ImageColor3 = Color3.new(0.129412, 0.133333, 0.141176)
T.ScaleType = Enum.ScaleType.Slice
T.SliceCenter = Rect.new(8, 8, 8, 8)
U.Parent = T
U.BackgroundColor3 = Color3.new(1, 1, 1)
U.BackgroundTransparency = 1
U.BorderSizePixel = 0
U.Size = UDim2.new(1, 0, 1, 1)
U.CanvasSize = UDim2.new(0, 0, 0, 0)
U.ScrollBarThickness = 4
V.Name = "Source"
V.Parent = U
V.BackgroundColor3 = Color3.new(1, 1, 1)
V.BackgroundTransparency = 1
V.Position = UDim2.new(0, 40, 0, 0)
V.Size = UDim2.new(1, -40, 0, 10000)
V.ZIndex = 3
V.ClearTextOnFocus = false
V.Font = Enum.Font.Code
V.MultiLine = true
V.PlaceholderColor3 = Color3.new(0.8, 0.8, 0.8)
V.Text = ""
V.TextColor3 = Color3.new(1, 1, 1)
V.TextSize = 15
V.TextStrokeColor3 = Color3.new(1, 1, 1)
V.TextWrapped = true
V.TextXAlignment = Enum.TextXAlignment.Left
V.TextYAlignment = Enum.TextYAlignment.Top
W.Name = "Comments"
W.Parent = V
W.BackgroundColor3 = Color3.new(1, 1, 1)
W.BackgroundTransparency = 1
W.Size = UDim2.new(1, 0, 1, 0)
W.ZIndex = 5
W.Font = Enum.Font.Code
W.Text = ""
W.TextColor3 = Color3.new(0.231373, 0.784314, 0.231373)
W.TextSize = 15
W.TextXAlignment = Enum.TextXAlignment.Left
W.TextYAlignment = Enum.TextYAlignment.Top
X.Name = "Globals"
X.Parent = V
X.BackgroundColor3 = Color3.new(1, 1, 1)
X.BackgroundTransparency = 1
X.Size = UDim2.new(1, 0, 1, 0)
X.ZIndex = 5
X.Font = Enum.Font.Code
X.Text = ""
X.TextColor3 = Color3.new(0.517647, 0.839216, 0.968628)
X.TextSize = 15
X.TextXAlignment = Enum.TextXAlignment.Left
X.TextYAlignment = Enum.TextYAlignment.Top
Y.Name = "Keywords"
Y.Parent = V
Y.BackgroundColor3 = Color3.new(1, 1, 1)
Y.BackgroundTransparency = 1
Y.Size = UDim2.new(1, 0, 1, 0)
Y.ZIndex = 5
Y.Font = Enum.Font.Code
Y.Text = ""
Y.TextColor3 = Color3.new(0.972549, 0.427451, 0.486275)
Y.TextSize = 15
Y.TextXAlignment = Enum.TextXAlignment.Left
Y.TextYAlignment = Enum.TextYAlignment.Top
Z.Name = "RemoteHighlight"
Z.Parent = V
Z.BackgroundColor3 = Color3.new(1, 1, 1)
Z.BackgroundTransparency = 1
Z.Size = UDim2.new(1, 0, 1, 0)
Z.ZIndex = 5
Z.Font = Enum.Font.Code
Z.Text = ""
Z.TextColor3 = Color3.new(0, 0.568627, 1)
Z.TextSize = 15
Z.TextXAlignment = Enum.TextXAlignment.Left
Z.TextYAlignment = Enum.TextYAlignment.Top
_.Name = "Strings"
_.Parent = V
_.BackgroundColor3 = Color3.new(1, 1, 1)
_.BackgroundTransparency = 1
_.Size = UDim2.new(1, 0, 1, 0)
_.ZIndex = 5
_.Font = Enum.Font.Code
_.Text = ""
_.TextColor3 = Color3.new(0.678431, 0.945098, 0.584314)
_.TextSize = 15
_.TextXAlignment = Enum.TextXAlignment.Left
_.TextYAlignment = Enum.TextYAlignment.Top
a0.Name = "Tokens"
a0.Parent = V
a0.BackgroundColor3 = Color3.new(1, 1, 1)
a0.BackgroundTransparency = 1
a0.Size = UDim2.new(1, 0, 1, 0)
a0.ZIndex = 5
a0.Font = Enum.Font.Code
a0.Text = ""
a0.TextColor3 = Color3.new(1, 1, 1)
a0.TextSize = 15
a0.TextXAlignment = Enum.TextXAlignment.Left
a0.TextYAlignment = Enum.TextYAlignment.Top
a1.Name = "Numbers"
a1.Parent = V
a1.BackgroundColor3 = Color3.new(1, 1, 1)
a1.BackgroundTransparency = 1
a1.Size = UDim2.new(1, 0, 1, 0)
a1.ZIndex = 4
a1.Font = Enum.Font.Code
a1.Text = ""
a1.TextColor3 = Color3.new(1, 0.776471, 0)
a1.TextSize = 15
a1.TextXAlignment = Enum.TextXAlignment.Left
a1.TextYAlignment = Enum.TextYAlignment.Top
a2.Name = "Info"
a2.Parent = V
a2.BackgroundColor3 = Color3.new(1, 1, 1)
a2.BackgroundTransparency = 1
a2.Size = UDim2.new(1, 0, 1, 0)
a2.ZIndex = 5
a2.Font = Enum.Font.Code
a2.Text = ""
a2.TextColor3 = Color3.new(0, 0.635294, 1)
a2.TextSize = 15
a2.TextXAlignment = Enum.TextXAlignment.Left
a2.TextYAlignment = Enum.TextYAlignment.Top
a3.Name = "Lines"
a3.Parent = U
a3.BackgroundColor3 = Color3.new(1, 1, 1)
a3.BackgroundTransparency = 1
a3.BorderSizePixel = 0
a3.Size = UDim2.new(0, 40, 0, 10000)
a3.ZIndex = 4
a3.Font = Enum.Font.Code
a3.Text = "1\n"
a3.TextColor3 = Color3.new(1, 1, 1)
a3.TextSize = 15
a3.TextWrapped = true
a3.TextYAlignment = Enum.TextYAlignment.Top
a4.Name = "ColorPicker"
a4.Parent = c
a4.BackgroundColor3 = Color3.new(1, 1, 1)
a4.BackgroundTransparency = 1
a4.Size = UDim2.new(0, 180, 0, 110)
a4.Image = "rbxassetid://2851929490"
a4.ImageColor3 = Color3.new(0.203922, 0.207843, 0.219608)
a4.ScaleType = Enum.ScaleType.Slice
a4.SliceCenter = Rect.new(4, 4, 4, 4)
a5.Name = "Palette"
a5.Parent = a4
a5.BackgroundColor3 = Color3.new(1, 1, 1)
a5.BackgroundTransparency = 1
a5.Position = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
a5.Size = UDim2.new(0, 100, 0, 100)
a5.Image = "rbxassetid://698052001"
a5.ScaleType = Enum.ScaleType.Slice
a5.SliceCenter = Rect.new(4, 4, 4, 4)
a6.Name = "Indicator"
a6.Parent = a5
a6.BackgroundColor3 = Color3.new(1, 1, 1)
a6.BackgroundTransparency = 1
a6.Size = UDim2.new(0, 5, 0, 5)
a6.ZIndex = 2
a6.Image = "rbxassetid://2851926732"
a6.ImageColor3 = Color3.new(0, 0, 0)
a6.ScaleType = Enum.ScaleType.Slice
a6.SliceCenter = Rect.new(12, 12, 12, 12)
a7.Name = "Sample"
a7.Parent = a4
a7.BackgroundColor3 = Color3.new(1, 1, 1)
a7.BackgroundTransparency = 1
a7.Position = UDim2.new(0.800000012, 0, 0.0500000007, 0)
a7.Size = UDim2.new(0, 25, 0, 25)
a7.Image = "rbxassetid://2851929490"
a7.ScaleType = Enum.ScaleType.Slice
a7.SliceCenter = Rect.new(4, 4, 4, 4)
a8.Name = "Saturation"
a8.Parent = a4
a8.BackgroundColor3 = Color3.new(1, 1, 1)
a8.Position = UDim2.new(0.649999976, 0, 0.0500000007, 0)
a8.Size = UDim2.new(0, 15, 0, 100)
a8.Image = "rbxassetid://3641079629"
a9.Name = "Indicator"
a9.Parent = a8
a9.BackgroundColor3 = Color3.new(1, 1, 1)
a9.BorderSizePixel = 0
a9.Size = UDim2.new(0, 20, 0, 2)
a9.ZIndex = 2
aa.Name = "Switch"
aa.Parent = c
aa.BackgroundColor3 = Color3.new(1, 1, 1)
aa.BackgroundTransparency = 1
aa.BorderSizePixel = 0
aa.Position = UDim2.new(0.229411766, 0, 0.20714286, 0)
aa.Size = UDim2.new(0, 20, 0, 20)
aa.ZIndex = 2
aa.Font = Enum.Font.SourceSans
aa.Text = ""
aa.TextColor3 = Color3.new(1, 1, 1)
aa.TextSize = 14
ab.Name = "TextButton_Roundify_4px"
ab.Parent = aa
ab.BackgroundColor3 = Color3.new(1, 1, 1)
ab.BackgroundTransparency = 1
ab.Size = UDim2.new(1, 0, 1, 0)
ab.Image = "rbxassetid://2851929490"
ab.ImageColor3 = Color3.new(0.160784, 0.290196, 0.478431)
ab.ImageTransparency = 0.5
ab.ScaleType = Enum.ScaleType.Slice
ab.SliceCenter = Rect.new(4, 4, 4, 4)
ac.Name = "Title"
ac.Parent = aa
ac.BackgroundColor3 = Color3.new(1, 1, 1)
ac.BackgroundTransparency = 1
ac.Position = UDim2.new(1.20000005, 0, 0, 0)
ac.Size = UDim2.new(0, 20, 0, 20)
ac.Font = Enum.Font.Bodoni
ac.Text = "Switch"
ac.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
ac.TextSize = 14
ac.TextXAlignment = Enum.TextXAlignment.Left
ad.Name = "Button"
ad.Parent = c
ad.BackgroundColor3 = Color3.new(0.160784, 0.290196, 0.478431)
ad.BackgroundTransparency = 1
ad.BorderSizePixel = 0
ad.Size = UDim2.new(0, 91, 0, 20)
ad.ZIndex = 2
ad.Font = Enum.Font.Bodoni
ad.TextColor3 = Color3.new(1, 1, 1)
ad.TextSize = 14
ae.Name = "TextButton_Roundify_4px"
ae.Parent = ad
ae.BackgroundColor3 = Color3.new(1, 1, 1)
ae.BackgroundTransparency = 1
ae.Size = UDim2.new(1, 0, 1, 0)
ae.Image = "rbxassetid://2851929490"
ae.ImageColor3 = Color3.new(0.160784, 0.290196, 0.478431)
ae.ScaleType = Enum.ScaleType.Slice
ae.SliceCenter = Rect.new(4, 4, 4, 4)
af.Name = "DropdownButton"
af.Parent = c
af.BackgroundColor3 = Color3.new(0.129412, 0.133333, 0.141176)
af.BorderSizePixel = 0
af.Size = UDim2.new(1, 0, 0, 20)
af.ZIndex = 3
af.Font = Enum.Font.Bodoni
af.Text = "      Button"
af.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
af.TextSize = 14
af.TextXAlignment = Enum.TextXAlignment.Left
ag.Name = "Keybind"
ag.Parent = c
ag.BackgroundColor3 = Color3.new(1, 1, 1)
ag.BackgroundTransparency = 1
ag.Size = UDim2.new(0, 200, 0, 20)
ag.Image = "rbxassetid://2851929490"
ag.ImageColor3 = Color3.new(0.203922, 0.207843, 0.219608)
ag.ScaleType = Enum.ScaleType.Slice
ag.SliceCenter = Rect.new(4, 4, 4, 4)
ah.Name = "Title"
ah.Parent = ag
ah.BackgroundColor3 = Color3.new(1, 1, 1)
ah.BackgroundTransparency = 1
ah.Size = UDim2.new(0, 0, 1, 0)
ah.Font = Enum.Font.Bodoni
ah.Text = "Keybind"
ah.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
ah.TextSize = 14
ah.TextXAlignment = Enum.TextXAlignment.Left
ai.Name = "Input"
ai.Parent = ag
ai.BackgroundColor3 = Color3.new(1, 1, 1)
ai.BackgroundTransparency = 1
ai.BorderSizePixel = 0
ai.Position = UDim2.new(1, -85, 0, 2)
ai.Size = UDim2.new(0, 80, 1, -4)
ai.ZIndex = 2
ai.Font = Enum.Font.Bodoni
ai.Text = "RShift"
ai.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
ai.TextSize = 12
ai.TextWrapped = true
aj.Name = "Input_Roundify_4px"
aj.Parent = ai
aj.BackgroundColor3 = Color3.new(1, 1, 1)
aj.BackgroundTransparency = 1
aj.Size = UDim2.new(1, 0, 1, 0)
aj.Image = "rbxassetid://2851929490"
aj.ImageColor3 = Color3.new(0.290196, 0.294118, 0.313726)
aj.ScaleType = Enum.ScaleType.Slice
aj.SliceCenter = Rect.new(4, 4, 4, 4)
ak.Name = "Windows"
ak.Parent = b
ak.BackgroundColor3 = Color3.new(1, 1, 1)
ak.BackgroundTransparency = 1
ak.Position = UDim2.new(0, 20, 0, 20)
ak.Size = UDim2.new(1, 20, 1, -20)
-- UI is parented directly to CoreGui above
local al = game:GetService("UserInputService")
local am = game:GetService("TweenService")
local an = game:GetService("RunService")
local ao = game:GetService("Players")
local ap = ao.LocalPlayer
local aq = ap:GetMouse()
local c = b:WaitForChild("Prefabs")
local ak = b:FindFirstChild("Windows")
local ar = {binding = false}
local as = {}
local function at(au)
    table.insert(as, au)
    return au
end
local function av()
    for aw, au in ipairs(as) do
        if au.Connected then
            au:Disconnect()
        end
    end
    as = {}
end
at(
    al.InputBegan:Connect(
        function(ax, ay)
            if ax.KeyCode == (typeof(a.toggle_key) == "EnumItem" and a.toggle_key or Enum.KeyCode.RightShift) then
                if b and not ar.binding then
                    b.Enabled = not b.Enabled
                end
            end
        end
    )
)
local function az(aA, aB, aC)
    aC = aC or 0.1
    if aC == 0 then
        for aD, aE in pairs(aB) do
            aA[aD] = aE
        end
        return
    end
    local aF = TweenInfo.new(aC, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local aG = am:Create(aA, aF, aB)
    aG:Play()
    return aG
end
local function aH(aI, aJ, aK)
    local aL = aI:FindFirstChild("UIGradient")
    if aL then
        aL:Destroy()
    end
    if typeof(aJ) == "Color3" then
        aJ = {aJ}
    end
    if not aJ or #aJ == 0 then
        return
    end
    if #aJ == 1 then
        if aI:IsA("ImageLabel") or aI:IsA("ImageButton") then
            aI.ImageColor3 = aJ[1]
        else
            aI.BackgroundColor3 = aJ[1]
        end
        return
    end
    local aM = Instance.new("UIGradient")
    aM.Parent = aI
    aM.Rotation = aK or 0
    local aN = {}
    if #aJ == 2 then
        aN = {ColorSequenceKeypoint.new(0, aJ[1]), ColorSequenceKeypoint.new(1, aJ[2])}
    elseif #aJ >= 3 then
        aN = {
            ColorSequenceKeypoint.new(0, aJ[1]),
            ColorSequenceKeypoint.new(0.5, aJ[2]),
            ColorSequenceKeypoint.new(1, aJ[3])
        }
    end
    aM.Color = ColorSequence.new(aN)
    if aI:IsA("ImageLabel") or aI:IsA("ImageButton") then
        aI.ImageColor3 = Color3.new(1, 1, 1)
    else
        aI.BackgroundColor3 = Color3.new(1, 1, 1)
    end
end
local function aO(aP, aQ, aR)
    aP, aQ, aR = aP / 255, aQ / 255, aR / 255
    local aS, aT = math.max(aP, aQ, aR), math.min(aP, aQ, aR)
    local aU, aV, aW = 0, 0, aS
    local aX = aS - aT
    aV = aS == 0 and 0 or aX / aS
    if aS == aT then
        aU = 0
    else
        if aS == aP then
            aU = (aQ - aR) / aX + (aQ < aR and 6 or 0)
        elseif aS == aQ then
            aU = (aR - aP) / aX + 2
        elseif aS == aR then
            aU = (aP - aQ) / aX + 4
        end
        aU = aU / 6
    end
    return aU, aV, aW
end
local function aY(aZ, aD)
    local a_, b0 =
        pcall(
        function()
            return aZ[tostring(aD)]
        end
    )
    return a_ and b0
end
local function b1(b2)
    return b2.TextBounds.X + 15
end
local function b3()
    return Vector2.new(al:GetMouseLocation().X + 1, al:GetMouseLocation().Y - 35)
end
local function b4(b5, b6, b7)
    task.spawn(
        function()
            b5.ClipsDescendants = true
            local b8 = c:FindFirstChild("Circle"):Clone()
            b8.Parent = b5
            b8.ZIndex = 1000
            local b9 = b6 - b8.AbsolutePosition.X
            local ba = b7 - b8.AbsolutePosition.Y
            b8.Position = UDim2.new(0, b9, 0, ba)
            local bb = math.max(b5.AbsoluteSize.X, b5.AbsoluteSize.Y) * 1.5
            b8:TweenSizeAndPosition(
                UDim2.new(0, bb, 0, bb),
                UDim2.new(0.5, -bb / 2, 0.5, -bb / 2),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.5,
                false
            )
            az(b8, {ImageTransparency = 1}, 0.5)
            task.wait(0.5)
            b8:Destroy()
        end
    )
end
local bc = 0
local bd = {}
local function be()
    local bf = c:FindFirstChild("UIListLayout"):Clone()
    bf.Parent = ak
    local bg = {}
    for aw, aW in ipairs(ak:GetChildren()) do
        if not aW:IsA("UIListLayout") then
            bg[aW] = aW.AbsolutePosition
        end
    end
    bf:Destroy()
    for bh, aW in pairs(bg) do
        bh.Position = UDim2.new(0, aW.X, 0, aW.Y)
    end
end
function bd:FormatWindows()
    be()
end
function bd:AddWindow(bi, bj)
    bc = bc + 1
    local bk = false
    bi = tostring(bi or "New Window")
    bj = typeof(bj) == "table" and bj or a
    bj.tween_time = bj.tween_time or 0.1
    bj.title_bar = bj.title_bar or {Color3.fromRGB(41, 74, 122)}
    if typeof(bj.title_bar) == "Color3" then
        bj.title_bar = {bj.title_bar}
    end
    bj.title_bar_transparency = bj.title_bar_transparency or 0
    bj.background = bj.background or {Color3.new(0.08, 0.09, 0.1)}
    if typeof(bj.background) == "Color3" then
        bj.background = {bj.background}
    end
    bj.background_transparency = bj.background_transparency or 0.1
    if not bj.main_color then
        bj.main_color = bj.title_bar[1]
    end
    local e = c:FindFirstChild("Window"):Clone()
    e.Parent = ak
    e:FindFirstChild("Title").Text = bi
    e.Size = UDim2.new(0, bj.min_size.X, 0, bj.min_size.Y)
    e.ZIndex = e.ZIndex + bc * 10
    do
        local g = e:FindFirstChild("Bar")
        local l = g:FindFirstChild("Title")
        local h = g:FindFirstChild("Toggle")
        local i = g:FindFirstChild("Base")
        local j = g:FindFirstChild("Top")
        local m = e:FindFirstChild("TabSelection")
        local bl = m:FindFirstChild("Frame")
        local bm = 24
        local bn = (bm - 18) / 2
        g.Size = UDim2.new(1, 0, 0, bm)
        g.Position = UDim2.new(0, 0, 0, 0)
        if i then
            i:Destroy()
        end
        if j then
            j:Destroy()
        end
        local bo = Instance.new("UICorner")
        bo.CornerRadius = UDim.new(0, 5)
        bo.Parent = g
        if h then
            h.Position = UDim2.new(0, 5, 0, bn)
        end
        if l then
            local bp = 25
            local bq = 5
            l.Position = UDim2.new(0, bp, 0, bn)
            l.Size = UDim2.new(1, -(bp + bq), 1, -bn * 2)
            l.TextXAlignment = Enum.TextXAlignment.Center
        end
        g.BackgroundTransparency = bj.title_bar_transparency
        aH(g, bj.title_bar, 0)
        if m then
            m.Size = UDim2.new(1, -30, 0, 22)
            m.Position = UDim2.new(0, 15, 0, 28)
            local br = Instance.new("UICorner")
            br.CornerRadius = UDim.new(0, 6)
            br.Parent = m
            m.ImageTransparency = 0.4
            aH(m, bj.title_bar, 45)
            local bs = m:FindFirstChild("TabScrolling")
            if bs then
                local bt = bs:FindFirstChild("TabButtons")
                if bt then
                    local bu = bt:FindFirstChild("UIListLayout")
                    if bu then
                        bu.VerticalAlignment = Enum.VerticalAlignment.Center
                        bu.Padding = UDim.new(0, 12)
                    end
                end
            end
            if bl then
                bl:Destroy()
            end
        end
        e.ImageTransparency = bj.background_transparency
        aH(e, bj.background, 45)
        local bv = e:FindFirstChild("Tabs")
        h.MouseButton1Click:Connect(
            function()
                local bw = bv.Visible
                if bw then
                    bv.Visible = false
                    az(e, {Size = UDim2.new(0, e.AbsoluteSize.X, 0, bm)}, bj.tween_time)
                else
                    bv.Visible = true
                    e.Size = UDim2.new(0, e.AbsoluteSize.X, 0, bj.min_size.Y)
                end
            end
        )
    end
    local f = e:WaitForChild("Resizer")
    local bx = {}
    e.Draggable = true
    do
        local by = aq.Icon
        local bz = false
        f.MouseEnter:Connect(
            function()
                e.Draggable = false
                if bj.can_resize then
                    by = aq.Icon
                end
                bz = true
            end
        )
        f.MouseLeave:Connect(
            function()
                bz = false
                if bj.can_resize then
                    aq.Icon = by
                end
                e.Draggable = true
            end
        )
        local bA = false
        local bB
        al.InputBegan:Connect(
            function(bC)
                if bC.UserInputType == Enum.UserInputType.MouseButton1 then
                    bA = true
                    if bz and f.Active and bj.can_resize then
                        bB =
                            an.Heartbeat:Connect(
                            function()
                                if not bA or not f.Active then
                                    if bB then
                                        bB:Disconnect()
                                        bB = nil
                                    end
                                    return
                                end
                                local bD = b3()
                                local b6 = bD.X - e.AbsolutePosition.X
                                local b7 = bD.Y - e.AbsolutePosition.Y
                                b6 = math.max(bj.min_size.X, b6)
                                b7 = math.max(bj.min_size.Y, b7)
                                e.Size = UDim2.new(0, b6, 0, b7)
                            end
                        )
                    end
                end
            end
        )
        al.InputEnded:Connect(
            function(bC)
                if bC.UserInputType == Enum.UserInputType.MouseButton1 then
                    bA = false
                    if bB then
                        bB:Disconnect()
                        bB = nil
                    end
                end
            end
        )
    end
    do
        local bE = e:FindFirstChild("Bar"):FindFirstChild("Toggle")
        local bF = true
        local bG = true
        local bH = {}
        local bI = e.AbsoluteSize.Y
        bE.MouseButton1Click:Connect(
            function()
                if not bG then
                    return
                end
                bG = false
                if bF then
                    bH = {}
                    for aw, aW in ipairs(e:FindFirstChild("Tabs"):GetChildren()) do
                        bH[aW] = aW.Visible
                        aW.Visible = false
                    end
                    f.Active = false
                    bI = e.AbsoluteSize.Y
                    az(bE, {Rotation = 0}, bj.tween_time)
                    local aG = az(e, {Size = UDim2.new(0, e.AbsoluteSize.X, 0, 26)}, bj.tween_time)
                    if bE.Parent:FindFirstChild("Base") then
                        bE.Parent:FindFirstChild("Base").Transparency = 1
                    end
                else
                    for bh, aW in pairs(bH) do
                        bh.Visible = aW
                    end
                    f.Active = true
                    az(bE, {Rotation = 0}, bj.tween_time)
                    local aG = az(e, {Size = UDim2.new(0, e.AbsoluteSize.X, 0, bI)}, bj.tween_time)
                    if bE.Parent:FindFirstChild("Base") then
                        bE.Parent:FindFirstChild("Base").Transparency = bj.title_bar_transparency
                    end
                end
                bF = not bF
                task.delay(
                    bj.tween_time,
                    function()
                        bG = true
                    end
                )
            end
        )
    end
    do
        local bJ = e:FindFirstChild("Tabs")
        local bK = e:FindFirstChild("TabSelection")
        local bL = bK:FindFirstChild("TabScrolling")
        local bM = bL:FindFirstChild("TabButtons")
        local bN = nil
        local bO = nil
        local function bP()
            local bQ = 0
            local bR = bM:FindFirstChildOfClass("UIListLayout").Padding.Offset or 0
            for aw, bS in ipairs(bM:GetChildren()) do
                if bS:IsA("TextButton") then
                    bQ = bQ + bS.AbsoluteSize.X + bR
                end
            end
            bM.Size = UDim2.new(0, bQ, 1, 0)
            if bL then
                bL.CanvasSize = UDim2.new(0, bQ, 0, 0)
            end
        end
        function bx:AddTab(bT)
            local bU = {}
            bT = tostring(bT or "New Tab")
            bK.Visible = true
            local bV = c:FindFirstChild("TabButton"):Clone()
            bV.Parent = bM
            bV.Text = bT
            bV.Size = UDim2.new(0, b1(bV) + 20, 0, 18)
            bV.ZIndex = bV.ZIndex + bc * 10
            bV.BackgroundTransparency = 1
            local bW = bV:GetChildren()[1]
            bW.ZIndex = bV.ZIndex + bc * 10
            bW.ImageTransparency = 1
            local bX = Instance.new("UICorner")
            bX.CornerRadius = UDim.new(0, 4)
            bX.Parent = bV
            bV.TextColor3 = Color3.fromRGB(200, 200, 200)
            bV.TextSize = 13
            bV.Font = Enum.Font.Bodoni
            local bY = Instance.new("UIStroke")
            bY.Color = Color3.new(0, 0, 0)
            bY.Thickness = 1.2
            bY.Transparency = 0.7
            bY.Parent = bV
            local bZ = Instance.new("Frame")
            bZ.Name = "TabOutline"
            bZ.Size = UDim2.new(1, 0, 1, 0)
            bZ.BackgroundTransparency = 1
            bZ.BorderSizePixel = 2
            bZ.BorderColor3 = bj.main_color
            bZ.ZIndex = bV.ZIndex + 10
            bZ.Visible = false
            local b_ = Instance.new("UICorner")
            b_.CornerRadius = UDim.new(0, 4)
            b_.Parent = bZ
            bZ.Parent = bV
            local c0 = c:FindFirstChild("Tab"):Clone()
            c0.Parent = bJ
            c0.ZIndex = c0.ZIndex + bc * 10
            c0.Visible = false
            c0.ClipsDescendants = false
            c0.Size = UDim2.new(1, 0, 1, 0)
            c0.BackgroundTransparency = 1
            local c1 = Instance.new("ScrollingFrame")
            c1.Name = "TabScroller"
            c1.Parent = c0
            c1.Size = UDim2.new(1, 0, 1, 0)
            c1.BackgroundTransparency = 1
            c1.BorderSizePixel = 0
            c1.ScrollBarThickness = 4
            c1.CanvasSize = UDim2.new(0, 0, 0, 0)
            c1.ZIndex = c0.ZIndex
            c1.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
            c1.ScrollBarImageTransparency = 0.4
            local bu = c0:FindFirstChildOfClass("UIListLayout")
            if bu then
                bu.Parent = c1
            end
            local function c2()
                local c3 = bu.AbsoluteContentSize.Y
                c1.CanvasSize = UDim2.new(0, 0, 0, c3 + 10)
            end
            bu:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(c2)
            c2()
            task.defer(bP)
            local function c4(b5)
                if b5 ~= bN then
                    return
                end
                local c5 = b5.AbsoluteSize
                for bh = 1, 3 do
                    task.spawn(
                        function()
                            local c6 = Instance.new("Frame")
                            c6.Name = "SimpleParticle"
                            c6.Size = UDim2.new(0, 1.5, 0, 1.5)
                            c6.AnchorPoint = Vector2.new(0.5, 0.5)
                            c6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            c6.BorderSizePixel = 0
                            c6.ZIndex = b5.ZIndex + 15
                            local bo = Instance.new("UICorner")
                            bo.CornerRadius = UDim.new(1, 0)
                            bo.Parent = c6
                            local c7 = math.random(1, 4)
                            local c8, c9 = 0, 0
                            if c7 == 1 then
                                c8 = math.random(5, c5.X - 5)
                                c9 = 1
                            elseif c7 == 2 then
                                c8 = c5.X - 1
                                c9 = math.random(5, c5.Y - 5)
                            elseif c7 == 3 then
                                c8 = math.random(5, c5.X - 5)
                                c9 = c5.Y - 1
                            else
                                c8 = 1
                                c9 = math.random(5, c5.Y - 5)
                            end
                            c6.Position = UDim2.new(0, c8, 0, c9)
                            c6.Parent = b5
                            local ca, cb = c5.X / 2, c5.Y / 2
                            local cc, cd = c8 - ca, c9 - cb
                            local ce = math.sqrt(cc * cc + cd * cd)
                            cc, cd = cc / ce, cd / ce
                            local cf = c8 + cc * 6
                            local cg = c9 + cd * 6
                            local aF = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                            local aG =
                                am:Create(c6, aF, {Position = UDim2.new(0, cf, 0, cg), BackgroundTransparency = 1})
                            aG:Play()
                            task.wait(0.5)
                            if c6 and c6.Parent then
                                c6:Destroy()
                            end
                        end
                    )
                end
            end
            local function ch()
                if bO then
                    bO:Disconnect()
                end
                bO =
                    an.Heartbeat:Connect(
                    function()
                        if bN and bN.Parent then
                            c4(bN)
                            task.wait(0.2)
                        end
                    end
                )
            end
            local function ci()
                if bk then
                    return
                end
                if bN and bN ~= bV then
                    local cj = bN:FindFirstChild("TabOutline")
                    if cj then
                        cj.Visible = false
                    end
                    bN.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
                for aw, aW in ipairs(bJ:GetChildren()) do
                    if aW:IsA("Frame") then
                        aW.Visible = false
                    end
                end
                bN = bV
                local ck = bV:FindFirstChild("TabOutline")
                if ck then
                    ck.Visible = true
                    ck.BorderColor3 = bj.main_color
                end
                bV.TextColor3 = Color3.new(1, 1, 1)
                ch()
                c0.Visible = true
            end
            bV.MouseButton1Click:Connect(ci)
            bV.MouseEnter:Connect(
                function()
                    if bV ~= bN then
                        bV.TextColor3 = Color3.fromRGB(230, 230, 230)
                    end
                end
            )
            bV.MouseLeave:Connect(
                function()
                    if bV ~= bN then
                        bV.TextColor3 = Color3.fromRGB(200, 200, 200)
                    end
                end
            )
            function bU:Show()
                ci()
            end
            bV.AncestryChanged:Connect(
                function()
                    if not bV.Parent then
                        if bN == bV then
                            bN = nil
                            if bO then
                                bO:Disconnect()
                                bO = nil
                            end
                        end
                    end
                end
            )
            if #bM:GetChildren() == 2 then
                ci()
            end
            do
                function bU:AddLabel(cl)
                    cl = tostring(cl or "New Label")
                    local cm = c:FindFirstChild("Label"):Clone()
                    local c1 = c0:FindFirstChild("TabScroller")
                    cm.Parent = c1 or c0
                    cm.Text = cl
                    cm.Size = UDim2.new(0, b1(cm), 0, 20)
                    cm.ZIndex = cm.ZIndex + bc * 10
                    return cm
                end
                function bU:AddButton(cn, co)
                    cn = tostring(cn or "New Button")
                    co = typeof(co) == "function" and co or function()
                        end
                    local b5 = c:FindFirstChild("Button"):Clone()
                    local c1 = c0:FindFirstChild("TabScroller")
                    b5.Parent = c1 or c0
                    b5.Text = cn
                    b5.Size = UDim2.new(0, b1(b5), 0, 20)
                    b5.ZIndex = b5.ZIndex + bc * 10
                    local cp = b5:GetChildren()[1]
                    cp.ZIndex = cp.ZIndex + bc * 10
                    cp.ImageTransparency = bj.title_bar_transparency or 0
                    aH(cp, bj.title_bar, 0)
                    b5.TextColor3 = Color3.new(1, 1, 1)
                    b5.MouseButton1Click:Connect(
                        function()
                            b4(b5, aq.X, aq.Y)
                            pcall(co)
                        end
                    )
                    return b5
                end
                function bU:AddSwitch(cq, co)
                    local cr = {}
                    cq = tostring(cq or "New Switch")
                    co = typeof(co) == "function" and co or function()
                        end
                    local cs = c:FindFirstChild("Switch"):Clone()
                    local c1 = c0:FindFirstChild("TabScroller")
                    cs.Parent = c1 or c0
                    cs:FindFirstChild("Title").Text = cq
                    cs:FindFirstChild("Title").ZIndex = cs:FindFirstChild("Title").ZIndex + bc * 10
                    cs.ZIndex = cs.ZIndex + bc * 10
                    local ct = cs:GetChildren()[1]
                    ct.ZIndex = ct.ZIndex + bc * 10
                    ct.ImageTransparency = bj.title_bar_transparency or 0
                    aH(ct, bj.title_bar, 0)
                    local cu = false
                    cs.MouseButton1Click:Connect(
                        function()
                            cu = not cu
                            cs.Text = cu and utf8.char(10003) or ""
                            pcall(co, cu)
                        end
                    )
                    function cr:Set(cv)
                        cu = typeof(cv) == "boolean" and cv or false
                        cs.Text = cu and utf8.char(10003) or ""
                        pcall(co, cu)
                    end
                    return cr, cs
                end
                function bU:AddTextBox(cw, co, cx)
                    cw = tostring(cw or "New TextBox")
                    co = typeof(co) == "function" and co or function()
                        end
                    cx = typeof(cx) == "table" and cx or {clear = false}
                    cx.clear = cx.clear == true
                    local cy = c:FindFirstChild("TextBox"):Clone()
                    cy.Size = UDim2.new(0.5, -5, 0, 20)
                    local c1 = c0:FindFirstChild("TabScroller")
                    cy.Parent = c1 or c0
                    cy.PlaceholderText = cw
                    cy.ZIndex = cy.ZIndex + bc * 10
                    local cz = cy:GetChildren()[1]
                    cz.ZIndex = cz.ZIndex + bc * 10
                    cz.ImageTransparency = bj.title_bar_transparency or 0
                    aH(cz, bj.title_bar, 0)
                    cy.TextColor3 = Color3.new(1, 1, 1)
                    cy.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
                    cy.FocusLost:Connect(
                        function(cA)
                            if cA and #cy.Text > 0 then
                                pcall(co, cy.Text)
                                if cx.clear then
                                    cy.Text = ""
                                end
                            end
                        end
                    )
                    return cy
                end
                function bU:AddSlider(cB, co, cC)
                    local cD = {}
                    cB = tostring(cB or "New Slider")
                    co = typeof(co) == "function" and co or function()
                        end
                    cC = typeof(cC) == "table" and cC or {}
                    cC.min = cC.min or 0
                    cC.max = cC.max or 100
                    cC.readonly = cC.readonly or false
                    local cE = c:FindFirstChild("Slider"):Clone()
                    local c1 = c0:FindFirstChild("TabScroller")
                    cE.Parent = c1 or c0
                    cE.ZIndex = cE.ZIndex + bc * 10
                    local bi = cE:FindFirstChild("Title")
                    local cF = cE:FindFirstChild("Indicator")
                    local cG = cE:FindFirstChild("Value")
                    bi.ZIndex = bi.ZIndex + bc * 10
                    cF.ZIndex = cF.ZIndex + bc * 10
                    cG.ZIndex = cG.ZIndex + bc * 10
                    bi.Text = cB
                    local bz = false
                    local cH
                    cE.MouseEnter:Connect(
                        function()
                            bz = true
                            e.Draggable = false
                        end
                    )
                    cE.MouseLeave:Connect(
                        function()
                            bz = false
                            e.Draggable = true
                        end
                    )
                    local bA = false
                    al.InputBegan:Connect(
                        function(bC)
                            if bC.UserInputType == Enum.UserInputType.MouseButton1 then
                                bA = true
                                if bz and not cC.readonly then
                                    cH =
                                        an.Heartbeat:Connect(
                                        function()
                                            if not bA or bk then
                                                if cH then
                                                    cH:Disconnect()
                                                    cH = nil
                                                end
                                                return
                                            end
                                            local bD = b3()
                                            local b6 =
                                                math.clamp((bD.X - cE.AbsolutePosition.X) / cE.AbsoluteSize.X, 0, 1)
                                            cF.Size = UDim2.new(b6, 0, 0, 20)
                                            local ap = math.floor(b6 * 100)
                                            local cI = cC.max
                                            local cJ = cC.min
                                            local cK = cI - cJ
                                            local cL = math.floor(cK / 100 * ap + cJ)
                                            cG.Text = tostring(cL)
                                            pcall(co, cL)
                                        end
                                    )
                                end
                            end
                        end
                    )
                    al.InputEnded:Connect(
                        function(bC)
                            if bC.UserInputType == Enum.UserInputType.MouseButton1 then
                                bA = false
                                if cH then
                                    cH:Disconnect()
                                    cH = nil
                                end
                            end
                        end
                    )
                    function cD:Set(cM)
                        cM = tonumber(cM) or 0
                        cM = math.clamp(cM, 0, 100) / 100
                        cF.Size = UDim2.new(cM, 0, 0, 20)
                        local ap = math.floor(cM * 100)
                        local cI = cC.max
                        local cJ = cC.min
                        local cK = cI - cJ
                        local cL = math.floor(cK / 100 * ap + cJ)
                        cG.Text = tostring(cL)
                        pcall(co, cL)
                    end
                    cD:Set(cC.min)
                    return cD, cE
                end
                function bU:AddKeybind(cN, co, cO)
                    local cP = {}
                    cN = tostring(cN or "New Keybind")
                    co = typeof(co) == "function" and co or function()
                        end
                    cO = typeof(cO) == "table" and cO or {}
                    cO.standard = cO.standard or Enum.KeyCode.RightShift
                    local cQ = c:FindFirstChild("Keybind"):Clone()
                    local ax = cQ:FindFirstChild("Input")
                    local bi = cQ:FindFirstChild("Title")
                    cQ.ZIndex = cQ.ZIndex + bc * 10
                    ax.ZIndex = ax.ZIndex + bc * 10
                    ax:GetChildren()[1].ZIndex = ax:GetChildren()[1].ZIndex + bc * 10
                    bi.ZIndex = bi.ZIndex + bc * 10
                    local c1 = c0:FindFirstChild("TabScroller")
                    cQ.Parent = c1 or c0
                    bi.Text = "  " .. cN
                    cQ.Size = UDim2.new(0, b1(bi) + 80, 0, 20)
                    local cR = {
                        RightControl = "RightCtrl",
                        LeftControl = "LeftCtrl",
                        LeftShift = "LShift",
                        RightShift = "RShift",
                        MouseButton1 = "Mouse1",
                        MouseButton2 = "Mouse2"
                    }
                    local cS = cO.standard
                    function cP:SetKeybind(ag)
                        local cT = cR[ag.Name] or ag.Name
                        ax.Text = cT
                        cS = ag
                    end
                    al.InputBegan:Connect(
                        function(cU, aR)
                            if ar.binding then
                                task.defer(
                                    function()
                                        ar.binding = false
                                    end
                                )
                                return
                            end
                            if cU.KeyCode == cS and not aR then
                                pcall(co, cS)
                            end
                        end
                    )
                    cP:SetKeybind(cO.standard)
                    ax.MouseButton1Click:Connect(
                        function()
                            if ar.binding then
                                return
                            end
                            ax.Text = "..."
                            ar.binding = true
                            local cU = al.InputBegan:Wait()
                            cP:SetKeybind(cU.KeyCode)
                        end
                    )
                    return cP, cQ
                end
                function bU:AddDropdown(cV, co)
                    local cW = {}
                    cV = tostring(cV or "New Dropdown")
                    co = typeof(co) == "function" and co or function()
                        end
                    local cX = c:FindFirstChild("Dropdown"):Clone()
                    local cY = cX:FindFirstChild("Box")
                    local cZ = cY:FindFirstChild("Objects")
                    local cF = cX:FindFirstChild("Indicator")
                    cX.ZIndex = cX.ZIndex + bc * 10
                    cY.ZIndex = cY.ZIndex + bc * 10
                    cZ.ZIndex = cZ.ZIndex + bc * 10
                    cF.ZIndex = cF.ZIndex + bc * 10
                    cX.Size = UDim2.new(0.5, -5, 0, 20)
                    local c_ = cX:GetChildren()[3]
                    c_.ZIndex = c_.ZIndex + bc * 10
                    c_.ImageTransparency = bj.title_bar_transparency or 0
                    aH(c_, bj.title_bar, 0)
                    cY.ImageTransparency = bj.background_transparency or 0.1
                    aH(cY, bj.background, 0)
                    local d0 = Instance.new("UICorner")
                    d0.CornerRadius = UDim.new(0, 6)
                    d0.Parent = cY
                    cZ.BackgroundTransparency = 1
                    cZ.Position = UDim2.new(0, 0, 0, 0)
                    cZ.Size = UDim2.new(1, 0, 1, 0)
                    local c1 = c0:FindFirstChild("TabScroller")
                    cX.Parent = c1 or c0
                    cX.Text = "      " .. cV
                    cY.Size = UDim2.new(1, 0, 0, 0)
                    cY.Position = UDim2.new(0, 0, 0, 25)
                    cX.TextColor3 = Color3.new(1, 1, 1)
                    local bF = false
                    local d1 = false
                    cX.MouseButton1Click:Connect(
                        function()
                            bF = not bF
                            local d2 = math.min((#cZ:GetChildren() - 1) * 20, 200)
                            if #cZ:GetChildren() - 1 >= 10 then
                                cZ.CanvasSize = UDim2.new(0, 0, (#cZ:GetChildren() - 1) * 0.1, 0)
                            end
                            if bF then
                                if bk then
                                    return
                                end
                                bk = true
                                local d3 = cX.AbsolutePosition.Y
                                local d4 = cX.AbsoluteSize.Y
                                local d5 = e.AbsolutePosition.Y + e.AbsoluteSize.Y
                                local d6 = d5 - (d3 + d4)
                                if d6 < d2 then
                                    d1 = true
                                    cY.Position = UDim2.new(0, 0, 0, -d2 - 5)
                                    cY.Size = UDim2.new(1, 0, 0, 0)
                                    local aF =
                                        TweenInfo.new(bj.tween_time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                                    local aG =
                                        am:Create(
                                        cY,
                                        aF,
                                        {Size = UDim2.new(1, 0, 0, d2), Position = UDim2.new(0, 0, 0, -d2 - 5)}
                                    )
                                    aG:Play()
                                    az(cF, {Rotation = -90}, bj.tween_time)
                                else
                                    d1 = false
                                    cY.Position = UDim2.new(0, 0, 0, 25)
                                    cY.Size = UDim2.new(1, 0, 0, 0)
                                    az(cY, {Size = UDim2.new(1, 0, 0, d2)}, bj.tween_time)
                                    az(cF, {Rotation = 90}, bj.tween_time)
                                end
                            else
                                bk = false
                                if d1 then
                                    local aF =
                                        TweenInfo.new(bj.tween_time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                                    local aG =
                                        am:Create(
                                        cY,
                                        aF,
                                        {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, -5)}
                                    )
                                    aG:Play()
                                    aG.Completed:Connect(
                                        function()
                                            cY.Position = UDim2.new(0, 0, 0, 25)
                                        end
                                    )
                                else
                                    az(cY, {Size = UDim2.new(1, 0, 0, 0)}, bj.tween_time)
                                end
                                az(cF, {Rotation = -90}, bj.tween_time)
                            end
                        end
                    )
                    function cW:Add(d7)
                        local d8 = {}
                        d7 = tostring(d7 or "New Object")
                        local aZ = c:FindFirstChild("DropdownButton"):Clone()
                        aZ.Parent = cZ
                        aZ.Text = "      " .. d7
                        aZ.ZIndex = aZ.ZIndex + bc * 10 + 5
                        aZ.BackgroundTransparency = 1
                        aZ.TextColor3 = Color3.new(1, 1, 1)
                        aZ.BorderSizePixel = 0
                        aZ.TextXAlignment = Enum.TextXAlignment.Left
                        local d9 = aZ:FindFirstChildOfClass("UICorner")
                        if d9 then
                            d9:Destroy()
                        end
                        local bY = Instance.new("UIStroke")
                        bY.Color = Color3.new(0, 0, 0)
                        bY.Thickness = 1
                        bY.Transparency = 0.3
                        bY.Parent = aZ
                        aZ.MouseEnter:Connect(
                            function()
                                aZ.BackgroundTransparency = 0.8
                                aZ.BackgroundColor3 = bj.main_color
                            end
                        )
                        aZ.MouseLeave:Connect(
                            function()
                                aZ.BackgroundTransparency = 1
                            end
                        )
                        if bF then
                            local d2 = math.min((#cZ:GetChildren() - 1) * 20, 200)
                            if #cZ:GetChildren() - 1 >= 10 then
                                cZ.CanvasSize = UDim2.new(0, 0, (#cZ:GetChildren() - 1) * 0.1, 0)
                            end
                            if d1 then
                                local aF = TweenInfo.new(bj.tween_time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                                local aG =
                                    am:Create(
                                    cY,
                                    aF,
                                    {Size = UDim2.new(1, 0, 0, d2), Position = UDim2.new(0, 0, 0, -d2 - 5)}
                                )
                                aG:Play()
                            else
                                az(cY, {Size = UDim2.new(1, 0, 0, d2)}, bj.tween_time)
                            end
                        end
                        aZ.MouseButton1Click:Connect(
                            function()
                                if bk then
                                    cX.Text = "      [ " .. d7 .. " ]"
                                    bk = false
                                    bF = false
                                    if d1 then
                                        local aF =
                                            TweenInfo.new(
                                            bj.tween_time,
                                            Enum.EasingStyle.Quad,
                                            Enum.EasingDirection.Out
                                        )
                                        local aG =
                                            am:Create(
                                            cY,
                                            aF,
                                            {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, -5)}
                                        )
                                        aG:Play()
                                        aG.Completed:Connect(
                                            function()
                                                cY.Position = UDim2.new(0, 0, 0, 25)
                                            end
                                        )
                                    else
                                        az(cY, {Size = UDim2.new(1, 0, 0, 0)}, bj.tween_time)
                                    end
                                    az(cF, {Rotation = -90}, bj.tween_time)
                                    pcall(co, d7)
                                end
                            end
                        )
                        function d8:Remove()
                            aZ:Destroy()
                        end
                        return aZ, d8
                    end
                    function cW:Remove(da)
                        local db = cZ:FindFirstChild(da)
                        if db then
                            db:Destroy()
                            if cW.currentSelection == da then
                                local dc = cZ:GetChildren()[1]
                                local dd = dc and dc.Text or "No Selection"
                                cW.currentSelection = dd
                                cX.Text = "        [ " .. dd .. " ]"
                                pcall(co, dd)
                            end
                        end
                    end
                    return cW, cX
                end
                function bU:AddColorPicker(co)
                    local de = {}
                    co = typeof(co) == "function" and co or function()
                        end
                    local df = c:FindFirstChild("ColorPicker"):Clone()
                    local c1 = c0:FindFirstChild("TabScroller")
                    df.Parent = c1 or c0
                    df.ZIndex = df.ZIndex + bc * 10
                    local dg = df:FindFirstChild("Palette")
                    local dh = df:FindFirstChild("Sample")
                    local di = df:FindFirstChild("Saturation")
                    dg.ZIndex = dg.ZIndex + bc * 10
                    dh.ZIndex = dh.ZIndex + bc * 10
                    di.ZIndex = di.ZIndex + bc * 10
                    local aU, aV, aW = 0, 1, 1
                    local function dj()
                        local dk = Color3.fromHSV(aU, aV, aW)
                        dh.ImageColor3 = dk
                        di.ImageColor3 = Color3.fromHSV(aU, 1, 1)
                        pcall(co, dk)
                    end
                    local dk = Color3.fromHSV(aU, aV, aW)
                    dh.ImageColor3 = dk
                    di.ImageColor3 = Color3.fromHSV(aU, 1, 1)
                    local dl, dm = false, false
                    dg.MouseEnter:Connect(
                        function()
                            e.Draggable = false
                            dl = true
                        end
                    )
                    dg.MouseLeave:Connect(
                        function()
                            e.Draggable = true
                            dl = false
                        end
                    )
                    di.MouseEnter:Connect(
                        function()
                            e.Draggable = false
                            dm = true
                        end
                    )
                    di.MouseLeave:Connect(
                        function()
                            e.Draggable = true
                            dm = false
                        end
                    )
                    local dn = dg:FindFirstChild("Indicator")
                    local dp = di:FindFirstChild("Indicator")
                    dn.ZIndex = dn.ZIndex + bc * 10
                    dp.ZIndex = dp.ZIndex + bc * 10
                    local bA = false
                    local dq
                    al.InputBegan:Connect(
                        function(bC)
                            if bC.UserInputType == Enum.UserInputType.MouseButton1 then
                                bA = true
                                dq =
                                    an.Heartbeat:Connect(
                                    function()
                                        if not bA or bk then
                                            if dq then
                                                dq:Disconnect()
                                                dq = nil
                                            end
                                            return
                                        end
                                        if dl then
                                            local bD = b3()
                                            local b6 =
                                                math.clamp((bD.X - dg.AbsolutePosition.X) / dg.AbsoluteSize.X, 0, 1)
                                            local b7 =
                                                math.clamp((bD.Y - dg.AbsolutePosition.Y) / dg.AbsoluteSize.Y, 0, 1)
                                            aU = b6
                                            aV = 1 - b7
                                            dn.Position =
                                                UDim2.new(b6, -dn.AbsoluteSize.X / 2, b7, -dn.AbsoluteSize.Y / 2)
                                            dj()
                                        elseif dm then
                                            local bD = b3()
                                            local b7 =
                                                math.clamp((bD.Y - di.AbsolutePosition.Y) / di.AbsoluteSize.Y, 0, 1)
                                            aW = 1 - b7
                                            dp.Position = UDim2.new(0, 0, b7, 0)
                                            dj()
                                        end
                                    end
                                )
                            end
                        end
                    )
                    al.InputEnded:Connect(
                        function(bC)
                            if bC.UserInputType == Enum.UserInputType.MouseButton1 then
                                bA = false
                                if dq then
                                    dq:Disconnect()
                                    dq = nil
                                end
                            end
                        end
                    )
                    function de:Set(dk)
                        dk = typeof(dk) == "Color3" and dk or Color3.new(1, 1, 1)
                        local dr, ds, dt = aO(dk.r * 255, dk.g * 255, dk.b * 255)
                        dh.ImageColor3 = dk
                        di.ImageColor3 = Color3.fromHSV(dr, 1, 1)
                        pcall(co, dk)
                    end
                    return de, df
                end
                function bU:AddHorizontalAlignment()
                    local du = {}
                    local dv = c:FindFirstChild("HorizontalAlignment"):Clone()
                    local c1 = c0:FindFirstChild("TabScroller")
                    dv.Parent = c1 or c0
                    function du:AddButton(...)
                        local dw = {bU:AddButton(...)}
                        local aZ = dw[#dw]
                        aZ.Parent = dv
                        return table.unpack(dw)
                    end
                    return du, dv
                end
                function bU:AddFolder(dx)
                    local dy = {}
                    dx = tostring(dx or "New Folder")
                    local dz = c:FindFirstChild("Folder"):Clone()
                    local b5 = dz:FindFirstChild("Button")
                    local cZ = dz:FindFirstChild("Objects")
                    local dA = b5:FindFirstChild("Toggle")
                    dz.ZIndex = dz.ZIndex + bc * 10
                    b5.ZIndex = b5.ZIndex + bc * 10
                    cZ.ZIndex = cZ.ZIndex + bc * 10
                    dA.ZIndex = dA.ZIndex + bc * 10
                    b5:GetChildren()[1].ZIndex = b5:GetChildren()[1].ZIndex + bc * 10
                    local c1 = c0:FindFirstChild("TabScroller")
                    dz.Parent = c1 or c0
                    b5.Text = "      " .. dx
                    local cp = b5:GetChildren()[1]
                    cp.ImageColor3 = bj.main_color
                    local function dB()
                        local d7 = 25
                        for aw, aW in ipairs(cZ:GetChildren()) do
                            if not aW:IsA("UIListLayout") then
                                d7 = d7 + aW.AbsoluteSize.Y + 5
                            end
                        end
                        return d7
                    end
                    local bF = false
                    local dC
                    b5.MouseButton1Click:Connect(
                        function()
                            bF = not bF
                            if bF then
                                az(dA, {Rotation = 90}, bj.tween_time)
                                cZ.Visible = true
                                if dC then
                                    dC:Disconnect()
                                end
                                dC =
                                    an.Heartbeat:Connect(
                                    function()
                                        if bF then
                                            dz.Size = UDim2.new(1, 0, 0, dB())
                                        else
                                            if dC then
                                                dC:Disconnect()
                                                dC = nil
                                            end
                                        end
                                    end
                                )
                            else
                                az(dA, {Rotation = 0}, bj.tween_time)
                                cZ.Visible = false
                                dz.Size = UDim2.new(1, 0, 0, 20)
                                if dC then
                                    dC:Disconnect()
                                    dC = nil
                                end
                            end
                        end
                    )
                    for bh, aW in pairs(bU) do
                        dy[bh] = function(...)
                            local dw = {aW(...)}
                            local aZ = dw[#dw]
                            aZ.Parent = cZ
                            return table.unpack(dw)
                        end
                    end
                    return dy, dz
                end
            end
            return bU, c0
        end
    end
    for aw, aW in ipairs(e:GetDescendants()) do
        if aY(aW, "ZIndex") then
            aW.ZIndex = aW.ZIndex + bc * 10
        end
    end
    return bx, e
end
return bd
end)()


local accent = Color3.fromRGB(210, 35, 45)
local window = Syniox:AddWindow("Kryvex Hub", {
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

tabs.rebirths.Switch = tabs.rebirths:AddSwitch("Pack Rebirth (Yes, Robux Packs)", function(state)
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
tabs.strength.maxSendRate = 462
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

tabs.strength:AddTextBox("Max reps/s: " .. tabs.strength.maxSendRate, function(inputText, value)
    value = tonumber(inputText)
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

tabs.strength:AddLabel("Recommended Speed: 462, you can always try more.")

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