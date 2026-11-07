--========================================================
-- SYLLINSE V10.1 | OURO-INSPIRED VISUAL REDESIGN
-- UI-only dashboard build
--========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("SYLLINSE")
if old then old:Destroy() end

local VERSION = "V10.1  |  OURO INSPIRED"
local BG = Color3.fromRGB(10, 7, 12)
local PANEL = Color3.fromRGB(22, 12, 20)
local CARD = Color3.fromRGB(34, 18, 31)
local GOLD = Color3.fromRGB(235, 91, 170)
local WHITE = Color3.fromRGB(250, 239, 247)
local MUTED = Color3.fromRGB(169, 143, 160)
local ACCENT = GOLD

local function new(className, props, parent)
    local obj = Instance.new(className)
    for key, value in pairs(props) do obj[key] = value end
    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    new("UICorner", {CornerRadius = UDim.new(0, radius or 8)}, obj)
end

local function tween(obj, duration, props, style)
    local t = TweenService:Create(obj, TweenInfo.new(
        duration,
        style or Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut
    ), props)
    t:Play()
    return t
end

-- Fade ordinary GUI objects without CanvasGroup. This avoids nested
-- CanvasGroup texture limits on lower-memory mobile devices.
local function collectFadeTargets(root)
    local targets = {}
    local function collect(obj)
        if obj:IsA("GuiObject") then
            targets[#targets + 1] = {
                object = obj,
                property = "BackgroundTransparency",
                base = obj.BackgroundTransparency
            }
        end
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            targets[#targets + 1] = {object=obj, property="TextTransparency", base=obj.TextTransparency}
            targets[#targets + 1] = {object=obj, property="TextStrokeTransparency", base=obj.TextStrokeTransparency}
        elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            targets[#targets + 1] = {object=obj, property="ImageTransparency", base=obj.ImageTransparency}
        elseif obj:IsA("UIStroke") then
            targets[#targets + 1] = {object=obj, property="Transparency", base=obj.Transparency}
        end
    end
    collect(root)
    for _, obj in ipairs(root:GetDescendants()) do collect(obj) end
    return targets
end

local function setFade(targets, amount, duration)
    for _, item in ipairs(targets) do
        if item.object and item.object.Parent then
            local value = item.base + (1 - item.base) * amount
            tween(item.object, duration, {[item.property] = value})
        end
    end
end

-- Full-screen backdrop and interface
local gui = new("ScreenGui", {
    Name = "SYLLINSE",
    ResetOnSpawn = false,
    DisplayOrder = 100,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, playerGui)

-- Passive backdrop: dims the game but never captures joystick or jump touches.
local backdrop = new("Frame", {
    Name = "Dimmer",
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromScale(0, 0),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Active = false,
    Selectable = false,
    ZIndex = 1,
    Visible = true
}, gui)

local main = new("Frame", {
    Name = "Window",
    Size = UDim2.fromOffset(570, 360),
    Position = UDim2.new(0.5, -285, 0.5, -180),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    ZIndex = 2,
    Visible = true
}, gui)
corner(main, 18)
-- Declare scale before hide/show callbacks so they capture this local instance.
local scale=new("UIScale",{Scale=1},main)
local mainGlow = new("UIStroke", {Color=GOLD, Transparency=0.68, Thickness=5}, main)
local mainStroke = new("UIStroke", {Color=GOLD, Transparency=0.12, Thickness=1.6}, main)
local mainGlowTween=TweenService:Create(mainGlow,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Transparency=.38,Thickness=7})
mainGlowTween:Play()

local top = new("Frame", {
    Size=UDim2.new(1,0,0,52), BackgroundColor3=PANEL,
    BorderSizePixel=0, Active=true, ZIndex=3
}, main)
corner(top, 16)
new("UIGradient",{Rotation=0,Color=ColorSequence.new(Color3.fromRGB(48,22,42),Color3.fromRGB(17,10,18))},top)
new("Frame",{
    Name="HeaderGoldRule",Position=UDim2.new(0,18,1,-2),
    Size=UDim2.new(1,-36,0,1),BackgroundColor3=GOLD,
    BorderSizePixel=0,ZIndex=4
},top)
local livePill=new("Frame",{
    Name="LiveStatus",AnchorPoint=Vector2.new(1,.5),
    Position=UDim2.new(1,-54,.5,0),Size=UDim2.fromOffset(58,22),
    BackgroundColor3=Color3.fromRGB(27,29,25),BorderSizePixel=0,ZIndex=4
},top)
corner(livePill,11)
new("Frame",{
    Position=UDim2.fromOffset(8,8),Size=UDim2.fromOffset(6,6),
    BackgroundColor3=Color3.fromRGB(110,220,145),BorderSizePixel=0,ZIndex=5
},livePill)
new("TextLabel",{
    Position=UDim2.fromOffset(18,0),Size=UDim2.new(1,-20,1,0),
    BackgroundTransparency=1,Text="READY",TextColor3=Color3.fromRGB(170,210,180),
    Font=Enum.Font.GothamBold,TextSize=8,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5
},livePill)

local logo = new("TextLabel", {
    Position=UDim2.fromOffset(19,0), Size=UDim2.fromOffset(155,52),
    BackgroundTransparency=1, Text="✦  SYLLINSE", TextColor3=ACCENT,
    Font=Enum.Font.GothamBlack, TextSize=17,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4
}, top)

new("TextLabel", {
    Position=UDim2.fromOffset(184,0), Size=UDim2.fromOffset(190,52),
    BackgroundTransparency=1, Text=VERSION, TextColor3=MUTED,
    Font=Enum.Font.GothamMedium, TextSize=9,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4
}, top)

local close = new("TextButton", {
    AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-12,0.5,0),
    Size=UDim2.fromOffset(28,28), BackgroundColor3=CARD,
    Text="×", TextColor3=WHITE, Font=Enum.Font.GothamBold,
    TextSize=19, AutoButtonColor=false, ZIndex=4
}, top)
corner(close, 7)

local sidebar = new("Frame", {
    Position=UDim2.fromOffset(0,52), Size=UDim2.new(0,140,1,-52),
    BackgroundColor3=PANEL, BorderSizePixel=0, ZIndex=3
}, main)

new("TextLabel", {
    Position=UDim2.fromOffset(16,17), Size=UDim2.new(1,-24,0,18),
    BackgroundTransparency=1, Text="NAVIGATION", TextColor3=MUTED,
    Font=Enum.Font.GothamBold, TextSize=9,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4
}, sidebar)

local nav = new("Frame", {
    Position=UDim2.fromOffset(9,46), Size=UDim2.new(1,-18,0,220),
    BackgroundTransparency=1, ZIndex=4
}, sidebar)
new("UIListLayout", {Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder}, nav)

local content = new("Frame", {
    Position=UDim2.fromOffset(151,64), Size=UDim2.new(1,-163,1,-74),
    BackgroundTransparency=1, ClipsDescendants=true, ZIndex=3
}, main)

local heading = new("TextLabel", {
    Size=UDim2.new(1,0,0,30), BackgroundTransparency=1,
    Text="Home", TextColor3=WHITE, Font=Enum.Font.GothamBold,
    TextSize=18, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4
}, content)

local pages, tabs, cards = {}, {}, {}
local tabInfo = {{"Home","⌂"},{"Player","◉"},{"Visuals","◈"},{"Settings","⚙"},{"About","ⓘ"}}

local function createPage(name)
    local page = new("ScrollingFrame", {
        Name=name, Position=UDim2.fromOffset(0,39),
        Size=UDim2.new(1,0,1,-39), BackgroundTransparency=1,
        ClipsDescendants=true, CanvasSize=UDim2.fromOffset(0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ScrollingDirection=Enum.ScrollingDirection.Y,
        ScrollBarThickness=3, ScrollBarImageColor3=ACCENT,
        Visible=false, ZIndex=4
    }, content)
    new("UIGridLayout", {
        CellSize=UDim2.new(0.5,-6,0,82),
        CellPadding=UDim2.fromOffset(10,10),
        SortOrder=Enum.SortOrder.LayoutOrder
    }, page)
    pages[name] = page
    return page
end

for _, info in ipairs(tabInfo) do
    local name, symbol = info[1], info[2]
    local button = new("TextButton", {
        Size=UDim2.new(1,0,0,35), BackgroundColor3=PANEL,
        Text="   "..symbol.."    "..name, TextColor3=MUTED,
        Font=Enum.Font.GothamSemibold, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left,
        AutoButtonColor=false, ZIndex=5
    }, nav)
    corner(button, 10)
    local indicator = new("Frame", {
        Size=UDim2.new(0,3,0,0), Position=UDim2.fromOffset(0,17),
        BackgroundColor3=ACCENT, BorderSizePixel=0, ZIndex=6
    }, button)
    corner(indicator, 4)
    tabs[name] = {button=button, indicator=indicator}
    createPage(name)
end

local function createCard(parent, title, description)
    local card = new("Frame", {
        Name=title, BackgroundColor3=CARD,
        BorderSizePixel=0, ZIndex=5
    }, parent)
    corner(card, 12)
    new("UIStroke", {Color=ACCENT, Transparency=0.72, Thickness=1}, card)
    new("UIGradient",{Rotation=90,Color=ColorSequence.new(Color3.fromRGB(49,25,43),Color3.fromRGB(25,13,24))},card)
    new("TextLabel", {
        Position=UDim2.fromOffset(10,8), Size=UDim2.new(1,-18,0,18),
        BackgroundTransparency=1, Text=title, TextColor3=WHITE,
        Font=Enum.Font.GothamSemibold, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6
    }, card)
    new("TextLabel", {
        Position=UDim2.fromOffset(10,29), Size=UDim2.new(1,-18,0,28),
        BackgroundTransparency=1, Text=description, TextColor3=MUTED,
        Font=Enum.Font.Gotham, TextSize=9, TextWrapped=true,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Top, ZIndex=6
    }, card)
    cards[#cards+1] = card
    return card
end

local function addStat(parent, title, initial)
    local card = createCard(parent, title, initial)
    local value = new("TextLabel", {
        Position=UDim2.fromOffset(10,31), Size=UDim2.new(1,-18,0,30),
        BackgroundTransparency=1, Text=initial, TextColor3=ACCENT,
        Font=Enum.Font.GothamBlack, TextSize=19,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6
    }, card)
    return value
end

local function addToggle(parent, title, description, callback)
    local card = createCard(parent, title, description)
    local enabled, dragging = false, false

    -- Transparent full-card hit target: tap anywhere except the visible switch.
    local cardHit = new("TextButton", {
        Name="FullCardToggleHitbox", Size=UDim2.fromScale(1,1),
        BackgroundTransparency=1, Text="", AutoButtonColor=false,
        Active=true, Interactable=true, ZIndex=6
    }, card)

    local track = new("TextButton", {
        AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0),
        Size=UDim2.fromOffset(48,26), BackgroundColor3=Color3.fromRGB(55,55,55),
        Text="", AutoButtonColor=false, Active=true, Interactable=true, ZIndex=8
    }, card)
    corner(track, 20)
    local outline = new("UIStroke", {Color=MUTED, Transparency=0.6}, track)
    local knob = new("Frame", {
        Position=UDim2.fromOffset(4,4), Size=UDim2.fromOffset(18,18),
        BackgroundColor3=WHITE, BorderSizePixel=0, ZIndex=9
    }, track)
    corner(knob, 20)

    local function setEnabled(value)
        if enabled == value then return end
        enabled = value
        tween(track,.18,{BackgroundColor3=enabled and ACCENT or Color3.fromRGB(55,55,55)})
        tween(knob,.18,{Position=enabled and UDim2.new(1,-22,0,4) or UDim2.fromOffset(4,4)})
        tween(outline,.18,{Color=enabled and ACCENT or MUTED,Transparency=enabled and .1 or .6})
        if callback then
            local ok,err=pcall(callback,enabled)
            if not ok then warn("[SYLLINSE] Toggle callback:",err) end
        end
    end

    cardHit.Activated:Connect(function() setEnabled(not enabled) end)
    track.Activated:Connect(function() setEnabled(not enabled) end)

    local function beginDrag(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            setEnabled(input.Position.X>=track.AbsolutePosition.X+track.AbsoluteSize.X/2)
        end
    end
    knob.InputBegan:Connect(beginDrag)
    track.InputBegan:Connect(beginDrag)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
            setEnabled(input.Position.X>=track.AbsolutePosition.X+track.AbsoluteSize.X/2)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=false
        end
    end)
    return card
end
local function addButton(parent, title, description, callback)
    local card = createCard(parent,title,description)
    local button = new("TextButton", {
        AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0),
        Size=UDim2.fromOffset(48,24), BackgroundColor3=ACCENT,
        Text="OPEN", TextColor3=BG, Font=Enum.Font.GothamBold,
        TextSize=9, AutoButtonColor=false, ZIndex=7
    },card)
    corner(button,5)
    button.Activated:Connect(function()
        tween(button,0.08,{Size=UDim2.fromOffset(44,21)})
        task.delay(0.1,function()
            if button.Parent then tween(button,0.14,{Size=UDim2.fromOffset(48,24)}) end
        end)
        if callback then
            local ok,err=pcall(callback)
            if not ok then warn("[SYLLINSE] Button callback:",err) end
        end
    end)
    return card
end

-- Home dashboard
_G.SYLLINSE_LAUNCHES = (_G.SYLLINSE_LAUNCHES or 0) + 1
local fpsValue = addStat(pages.Home,"FPS","--")
local pingValue = addStat(pages.Home,"PING","--")
local sessionValue = addStat(pages.Home,"SESSION TIME","00:00")
local launchValue = addStat(pages.Home,"LOCAL LAUNCHES",tostring(_G.SYLLINSE_LAUNCHES))
local gameCard = createCard(pages.Home,"CURRENT GAME",game.Name)
createCard(pages.Home,"SCRIPT VERSION",VERSION)
createCard(pages.Home,"GLOBAL EXECUTIONS","Not connected to a statistics service")

-- Demo-only controls: these do not modify gameplay.
addToggle(pages.Player,"Player Demo","UI demonstration switch",function(v) print("Player demo:",v) end)
addToggle(pages.Player,"Movement Demo","UI demonstration switch",function(v) print("Movement demo:",v) end)
addButton(pages.Player,"Reset Demo","Test button interaction",function() print("Reset demo") end)
addToggle(pages.Visuals,"Visual Demo","UI demonstration switch",function(v) print("Visual demo:",v) end)
addToggle(pages.Visuals,"Highlight Demo","UI demonstration switch",function(v) print("Highlight demo:",v) end)
addButton(pages.Visuals,"Preview","Test button interaction",function() print("Preview clicked") end)
addToggle(pages.Settings,"Interface Effects","UI demonstration setting",function(v) print("Interface effects:",v) end)
addButton(pages.Settings,"Refresh","Refresh dashboard values",function()
    launchValue.Text=tostring(_G.SYLLINSE_LAUNCHES)
    local label=gameCard:FindFirstChildWhichIsA("TextLabel")
    if label then label.Text=game.Name end
end)
addButton(pages.About,"SYLLINSE V10.1","Ouro-Inspired Edition",function() print(VERSION) end)
addButton(pages.About,"Developer","SYLLINSE project",function() print("SYLLINSE") end)

-- Live stats
local started, frames, last = os.clock(), 0, os.clock()
RunService.RenderStepped:Connect(function()
    frames += 1
    local now=os.clock()
    if now-last >= 1 then
        fpsValue.Text=tostring(math.floor(frames/(now-last)))
        frames=0
        last=now
        local elapsed=math.floor(now-started)
        sessionValue.Text=string.format("%02d:%02d",math.floor(elapsed/60),elapsed%60)
        local ok,ping=pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        end)
        pingValue.Text=ok and tostring(ping) or "N/A"
    end
end)

-- Animated modal colour picker with explicit Apply / Cancel behaviour.
local themeButton = new("TextButton", {
    AnchorPoint=Vector2.new(0.5,1), Position=UDim2.new(0.5,0,1,-12),
    Size=UDim2.new(1,-16,0,32), BackgroundColor3=CARD,
    Text="  ◉  CHANGE THEME", TextColor3=ACCENT,
    Font=Enum.Font.GothamBold, TextSize=9, AutoButtonColor=false, ZIndex=7
},sidebar)
corner(themeButton,7)

local pickerShade = new("Frame", {
    Name="ThemePickerShade", Size=UDim2.fromScale(1,1),
    BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=1,
    BorderSizePixel=0, Visible=false, Active=false, ZIndex=30
},gui)
local picker = new("Frame", {
    Name="ThemePicker", AnchorPoint=Vector2.new(.5,.5),
    Position=UDim2.fromScale(.5,.5), Size=UDim2.fromOffset(300,360),
    BackgroundColor3=PANEL, BorderSizePixel=0, Visible=false, ZIndex=31
},gui)
corner(picker,14)
local pickerStroke=new("UIStroke",{Color=ACCENT,Transparency=.25,Thickness=1},picker)
new("TextLabel",{
    Position=UDim2.fromOffset(18,13),Size=UDim2.new(1,-36,0,25),
    BackgroundTransparency=1,Text="CHOOSE YOUR COLOUR",
    TextColor3=WHITE,Font=Enum.Font.GothamBlack,TextSize=13,
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=32
},picker)

-- Filled Mac-style colour wheel, with a live magnifier and brightness control.
local wheel=new("Frame",{
    AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,0,145),
    Size=UDim2.fromOffset(204,204),BackgroundColor3=CARD,
    BorderSizePixel=0,ClipsDescendants=true,ZIndex=32
},picker)
new("UIAspectRatioConstraint",{AspectRatio=1},wheel)
corner(wheel,102)
new("UIStroke",{Color=Color3.fromRGB(75,75,75),Transparency=.25,Thickness=1},wheel)

local hue,saturation,brightness=.12,.88,.98
local wheelDragging=false
local committedAccent=ACCENT
local wheelCenter
local doneButton
local magnifier
local brightnessFill
local brightnessKnob
local function applyAccent(color)
    ACCENT=color
    tween(logo,.16,{TextColor3=color})
    tween(themeButton,.16,{TextColor3=color})
    tween(mainStroke,.16,{Color=color})
    tween(pickerStroke,.16,{Color=color})
    if wheelCenter then tween(wheelCenter,.12,{BackgroundColor3=color}) end
    if doneButton then tween(doneButton,.12,{BackgroundColor3=color}) end
    if brightnessFill then brightnessFill.BackgroundColor3=color end
    local floatingButton=gui:FindFirstChild("FloatingToggle")
    if floatingButton then tween(floatingButton,.16,{BackgroundColor3=color}) end
    for _,data in pairs(tabs) do tween(data.indicator,.16,{BackgroundColor3=color}) end
    for _,obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("UIStroke") then obj.Color=color end
        if obj:IsA("TextButton") and obj.Text=="OPEN" then obj.BackgroundColor3=color end
    end
    fpsValue.TextColor3=color
    pingValue.TextColor3=color
    sessionValue.TextColor3=color
    launchValue.TextColor3=color
end

local function currentColor()
    return Color3.fromHSV(hue,saturation,brightness)
end

-- Native circular HSV wheel using Roblox's conical + radial UIGradient types.
-- Conical gradient provides the continuous rainbow hue sweep.
-- A radial white overlay fades from white at the centre to transparent at the rim.
local hueLayer=new("Frame",{
    Name="HueRing",
    Size=UDim2.fromScale(1,1),
    BackgroundColor3=WHITE,
    BorderSizePixel=0,
    ZIndex=33
},wheel)
corner(hueLayer,102)

local hueGradient=new("UIGradient",{
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0.000,Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.167,Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(0.333,Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.500,Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.667,Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(0.833,Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1.000,Color3.fromRGB(255,0,0))
    }),
    Rotation=90
},hueLayer)
local conicalSupported=pcall(function()
    hueGradient.Type=Enum.GradientType.Conical
end)

local saturationLayer=new("Frame",{
    Name="WhiteSaturationFade",
    Size=UDim2.fromScale(1,1),
    BackgroundColor3=Color3.new(1,1,1),
    BorderSizePixel=0,
    ZIndex=34
},wheel)
corner(saturationLayer,102)
local saturationGradient=new("UIGradient",{
    Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,0),
        NumberSequenceKeypoint.new(1,1)
    })
},saturationLayer)
local radialSupported=pcall(function()
    saturationGradient.Type=Enum.GradientType.Radial
end)

if not conicalSupported or not radialSupported then
    warn("[SYLLINSE] Native radial/conical UIGradient is unavailable in this client.")
end

wheelCenter=new("Frame",{
    AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),
    Size=UDim2.fromOffset(14,14),BackgroundColor3=currentColor(),
    BorderSizePixel=0,ZIndex=40
},wheel)
corner(wheelCenter,7)
new("UIStroke",{Color=WHITE,Transparency=0,Thickness=2},wheelCenter)

-- Floating loupe follows the finger and previews the exact selected shade.
magnifier=new("Frame",{
    Size=UDim2.fromOffset(48,48),BackgroundColor3=currentColor(),
    BorderSizePixel=0,Visible=false,ZIndex=50
},wheel)
corner(magnifier,24)
new("UIStroke",{Color=WHITE,Thickness=3,Transparency=.08},magnifier)
local magText=new("TextLabel",{
    Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
    Text="●",TextColor3=BG,Font=Enum.Font.GothamBlack,
    TextSize=18,ZIndex=51
},magnifier)

local function updateColourFromPoint(point,showLoupe)
    local center=wheel.AbsolutePosition+wheel.AbsoluteSize/2
    local delta=point-center
    local radius=math.min(delta.Magnitude, wheel.AbsoluteSize.X/2-5)
    if delta.Magnitude>2 then
        hue=(math.atan2(delta.Y,delta.X)/(math.pi*2))%1
        saturation=math.clamp(radius/(wheel.AbsoluteSize.X/2-5),0,1)
    else
        saturation=0
    end
    local color=currentColor()
    applyAccent(color)
    if wheelCenter then
        wheelCenter.BackgroundColor3=color
        local markerX=wheel.AbsoluteSize.X/2+delta.X
        local markerY=wheel.AbsoluteSize.Y/2+delta.Y
        wheelCenter.Position=UDim2.fromOffset(markerX,markerY)
    end
    if magnifier then
        magnifier.BackgroundColor3=color
        magnifier.Visible=showLoupe
        local localX=point.X-wheel.AbsolutePosition.X
        local localY=point.Y-wheel.AbsolutePosition.Y-38
        magnifier.Position=UDim2.fromOffset(
            math.clamp(localX-24,0,wheel.AbsoluteSize.X-48),
            math.clamp(localY-24,0,wheel.AbsoluteSize.Y-48)
        )
    end
end

local function chooseHue(value)
    hue=value%1
    saturation=.88
    applyAccent(currentColor())
end

UIS.InputBegan:Connect(function(input)
    if not picker.Visible then return end
    local kind=input.UserInputType
    if kind~=Enum.UserInputType.Touch and kind~=Enum.UserInputType.MouseButton1 then return end
    local point=Vector2.new(input.Position.X,input.Position.Y)
    local wp,ws=wheel.AbsolutePosition,wheel.AbsoluteSize
    if point.X>=wp.X and point.X<=wp.X+ws.X and point.Y>=wp.Y and point.Y<=wp.Y+ws.Y then
        wheelDragging=true
        updateColourFromPoint(point,true)
    end
end)
UIS.InputChanged:Connect(function(input)
    if not picker.Visible or not wheelDragging then return end
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement then
        updateColourFromPoint(Vector2.new(input.Position.X,input.Position.Y),true)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
        wheelDragging=false
        if magnifier then magnifier.Visible=false end
    end
end)

-- Brightness slider below the wheel.
local brightnessTrack=new("Frame",{
    Position=UDim2.new(0,18,0,264),Size=UDim2.new(1,-36,0,12),
    BackgroundColor3=Color3.fromRGB(45,45,45),BorderSizePixel=0,ZIndex=34
},picker)
corner(brightnessTrack,8)
brightnessFill=new("Frame",{
    Size=UDim2.new(brightness,0,1,0),BackgroundColor3=currentColor(),
    BorderSizePixel=0,ZIndex=35
},brightnessTrack)
corner(brightnessFill,8)
new("UIGradient",{Color=ColorSequence.new(Color3.new(0,0,0),Color3.new(1,1,1))},brightnessFill)
brightnessKnob=new("Frame",{
    AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(brightness,0,.5,0),
    Size=UDim2.fromOffset(18,18),BackgroundColor3=WHITE,
    BorderSizePixel=0,ZIndex=36
},brightnessTrack)
corner(brightnessKnob,9)
new("UIStroke",{Color=BG,Thickness=1},brightnessKnob)
local brightnessDragging=false
local function setBrightnessFromX(x)
    brightness=math.clamp((x-brightnessTrack.AbsolutePosition.X)/brightnessTrack.AbsoluteSize.X,.08,1)
    brightnessFill.Size=UDim2.new(brightness,0,1,0)
    brightnessKnob.Position=UDim2.new(brightness,0,.5,0)
    applyAccent(currentColor())
end
brightnessTrack.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
        brightnessDragging=true
        setBrightnessFromX(input.Position.X)
    end
end)
UIS.InputChanged:Connect(function(input)
    if brightnessDragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
        setBrightnessFromX(input.Position.X)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then brightnessDragging=false end
end)

local pickerHint=new("TextLabel",{
    Position=UDim2.new(0,12,0,282),Size=UDim2.new(1,-24,0,14),
    BackgroundTransparency=1,Text="DRAG ON THE WHEEL • SLIDE TO ADJUST BRIGHTNESS",
    TextColor3=MUTED,Font=Enum.Font.GothamBold,TextSize=8,ZIndex=32
},picker)

doneButton=new("TextButton",{
    Position=UDim2.new(0,14,0,305),Size=UDim2.new(.5,-20,0,36),
    BackgroundColor3=ACCENT,Text="DONE",
    TextColor3=BG,Font=Enum.Font.GothamBlack,TextSize=11,
    AutoButtonColor=false,ZIndex=33
},picker)
corner(doneButton,8)
local cancelButton=new("TextButton",{
    AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-14,0,305),
    Size=UDim2.new(.5,-20,0,36),BackgroundColor3=CARD,
    Text="CLOSE",TextColor3=WHITE,Font=Enum.Font.GothamBold,
    TextSize=11,AutoButtonColor=false,ZIndex=33
},picker)
corner(cancelButton,8)
new("UIStroke",{Color=MUTED,Transparency=.65,Thickness=1},cancelButton)

local function openPicker()
    if picker.Visible then return end
    committedAccent=ACCENT
    main.Visible=false
    picker.Visible=true
    pickerShade.Visible=true
    pickerShade.BackgroundTransparency=1
    tween(pickerShade,.22,{BackgroundTransparency=.28})
    picker.Size=UDim2.fromOffset(270,330)
    picker.BackgroundTransparency=1
    tween(picker,.26,{Size=UDim2.fromOffset(300,360),BackgroundTransparency=0},Enum.EasingStyle.Back)
end

local pickerClosing=false
local function finishPicker(keepSelection)
    if not picker.Visible or pickerClosing then return end
    pickerClosing=true
    if keepSelection then
        committedAccent=ACCENT
    else
        applyAccent(committedAccent)
    end
    tween(pickerShade,.18,{BackgroundTransparency=1})
    tween(picker,.18,{Size=UDim2.fromOffset(270,330),BackgroundTransparency=1})
    task.delay(.19,function()
        picker.Visible=false
        pickerShade.Visible=false
        main.Visible=true
        picker.Size=UDim2.fromOffset(300,360)
        picker.BackgroundTransparency=0
        pickerClosing=false
    end)
end

themeButton.Activated:Connect(openPicker)
doneButton.Activated:Connect(function() finishPicker(true) end)
cancelButton.Activated:Connect(function() finishPicker(false) end)

-- Tabs slide horizontally and support left/right touch swipes.
local currentTab="Home"
local switching=false
local tabOrder={"Home","Player","Visuals","Settings","About"}
local tabPositions={}
for i,name in ipairs(tabOrder) do tabPositions[name]=i end
local function switchTab(name,direction)
    if switching or currentTab==name or not pages[name] then return end
    switching=true
    direction=direction or (tabPositions[name]>tabPositions[currentTab] and 1 or -1)
    for tabName,data in pairs(tabs) do
        local selected=tabName==name
        tween(data.button,.22,{BackgroundColor3=selected and CARD or PANEL,TextColor3=selected and ACCENT or MUTED})
        tween(data.indicator,.24,{Size=UDim2.new(0,3,0,selected and 19 or 0),Position=UDim2.fromOffset(0,selected and 8 or 17)})
    end
    local oldPage,newPage=pages[currentTab],pages[name]
    local width=math.max(content.AbsoluteSize.X,200)
    newPage.Position=UDim2.new(0,direction*width,0,39)
    newPage.Visible=true
    currentTab=name
    heading.Text=name
    tween(oldPage,.27,{Position=UDim2.new(0,-direction*width,0,39)})
    local slide=tween(newPage,.27,{Position=UDim2.fromOffset(0,39)})
    slide.Completed:Wait()
    oldPage.Visible=false
    oldPage.Position=UDim2.fromOffset(0,39)
    switching=false
end
for name,data in pairs(tabs) do
    data.name=name
    data.button.Activated:Connect(function() switchTab(name) end)
end
local swipeStart=nil
UIS.InputBegan:Connect(function(input,processed)
    if not main.Visible or picker.Visible or input.UserInputType~=Enum.UserInputType.Touch then return end
    local p=input.Position
    local pos,size=content.AbsolutePosition,content.AbsoluteSize
    if p.X>=pos.X and p.X<=pos.X+size.X and p.Y>=pos.Y and p.Y<=pos.Y+size.Y then swipeStart=p end
end)
UIS.InputEnded:Connect(function(input)
    if not swipeStart or input.UserInputType~=Enum.UserInputType.Touch then return end
    local delta=input.Position-swipeStart
    if math.abs(delta.X)>75 and math.abs(delta.X)>math.abs(delta.Y)*1.25 then
        local index=math.clamp(tabPositions[currentTab]+(delta.X<0 and 1 or -1),1,#tabOrder)
        switchTab(tabOrder[index],delta.X<0 and 1 or -1)
    end
    swipeStart=nil
end)

-- Floating S toggle. Keep this instance in scope for the gesture handlers below.
local floating=new("TextButton",{
    Name="FloatingToggle",
    AnchorPoint=Vector2.new(1,.5),
    Position=UDim2.new(1,-12,.5,0),
    Size=UDim2.fromOffset(44,44),
    BackgroundColor3=ACCENT,
    Text="S",TextColor3=BG,
    Font=Enum.Font.GothamBlack,TextSize=20,
    AutoButtonColor=false,Active=true,Interactable=true,
    Selectable=true,Visible=true,ZIndex=200
},gui)
corner(floating,22)

-- Dock rises above the toggle; its lower edge meets the toggle's vertical midpoint.
local dock=new("Frame",{
    Name="FloatingNavigationDock",
    AnchorPoint=Vector2.new(.5,1),
    Position=UDim2.fromOffset(0,0),
    Size=UDim2.fromOffset(44,176),
    BackgroundTransparency=1,
    Visible=false,
    ZIndex=201
},floating)
local dockScale=new("UIScale",{Scale=1},dock)
local dockBase=new("Frame",{
    Name="DockBase",
    Position=UDim2.fromOffset(0,0),
    Size=UDim2.fromOffset(44,176),
    BackgroundColor3=Color3.fromRGB(30,14,27),
    BorderSizePixel=0,ZIndex=202
},dock)
corner(dockBase,30)
local dockGlow=new("UIStroke",{Color=GOLD,Thickness=6,Transparency=.58},dockBase)
local dockStroke=new("UIStroke",{Color=GOLD,Thickness=1.6,Transparency=.08},dockBase)
local dockGlowTween=TweenService:Create(dockGlow,TweenInfo.new(1.35,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Transparency=.28,Thickness=8})
dockGlowTween:Play()

local dockButtons={}
local showWindow -- forward declaration: dock actions must call the local window opener
local dockTabs={{"Home","⌂"},{"Player","▤"},{"About","♙"}}
for index,info in ipairs(dockTabs) do
    local tabName,glyph=info[1],info[2]
    local button=new("TextButton",{
        Name="Dock"..tabName,
        Position=UDim2.fromOffset(0,(index-1)*44),
        Size=UDim2.fromOffset(44,44),
        BackgroundTransparency=1,
        Text=glyph,TextColor3=Color3.fromRGB(205,205,205),
        Font=Enum.Font.Gotham,TextSize=29,
        AutoButtonColor=false,ZIndex=203
    },dockBase)
    if index<3 then
        new("Frame",{
            Position=UDim2.new(0,13,1,-1),Size=UDim2.fromOffset(32,1),
            BackgroundColor3=Color3.fromRGB(5,5,6),
            BorderSizePixel=0,ZIndex=204
        },button)
    end
    local underline=new("Frame",{
        Name="GoldIndicator",AnchorPoint=Vector2.new(0, .5),
        Position=UDim2.new(0,2,.5,0),Size=UDim2.fromOffset(3,0),
        BackgroundColor3=GOLD,BorderSizePixel=0,ZIndex=73
    },button)
    corner(underline,3)
    dockButtons[tabName]={button=button,indicator=underline}
    button.Activated:Connect(function()
        if not main.Visible then showWindow() end
        switchTab(tabName)
    end)
end

local menuButton=new("TextButton",{
    Name="DockMenuButton",Position=UDim2.fromOffset(0,132),
    Size=UDim2.fromOffset(44,44),BackgroundColor3=Color3.fromRGB(43,18,36),
    BorderSizePixel=0,Text="☰",TextColor3=WHITE,
    Font=Enum.Font.Gotham,TextSize=25,AutoButtonColor=false,ZIndex=72
},dockBase)
corner(menuButton,18)
local menuGlow=new("UIStroke",{Color=GOLD,Thickness=2.5,Transparency=.08},menuButton)
local sidebarExpanded=true
menuButton.Activated:Connect(function()
    if not main.Visible then
        showWindow()
        return
    end
    sidebarExpanded=not sidebarExpanded
    if sidebarExpanded then
        sidebar.Visible=true
        tween(content,.28,{Position=UDim2.fromOffset(151,64),Size=UDim2.new(1,-163,1,-74)},Enum.EasingStyle.Quart)
        tween(menuGlow,.25,{Transparency=.08,Thickness=2.5})
    else
        tween(content,.28,{Position=UDim2.fromOffset(16,64),Size=UDim2.new(1,-32,1,-74)},Enum.EasingStyle.Quart)
        tween(menuGlow,.25,{Transparency=.42,Thickness=1.5})
        task.delay(.29,function()
            if not sidebarExpanded then sidebar.Visible=false end
        end)
    end
end)

local function updateDockSelection(activeName)
    for name,data in pairs(dockButtons) do
        local active=name==activeName
        tween(data.button,.2,{TextColor3=active and WHITE or Color3.fromRGB(155,155,155)})
        tween(data.indicator,.22,{Size=UDim2.fromOffset(3,active and 28 or 0)})
    end
end
local previousSwitchTab=switchTab
switchTab=function(name,direction)
    previousSwitchTab(name,direction)
    updateDockSelection(name)
end

-- Reliable hide/reopen controls.
-- The X hides the dashboard; the floating S restores it.
local mainFadeTargets=collectFadeTargets(main)
local animating=false
local function hideWindow()
    if animating or (not main.Visible and not picker.Visible) then return end
    animating=true
    picker.Visible=false
    pickerShade.Visible=false
    pickerClosing=false
    wheelDragging=false
    dock.Visible=false
    local shownScale=scale.Scale
    tween(backdrop,1.2,{BackgroundTransparency=1},Enum.EasingStyle.Quart)
    tween(scale,1.2,{Scale=shownScale*.96},Enum.EasingStyle.Quart)
    setFade(mainFadeTargets,1,1.2)
    task.delay(1.22,function()
        main.Visible=false
        scale.Scale=shownScale
        animating=false
    end)
end
showWindow=function()
    if animating or main.Visible or picker.Visible then return end
    animating=true
    main.Visible=true
    dock.Visible=false
    local shownScale=scale.Scale
    scale.Scale=shownScale*.96
    setFade(mainFadeTargets,1,0)
    tween(backdrop,1.2,{BackgroundTransparency=.43},Enum.EasingStyle.Quart)
    tween(scale,1.2,{Scale=shownScale},Enum.EasingStyle.Quart)
    setFade(mainFadeTargets,0,1.2)
    task.delay(1.22,function() animating=false end)
end
close.Active=true
close.Activated:Connect(function()
    dock.Visible=false
    hideWindow()
end)
-- Floating toggle: short tap hides/shows, hold reveals dock, drag moves it.
local floatingPress,floatingStart,floatingOrigin
local floatingMoved=false
local floatingDragging=false
local holdTriggered=false
local holdToken=0
local HOLD_TIME=.48

local function revealDock()
    if animating then return end
    -- Dock is parented to the toggle, so it shares the toggle position while dragged.
    dock.AnchorPoint=Vector2.new(.5,1)
    dock.Position=UDim2.new(.5,0,0,30)
    dock.Visible=true
    dockScale.Scale=.96
    tween(floating,.46,{Rotation=180},Enum.EasingStyle.Quart)
    tween(dockScale,.46,{Scale=1},Enum.EasingStyle.Quart)
    tween(dock,.46,{Position=UDim2.new(.5,0,0,22)},Enum.EasingStyle.Quart)
end

floating.InputBegan:Connect(function(input)
    if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseButton1 then return end
    floatingPress=input
    floatingStart=Vector2.new(input.Position.X,input.Position.Y)
    floatingOrigin=floating.Position
    floatingMoved=false
    floatingDragging=true
    holdTriggered=false
    holdToken+=1
    local thisToken=holdToken
    task.delay(HOLD_TIME,function()
        if floatingDragging and floatingPress and holdToken==thisToken and not floatingMoved then
            holdTriggered=true
            if dock.Visible then
                tween(dockScale,.2,{Scale=.88})
                tween(floating,.32,{Rotation=0},Enum.EasingStyle.Quart)
                task.delay(.21,function() if dock.Parent then dock.Visible=false end end)
            else
                revealDock()
            end
        end
    end)
end)

UIS.InputChanged:Connect(function(input)
    if not floatingDragging or not floatingPress then return end
    local isMove=(input.UserInputType==Enum.UserInputType.Touch and input==floatingPress)
        or input.UserInputType==Enum.UserInputType.MouseMovement
    if not isMove then return end
    local point=Vector2.new(input.Position.X,input.Position.Y)
    local delta=point-floatingStart
    if delta.Magnitude>8 then
        floatingMoved=true
        holdToken+=1
    end
    if floatingMoved then
        floating.Position=UDim2.new(
            floatingOrigin.X.Scale,floatingOrigin.X.Offset+delta.X,
            floatingOrigin.Y.Scale,floatingOrigin.Y.Offset+delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if not floatingDragging or not floatingPress then return end
    local sameTouch=input.UserInputType==Enum.UserInputType.Touch
        and floatingPress.UserInputType==Enum.UserInputType.Touch
    local sameMouse=input.UserInputType==Enum.UserInputType.MouseButton1
        and floatingPress.UserInputType==Enum.UserInputType.MouseButton1
    if input~=floatingPress and not sameTouch and not sameMouse then return end

    local wasMoved,wasHeld=floatingMoved,holdTriggered
    floatingDragging=false
    floatingPress=nil
    holdToken+=1

    -- A hold is ONLY for showing/hiding the dock. It must never toggle the window.
    -- A short, unmoved tap is the ONLY gesture that toggles the main window.
    if not wasMoved and not wasHeld then
        dock.Visible=false
        tween(floating,.28,{Rotation=0},Enum.EasingStyle.Quart)
        if main.Visible or picker.Visible then
            hideWindow()
        else
            showWindow()
        end
    end
end)

-- Responsive sizing
local function updateScale()
    local camera=workspace.CurrentCamera
    if not camera then return end
    local size=camera.ViewportSize
    scale.Scale=math.clamp(math.min((size.X-20)/570,(size.Y-20)/360),.55,1)
end
updateScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

-- Initial selected tab and smooth execution fade-in.
pages.Home.Visible=true
for name,data in pairs(tabs) do
    local selected=name=="Home"
    data.button.BackgroundColor3=selected and CARD or PANEL
    data.button.TextColor3=selected and ACCENT or MUTED
    if selected then
        data.indicator.Size=UDim2.new(0,3,0,19)
        data.indicator.Position=UDim2.fromOffset(0,8)
    end
end
applyAccent(GOLD)
local initialFade=collectFadeTargets(main)
setFade(initialFade,1,0)
backdrop.BackgroundTransparency=1
local finalPosition=UDim2.new(0.5,-285,0.5,-180)
main.Position=UDim2.new(0.5,-285,0.5,-166)
local finalScale=scale.Scale
scale.Scale=finalScale*.96
tween(backdrop,1.2,{BackgroundTransparency=.43},Enum.EasingStyle.Quart)
tween(main,1.2,{Position=finalPosition},Enum.EasingStyle.Quart)
tween(scale,1.2,{Scale=finalScale},Enum.EasingStyle.Quart)
setFade(initialFade,0,1.2)

print("[SYLLINSE] "..VERSION.." loaded")
