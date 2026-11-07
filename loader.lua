
--==================================================
-- SYLLINSE V5 | PREMIUM UI
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Cleanup
local OldGui = PlayerGui:FindFirstChild("SYLLINSE")
if OldGui then
    OldGui:Destroy()
end

--==================================================
-- CONFIGURATION
--==================================================

local Themes = {
    Purple = Color3.fromRGB(145, 95, 255),
    Blue = Color3.fromRGB(65, 145, 255),
    Red = Color3.fromRGB(245, 75, 95),
    Green = Color3.fromRGB(55, 205, 135)
}

local Accent = Themes.Purple
local Dark = Color3.fromRGB(17, 18, 26)
local Panel = Color3.fromRGB(27, 28, 39)
local TextColor = Color3.fromRGB(245, 245, 255)

local Visible = true
local ScaleValue = 0.85
local CurrentTab = "Home"

local Main
local Floating
local UIScale
local Header
local Sidebar
local ThemePopup

local Pages = {}
local TabButtons = {}

local WindowTween
local ToastOrder = 0

--==================================================
-- HELPERS
--==================================================

local function New(class, properties, parent)
    local obj = Instance.new(class)

    for k, v in pairs(properties) do
        obj[k] = v
    end

    obj.Parent = parent
    return obj
end

local function Animate(obj, duration, properties)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(
            duration,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        properties
    )

    tween:Play()
    return tween
end

local function UpdateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local size = camera.ViewportSize

    UIScale.Scale = math.max(
        0.35,
        math.min(
            ScaleValue,
            (size.X - 25) / 590,
            (size.Y - 25) / 365
        )
    )
end

--==================================================
-- MAIN GUI
--==================================================

local Gui = New("ScreenGui", {
    Name = "SYLLINSE",
    ResetOnSpawn = false,
    DisplayOrder = 100
}, PlayerGui)

Main = New("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(590, 365),
    Position = UDim2.new(0.5, -295, 0.5, -182),
    BackgroundColor3 = Dark,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, Gui)

New("UICorner", {
    CornerRadius = UDim.new(0, 12)
}, Main)

local MainStroke = New("UIStroke", {
    Color = Accent,
    Transparency = 0.65,
    Thickness = 1
}, Main)

UIScale = New("UIScale", {
    Scale = ScaleValue
}, Main)

UpdateScale()

--==================================================
-- SIDEBAR
--==================================================

Sidebar = New("Frame", {
    Size = UDim2.new(0, 145, 1, 0),
    BackgroundColor3 = Panel,
    BorderSizePixel = 0
}, Main)

local Brand = New("TextLabel", {
    Size = UDim2.new(1, -15, 0, 35),
    Position = UDim2.fromOffset(12, 12),
    BackgroundTransparency = 1,
    Text = "SYLLINSE",
    TextColor3 = Accent,
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left
}, Sidebar)

New("TextLabel", {
    Size = UDim2.new(1, -15, 0, 20),
    Position = UDim2.fromOffset(12, 43),
    BackgroundTransparency = 1,
    Text = "PREMIUM V5",
    TextColor3 = Color3.fromRGB(140, 140, 155),
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left
}, Sidebar)

local Nav = New("Frame", {
    Position = UDim2.fromOffset(9, 85),
    Size = UDim2.new(1, -18, 1, -95),
    BackgroundTransparency = 1
}, Sidebar)

New("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder
}, Nav)

--==================================================
-- CONTENT
--==================================================

local Content = New("Frame", {
    Position = UDim2.fromOffset(157, 10),
    Size = UDim2.new(1, -167, 1, -20),
    BackgroundTransparency = 1
}, Main)

Header = New("TextLabel", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundTransparency = 1,
    Text = "Home",
    TextColor3 = TextColor,
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left
}, Content)

local function CreatePage(name)
    local page = New("ScrollingFrame", {
        Name = name,
        Position = UDim2.fromOffset(0, 45),
        Size = UDim2.new(1, 0, 1, -45),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false
    }, Content)

    New("UIListLayout", {
        Padding = UDim.new(0, 9),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    Pages[name] = page
    return page
end

local Home = CreatePage("Home")
local Settings = CreatePage("Settings")
local About = CreatePage("About")

--==================================================
-- NOTIFICATION SYSTEM
--==================================================

local ToastHolder = New("Frame", {
    Name = "Notifications",
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -12, 1, -12),
    Size = UDim2.fromOffset(240, 190),
    BackgroundTransparency = 1,
    ZIndex = 50
}, Gui)

New("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    HorizontalAlignment = Enum.HorizontalAlignment.Right
}, ToastHolder)

local function Notify(message)
    ToastOrder = ToastOrder + 1

    local Toast = New("Frame", {
        Size = UDim2.fromOffset(225, 42),
        BackgroundColor3 = Panel,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = ToastOrder,
        ZIndex = 50
    }, ToastHolder)

    New("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, Toast)

    New("UIStroke", {
        Color = Accent,
        Transparency = 0.55
    }, Toast)

    local Label = New("TextLabel", {
        Size = UDim2.new(1, -15, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Text = tostring(message),
        TextColor3 = TextColor,
        TextTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 51
    }, Toast)

    Animate(Toast, 0.2, {
        BackgroundTransparency = 0
    })

    Animate(Label, 0.2, {
        TextTransparency = 0
    })

    task.delay(2.5, function()
        if not Toast.Parent then return end

        Animate(Toast, 0.2, {
            BackgroundTransparency = 1
        })

        Animate(Label, 0.2, {
            TextTransparency = 1
        })

        task.wait(0.22)

        if Toast.Parent then
            Toast:Destroy()
        end
    end)
end

--==================================================
-- COMPONENTS
--==================================================

local function Section(parent, title, description)
    local Card = New("Frame", {
        Size = UDim2.new(1, -5, 0, description and 58 or 40),
        BackgroundColor3 = Panel,
        BorderSizePixel = 0
    }, parent)

    New("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, Card)

    New("TextLabel", {
        Position = UDim2.fromOffset(12, 5),
        Size = UDim2.new(1, -20, 0, 24),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = TextColor,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Card)

    if description then
        New("TextLabel", {
            Position = UDim2.fromOffset(12, 29),
            Size = UDim2.new(1, -20, 0, 20),
            BackgroundTransparency = 1,
            Text = description,
            TextColor3 = Color3.fromRGB(155, 155, 170),
            Font = Enum.Font.Gotham,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left
        }, Card)
    end

    return Card
end

local function Button(parent, name, callback)
    local B = New("TextButton", {
        Size = UDim2.new(1, -5, 0, 38),
        BackgroundColor3 = Panel,
        Text = name,
        TextColor3 = TextColor,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        AutoButtonColor = false
    }, parent)

    New("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, B)

    B.Activated:Connect(function()
        if callback then
            callback()
        end
    end)

    B.MouseEnter:Connect(function()
        Animate(B, 0.15, {
            BackgroundColor3 = Accent
        })
    end)

    B.MouseLeave:Connect(function()
        Animate(B, 0.15, {
            BackgroundColor3 = Panel
        })
    end)

    return B
end

-- Fixed toggle function
local function Toggle(parent, name, callback)
    local Enabled = false
    local B

    B = Button(parent, name .. "  [ OFF ]", function()
        Enabled = not Enabled

        B.Text = name .. (Enabled and "  [ ON ]" or "  [ OFF ]")

        Animate(B, 0.15, {
            BackgroundColor3 = Enabled and Accent or Panel
        })

        if callback then
            callback(Enabled)
        end
    end)

    return B
end

--==================================================
-- NAVIGATION
--==================================================

local function ShowTab(name)
    CurrentTab = name

    for n, page in pairs(Pages) do
        page.Visible = n == name
    end

    for n, button in pairs(TabButtons) do
        button.BackgroundColor3 =
            n == name and Accent or Panel
    end

    Header.Text = name
end

local function AddTab(name)
    local B = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Panel,
        Text = name,
        TextColor3 = TextColor,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        AutoButtonColor = false
    }, Nav)

    New("UICorner", {
        CornerRadius = UDim.new(0, 7)
    }, B)

    B.Activated:Connect(function()
        ShowTab(name)
    end)

    TabButtons[name] = B
end

AddTab("Home")
AddTab("Settings")
AddTab("About")

--==================================================
-- HOME
--==================================================

Section(Home, "Welcome to SYLLINSE", "Premium interface V5 is ready.")

Button(Home, "Test notification", function()
    Notify("SYLLINSE is working!")
end)

Toggle(Home, "Example UI option", function(value)
    Notify(value and "Option enabled" or "Option disabled")
end)

--==================================================
-- SETTINGS
--==================================================

Section(Settings, "Appearance", "Customize your interface.")

-- Single colour selection button
local ColourButton = Button(Settings, "Colour  >  Choose theme", function()
    ThemePopup.Visible = not ThemePopup.Visible

    if ThemePopup.Visible then
        ThemePopup.Size = UDim2.fromOffset(185, 0)

        Animate(ThemePopup, 0.22, {
            Size = UDim2.fromOffset(185, 160)
        })
    else
        Animate(ThemePopup, 0.18, {
            Size = UDim2.fromOffset(185, 0)
        })

        task.delay(0.2, function()
            if ThemePopup and not ThemePopup.Visible then
                ThemePopup.Visible = false
            end
        end)
    end
end)

-- Theme dropdown
ThemePopup = New("Frame", {
    Name = "ThemePopup",
    Position = UDim2.new(0, 5, 0, 100),
    Size = UDim2.fromOffset(185, 0),
    BackgroundColor3 = Dark,
    BorderSizePixel = 0,
    Visible = false,
    ClipsDescendants = true,
    ZIndex = 30
}, Settings)

New("UICorner", {
    CornerRadius = UDim.new(0, 9)
}, ThemePopup)

New("UIStroke", {
    Color = Accent,
    Transparency = 0.4
}, ThemePopup)

local ThemeList = New("Frame", {
    Position = UDim2.fromOffset(6, 6),
    Size = UDim2.new(1, -12, 1, -12),
    BackgroundTransparency = 1,
    ZIndex = 31
}, ThemePopup)

New("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder
}, ThemeList)

local function ApplyTheme()
    MainStroke.Color = Accent
    Brand.TextColor3 = Accent

    for name, button in pairs(TabButtons) do
        button.BackgroundColor3 =
            name == CurrentTab and Accent or Panel
    end

    if Floating then
        Floating.BackgroundColor3 = Accent
    end

    local stroke = ThemePopup:FindFirstChildOfClass("UIStroke")
    if stroke then
        stroke.Color = Accent
    end
end

local function ChooseTheme(name, color)
    Accent = color
    ApplyTheme()

    ThemePopup.Visible = false
    ThemePopup.Size = UDim2.fromOffset(185, 0)

    Notify(name .. " theme selected")
end

local ThemeOptions = {
    {"Purple", Themes.Purple},
    {"Blue", Themes.Blue},
    {"Red", Themes.Red},
    {"Green", Themes.Green}
}

for _, option in ipairs(ThemeOptions) do
    local name = option[1]
    local color = option[2]

    local B = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Panel,
        Text = name,
        TextColor3 = TextColor,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        AutoButtonColor = false,
        ZIndex = 32
    }, ThemeList)

    New("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, B)

    B.Activated:Connect(function()
        ChooseTheme(name, color)
    end)
end

-- Size controls
Button(Settings, "Increase GUI size +", function()
    ScaleValue = math.clamp(ScaleValue + 0.08, 0.5, 1)
    UpdateScale()
    Notify("GUI size increased")
end)

Button(Settings, "Decrease GUI size -", function()
    ScaleValue = math.clamp(ScaleValue - 0.08, 0.5, 1)
    UpdateScale()
    Notify("GUI size decreased")
end)

Button(Settings, "Reset GUI size", function()
    ScaleValue = 0.85
    UpdateScale()
    Notify("GUI size reset")
end)

--==================================================
-- FLOATING MOBILE BUTTON
--==================================================

Floating = New("TextButton", {
    Name = "MobileToggle",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -15, 0.5, 0),
    Size = UDim2.fromOffset(45, 45),
    BackgroundColor3 = Accent,
    Text = "S",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 21,
    AutoButtonColor = false
}, Gui)

New("UICorner", {
    CornerRadius = UDim.new(1, 0)
}, Floating)

New("UIStroke", {
    Color = Color3.new(1, 1, 1),
    Transparency = 0.8
}, Floating)

--==================================================
-- OPEN / CLOSE ANIMATION
--==================================================

local function SetWindowVisible(state)
    if WindowTween then
        WindowTween:Cancel()
    end

    Visible = state

    if state then
        Main.Visible = true
        Main.Size = UDim2.fromOffset(0, 0)

        WindowTween = Animate(Main, 0.3, {
            Size = UDim2.fromOffset(590, 365)
        })
    else
        WindowTween = Animate(Main, 0.22, {
            Size = UDim2.fromOffset(0, 0)
        })

        WindowTween.Completed:Connect(function()
            if not Visible then
                Main.Visible = false
            end
        end)
    end
end

Floating.Activated:Connect(function()
    SetWindowVisible(not Visible)
end)

Toggle(Settings, "Floating button", function(value)
    Floating.Visible = value
end)

Button(Settings, "Minimize window", function()
    SetWindowVisible(false)
end)

--==================================================
-- ABOUT
--==================================================

Section(About, "SYLLINSE V5", "Premium UI edition.")

Section(About, "Keyboard shortcut", "RightShift toggles the main window.")

Button(About, "Show notification", function()
    Notify("Thanks for using SYLLINSE!")
end)

--==================================================
-- DRAGGABLE MAIN WINDOW
--==================================================

local DragHandle = New("TextButton", {
    Position = UDim2.fromOffset(145, 0),
    Size = UDim2.new(1, -145, 0, 12),
    BackgroundTransparency = 1,
    Text = "",
    Active = true
}, Main)

local Dragging = false
local DragStart
local StartPosition

DragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = input.Position
        StartPosition = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if Dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then

        local Delta = input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

--==================================================
-- RIGHT SHIFT SHORTCUT
--==================================================

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.RightShift then
        SetWindowVisible(not Visible)
    end
end)

--==================================================
-- FLOATING BUTTON DRAGGING
--==================================================

local FloatDragging = false
local FloatStart
local FloatPosition
local FloatMoved = false

Floating.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then

        FloatDragging = true
        FloatMoved = false
        FloatStart = input.Position
        FloatPosition = Floating.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                FloatDragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if FloatDragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then

        local Delta = input.Position - FloatStart

        if Delta.Magnitude > 5 then
            FloatMoved = true

            Floating.Position = UDim2.new(
                FloatPosition.X.Scale,
                FloatPosition.X.Offset + Delta.X,
                FloatPosition.Y.Scale,
                FloatPosition.Y.Offset + Delta.Y
            )
        end
    end
end)

--==================================================
-- INITIALIZATION
--==================================================

ShowTab("Home")

Main.Size = UDim2.fromOffset(0, 0)
Main.Visible = true

WindowTween = Animate(Main, 0.35, {
    Size = UDim2.fromOffset(590, 365)
})

Notify("SYLLINSE V5 loaded successfully!")
