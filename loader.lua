
--========================================================
-- SYLLINSE V7 | GOLD EDITION
-- Premium dashboard / Animated interface
--========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Cleanup
local Old = PlayerGui:FindFirstChild("SYLLINSE")
if Old then Old:Destroy() end

--========================================================
-- CONFIG
--========================================================

local VERSION = "V7 GOLD"
local BG = Color3.fromRGB(8, 8, 9)
local PANEL = Color3.fromRGB(16, 16, 17)
local CARD = Color3.fromRGB(24, 23, 20)
local GOLD = Color3.fromRGB(212, 175, 55)
local WHITE = Color3.fromRGB(245, 242, 232)
local MUTED = Color3.fromRGB(145, 143, 135)

local ACCENT = GOLD
local Open = true
local CurrentTab = "Home"
local Cards = {}
local Tabs = {}
local Pages = {}

_G.SYLLINSE_LAUNCHES = (_G.SYLLINSE_LAUNCHES or 0) + 1
local LocalLaunches = _G.SYLLINSE_LAUNCHES

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

local function Stroke(parent, color)
    return New("UIStroke", {
        Color = color or ACCENT,
        Transparency = 0.45,
        Thickness = 1
    }, parent)
end

--========================================================
-- GUI
--========================================================

local GUI = New("ScreenGui", {
    Name = "SYLLINSE",
    ResetOnSpawn = false,
    DisplayOrder = 100
}, PlayerGui)

local Main = New("CanvasGroup", {
    Name = "Window",
    Size = UDim2.fromOffset(570, 360),
    Position = UDim2.new(0.5, -285, 0.5, -180),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    GroupTransparency = 0,
    ClipsDescendants = true
}, GUI)

Corner(Main, 12)
Stroke(Main)

local UIScale = New("UIScale", {
    Scale = 1
}, Main)

--========================================================
-- TOP BAR
--========================================================

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
    Size = UDim2.fromOffset(120, 46),
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
    Size = UDim2.fromOffset(27, 27),
    BackgroundColor3 = CARD,
    Text = "×",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    AutoButtonColor = false
}, Top)

Corner(Close, 7)

--========================================================
-- SIDEBAR
--========================================================

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

--========================================================
-- CONTENT
--========================================================

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

local Search = New("TextBox", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 2),
    Size = UDim2.fromOffset(145, 26),
    BackgroundColor3 = CARD,
    Text = "",
    PlaceholderText = "⌕  Search...",
    PlaceholderColor3 = MUTED,
    TextColor3 = WHITE,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    ClearTextOnFocus = false
}, Content)

Corner(Search, 6)

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
        GroupTransparency = 0,
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
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, Nav)

    Corner(button, 7)
    Tabs[name] = button
    CreatePage(name)

    button.Activated:Connect(function()
        Heading.Text = name

        for tabName, tabButton in pairs(Tabs) do
            local selected = tabName == name

            Tween(tabButton, 0.2, {
                BackgroundColor3 = selected and CARD or PANEL,
                TextColor3 = selected and ACCENT or MUTED
            })
        end

        for pageName, page in pairs(Pages) do
            if pageName == name then
                page.Visible = true
                page.GroupTransparency = 1
                page.Position = UDim2.fromOffset(12, 39)

                Tween(page, 0.28, {
                    GroupTransparency = 0,
                    Position = UDim2.fromOffset(0, 39)
                })
            else
                page.Visible = false
            end
        end
    end)
end

--========================================================
-- CARD SYSTEM
--========================================================

local function CreateCard(parent, title, description)
    local card = New("Frame", {
        Name = title,
        BackgroundColor3 = CARD,
        BorderSizePixel = 0
    }, parent)

    Corner(card, 8)

    local border = Stroke(card)
    border.Transparency = 0.75

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

    local desc = New("TextLabel", {
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

local function AddToggle(parent, title, description, callback)
    local card = CreateCard(parent, title, description)

    local switch = New("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(34, 18),
        BackgroundColor3 = MUTED,
        Text = "",
        AutoButtonColor = false
    }, card)

    Corner(switch, 20)

    local knob = New("Frame", {
        Position = UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0
    }, switch)

    Corner(knob, 20)

    local enabled = false

    switch.Activated:Connect(function()
        enabled = not enabled

        Tween(switch, 0.2, {
            BackgroundColor3 = enabled and ACCENT or MUTED
        })

        Tween(knob, 0.2, {
            Position = enabled
                and UDim2.new(1, -15, 0, 3)
                or UDim2.fromOffset(3, 3)
        })

        if callback then
            local ok, err = pcall(callback, enabled)
            if not ok then warn("SYLLINSE:", err) end
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
            Size = UDim2.fromOffset(44, 21)
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
            if not ok then warn("SYLLINSE:", err) end
        end
    end)

    return card
end

--========================================================
-- HOME DASHBOARD
--========================================================

local HomePage = Pages.Home

local function AddStat(parent, title, initialValue)
    local card = CreateCard(parent, title, initialValue)

    local value = New("TextLabel", {
        Position = UDim2.new(0, 10, 0, 31),
        Size = UDim2.new(1, -18, 0, 30),
        BackgroundTransparency = 1,
        Text = initialValue,
        TextColor3 = ACCENT,
        Font = Enum.Font.GothamBlack,
        TextSize = 19,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    return value
end

local FPSLabel = AddStat(HomePage, "FPS", "--")
local PingLabel = AddStat(HomePage, "PING", "--")
local SessionLabel = AddStat(HomePage, "SESSION TIME", "00:00")
local LaunchLabel = AddStat(HomePage, "LOCAL LAUNCHES", tostring(LocalLaunches))

local GameCard = CreateCard(
    HomePage,
    "CURRENT GAME",
    game.Name
)

local VersionCard = CreateCard(
    HomePage,
    "SCRIPT VERSION",
    VERSION .. "  |  SYLLINSE"
)

local GlobalCard = CreateCard(
    HomePage,
    "GLOBAL EXECUTIONS",
    "Statistics service not connected"
)

--========================================================
-- LIVE STATISTICS
--========================================================

local StartTime = os.clock()
local Frames = 0
local LastFPSUpdate = os.clock()

RunService.RenderStepped:Connect(function()
    Frames = Frames + 1

    local now = os.clock()

    if now - LastFPSUpdate >= 1 then
        local fps = math.floor(
            Frames / (now - LastFPSUpdate)
        )

        FPSLabel.Text = tostring(fps)

        Frames = 0
        LastFPSUpdate = now

        local minutes = math.floor((now - StartTime) / 60)
        local seconds = math.floor((now - StartTime) % 60)

        SessionLabel.Text = string.format(
            "%02d:%02d",
            minutes,
            seconds
        )

        local ok, ping = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        end)

        if ok then
            PingLabel.Text = tostring(ping)
        else
            PingLabel.Text = "N/A"
        end
    end
end)

--========================================================
-- PLAYER PAGE
--========================================================

local PlayerPage = Pages.Player

AddToggle(
    PlayerPage,
    "Player Demo",
    "Example interface switch",
    function(v)
        print("Player Demo:", v)
    end
)

AddToggle(
    PlayerPage,
    "Movement Demo",
    "Interface-only demonstration",
    function(v)
        print("Movement Demo:", v)
    end
)

AddButton(
    PlayerPage,
    "Reset Demo",
    "Example reset button",
    function()
        print("Demo reset")
    end
)

--========================================================
-- VISUALS PAGE
--========================================================

local VisualPage = Pages.Visuals

AddToggle(
    VisualPage,
    "Visual Demo",
    "Example visual switch",
    function(v)
        print("Visual Demo:", v)
    end
)

AddToggle(
    VisualPage,
    "Highlight Demo",
    "Example highlight switch",
    function(v)
        print("Highlight Demo:", v)
    end
)

AddButton(
    VisualPage,
    "Preview",
    "Test interface interaction",
    function()
        print("Preview clicked")
    end
)

--========================================================
-- SETTINGS PAGE
--========================================================

local SettingsPage = Pages.Settings

AddToggle(
    SettingsPage,
    "Interface Effects",
    "Example interface setting",
    function(v)
        print("Interface effects:", v)
    end
)

AddButton(
    SettingsPage,
    "Refresh Dashboard",
    "Refresh displayed information",
    function()
        GameCard:FindFirstChildWhichIsA("TextLabel").Text = game.Name
        LaunchLabel.Text = tostring(LocalLaunches)
        print("Dashboard refreshed")
    end
)

--========================================================
-- ABOUT PAGE
--========================================================

local AboutPage = Pages.About

AddButton(
    AboutPage,
    "SYLLINSE V7",
    "Gold Edition",
    function()
        print("SYLLINSE V7 GOLD")
    end
)

AddButton(
    AboutPage,
    "Developer",
    "SYLLINSE project",
    function()
        print("SYLLINSE")
    end
)

--========================================================
-- BOTTOM THEME PICKER
--========================================================

local ThemeButton = New("TextButton", {
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 1, -13),
    Size = UDim2.new(1, -16, 0, 32),
    BackgroundColor3 = CARD,
    Text = "  ◉  THEME",
    TextColor3 = ACCENT,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    AutoButtonColor = false
}, Sidebar)

Corner(ThemeButton, 7)
Stroke(ThemeButton)

local ThemePopup = New("Frame", {
    Position = UDim2.new(0, 8, 1, -151),
    Size = UDim2.new(1, -16, 0, 130),
    BackgroundColor3 = CARD,
    Visible = false,
    ZIndex = 20
}, Sidebar)

Corner(ThemePopup, 8)
Stroke(ThemePopup)

New("UIListLayout", {
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder
}, ThemePopup)

local Themes = {
    {"GOLD", Color3.fromRGB(212, 175, 55)},
    {"BLUE", Color3.fromRGB(75, 155, 255)},
    {"PURPLE", Color3.fromRGB(170, 105, 255)},
    {"RED", Color3.fromRGB(255, 85, 95)},
    {"GREEN", Color3.fromRGB(90, 205, 125)}
}

local function SetAccent(color, name)
    ACCENT = color

    Logo.TextColor3 = color
    ThemeButton.TextColor3 = color
    ThemeButton.BackgroundColor3 = CARD

    for _, object in ipairs(GUI:GetDescendants()) do
        if object:IsA("UIStroke") then
            object.Color = color
        elseif object:IsA("TextButton") then
            if object.Text == "RUN" then
                object.BackgroundColor3 = color
            end
        end
    end

    for _, tab in pairs(Tabs) do
        if tab.Text:find(CurrentTab, 1, true) then
            tab.TextColor3 = color
        end
    end

    for _, item in ipairs({FPSLabel, PingLabel, SessionLabel, LaunchLabel}) do
        item.TextColor3 = color
    end

    print("Theme changed:", name)
end

for _, theme in ipairs(Themes) do
    local name, color = theme[1], theme[2]

    local button = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundColor3 = PANEL,
        Text = name,
        TextColor3 = color,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        ZIndex = 21,
        AutoButtonColor = false
    }, ThemePopup)

    button.Activated:Connect(function()
        SetAccent(color, name)
        ThemePopup.Visible = false
    end)
end

ThemeButton.Activated:Connect(function()
    ThemePopup.Visible = not ThemePopup.Visible
end)

--========================================================
-- SEARCH
--========================================================

Search:GetPropertyChangedSignal("Text"):Connect(function()
    local query = Search.Text:lower()

    for _, card in ipairs(Cards) do
        card.Visible = query == ""
            or card.Name:lower():find(query, 1, true) ~= nil
    end
end)

--========================================================
-- FLOATING BUTTON
--========================================================

local Floating = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -12, 0.5, 0),
    Size = UDim2.fromOffset(44, 44),
    BackgroundColor3 = ACCENT,
    Text = "S",
    TextColor3 = BG,
    Font = Enum.Font.GothamBlack,
    TextSize = 20,
    AutoButtonColor = false
}, GUI)

Corner(Floating, 22)

--========================================================
-- OPEN / CLOSE ANIMATION
--========================================================

local Animating = false

local function SetOpen(state)
    if Animating or Open == state then return end

    Open = state
    Animating = true

    if state then
        Main.Visible = true
        Main.GroupTransparency = 1
        Main.Size = UDim2.fromOffset(535, 335)

        local tween = Tween(Main, 1.2, {
            GroupTransparency = 0,
            Size = UDim2.fromOffset(570, 360)
        })

        tween.Completed:Once(function()
            Animating = false
        end)
    else
        local tween = Tween(Main, 1.2, {
            GroupTransparency = 1,
            Size = UDim2.fromOffset(535, 335)
        })

        tween.Completed:Once(function()
            Main.Visible = false
            Animating = false
            Main.Size = UDim2.fromOffset(570, 360)
        end)
    end
end

Floating.Activated:Connect(function()
    SetOpen(not Open)
end)

Close.Activated:Connect(function()
    SetOpen(false)
end)

--========================================================
-- DRAGGING
--========================================================

local dragging = false
local dragStart
local startPosition

Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Positio