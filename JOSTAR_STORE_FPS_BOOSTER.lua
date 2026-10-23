-- JOSTAR STORE | FPS BOOSTER (local visual settings only)
-- Does not guarantee FPS gains. ON simplifies selected local effects; OFF restores saved values.

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
if not player then warn("Run this on the client.") return end

local enabled, saved = false, {}
local function setSaved(obj, prop, value)
    if not obj then return end
    saved[obj] = saved[obj] or {}
    if saved[obj][prop] == nil then
        local ok, old = pcall(function() return obj[prop] end)
        if ok then saved[obj][prop] = old end
    end
    pcall(function() obj[prop] = value end)
end

local function simplify(obj)
    if obj:IsA("BasePart") then
        setSaved(obj, "CastShadow", false)
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        setSaved(obj, "Transparency", 1)
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
        or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles")
        or obj:IsA("PostEffect") then
        setSaved(obj, "Enabled", false)
    end
end

local function restore()
    for obj, props in pairs(saved) do
        if obj and obj.Parent then
            for prop, old in pairs(props) do
                pcall(function() obj[prop] = old end)
            end
        end
    end
    saved = {}
end

local gui = Instance.new("ScreenGui")
gui.Name = "JOSTAR_FPS_BOOSTER"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(190, 112)
frame.Position = UDim2.new(0.5, -95, 0.22, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
local outline = Instance.new("UIStroke", frame)
outline.Color = Color3.fromRGB(235, 235, 235)
outline.Thickness = 1

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -12, 0, 25)
title.Position = UDim2.fromOffset(8, 3)
title.BackgroundTransparency = 1
title.Text = "JOSTAR STORE | FPS"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -16, 0, 18)
status.Position = UDim2.fromOffset(8, 28)
status.BackgroundTransparency = 1
status.Text = "STATUS: OFF"
status.TextColor3 = Color3.fromRGB(190, 190, 190)
status.Font = Enum.Font.Gotham
status.TextSize = 10
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = frame

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -16, 0, 30)
toggle.Position = UDim2.fromOffset(8, 49)
toggle.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
toggle.BorderSizePixel = 0
toggle.Text = "FPS BOOST: OFF"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 11
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 5)

local note = Instance.new("TextLabel")
note.Size = UDim2.new(1, -16, 0, 17)
note.Position = UDim2.fromOffset(8, 85)
note.BackgroundTransparency = 1
note.Text = "Local graphics only • no FPS guarantee"
note.TextColor3 = Color3.fromRGB(150, 150, 150)
note.Font = Enum.Font.Gotham
note.TextSize = 8
note.TextXAlignment = Enum.TextXAlignment.Left
note.Parent = frame

local function apply(value)
    enabled = value
    if enabled then
        setSaved(Lighting, "GlobalShadows", false)
        for _, obj in ipairs(Lighting:GetDescendants()) do
            if obj:IsA("PostEffect") then simplify(obj) end
        end
        for _, obj in ipairs(Workspace:GetDescendants()) do simplify(obj) end
        pcall(function() setSaved(Workspace.Terrain, "Decoration", false) end)
        status.Text = "STATUS: ON"
        toggle.Text = "FPS BOOST: ON"
        toggle.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
        toggle.TextColor3 = Color3.fromRGB(15, 15, 15)
    else
        restore()
        status.Text = "STATUS: OFF"
        toggle.Text = "FPS BOOST: OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        toggle.TextColor3 = Color3.new(1, 1, 1)
    end
end
toggle.Activated:Connect(function() apply(not enabled) end)

-- Drag by touching/clicking the title area.
local dragging, dragStart, startPos = false, nil, nil
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging, dragStart, startPos = true, input.Position, frame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

local function onAdded(obj)
    if enabled then task.defer(function() if enabled and obj.Parent then simplify(obj) end end) end
end
Workspace.DescendantAdded:Connect(onAdded)
Lighting.DescendantAdded:Connect(onAdded)
gui.Destroying:Connect(function() if enabled then restore() end end)
print("[JOSTAR FPS] Loaded")
