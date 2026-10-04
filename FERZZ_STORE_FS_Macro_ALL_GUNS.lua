-- =====================================================
-- FERZZ STORE [ FS ] UI - Macro ALL GUNS + No Recoil + No Spread
-- =====================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.FERZZ = {
    ForceAuto = false,
    NoRecoil = false,
    NoSpread = false,
    Speed = 0.05,
}

if CoreGui:FindFirstChild("FERZZStoreUI") then
    CoreGui.FERZZStoreUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FERZZStoreUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 99999
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
MainFrame.Size = UDim2.new(0, 300, 0, 210)
MainFrame.Active = true

local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(43, 125, 233)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.2

local Corner = Instance.new("UICorner")
Corner.Parent = MainFrame
Corner.CornerRadius = UDim.new(0, 4)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 14, 0, 12)
Title.Size = UDim2.new(0, 200, 0, 24)
Title.Font = Enum.Font.GothamBold
Title.Text = "FERZZ STORE [ FS ]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = MainFrame
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 14, 0, 34)
Subtitle.Size = UDim2.new(0, 200, 0, 14)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Macro"
Subtitle.TextColor3 = Color3.fromRGB(140, 140, 150)
Subtitle.TextSize = 12
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

local Divider = Instance.new("Frame")
Divider.Parent = MainFrame
Divider.BackgroundColor3 = Color3.fromRGB(43, 125, 233)
Divider.BackgroundTransparency = 0.5
Divider.BorderSizePixel = 0
Divider.Position = UDim2.new(0, 14, 0, 58)
Divider.Size = UDim2.new(0, 272, 0, 1)

local function CreateMenuItem(parent, yOffset, labelText, callback)
    local Row = Instance.new("Frame")
    Row.Parent = parent
    Row.BackgroundTransparency = 1
    Row.Position = UDim2.new(0, 14, 0, yOffset)
    Row.Size = UDim2.new(0, 272, 0, 34)

    local Label = Instance.new("TextLabel")
    Label.Parent = Row
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0, 180, 0, 34)
    Label.Font = Enum.Font.Gotham
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(230, 230, 235)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Button = Instance.new("TextButton")
    Button.Parent = Row
    Button.BackgroundColor3 = Color3.fromRGB(45, 48, 55)
    Button.BorderSizePixel = 0
    Button.Position = UDim2.new(1, -70, 0, 4)
    Button.Size = UDim2.new(0, 70, 0, 26)
    Button.Font = Enum.Font.GothamSemibold
    Button.Text = "OFF"
    Button.TextColor3 = Color3.fromRGB(180, 180, 190)
    Button.TextSize = 13
    Button.AutoButtonColor = false

    local BC = Instance.new("UICorner")
    BC.Parent = Button
    BC.CornerRadius = UDim.new(0, 4)

    local BStroke = Instance.new("UIStroke")
    BStroke.Parent = Button
    BStroke.Color = Color3.fromRGB(65, 68, 78)
    BStroke.Thickness = 1

    local isOn = false
    Button.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            Button.Text = "ON"
            Button.BackgroundColor3 = Color3.fromRGB(43, 125, 233)
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            BStroke.Color = Color3.fromRGB(43, 125, 233)
            pcall(callback, true)
        else
            Button.Text = "OFF"
            Button.BackgroundColor3 = Color3.fromRGB(45, 48, 55)
            Button.TextColor3 = Color3.fromRGB(180, 180, 190)
            BStroke.Color = Color3.fromRGB(65, 68, 78)
            pcall(callback, false)
        end
    end)
end

local function applyMacro(tool)
    if not tool or not tool:IsA("Tool") then return end
    local s = tool:FindFirstChild("Setting")
    if not s or not s:IsA("ModuleScript") then return end
    pcall(function()
        local m = require(s)
        if type(m) ~= "table" then return end
        if m.FireRate ~= nil then m.FireRate = 0.03 end
        if m.FireRateValue ~= nil then m.FireRateValue = 0.03 end
        if m.RateOfFire ~= nil then m.RateOfFire = 0.03 end
        if m.FireDelay ~= nil then m.FireDelay = 0.03 end
        if m.Cooldown ~= nil then m.Cooldown = 0.03 end
        if m.ShootDelay ~= nil then m.ShootDelay = 0.03 end
        if m.Auto ~= nil then m.Auto = true end
        if m.AutoFire ~= nil then m.AutoFire = true end
        if m.Automatic ~= nil then m.Automatic = true end
        if m.FullAuto ~= nil then m.FullAuto = true end
        if m.IsAuto ~= nil then m.IsAuto = true end
        if m.AutoShoot ~= nil then m.AutoShoot = true end
    end)
end

local function applyNoRecoil(tool)
    if not tool or not tool:IsA("Tool") then return end
    local s = tool:FindFirstChild("Setting")
    if not s or not s:IsA("ModuleScript") then return end
    pcall(function()
        local m = require(s)
        if type(m) ~= "table" then return end
        if m.Recoil ~= nil then m.Recoil = 0 end
        if m.RecoilAmount ~= nil then m.RecoilAmount = 0 end
        if m.CameraRecoil ~= nil then m.CameraRecoil = 0 end
        if m.CameraShake ~= nil then m.CameraShake = 0 end
        if m.Kick ~= nil then m.Kick = 0 end
        if m.Kickback ~= nil then m.Kickback = 0 end
        if m.VerticalRecoil ~= nil then m.VerticalRecoil = 0 end
        if m.HorizontalRecoil ~= nil then m.HorizontalRecoil = 0 end
        if m.RecoilX ~= nil then m.RecoilX = 0 end
        if m.RecoilY ~= nil then m.RecoilY = 0 end
        if m.GunRecoil ~= nil then m.GunRecoil = 0 end
        if m.WeaponRecoil ~= nil then m.WeaponRecoil = 0 end
        if m.AimRecoil ~= nil then m.AimRecoil = 0 end
        if m.ShakeAmount ~= nil then m.ShakeAmount = 0 end
        if m.ShakeIntensity ~= nil then m.ShakeIntensity = 0 end
    end)
end

local function applyNoSpread(tool)
    if not tool or not tool:IsA("Tool") then return end
    local s = tool:FindFirstChild("Setting")
    if not s or not s:IsA("ModuleScript") then return end
    pcall(function()
        local m = require(s)
        if type(m) ~= "table" then return end
        if m.Spread ~= nil then m.Spread = 0 end
        if m.SpreadX ~= nil then m.SpreadX = 0 end
        if m.SpreadY ~= nil then m.SpreadY = 0 end
        if m.MinSpread ~= nil then m.MinSpread = 0 end
        if m.MaxSpread ~= nil then m.MaxSpread = 0 end
        if m.HipSpread ~= nil then m.HipSpread = 0 end
        if m.AimSpread ~= nil then m.AimSpread = 0 end
        if m.SpreadAmount ~= nil then m.SpreadAmount = 0 end
        if m.Bloom ~= nil then m.Bloom = 0 end
        if m.Accuracy ~= nil then m.Accuracy = 1 end
    end)
end

local function applyToAll()
    local char = LocalPlayer.Character
    if char then
        for _, c in ipairs(char:GetChildren()) do
            if c:IsA("Tool") then
                if _G.FERZZ.NoRecoil then applyNoRecoil(c) end
                if _G.FERZZ.NoSpread then applyNoSpread(c) end
                if _G.FERZZ.ForceAuto then applyMacro(c) end
            end
        end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, c in ipairs(bp:GetChildren()) do
            if c:IsA("Tool") then
                if _G.FERZZ.NoRecoil then applyNoRecoil(c) end
                if _G.FERZZ.NoSpread then applyNoSpread(c) end
                if _G.FERZZ.ForceAuto then applyMacro(c) end
            end
        end
    end
end

CreateMenuItem(MainFrame, 68, "Force Auto", function(s)
    _G.FERZZ.ForceAuto = s
    applyToAll()
    print("[FERZZ STORE] Force Auto:", s and "ON" or "OFF")
end)

CreateMenuItem(MainFrame, 106, "No Recoil", function(s)
    _G.FERZZ.NoRecoil = s
    applyToAll()
    print("[FERZZ STORE] No Recoil:", s and "ON" or "OFF")
end)

CreateMenuItem(MainFrame, 144, "No Spread", function(s)
    _G.FERZZ.NoSpread = s
    applyToAll()
    print("[FERZZ STORE] No Spread:", s and "ON" or "OFF")
end)

task.spawn(function()
    while ScreenGui.Parent do
        if _G.FERZZ.ForceAuto then
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Setting") then
                    applyMacro(tool)
                    pcall(function() tool:Activate() end)
                end
            end
        end
        task.wait(_G.FERZZ.Speed)
    end
end)

task.spawn(function()
    while ScreenGui.Parent do
        if _G.FERZZ.NoRecoil or _G.FERZZ.NoSpread then
            applyToAll()
        end
        task.wait(0.5)
    end
end)

local function watchChar(char)
    if not char then return end
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.1)
            if _G.FERZZ.NoRecoil then applyNoRecoil(child) end
            if _G.FERZZ.NoSpread then applyNoSpread(child) end
            if _G.FERZZ.ForceAuto then applyMacro(child) end
        end
    end)
end

if LocalPlayer.Character then watchChar(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    watchChar(char)
    if _G.FERZZ.NoRecoil or _G.FERZZ.NoSpread or _G.FERZZ.ForceAuto then
        task.wait(0.5)
        applyToAll()
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        _G.FERZZ.ForceAuto = not _G.FERZZ.ForceAuto
        applyToAll()
        print("[FERZZ STORE] Macro:", _G.FERZZ.ForceAuto and "ON" or "OFF")
    end
end)

local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("===========================================")
print("  FERZZ STORE [ FS ] UI - LOADED")
print("===========================================")
print("● Force Auto = support SEMUA gun")
print("● No Recoil = recoil 0")
print("● No Spread = spread 0")
print("● Hotkey F = toggle macro")
print("===========================================")
