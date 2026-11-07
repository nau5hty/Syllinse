-- SYLLINSE | VibeUI-style Studio UI rebuild
-- Visual-only interface for experiences you own. Place in StarterPlayerScripts.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("SYLLINSE")
if old then old:Destroy() end

local C = {
    background = Color3.fromRGB(13, 15, 19),
    window = Color3.fromRGB(19, 22, 28),
    topbar = Color3.fromRGB(23, 27, 34),
    sidebar = Color3.fromRGB(17, 20, 26),
    section = Color3.fromRGB(25, 30, 38),
    element = Color3.fromRGB(31, 37, 47),
    elementHover = Color3.fromRGB(39, 47, 59),
    white = Color3.fromRGB(239, 243, 248),
    muted = Color3.fromRGB(137, 149, 165),
    line = Color3.fromRGB(48, 57, 70),
    accent = Color3.fromRGB(130, 105, 255),
    accentSoft = Color3.fromRGB(53, 43, 91),
}
local accent = C.accent

local function new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end
local function corner(o, r)
    new("UICorner", {CornerRadius = UDim.new(0, r or 8)}, o)
end
local function stroke(o, color, transparency)
    return new("UIStroke", {Color = color or C.line, Transparency = transparency or 0.25, Thickness = 1}, o)
end
local function tw(o, t, props, style)
    local a = TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    a:Play()
    return a
end
local function label(parent, text, pos, size, font, textSize, color)
    return new("TextLabel", {
        BackgroundTransparency = 1, Position = pos, Size = size, Text = text,
        Font = font or Enum.Font.Gotham, TextSize = textSize or 12,
        TextColor3 = color or C.white, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 5,
    }, parent)
end

local gui = new("ScreenGui", {
    Name = "SYLLINSE", ResetOnSpawn = false, IgnoreGuiInset = true,
    DisplayOrder = 90, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)
local uiScale = new("UIScale", {Scale = 1}, gui)
local function resize()
    local cam = workspace.CurrentCamera
    if cam then
        local v = cam.ViewportSize
        uiScale.Scale = math.clamp(math.min(v.X / 850, v.Y / 620), 0.62, 1)
    end
end
resize()
if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end

local window = new("Frame", {
    Name = "MainWindow", AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(690, 440),
    BackgroundColor3 = C.window, BorderSizePixel = 0, Visible = false, ZIndex = 2,
}, gui)
corner(window, 13)
stroke(window, C.line, 0.05)
local scale = new("UIScale", {Scale = 0.94}, window)

-- Header bar
local top = new("Frame", {Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = C.topbar, BorderSizePixel = 0, ZIndex = 3}, window)
corner(top, 13)
new("Frame", {Position = UDim2.new(0, 0, 1, -12), Size = UDim2.new(1, 0, 0, 12), BackgroundColor3 = C.topbar, BorderSizePixel = 0, ZIndex = 3}, top)
label(top, "✦", UDim2.fromOffset(17, 0), UDim2.fromOffset(24, 52), Enum.Font.GothamBold, 21, accent)
label(top, "SYLLINSE", UDim2.fromOffset(43, 0), UDim2.fromOffset(150, 52), Enum.Font.GothamBold, 15, C.white)
label(top, "VIBE UI EDITION", UDim2.fromOffset(151, 1), UDim2.fromOffset(120, 50), Enum.Font.GothamMedium, 8, C.muted)
local status = label(top, "●  READY", UDim2.new(1, -105, 0, 0), UDim2.fromOffset(75, 52), Enum.Font.GothamBold, 9, accent)
local close = new("TextButton", {
    Position = UDim2.new(1, -43, 0.5, -14), Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = C.element, Text = "×", TextColor3 = C.white,
    Font = Enum.Font.GothamBold, TextSize = 18, AutoButtonColor = false, ZIndex = 6,
}, top)
corner(close, 7)

-- Left navigation rail
local rail = new("Frame", {
    Position = UDim2.fromOffset(0, 52), Size = UDim2.new(0, 154, 1, -52),
    BackgroundColor3 = C.sidebar, BorderSizePixel = 0, ZIndex = 3,
}, window)
new("Frame", {Position = UDim2.new(1, -1, 0, 0), Size = UDim2.new(0, 1, 1, 0), BackgroundColor3 = C.line, BackgroundTransparency = 0.4, BorderSizePixel = 0, ZIndex = 4}, rail)
label(rail, "NAVIGATION", UDim2.fromOffset(16, 16), UDim2.new(1, -25, 0, 18), Enum.Font.GothamBold, 8, C.muted)

local content = new("Frame", {
    Position = UDim2.fromOffset(154, 52), Size = UDim2.new(1, -154, 1, -52),
    BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 3,
}, window)
local pages, navs = {}, {}
local active = "Combat"

local function page(name)
    local p = new("ScrollingFrame", {
        Name = name, Position = UDim2.fromOffset(0, 0), Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        ScrollBarImageColor3 = accent, CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, ZIndex = 3,
    }, content)
    new("UIPadding", {PaddingTop = UDim.new(0, 20), PaddingBottom = UDim.new(0, 18), PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18)}, p)
    pages[name] = p
    return p
end

local function choose(name)
    active = name
    for n, p in pairs(pages) do p.Visible = n == name end
    for n, b in pairs(navs) do
        local on = n == name
        tw(b, 0.15, {BackgroundColor3 = on and C.accentSoft or C.sidebar, TextColor3 = on and accent or C.muted})
    end
end

local function nav(name, glyph, order)
    local b = new("TextButton", {
        Name = name .. "Tab", Position = UDim2.fromOffset(10, 43 + (order - 1) * 42),
        Size = UDim2.new(1, -20, 0, 34), BackgroundColor3 = C.sidebar,
        Text = glyph .. "    " .. name, TextColor3 = C.muted,
        Font = Enum.Font.GothamSemibold, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, ZIndex = 5,
    }, rail)
    corner(b, 7)
    new("UIPadding", {PaddingLeft = UDim.new(0, 11)}, b)
    b.Activated:Connect(function() choose(name) end)
    navs[name] = b
end
nav("Combat", "✣", 1)
nav("Visuals", "◉", 2)
nav("Misc", "⌘", 3)
nav("Settings", "⚙", 4)

local function section(parent, title, column, order)
    local holder = new("Frame", {
        LayoutOrder = order, BackgroundColor3 = C.section, BorderSizePixel = 0,
        Size = UDim2.new(0.5, -7, 0, 150), AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 4,
    }, column)
    corner(holder, 9)
    stroke(holder, C.line, 0.5)
    local head = new("Frame", {Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, ZIndex = 5}, holder)
    label(head, title, UDim2.fromOffset(13, 0), UDim2.new(1, -26, 1, 0), Enum.Font.GothamBold, 10, C.white)
    new("Frame", {Position = UDim2.new(0, 12, 1, -1), Size = UDim2.new(1, -24, 0, 1), BackgroundColor3 = C.line, BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 5}, head)
    local body = new("Frame", {Position = UDim2.fromOffset(0, 37), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 5}, holder)
    new("UIPadding", {PaddingLeft = UDim.new(0, 11), PaddingRight = UDim.new(0, 11), PaddingBottom = UDim.new(0, 10)}, body)
    new("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, body)
    return body
end

local function columns(p)
    local wrap = new("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 4}, p)
    new("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder}, wrap)
    local left = new("Frame", {Size = UDim2.new(0.5, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 4}, wrap)
    local right = new("Frame", {Size = UDim2.new(0.5, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 4}, wrap)
    for _, col in ipairs({left, right}) do new("UIListLayout", {Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder}, col) end
    return left, right
end

local function toggle(parent, title, description, default)
    local row = new("Frame", {Size = UDim2.new(1, 0, 0, description and 48 or 34), BackgroundTransparency = 1, ZIndex = 6}, parent)
    label(row, title, UDim2.fromOffset(1, 0), UDim2.new(1, -63, 0, 22), Enum.Font.GothamSemibold, 10, C.white)
    if description then label(row, description, UDim2.fromOffset(1, 21), UDim2.new(1, -62, 0, 18), Enum.Font.Gotham, 8, C.muted) end
    local value = default == true
    local switch = new("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(39, 21), BackgroundColor3 = value and accent or C.element, Text = "", AutoButtonColor = false, ZIndex = 7}, row)
    corner(switch, 20)
    local dot = new("Frame", {Position = value and UDim2.new(1, -18, 0, 3) or UDim2.fromOffset(3, 3), Size = UDim2.fromOffset(15, 15), BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 8}, switch)
    corner(dot, 20)
    switch.Activated:Connect(function()
        value = not value
        tw(switch, 0.16, {BackgroundColor3 = value and accent or C.element})
        tw(dot, 0.16, {Position = value and UDim2.new(1, -18, 0, 3) or UDim2.fromOffset(3, 3)})
    end)
    return row
end

local function slider(parent, title, min, max, initial, suffix)
    local row = new("Frame", {Size = UDim2.new(1, 0, 0, 55), BackgroundTransparency = 1, ZIndex = 6}, parent)
    local value = initial
    local val = label(row, title .. "  •  " .. tostring(value) .. (suffix or ""), UDim2.fromOffset(1, 0), UDim2.new(1, 0, 0, 20), Enum.Font.GothamSemibold, 10, C.white)
    local track = new("Frame", {Position = UDim2.fromOffset(1, 34), Size = UDim2.new(1, -2, 0, 5), BackgroundColor3 = C.element, BorderSizePixel = 0, ZIndex = 6}, row)
    corner(track, 6)
    local ratio = math.clamp((value - min) / (max - min), 0, 1)
    local fill = new("Frame", {Size = UDim2.new(ratio, 0, 1, 0), BackgroundColor3 = accent, BorderSizePixel = 0, ZIndex = 7}, track)
    corner(fill, 6)
    local knob = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(ratio, 0, 0.5, 0), Size = UDim2.fromOffset(13, 13), BackgroundColor3 = C.white, ZIndex = 8}, track)
    corner(knob, 10)
    local hit = new("TextButton", {Position = UDim2.fromOffset(-2, 24), Size = UDim2.new(1, 4, 0, 25), BackgroundTransparency = 1, Text = "", ZIndex = 9}, row)
    local function update(x)
        local a = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        value = math.floor(min + (max - min) * a + 0.5)
        val.Text = title .. "  •  " .. tostring(value) .. (suffix or "")
        fill.Size = UDim2.new(a, 0, 1, 0)
        knob.Position = UDim2.new(a, 0, 0.5, 0)
    end
    hit.Activated:Connect(function() update(UserInputService:GetMouseLocation().X) end)
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then update(input.Position.X) end
    end)
end

-- Vibe-style page: named tabs, paired sections, reusable controls.
local combat = page("Combat")
label(combat, "Combat", UDim2.fromOffset(0, 0), UDim2.new(1, 0, 0, 27), Enum.Font.GothamBold, 19, C.white)
label(combat, "Organize your experience controls into clean sections.", UDim2.fromOffset(1, 27), UDim2.new(1, 0, 0, 23), Enum.Font.Gotham, 9, C.muted)
local l1, r1 = columns(combat)
local a = section(l1, "AIM SETTINGS", l1, 1)
toggle(a, "Enable option", "Example local toggle", false)
toggle(a, "Show indicator", "Visual demonstration only", true)
slider(a, "Field of view", 1, 500, 120, " px")
local b = section(r1, "GENERAL", r1, 1)
toggle(b, "Demo feature", "A harmless interface switch", true)
toggle(b, "Extra setting", "No gameplay effect", false)
slider(b, "Intensity", 0, 100, 65, "%")

local visuals = page("Visuals")
label(visuals, "Visuals", UDim2.fromOffset(0, 0), UDim2.new(1, 0, 0, 27), Enum.Font.GothamBold, 19, C.white)
label(visuals, "Visual preferences for your own experience.", UDim2.fromOffset(1, 27), UDim2.new(1, 0, 0, 23), Enum.Font.Gotham, 9, C.muted)
local vl, vr = columns(visuals)
local vs1 = section(vl, "DISPLAY", vl, 1)
toggle(vs1, "Show UI effects", "Toggle sample visual state", true)
toggle(vs1, "Compact layout", "Demo control", false)
local vs2 = section(vr, "TUNING", vr, 1)
slider(vs2, "Opacity", 10, 100, 85, "%")
slider(vs2, "Scale", 50, 150, 100, "%")

local misc = page("Misc")
label(misc, "Miscellaneous", UDim2.fromOffset(0, 0), UDim2.new(1, 0, 0, 27), Enum.Font.GothamBold, 19, C.white)
label(misc, "Small utilities and interface feedback.", UDim2.fromOffset(1, 27), UDim2.new(1, 0, 0, 23), Enum.Font.Gotham, 9, C.muted)
local ml, mr = columns(misc)
local ms = section(ml, "INTERFACE", ml, 1)
toggle(ms, "Enable animations", "Sample setting", true)
toggle(ms, "Show status", "Sample setting", true)
local notifySection = section(mr, "NOTIFICATIONS", mr, 1)
local toast = new("TextButton", {Size = UDim2.new(1, 0, 0, 31), BackgroundColor3 = C.accentSoft, Text = "Show test notification", TextColor3 = C.white, Font = Enum.Font.GothamBold, TextSize = 9, AutoButtonColor = false, ZIndex = 7}, notifySection)
corner(toast, 7)
local popup = new("Frame", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 15), Size = UDim2.fromOffset(220, 55), BackgroundColor3 = C.section, Visible = false, ZIndex = 30}, gui)
corner(popup, 9)
stroke(popup, accent, 0.1)
label(popup, "✓  SYLLINSE", UDim2.fromOffset(12, 5), UDim2.new(1, -24, 0, 20), Enum.Font.GothamBold, 10, accent)
label(popup, "Test notification received.", UDim2.fromOffset(12, 26), UDim2.new(1, -24, 0, 18), Enum.Font.Gotham, 9, C.muted)
toast.Activated:Connect(function()
    popup.Visible = true
    popup.Position = UDim2.new(1, 0, 0, 15)
    tw(popup, 0.22, {Position = UDim2.new(1, -16, 0, 15)})
    task.delay(2, function()
        if popup.Parent then
            tw(popup, 0.18, {Position = UDim2.new(1, 0, 0, 15)})
            task.delay(0.2, function() if popup.Parent then popup.Visible = false end end)
        end
    end)
end)

local settings = page("Settings")
label(settings, "Settings", UDim2.fromOffset(0, 0), UDim2.new(1, 0, 0, 27), Enum.Font.GothamBold, 19, C.white)
label(settings, "Choose an accent theme for the interface.", UDim2.fromOffset(1, 27), UDim2.new(1, 0, 0, 23), Enum.Font.Gotham, 9, C.muted)
local themeSection = section(settings, "THEMES", settings, 1)
local themes = {
    {"Violet", Color3.fromRGB(130,105,255)},
    {"Aqua", Color3.fromRGB(82,210,199)},
    {"Gold", Color3.fromRGB(231,183,91)},
    {"Rose", Color3.fromRGB(235,123,163)},
}
for i, item in ipairs(themes) do
    local btn = new("TextButton", {LayoutOrder = i, Size = UDim2.new(1, 0, 0, 31), BackgroundColor3 = C.element, Text = "●    " .. item[1], TextColor3 = item[2], Font = Enum.Font.GothamSemibold, TextSize = 10, AutoButtonColor = false, ZIndex = 7}, themeSection)
    corner(btn, 7)
    btn.Activated:Connect(function()
        accent = item[2]
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("UIStroke") and obj.Color == C.accent then obj.Color = accent end
        end
        status.TextColor3 = accent
        for n, navButton in pairs(navs) do
            if n == active then navButton.TextColor3 = accent end
        end
    end)
end

choose("Combat")

-- Floating open/close button
local launcher = new("TextButton", {
    Name = "SYLLINSELauncher", AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 18, 0.5, 0), Size = UDim2.fromOffset(48, 48),
    BackgroundColor3 = C.topbar, Text = "S", TextColor3 = accent,
    Font = Enum.Font.GothamBlack, TextSize = 21, AutoButtonColor = false, ZIndex = 20,
}, gui)
corner(launcher, 24)
stroke(launcher, accent, 0.08)

local opened = false
local function setOpen(value)
    opened = value
    if value then
        window.Visible = true
        scale.Scale = 0.92
        tw(scale, 0.28, {Scale = 1}, Enum.EasingStyle.Back)
    else
        tw(scale, 0.17, {Scale = 0.94})
        task.delay(0.18, function() if window.Parent and not opened then window.Visible = false end end)
    end
end
launcher.Activated:Connect(function() setOpen(not opened) end)
close.Activated:Connect(function() setOpen(false) end)

-- Drag by title bar (mouse and touch)
local dragging, dragStart, startPos
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, window.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("[SYLLINSE] Vibe-style Studio UI loaded.")
