
--==================================================
-- SYLLINSE V4 | PREMIUM UI
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Cleanup
if PlayerGui:FindFirstChild("SYLLINSE") then
    PlayerGui.SYLLINSE:Destroy()
end

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

local function New(class, properties, parent)
    local obj = Instance.new(class)

    for k, v in pairs(properties) do
        obj[k] = v
    end

    obj.Parent = parent
    return obj
end

local function Animate(obj, duration, properties)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        properties
    )
    t:Play()
    return t
end

-- Main GUI
local Gui = New("ScreenGui", {
    Name = "SYLLINSE",
    ResetOnSpawn = false,
    DisplayOrder = 100
}, PlayerGui)

local Main = New("Frame", {
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

New("UIStroke", {
    Color = Accent,
    Transparency = 0.65,
    Thickness = 1
}, Main)

local UIScale = New("UIScale", {
    Scale = ScaleValue
}, Main)

local function UpdateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local size = camera.ViewportSize

    UIScale.Scale = math.min(
        ScaleValue,
        (size.X - 25) / 590,
        (size.Y - 25) / 365
    )
end

UpdateScale()

-- Sidebar
local Sidebar = New("Frame", {
    Size = UDim2.new(0, 145, 1, 0),
    BackgroundColor3 = Panel,
    BorderSizePixel = 0
}, Main)

New("TextLabel", {
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
    Text = "PREMIUM V4",
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

-- Content
local Content = New("Frame", {
    Position = UDim2.fromOffset(157, 10),
    Size = UDim2.new(1, -167, 1, -20),
    BackgroundTransparency = 1
}, Main)

local Header = New("TextLabel", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundTransparency = 1,
    Text = "Home",
    TextColor3 = TextColor,
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left
}, Content)

local Pages = {}
local TabButtons = {}

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

-- Notifications
local function Notify(message)
    local Toast = New("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, 0, 1, 10),
        Size = UDim2.fromOffset(220, 42),
        BackgroundColor3 = Panel,
        BorderSizePixel = 0,
        ZIndex = 20
    }, Gui)

    New("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, Toast)

    New("TextLabel", {
        Size = UDim2.new(1, -15, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = TextColor,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21
    }, Toast)

    Animate(Toast, 0.25, {
        Position = UDim2.new(1, -10, 1, -12)
    })

    task.delay(2, function()
        if Toast.Parent then
            Animate(Toast, 0.2, {
                Position = UDim2.new(1, 0, 1, 10)
            })
            task.wait(0.25)
            Toast:Destroy()
        end
    end)
end

-- Section
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

-- Button
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

    B.Activated:Connect(callback)

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

-- Toggle
local function Toggle(parent, name, callback)
    local Enabled = false

    local B = Button(parent, name .. "  [ OFF ]", function()
        Enabled = not Enabled

        B.Text = name .. (Enabled and "  [ ON ]" or "  [ OFF ]")
        B.BackgroundColor3 = Enabled and Accent or Panel

        if callback then
            callback(Enabled)
        end
    end)

    return B
end

-- Navigation
local function ShowTab(name)
    CurrentTab = name

    for n, page in pairs(Pages) do
        page.Visible = n == name
    end

    for n, button in pairs(TabButtons) do
        button.BackgroundColor3 = n == name and Accent or Panel
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

-- Home
Section(Home, "Welcome to SYLLINSE", "Premium interface V4 is ready.")

Button(Home, "Test notification", function()
    Notify("SYLLINSE is working!")
end)

Toggle(Home, "Example UI option", function(value)
    Notify(value and "Option enabled" or "Option disabled")
end)

-- Settings
Section(Settings, "Appearance", "Customize your interface.")

Button(Settings, "Theme: Purple", function()
    Accent = Themes.Purple
    Notify("Purple theme selected")
end)

Button(Settings, "Theme: Blue", function()
    Accent = Themes.Blue
    Notify("Blue theme selected")
end)

Button(Settings, "Theme: Red", function()
    Accent = Themes.Red
    Notify("Red theme selected")
end)

Button(Settings, "Theme: Green", function()
    Accent = Themes.Green
    Notify("Green theme selected")
end)

local function ApplyTheme()
    Main:FindFirstChildOfClass("UIStroke").Color = Accent
    Sidebar.BackgroundColor3 = Panel
    brand = Sidebar:FindFirstChildOfClass("TextLabel")
    if brand then brand.TextColor3 = Accent end

    for name, button in pairs(TabButtons) do
        button.BackgroundColor3 = name == CurrentTab and Accent or Panel
    end

    Floating.BackgroundColor3 = Accent
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

Button(Settings, "Apply selected theme", function()
    ApplyTheme()
    Notify("Theme applied!")
end)

-- Floating button
local Floating = New("TextButton", {
    Name = "MobileToggle",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -15, 0.5, 0),
    Size = UDim2.fromOffset(45, 45),
    BackgroundColor3 = Accent,
    Text = "S",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 21
}, Gui)

New("UICorner", {
    CornerRadius = UDim.new(1, 0)
}, Floating)

Floating.Activated:Connect(function()
    Visible = not Visible
    Main.Visible = Visible

    if Visible then
        Main.Size = UDim2.fromOffset(0, 0)
        Animate(Main, 0.25, {
            Size = UDim2.fromOffset(590, 365)
        })
    end
end)

-- Floating button visibility
Toggle(Settings, "Floating button", function(value)
    Floating.Visible = value
end)

-- Minimize
Button(Settings, "Minimize window", function()
    Main.Visible = false
    Visible = false
end)

-- About
Section(About, "SYLLINSE V4", "Premium UI edition.")
Section(About, "Keyboard shortcut", "RightShift toggles the main window.")
Button(About, "Show notification", function()
    Notify("Thanks for using SYLLINSE!")
end)

ShowTab("Home")

-- Draggable window
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
local DragInput

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

-- Keyboard toggle
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.RightShift then
        Visible = not Visible
        Main.Visible = Visible
    end
end)

-- Mobile floating button dragging
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

        local delta = input.Position - FloatStart

        if delta.Magnitude > 5 then
            FloatMoved = true
            Floating.Position = UDim2.new(
                FloatPosition.X.Scale,
                FloatPosition.X.Offset + delta.X,
                FloatPosition.Y.Scale,
                FloatPosition.Y.Offset + delta.Y
            )
        end
    end
end)

-- Initial animation
Main.Size = UDim2.fromOffset(0, 0)

Animate(Main, 0.35, {
    Size = UDim2.fromOffset(590, 365)
})

Notify("SYLLINSE V4 loaded successfully!")
