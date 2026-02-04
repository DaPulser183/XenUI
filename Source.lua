-- Source (ModuleScript) - Your UI Library
local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local windows = {}
local toggleKey = Enum.KeyCode.RightShift  -- Change to your preferred key

-- Create main ScreenGui
local function createGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MyUILib"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    return screenGui
end

function Library:CreateWindow(options)
    options = options or {}
    local title = options.Title or "My UI Library"
    local size = options.Size or UDim2.new(0, 450, 0, 350)
    
    local screenGui = createGui()
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
    titleLabel.Size = UDim2.new(1, -10, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1,1,1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar
    
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
    
    -- Add more: Toggle, Slider, etc. (ask me for code!)
    
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
