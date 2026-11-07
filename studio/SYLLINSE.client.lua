-- SYLLINSE | VibeUI-inspired Studio interface
-- Studio-safe visual prototype. Place this LocalScript in StarterPlayerScripts.
-- This recreates a modern dark/cyan UI aesthetic; it does not load executor code.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local previous = playerGui:FindFirstChild("SYLLINSE")
if previous then previous:Destroy() end

local COLORS = {
    bg = Color3.fromRGB(12, 15, 20),
    panel = Color3.fromRGB(19, 23, 30),
    card = Color3.fromRGB(25, 31, 40),
    cardHover = Color3.fromRGB(32, 40, 51),
    text = Color3.fromRGB(235, 241, 248),
    muted = Color3.fromRGB(139, 153, 169),
    accent = Color3.fromRGB(91, 214, 207),
    accentDark = Color3.fromRGB(35, 115, 117),
    line = Color3.fromRGB(49, 62, 75),
}
local accent = COLORS.accent

local function make(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, obj)
end

local function outline(obj, color, transparency, thickness)
    return make("UIStroke", {
        Color = color or COLORS.line,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, obj)
end

local function tween(obj, duration, props, style)
    local t = TweenService:Create(obj, TweenInfo.new(
        duration, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out
    ), props)
    t:Play()
    return t
end

local gui = make("ScreenGui", {
    Name = "SYLLINSE",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 80,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local scale = make("UIScale", {Scale = 1}, gui)
local function fitScale()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    scale.Scale = math.clamp(math.min(viewport.X / 900, viewport.Y / 650), 0.68, 1)
end
fitScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitScale)
end

-- Soft dim layer. It is non-interactive so touch controls remain usable.
local dim = make("Frame", {
    Name = "Dim",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Active = false,
    ZIndex = 1,
}, gui)

local window = make("Frame", {
    Name = "Window",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(720, 470),
    BackgroundColor3 = COLORS.bg,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 2,
}, gui)
round(window, 17)
outline(window, COLORS.line, 0.1, 1.2)
make("UIGradient", {
    Rotation = 90,
    Color = ColorSequence.new(Color3.fromRGB(20, 27, 35), COLORS.bg),
}, window)

local windowScale = make("UIScale", {Scale = 0.94}, window)

local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 64),
    BackgroundColor3 = COLORS.panel,
    BorderSizePixel = 0,
    ZIndex = 3,
}, window)
round(header, 17)
make("Frame", {
    Position = UDim2.new(0, 0, 1, -1),
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = COLORS.line,
    BorderSizePixel = 0,
    ZIndex = 4,
}, header)

local brand = make("TextLabel", {
    Position = UDim2.fromOffset(22, 10),
    Size = UDim2.fromOffset(210, 26),
    BackgroundTransparency = 1,
    Text = "✦  SYLLINSE",
    TextColor3 = accent,
    Font = Enum.Font.GothamBold,
    TextSize = 19,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
}, header)
make("TextLabel", {
    Position = UDim2.fromOffset(24, 36),
    Size = UDim2.fromOffset(270, 16),
    BackgroundTransparency = 1,
    Text = "VIBE-INSPIRED INTERFACE  •  STUDIO EDITION",
    TextColor3 = COLORS.muted,
    Font = Enum.Font.GothamMedium,
    TextSize = 8,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
}, header)

local status = make("TextLabel", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -64, 0.5, 0),
    Size = UDim2.fromOffset(88, 25),
    BackgroundColor3 = Color3.fromRGB(22, 49, 47),
    Text = "●  READY",
    TextColor3 = accent,
    Font = Enum.Font.GothamBold,
    TextSize = 9,
    ZIndex = 4,
}, header)
round(status, 20)

local close = make("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -17, 0.5, 0),
    Size = UDim2.fromOffset(30, 30),
    BackgroundColor3 = COLORS.card,
    Text = "×",
    TextColor3 = COLORS.text,
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    AutoButtonColor = false,
    ZIndex = 5,
}, header)
round(close, 9)

-- Sidebar and page area
local sidebar = make("Frame", {
    Position = UDim2.fromOffset(0, 64),
    Size = UDim2.new(0, 166, 1, -64),
    BackgroundColor3 = COLORS.panel,
    BorderSizePixel = 0,
    ZIndex = 3,
}, window)
make("TextLabel", {
    Position = UDim2.fromOffset(19, 17),
    Size = UDim2.new(1, -30, 0, 18),
    BackgroundTransparency = 1,
    Text = "WORKSPACE",
    TextColor3 = COLORS.muted,
    Font = Enum.Font.GothamBold,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
}, sidebar)

local nav = make("Frame", {
    Position = UDim2.fromOffset(10, 45),
    Size = UDim2.new(1, -20, 0, 190),
    BackgroundTransparency = 1,
    ZIndex = 4,
}, sidebar)
make("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, nav)

local pageArea = make("Frame", {
    Position = UDim2.fromOffset(184, 82),
    Size = UDim2.new(1, -202, 1, -100),
    BackgroundTransparency = 1,
    ZIndex = 3,
}, window)

local pages, navButtons = {}, {}
local selectedPage = "Home"

local function addText(parent, text, pos, size, fontSize, color, font)
    return make("TextLabel", {
        Position = pos,
        Size = size,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or COLORS.text,
        Font = font or Enum.Font.Gotham,
        TextSize = fontSize or 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true,
        ZIndex = 5,
    }, parent)
end

local function card(parent, y, height)
    local c = make("Frame", {
        Position = UDim2.fromOffset(0, y),
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = COLORS.card,
        BorderSizePixel = 0,
        ZIndex = 4,
    }, parent)
    round(c, 12)
    outline(c, COLORS.line, 0.45, 1)
    return c
end

local function makePage(name, title, subtitle)
    local page = make("Frame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 3,
    }, pageArea)
    addText(page, title, UDim2.fromOffset(2, 0), UDim2.new(1, -4, 0, 34), 22, COLORS.text, Enum.Font.GothamBold)
    addText(page, subtitle, UDim2.fromOffset(3, 34), UDim2.new(1, -6, 0, 30), 11, COLORS.muted)
    pages[name] = page
    return page
end

local function selectPage(name)
    selectedPage = name
    for pageName, page in pairs(pages) do page.Visible = pageName == name end
    for buttonName, button in pairs(navButtons) do
        local active = buttonName == name
        tween(button, 0.16, {
            BackgroundColor3 = active and Color3.fromRGB(27, 55, 57) or COLORS.panel,
            TextColor3 = active and accent or COLORS.muted,
        })
    end
end

local function addNav(name, glyph, order)
    local b = make("TextButton", {
        Name = name .. "Nav",
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = COLORS.panel,
        Text = glyph .. "   " .. name,
        TextColor3 = COLORS.muted,
        Font = Enum.Font.GothamSemibold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        LayoutOrder = order,
        ZIndex = 5,
    }, nav)
    round(b, 9)
    make("UIPadding", {PaddingLeft = UDim.new(0, 12)}, b)
    b.Activated:Connect(function() selectPage(name) end)
    navButtons[name] = b
end

addNav("Home", "⌂", 1)
addNav("Appearance", "◈", 2)
addNav("Controls", "⚙", 3)
addNav("About", "ⓘ", 4)

-- Home page
local home = makePage("Home", "Welcome to SYLLINSE", "A clean, responsive interface playground.")
local welcome = card(home, 82, 112)
addText(welcome, "YOUR WORKSPACE", UDim2.fromOffset(18, 15), UDim2.new(1, -36, 0, 18), 9, accent, Enum.Font.GothamBold)
addText(welcome, "Everything is ready.", UDim2.fromOffset(18, 39), UDim2.new(1, -36, 0, 27), 18, COLORS.text, Enum.Font.GothamBold)
addText(welcome, "This is a Studio-safe UI preview. Add your own game features through normal Roblox scripts.", UDim2.fromOffset(18, 70), UDim2.new(1, -36, 0, 30), 10, COLORS.muted)

local quick = card(home, 208, 94)
addText(quick, "QUICK STATUS", UDim2.fromOffset(18, 13), UDim2.new(1, -36, 0, 17), 9, COLORS.muted, Enum.Font.GothamBold)
addText(quick, "Interface", UDim2.fromOffset(18, 39), UDim2.fromOffset(110, 20), 12, COLORS.text, Enum.Font.GothamSemibold)
local online = addText(quick, "●  Running", UDim2.new(1, -128, 0, 39), UDim2.fromOffset(108, 20), 11, accent, Enum.Font.GothamSemibold)

-- Controls page: harmless, local UI demonstration controls.
local controls = makePage("Controls", "Controls", "Example toggles and sliders for your own game's UI.")
local leftControl = make("Frame", {Position = UDim2.fromOffset(0, 82), Size = UDim2.new(0.5, -7, 0, 290), BackgroundTransparency = 1, ZIndex = 3}, controls)
local rightControl = make("Frame", {Position = UDim2.new(0.5, 7, 0, 82), Size = UDim2.new(0.5, -7, 0, 290), BackgroundTransparency = 1, ZIndex = 3}, controls)
local function controlCard(parent, y, h, title)
    local c = card(parent, y, h)
    addText(c, title, UDim2.fromOffset(15, 12), UDim2.new(1, -30, 0, 18), 10, COLORS.muted, Enum.Font.GothamBold)
    return c
end
local toggleCard = controlCard(leftControl, 0, 118, "DEMO TOGGLES")
local function addDemoToggle(parent, y, labelText, defaultValue)
    local value = defaultValue
    addText(parent, labelText, UDim2.fromOffset(15, y), UDim2.new(1, -85, 0, 24), 11, COLORS.text, Enum.Font.GothamSemibold)
    local switch = make("TextButton", {Position = UDim2.new(1, -62, 0, y - 1), Size = UDim2.fromOffset(46, 24), BackgroundColor3 = value and accent or COLORS.line, Text = "", AutoButtonColor = false, ZIndex = 6}, parent)
    round(switch, 20)
    local knob = make("Frame", {Position = value and UDim2.new(1, -21, 0, 3) or UDim2.fromOffset(3, 3), Size = UDim2.fromOffset(18, 18), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, ZIndex = 7}, switch)
    round(knob, 12)
    switch.Activated:Connect(function()
        value = not value
        tween(switch, 0.16, {BackgroundColor3 = value and accent or COLORS.line})
        tween(knob, 0.16, {Position = value and UDim2.new(1, -21, 0, 3) or UDim2.fromOffset(3, 3)})
    end)
end
addDemoToggle(toggleCard, 43, "Example option", true)
addDemoToggle(toggleCard, 79, "Second option", false)
local sliderCard = controlCard(leftControl, 132, 112, "DEMO SLIDER")
local sliderValue = 60
local valueLabel = addText(sliderCard, "Value: 60", UDim2.fromOffset(15, 39), UDim2.new(1, -30, 0, 20), 11, COLORS.text, Enum.Font.GothamSemibold)
local track = make("TextButton", {Position = UDim2.fromOffset(15, 72), Size = UDim2.new(1, -30, 0, 8), BackgroundColor3 = COLORS.line, Text = "", AutoButtonColor = false, ZIndex = 6}, sliderCard)
round(track, 8)
local fill = make("Frame", {Size = UDim2.new(0.6, 0, 1, 0), BackgroundColor3 = accent, BorderSizePixel = 0, ZIndex = 7}, track)
round(fill, 8)
local function setSliderFromX(x)
    local alpha = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
    sliderValue = math.floor(alpha * 100 + 0.5)
    valueLabel.Text = "Value: " .. sliderValue
    fill.Size = UDim2.new(alpha, 0, 1, 0)
end
track.Activated:Connect(function() setSliderFromX(UserInputService:GetMouseLocation().X) end)
local notificationCard = controlCard(rightControl, 0, 118, "NOTIFICATIONS")
addText(notificationCard, "Try a sample toast message.", UDim2.fromOffset(15, 42), UDim2.new(1, -30, 0, 28), 10, COLORS.muted)
local toastButton = make("TextButton", {Position = UDim2.fromOffset(15, 77), Size = UDim2.new(1, -30, 0, 28), BackgroundColor3 = accentDark, Text = "Show notification", TextColor3 = COLORS.text, Font = Enum.Font.GothamBold, TextSize = 10, AutoButtonColor = false, ZIndex = 6}, notificationCard)
round(toastButton, 8)
local toast = make("Frame", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -18, 0, 18), Size = UDim2.fromOffset(230, 58), BackgroundColor3 = COLORS.panel, BackgroundTransparency = 0.05, Visible = false, ZIndex = 30}, gui)
round(toast, 11)
outline(toast, accent, 0.15, 1.2)
addText(toast, "✓  SYLLINSE", UDim2.fromOffset(13, 7), UDim2.new(1, -26, 0, 18), 10, accent, Enum.Font.GothamBold)
addText(toast, "Sample notification displayed.", UDim2.fromOffset(13, 29), UDim2.new(1, -26, 0, 18), 9, COLORS.muted)
toastButton.Activated:Connect(function()
    toast.Visible = true
    toast.Position = UDim2.new(1, 0, 0, 18)
    tween(toast, 0.25, {Position = UDim2.new(1, -18, 0, 18)})
    task.delay(2.2, function() if toast and toast.Parent then tween(toast, 0.2, {Position = UDim2.new(1, 0, 0, 18)}); task.delay(0.22, function() if toast and toast.Parent then toast.Visible = false end end) end end)
end)

-- Appearance page
local appearance = makePage("Appearance", "Appearance", "Adjust the look of this interface.")
local themeCard = card(appearance, 82, 128)
addText(themeCard, "ACCENT COLOR", UDim2.fromOffset(18, 14), UDim2.new(1, -36, 0, 18), 9, COLORS.muted, Enum.Font.GothamBold)
local themeOptions = {
    {name = "Aqua", color = Color3.fromRGB(91, 214, 207)},
    {name = "Violet", color = Color3.fromRGB(166, 133, 255)},
    {name = "Gold", color = Color3.fromRGB(235, 190, 105)},
    {name = "Rose", color = Color3.fromRGB(238, 132, 166)},
}
for i, option in ipairs(themeOptions) do
    local x = 18 + (i - 1) * 105
    local b = make("TextButton", {
        Position = UDim2.fromOffset(x, 48),
        Size = UDim2.fromOffset(92, 48),
        BackgroundColor3 = COLORS.bg,
        Text = "●  " .. option.name,
        TextColor3 = option.color,
        Font = Enum.Font.GothamSemibold,
        TextSize = 10,
        AutoButtonColor = false,
        ZIndex = 5,
    }, themeCard)
    round(b, 9)
    outline(b, option.color, 0.35, 1)
    b.Activated:Connect(function()
        accent = option.color
        brand.TextColor3 = accent
        status.TextColor3 = accent
        status.BackgroundColor3 = Color3.new(option.color.R * 0.22, option.color.G * 0.22, option.color.B * 0.22)
        online.TextColor3 = accent
        for _, navButton in pairs(navButtons) do
            if navButton.Text:find(selectedPage, 1, true) then navButton.TextColor3 = accent end
        end
        for _, child in ipairs(themeCard:GetChildren()) do
            if child:IsA("TextButton") then
                local strokeObj = child:FindFirstChildOfClass("UIStroke")
                if strokeObj then strokeObj.Transparency = child == b and 0 or 0.65 end
            end
        end
    end)
end

local info = card(appearance, 224, 74)
addText(info, "TIP", UDim2.fromOffset(18, 10), UDim2.new(1, -36, 0, 16), 9, accent, Enum.Font.GothamBold)
addText(info, "Theme changes are local to this UI preview.", UDim2.fromOffset(18, 31), UDim2.new(1, -36, 0, 25), 11, COLORS.muted)

-- About page
local about = makePage("About", "About SYLLINSE", "A personal interface project.")
local aboutCard = card(about, 82, 150)
addText(aboutCard, "SYLLINSE STUDIO EDITION", UDim2.fromOffset(18, 17), UDim2.new(1, -36, 0, 20), 12, accent, Enum.Font.GothamBold)
addText(aboutCard, "Built with native Roblox ScreenGui objects, TweenService and touch-friendly controls. This version is a visual UI prototype and does not execute remote code.", UDim2.fromOffset(18, 48), UDim2.new(1, -36, 0, 78), 11, COLORS.muted)

selectPage("Home")

-- Floating launcher
local launcher = make("TextButton", {
    Name = "SYLLINSELauncher",
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 22, 0.5, 0),
    Size = UDim2.fromOffset(54, 54),
    BackgroundColor3 = COLORS.panel,
    Text = "S",
    TextColor3 = accent,
    Font = Enum.Font.GothamBlack,
    TextSize = 23,
    AutoButtonColor = false,
    ZIndex = 20,
}, gui)
round(launcher, 27)
outline(launcher, accent, 0.05, 1.8)

local function setOpen(open)
    if open then
        window.Visible = true
        dim.Visible = true
        windowScale.Scale = 0.94
        window.BackgroundTransparency = 0.08
        tween(dim, 0.28, {BackgroundTransparency = 0.48})
        tween(windowScale, 0.32, {Scale = 1}, Enum.EasingStyle.Back)
    else
        tween(dim, 0.22, {BackgroundTransparency = 1})
        tween(windowScale, 0.2, {Scale = 0.96})
        task.delay(0.22, function()
            if window and window.Parent then window.Visible = false end
            if dim and dim.Parent then dim.Visible = false end
        end)
    end
end

local isOpen = false
local function toggleWindow()
    isOpen = not isOpen
    setOpen(isOpen)
end
launcher.Activated:Connect(toggleWindow)
close.Activated:Connect(toggleWindow)

-- Drag window from its header; supports mouse and touch.
local dragging, dragStart, startPos, dragInput
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = window.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Start closed; the launcher remains available.
dim.Visible = false
window.Visible = false
print("[SYLLINSE] Studio interface loaded.")
