-- By WozzyLaco Private Obf
local function _ssbulHoq3jr(_dzmPlGJvauSyO, _tO4XVAKlw)
    local _rl4EAAIEMMLIS = {}
    for _iQeadn7PAgc4, _vBDTL5vCw in ipairs(_tO4XVAKlw) do
        local _kwl1RMPT03 = (_vBDTL5vCw - _dzmPlGJvauSyO) % 256
        _rl4EAAIEMMLIS[_iQeadn7PAgc4] = string.char(_kwl1RMPT03)
    end
    return table.concat(_rl4EAAIEMMLIS)
end

local function _xq9cPqwm4iI(_atpVotOqTIkTo, _bvb8XoVl)
    local _rl4EAAIEMMLIS, _bvb8XoVl2 = 0, 1
    local _atpVotOqTIkTo1, _bvb8XoVl1 = math.floor(tonumber(_atpVotOqTIkTo) or 0), math.floor(tonumber(_bvb8XoVl) or 0)
    if _atpVotOqTIkTo1 < 0 then _atpVotOqTIkTo1 = (_atpVotOqTIkTo1 % 4294967296) end
    if _bvb8XoVl1 < 0 then _bvb8XoVl1 = (_bvb8XoVl1 % 4294967296) end
    for _ = 0, 31 do
        if (_atpVotOqTIkTo1 % 2) ~= (_bvb8XoVl1 % 2) then
            _rl4EAAIEMMLIS = _rl4EAAIEMMLIS + _bvb8XoVl2
        end
        _atpVotOqTIkTo1 = math.floor(_atpVotOqTIkTo1 / 2)
        _bvb8XoVl1 = math.floor(_bvb8XoVl1 / 2)
        _bvb8XoVl2 = _bvb8XoVl2 * 2
    end
    return _rl4EAAIEMMLIS
end

local function _eKh3j16eA()
    local _stbmfHl0j1L, _rl4EAAIEMMLIS = pcall(function()
        if typeof ~= nil and TweenInfo ~= nil and Faces ~= nil and Axes ~= nil and Ray ~= nil then
            local _ti = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 2, true, 0.5)
            if typeof(_ti) ~= "TweenInfo" or _ti.Time ~= 1 or _ti.RepeatCount ~= 2 then return 0 end
            if _ti.EasingStyle ~= Enum.EasingStyle.Quad or _ti.Reverses ~= true then return 0 end
            if math.abs(_ti.DelayTime - 0.5) > 1e-6 then return 0 end
            local _fc = Faces.new(Enum.NormalId.Top, Enum.NormalId.Bottom)
            if typeof(_fc) ~= "Faces" or _fc.Top ~= true or _fc.Bottom ~= true or _fc.Right ~= false then return 0 end
            local _ax = Axes.new(Enum.Axis.X)
            if typeof(_ax) ~= "Axes" or _ax.X ~= true or _ax.Y ~= false or _ax.Z ~= false then return 0 end
            local _ry = Ray.new(Vector3.new(0, 0, 0), Vector3.new(0, 5, 0))
            if typeof(_ry) ~= "Ray" or _ry.Origin ~= Vector3.new(0, 0, 0) then return 0 end
            if math.abs(_ry.Direction.Unit.Y - 1) > 1e-5 then return 0 end
            return _ti.RepeatCount * 10 + _ti.Time + _ry.Direction.Unit.Y
        end
        return 22
    end)
    if _stbmfHl0j1L and type(_rl4EAAIEMMLIS) == "number" and _rl4EAAIEMMLIS ~= 0 then
        return _rl4EAAIEMMLIS
    end
    return 22
end

local function _gE7kj8Zg()
    local _stbmfHl0j1L, _rl4EAAIEMMLIS = pcall(function()
        local _f = table.find({10, 20, 30}, 20)
        if _f ~= 2 then return 0 end
        local _m = table.move({10, 20, 30}, 1, 3, 1, {})
        if type(_m) ~= "table" or _m[1] ~= 10 or _m[3] ~= 30 then return 0 end
        local _p = table.pack(10, 20, 30)
        if _p.n ~= 3 or _p[1] ~= 10 or _p[3] ~= 30 then return 0 end
        local _mt = string.match("kryvex123obf", "%d+")
        if _mt ~= "123" then return 0 end
        local _gc = 0
        for _ in string.gmatch("aaaa", "a") do _gc = _gc + 1 end
        if _gc ~= 4 then return 0 end
        return (tonumber(_mt) or 123) + _f
    end)
    if _stbmfHl0j1L and type(_rl4EAAIEMMLIS) == "number" and _rl4EAAIEMMLIS ~= 0 then
        return _rl4EAAIEMMLIS
    end
    return 125
end

local _kv1 = _eKh3j16eA()
local _kv2 = _gE7kj8Zg()
local _kvSum = _kv1 + _kv2
local _kvXor = _xq9cPqwm4iI(_kv1, _kv2)
local _kvSig = 2724328735

if _kvSum ~= 147 or _kvXor ~= 107 or type(_kvSig) ~= "number" then
    return
end

local function _runP2lfOzVHlK0()
local MolynKeySystem1 = Instance.new((function() local _k = _xq9cPqwm4iI(132, 53) if _k >= 0 then return _ssbulHoq3jr(5, {88, 104, 119, 106, 106, 115, 76, 122, 110}) end end)())
_kw2fftMJK5hT.Name = (function() local _k = _xq9cPqwm4iI(122, 115) if _k >= 0 then return _ssbulHoq3jr(17, {94, 128, 125, 138, 127, 92, 118, 138, 100, 138, 132, 133, 118, 126}) end end)()
_kw2fftMJK5hT.ZIndexBehavior = Enum.ZIndexBehavior.Global
_kw2fftMJK5hT.ResetOnSpawn = false
_kw2fftMJK5hT.IgnoreGuiInset = true
_kw2fftMJK5hT.Parent = game.Players.LocalPlayer.PlayerGui
local Background2 = Instance.new((function() local _k = _xq9cPqwm4iI(87, 215) if _k >= 0 then return _ssbulHoq3jr(3, {73, 117, 100, 112, 104}) end end)())
_kntfnHh1f.Name = (function() local _k = _xq9cPqwm4iI(170, 208) if _k >= 0 then return _ssbulHoq3jr(14, {80, 111, 113, 121, 117, 128, 125, 131, 124, 114}) end end)()
_kntfnHh1f.Size = UDim2.new((2047 - 2046),_xq9cPqwm4iI(2795, 2795),(0 * 4 + 1),(5510 - 5510))
_kntfnHh1f.Position = UDim2.new((0 * 6 + 0),_xq9cPqwm4iI(1842, 1842),(0 * 4 + 0),(5400 - 5400))
_kntfnHh1f.AnchorPoint = Vector2.new((8398 - 8398),(0 * 2 + 0))
_kntfnHh1f.BackgroundColor3 = Color3.fromRGB((0 * 4 + 0),(7190 - 7190),(7887 - 7887))
_kntfnHh1f.BackgroundTransparency = (-5.96947877 + 6.26947877)
_kntfnHh1f.BorderSizePixel = (5758 - 5758)
_kntfnHh1f.Visible = true
_kntfnHh1f.ZIndex = _xq9cPqwm4iI(3721, 3720)
_kntfnHh1f.AutomaticSize = Enum.AutomaticSize.None
_kntfnHh1f.ClipsDescendants = false
_kntfnHh1f.LayoutOrder = _xq9cPqwm4iI(2529, 2529)
_kntfnHh1f.Parent = _kw2fftMJK5hT
local MainFrame3 = Instance.new((function() local _k = _xq9cPqwm4iI(18, 182) if _k >= 0 then return _ssbulHoq3jr(16, {86, 130, 113, 125, 117}) end end)())
_kwBMMp1.Name = (function() local _k = _xq9cPqwm4iI(182, 244) if _k >= 0 then return _ssbulHoq3jr(8, {85, 105, 113, 118, 78, 122, 105, 117, 109}) end end)()
_kwBMMp1.Size = UDim2.new((0 * 5 + 0),(210 * 2 + 0),(4768 - 4768),(193 * 3 + 1))
_kwBMMp1.Position = UDim2.new((-9.14661277 + 9.64661277),_xq9cPqwm4iI(2555, 2555),(-1.28115570 + 1.78115570),_xq9cPqwm4iI(3791, 3791))
_kwBMMp1.AnchorPoint = Vector2.new((9.94249604 - 9.44249604),(-3.17541144 + 3.67541144))
_kwBMMp1.BackgroundColor3 = Color3.fromRGB((5 * 2 + 0),_xq9cPqwm4iI(1591, 1597),(1 * 7 + 3))
_kwBMMp1.BackgroundTransparency = _xq9cPqwm4iI(1258, 1258)
_kwBMMp1.BorderSizePixel = _xq9cPqwm4iI(2162, 2162)
_kwBMMp1.Visible = true
_kwBMMp1.ZIndex = (5562 - 5561)
_kwBMMp1.AutomaticSize = Enum.AutomaticSize.None
_kwBMMp1.ClipsDescendants = false
_kwBMMp1.LayoutOrder = _xq9cPqwm4iI(169, 169)
_kwBMMp1.Parent = _kntfnHh1f
local UICorner4 = Instance.new((function() local _k = _xq9cPqwm4iI(120, 65) if _k >= 0 then return _ssbulHoq3jr(16, {101, 89, 83, 127, 130, 126, 117, 130}) end end)())
_kJYp8TE.CornerRadius = UDim.new((6054 - 6054),(3 * 4 + 3))
_kJYp8TE.Parent = _kwBMMp1
local GlowFrame5 = Instance.new((function() local _k = _xq9cPqwm4iI(78, 116) if _k >= 0 then return _ssbulHoq3jr(17, {87, 131, 114, 126, 118}) end end)())
_kd6UIU2F0.Name = (function() local _k = _xq9cPqwm4iI(244, 76) if _k >= 0 then return _ssbulHoq3jr(5, {76, 113, 116, 124, 75, 119, 102, 114, 106}) end end)()
_kd6UIU2F0.Size = UDim2.new((0 * 4 + 1),(6 * 5 + 0),_xq9cPqwm4iI(1342, 1343),(8774 - 8744))
_kd6UIU2F0.Position = UDim2.new((7342 - 7342),-(5 * 3 + 0),(6383 - 6383),-(5 * 3 + 0))
_kd6UIU2F0.AnchorPoint = Vector2.new(_xq9cPqwm4iI(3534, 3534),(0 * 7 + 0))
_kd6UIU2F0.BackgroundColor3 = Color3.fromRGB(_xq9cPqwm4iI(1142, 1161),(25 * 2 + 0),_xq9cPqwm4iI(4021, 3975))
_kd6UIU2F0.BackgroundTransparency = (8.04158030 - 7.36929230)
_kd6UIU2F0.BorderSizePixel = (8170 - 8170)
_kd6UIU2F0.Visible = true
_kd6UIU2F0.ZIndex = -_xq9cPqwm4iI(1939, 1938)
_kd6UIU2F0.AutomaticSize = Enum.AutomaticSize.None
_kd6UIU2F0.ClipsDescendants = false
_kd6UIU2F0.LayoutOrder = (8090 - 8090)
_kd6UIU2F0.Parent = _kwBMMp1
local UICorner6 = Instance.new((function() local _k = _xq9cPqwm4iI(143, 215) if _k >= 0 then return _ssbulHoq3jr(18, {103, 91, 85, 129, 132, 128, 119, 132}) end end)())
_kxm3elIBgK.CornerRadius = UDim.new((0 * 3 + 0),(3034 - 3009))
_kxm3elIBgK.Parent = _kd6UIU2F0
local Header7 = Instance.new((function() local _k = _xq9cPqwm4iI(132, 136) if _k >= 0 then return _ssbulHoq3jr(14, {84, 128, 111, 123, 115}) end end)())
_kl68jgZn0RhAu.Name = (function() local _k = _xq9cPqwm4iI(236, 232) if _k >= 0 then return _ssbulHoq3jr(5, {77, 106, 102, 105, 106, 119}) end end)()
_kl68jgZn0RhAu.Size = UDim2.new((8319 - 8318),(0 * 3 + 0),(2815 - 2815),_xq9cPqwm4iI(192, 154))
_kl68jgZn0RhAu.Position = UDim2.new((0 * 4 + 0),(0 * 7 + 0),(0 * 7 + 0),(1237 - 1237))
_kl68jgZn0RhAu.AnchorPoint = Vector2.new(_xq9cPqwm4iI(2227, 2227),(0 * 5 + 0))
_kl68jgZn0RhAu.BackgroundColor3 = Color3.fromRGB((8 * 3 + 1),(4 * 6 + 1),(8203 - 8178))
_kl68jgZn0RhAu.BackgroundTransparency = (0 * 5 + 0)
_kl68jgZn0RhAu.BorderSizePixel = _xq9cPqwm4iI(1944, 1944)
_kl68jgZn0RhAu.Visible = true
_kl68jgZn0RhAu.ZIndex = (0 * 5 + 1)
_kl68jgZn0RhAu.AutomaticSize = Enum.AutomaticSize.None
_kl68jgZn0RhAu.ClipsDescendants = false
_kl68jgZn0RhAu.LayoutOrder = _xq9cPqwm4iI(3605, 3605)
_kl68jgZn0RhAu.Parent = _kwBMMp1
local UICorner8 = Instance.new((function() local _k = _xq9cPqwm4iI(151, 170) if _k >= 0 then return _ssbulHoq3jr(7, {92, 80, 74, 118, 121, 117, 108, 121}) end end)())
_kYTNpoMBlWE3l.CornerRadius = UDim.new(_xq9cPqwm4iI(2425, 2425),(7423 - 7408))
_kYTNpoMBlWE3l.Parent = _kl68jgZn0RhAu
local Frame9 = Instance.new((function() local _k = _xq9cPqwm4iI(183, 154) if _k >= 0 then return _ssbulHoq3jr(5, {75, 119, 102, 114, 106}) end end)())
_kltDhrmcpFQS.Name = (function() local _k = _xq9cPqwm4iI(196, 149) if _k >= 0 then return _ssbulHoq3jr(7, {77, 121, 104, 116, 108}) end end)()
_kltDhrmcpFQS.Size = UDim2.new((5535 - 5534),(0 * 5 + 0),(0 * 6 + 0),_xq9cPqwm4iI(3059, 3068))
_kltDhrmcpFQS.Position = UDim2.new((2456 - 2456),(0 * 5 + 0),(0 * 2 + 1),-(7875 - 7860))
_kltDhrmcpFQS.AnchorPoint = Vector2.new((2267 - 2267),_xq9cPqwm4iI(2359, 2359))
_kltDhrmcpFQS.BackgroundColor3 = Color3.fromRGB((5 * 5 + 0),_xq9cPqwm4iI(3519, 3494),(1369 - 1344))
_kltDhrmcpFQS.BackgroundTransparency = (8970 - 8970)
_kltDhrmcpFQS.BorderSizePixel = (7418 - 7418)
_kltDhrmcpFQS.Visible = true
_kltDhrmcpFQS.ZIndex = (0 * 5 + 1)
_kltDhrmcpFQS.AutomaticSize = Enum.AutomaticSize.None
_kltDhrmcpFQS.ClipsDescendants = false
_kltDhrmcpFQS.LayoutOrder = (1170 - 1170)
_kltDhrmcpFQS.Parent = _kl68jgZn0RhAu
local LogoFrame10 = Instance.new((function() local _k = _xq9cPqwm4iI(155, 126) if _k >= 0 then return _ssbulHoq3jr(11, {81, 125, 108, 120, 112}) end end)())
_kkR1YcMP.Name = (function() local _k = _xq9cPqwm4iI(151, 23) if _k >= 0 then return _ssbulHoq3jr(8, {84, 119, 111, 119, 78, 122, 105, 117, 109}) end end)()
_kkR1YcMP.Size = UDim2.new((0 * 4 + 0),(6862 - 6792),(8134 - 8134),(11 * 6 + 4))
_kkR1YcMP.Position = UDim2.new((1530 - 1530),(2 * 7 + 1),(2.19453678 - 1.69453678),-_xq9cPqwm4iI(3184, 3155))
_kkR1YcMP.AnchorPoint = Vector2.new(_xq9cPqwm4iI(3092, 3092),(0 * 7 + 0))
_kkR1YcMP.BackgroundColor3 = Color3.fromRGB(_xq9cPqwm4iI(2509, 2509),(936 - 936),(1673 - 1673))
_kkR1YcMP.BackgroundTransparency = _xq9cPqwm4iI(433, 433)
_kkR1YcMP.BorderSizePixel = (0 * 2 + 0)
_kkR1YcMP.Visible = true
_kkR1YcMP.ZIndex = _xq9cPqwm4iI(1907, 1906)
_kkR1YcMP.AutomaticSize = Enum.AutomaticSize.None
_kkR1YcMP.ClipsDescendants = false
_kkR1YcMP.LayoutOrder = (0 * 6 + 0)
_kkR1YcMP.Parent = _kl68jgZn0RhAu
local UICorner11 = Instance.new((function() local _k = _xq9cPqwm4iI(249, 114) if _k >= 0 then return _ssbulHoq3jr(11, {96, 84, 78, 122, 125, 121, 112, 125}) end end)())
_kRCrgiaor.CornerRadius = UDim.new((7665 - 7665),_xq9cPqwm4iI(2451, 2463))
_kRCrgiaor.Parent = _kkR1YcMP
local LogoImage12 = Instance.new((function() local _k = _xq9cPqwm4iI(20, 56) if _k >= 0 then return _ssbulHoq3jr(19, {92, 128, 116, 122, 120, 95, 116, 117, 120, 127}) end end)())
_kgzObHS.Name = (function() local _k = _xq9cPqwm4iI(81, 46) if _k >= 0 then return _ssbulHoq3jr(14, {90, 125, 117, 125, 87, 123, 111, 117, 115}) end end)()
_kgzObHS.Size = UDim2.new(_xq9cPqwm4iI(58, 59),-(2470 - 2460),_xq9cPqwm4iI(2177, 2176),-_xq9cPqwm4iI(4032, 4042))
_kgzObHS.Position = UDim2.new((0 * 6 + 0),(2 * 2 + 1),(8451 - 8451),(2907 - 2902))
_kgzObHS.AnchorPoint = Vector2.new((3435 - 3435),(0 * 3 + 0))
_kgzObHS.BackgroundColor3 = Color3.fromRGB((1353 - 1190),(40 * 4 + 2),(33 * 5 + 0))
_kgzObHS.BackgroundTransparency = (0 * 6 + 1)
_kgzObHS.BorderSizePixel = (2303 - 2302)
_kgzObHS.Image = (function() local _k = _xq9cPqwm4iI(106, 227) if _k >= 0 then return _ssbulHoq3jr(14, {128, 112, 134, 111, 129, 129, 115, 130, 119, 114, 72, 61, 61, 63, 62, 71, 66, 64, 63, 63, 71, 65, 64, 65, 64, 62, 65, 66}) end end)()
_kgzObHS.ImageColor3 = Color3.fromRGB((51 * 5 + 0),_xq9cPqwm4iI(2719, 2656),_xq9cPqwm4iI(1583, 1744))
_kgzObHS.ImageTransparency = _xq9cPqwm4iI(4054, 4054)
_kgzObHS.ScaleType = Enum.ScaleType.Fit
_kgzObHS.SliceCenter = Rect.new(_xq9cPqwm4iI(2377, 2377),_xq9cPqwm4iI(3792, 3792),(1280 - 1280),(739 - 739))
_kgzObHS.Visible = true
_kgzObHS.ZIndex = (5338 - 5337)
_kgzObHS.Parent = _kkR1YcMP
local Title13 = Instance.new((function() local _k = _xq9cPqwm4iI(246, 217) if _k >= 0 then return _ssbulHoq3jr(9, {93, 110, 129, 125, 85, 106, 107, 110, 117}) end end)())
_kZV8FaU.Name = (function() local _k = _xq9cPqwm4iI(60, 162) if _k >= 0 then return _ssbulHoq3jr(15, {99, 120, 131, 123, 116}) end end)()
_kZV8FaU.Size = UDim2.new((4596 - 4596),(45 * 7 + 5),(7569 - 7569),(2696 - 2651))
_kZV8FaU.Position = UDim2.new((0 * 7 + 0),(25 * 4 + 0),_xq9cPqwm4iI(102, 102),(1 * 7 + 3))
_kZV8FaU.AnchorPoint = Vector2.new(_xq9cPqwm4iI(2686, 2686),(0 * 4 + 0))
_kZV8FaU.BackgroundColor3 = Color3.fromRGB((27 * 6 + 1),(27 * 6 + 0),(23 * 7 + 4))
_kZV8FaU.BackgroundTransparency = _xq9cPqwm4iI(4056, 4057)
_kZV8FaU.BorderSizePixel = (0 * 6 + 1)
_kZV8FaU.Visible = true
_kZV8FaU.AutomaticSize = Enum.AutomaticSize.None
_kZV8FaU.ClipsDescendants = false
_kZV8FaU.LayoutOrder = (5456 - 5456)
_kZV8FaU.Active = false
_kZV8FaU.Selectable = false
_kZV8FaU.SizeConstraint = Enum.SizeConstraint.RelativeXY
_kZV8FaU.ZIndex = _xq9cPqwm4iI(1175, 1174)
_kZV8FaU.Rotation = (0 * 3 + 0)
_kZV8FaU.Transparency = (9919 - 9918)
_kZV8FaU.Text = (function() local _k = _xq9cPqwm4iI(132, 129) if _k >= 0 then return _ssbulHoq3jr(10, {87, 89, 86, 99, 88, 42, 78, 79, 96, 79, 86, 89, 90, 87, 79, 88, 94}) end end)()
_kZV8FaU.TextColor3 = Color3.fromRGB((42 * 6 + 3),(36 * 7 + 3),(931 - 676))
_kZV8FaU.TextSize = (4831 - 4809)
_kZV8FaU.Font = Enum.Font.GothamBold
_kZV8FaU.TextScaled = false
_kZV8FaU.TextWrapped = false
_kZV8FaU.RichText = false
_kZV8FaU.LineHeight = (0 * 4 + 1)
_kZV8FaU.MaxVisibleGraphemes = -_xq9cPqwm4iI(541, 540)
_kZV8FaU.TextTransparency = (9038 - 9038)
_kZV8FaU.TextStrokeColor3 = Color3.fromRGB((1994 - 1994),_xq9cPqwm4iI(342, 342),(0 * 2 + 0))
_kZV8FaU.TextStrokeTransparency = (0 * 6 + 1)
_kZV8FaU.TextTruncate = Enum.TextTruncate.None
_kZV8FaU.ZIndex = (0 * 2 + 1)
_kZV8FaU.TextXAlignment = Enum.TextXAlignment.Left
_kZV8FaU.TextYAlignment = Enum.TextYAlignment.Center
_kZV8FaU.Parent = _kl68jgZn0RhAu
local Subtitle14 = Instance.new((function() local _k = _xq9cPqwm4iI(29, 199) if _k >= 0 then return _ssbulHoq3jr(14, {98, 115, 134, 130, 90, 111, 112, 115, 122}) end end)())
_kReHB2loJ5Hh4.Name = (function() local _k = _xq9cPqwm4iI(136, 162) if _k >= 0 then return _ssbulHoq3jr(5, {88, 122, 103, 121, 110, 121, 113, 106}) end end)()
_kReHB2loJ5Hh4.Size = UDim2.new(_xq9cPqwm4iI(3920, 3920),_xq9cPqwm4iI(1636, 1828),_xq9cPqwm4iI(2575, 2575),(8 * 3 + 1))
_kReHB2loJ5Hh4.Position = UDim2.new(_xq9cPqwm4iI(3976, 3976),(50 * 2 + 0),(3498 - 3498),(10 * 5 + 0))
_kReHB2loJ5Hh4.AnchorPoint = Vector2.new(_xq9cPqwm4iI(3229, 3229),(0 * 7 + 0))
_kReHB2loJ5Hh4.BackgroundColor3 = Color3.fromRGB((23 * 7 + 2),_xq9cPqwm4iI(2993, 2835),(27 * 6 + 3))
_kReHB2loJ5Hh4.BackgroundTransparency = (1426 - 1425)
_kReHB2loJ5Hh4.BorderSizePixel = _xq9cPqwm4iI(3734, 3735)
_kReHB2loJ5Hh4.Visible = true
_kReHB2loJ5Hh4.AutomaticSize = Enum.AutomaticSize.None
_kReHB2loJ5Hh4.ClipsDescendants = false
_kReHB2loJ5Hh4.LayoutOrder = (7976 - 7976)
_kReHB2loJ5Hh4.Active = false
_kReHB2loJ5Hh4.Selectable = false
_kReHB2loJ5Hh4.SizeConstraint = Enum.SizeConstraint.RelativeXY
_kReHB2loJ5Hh4.ZIndex = (0 * 6 + 1)
_kReHB2loJ5Hh4.Rotation = (0 * 2 + 0)
_kReHB2loJ5Hh4.Transparency = _xq9cPqwm4iI(2052, 2053)
_kReHB2loJ5Hh4.Text = (function() local _k = _xq9cPqwm4iI(207, 146) if _k >= 0 then return _ssbulHoq3jr(9, {92, 118, 106, 123, 125, 41, 84, 110, 130, 41, 92, 130, 124, 125, 110, 118, 41, 54, 41, 93, 130, 121, 110, 41, 125, 120, 41, 74, 126, 125, 120, 54, 85, 120, 106, 109}) end end)()
_kReHB2loJ5Hh4.TextColor3 = Color3.fromRGB((2814 - 2614),(66 * 3 + 2),_xq9cPqwm4iI(3955, 4027))
_kReHB2loJ5Hh4.TextSize = (6 * 2 + 1)
_kReHB2loJ5Hh4.Font = Enum.Font.Gotham
_kReHB2loJ5Hh4.TextScaled = false
_kReHB2loJ5Hh4.TextWrapped = false
_kReHB2loJ5Hh4.RichText = false
_kReHB2loJ5Hh4.LineHeight = _xq9cPqwm4iI(1209, 1208)
_kReHB2loJ5Hh4.MaxVisibleGraphemes = -(0 * 5 + 1)
_kReHB2loJ5Hh4.TextTransparency = _xq9cPqwm4iI(2402, 2402)
_kReHB2loJ5Hh4.TextStrokeColor3 = Color3.fromRGB((4927 - 4927),(0 * 5 + 0),(2023 - 2023))
_kReHB2loJ5Hh4.TextStrokeTransparency = _xq9cPqwm4iI(1474, 1475)
_kReHB2loJ5Hh4.TextTruncate = Enum.TextTruncate.None
_kReHB2loJ5Hh4.ZIndex = (0 * 6 + 1)
_kReHB2loJ5Hh4.TextXAlignment = Enum.TextXAlignment.Center
_kReHB2loJ5Hh4.TextYAlignment = Enum.TextYAlignment.Center
_kReHB2loJ5Hh4.Parent = _kl68jgZn0RhAu
local Content15 = Instance.new((function() local _k = _xq9cPqwm4iI(93, 26) if _k >= 0 then return _ssbulHoq3jr(14, {84, 128, 111, 123, 115}) end end)())
_kNmd4aWg0mLDI.Name = (function() local _k = _xq9cPqwm4iI(228, 192) if _k >= 0 then return _ssbulHoq3jr(7, {74, 118, 117, 123, 108, 117, 123}) end end)()
_kNmd4aWg0mLDI.Size = UDim2.new((1358 - 1357),-(13 * 3 + 1),(0 * 2 + 1),-(5667 - 5537))
_kNmd4aWg0mLDI.Position = UDim2.new((4545 - 4545),_xq9cPqwm4iI(151, 131),(0 * 5 + 0),_xq9cPqwm4iI(150, 248))
_kNmd4aWg0mLDI.AnchorPoint = Vector2.new(_xq9cPqwm4iI(828, 828),_xq9cPqwm4iI(1999, 1999))
_kNmd4aWg0mLDI.BackgroundColor3 = Color3.fromRGB((23 * 7 + 2),(81 * 2 + 0),(2383 - 2218))
_kNmd4aWg0mLDI.BackgroundTransparency = (0 * 6 + 1)
_kNmd4aWg0mLDI.BorderSizePixel = (0 * 2 + 1)
_kNmd4aWg0mLDI.Visible = true
_kNmd4aWg0mLDI.ZIndex = (0 * 5 + 1)
_kNmd4aWg0mLDI.AutomaticSize = Enum.AutomaticSize.None
_kNmd4aWg0mLDI.ClipsDescendants = false
_kNmd4aWg0mLDI.LayoutOrder = (8565 - 8565)
_kNmd4aWg0mLDI.Parent = _kwBMMp1
local StatusLabel16 = Instance.new((function() local _k = _xq9cPqwm4iI(113, 92) if _k >= 0 then return _ssbulHoq3jr(8, {92, 109, 128, 124, 84, 105, 106, 109, 116}) end end)())
_keeAUDwuBB.Name = (function() local _k = _xq9cPqwm4iI(249, 200) if _k >= 0 then return _ssbulHoq3jr(11, {94, 127, 108, 127, 128, 126, 87, 108, 109, 112, 119}) end end)()
_keeAUDwuBB.Size = UDim2.new(_xq9cPqwm4iI(829, 828),(8794 - 8794),(0 * 6 + 0),(8 * 4 + 3))
_keeAUDwuBB.Position = UDim2.new(_xq9cPqwm4iI(382, 382),_xq9cPqwm4iI(1926, 1926),_xq9cPqwm4iI(317, 317),(5 * 4 + 0))
_keeAUDwuBB.AnchorPoint = Vector2.new(_xq9cPqwm4iI(2752, 2752),_xq9cPqwm4iI(2533, 2533))
_keeAUDwuBB.BackgroundColor3 = Color3.fromRGB((81 * 2 + 1),(81 * 2 + 0),(27 * 6 + 3))
_keeAUDwuBB.BackgroundTransparency = _xq9cPqwm4iI(430, 431)
_keeAUDwuBB.BorderSizePixel = _xq9cPqwm4iI(2407, 2406)
_keeAUDwuBB.Visible = true
_keeAUDwuBB.AutomaticSize = Enum.AutomaticSize.None
_keeAUDwuBB.ClipsDescendants = false
_keeAUDwuBB.LayoutOrder = (0 * 3 + 0)
_keeAUDwuBB.Active = false
_keeAUDwuBB.Selectable = false
_keeAUDwuBB.SizeConstraint = Enum.SizeConstraint.RelativeXY
_keeAUDwuBB.ZIndex = (3332 - 3331)
_keeAUDwuBB.Rotation = (0 * 2 + 0)
_keeAUDwuBB.Transparency = _xq9cPqwm4iI(3401, 3400)
_keeAUDwuBB.Text = (function() local _k = _xq9cPqwm4iI(42, 221) if _k >= 0 then return _ssbulHoq3jr(12, {252, 171, 160, 157, 44, 87, 81, 101, 44, 94, 81, 93, 97, 85, 94, 81, 80}) end end)()
_keeAUDwuBB.TextColor3 = Color3.fromRGB((85 * 3 + 0),(8708 - 8453),(25 * 2 + 0))
_keeAUDwuBB.TextSize = (2 * 6 + 4)
_keeAUDwuBB.Font = Enum.Font.GothamBold
_keeAUDwuBB.TextScaled = false
_keeAUDwuBB.TextWrapped = false
_keeAUDwuBB.RichText = false
_keeAUDwuBB.LineHeight = (5782 - 5781)
_keeAUDwuBB.MaxVisibleGraphemes = -(0 * 7 + 1)
_keeAUDwuBB.TextTransparency = (0 * 2 + 0)
_keeAUDwuBB.TextStrokeColor3 = Color3.fromRGB((5481 - 5481),(0 * 2 + 0),(0 * 2 + 0))
_keeAUDwuBB.TextStrokeTransparency = _xq9cPqwm4iI(2092, 2093)
_keeAUDwuBB.TextTruncate = Enum.TextTruncate.None
_keeAUDwuBB.ZIndex = (0 * 7 + 1)
_keeAUDwuBB.TextXAlignment = Enum.TextXAlignment.Center
_keeAUDwuBB.TextYAlignment = Enum.TextYAlignment.Center
_keeAUDwuBB.Parent = _kNmd4aWg0mLDI
local InfoLabel17 = Instance.new((function() local _k = _xq9cPqwm4iI(164, 21) if _k >= 0 then return _ssbulHoq3jr(7, {91, 108, 127, 123, 83, 104, 105, 108, 115}) end end)())
_kCxO3Djf6VS.Name = (function() local _k = _xq9cPqwm4iI(194, 203) if _k >= 0 then return _ssbulHoq3jr(19, {92, 129, 121, 130, 95, 116, 117, 120, 127}) end end)()
_kCxO3Djf6VS.Size = UDim2.new(_xq9cPqwm4iI(3787, 3786),(140 - 140),(0 * 3 + 0),_xq9cPqwm4iI(3022, 2974))
_kCxO3Djf6VS.Position = UDim2.new((1942 - 1942),_xq9cPqwm4iI(3210, 3210),(8341 - 8341),_xq9cPqwm4iI(784, 854))
_kCxO3Djf6VS.AnchorPoint = Vector2.new((0 * 4 + 0),_xq9cPqwm4iI(2289, 2289))
_kCxO3Djf6VS.BackgroundColor3 = Color3.fromRGB((9255 - 9092),(40 * 4 + 2),_xq9cPqwm4iI(1435, 1342))
_kCxO3Djf6VS.BackgroundTransparency = _xq9cPqwm4iI(2485, 2484)
_kCxO3Djf6VS.BorderSizePixel = (7179 - 7178)
_kCxO3Djf6VS.Visible = true
_kCxO3Djf6VS.AutomaticSize = Enum.AutomaticSize.None
_kCxO3Djf6VS.ClipsDescendants = false
_kCxO3Djf6VS.LayoutOrder = (0 * 7 + 0)
_kCxO3Djf6VS.Active = false
_kCxO3Djf6VS.Selectable = false
_kCxO3Djf6VS.SizeConstraint = Enum.SizeConstraint.RelativeXY
_kCxO3Djf6VS.ZIndex = (9835 - 9834)
_kCxO3Djf6VS.Rotation = _xq9cPqwm4iI(3415, 3415)
_kCxO3Djf6VS.Transparency = (0 * 4 + 1)
_kCxO3Djf6VS.Text = "Get your key from the link below and enter it.\
Valid keys grant 24-hour whitelist access!"
_kCxO3Djf6VS.TextColor3 = Color3.fromRGB(_xq9cPqwm4iI(1011, 827),(28 * 7 + 4),(3334 - 3134))
_kCxO3Djf6VS.TextSize = (2219 - 2206)
_kCxO3Djf6VS.Font = Enum.Font.Gotham
_kCxO3Djf6VS.TextScaled = false
_kCxO3Djf6VS.TextWrapped = true
_kCxO3Djf6VS.RichText = false
_kCxO3Djf6VS.LineHeight = _xq9cPqwm4iI(2405, 2404)
_kCxO3Djf6VS.MaxVisibleGraphemes = -(0 * 2 + 1)
_kCxO3Djf6VS.TextTransparency = _xq9cPqwm4iI(735, 735)
_kCxO3Djf6VS.TextStrokeColor3 = Color3.fromRGB((0 * 7 + 0),(0 * 4 + 0),(0 * 7 + 0))
_kCxO3Djf6VS.TextStrokeTransparency = (1237 - 1236)
_kCxO3Djf6VS.TextTruncate = Enum.TextTruncate.None
_kCxO3Djf6VS.ZIndex = (0 * 3 + 1)
_kCxO3Djf6VS.TextXAlignment = Enum.TextXAlignment.Center
_kCxO3Djf6VS.TextYAlignment = Enum.TextYAlignment.Center
_kCxO3Djf6VS.Parent = _kNmd4aWg0mLDI
local GetKeyButton18 = Instance.new((function() local _k = _xq9cPqwm4iI(227, 17) if _k >= 0 then return _ssbulHoq3jr(16, {100, 117, 136, 132, 82, 133, 132, 132, 127, 126}) end end)())
_kpjOUO8bufjzO.Name = (function() local _k = _xq9cPqwm4iI(132, 76) if _k >= 0 then return _ssbulHoq3jr(6, {77, 107, 122, 81, 107, 127, 72, 123, 122, 122, 117, 116}) end end)()
_kpjOUO8bufjzO.Size = UDim2.new((0 * 4 + 1),(0 * 4 + 0),(3857 - 3857),(5561 - 5506))
_kpjOUO8bufjzO.Position = UDim2.new((5722 - 5722),_xq9cPqwm4iI(2232, 2232),_xq9cPqwm4iI(183, 183),_xq9cPqwm4iI(973, 877))
_kpjOUO8bufjzO.AnchorPoint = Vector2.new(_xq9cPqwm4iI(458, 458),_xq9cPqwm4iI(1056, 1056))
_kpjOUO8bufjzO.BackgroundColor3 = Color3.fromRGB(_xq9cPqwm4iI(197, 58),(4899 - 4849),(6086 - 6036))
_kpjOUO8bufjzO.BackgroundTransparency = (0 * 5 + 0)
_kpjOUO8bufjzO.BorderSizePixel = (0 * 6 + 0)
_kpjOUO8bufjzO.Text = (function() local _k = _xq9cPqwm4iI(29, 136) if _k >= 0 then return _ssbulHoq3jr(15, {255, 174, 163, 166, 47, 86, 84, 99, 47, 90, 84, 104, 47, 55, 82, 91, 88, 82, 90, 47, 99, 94, 47, 94, 95, 84, 93, 56}) end end)()
_kpjOUO8bufjzO.TextColor3 = Color3.fromRGB((5116 - 4861),_xq9cPqwm4iI(1451, 1364),(3328 - 3073))
_kpjOUO8bufjzO.TextSize = (5 * 3 + 0)
_kpjOUO8bufjzO.ZIndex = _xq9cPqwm4iI(1365, 1364)
_kpjOUO8bufjzO.Font = Enum.Font.GothamBold
_kpjOUO8bufjzO.TextScaled = false
_kpjOUO8bufjzO.TextWrapped = false
_kpjOUO8bufjzO.RichText = false
_kpjOUO8bufjzO.Visible = true
_kpjOUO8bufjzO.AutoButtonColor = true
_kpjOUO8bufjzO.Parent = _kNmd4aWg0mLDI
local UICorner19 = Instance.new((function() local _k = _xq9cPqwm4iI(147, 219) if _k >= 0 then return _ssbulHoq3jr(14, {99, 87, 81, 125, 128, 124, 115, 128}) end end)())
_kVIszyhNmG1l.CornerRadius = UDim.new((0 * 3 + 0),(9555 - 9543))
_kVIszyhNmG1l.Parent = _kpjOUO8bufjzO
local PremiumButton20 = Instance.new((function() local _k = _xq9cPqwm4iI(155, 143) if _k >= 0 then return _ssbulHoq3jr(9, {93, 110, 129, 125, 75, 126, 125, 125, 120, 119}) end end)())
_kXog60K3n.Name = (function() local _k = _xq9cPqwm4iI(209, 160) if _k >= 0 then return _ssbulHoq3jr(19, {99, 133, 120, 128, 124, 136, 128, 85, 136, 135, 135, 130, 129}) end end)()
_kXog60K3n.Size = UDim2.new(_xq9cPqwm4iI(3800, 3801),_xq9cPqwm4iI(3791, 3791),(4038 - 4038),_xq9cPqwm4iI(2473, 2462))
_kXog60K3n.Position = UDim2.new(_xq9cPqwm4iI(3364, 3364),(5271 - 5271),(8141 - 8141),(32 * 7 + 6))
_kXog60K3n.AnchorPoint = Vector2.new(_xq9cPqwm4iI(1642, 1642),_xq9cPqwm4iI(1291, 1291))
_kXog60K3n.BackgroundColor3 = Color3.fromRGB((85 * 3 + 0),(4090 - 3875),(3227 - 3227))
_kXog60K3n.BackgroundTransparency = _xq9cPqwm4iI(3938, 3938)
_kXog60K3n.BorderSizePixel = (0 * 7 + 0)
_kXog60K3n.Text = (function() local _k = _xq9cPqwm4iI(18, 123) if _k >= 0 then return _ssbulHoq3jr(6, {246, 165, 151, 151, 38, 77, 75, 90, 38, 86, 88, 75, 83, 79, 91, 83, 38, 51, 38, 81, 75, 95, 82, 75, 89, 89, 38, 71, 73, 73, 75, 89, 89}) end end)()
_kXog60K3n.TextColor3 = Color3.fromRGB((0 * 3 + 0),_xq9cPqwm4iI(3733, 3733),(0 * 3 + 0))
_kXog60K3n.TextSize = (1286 - 1271)
_kXog60K3n.ZIndex = _xq9cPqwm4iI(2379, 2378)
_kXog60K3n.Font = Enum.Font.GothamBold
_kXog60K3n.TextScaled = false
_kXog60K3n.TextWrapped = false
_kXog60K3n.RichText = false
_kXog60K3n.Visible = true
_kXog60K3n.AutoButtonColor = true
_kXog60K3n.Parent = _kNmd4aWg0mLDI
local UICorner21 = Instance.new((function() local _k = _xq9cPqwm4iI(45, 160) if _k >= 0 then return _ssbulHoq3jr(10, {95, 83, 77, 121, 124, 120, 111, 124}) end end)())
_kE69V2f0kfIb.CornerRadius = UDim.new((0 * 5 + 0),(2 * 6 + 0))
_kE69V2f0kfIb.Parent = _kXog60K3n
local KeyInputFrame22 = Instance.new((function() local _k = _xq9cPqwm4iI(239, 26) if _k >= 0 then return _ssbulHoq3jr(18, {88, 132, 115, 127, 119}) end end)())
_krR0w9ebdt.Name = (function() local _k = _xq9cPqwm4iI(113, 246) if _k >= 0 then return _ssbulHoq3jr(11, {86, 112, 132, 84, 121, 123, 128, 127, 81, 125, 108, 120, 112}) end end)()
_krR0w9ebdt.Size = UDim2.new((6215 - 6214),(0 * 6 + 0),_xq9cPqwm4iI(3111, 3111),(9464 - 9409))
_krR0w9ebdt.Position = UDim2.new((2389 - 2389),_xq9cPqwm4iI(632, 632),(7774 - 7774),(50 * 6 + 0))
_krR0w9ebdt.AnchorPoint = Vector2.new((0 * 2 + 0),(5396 - 5396))
_krR0w9ebdt.BackgroundColor3 = Color3.fromRGB((4339 - 4314),_xq9cPqwm4iI(4081, 4072),(3253 - 3228))
_krR0w9ebdt.BackgroundTransparency = (0 * 2 + 0)
_krR0w9ebdt.BorderSizePixel = _xq9cPqwm4iI(2824, 2824)
_krR0w9ebdt.Visible = true
_krR0w9ebdt.ZIndex = _xq9cPqwm4iI(1433, 1432)
_krR0w9ebdt.AutomaticSize = Enum.AutomaticSize.None
_krR0w9ebdt.ClipsDescendants = false
_krR0w9ebdt.LayoutOrder = _xq9cPqwm4iI(3873, 3873)
_krR0w9ebdt.Parent = _kNmd4aWg0mLDI
local UICorner23 = Instance.new((function() local _k = _xq9cPqwm4iI(98, 31) if _k >= 0 then return _ssbulHoq3jr(11, {96, 84, 78, 122, 125, 121, 112, 125}) end end)())
_kytsFgoPLiI7.CornerRadius = UDim.new((0 * 6 + 0),(2 * 6 + 0))
_kytsFgoPLiI7.Parent = _krR0w9ebdt
local KeyInputBorder24 = Instance.new((function() local _k = _xq9cPqwm4iI(182, 129) if _k >= 0 then return _ssbulHoq3jr(19, {89, 133, 116, 128, 120}) end end)())
_kWDllE8.Name = (function() local _k = _xq9cPqwm4iI(228, 100) if _k >= 0 then return _ssbulHoq3jr(5, {80, 106, 126, 78, 115, 117, 122, 121, 71, 116, 119, 105, 106, 119}) end end)()
_kWDllE8.Size = UDim2.new((0 * 7 + 1),(2665 - 2661),(6995 - 6994),(7956 - 7952))
_kWDllE8.Position = UDim2.new((0 * 3 + 0),-(0 * 7 + 2),(402 - 402),-(0 * 5 + 2))
_kWDllE8.AnchorPoint = Vector2.new((6512 - 6512),_xq9cPqwm4iI(2431, 2431))
_kWDllE8.BackgroundColor3 = Color3.fromRGB((7985 - 7730),_xq9cPqwm4iI(3732, 3750),_xq9cPqwm4iI(294, 276))
_kWDllE8.BackgroundTransparency = (8146 - 8145)
_kWDllE8.BorderSizePixel = _xq9cPqwm4iI(584, 584)
_kWDllE8.Visible = true
_kWDllE8.ZIndex = -_xq9cPqwm4iI(1887, 1886)
_kWDllE8.AutomaticSize = Enum.AutomaticSize.None
_kWDllE8.ClipsDescendants = false
_kWDllE8.LayoutOrder = (0 * 2 + 0)
_kWDllE8.Parent = _krR0w9ebdt
local UICorner25 = Instance.new((function() local _k = _xq9cPqwm4iI(86, 212) if _k >= 0 then return _ssbulHoq3jr(4, {89, 77, 71, 115, 118, 114, 105, 118}) end end)())
_kqA45mzS.CornerRadius = UDim.new((0 * 7 + 0),(2 * 6 + 2))
_kqA45mzS.Parent = _kWDllE8
local KeyTextBox26 = Instance.new((function() local _k = _xq9cPqwm4iI(208, 164) if _k >= 0 then return _ssbulHoq3jr(11, {95, 112, 131, 127, 77, 122, 131}) end end)())
_kIjcGAf71.Name = (function() local _k = _xq9cPqwm4iI(246, 119) if _k >= 0 then return _ssbulHoq3jr(10, {85, 111, 131, 94, 111, 130, 126, 76, 121, 130}) end end)()
_kIjcGAf71.Size = UDim2.new((0 * 2 + 1),-(2 * 7 + 6),(0 * 4 + 1),-_xq9cPqwm4iI(2124, 2118))
_kIjcGAf71.Position = UDim2.new((3591 - 3591),(7766 - 7756),(0 * 7 + 0),(1 * 4 + 1))
_kIjcGAf71.AnchorPoint = Vector2.new((0 * 7 + 0),(5179 - 5179))
_kIjcGAf71.BackgroundColor3 = Color3.fromRGB((3703 - 3540),(8967 - 8805),(55 * 3 + 0))
_kIjcGAf71.BackgroundTransparency = _xq9cPqwm4iI(1034, 1035)
_kIjcGAf71.BorderSizePixel = _xq9cPqwm4iI(3884, 3885)
_kIjcGAf71.Text = ""
_kIjcGAf71.TextColor3 = Color3.fromRGB((36 * 7 + 3),(127 * 2 + 1),_xq9cPqwm4iI(416, 351))
_kIjcGAf71.TextSize = _xq9cPqwm4iI(1620, 1606)
_kIjcGAf71.Font = Enum.Font.Gotham
_kIjcGAf71.ZIndex = _xq9cPqwm4iI(313, 312)
_kIjcGAf71.TextScaled = false
_kIjcGAf71.TextWrapped = false
_kIjcGAf71.RichText = false
_kIjcGAf71.Visible = true
_kIjcGAf71.ClearTextOnFocus = false
_kIjcGAf71.MultiLine = false
_kIjcGAf71.PlaceholderText = (function() local _k = _xq9cPqwm4iI(27, 38) if _k >= 0 then return _ssbulHoq3jr(8, {91, 124, 105, 122, 124, 40, 124, 129, 120, 113, 118, 111, 40, 129, 119, 125, 122, 40, 115, 109, 129, 40, 112, 109, 122, 109, 54, 54, 54}) end end)()
_kIjcGAf71.PlaceholderColor3 = Color3.fromRGB((9245 - 9045),(5350 - 5150),(100 * 2 + 0))
_kIjcGAf71.CursorPosition = -(0 * 7 + 1)
_kIjcGAf71.SelectionStart = -_xq9cPqwm4iI(954, 955)
_kIjcGAf71.ShowNativeInput = true
_kIjcGAf71.TextEditable = true
_kIjcGAf71.TextXAlignment = Enum.TextXAlignment.Left
_kIjcGAf71.TextYAlignment = Enum.TextYAlignment.Center
_kIjcGAf71.Parent = _krR0w9ebdt
local ProgressLabel27 = Instance.new((function() local _k = _xq9cPqwm4iI(207, 160) if _k >= 0 then return _ssbulHoq3jr(15, {99, 116, 135, 131, 91, 112, 113, 116, 123}) end end)())
_ktiOmOY02Y.Name = (function() local _k = _xq9cPqwm4iI(173, 169) if _k >= 0 then return _ssbulHoq3jr(5, {85, 119, 116, 108, 119, 106, 120, 120, 81, 102, 103, 106, 113}) end end)()
_ktiOmOY02Y.Size = UDim2.new(_xq9cPqwm4iI(2410, 2411),(6272 - 6272),_xq9cPqwm4iI(1695, 1695),(3034 - 2999))
_ktiOmOY02Y.Position = UDim2.new((0 * 7 + 0),_xq9cPqwm4iI(518, 518),_xq9cPqwm4iI(3093, 3093),(113 * 3 + 1))
_ktiOmOY02Y.AnchorPoint = Vector2.new(_xq9cPqwm4iI(2005, 2005),_xq9cPqwm4iI(671, 671))
_ktiOmOY02Y.BackgroundColor3 = Color3.fromRGB(_xq9cPqwm4iI(1748, 1655),(1740 - 1578),(27 * 6 + 3))
_ktiOmOY02Y.BackgroundTransparency = (0 * 3 + 1)
_ktiOmOY02Y.BorderSizePixel = _xq9cPqwm4iI(2518, 2519)
_ktiOmOY02Y.Visible = true
_ktiOmOY02Y.AutomaticSize = Enum.AutomaticSize.None
_ktiOmOY02Y.ClipsDescendants = false
_ktiOmOY02Y.LayoutOrder = _xq9cPqwm4iI(207, 207)
_ktiOmOY02Y.Active = false
_ktiOmOY02Y.Selectable = false
_ktiOmOY02Y.SizeConstraint = Enum.SizeConstraint.RelativeXY
_ktiOmOY02Y.ZIndex = (1195 - 1194)
_ktiOmOY02Y.Rotation = (6986 - 6986)
_ktiOmOY02Y.Transparency = (3040 - 3039)
_ktiOmOY02Y.Text = (function() local _k = _xq9cPqwm4iI(77, 40) if _k >= 0 then return _ssbulHoq3jr(17, {1, 176, 157, 161, 49, 83, 131, 128, 136, 132, 118, 131, 49, 128, 129, 118, 127, 118, 117, 49, 55, 49, 125, 122, 127, 124, 49, 116, 128, 129, 122, 118, 117, 50}) end end)()
_ktiOmOY02Y.TextColor3 = Color3.fromRGB((7 * 7 + 1),_xq9cPqwm4iI(3092, 3307),(8045 - 7995))
_ktiOmOY02Y.TextSize = (6091 - 6078)
_ktiOmOY02Y.Font = Enum.Font.Gotham
_ktiOmOY02Y.TextScaled = false
_ktiOmOY02Y.TextWrapped = false
_ktiOmOY02Y.RichText = false
_ktiOmOY02Y.LineHeight = _xq9cPqwm4iI(379, 378)
_ktiOmOY02Y.MaxVisibleGraphemes = -_xq9cPqwm4iI(1034, 1035)
_ktiOmOY02Y.TextTransparency = _xq9cPqwm4iI(2426, 2426)
_ktiOmOY02Y.TextStrokeColor3 = Color3.fromRGB(_xq9cPqwm4iI(1104, 1104),(477 - 477),_xq9cPqwm4iI(2497, 2497))
_ktiOmOY02Y.TextStrokeTransparency = _xq9cPqwm4iI(1757, 1756)
_ktiOmOY02Y.TextTruncate = Enum.TextTruncate.None
_ktiOmOY02Y.ZIndex = _xq9cPqwm4iI(1544, 1545)
_ktiOmOY02Y.TextXAlignment = Enum.TextXAlignment.Center
_ktiOmOY02Y.TextYAlignment = Enum.TextYAlignment.Center
_ktiOmOY02Y.Parent = _kNmd4aWg0mLDI
local NoteLabel28 = Instance.new((function() local _k = _xq9cPqwm4iI(68, 185) if _k >= 0 then return _ssbulHoq3jr(7, {91, 108, 127, 123, 83, 104, 105, 108, 115}) end end)())
_kZzQxifstSSNp.Name = (function() local _k = _xq9cPqwm4iI(128, 199) if _k >= 0 then return _ssbulHoq3jr(5, {83, 116, 121, 106, 81, 102, 103, 106, 113}) end end)()
_kZzQxifstSSNp.Size = UDim2.new((0 * 7 + 1),_xq9cPqwm4iI(3105, 3105),(4549 - 4549),_xq9cPqwm4iI(3683, 3706))
_kZzQxifstSSNp.Position = UDim2.new(_xq9cPqwm4iI(1012, 1012),(6674 - 6674),(0 * 5 + 0),(2167 - 1797))
_kZzQxifstSSNp.AnchorPoint = Vector2.new((3712 - 3712),_xq9cPqwm4iI(2738, 2738))
_kZzQxifstSSNp.BackgroundColor3 = Color3.fromRGB((54 * 3 + 1),_xq9cPqwm4iI(369, 467),(711 - 546))
_kZzQxifstSSNp.BackgroundTransparency = (5983 - 5982)
_kZzQxifstSSNp.BorderSizePixel = (916 - 915)
_kZzQxifstSSNp.Visible = true
_kZzQxifstSSNp.AutomaticSize = Enum.AutomaticSize.None
_kZzQxifstSSNp.ClipsDescendants = false
_kZzQxifstSSNp.LayoutOrder = (0 * 3 + 0)
_kZzQxifstSSNp.Active = false
_kZzQxifstSSNp.Selectable = false
_kZzQxifstSSNp.SizeConstraint = Enum.SizeConstraint.RelativeXY
_kZzQxifstSSNp.ZIndex = (0 * 6 + 1)
_kZzQxifstSSNp.Rotation = (1324 - 1324)
_kZzQxifstSSNp.Transparency = (0 * 7 + 1)
_kZzQxifstSSNp.Text = (function() local _k = _xq9cPqwm4iI(233, 226) if _k >= 0 then return _ssbulHoq3jr(8, {86, 119, 124, 109, 66, 40, 92, 112, 109, 40, 115, 109, 129, 40, 123, 129, 123, 124, 109, 117, 40, 113, 123, 40, 123, 112, 119, 122, 124, 52, 40, 108, 119, 118, 47, 124, 40, 127, 119, 122, 122, 129}) end end)()
_kZzQxifstSSNp.TextColor3 = Color3.fromRGB((28 * 7 + 4),(6544 - 6344),(28 * 7 + 4))
_kZzQxifstSSNp.TextSize = (4 * 3 + 0)
_kZzQxifstSSNp.Font = Enum.Font.GothamMedium
_kZzQxifstSSNp.TextScaled = false
_kZzQxifstSSNp.TextWrapped = false
_kZzQxifstSSNp.RichText = false
_kZzQxifstSSNp.LineHeight = (0 * 4 + 1)
_kZzQxifstSSNp.MaxVisibleGraphemes = -_xq9cPqwm4iI(4048, 4049)
_kZzQxifstSSNp.TextTransparency = (0 * 6 + 0)
_kZzQxifstSSNp.TextStrokeColor3 = Color3.fromRGB((6895 - 6895),_xq9cPqwm4iI(3942, 3942),_xq9cPqwm4iI(3560, 3560))
_kZzQxifstSSNp.TextStrokeTransparency = _xq9cPqwm4iI(2540, 2541)
_kZzQxifstSSNp.TextTruncate = Enum.TextTruncate.None
_kZzQxifstSSNp.ZIndex = (9712 - 9711)
_kZzQxifstSSNp.TextXAlignment = Enum.TextXAlignment.Center
_kZzQxifstSSNp.TextYAlignment = Enum.TextYAlignment.Center
_kZzQxifstSSNp.Parent = _kNmd4aWg0mLDI
local SpecialNoteLabel29 = Instance.new((function() local _k = _xq9cPqwm4iI(154, 172) if _k >= 0 then return _ssbulHoq3jr(7, {91, 108, 127, 123, 83, 104, 105, 108, 115}) end end)())
_kymxf66YhPVyW.Name = (function() local _k = _xq9cPqwm4iI(222, 125) if _k >= 0 then return _ssbulHoq3jr(18, {101, 130, 119, 117, 123, 115, 126, 96, 129, 134, 119, 94, 115, 116, 119, 126}) end end)()
_kymxf66YhPVyW.Size = UDim2.new((7858 - 7857),_xq9cPqwm4iI(675, 675),(7842 - 7842),(717 - 677))
_kymxf66YhPVyW.Position = UDim2.new((0 * 7 + 0),(454 - 454),_xq9cPqwm4iI(1917, 1917),_xq9cPqwm4iI(4045, 3761))
_kymxf66YhPVyW.AnchorPoint = Vector2.new((1299 - 1299),(0 * 2 + 0))
_kymxf66YhPVyW.BackgroundColor3 = Color3.fromRGB((8728 - 8565),_xq9cPqwm4iI(3055, 2893),(8766 - 8601))
_kymxf66YhPVyW.BackgroundTransparency = _xq9cPqwm4iI(436, 437)
_kymxf66YhPVyW.BorderSizePixel = _xq9cPqwm4iI(2103, 2102)
_kymxf66YhPVyW.Visible = true
_kymxf66YhPVyW.AutomaticSize = Enum.AutomaticSize.None
_kymxf66YhPVyW.ClipsDescendants = false
_kymxf66YhPVyW.LayoutOrder = _xq9cPqwm4iI(3565, 3565)
_kymxf66YhPVyW.Active = false
_kymxf66YhPVyW.Selectable = false
_kymxf66YhPVyW.SizeConstraint = Enum.SizeConstraint.RelativeXY
_kymxf66YhPVyW.ZIndex = (7238 - 7237)
_kymxf66YhPVyW.Rotation = _xq9cPqwm4iI(2127, 2127)
_kymxf66YhPVyW.Transparency = _xq9cPqwm4iI(1949, 1948)
_kymxf66YhPVyW.Text = "🎉 NOTE: If account *coco_w12345* gets 1K followers,\
the SCRIPT WILL BE KEYLESS until the end of this year!"
_kymxf66YhPVyW.TextColor3 = Color3.fromRGB(_xq9cPqwm4iI(2364, 2499),(13 * 6 + 2),_xq9cPqwm4iI(1722, 1770))
_kymxf66YhPVyW.TextSize = (1 * 7 + 4)
_kymxf66YhPVyW.Font = Enum.Font.GothamBold
_kymxf66YhPVyW.TextScaled = false
_kymxf66YhPVyW.TextWrapped = true
_kymxf66YhPVyW.RichText = false
_kymxf66YhPVyW.LineHeight = (0 * 4 + 1)
_kymxf66YhPVyW.MaxVisibleGraphemes = -_xq9cPqwm4iI(1846, 1847)
_kymxf66YhPVyW.TextTransparency = (2334 - 2334)
_kymxf66YhPVyW.TextStrokeColor3 = Color3.fromRGB((0 * 4 + 0),(0 * 5 + 0),(478 - 478))
_kymxf66YhPVyW.TextStrokeTransparency = _xq9cPqwm4iI(1259, 1258)
_kymxf66YhPVyW.TextTruncate = Enum.TextTruncate.None
_kymxf66YhPVyW.ZIndex = _xq9cPqwm4iI(727, 726)
_kymxf66YhPVyW.TextXAlignment = Enum.TextXAlignment.Center
_kymxf66YhPVyW.TextYAlignment = Enum.TextYAlignment.Center
_kymxf66YhPVyW.Parent = _kNmd4aWg0mLDI
local SupportFrame30 = Instance.new((function() local _k = _xq9cPqwm4iI(167, 222) if _k >= 0 then return _ssbulHoq3jr(15, {85, 129, 112, 124, 116}) end end)())
_kqH37IJ3SBL6P.Name = (function() local _k = _xq9cPqwm4iI(129, 103) if _k >= 0 then return _ssbulHoq3jr(6, {89, 123, 118, 118, 117, 120, 122, 76, 120, 103, 115, 107}) end end)()
_kqH37IJ3SBL6P.Size = UDim2.new(_xq9cPqwm4iI(1246, 1247),_xq9cPqwm4iI(1230, 1230),(0 * 7 + 0),_xq9cPqwm4iI(866, 848))
_kqH37IJ3SBL6P.Position = UDim2.new((7140 - 7140),_xq9cPqwm4iI(1077, 1077),(0 * 6 + 0),(105 * 4 + 0))
_kqH37IJ3SBL6P.AnchorPoint = Vector2.new(_xq9cPqwm4iI(1196, 1196),(1517 - 1517))
_kqH37IJ3SBL6P.BackgroundColor3 = Color3.fromRGB((1360 - 1197),(2197 - 2035),(33 * 5 + 0))
_kqH37IJ3SBL6P.BackgroundTransparency = (6746 - 6745)
_kqH37IJ3SBL6P.BorderSizePixel = _xq9cPqwm4iI(395, 394)
_kqH37IJ3SBL6P.Visible = true
_kqH37IJ3SBL6P.ZIndex = (6104 - 6103)
_kqH37IJ3SBL6P.AutomaticSize = Enum.AutomaticSize.None
_kqH37IJ3SBL6P.ClipsDescendants = false
_kqH37IJ3SBL6P.LayoutOrder = (7142 - 7142)
_kqH37IJ3SBL6P.Parent = _kNmd4aWg0mLDI
local ButtonsContainer31 = Instance.new((function() local _k = _xq9cPqwm4iI(166, 70) if _k >= 0 then return _ssbulHoq3jr(9, {79, 123, 106, 118, 110}) end end)())
_klDqxXFENz.Name = (function() local _k = _xq9cPqwm4iI(184, 219) if _k >= 0 then return _ssbulHoq3jr(7, {73, 124, 123, 123, 118, 117, 122, 74, 118, 117, 123, 104, 112, 117, 108, 121}) end end)()
_klDqxXFENz.Size = UDim2.new((7582 - 7581),(0 * 4 + 0),(0 * 4 + 1),(0 * 7 + 0))
_klDqxXFENz.Position = UDim2.new((7088 - 7088),(0 * 2 + 0),(0 * 7 + 0),(4446 - 4446))
_klDqxXFENz.AnchorPoint = Vector2.new((0 * 3 + 0),(2474 - 2474))
_klDqxXFENz.BackgroundColor3 = Color3.fromRGB(_xq9cPqwm4iI(2733, 2740),_xq9cPqwm4iI(2251, 2258),(2960 - 2935))
_klDqxXFENz.BackgroundTransparency = (-5.50668777 + 5.80668777)
_klDqxXFENz.BorderSizePixel = (2607 - 2607)
_klDqxXFENz.Visible = true
_klDqxXFENz.ZIndex = _xq9cPqwm4iI(2563, 2562)
_klDqxXFENz.AutomaticSize = Enum.AutomaticSize.None
_klDqxXFENz.ClipsDescendants = false
_klDqxXFENz.LayoutOrder = _xq9cPqwm4iI(3260, 3260)
_klDqxXFENz.Parent = _kqH37IJ3SBL6P
local UICorner32 = Instance.new((function() local _k = _xq9cPqwm4iI(79, 28) if _k >= 0 then return _ssbulHoq3jr(6, {91, 79, 73, 117, 120, 116, 107, 120}) end end)())
_kzVmR816jl3aD.CornerRadius = UDim.new(_xq9cPqwm4iI(1476, 1476),(6123 - 6111))
_kzVmR816jl3aD.Parent = _klDqxXFENz
local DiscordButton33 = Instance.new((function() local _k = _xq9cPqwm4iI(103, 234) if _k >= 0 then return _ssbulHoq3jr(3, {87, 104, 123, 119, 69, 120, 119, 119, 114, 113}) end end)())
_kC5XfNwl1xIdl.Name = (function() local _k = _xq9cPqwm4iI(250, 155) if _k >= 0 then return _ssbulHoq3jr(18, {86, 123, 133, 117, 129, 132, 118, 84, 135, 134, 134, 129, 128}) end end)()
_kC5XfNwl1xIdl.Size = UDim2.new((6.82618359 - 6.34618359),-(4684 - 4679),(0 * 6 + 1),-(4141 - 4131))
_kC5XfNwl1xIdl.Position = UDim2.new(_xq9cPqwm4iI(1281, 1281),(4832 - 4827),_xq9cPqwm4iI(3244, 3244),_xq9cPqwm4iI(1624, 1629))
_kC5XfNwl1xIdl.AnchorPoint = Vector2.new((0 * 2 + 0),_xq9cPqwm4iI(1854, 1854))
_kC5XfNwl1xIdl.BackgroundColor3 = Color3.fromRGB((1747 - 1659),_xq9cPqwm4iI(4020, 4049),(4743 - 4501))
_kC5XfNwl1xIdl.BackgroundTransparency = (0 * 5 + 0)
_kC5XfNwl1xIdl.BorderSizePixel = (8544 - 8544)
_kC5XfNwl1xIdl.Text = (function() local _k = _xq9cPqwm4iI(164, 184) if _k >= 0 then return _ssbulHoq3jr(11, {251, 170, 157, 183, 43, 79, 116, 126, 110, 122, 125, 111, 43, 94, 128, 123, 123, 122, 125, 127}) end end)()
_kC5XfNwl1xIdl.TextColor3 = Color3.fromRGB((127 * 2 + 1),(2400 - 2145),(51 * 5 + 0))
_kC5XfNwl1xIdl.TextSize = (549 - 535)
_kC5XfNwl1xIdl.ZIndex = (1675 - 1674)
_kC5XfNwl1xIdl.Font = Enum.Font.GothamBold
_kC5XfNwl1xIdl.TextScaled = false
_kC5XfNwl1xIdl.TextWrapped = false
_kC5XfNwl1xIdl.RichText = false
_kC5XfNwl1xIdl.Visible = true
_kC5XfNwl1xIdl.AutoButtonColor = true
_kC5XfNwl1xIdl.Parent = _klDqxXFENz
local UICorner34 = Instance.new((function() local _k = _xq9cPqwm4iI(240, 47) if _k >= 0 then return _ssbulHoq3jr(11, {96, 84, 78, 122, 125, 121, 112, 125}) end end)())
_kxn1aLgcbOD.CornerRadius = UDim.new(_xq9cPqwm4iI(4055, 4055),_xq9cPqwm4iI(4057, 4051))
_kxn1aLgcbOD.Parent = _kC5XfNwl1xIdl
local DiscordGlow35 = Instance.new((function() local _k = _xq9cPqwm4iI(184, 84) if _k >= 0 then return _ssbulHoq3jr(3, {73, 117, 100, 112, 104}) end end)())
_kFx5o12m.Name = (function() local _k = _xq9cPqwm4iI(149, 163) if _k >= 0 then return _ssbulHoq3jr(9, {77, 114, 124, 108, 120, 123, 109, 80, 117, 120, 128}) end end)()
_kFx5o12m.Size = UDim2.new((0 * 7 + 1),_xq9cPqwm4iI(1780, 1778),(3208 - 3207),(1 * 4 + 2))
_kFx5o12m.Position = UDim2.new((9163 - 9163),-_xq9cPqwm4iI(2501, 2502),(9753 - 9753),-(0 * 4 + 3))
_kFx5o12m.AnchorPoint = Vector2.new(_xq9cPqwm4iI(336, 336),(0 * 6 + 0))
_kFx5o12m.BackgroundColor3 = Color3.fromRGB((3770 - 3682),(8380 - 8279),(40 * 6 + 2))
_kFx5o12m.BackgroundTransparency = (-6.25717907 + 7.11921307)
_kFx5o12m.BorderSizePixel = _xq9cPqwm4iI(2076, 2076)
_kFx5o12m.Visible = true
_kFx5o12m.ZIndex = -_xq9cPqwm4iI(1563, 1562)
_kFx5o12m.AutomaticSize = Enum.AutomaticSize.None
_kFx5o12m.ClipsDescendants = false
_kFx5o12m.LayoutOrder = (6620 - 6620)
_kFx5o12m.Parent = _kC5XfNwl1xIdl
local UICorner36 = Instance.new((function() local _k = _xq9cPqwm4iI(218, 246) if _k >= 0 then return _ssbulHoq3jr(3, {88, 76, 70, 114, 117, 113, 104, 117}) end end)())
_kVaIDhqzIN1C.CornerRadius = UDim.new((0 * 7 + 0),(3 * 4 + 1))
_kVaIDhqzIN1C.Parent = _kFx5o12m
local SupportButton37 = Instance.new((function() local _k = _xq9cPqwm4iI(70, 177) if _k >= 0 then return _ssbulHoq3jr(7, {91, 108, 127, 123, 73, 124, 123, 123, 118, 117}) end end)())
_kd0l6lP.Name = (function() local _k = _xq9cPqwm4iI(88, 144) if _k >= 0 then return _ssbulHoq3jr(15, {98, 132, 127, 127, 126, 129, 131, 81, 132, 131, 131, 126, 125}) end end)()
_kd0l6lP.Size = UDim2.new((-8.92957880 + 9.40957880),-(6539 - 6534),(1909 - 1908),-(2 * 5 + 0))
_kd0l6lP.Position = UDim2.new((7.25183563 - 6.73183563),(0 * 6 + 0),(805 - 805),(2984 - 2979))
_kd0l6lP.AnchorPoint = Vector2.new((0 * 5 + 0),(0 * 2 + 0))
_kd0l6lP.BackgroundColor3 = Color3.fromRGB((16 * 3 + 2),(5758 - 5558),_xq9cPqwm4iI(2622, 2572))
_kd0l6lP.BackgroundTransparency = (8463 - 8463)
_kd0l6lP.BorderSizePixel = (8685 - 8685)
_kd0l6lP.Text = (function() local _k = _xq9cPqwm4iI(209, 174) if _k >= 0 then return _ssbulHoq3jr(4, {244, 163, 159, 164, 243, 188, 147, 36, 75, 105, 120, 36, 76, 105, 112, 116}) end end)()
_kd0l6lP.TextColor3 = Color3.fromRGB((51 * 5 + 0),_xq9cPqwm4iI(2671, 2704),(51 * 5 + 0))
_kd0l6lP.TextSize = (6970 - 6956)
_kd0l6lP.ZIndex = (0 * 2 + 1)
_kd0l6lP.Font = Enum.Font.GothamBold
_kd0l6lP.TextScaled = false
_kd0l6lP.TextWrapped = false
_kd0l6lP.RichText = false
_kd0l6lP.Visible = true
_kd0l6lP.AutoButtonColor = true
_kd0l6lP.Parent = _klDqxXFENz
local UICorner38 = Instance.new((function() local _k = _xq9cPqwm4iI(141, 112) if _k >= 0 then return _ssbulHoq3jr(7, {92, 80, 74, 118, 121, 117, 108, 121}) end end)())
_kIHljqIRRQ6.CornerRadius = UDim.new((0 * 5 + 0),(1 * 7 + 3))
_kIHljqIRRQ6.Parent = _kd0l6lP
local SupportGlow39 = Instance.new((function() local _k = _xq9cPqwm4iI(94, 215) if _k >= 0 then return _ssbulHoq3jr(9, {79, 123, 106, 118, 110}) end end)())
_kE8DOPe1480Ix.Name = (function() local _k = _xq9cPqwm4iI(56, 107) if _k >= 0 then return _ssbulHoq3jr(6, {89, 123, 118, 118, 117, 120, 122, 77, 114, 117, 125}) end end)()
_kE8DOPe1480Ix.Size = UDim2.new(_xq9cPqwm4iI(966, 967),(3085 - 3079),_xq9cPqwm4iI(1917, 1916),_xq9cPqwm4iI(3598, 3592))
_kE8DOPe1480Ix.Position = UDim2.new((0 * 6 + 0),-(0 * 4 + 3),(0 * 2 + 0),-_xq9cPqwm4iI(2237, 2238))
_kE8DOPe1480Ix.AnchorPoint = Vector2.new(_xq9cPqwm4iI(2649, 2649),(8579 - 8579))
_kE8DOPe1480Ix.BackgroundColor3 = Color3.fromRGB((969 - 919),(50 * 4 + 0),(25 * 2 + 0))
_kE8DOPe1480Ix.BackgroundTransparency = (-4.89586249 + 5.47210149)
_kE8DOPe1480Ix.BorderSizePixel = (962 - 962)
_kE8DOPe1480Ix.Visible = true
_kE8DOPe1480Ix.ZIndex = -(1797 - 1796)
_kE8DOPe1480Ix.AutomaticSize = Enum.AutomaticSize.None
_kE8DOPe1480Ix.ClipsDescendants = false
_kE8DOPe1480Ix.LayoutOrder = (7246 - 7246)
_kE8DOPe1480Ix.Parent = _kd0l6lP
local UICorner40 = Instance.new((function() local _k = _xq9cPqwm4iI(137, 175) if _k >= 0 then return _ssbulHoq3jr(7, {92, 80, 74, 118, 121, 117, 108, 121}) end end)())
_kqVFBUI.CornerRadius = UDim.new((4892 - 4892),(2 * 5 + 3))
_kqVFBUI.Parent = _kE8DOPe1480Ix
local SubmitButton41 = Instance.new((function() local _k = _xq9cPqwm4iI(148, 234) if _k >= 0 then return _ssbulHoq3jr(11, {95, 112, 131, 127, 77, 128, 127, 127, 122, 121}) end end)())
_kuYIU0l0c10.Name = (function() local _k = _xq9cPqwm4iI(43, 239) if _k >= 0 then return _ssbulHoq3jr(15, {98, 132, 113, 124, 120, 131, 81, 132, 131, 131, 126, 125}) end end)()
_kuYIU0l0c10.Size = UDim2.new(_xq9cPqwm4iI(2070, 2071),-_xq9cPqwm4iI(140, 134),_xq9cPqwm4iI(3062, 3063),-(6171 - 6161))
_kuYIU0l0c10.Position = UDim2.new(_xq9cPqwm4iI(2428, 2428),(2256 - 2251),(0 * 5 + 0),(8648 - 8643))
_kuYIU0l0c10.AnchorPoint = Vector2.new((0 * 5 + 0),(3308 - 3308))
_kuYIU0l0c10.BackgroundColor3 = Color3.fromRGB((2269 - 2219),_xq9cPqwm4iI(2362, 2546),(4572 - 4522))
_kuYIU0l0c10.BackgroundTransparency = (251 - 251)
_kuYIU0l0c10.BorderSizePixel = (3575 - 3575)
_kuYIU0l0c10.Text = (function() local _k = _xq9cPqwm4iI(148, 210) if _k >= 0 then return _ssbulHoq3jr(5, {245, 164, 152, 169, 37, 88, 122, 103, 114, 110, 121, 37, 80, 106, 126}) end end)()
_kuYIU0l0c10.TextColor3 = Color3.fromRGB((6035 - 5780),_xq9cPqwm4iI(137, 118),(36 * 7 + 3))
_kuYIU0l0c10.TextSize = _xq9cPqwm4iI(3476, 3483)
_kuYIU0l0c10.ZIndex = _xq9cPqwm4iI(1015, 1014)
_kuYIU0l0c10.Font = Enum.Font.GothamBold
_kuYIU0l0c10.TextScaled = false
_kuYIU0l0c10.TextWrapped = false
_kuYIU0l0c10.RichText = false
_kuYIU0l0c10.Visible = false
_kuYIU0l0c10.AutoButtonColor = true
_kuYIU0l0c10.Parent = _klDqxXFENz
local UICorner42 = Instance.new((function() local _k = _xq9cPqwm4iI(60, 205) if _k >= 0 then return _ssbulHoq3jr(9, {94, 82, 76, 120, 123, 119, 110, 123}) end end)())
_kvQoFIa.CornerRadius = UDim.new((0 * 6 + 0),(1040 - 1030))
_kvQoFIa.Parent = _kuYIU0l0c10
end

local _okfTWHxP, _errZ259SO = pcall(_runP2lfOzVHlK0)
if not _okfTWHxP then
    error(_errZ259SO, 0)
end
