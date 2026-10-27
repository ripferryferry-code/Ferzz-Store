--[[
    JOSTAR STORE | AUTO F
    BLACK & WHITE EDITION
    Mobile / Mouse OTG
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local enabled = false
local holding = false

local gui = Instance.new("ScreenGui")
gui.Name = "JOSTAR_STORE_AUTO_F"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 175, 0, 90)
frame.Position = UDim2.new(0.5, -87, 0.5, -45)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderColor3 = Color3.fromRGB(230, 230, 230)
frame.BorderSizePixel = 1
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "JOSTAR STORE"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 35)
button.Position = UDim2.new(0, 10, 0, 42)
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "AUTO F : OFF"
button.TextSize = 13
button.Font = Enum.Font.GothamBold
button.Parent = frame

button.MouseButton1Click:Connect(function()
    enabled = not enabled
    button.Text = enabled and "AUTO F : ON" or "AUTO F : OFF"
end)

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        holding = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        holding = false
    end
end)

task.spawn(function()
    while gui.Parent do
        if enabled and holding then
            pcall(function()
                VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                task.wait(0.05)
                VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            end)
            task.wait(0.1)
        else
            task.wait(0.05)
        end
    end
end)
