
--========================================================
-- SYLLINSE V8 | GOLD MOTION EDITION
--========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Old = PlayerGui:FindFirstChild("SYLLINSE")
if Old then Old:Destroy() end

-- CONFIG
local VERSION = "V8 GOLD MOTION"
local BG = Color3.fromRGB(8, 8, 9)
local PANEL = Color3.fromRGB(16, 16, 17)
local CARD = Color3.fromRGB(24, 23, 20)
local GOLD = Color3.fromRGB(212, 175, 55)
local WHITE = Color3.fromRGB(245, 242, 232)
local MUTED = Color3.fromRGB(145, 143, 135)

local ACCENT = GOLD
local Open = true
local Animating = false
local CurrentTab = "Home"

local Pages = {}
local Tabs = {}
local Cards = {}

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function Tween(obj, duration, props)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(
            duration,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        props
    )
    t:Play()
    return t
end

local function Corner(parent, radius)
    New("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, parent)
end

-- GUI
local GUI = New("ScreenGui", {
    Name = "SYLLINSE",
    ResetOnSpawn = false,
    DisplayOrder = 100
}, PlayerGui)

-- Background dimmer
local Backdrop = New("TextButton", {
    Name = "Backdrop",
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromScale(0, 0),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 1,
    Text = "",
    AutoButtonColor = false,
    Visible = true
}, GUI)

local Main = New("CanvasGroup", {
    Name = "Window",
    Size = UDim2.fromOffset(570, 360),
    Position = UDim2.new(0.5, -285, 0.5, -180),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    GroupTransparency = 1,
    ClipsDescendants = true
}, GUI)

Corner(Main, 12)

local MainStroke = New("UIStroke", {
    Color = ACCENT,
    Transparency = 0.35,
    Thickness = 1
}, Main)

-- TOP BAR
local Top = New("Frame", {
    Size = UDim2.new(1, 0, 0, 46),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, Main)

local Logo = New("TextLabel", {
    Position = UDim2.fromOffset(16, 0),
    Size = UDim2.fromOffset(155, 46),
    BackgroundTransparency = 1,
    Text = "◈  SYLLINSE",
    TextColor3 = ACCENT,
    Font = Enum.Font.GothamBlack,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left
}, Top)

New("TextLabel", {
    Position = UDim2.fromOffset(170, 0),
    Size = UDim2.fromOffset(140, 46),
    BackgroundTransparency = 1,
    Text = VERSION,
    TextColor3 = MUTED,
    Font = Enum.Font.GothamMedium,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left
}, Top)

local Close = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -12, 0.5, 0),
    Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = CARD,
    Text = "×",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 19,
    AutoButtonColor = false
}, Top)
Corner(Close, 7)

-- SIDEBAR
local Sidebar = New("Frame", {
    Position = UDim2.fromOffset(0, 46),
    Size = UDim2.new(0, 132, 1, -46),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, Main)

New("TextLabel", {
    Position = UDim2.fromOffset(14, 13),
    Size = UDim2.new(1, -20, 0, 18),
    BackgroundTransparency = 1,
    Text = "NAVIGATION",
    TextColor3 = MUTED,
    Font = Enum.Font.GothamBold,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left
}, Sidebar)

local Nav = New("Frame", {
    Position = UDim2.fromOffset(8, 40),
    Size = UDim2.new(1, -16, 0, 220),
    BackgroundTransparency = 1
}, Sidebar)

New("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder
}, Nav)

-- CONTENT
local Content = New("Frame", {
    Position = UDim2.fromOffset(143, 57),
    Size = UDim2.new(1, -154, 1, -67),
    BackgroundTransparency = 1
}, Main)

local Heading = New("TextLabel", {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Text = "Home",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left
}, Content)

-- PAGE CREATION
local TabNames = {
    {"Home", "⌂"},
    {"Player", "◉"},
    {"Visuals", "◈"},
    {"Settings", "⚙"},
    {"About", "ⓘ"}
}

local function CreatePage(name)
    local page = New("CanvasGroup", {
        Name = name,
        Position = UDim2.fromOffset(0, 39),
        Size = UDim2.new(1, 0, 1, -39),
        BackgroundTransparency = 1,
        GroupTransparency = 1,
        Visible = false
    }, Content)

    New("UIGridLayout", {
        CellSize = UDim2.new(0.5, -6, 0, 75),
        CellPadding = UDim2.fromOffset(9, 9),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    Pages[name] = page
    return page
end

for _, tab in ipairs(TabNames) do
    local name = tab[1]
    local symbol = tab[2]

    local button = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = PANEL,
        Text = "   " .. symbol .. "    " .. name,
        TextColor3 = MUTED,
        Font = Enum.Font.GothamSemibold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, Nav)

    Corner(button, 7)

    local indicator = New("Frame", {
        Size = UDim2.new(0, 3, 0, 0),
        Position = UDim2.fromOffset(0, 17),
        BackgroundColor3 = ACCENT,
        BorderSizePixel = 0
    }, button)
    Corner(indicator, 5)

    Tabs[name] = {
        Button = button,
        Indicator = indicator
    }

    CreatePage(name)
end

-- PAGE SWITCHING
local SwitchLock = false

local function SwitchTab(name)
    if SwitchLock or not Pages[name] then return end
    if CurrentTab == name then return end

    SwitchLock = true

    local oldPage = Pages[CurrentTab]
    local newPage = Pages[name]

    CurrentTab = name
    Heading.Text = name

    -- Animate tab buttons
    for tabName, data in pairs(Tabs) do
        local selected = tabName == name

        Tween(data.Button, 0.2, {
            BackgroundColor3 = selected and CARD or PANEL,
            TextColor3 = selected and ACCENT or MUTED
        })

        Tween(data.Indicator, 0.25, {
            Size = UDim2.new(0, 3, 0, selected and 19 or 0),
            Position = UDim2.fromOffset(0, selected and 8 or 17)
        })
    end

    -- Fade old page out
    if oldPage then
        Tween(oldPage, 0.16, {
            GroupTransparency = 1,
            Position = UDim2.fromOffset(-8, 39)
        })

        task.wait(0.17)
        oldPage.Visible = false
    end

    -- Fade new page in
    newPage.Visible = true
    newPage.GroupTransparency = 1
    newPage.Position = UDim2.fromOffset(10, 39)

    Tween(newPage, 0.28, {
        GroupTransparency = 0,
        Position = UDim2.fromOffset(0, 39)
    })

    task.wait(0.29)
    SwitchLock = false
end

for name, data in pairs(Tabs) do
    data.Button.Activated:Connect(function()
        SwitchTab(name)
    end)
end

-- CARD SYSTEM
local function CreateCard(parent, title, description)
    local card = New("Frame", {
        Name = title,
        BackgroundColor3 = CARD,
        BorderSizePixel = 0
    }, parent)

    Corner(card, 8)

    local stroke = New("UIStroke", {
        Color = ACCENT,
        Transparency = 0.75,
        Thickness = 1
    }, card)

    New("TextLabel", {
        Position = UDim2.fromOffset(10, 8),
        Size = UDim2.new(1, -18, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = WHITE,
        Font = Enum.Font.GothamSemibold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    New("TextLabel", {
        Position = UDim2.fromOffset(10, 29),
        Size = UDim2.new(1, -18, 0, 28),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = MUTED,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, card)

    Cards[#Cards + 1] = card
    return card
end

-- MOVABLE TOGGLE
local function AddToggle(parent, title, description, callback)
    local card = CreateCard(parent, title, description)

    local switch = New("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(39, 21),
        BackgroundColor3 = Color3.fromRGB(55, 55, 55),
        Text = "",
        AutoButtonColor = false
    }, card)

    Corner(switch, 20)

    local outline = New("UIStroke", {
        Color = MUTED,
        Transparency = 0.65,
        Thickness = 1
    }, switch)

    local knob = New("Frame", {
        Position = UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(15, 15),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0
    }, switch)

    Corner(knob, 20)

    New("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.7,
        Thickness = 1
    }, knob)

    local enabled = false
    local dragging = false
    local dragInput

    local function UpdateToggle(value)
        enabled = value

        Tween(switch, 0.2, {
            BackgroundColor3 = enabled
                and ACCENT
                or Color3.fromRGB(55, 55, 55)
        })

        Tween(knob, 0.2, {
            Position = enabled
                and UDim2.new(1, -18, 0, 3)
                or UDim2.fromOffset(3, 3),
            BackgroundColor3 = enabled and Color3.new(1,1,1) or WHITE
        })

        Tween(outline, 0.2, {
            Color = enabled and ACCENT or MUTED,
            Transparency = enabled and 0.15 or 0.65
        })

        if callback then
            local ok, err = pcall(callback, enabled)
            if not ok then warn("SYLLINSE toggle:", err) end
        end
    end

    local function UpdateFromPosition(position)
        local center = switch.AbsolutePosition.X
            + switch.AbsoluteSize.X / 2

        UpdateToggle(position.X >= center)
    end

    -- Clicking the track toggles it
    switch.Activated:Connect(function()
        if not dragging then
            UpdateToggle(not enabled)
        end
    end)

    -- Dragging the knob
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
                UpdateFromPosition(input.Position)
            end
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                dragInput = nil
            end
        end
    end)

    return card
end

local function AddButton(parent, title, description, callback)
    local card = CreateCard(parent, title, description)

    local button = New("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(48, 24),
        BackgroundColor3 = ACCENT,
        Text = "RUN",
        TextColor3 = BG,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        AutoButtonColor = false
    }, card)

    Corner(button, 5)

    button.Activated:Connect(function()
        Tween(button, 0.08, {
            Size = UDim2.fromOffset(43, 21)
        })

        task.delay(0.09, function()
            if button.Parent then
                Tween(button, 0.15, {
                    Size = UDim2.fromOffset(48, 24)
                })
            end
        end)

        if callback then
            local ok, err = pcall(callback)
            if not ok then warn("SYLLINSE button:", err) end
        end
    end)

    return card
end

-- HOME DASHBOARD
local Home = Pages.Home

local function AddStat(parent, title, initial)
    local card = CreateCard(parent, title, initial)

    local value = New("TextLabel", {
        Position = UDim2.fromOffset(10, 31),
        Size = UDim2.new(1, -18, 0, 30),
        BackgroundTransparency = 1,
        Text = initial,
        TextColor3 = ACCENT,
        Font = Enum.Font.GothamBlack,
        TextSize = 19,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    return value
end

_G.SYLLINSE_LAUNCHES = (_G.SYLLINSE_LAUNCHES or 0) + 1

local FPSLabel = AddStat(Home, "FPS", "--")
local PingLabel = AddStat(Home, "PING", "--")
local SessionLabel = AddStat(Home, "SESSION TIME", "00:00")
local LaunchLabel = AddStat(
    Home,
    "LOCAL LAUNCHES",
    tostring(_G.SYLLINSE_LAUNCHES)
)

local GameCard = CreateCard(Home, "CURRENT GAME", game.Name)
CreateCard(Home, "SCRIPT VERSION", VERSION)
CreateCard(Home, "GLOBAL EXECUTIONS", "Statistics service not connected")

-- PLAYER PAGE
AddToggle(Pages.Player, "Player Demo", "Example interface switch",
    function(v) print("Player Demo:", v) end)

AddToggle(Pages.Player, "Movement Demo", "Example interface switch",
    function(v) print("Movement Demo:", v) end)

AddButton(Pages.Player, "Reset Demo", "Example button",
    function() print("Reset demo") end)

-- VISUALS PAGE
AddToggle(Pages.Visuals, "Visual Demo", "Example visual switch",
    function(v) print("Visual Demo:", v) end)

AddToggle(Pages.Visuals, "Highlight Demo", "Example highlight switch",
    function(v) print("Highlight Demo:", v) end)

AddButton(Pages.Visuals, "Preview", "Test interface interaction",
    function() print("Preview clicked") end)

-- SETTINGS PAGE
AddToggle(Pages.Settings, "Interface Effects", "Example setting",
    function(v) print("Interface Effects:", v) end)

AddButton(Pages.Settings, "Refresh Dashboard", "Refresh information",
    function()
        GameCard:FindFirstChildWhichIsA("TextLabel").Text = game.Name
        LaunchLabel.Text = tostring(_G.SYLLINSE_LAUNCHES)
    end)

-- ABOUT PAGE
AddButton(Pages.About, "SYLLINSE V8", "Gold Motion Edition",
    function() print("SYLLINSE V8 GOLD MOTION") end)

AddButton(Pages.About, "Developer", "SYLLINSE project",
    function() print("SYLLINSE") end)

-- LIVE STATS
local StartTime = os.clock()
local Frames = 0
local LastUpdate = os.clock()

RunService.RenderStepped:Connect(function()
    Frames += 1

    local now = os.clock()

    if now - LastUpdate >= 1 then
        FPSLabel.Text = tostring(
            math.floor(Frames / (now - LastUpdate))
        )

        Frames = 0
        LastUpdate = now

        local elapsed = math.floor(now - StartTime)
        SessionLabel.Text = string.format(
            "%02d:%02d",
            math.floor(elapsed / 60),
            elapsed % 60
        )

        local ok, ping = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        end)

        PingLabel.Text = ok and tostring(ping) or "N/A"
    end
end)

-- SLIDING COLOUR BAR
local ThemeButton = New("TextButton", {
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 1, -12),
    Size = UDim2.new(1, -16, 0, 32),
    BackgroundColor3 = CARD,
    Text = "  ◉  CUSTOM THEME",
    TextColor3 = ACCENT,
    Font = Enum.Font.GothamBold,
    TextSize = 9,
    AutoButtonColor = false
}, Sidebar)

Corner(ThemeButton, 7)

local ThemePopup = New("Frame", {
    Position = UDim2.new(0, 8, 1, -105),
    Size = UDim2.new(1, -16, 0, 85),
    BackgroundColor3 = CARD,
    Visible = false,
    ZIndex = 20
}, Sidebar)

Corner(ThemePopup, 8)

New("UIStroke", {
    Color = ACCENT,
    Transparency = 0.3
}, ThemePopup)

New("TextLabel", {
    Position = UDim2.fromOffset(8, 5),
    Size = UDim2.new(1, -16, 0, 18),
    BackgroundTransparency = 1,
    Text = "DRAG TO CHANGE COLOUR",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 8,
    ZIndex = 21
}, ThemePopup)

local HueBar = New("Frame", {
    Position = UDim2.fromOffset(9, 36),
    Size = UDim2.new(1, -18, 0, 18),
    BackgroundColor3 = WHITE,
    BorderSizePixel = 0,
    ZIndex = 21
}, ThemePopup)

Corner(HueBar, 8)

New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
    })
}, HueBar)

local HueKnob = New("Frame", {
    Position = UDim2.new(0, -3, 0.5, -5),
    Size = UDim2.fromOffset(10, 28),
    BackgroundColor3 = WHITE,
    BorderSizePixel = 0,
    ZIndex = 23
}, HueBar)

Corner(HueKnob, 6)

New("UIStroke", {
    Color = Color3.new(0,0,0),
    Thickness = 1
}, HueKnob)

local Hue = 0.12
local Saturation = 0.72
local Value = 0.83

local function ApplyAccent(color)
    ACCENT = color

    Tween(Logo, 0.15, {TextColor3 = color})
    Tween(ThemeButton, 0.15, {TextColor3 = color})
    Tween(MainStroke, 0.15, {Color = color})

    for _, data in pairs(Tabs) do
        local selected = data.Button.Text:find(CurrentTab, 1, true)

        Tween(data.Indicator, 0.15, {
            BackgroundColor3 = color
        })

        if selected then
            Tween(data.Button, 0.15, {
                TextColor3 = color
            })
        end
    end

    for _, obj in ipairs(GUI:GetDescendants()) do
        if obj:IsA("UIStroke") then
            obj.Color = color
        elseif obj:IsA("TextLabel") and obj.TextColor3 == GOLD then
            obj.TextColor3 = color
        elseif obj:IsA("TextButton") and obj.Text == "RUN" then
            obj.BackgroundColor3 = color
        end
    end

    FPSLabel.TextColor3 = color
    PingLabel.TextColor3 = color
    SessionLabel.TextColor3 = color
    LaunchLabel.TextColor3 = color
end

local function SetHueFromPosition(x)
    local relative = math.clamp(
        (x - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X,
        0,
        1
    )

    Hue = relative

    local color = Color3.fromHSV(Hue, Saturation, Value)

    Tween(HueKnob, 0.08, {
        Position = UDim2.new(relative, -5, 0.5, -5)
    })

    ApplyAccent(color)
end

local SliderDragging = false

HueBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        SliderDragging = true
        SetHueFromPosition(input.Position.X)
    end
end)

HueKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        SliderDragging = true
    end
end)

UIS.InputChanged:Connect(function(input)
    if SliderDragging then
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            SetHueFromPosition(input.Position.X)
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        SliderDragging = false
    end
end)

ThemeButton.Activated:Connect(function()
    
