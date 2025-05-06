-- Nexon UI Library
local Nexon = {}
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

-- ✅ สร้างหน้าต่างหลัก
function Nexon:CreateWindow(titleText)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "NexonUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = UDim2.new(0, 350, 0, 400)
	main.Position = UDim2.new(0.5, -175, 0.5, -200)
	main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	main.BorderSizePixel = 0
	main.Parent = screenGui
	main.Active = true
	main.Draggable = true

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
	title.Text = "🌿 Nexon UI | " .. (titleText or "Window")
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.TextColor3 = Color3.fromRGB(0, 0, 0)
	title.Parent = main

	local container = Instance.new("ScrollingFrame")
	container.Name = "Container"
	container.Size = UDim2.new(1, 0, 1, -40)
	container.Position = UDim2.new(0, 0, 0, 40)
	container.CanvasSize = UDim2.new(0, 0, 0, 0)
	container.ScrollBarThickness = 4
	container.BackgroundTransparency = 1
	container.Parent = main

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 6)
	layout.Parent = container

	return setmetatable({
		Container = container,
		ScreenGui = screenGui,
		Main = main
	}, {
		__index = Nexon
	})
end

-- ✅ ปุ่ม
function Nexon:AddButton(name, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 30)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Text = name or "Button"
	button.Font = Enum.Font.Gotham
	button.TextSize = 14
	button.Parent = self.Container

	button.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)

	return button
end

-- ✅ Toggle
function Nexon:AddToggle(name, default, callback)
	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(1, -10, 0, 30)
	toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggle.Text = "[ OFF ] " .. name
	toggle.Font = Enum.Font.Gotham
	toggle.TextSize = 14
	toggle.Parent = self.Container

	local state = default or false
	toggle.MouseButton1Click:Connect(function()
		state = not state
		toggle.Text = (state and "[ ON ] " or "[ OFF ] ") .. name
		if callback then callback(state) end
	end)

	return toggle
end

-- ✅ Label
function Nexon:AddLabel(text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 25)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(200, 255, 200)
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.Parent = self.Container
	return label
end

-- ✅ Slider
function Nexon:AddSlider(name, min, max, default, callback)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Size = UDim2.new(1, -10, 0, 35)
	sliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	sliderFrame.Parent = self.Container

	local title = Instance.new("TextLabel", sliderFrame)
	title.Size = UDim2.new(1, 0, 0.5, 0)
	title.Text = name .. ": " .. tostring(default)
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.Gotham
	title.TextSize = 14

	local slider = Instance.new("TextButton", sliderFrame)
	slider.Position = UDim2.new(0, 0, 0.5, 0)
	slider.Size = UDim2.new(1, 0, 0.5, 0)
	slider.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
	slider.Text = ""

	slider.MouseButton1Down:Connect(function()
		local conn
		conn = game:GetService("UserInputService").InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				local x = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
				local value = math.floor(min + (max - min) * x)
				title.Text = name .. ": " .. tostring(value)
				if callback then callback(value) end
			end
		end)
		game:GetService("UserInputService").InputEnded:Wait()
		if conn then conn:Disconnect() end
	end)

	return slider
end

return Nexon
