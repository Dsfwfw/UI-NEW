-- Nexon UI Library (Stylized)
local Nexon = {}
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local function applyStyle(ui)
	local corner = Instance.new("UICorner", ui)
	corner.CornerRadius = UDim.new(0, 6)

	local stroke = Instance.new("UIStroke", ui)
	stroke.Color = Color3.fromRGB(0, 255, 200)
	stroke.Thickness = 1
	stroke.Transparency = 0.8
end

function Nexon:CreateWindow(titleText)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "NexonUI"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = UDim2.new(0, 420, 0, 480)
	main.Position = UDim2.new(0.5, -210, 0.5, -240)
	main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	main.BorderSizePixel = 0
	main.Active = true
	main.Draggable = true
	main.Parent = screenGui
	applyStyle(main)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 45)
	title.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
	title.Text = "🌿 Nexon | " .. (titleText or "Window")
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 20
	title.TextColor3 = Color3.fromRGB(10, 10, 10)
	title.Parent = main
	applyStyle(title)

	local container = Instance.new("ScrollingFrame")
	container.Name = "Container"
	container.Size = UDim2.new(1, -20, 1, -60)
	container.Position = UDim2.new(0, 10, 0, 50)
	container.CanvasSize = UDim2.new(0, 0, 0, 0)
	container.ScrollBarThickness = 4
	container.BackgroundTransparency = 1
	container.Parent = main

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)
	layout.Parent = container

	return setmetatable({
		Container = container,
		ScreenGui = screenGui,
		Main = main
	}, {
		__index = Nexon
	})
end

function Nexon:AddButton(name, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 36)
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Text = name or "Button"
	button.Font = Enum.Font.GothamSemibold
	button.TextSize = 14
	button.AutoButtonColor = false
	button.Parent = self.Container
	applyStyle(button)

	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 200)}):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
	end)

	button.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)

	return button
end

function Nexon:AddToggle(name, default, callback)
	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(1, 0, 0, 36)
	toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggle.Text = "[ OFF ] " .. name
	toggle.Font = Enum.Font.Gotham
	toggle.TextSize = 14
	toggle.AutoButtonColor = false
	toggle.Parent = self.Container
	applyStyle(toggle)

	local state = default or false
	toggle.MouseButton1Click:Connect(function()
		state = not state
		toggle.Text = (state and "[ ON ] " or "[ OFF ] ") .. name
		TweenService:Create(toggle, TweenInfo.new(0.15), {
			BackgroundColor3 = state and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(30, 30, 30)
		}):Play()
		if callback then callback(state) end
	end)

	return toggle
end

function Nexon:AddLabel(text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 28)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(0, 255, 200)
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.Parent = self.Container
	return label
end

function Nexon:AddSlider(name, min, max, default, callback)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Size = UDim2.new(1, 0, 0, 42)
	sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	sliderFrame.Parent = self.Container
	applyStyle(sliderFrame)

	local title = Instance.new("TextLabel", sliderFrame)
	title.Size = UDim2.new(1, 0, 0.5, 0)
	title.Text = name .. ": " .. tostring(default)
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.Gotham
	title.TextSize = 13

	local slider = Instance.new("TextButton", sliderFrame)
	slider.Position = UDim2.new(0, 0, 0.5, 0)
	slider.Size = UDim2.new(1, 0, 0.5, 0)
	slider.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
	slider.Text = ""
	applyStyle(slider)

	slider.MouseButton1Down:Connect(function()
		local conn
		conn = UserInputService.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				local x = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
				local value = math.floor(min + (max - min) * x)
				title.Text = name .. ": " .. tostring(value)
				if callback then callback(value) end
			end
		end)
		UserInputService.InputEnded:Wait()
		if conn then conn:Disconnect() end
	end)

	return slider
end

return Nexon
