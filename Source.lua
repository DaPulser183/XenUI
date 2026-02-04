-- XenUI Library - Source.lua
-- Full version with Button, Toggle, Slider, Dropdown, Label, Section

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local windows = {}
local toggleKey = Enum.KeyCode.RightShift

-- Shared ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XenUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

function Library:CreateWindow(options)
    options = options or {}
    local title = options.Title or "XenUI"
    local size = options.Size or UDim2.new(0, 450, 0, 380)

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainWindow"
    mainFrame.Size = size
    mainFrame.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1
    stroke.Parent = mainFrame

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1,1,1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar

    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "Close"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 2)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1,1,1)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton

    closeButton.MouseButton1Click:Connect(function()
        mainFrame:Destroy()
        table.remove(windows, table.find(windows, window))
    end)

    -- Content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -55)
    contentFrame.Position = UDim2.new(0, 10, 0, 45)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    local contentList = Instance.new("UIListLayout")
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Padding = UDim.new(0, 6)
    contentList.Parent = contentFrame

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 8)
    contentPadding.PaddingBottom = UDim.new(0, 8)
    contentPadding.PaddingLeft = UDim.new(0, 8)
    contentPadding.PaddingRight = UDim.new(0, 8)
    contentPadding.Parent = contentFrame

    local window = {}

    function window:Toggle()
        mainFrame.Visible = not mainFrame.Visible
    end

    -- Button
    function window:Button(text, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 36)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.Text = text
        button.TextColor3 = Color3.new(1,1,1)
        button.TextScaled = true
        button.Font = Enum.Font.GothamSemibold
        button.Parent = contentFrame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = button

        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(70, 70, 70)
        btnStroke.Thickness = 1
        btnStroke.Parent = button

        local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        button.MouseEnter:Connect(function()
            TweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        end)

        button.MouseLeave:Connect(function()
            TweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        end)

        button.MouseButton1Click:Connect(callback)

        return button
    end

    -- Toggle
    function window:Toggle(text, callback, default)
        local value = default or false

        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, 0, 0, 36)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = contentFrame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -70, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.new(1,1,1)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 50, 0, 26)
        toggleBtn.Position = UDim2.new(1, -55, 0.5, -13)
        toggleBtn.BackgroundColor3 = value and Color3.fromRGB(0, 170, 80) or Color3.fromRGB(170, 0, 0)
        toggleBtn.Text = value and "ON" or "OFF"
        toggleBtn.TextColor3 = Color3.new(1,1,1)
        toggleBtn.Font = Enum.Font.GothamSemibold
        toggleBtn.Parent = toggleFrame

        local togCorner = Instance.new("UICorner")
        togCorner.CornerRadius = UDim.new(0, 6)
        togCorner.Parent = toggleBtn

        toggleBtn.MouseButton1Click:Connect(function()
            value = not value
            toggleBtn.Text = value and "ON" or "OFF"
            toggleBtn.BackgroundColor3 = value and Color3.fromRGB(0, 170, 80) or Color3.fromRGB(170, 0, 0)
            callback(value)
        end)

        return toggleBtn
    end

    -- Slider
    function window:Slider(text, min, max, default, callback)
        local value = default or min

        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, 0, 0, 50)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = contentFrame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. value
        label.TextColor3 = Color3.new(1,1,1)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sliderFrame

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 0, 10)
        bar.Position = UDim2.new(0, 0, 0, 25)
        bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        bar.Parent = sliderFrame

        local barCorner = Instance.new("UICorner")
        barCorner.CornerRadius = UDim.new(0, 5)
        barCorner.Parent = bar

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
        fill.Parent = bar

        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 5)
        fillCorner.Parent = fill

        local dragging = false

        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)

        bar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local pos = input.Position.X
                local rel = math.clamp((pos - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                value = math.round(min + rel * (max - min))
                fill.Size = UDim2.new(rel, 0, 1, 0)
                label.Text = text .. ": " .. value
                callback(value)
            end
        end)

        return sliderFrame
    end

    -- Dropdown
    function window:Dropdown(text, options, default, callback)
        local selected = default or options[1] or "Select..."

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 36)
        frame.BackgroundTransparency = 1
        frame.Parent = contentFrame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.new(1,1,1)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 160, 0, 30)
        btn.Position = UDim2.new(1, -170, 0.5, -15)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.Text = selected
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.Parent = frame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        local list = Instance.new("ScrollingFrame")
        list.Size = UDim2.new(0, 160, 0, 0)
        list.Position = UDim2.new(1, -170, 0, 40)
        list.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        list.BorderSizePixel = 0
        list.Visible = false
        list.CanvasSize = UDim2.new(0,0,0,0)
        list.ScrollBarThickness = 4
        list.Parent = frame

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 2)
        listLayout.Parent = list

        local function updateSize()
            local count = math.min(#options, 7)
            list.Size = UDim2.new(0, 160, 0, count * 32 + 8)
            list.CanvasSize = UDim2.new(0,0,0, #options * 32 + 8)
        end

        for _, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 28)
            optBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.new(1,1,1)
            optBtn.TextScaled = true
            optBtn.Font = Enum.Font.Gotham
            optBtn.Parent = list

            local optCorner = Instance.new("UICorner")
            optCorner.CornerRadius = UDim.new(0, 5)
            optCorner.Parent = optBtn

            optBtn.MouseButton1Click:Connect(function()
                selected = opt
                btn.Text = opt
                list.Visible = false
                callback(opt)
            end)

            optBtn.MouseEnter:Connect(function()
                optBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            end)
            optBtn.MouseLeave:Connect(function()
                optBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end)
        end

        updateSize()

        btn.MouseButton1Click:Connect(function()
            list.Visible = not list.Visible
        end)

        return btn
    end

    -- Label
    function window:Label(text)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 26)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        lbl.TextScaled = true
        lbl.Font = Enum.Font.Gotham
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = contentFrame
        return lbl
    end

    -- Section
    function window:Section(title)
        local sec = Instance.new("Frame")
        sec.Size = UDim2.new(1, 0, 0, 32)
        sec.BackgroundTransparency = 1
        sec.Parent = contentFrame

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = title
        lbl.TextColor3 = Color3.fromRGB(140, 140, 255)
        lbl.TextScaled = true
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = sec

        return sec
    end

    table.insert(windows, window)
    return window
end

-- Global toggle key
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == toggleKey then
        for _, w in ipairs(windows) do
            w:Toggle()
        end
    end
end)

return Library
