
--========================================================
-- SYLLINSE V6 | OROBOROUS-INSPIRED UI
-- Dark charcoal / neon lime design
-- Standalone interface and demo controls
--========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Cleanup
local Old = PlayerGui:FindFirstChild("SYLLINSE")
if Old then Old:Destroy() end

--========================================================
-- CONFIG
--========================================================

local GREEN = Color3.fromRGB(178, 255, 65)
local BG = Color3.fromRGB(15, 16, 17)
local PANEL = Color3.fromRGB(23, 24, 26)
local CARD = Color3.fromRGB(29, 30, 32)
local MUTED = Color3.fromRGB(135, 138, 140)
local WHITE = Color3.fromRGB(240, 242, 238)

local Open = true
local CurrentTab = "Main"
local SearchText = ""
local Scale = 1

local Tabs = {}
local Pages = {}
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

--========================================================
-- SCREEN GUI
--========================================================

local GUI = New("ScreenGui", {
    Name = "SYLLINSE",
    ResetOnSpawn = false,
    DisplayOrder = 100
}, PlayerGui)

local Main = New("Frame", {
    Name = "Window",
    Size = UDim2.fromOffset(570, 350),
    Position = UDim2.new(0.5, -285, 0.5, -175),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, GUI)

New("UICorner", {
    CornerRadius = UDim.new(0, 11)
}, Main)

New("UIStroke", {
    Color = Color3.fromRGB(55, 58, 53),
    Transparency = 0.25,
    Thickness = 1
}, Main)

local UIScale = New("UIScale", {
    Scale = 1
}, Main)

--========================================================
-- TOP BAR
--========================================================

local Top = New("Frame", {
    Size = UDim2.new(1, 0, 0, 43),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, Main)

local Logo = New("TextLabel", {
    Position = UDim2.fromOffset(15, 0),
    Size = UDim2.fromOffset(110, 43),
    BackgroundTransparency = 1,
    Text = "◈  SYLLINSE",
    TextColor3 = GREEN,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left
}, Top)

New("TextLabel", {
    Position = UDim2.fromOffset(130, 0),
    Size = UDim2.fromOffset(100, 43),
    BackgroundTransparency = 1,
    Text = "V6  /  PREMIUM",
    TextColor3 = MUTED,
    Font = Enum.Font.GothamMedium,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left
}, Top)

local Close = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -12, 0.5, 0),
    Size = UDim2.fromOffset(25, 25),
    BackgroundColor3 = CARD,
    Text = "×",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 17,
    AutoButtonColor = false
}, Top)

New("UICorner", {
    CornerRadius = UDim.new(0, 6)
}, Close)

--========================================================
-- SIDEBAR
--========================================================

local Sidebar = New("Frame", {
    Position = UDim2.fromOffset(0, 43),
    Size = UDim2.new(0, 125, 1, -43),
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
    Position = UDim2.fromOffset(8, 42),
    Size = UDim2.new(1, -16, 0, 210),
    BackgroundTransparency = 1
}, Sidebar)

New("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder
}, Nav)

local TabNames = {
    {"Main", "⌂"},
    {"Player", "◉"},
    {"Visuals", "◈"},
    {"Settings", "⚙"},
    {"About", "ⓘ"}
}

local function SelectTab(name)
    CurrentTab = name

    for tab, button in pairs(Tabs) do
        local selected = tab == name

        button.BackgroundColor3 =
            selected and Color3.fromRGB(48, 58, 38) or PANEL

        button.TextColor3 = selected and GREEN or MUTED
    end

    for tab, page in pairs(Pages) do
        page.Visible = tab == name
    end
end

--========================================================
-- CONTENT AREA
--========================================================

local Content = New("Frame", {
    Position = UDim2.fromOffset(135, 53),
    Size = UDim2.new(1, -145, 1, -63),
    BackgroundTransparency = 1
}, Main)

local Heading = New("TextLabel", {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Text = "Main",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left
}, Content)

local Search = New("TextBox", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 2),
    Size = UDim2.fromOffset(155, 26),
    BackgroundColor3 = CARD,
    Text = "",
    PlaceholderText = "⌕  Search...",
    PlaceholderColor3 = MUTED,
    TextColor3 = WHITE,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    ClearTextOnFocus = false
}, Content)

New("UICorner", {
    CornerRadius = UDim.new(0, 6)
}, Search)

local function CreatePage(name)
    local page = New("ScrollingFrame", {
        Name = name,
        Position = UDim2.fromOffset(0, 39),
        Size = UDim2.new(1, 0, 1, -39),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = GREEN,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false
    }, Content)

    New("UIGridLayout", {
        CellSize = UDim2.new(0.5, -6, 0, 78),
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
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = PANEL,
        Text = "   " .. symbol .. "    " .. name,
        TextColor3 = MUTED,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, Nav)

    New("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, button)

    Tabs[name] = button

    button.Activated:Connect(function()
        Heading.Text = name
        SelectTab(name)
    end)

    CreatePage(name)
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

    New("UICorner", {
        CornerRadius = UDim.new(0, 7)
    }, card)

    New("UIStroke", {
        Color = Color3.fromRGB(48, 50, 48),
        Transparency = 0.55
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
        Position = UDim2.fromOffset(10, 28),
        Size = UDim2.new(1, -18, 0, 17),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = MUTED,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    Cards[#Cards + 1] = card
    return card
end

--========================================================
-- TOGGLE CONTROL
--========================================================

local function AddToggle(parent, title, description, callback)
    local card = CreateCard(parent, title, description)

    local switch = New("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(34, 18),
        BackgroundColor3 = Color3.fromRGB(58, 60, 60),
        Text = "",
        AutoButtonColor = false
    }, card)

    New("UICorner", {
        CornerRadius = UDim.new(1, 0)
    }, switch)

    local knob = New("Frame", {
        Position = UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0
    }, switch)

    New("UICorner", {
        CornerRadius = UDim.new(1, 0)
    }, knob)

    local enabled = false

    switch.Activated:Connect(function()
        enabled = not enabled

        Tween(switch, 0.18, {
            BackgroundColor3 = enabled and GREEN
                or Color3.fromRGB(58, 60, 60)
        })

        Tween(knob, 0.18, {
            Position = enabled
                and UDim2.new(1, -15, 0, 3)
                or UDim2.fromOffset(3, 3)
        })

        if callback then
            callback(enabled)
        end
    end)

    return card
end

--========================================================
-- BUTTON CONTROL
--========================================================

local function AddButton(parent, title, description, callback)
    local card = CreateCard(parent, title, description)

    local button = New("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(48, 23),
        BackgroundColor3 = Color3.fromRGB(48, 58, 38),
        Text = "RUN",
        TextColor3 = GREEN,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        AutoButtonColor = false
    }, card)

    New("UICorner", {
        CornerRadius = UDim.new(0, 5)
    }, button)

    button.Activated:Connect(function()
        if callback then callback() end
    end)

    return card
end

--========================================================
-- MAIN PAGE
--========================================================

local MainPage = Pages.Main

AddToggle(
    MainPage,
    "Demo Toggle",
    "Example interface switch",
    function(v)
        print("Demo Toggle:", v)
    end
)

AddToggle(
    MainPage,
    "Notifications",
    "Example notification setting",
    function(v)
        print("Notifications:", v)
    end
)

AddToggle(
    MainPage,
    "Interface Effects",
    "Example visual setting",
    function(v)
        print("Interface Effects:", v)
    end
)

AddButton(
    MainPage,
    "Test Button",
    "Test the button interaction",
    function()
        print("SYLLINSE: Button clicked")
    end
)

--========================================================
-- PLAYER PAGE
--========================================================

local PlayerPage = Pages.Player

AddToggle(
    PlayerPage,
    "Player Demo",
    "Example player setting",
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
    "Example highlight setting",
    function(v)
        print("Highlight Demo:", v)
    end
)

AddButton(
    VisualPage,
    "Preview",
    "Test a visual interface action",
    function()
        print("Preview clicked")
    end
)

--========================================================
-- SETTINGS PAGE
--========================================================

local SettingsPage = Pages.Settings

local themeCard = CreateCard(
    SettingsPage,
    "Accent Colour",
    "Choose your interface colour"
)

local themeButton = New("TextButton", {
    Position = UDim2.new(1, -105, 0.5, -12),
    Size = UDim2.fromOffset(95, 24),
    BackgroundColor3 = GREEN,
    Text = "LIME  ▼",
    TextColor3 = BG,
    Font = Enum.Font.GothamBold,
    TextSize = 9,
    AutoButtonColor = false
}, themeCard)

New("UICorner", {
    CornerRadius = UDim.new(0, 5)
}, themeButton)

local themePopup = New("Frame", {
    Position = UDim2.new(1, -110, 0, 68),
    Size = UDim2.fromOffset(100, 0),
    BackgroundColor3 = PANEL,
    Visible = false,
    ClipsDescendants = true,
    ZIndex = 20
}, SettingsPage)

New("UICorner", {
    CornerRadius = UDim.new(0, 6)
}, themePopup)

New("UIListLayout", {
    Padding = UDim.new(0, 3)
}, themePopup)

local function SetAccent(color, name)
    GREEN = color

    themeButton.Text = name .. "  ▼"
    themeButton.BackgroundColor3 = color

    for _, object in ipairs(GUI:GetDescendants()) do
        if object:IsA("UIStroke") then
            if object.Name == "AccentStroke" then
                object.Color = color
            end
        end
    end

    Logo.TextColor3 = color
end

local themes = {
    {"LIME", Color3.fromRGB(178, 255, 65)},
    {"BLUE", Color3.fromRGB(75, 155, 255)},
    {"PURPLE", Color3.fromRGB(170, 105, 255)},
    {"RED", Color3.fromRGB(255, 85, 95)}
}

for _, item in ipairs(themes) do
    local name, color = item[1], item[2]

    local b = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundColor3 = CARD,
        Text = name,
        TextColor3 = color,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        ZIndex = 21
    }, themePopup)

    b.Activated:Connect(function()
        SetAccent(color, name)
        themePopup.Visible = false
        themePopup.Size = UDim2.fromOffset(100, 0)
    end)
end

themeButton.Activated:Connect(function()
    themePopup.Visible = not themePopup.Visible

    if themePopup.Visible then
        Tween(themePopup, 0.2, {
            Size = UDim2.fromOffset(100, 105)
        })
    else
        Tween(themePopup, 0.15, {
            Size = UDim2.fromOffset(100, 0)
        })
    end
end)

AddButton(
    SettingsPage,
    "Reset UI",
    "Restore the default interface layout",
    function()
        SetAccent(themes[1][2], "LIME")
        print("UI settings reset")
    end
)

--========================================================
-- ABOUT PAGE
--========================================================

local AboutPage = Pages.About

AddButton(
    AboutPage,
    "SYLLINSE V6",
    "Premium interface edition",
    function()
        print("SYLLINSE V6")
    end
)

AddButton(
    AboutPage,
    "Developer",
    "Made for the SYLLINSE project",
    function()
        print("SYLLINSE")
    end
)

--========================================================
-- SEARCH
--========================================================

local function FilterCards()
    local query = SearchText:lower()

    for _, card in ipairs(Cards) do
        local matches =
            card.Name:lower():find(query, 1, true) ~= nil

        card.Visible = matches
    end
end

Search:GetPropertyChangedSignal("Text"):Connect(function()
    SearchText = Search.Text
    FilterCards()
end)

--========================================================
-- FLOATING BUTTON
--========================================================

local Floating = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -15, 0.5, 0),
    Size = UDim2.fromOffset(43, 43),
    BackgroundColor3 = GREEN,
    Text = "S",
    TextColor3 = BG,
    Font = Enum.Font.GothamBlack,
    TextSize = 20,
    AutoButtonColor = false
}, GUI)

New("UICorner", {
    CornerRadius = UDim.new(1, 0)
}, Floating)

--========================================================
-- OPEN / CLOSE
--========================================================

local function SetOpen(state)
    Open = state

    if state then
        Main.Visible = true
        Main.Size = UDim2.fromOffset(0, 0)

        Tween(Main, 0.3, {
            Size = UDim2.fromOffset(570, 350)
        })
    else
        local t = Tween(Main, 0.22, {
            Size = UDim2.fromOffset(0, 0)
        })

        t.Completed:Once(function()
            if not Open then
                Main.Visible = false
            end
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
        startPosition = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then

        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

--========================================================
-- KEYBOARD
--========================================================

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.RightShift then
        SetOpen(not Open)
    end
end)

--========================================================
-- RESPONSIVE SIZE
--========================================================

local function UpdateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local viewport = camera.ViewportSize

    UIScale.Scale = math.min(
        1,
        (viewport.X - 20) / 570,
        (viewport.Y - 20) / 350
    )
end

UpdateScale()

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal(
        "ViewportSize"
    ):Connect(UpdateScale)
end

--========================================================
-- INITIALIZE
--========================================================

SelectTab("Main")

Main.Size = UDim2.fromOffset(0, 0)

Tween(Main, 0.35, {
    Size = UDim2.fromOffset(570, 350)
})

print("SYLLINSE V6 loaded successfully!")
