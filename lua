-- Nexon UI Library V2
-- Modern, smooth UI with blue-mint-black theme
local Nexon = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Preset colors
local COLORS = {
    PRIMARY = Color3.fromRGB(0, 220, 255),    -- Mint blue
    SECONDARY = Color3.fromRGB(0, 255, 170),  -- Mint green
    BACKGROUND = Color3.fromRGB(25, 25, 30),  -- Dark background
    CONTAINER = Color3.fromRGB(30, 30, 40),   -- Slightly lighter
    ELEMENT = Color3.fromRGB(40, 45, 60),     -- Element background
    WHITE = Color3.fromRGB(255, 255, 255),
    LIGHT_TEXT = Color3.fromRGB(230, 230, 230),
    HIGHLIGHT = Color3.fromRGB(0, 240, 220)   -- Highlight color
}

-- Utility functions
local function createCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 5)
    corner.Parent = instance
    return corner
end

local function createShadow(instance)
    local shadow = Instance.new("ImageLabel")
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 2)
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.ZIndex = instance.ZIndex - 1
    shadow.Image = "rbxassetid://7912134082" -- Shadow asset
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.65
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(95, 95, 205, 205)
    shadow.SliceScale = 1
    shadow.Parent = instance
    return shadow
end

-- Main window creation function
function Nexon:CreateWindow(titleText)
    -- Screen GUI setup
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NexonUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to set core GUI settings
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Nexon Hub",
            Text = "โหลดสคริปต์สำเร็จ!",
            Icon = "rbxassetid://7733658504", -- Notification icon
            Duration = 3
        })
    end)
    
    -- Set parent based on environment
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = game:GetService("CoreGui")
    elseif gethui then
        screenGui.Parent = gethui()
    else
        screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Main frame
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 350, 0, 400)
    main.Position = UDim2.new(0.5, -175, 0.5, -200)
    main.BackgroundColor3 = COLORS.BACKGROUND
    main.BorderSizePixel = 0
    main.Parent = screenGui
    createCorner(main, 8)
    createShadow(main)

    -- Top bar with gradient
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = COLORS.PRIMARY
    topBar.BorderSizePixel = 0
    topBar.Parent = main
    createCorner(topBar, 8)

    -- Make bottom corners square
    local fix = Instance.new("Frame")
    fix.Size = UDim2.new(1, 0, 0.5, 0)
    fix.Position = UDim2.new(0, 0, 0.5, 0)
    fix.BackgroundColor3 = COLORS.PRIMARY
    fix.BorderSizePixel = 0
    fix.ZIndex = topBar.ZIndex
    fix.Parent = topBar

    -- Gradient on top bar
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.PRIMARY),
        ColorSequenceKeypoint.new(1, COLORS.SECONDARY)
    })
    gradient.Rotation = 45
    gradient.Parent = topBar

    -- Title with icon
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🌊 " .. (titleText or "Nexon Hub")
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(0, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    closeBtn.Text = "✕"
    closeBtn.TextSize = 18
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = topBar
    createCorner(closeBtn, 6)
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Content container
    local containerFrame = Instance.new("Frame")
    containerFrame.Name = "ContainerFrame"
    containerFrame.Size = UDim2.new(1, -20, 1, -50)
    containerFrame.Position = UDim2.new(0, 10, 0, 45)
    containerFrame.BackgroundColor3 = COLORS.CONTAINER
    containerFrame.BackgroundTransparency = 0.2
    containerFrame.BorderSizePixel = 0
    containerFrame.Parent = main
    createCorner(containerFrame, 8)

    local container = Instance.new("ScrollingFrame")
    container.Name = "Container"
    container.Size = UDim2.new(1, -10, 1, -10)
    container.Position = UDim2.new(0, 5, 0, 5)
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.ScrollBarThickness = 3
    container.ScrollBarImageColor3 = COLORS.PRIMARY
    container.BackgroundTransparency = 1
    container.Parent = containerFrame

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container

    -- Auto-size canvas
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    -- Dragging functionality
    local dragging = false
    local dragInput, dragStart, startPos

    local function updateDrag(input)
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            updateDrag(input)
        end
    end)

    -- Return the window object
    return setmetatable({
        Container = container,
        ScreenGui = screenGui,
        Main = main
    }, {
        __index = Nexon
    })
end

-- Button creation with hover effect
function Nexon:AddButton(name, callback)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 36)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = self.Container

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = COLORS.ELEMENT
    button.TextColor3 = COLORS.LIGHT_TEXT
    button.Text = name or "Button"
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.Parent = buttonFrame
    createCorner(button, 6)
    
    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Position = UDim2.new(0, 10, 0.5, -10)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://7733715400" -- Button icon
    icon.ImageColor3 = COLORS.PRIMARY
    icon.Parent = button
    
    -- Adjust text position
    button.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Hover and click effects
    local defaultColor = COLORS.ELEMENT
    local hoverColor = Color3.fromRGB(50, 55, 70)
    local clickColor = Color3.fromRGB(30, 35, 50)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = defaultColor}):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = clickColor}):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = hoverColor}):Play()
    end)

    button.MouseButton1Click:Connect(function()
        if callback then 
            local success, err = pcall(callback)
            if not success then
                warn("Nexon UI Button Error: " .. tostring(err))
            end
        end
    end)

    return button
end

-- Toggle with animation
function Nexon:AddToggle(name, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 36)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = self.Container

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, 0, 1, 0)
    toggle.BackgroundColor3 = COLORS.ELEMENT
    toggle.TextColor3 = COLORS.LIGHT_TEXT
    toggle.Text = name
    toggle.Font = Enum.Font.GothamSemibold
    toggle.TextSize = 14
    toggle.TextXAlignment = Enum.TextXAlignment.Left
    toggle.TextTruncate = Enum.TextTruncate.AtEnd
    toggle.Parent = toggleFrame
    createCorner(toggle, 6)
    
    -- Add padding to text
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = toggle
    
    -- Toggle indicator
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 40, 0, 20)
    indicator.Position = UDim2.new(1, -50, 0.5, -10)
    indicator.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    indicator.Parent = toggle
    createCorner(indicator, 10)
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = COLORS.WHITE
    knob.Parent = indicator
    createCorner(knob, 8)
    
    -- State management
    local state = default or false
    
    local function updateToggle()
        local pos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local color = state and COLORS.PRIMARY or Color3.fromRGB(60, 60, 70)
        
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = pos}):Play()
        TweenService:Create(indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = color}):Play()
        
        if callback then 
            local success, err = pcall(function() callback(state) end)
            if not success then
                warn("Nexon UI Toggle Error: " .. tostring(err))
            end
        end
    end
    
    -- Initialize toggle state
    if state then
        knob.Position = UDim2.new(1, -18, 0.5, -8)
        indicator.BackgroundColor3 = COLORS.PRIMARY
    end
    
    -- Hover effect
    toggle.MouseEnter:Connect(function()
        TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 55, 70)}):Play()
    end)
    
    toggle.MouseLeave:Connect(function()
        TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.ELEMENT}):Play()
    end)

    toggle.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
    end)

    return toggle
end

-- Label with optional styling
function Nexon:AddLabel(text)
    local labelFrame = Instance.new("Frame")
    labelFrame.Size = UDim2.new(1, 0, 0, 28)
    labelFrame.BackgroundTransparency = 1
    labelFrame.Parent = self.Container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = COLORS.HIGHLIGHT
    label.Text = text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.Parent = labelFrame
    
    -- Add text padding
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 5)
    padding.Parent = label
    
    -- Add subtle underline
    local underline = Instance.new("Frame")
    underline.Size = UDim2.new(1, 0, 0, 1)
    underline.Position = UDim2.new(0, 0, 1, -1)
    underline.BackgroundColor3 = COLORS.HIGHLIGHT
    underline.BackgroundTransparency = 0.7
    underline.Parent = label

    return label
end

-- Enhanced slider with smooth movement
function Nexon:AddSlider(name, min, max, default, callback)
    min = min or 0
    max = max or 100
    default = default or min
    
    -- Clamp default value
    default = math.clamp(default, min, max)
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundColor3 = COLORS.ELEMENT
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = self.Container

    local sliderBg = Instance.new("Frame")
    sliderBg.Name = "SliderBg"
    sliderBg.Size = UDim2.new(1, 0, 1, 0)
    sliderBg.BackgroundColor3 = COLORS.ELEMENT
    sliderBg.Parent = sliderFrame
    createCorner(sliderBg, 6)
    
    -- Title and value display
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -75, 0, 20)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name or "Slider"
    titleLabel.TextColor3 = COLORS.LIGHT_TEXT
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 14
    titleLabel.Parent = sliderBg

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -70, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = COLORS.PRIMARY
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.GothamSemibold
    valueLabel.TextSize = 14
    valueLabel.Parent = sliderBg
    
    -- Slider track
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, -20, 0, 6)
    track.Position = UDim2.new(0, 10, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    track.Parent = sliderBg
    createCorner(track, 3)
    
    -- Filled part of slider
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = COLORS.PRIMARY
    fill.Parent = track
    createCorner(fill, 3)
    
    -- Slider knob
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 0, 0.5, -8)
    knob.AnchorPoint = Vector2.new(0.5, 0)
    knob.BackgroundColor3 = COLORS.WHITE
    knob.Parent = track
    createCorner(knob, 8)
    createShadow(knob)
    
    -- Calculate slider value based on position
    local function calculateValue(posX)
        local trackWidth = track.AbsoluteSize.X
        local relativeX = math.clamp(posX - track.AbsolutePosition.X, 0, trackWidth)
        local percent = relativeX / trackWidth
        local value = min + (max - min) * percent
        return math.floor(value + 0.5) -- Round to nearest integer
    end
    
    -- Update slider visuals
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        local percent = (value - min) / (max - min)
        
        -- Update fill and knob position
        fill.Size = UDim2.new(percent, 0, 1, 0)
        knob.Position = UDim2.new(percent, 0, 0.5, -8)
        
        -- Update value label
        valueLabel.Text = tostring(value)
        
        -- Call callback
        if callback then
            local success, err = pcall(function() callback(value) end)
            if not success then
                warn("Nexon UI Slider Error: " .. tostring(err))
            end
        end
    end
    
    -- Initialize with default value
    updateSlider(default)
    
    -- Handle slider interaction
    local isDragging = false
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            updateSlider(calculateValue(input.Position.X))
        end
    end)
    
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(calculateValue(input.Position.X))
        end
    end)

    return sliderFrame
end

-- Add dropdown selection
function Nexon:AddDropdown(name, options, default, callback)
    options = options or {}
    default = default or options[1]
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 36)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.Parent = self.Container
    
    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(1, 0, 1, 0)
    dropdown.BackgroundColor3 = COLORS.ELEMENT
    dropdown.TextColor3 = COLORS.LIGHT_TEXT
    dropdown.Text = name .. ": " .. (default or "Select...")
    dropdown.Font = Enum.Font.GothamSemibold
    dropdown.TextSize = 14
    dropdown.TextXAlignment = Enum.TextXAlignment.Left
    dropdown.Parent = dropdownFrame
    createCorner(dropdown, 6)
    
    -- Add padding to text
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = dropdown
    
    -- Dropdown arrow
    local arrow = Instance.new("ImageLabel")
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Position = UDim2.new(1, -25, 0.5, -10)
    arrow.BackgroundTransparency = 1
    arrow.Image = "rbxassetid://7734053682" -- Dropdown arrow
    arrow.ImageColor3 = COLORS.PRIMARY
    arrow.Parent = dropdown
    
    -- Dropdown menu
    local optionContainer = Instance.new("Frame")
    optionContainer.Name = "OptionContainer"
    optionContainer.Size = UDim2.new(1, 0, 0, #options * 30)
    optionContainer.Position = UDim2.new(0, 0, 1, 5)
    optionContainer.BackgroundColor3 = COLORS.CONTAINER
    optionContainer.Visible = false
    optionContainer.ZIndex = 5
    optionContainer.Parent = dropdownFrame
    createCorner(optionContainer, 6)
    createShadow(optionContainer)
    
    local optionList = Instance.new("ScrollingFrame")
    optionList.Size = UDim2.new(1, -10, 1, -10)
    optionList.Position = UDim2.new(0, 5, 0, 5)
    optionList.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
    optionList.ScrollBarThickness = 3
    optionList.ScrollBarImageColor3 = COLORS.PRIMARY
    optionList.BackgroundTransparency = 1
    optionList.ZIndex = 5
    optionList.Parent = optionContainer
    
    local optionLayout = Instance.new("UIListLayout")
    optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionLayout.Padding = UDim.new(0, 2)
    optionLayout.Parent = optionList
    
    local selectedOption = default
    
    -- Create dropdown options
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, -5, 0, 28)
        optionButton.BackgroundColor3 = COLORS.ELEMENT
        optionButton.TextColor3 = COLORS.LIGHT_TEXT
        optionButton.Text = tostring(option)
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextSize = 14
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.ZIndex = 6
        optionButton.Parent = optionList
        createCorner(optionButton, 4)
        
        -- Add padding to text
        local optionPadding = Instance.new("UIPadding")
        optionPadding.PaddingLeft = UDim.new(0, 8)
        optionPadding.Parent = optionButton
        
        -- Hover effect
        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 55, 70)}):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.ELEMENT}):Play()
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            dropdown.Text = name .. ": " .. tostring(option)
            optionContainer.Visible = false
            
            if callback then 
                local success, err = pcall(function() callback(option) end)
                if not success then
                    warn("Nexon UI Dropdown Error: " .. tostring(err))
                end
            end
        end)
    end
    
    -- Toggle dropdown visibility
    dropdown.MouseButton1Click:Connect(function()
        optionContainer.Visible = not optionContainer.Visible
        
        -- Rotate arrow based on state
        local rotation = optionContainer.Visible and 180 or 0
        TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = rotation}):Play()
    end)
    
    -- Close dropdown when clicking elsewhere
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local position = input.Position
            local inset = game:GetService("GuiService"):GetGuiInset()
            position = position - inset
            
            if optionContainer.Visible then
                local frame = optionContainer.AbsolutePosition
                local size = optionContainer.AbsoluteSize
                
                if position.X < frame.X or position.X > frame.X + size.X or
                   position.Y < frame.Y or position.Y > frame.Y + size.Y then
                    if position.Y < dropdown.AbsolutePosition.Y or 
                       position.Y > dropdown.AbsolutePosition.Y + dropdown.AbsoluteSize.Y then
                        optionContainer.Visible = false
                        TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    end
                end
            end
        end
    end)
    
    return dropdown
end

-- Add separator line
function Nexon:AddSeparator()
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.BackgroundColor3 = COLORS.PRIMARY
    separator.BackgroundTransparency = 0.7
    separator.Parent = self.Container
    
    -- Add padding
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.Parent = separator
    
    return separator
end

-- Add text input
function Nexon:AddTextbox(name, default, placeholder, callback)
    local textboxFrame = Instance.new("Frame")
    textboxFrame.Size = UDim2.new(1, 0, 0, 60)
    textboxFrame.BackgroundColor3 = COLORS.ELEMENT
    textboxFrame.BackgroundTransparency = 1
    textboxFrame.Parent = self.Container
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = COLORS.ELEMENT
    bg.Parent = textboxFrame
    createCorner(bg, 6)
    
    -- Title label
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 0, 20)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = name or "Input"
    title.TextColor3 = COLORS.LIGHT_TEXT
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 14
    title.Parent = bg
    
    -- Textbox container
    local inputContainer = Instance.new("Frame")
    inputContainer.Size = UDim2.new(1, -20, 0, 30)
    inputContainer.Position = UDim2.new(0, 10, 0, 25)
    inputContainer.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
    inputContainer.Parent = bg
    createCorner(inputContainer, 4)
    
    -- Actual textbox
    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(1, -10, 1, -2)
    textbox.Position = UDim2.new(0, 5, 0, 1)
    textbox.BackgroundTransparency = 1
    textbox.Text = default or ""
    textbox.PlaceholderText = placeholder or "Type here..."
    textbox.TextColor3 = COLORS.WHITE
    textbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
    textbox.Font = Enum.Font.Gotham
    textbox.TextSize = 14
    textbox.TextXAlignment = Enum.TextXAlignment.Left
    textbox.ClearTextOnFocus = false
    textbox.Parent = inputContainer
    
    -- Border highlight effect
    local highlight = Instance.new("UIStroke")
    highlight.Thickness = 1
    highlight.Color = COLORS.PRIMARY
    highlight.Transparency = 1
    highlight.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    highlight.Parent = inputContainer
    
    -- Focus and unfocus effects
    textbox.Focused:Connect(function()
        TweenService:Create(highlight, TweenInfo.new(0.2), {Transparency = 0}):Play()
    end)
    
    textbox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(highlight, TweenInfo.new(0.2), {Transparency = 1}):Play()
        
        if callback then
            local success, err = pcall(function() callback(textbox.Text, enterPressed) end)
            if not success then
                warn("Nexon UI Textbox Error: " .. tostring(err))
            end
        end
    end)
    
    return textbox
end
