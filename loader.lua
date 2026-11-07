--========================================================
-- SYLLINSE V8.1 | GOLD MOTION
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

local VERSION = "V8.1 GOLD MOTION"
local BG = Color3.fromRGB(8, 8, 9)
local PANEL = Color3.fromRGB(16, 16, 17)
local CARD = Color3.fromRGB(24, 23, 20)
local GOLD = Color3.fromRGB(212, 175, 55)
local WHITE = Color3.fromRGB(245, 242, 232)
local MUTED = Color3.fromRGB(145, 143, 135)
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

local backdrop = new("TextButton", {
    Name = "Dimmer",
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromScale(0, 0),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 1,
    Text = "",
    AutoButtonColor = false,
    BorderSizePixel = 0,
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
corner(main, 12)
local mainStroke = new("UIStroke", {Color=ACCENT, Transparency=0.3, Thickness=1}, main)

local top = new("Frame", {
    Size=UDim2.new(1,0,0,46), BackgroundColor3=PANEL,
    BorderSizePixel=0, ZIndex=3
}, main)
corner(top, 10)

local logo = new("TextLabel", {
    Position=UDim2.fromOffset(16,0), Size=UDim2.fromOffset(155,46),
    BackgroundTransparency=1, Text="◈  SYLLINSE", TextColor3=ACCENT,
    Font=Enum.Font.GothamBlack, TextSize=16,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4
}, top)

new("TextLabel", {
    Position=UDim2.fromOffset(170,0), Size=UDim2.fromOffset(160,46),
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
    Position=UDim2.fromOffset(0,46), Size=UDim2.new(0,132,1,-46),
    BackgroundColor3=PANEL, BorderSizePixel=0, ZIndex=3
}, main)

new("TextLabel", {
    Position=UDim2.fromOffset(14,13), Size=UDim2.new(1,-20,0,18),
    BackgroundTransparency=1, Text="NAVIGATION", TextColor3=MUTED,
    Font=Enum.Font.GothamBold, TextSize=9,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4
}, sidebar)

local nav = new("Frame", {
    Position=UDim2.fromOffset(8,40), Size=UDim2.new(1,-16,0,220),
    BackgroundTransparency=1, ZIndex=4
}, sidebar)
new("UIListLayout", {Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder}, nav)

local content = new("Frame", {
    Position=UDim2.fromOffset(143,57), Size=UDim2.new(1,-154,1,-67),
    BackgroundTransparency=1, ZIndex=3
}, main)

local heading = new("TextLabel", {
    Size=UDim2.new(1,0,0,30), BackgroundTransparency=1,
    Text="Home", TextColor3=WHITE, Font=Enum.Font.GothamBold,
    TextSize=18, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4
}, content)

local pages, tabs, cards = {}, {}, {}
local tabInfo = {{"Home","⌂"},{"Player","◉"},{"Visuals","◈"},{"Settings","⚙"},{"About","ⓘ"}}

local function createPage(name)
    local page = new("Frame", {
        Name=name, Position=UDim2.fromOffset(0,39),
        Size=UDim2.new(1,0,1,-39), BackgroundTransparency=1,
        Visible=false, ZIndex=4
    }, content)
    new("UIGridLayout", {
        CellSize=UDim2.new(0.5,-6,0,75),
        CellPadding=UDim2.fromOffset(9,9),
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
    corner(button, 7)
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
    corner(card, 8)
    new("UIStroke", {Color=ACCENT, Transparency=0.78, Thickness=1}, card)
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
    local track = new("TextButton", {
        AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0),
        Size=UDim2.fromOffset(40,22), BackgroundColor3=Color3.fromRGB(55,55,55),
        Text="", AutoButtonColor=false, ZIndex=7
    }, card)
    corner(track, 20)
    local outline = new("UIStroke", {Color=MUTED, Transparency=0.6}, track)
    local knob = new("Frame", {
        Position=UDim2.fromOffset(3,3), Size=UDim2.fromOffset(16,16),
        BackgroundColor3=WHITE, BorderSizePixel=0, ZIndex=8
    }, track)
    corner(knob, 20)
    local enabled, dragging = false, false

    local function setEnabled(value)
        if enabled == value then return end
        enabled = value
        tween(track,0.18,{BackgroundColor3=enabled and ACCENT or Color3.fromRGB(55,55,55)})
        tween(knob,0.18,{Position=enabled and UDim2.new(1,-19,0,3) or UDim2.fromOffset(3,3)})
        tween(outline,0.18,{Color=enabled and ACCENT or MUTED,Transparency=enabled and 0.1 or 0.6})
        if callback then
            local ok, err = pcall(callback, enabled)
            if not ok then warn("[SYLLINSE] Toggle callback:",err) end
        end
    end

    track.Activated:Connect(function()
        if not dragging then setEnabled(not enabled) end
    end)

    local function beginDrag(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            setEnabled(input.Position.X >= track.AbsolutePosition.X + track.AbsoluteSize.X/2)
        end
    end
    knob.InputBegan:Connect(beginDrag)
    track.InputBegan:Connect(beginDrag)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            setEnabled(input.Position.X >= track.AbsolutePosition.X + track.AbsoluteSize.X/2)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
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
addButton(pages.About,"SYLLINSE V8.1","Gold Motion Edition",function() print(VERSION) end)
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

-- Bottom hue slider
local themeButton = new("TextButton", {
    AnchorPoint=Vector2.new(0.5,1), Position=UDim2.new(0.5,0,1,-12),
    Size=UDim2.new(1,-16,0,32), BackgroundColor3=CARD,
    Text="  ◉  CUSTOM COLOUR", TextColor3=ACCENT,
    Font=Enum.Font.GothamBold, TextSize=9, AutoButtonColor=false, ZIndex=7
},sidebar)
corner(themeButton,7)

local popup = new("Frame", {
    Position=UDim2.new(0,8,1,-105), Size=UDim2.new(1,-16,0,85),
    BackgroundColor3=CARD, Visible=false, ZIndex=10
},sidebar)
corner(popup,8)
new("UIStroke",{Color=ACCENT,Transparency=0.3},popup)
new("TextLabel",{
    Position=UDim2.fromOffset(8,5),Size=UDim2.new(1,-16,0,18),
    BackgroundTransparency=1,Text="DRAG TO CHANGE COLOUR",
    TextColor3=WHITE,Font=Enum.Font.GothamBold,TextSize=8,ZIndex=11
},popup)

local hueBar=new("Frame",{
    Position=UDim2.fromOffset(9,36),Size=UDim2.new(1,-18,0,18),
    BackgroundColor3=WHITE,BorderSizePixel=0,ZIndex=11
},popup)
corner(hueBar,8)
new("UIGradient",{
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(.17,Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(.33,Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(.5,Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(.67,Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(.83,Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))
    })
},hueBar)
local hueKnob=new("Frame",{
    Position=UDim2.new(.12,-5,.5,-5),Size=UDim2.fromOffset(10,28),
    BackgroundColor3=WHITE,BorderSizePixel=0,ZIndex=12
},hueBar)
corner(hueKnob,6)
new("UIStroke",{Color=Color3.new(0,0,0),Thickness=1},hueKnob)

local hue, sliderDragging = .12, false
local function applyAccent(color)
    ACCENT=color
    tween(logo,.12,{TextColor3=color})
    tween(themeButton,.12,{TextColor3=color})
    tween(mainStroke,.12,{Color=color})
    for _,data in pairs(tabs) do
        tween(data.indicator,.12,{BackgroundColor3=color})
        if data.name==currentTab then tween(data.button,.12,{TextColor3=color}) end
    end
    for _,obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("UIStroke") then obj.Color=color end
        if obj:IsA("TextButton") and obj.Text=="OPEN" then obj.BackgroundColor3=color end
    end
    fpsValue.TextColor3=color
    pingValue.TextColor3=color
    sessionValue.TextColor3=color
    launchValue.TextColor3=color
end
local function setHue(x)
    local width=math.max(1,hueBar.AbsoluteSize.X)
    hue=math.clamp((x-hueBar.AbsolutePosition.X)/width,0,1)
    hueKnob.Position=UDim2.new(hue,-5,.5,-5)
    applyAccent(Color3.fromHSV(hue,.72,.83))
end
hueBar.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
        sliderDragging=true
        setHue(input.Position.X)
    end
end)
hueKnob.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
        sliderDragging=true
    end
end)
UIS.InputChanged:Connect(function(input)
    if sliderDragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
        setHue(input.Position.X)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
        sliderDragging=false
    end
end)
themeButton.Activated:Connect(function() popup.Visible=not popup.Visible end)

-- Tab transitions: use per-object transparency, not nested CanvasGroups.
local currentTab="Home"
local switching=false
local pageFadeTargets={}
for name,page in pairs(pages) do pageFadeTargets[name]=collectFadeTargets(page) end
local function switchTab(name)
    if switching or currentTab==name then return end
    switching=true
    local oldName=currentTab
    for tabName,data in pairs(tabs) do
        local selected=tabName==name
        tween(data.button,.22,{BackgroundColor3=selected and CARD or PANEL,TextColor3=selected and ACCENT or MUTED})
        tween(data.indicator,.24,{
            Size=UDim2.new(0,3,0,selected and 19 or 0),
            Position=UDim2.fromOffset(0,selected and 8 or 17)
        })
    end
    setFade(pageFadeTargets[oldName],1,.18)
    task.wait(.19)
    pages[oldName].Visible=false
    currentTab=name
    heading.Text=name
    pages[name].Visible=true
    setFade(pageFadeTargets[name],1,0)
    setFade(pageFadeTargets[name],0,.34)
    task.wait(.35)
    switching=false
end

for name,data in pairs(tabs) do
    data.name=name
    data.button.Activated:Connect(function() switchTab(name) end)
end

-- Floating reopen button
local floating=new("TextButton",{
    AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-12,.5,0),
    Size=UDim2.fromOffset(44,44),BackgroundColor3=ACCENT,
    Text="S",TextColor3=BG,Font=Enum.Font.GothamBlack,
    TextSize=20,AutoButtonColor=false,ZIndex=20
},gui)
corner(floating,22)

-- Window dragging
local dragging, dragStart, startPos=false,nil,nil
top.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true
        dragStart=input.Position
        startPos=main.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
        local delta=input.Position-dragStart
        main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)

-- Full-window fade, including every tab, card, label and control.
local mainFadeTargets=collectFadeTargets(main)
local open=true
local animating=false
local function setOpen(state)
    if animating or open==state then return end
    open=state
    animating=true
    if state then
        main.Visible=true
        setFade(mainFadeTargets,1,0)
        tween(backdrop,1.45,{BackgroundTransparency=.43})
        setFade(mainFadeTargets,0,1.45)
        task.delay(1.48,function() animating=false end)
    else
        popup.Visible=false
        tween(backdrop,1.45,{BackgroundTransparency=1})
        setFade(mainFadeTargets,1,1.45)
        task.delay(1.48,function()
            main.Visible=false
            animating=false
        end)
    end
end
close.Activated:Connect(function() setOpen(false) end)
floating.Activated:Connect(function() setOpen(not open) end)

-- Responsive sizing
local scale=new("UIScale",{Scale=1},main)
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

-- Initial selected tab and initial natural fade.
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
tween(backdrop,1.45,{BackgroundTransparency=.43})
setFade(initialFade,0,1.45)

print("[SYLLINSE] "..VERSION.." loaded")
