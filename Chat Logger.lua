--// Simple Transparent Chat Logger with Context Menu //-- 

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChatLogger"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (transparent style)
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.3 -- semi-transparent like old version
Frame.BorderSizePixel = 0

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 0.5
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.Text = "Chat Logger"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- ScrollingFrame
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = Frame
ScrollingFrame.Size = UDim2.new(1, -10, 1, -40)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 35)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 6

-- UIListLayout
local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScrollingFrame
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 2)

-- Context Menu
local ContextMenu = Instance.new("Frame")
ContextMenu.Size = UDim2.new(0, 120, 0, 60)
ContextMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContextMenu.BackgroundTransparency = 0.2
ContextMenu.Visible = false
ContextMenu.ZIndex = 10
ContextMenu.Parent = ScreenGui

local CopyButton = Instance.new("TextButton")
CopyButton.Parent = ContextMenu
CopyButton.Size = UDim2.new(1, 0, 0.5, 0)
CopyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Font = Enum.Font.SourceSans
CopyButton.TextSize = 16
CopyButton.Text = "Copy User"

local ReportButton = Instance.new("TextButton")
ReportButton.Parent = ContextMenu
ReportButton.Position = UDim2.new(0, 0, 0.5, 0)
ReportButton.Size = UDim2.new(1, 0, 0.5, 0)
ReportButton.BackgroundColor3 = Color3.fromRGB(70, 30, 30)
ReportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ReportButton.Font = Enum.Font.SourceSans
ReportButton.TextSize = 16
ReportButton.Text = "Report"

-- Hide context menu when clicking elsewhere
ScreenGui.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		ContextMenu.Visible = false
	end
end)

-- Function to log chat messages
local function LogMessage(playerName, message)
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Parent = ScrollingFrame
	TextLabel.Size = UDim2.new(1, -10, 0, 20)
	TextLabel.BackgroundTransparency = 1
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.Font = Enum.Font.SourceSans
	TextLabel.TextSize = 16
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Text = "[" .. os.date("%H:%M") .. "] " .. playerName .. ": " .. message

	-- Right-click context menu
	TextLabel.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			ContextMenu.Position = UDim2.fromOffset(input.Position.X, input.Position.Y)
			ContextMenu.Visible = true

			-- Copy user
			CopyButton.MouseButton1Click:Connect(function()
				setclipboard(playerName)
				ContextMenu.Visible = false
			end)

			-- Report user
			ReportButton.MouseButton1Click:Connect(function()
				print("Reported " .. playerName .. ": " .. message) -- hook webhook here
				ContextMenu.Visible = false
			end)
		end
	end)

	-- Adjust canvas size
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end

-- Keep scroll updated
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end)

-- Listen to chat
Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg)
		LogMessage(player.Name, msg)
	end)
end)

for _, player in ipairs(Players:GetPlayers()) do
	player.Chatted:Connect(function(msg)
		LogMessage(player.Name, msg)
	end)
end
