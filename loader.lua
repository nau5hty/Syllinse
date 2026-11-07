
--[[
    SYLLINSE V3
    Compact Landscape UI
    UI-only client interface
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
if not Player then return end

local PlayerGui = Player:WaitForChild("PlayerGui")

-- Remove old version
local Old = PlayerGui:FindFirstChild("SYLLINSE")
if Old then Old:Destroy() end

local Purple = Color3.fromRGB(139, 92, 246)
local Dark = Color3.fromRGB(17, 18, 26)
local Panel = Color3.fromRGB(27, 28, 39)
local White = Color3.fromRGB(245, 245, 255)

local Gui = Instance.new("ScreenGui")
Gui.Name = "SYLLINSE"
Gui.ResetOnSpawn = false
Gui.DisplayOrder = 999
Gui.Parent = PlayerGui

local function Make(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local Main = Make("Frame", {
    Size = UDim2.fromOffset(560, 330),
    Position = UDim2.new(0.5, -280, 0.5, -165),
    BackgroundColor3 = Dark,
    BorderSizePixel = 0
}, Gui)

Make("UICorner", {
    CornerRadius = UDim.new(0, 12)
}, Main)

local Scale = Make("UIScale", {
    Scale = 1
}, Main)

local Camera = workspace.CurrentCamera

local function UpdateScale()
    if not Camera then return end

    local size = Camera.ViewportSize
    Scale.Scale = math.min(
        0.85,
        size.X / 600,
        size.Y / 370
    )
end

UpdateScale()

if Camera then
    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
end

-- Sidebar
local Sidebar = Make("Frame", {
    Size = UDim2.new(0, 135, 1, 0),
    BackgroundColor3 = Panel,
    BorderSizePixel = 0
}, Main)

Make("UICorner", {
    CornerRadius = UDim.new(0, 12)
}, Sidebar)

Make("TextLabel", {
    Size = UDim2.new(1, -15, 0, 55),
    Position = UDim2.fromOffset(12, 5),
    BackgroundTransparency = 1,
    Text = "SYLLINSE",
    TextColor3 = Purple,
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left
}, Sidebar)

Make("TextLabel", {
    Size = UDim2.new(1, -15, 0, 20),
    Position = UDim2.fromOffset(12, 40),
    BackgroundTransparency = 1,
    Text = "VERSION 3.0",
    TextColor3 = Color3.fromRGB(140,140,155),
    Font = Enum.Font.Gotham,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left
}, Sidebar)

-- Content
local Content = Make("Frame", {
    Size = UDim2.new(1, -150, 1, -15),
    Position = UDim2.fromOffset(145, 10),
    BackgroundTransparency = 1
}, Main)

Make("TextLabel", {
    Size = UDim2.new(1, -40, 0, 40),
    BackgroundTransparency = 1,
    Text = "SYLLINSE HUB",
    TextColor3 = White,
    Font = Enum.Font.GothamBold,
    TextSize = 19,
    TextXAlignment = Enum.TextXAlignment.Left
}, Content)

local Pages = {}
local ActivePage

local function CreatePage(name)
    local page = Make("ScrollingFrame", {
        Name = name,
        Size = UDim2.new(1, 0, 1, -45),
        Position = UDim2.fromOffset(0, 45),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0,0,0,0),
        Visible = false
    }, Content)

    local layout = Make("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.fromOffset(
            0, layout.AbsoluteContentSize.Y + 10
        )
    end)

    Pages[name] = page
    return page
end

local Dashboard = CreatePage("Dashboard")
local MainPage = CreatePage("Main")
local Visuals = CreatePage("Visuals")
local Settings = CreatePage("Settings")

local function Notify(message)
    local notice = Make("TextLabel", {
        Size = UDim2.fromOffset(210, 38),
        Position = UDim2.new(1, -220, 1, -48),
        BackgroundColor3 = Panel,
        Text = message,
        TextColor3 = White,
        TextSize = 12,
        Font = Enum.Font.GothamMedium
    }, Main)

    Make("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, notice)

    task.delay(2, function()
        if notice.Parent then
            notice:Destroy()
        end
    end)
end

local function Button(parent, name, callback)
    local b = Make("TextButton", {
        Size = UDim2.new(1, -8, 0, 37),
        BackgroundColor3 = Panel,
        Text = name,
        TextColor3 = White,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = true
    }, parent)

    Make("UICorner", {
        CornerRadius = UDim.new(0, 7)
    }, b)

    b.MouseButton1Click:Connect(callback)
    return b
end

local function Toggle(parent, name, callback)
    local enabled = false

    local b = Button(parent, name .. " : OFF", function()
        enabled = not enabled
        b.Text = name .. (enabled and " : ON" or " : OFF")
        b.BackgroundColor3 = enabled and Purple or Panel
        callback(enabled)
    end)

    return b
end

-- Tabs
local function AddTab(name, page, y)
    local tab = Make("TextButton", {
        Size = UDim2.new(1, -18, 0, 36),
        Position = UDim2.fromOffset(9, y),
        BackgroundColor3 = Panel,
        Text = name,
        TextColor3 = White,
        TextSize = 12,
        Font = Enum.Font.GothamMedium
    }, Sidebar)

    Make("UICorner", {
        CornerRadius = UDim.new(0, 7)
    }, tab)

    tab.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do
            p.Visible = false
        end

        page.Visible = true
        ActivePage = page
    end)
end

AddTab("Dashboard", Dashboard, 80)
AddTab("Main", MainPage, 123)
AddTab("Visuals", Visuals, 166)
AddTab("Settings", Settings, 209)

Dashboard.Visible = true
ActivePage = Dashboard

-- Dashboard
Button(Dashboard, "Welcome to SYLLINSE", function()
    Notify("Welcome to SYLLINSE!")
end)

Button(Dashboard, "Show notification", function()
    Notify("Everything is working!")
end)

-- Main
Toggle(MainPage, "Example Feature", function(value)
    Notify("Example Feature " .. (value and "enabled" or "disabled"))
end)

Toggle(MainPage, "Example Option", function(value)
    Notify("Option changed")
end)

-- Visuals
Toggle(Visuals, "Example Visual", function(value)
    Notify("Visual setting changed")
end)

-- Settings
Button(Settings, "Increase GUI size +", function()
    Scale.Scale = math.clamp(Scale.Scale + 0.05, 0.4, 1)
end)

Button(Settings, "Decrease GUI size -", function()
    Scale.Scale = math.clamp(Scale.Scale - 0.05, 0.4, 1)
end)

Button(Settings, "Reset GUI size", function()
    UpdateScale()
end)

local Light = false

Button(Settings, "Switch theme", function()
    Light = not Light

    Main.BackgroundColor3 = Light
        and Color3.fromRGB(235,235,245)
        or Dark

    Sidebar.BackgroundColor3 = Light
        and Color3.fromRGB(215,215,230)
        or Panel

    Notify(Light and "Light theme" or "Dark theme")
end)

-- Minimize / Restore
local Minimize = Button(Settings, "Minimize GUI", function()
    Main.Visible = false
end)

-- Floating toggle
local Floating = Make("TextButton", {
    Size = UDim2.fromOffset(44,44),
    Position = UDim2.new(1,-60,0.5,-22),
    BackgroundColor3 = Purple,
    Text = "S",
    TextColor3 = White,
    TextSize = 21,
    Font = Enum.Font.GothamBold
}, Gui)

Make("UICorner", {
    CornerRadius = UDim.new(1,0)
}, Floating)

Floating.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Draggable window: mouse and touch
local dragging = false
local dragStart
local startPosition
local dragInput

local Topbar = Make("TextButton", {
    Size = UDim2.new(1,-135,0,35),
    Position = UDim2.fromOffset(135,0),
    BackgroundTransparency = 1,
    Text = "",
    Active = true
}, Main)

Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
        dragInput = input

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input == dragInput
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

Notify("SYLLINSE V3 loaded!")

