-- SYLLINSE V1
-- VibeUI-inspired Roblox Studio interface
-- Place this LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("SYLLINSE")
if old then old:Destroy() end

local GOLD = Color3.fromRGB(225, 174, 75)
local DARK = Color3.fromRGB(13, 13, 17)
local PANEL = Color3.fromRGB(22, 22, 28)
local TEXT = Color3.fromRGB(240, 237, 230)
local MUTED = Color3.fromRGB(145, 143, 150)

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function stroke(obj, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Transparency = transparency or 0
    s.Thickness = thickness or 1
    s.Parent = obj
    return s
end

local function tween(obj, duration, properties)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        properties
    )
    t:Play()
    return t
end

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

-- Floating toggle
local toggle = make("TextButton", {
    Name = "Toggle",
    Size = UDim2.fromOffset(58, 58),
    Position = UDim2.new(0, 24, 0.5, -29),
    BackgroundColor3 = DARK,
    Text = "S",
    TextColor3 = GOLD,
    TextSize = 27,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 10
}, gui)

corner(toggle, 100)
stroke(toggle, GOLD, 0.08, 2)

-- Navigation dock
local dock = make("Frame", {
    Name = "NavigationDock",
    Size = UDim2.fromOffset(58, 0),
    Position = UDim2.new(0, 24, 0.5, -29),
    BackgroundColor3 = PANEL,
    ClipsDescendants = true,
    ZIndex = 5
}, gui)

corner(dock, 22)
stroke(dock, GOLD, 0.35, 1)

local dockLayout = Instance.new("UIListLayout")
dockLayout.Padding = UDim.new(0, 8)
dockLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
dockLayout.Parent = dock

make("UIPadding", {
    PaddingTop = UDim.new(0, 12),
    PaddingBottom = UDim.new(0, 12)
}, dock)

-- Main window
local main = make("Frame", {
    Name = "MainWindow",
    Size = UDim2.fromOffset(530, 340),
    Position = UDim2.new(0.5, -265, 0.5, -170),
    BackgroundColor3 = DARK,
    Visible = false,
    BackgroundTransparency = 1,
    ZIndex = 2
}, gui)

corner(main, 18)
stroke(main, GOLD, 0.2, 1.4)

local scale = Instance.new("UIScale")
scale.Scale = 0.94
scale.Parent = main

-- Header
local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 65),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, main)

corner(header, 18)

make("TextLabel", {
    Position = UDim2.fromOffset(22, 9),
    Size = UDim2.fromOffset(220, 28),
    BackgroundTransparency = 1,
    Text = "SYLLINSE",
    TextColor3 = GOLD,
    TextSize = 21,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

make("TextLabel", {
    Position = UDim2.fromOffset(23, 36),
    Size = UDim2.fromOffset(250, 17),
    BackgroundTransparency = 1,
    Text = "PREMIUM INTERFACE  •  V1",
    TextColor3 = MUTED,
    TextSize = 9,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local close = make("TextButton", {
    Size = UDim2.fromOffset(34, 34),
    Position = UDim2.new(1, -48, 0, 15),
    BackgroundColor3 = Color3.fromRGB(42, 35, 32),
    Text = "×",
    TextColor3 = GOLD,
    TextSize = 23,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false
}, header)

corner(close, 10)

-- Sidebar
local sidebar = make("Frame", {
    Position = UDim2.fromOffset(12, 78),
    Size = UDim2.new(0, 135, 1, -90),
    BackgroundColor3 = PANEL
}, main)

corner(sidebar, 13)

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 8)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.Parent = sidebar

make("UIPadding", {
    PaddingTop = UDim.new(0, 12)
}, sidebar)

-- Content area
local content = make("Frame", {
    Position = UDim2.fromOffset(158, 78),
    Size = UDim2.new(1, -170, 1, -90),
    BackgroundColor3 = PANEL
}, main)

corner(content, 13)

local pages = {}

local function createPage(name, title, description)
    local page = make("Frame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false
    }, content)

    make("TextLabel", {
        Position = UDim2.fromOffset(20, 20),
        Size = UDim2.new(1, -35, 0, 32),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = TEXT,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, page)

    make("TextLabel", {
        Position = UDim2.fromOffset(20, 57),
        Size = UDim2.new(1, -35, 0, 38),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = MUTED,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, page)

    pages[name] = page
    return page
end

local home = createPage(
    "Home",
    "Welcome back.",
    "SYLLINSE is ready. Your interface is running smoothly."
)

local settings = createPage(
    "Settings",
    "Appearance",
    "Customize the interface experience."
)

local about = createPage(
    "About",
    "About SYLLINSE",
    "A premium interface project inspired by modern Roblox UI design."
)

local function createAction(parent, label, position, callback)
    local button = make("TextButton", {
        Position = position,
        Size = UDim2.new(1, -40, 0, 42),
        BackgroundColor3 = Color3.fromRGB(35, 33, 38),
        Text = label,
        TextColor3 = TEXT,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false
    }, parent)

    corner(button, 10)
    stroke(button, GOLD, 0.75, 1)

    button.MouseEnter:Connect(function()
        tween(button, 0.15, {
            BackgroundColor3 = Color3.fromRGB(53, 44, 34)
        })
    end)

    button.MouseLeave:Connect(function()
        tween(button, 0.15, {
            BackgroundColor3 = Color3.fromRGB(35, 33, 38)
        })
    end)

    button.Activated:Connect(callback)
    return button
end

local function notify(message)
    local notification = make("TextLabel", {
        Size = UDim2.fromOffset(250, 45),
        Position = UDim2.new(0.5, -125, 0, -60),
        BackgroundColor3 = PANEL,
        Text = message,
        TextColor3 = GOLD,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        ZIndex = 20
    }, gui)

    corner(notification, 12)
    stroke(notification, GOLD, 0.3, 1)

    tween(notification, 0.35, {
        Position = UDim2.new(0.5, -125, 0, 25)
    })

    task.delay(2, function()
        if notification.Parent then
            tween(notification, 0.3, {
                Position = UDim2.new(0.5, -125, 0, -60),
                BackgroundTransparency = 1,
                TextTransparency = 1
            })
            task.wait(0.35)
            notification:Destroy()
        end
    end)
end

createAction(home, "Interface loaded", UDim2.fromOffset(20, 115), function()
    notify("SYLLINSE is running!")
end)

createAction(settings, "Toggle gold theme", UDim2.fromOffset(20, 115), function()
    notify("Gold theme selected")
end)

createAction(about, "Version 1.0.0", UDim2.fromOffset(20, 115), function()
    notify("Thanks for using SYLLINSE")
end)

local function showPage(name)
    for pageName, page in pairs(pages) do
        page.Visible = pageName == name
    end
end

showPage("Home")

local tabNames = {"Home", "Settings", "About"}

for _, name in ipairs(tabNames) do
    local tab = make("TextButton", {
        Size = UDim2.new(1, -16, 0, 39),
        BackgroundColor3 = DARK,
        Text = name,
        TextColor3 = TEXT,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false
    }, sidebar)

    corner(tab, 9)

    tab.Activated:Connect(function()
        showPage(name)
    end)
end

-- Dock buttons
local dockOpen = false

for _, name in ipairs(tabNames) do
    local button = make("TextButton", {
        Size = UDim2.fromOffset(38, 38),
        BackgroundColor3 = DARK,
        Text = string.sub(name, 1, 1),
        TextColor3 = GOLD,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        ZIndex = 6
    }, dock)

    corner(button, 12)

    button.Activated:Connect(function()
        showPage(name)
        if not main.Visible then
            main.Visible = true
            main.BackgroundTransparency = 1
            scale.Scale = 0.94
            tween(main, 0.3, {BackgroundTransparency = 0})
            tween(scale, 0.3, {Scale = 1})
        end
    end)
end

local function setDock(open)
    dockOpen = open
    local height = open and 178 or 0

    tween(dock, 0.3, {
        Size = UDim2.fromOffset(58, height),
        Position = open
            and UDim2.new(0, 24, 0.5, -117)
            or UDim2.new(0, 24, 0.5, -29)
    })

    tween(toggle, 0.25, {
        Rotation = open and 45 or 0
    })
end

local function openWindow()
    main.Visible = true
    main.BackgroundTransparency = 1
    scale.Scale = 0.94

    tween(main, 0.4, {
        BackgroundTransparency = 0
    })

    tween(scale, 0.4, {
        Scale = 1
    })
end

local function closeWindow()
    local t = tween(scale, 0.25, {Scale = 0.94})
    tween(main, 0.25, {BackgroundTransparency = 1})

    t.Completed:Wait()
    main.Visible = false
end

toggle.Activated:Connect(function()
    setDock(not dockOpen)

    if main.Visible then
        closeWindow()
    else
        openWindow()
    end
end)

close.Activated:Connect(closeWindow)

-- Drag the floating toggle
local dragging = false
local dragStart
local startPosition

toggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = toggle.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        toggle.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )

        dock.Position = UDim2.new(
            toggle.Position.X.Scale,
            toggle.Position.X.Offset,
            toggle.Position.Y.Scale,
            toggle.Position.Y.Offset - (dockOpen and 88 or 0)
        )
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

notify("SYLLINSE V1 loaded")
