-- FERZZ STORE [ FS ] - Macro SUPER Universal (SAFE MODE)

if _G.FERZZ_LOADED then
    pcall(function() _G.FERZZ_UI:Destroy() end)
end
_G.FERZZ_LOADED = true

local ok, CoreGui = pcall(function() return game:GetService("CoreGui") end)
if not ok then CoreGui = nil end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

_G.FERZZ = {
    ForceAuto = false,
    NoRecoil = false,
    NoSpread = false,
    Speed = 0.15,
}

local errorCount = 0
local MAX_ERRORS = 25
local locked = false

local function safeCall(fn, ...)
    if locked then return end
    local success = pcall(fn, ...)
    if not success then
        errorCount = errorCount + 1
        if errorCount >= MAX_ERRORS then
            locked = true
            warn("[FERZZ] Terlalu banyak error, macro dimatikan otomatis.")
        end
    elseif errorCount > 0 then
        errorCount = errorCount - 1
    end
end

local parentGui = CoreGui
if not parentGui then
    parentGui = LocalPlayer:WaitForChild("PlayerGui", 10)
end
if not parentGui then return end

pcall(function()
    local old = parentGui:FindFirstChild("FERZZStoreUI")
    if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FERZZStoreUI"
ScreenGui.Parent = parentGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 99999
ScreenGui.IgnoreGuiInset = true
_G.FERZZ_UI = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 9, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.Active = true

local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(255, 40, 40)
Stroke.Thickness = 2.5

local Corner = Instance.new("UICorner")
Corner.Parent = MainFrame
Corner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 17, 0, 13)
Title.Size = UDim2.new(1, -34, 0, 22)
Title.Font = Enum.Font.GothamBold
Title.Text = "FERZZ STORE [ FS ]"
Title.TextColor3 = Color3.fromRGB(255, 55, 55)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = MainFrame
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 17, 0, 35)
Subtitle.Size = UDim2.new(1, -34, 0, 14)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "ferzz.store"
Subtitle.TextColor3 = Color3.fromRGB(82, 87, 100)
Subtitle.TextSize = 8
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

local Divider = Instance.new("Frame")
Divider.Parent = MainFrame
Divider.BackgroundColor3 = Color3.fromRGB(42, 49, 66)
Divider.BorderSizePixel = 0
Divider.Position = UDim2.new(0, 17, 0, 60)
Divider.Size = UDim2.new(1, -34, 0, 1)

local function CreateMenuItem(parent, yOffset, labelText, callback)
    local Row = Instance.new("Frame")
    Row.Parent = parent
    Row.BackgroundTransparency = 1
    Row.Position = UDim2.new(0, 17, 0, yOffset)
    Row.Size = UDim2.new(1, -34, 0, 30)

    local Label = Instance.new("TextLabel")
    Label.Parent = Row
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -75, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(225, 228, 235)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Button = Instance.new("TextButton")
    Button.Parent = Row
    Button.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    Button.BorderSizePixel = 0
    Button.Position = UDim2.new(1, -63, 0, 2)
    Button.Size = UDim2.new(0, 63, 0, 25)
    Button.Font = Enum.Font.GothamBold
    Button.Text = "OFF"
    Button.TextColor3 = Color3.fromRGB(190, 193, 201)
    Button.TextSize = 10
    Button.AutoButtonColor = false

    local BC = Instance.new("UICorner")
    BC.Parent = Button
    BC.CornerRadius = UDim.new(0, 6)

    local isOn = false
    Button.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            Button.Text = "ON"
            Button.BackgroundColor3 = Color3.fromRGB(232, 35, 45)
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            safeCall(callback, true)
        else
            Button.Text = "OFF"
            Button.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
            Button.TextColor3 = Color3.fromRGB(190, 193, 201)
            safeCall(callback, false)
        end
    end)
end

local modifiedCache = setmetatable({}, {__mode="k"})

local function safeRequire(moduleScript)
    if not moduleScript or not moduleScript:IsA("ModuleScript") then return nil end
    local success,result = pcall(function() return require(moduleScript) end)
    if success and type(result)=="table" then return result end
end

local function modifyModule(mod,callback)
    if type(mod)~="table" then return end
    for k,v in pairs(mod) do
        pcall(function() callback(k,v) end)
    end
end

local function applyMacro(tool)
    if not tool or not tool:IsA("Tool") then return end
    local s = tool:FindFirstChild("Setting")
    if not s or not s:IsA("ModuleScript") then return end
    local m = safeRequire(s)
    if not m then return end
    modifyModule(m,function(k,v)
        if type(k)~="string" then return end
        local kl=string.lower(k)
        if type(v)=="number" then
            if kl:find("firerate") or kl:find("firedelay") or kl:find("rateoffire") or kl:find("cooldown") or kl:find("shootdelay") or kl:find("interval") then
                pcall(function() m[k]=0.15 end)
            elseif kl:find("recoil") or kl:find("kick") or kl:find("shake") or kl:find("bloom") or kl:find("spread") or kl:find("inaccuracy") then
                pcall(function() m[k]=0 end)
            elseif kl=="accuracy" then
                pcall(function() m[k]=1 end)
            end
        elseif type(v)=="boolean" then
            if kl:find("auto") or kl:find("automatic") or kl:find("fullauto") then
                pcall(function() m[k]=true end)
            end
        end
    end)
    modifiedCache[tool]=true
end

local function applyNoRecoil(tool)
    if not tool or not tool:IsA("Tool") then return end
    local s=tool:FindFirstChild("Setting")
    if not s then return end
    local m=safeRequire(s)
    if not m then return end
    modifyModule(m,function(k,v)
        if type(k)~="string" or type(v)~="number" then return end
        local kl=string.lower(k)
        if kl:find("recoil") or kl:find("kick") or kl:find("shake") or kl:find("bloom") then
            pcall(function() m[k]=0 end)
        end
    end)
end

local function applyNoSpread(tool)
    if not tool or not tool:IsA("Tool") then return end
    local s=tool:FindFirstChild("Setting")
    if not s then return end
    local m=safeRequire(s)
    if not m then return end
    modifyModule(m,function(k,v)
        if type(k)~="string" or type(v)~="number" then return end
        local kl=string.lower(k)
        if kl:find("spread") or kl:find("inaccuracy") then
            pcall(function() m[k]=0 end)
        elseif kl=="accuracy" then
            pcall(function() m[k]=1 end)
        end
    end)
end

local function applyToContainer(container)
    if not container then return end
    for _,c in ipairs(container:GetChildren()) do
        if c:IsA("Tool") then
            safeCall(function()
                if _G.FERZZ.NoRecoil then applyNoRecoil(c) end
                if _G.FERZZ.NoSpread then applyNoSpread(c) end
                if _G.FERZZ.ForceAuto and not modifiedCache[c] then applyMacro(c) end
            end)
        end
    end
end

local function applyToAll()
    local char=LocalPlayer.Character
    if char then applyToContainer(char) end
    local bp=LocalPlayer:FindFirstChildOfClass("Backpack")
    if bp then applyToContainer(bp) end
end

CreateMenuItem(MainFrame,68,"Force Auto",function(s)
    _G.FERZZ.ForceAuto=s
    if not s then modifiedCache=setmetatable({}, {__mode="k"}) end
    task.wait(0.1)
    applyToAll()
end)

CreateMenuItem(MainFrame,106,"No Recoil",function(s)
    _G.FERZZ.NoRecoil=s
    task.wait(0.1)
    applyToAll()
end)

CreateMenuItem(MainFrame,144,"No Spread",function(s)
    _G.FERZZ.NoSpread=s
    task.wait(0.1)
    applyToAll()
end)

-- Status bar / slider visual ala referensi
local ValueLabel = Instance.new("TextLabel")
ValueLabel.Parent = MainFrame
ValueLabel.BackgroundTransparency = 1
ValueLabel.Position = UDim2.new(0, 17, 0, 169)
ValueLabel.Size = UDim2.new(1, -34, 0, 14)
ValueLabel.Font = Enum.Font.GothamBold
ValueLabel.Text = "10   |   $0"
ValueLabel.TextColor3 = Color3.fromRGB(220, 224, 232)
ValueLabel.TextSize = 9
ValueLabel.TextXAlignment = Enum.TextXAlignment.Left

local SliderTrack = Instance.new("Frame")
SliderTrack.Parent = MainFrame
SliderTrack.BackgroundColor3 = Color3.fromRGB(29, 37, 54)
SliderTrack.BorderSizePixel = 0
SliderTrack.Position = UDim2.new(0, 17, 0, 188)
SliderTrack.Size = UDim2.new(1, -34, 0, 5)

local SliderCorner = Instance.new("UICorner")
SliderCorner.Parent = SliderTrack
SliderCorner.CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame")
SliderFill.Parent = SliderTrack
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
SliderFill.BorderSizePixel = 0
SliderFill.Size = UDim2.new(0.22, 0, 1, 0)

local FillCorner = Instance.new("UICorner")
FillCorner.Parent = SliderFill
FillCorner.CornerRadius = UDim.new(1, 0)

local SliderKnob = Instance.new("Frame")
SliderKnob.Parent = SliderTrack
SliderKnob.BackgroundColor3 = Color3.fromRGB(230, 235, 245)
SliderKnob.BorderSizePixel = 0
SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
SliderKnob.Position = UDim2.new(0.22, 0, 0.5, 0)
SliderKnob.Size = UDim2.new(0, 16, 0, 16)

local KnobCorner = Instance.new("UICorner")
KnobCorner.Parent = SliderKnob
KnobCorner.CornerRadius = UDim.new(1, 0)

local autoFireCooldown=0
RunService.Heartbeat:Connect(function(dt)
    if locked or not ScreenGui.Parent then return end
    if _G.FERZZ.ForceAuto then
        autoFireCooldown=autoFireCooldown-dt
        if autoFireCooldown<=0 then
            autoFireCooldown=_G.FERZZ.Speed
            local char=LocalPlayer.Character
            if char then
                local tool=char:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Setting") then
                    safeCall(applyMacro,tool)
                    if tool.Parent==char then
                        pcall(function() tool:Activate() end)
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while ScreenGui.Parent and not locked do
        if _G.FERZZ.NoRecoil or _G.FERZZ.NoSpread then safeCall(applyToAll) end
        task.wait(1)
    end
end)

local function watchChar(char)
    if not char then return end
    local conn
    conn=char.ChildAdded:Connect(function(child)
        if not child:IsA("Tool") then return end
        task.wait(0.3)
        if not child.Parent then return end
        safeCall(function()
            if _G.FERZZ.NoRecoil then applyNoRecoil(child) end
            if _G.FERZZ.NoSpread then applyNoSpread(child) end
            if _G.FERZZ.ForceAuto then applyMacro(child) end
        end)
    end)
    char.AncestryChanged:Connect(function(_,parent)
        if not parent and conn then conn:Disconnect() end
    end)
end

if LocalPlayer.Character then watchChar(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(2)
    modifiedCache=setmetatable({}, {__mode="k"})
    if char.Parent then watchChar(char) end
end)

local dragging=false
local dragInput,dragStart,startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=input.Position
        startPos=MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then dragging=false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
        dragInput=input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input==dragInput and dragging then
        local delta=input.Position-dragStart
        MainFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)

print("FERZZ STORE [ FS ] - Macro Universal (SAFE)")
