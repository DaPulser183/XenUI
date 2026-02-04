-- Source.lua - XenUI Library (Updated with Toggle & Slider)
local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local windows = {}
local toggleKey = Enum.KeyCode.RightShift  -- Change to your preferred key

-- Create main ScreenGui (shared for all windows)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XenUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

function Library:CreateWindow(options)
    options = options or {}
    local title = options.Title or "XenUI"
    local size = options.Size or UDim2.new(0, 450, 0, 350)
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainWindow"
    mainFrame.Size = size
    mainFrame.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Add corner and stroke for modern look
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
    
    -- Content frame with padding
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -55)
    contentFrame.Position = UDim2.new(0, 10, 0, 45)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    local contentList = Instance.new("UIListLayout")
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Padding = UDim.new(0, 5)
    contentList.Parent = contentFrame
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.Parent = contentFrame
    
    local window = {}
    
    -- Toggle visibility
    function window:Toggle()
        mainFrame.Visible = not mainFrame.Visible
    end
    
    -- Button
    function window:Button(text, callback)
        local button = Instance.new("TextButton")
        button.Name = text
        button.Size = UDim2.new(1, 0, 0, 35)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.Text = text
        button.TextColor3 = Color3.new(1,1,1)
        button.TextScaled = true
        button.Font = Enum.Font.Gotham
        button.Parent = contentFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = button
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(65, 65, 65)
        btnStroke.Thickness = 1
        btnStroke.Parent = button
        
        -- Hover/tween effects
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
            TweenService:Create(btnStroke, tweenInfo, {Color = Color3.fromRGB(75, 75, 75)}):Play()
        end)
        button.MouseLeave:Connect(function()
            TweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            TweenService:Create(btnStroke, tweenInfo, {Color = Color3.fromRGB(65, 65, 65)}):Play()
        end)
        button.MouseButton1Click:Connect(callback)
        
        return button
    end
    
    -- New: Toggle
    function window:Toggle(text, callback, default)
        local toggleValue = default or false
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = text
        toggleFrame.Size = UDim2.new(1, 0, 0, 35)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = contentFrame
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(1, -60, 1, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = text
        toggleLabel.TextColor3 = Color3.new(1,1,1)
        toggleLabel.TextScaled = true
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 50, 0, 25)
        toggleButton.Position = UDim2.new(1, -50, 0.5, -12.5)
        toggleButton.BackgroundColor3 = toggleValue and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        toggleButton.Text = toggleValue and "On" or "Off"
        toggleButton.TextColor3 = Color3.new(1,1,1)
        toggleButton.Font = Enum.Font.Gotham
        toggleButton.Parent = toggleFrame
        
        local togCorner = Instance.new("UICorner")
        togCorner.CornerRadius = UDim.new(0, 6)
        togCorner.Parent = toggleButton
        
        local togStroke = Instance.new("UIStroke")
        togStroke.Color = Color3.fromRGB(65, 65, 65)
        togStroke.Thickness = 1
        togStroke.Parent = toggleButton
        
        toggleButton.MouseButton1Click:Connect(function()
            toggleValue = not toggleValue
            toggleButton.Text = toggleValue and "On" or "Off"
            toggleButton.BackgroundColor3 = toggleValue and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
            callback(toggleValue)
        end)
        
        return toggleButton
    end
    
    -- New: Slider
    function window:Slider(text, min, max, default, callback)
        local sliderValue = default or min
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = text
        sliderFrame.Size = UDim2.new(1, 0, 0, 50)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = contentFrame
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Size = UDim2.new(1, 0, 0, 20)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = text .. ": " .. sliderValue
        sliderLabel.TextColor3 = Color3.new(1,1,1)
        sliderLabel.TextScaled = true
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame
        
        local sliderBar = Instance.new("Frame")
        sliderBar.Size = UDim2.new(1, 0, 0, 10)
        sliderBar.Position = UDim2.new(0, 0, 0, 25)
        sliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        sliderBar.Parent = sliderFrame
        
        local barCorner = Instance.new("UICorner")
        barCorner.CornerRadius = UDim.new(0, 5)
        barCorner.Parent = sliderBar
        
        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Size = UDim2.new((sliderValue - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        fill.Parent = sliderBar
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 5)
        fillCorner.Parent = fill
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(1, 0, 1, 0)
        sliderButton.BackgroundTransparency = 1
        sliderButton.Text = ""
        sliderButton.Parent = sliderBar
        
        local dragging = false
        sliderButton.MouseButton1Down:Connect(function()
            dragging = true
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        sliderButton.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativeX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                sliderValue = math.floor(min + relativeX * (max - min))
                fill.Size = UDim2.new(relativeX, 0, 1, 0)
                sliderLabel.Text = text .. ": " .. sliderValue
                callback(sliderValue)
            end
        end)
        
        return sliderFrame
    end
    
    table.insert(windows, window)
    return window
end

-- Global toggle (Right Shift)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == toggleKey then
        for _, win in windows do
            win:Toggle()
        end
    end
end)

return Library
