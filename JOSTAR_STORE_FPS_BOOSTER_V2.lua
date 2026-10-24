-- JOSTAR STORE - FPS BOOSTER V2
-- Black/white, draggable mobile UI, no animations.
-- Local visual tweaks only; FPS improvement is not guaranteed.

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local previous = playerGui:FindFirstChild("JOSTAR_FPS_V2")
if previous then previous:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "JOSTAR_FPS_V2"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local W = Color3.fromRGB(245,245,245)
local B = Color3.fromRGB(8,8,8)
local D = Color3.fromRGB(20,20,20)
local G = Color3.fromRGB(43,43,43)

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(280,300)
main.Position = UDim2.new(0.5,-140,0.5,-150)
main.BackgroundColor3 = B
main.BorderSizePixel = 0
main.Parent = gui
local stroke = Instance.new("UIStroke",main)
stroke.Color = W
stroke.Thickness = 1.5

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-42,0,38)
title.Position = UDim2.fromOffset(10,0)
title.BackgroundTransparency = 1
title.Text = "JOSTAR STORE"
title.TextColor3 = W
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30,28)
close.Position = UDim2.new(1,-35,0,5)
close.BackgroundColor3 = G
close.Text = "X"
close.TextColor3 = W
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.Parent = main

local tabs = Instance.new("Frame")
tabs.Position = UDim2.fromOffset(8,42)
tabs.Size = UDim2.new(1,-16,0,30)
tabs.BackgroundTransparency = 1
tabs.Parent = main
local tabLayout = Instance.new("UIListLayout",tabs)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0,3)

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(8,80)
content.Size = UDim2.new(1,-16,1,-88)
content.BackgroundTransparency = 1
content.Parent = main

local pages = {}
local function showPage(name)
    for n,p in pairs(pages) do p.Visible = (n == name) end
    for _,v in ipairs(tabs:GetChildren()) do
        if v:IsA("TextButton") then
            local active = v.Name == name
            v.BackgroundColor3 = active and W or G
            v.TextColor3 = active and B or W
        end
    end
end

local function addPage(name,order)
    local tab = Instance.new("TextButton")
    tab.Name = name
    tab.Size = UDim2.new(0,48,1,0)
    tab.BackgroundColor3 = G
    tab.Text = name
    tab.TextColor3 = W
    tab.TextSize = 9
    tab.Font = Enum.Font.GothamBold
    tab.LayoutOrder = order
    tab.Parent = tabs

    local page = Instance.new("ScrollingFrame")
    page.Name = name.."Page"
    page.Size = UDim2.fromScale(1,1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new()
    page.Visible = false
    page.Parent = content
    local layout = Instance.new("UIListLayout",page)
    layout.Padding = UDim.new(0,7)
    pages[name] = page
    tab.Activated:Connect(function() showPage(name) end)
    return page
end

local function addLabel(parent,text)
    local x = Instance.new("TextLabel")
    x.Size = UDim2.new(1,-2,0,36)
    x.BackgroundColor3 = D
    x.BorderSizePixel = 0
    x.Text = text
    x.TextColor3 = W
    x.TextSize = 12
    x.Font = Enum.Font.Gotham
    x.TextWrapped = true
    x.Parent = parent
    return x
end

local function addButton(parent,text,callback)
    local x = Instance.new("TextButton")
    x.Size = UDim2.new(1,-2,0,36)
    x.BackgroundColor3 = G
    x.BorderSizePixel = 0
    x.Text = text
    x.TextColor3 = W
    x.TextSize = 12
    x.Font = Enum.Font.GothamBold
    x.Parent = parent
    x.Activated:Connect(callback)
    return x
end

local home = addPage("HOME",1)
local boost = addPage("BOOST",2)
local graph = addPage("GRAPH",3)
local fx = addPage("FX",4)
local info = addPage("INFO",5)

addLabel(home,"FPS BOOSTER V2")
addLabel(home,"Black & white | Draggable | No animation")
addLabel(home,"Pilih BOOST, GRAPH, atau FX di atas.")

local boostOn = false
local oldQuality
local savedEffects = {}

local function setPostEffects(enabled)
    for _,obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("PostEffect") then
            if savedEffects[obj] == nil then savedEffects[obj] = obj.Enabled end
            obj.Enabled = enabled and savedEffects[obj] or false
        end
    end
end

local function toggleBoost()
    if not boostOn then
        pcall(function()
            oldQuality = settings().Rendering.QualityLevel
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        Lighting.GlobalShadows = false
        setPostEffects(false)
        boostOn = true
    else
        pcall(function()
            if oldQuality then settings().Rendering.QualityLevel = oldQuality end
        end)
        Lighting.GlobalShadows = true
        for obj,wasOn in pairs(savedEffects) do
            if obj and obj.Parent then obj.Enabled = wasOn end
        end
        boostOn = false
    end
end

local boostButton
boostButton = addButton(boost,"FPS BOOST: OFF",function()
    toggleBoost()
    boostButton.Text = "FPS BOOST: "..(boostOn and "ON" or "OFF")
end)
addLabel(boost,"Mengurangi bayangan dan efek visual lokal.")
addButton(boost,"TOGGLE BOOST",function()
    toggleBoost()
    boostButton.Text = "FPS BOOST: "..(boostOn and "ON" or "OFF")
end)

local shadows = true
addButton(graph,"TOGGLE GLOBAL SHADOWS",function()
    shadows = not shadows
    Lighting.GlobalShadows = shadows
end)
addButton(graph,"SET QUALITY LEVEL 1",function()
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
end)
addButton(graph,"SET QUALITY LEVEL 3",function()
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level03 end)
end)
addLabel(graph,"Kualitas rendering dapat dibatasi Roblox.")

local effectsHidden = false
addButton(fx,"TOGGLE POST EFFECTS",function()
    effectsHidden = not effectsHidden
    setPostEffects(not effectsHidden)
end)
addButton(fx,"HIDE TERRAIN DECORATION",function()
    pcall(function() Workspace.Terrain.Decoration = false end)
end)
addLabel(fx,"Perubahan visual bergantung pada game.")

addLabel(info,"JOSTAR STORE • FPS V2")
addLabel(info,"Tidak mengubah server atau menjamin FPS.")
addLabel(info,"Tutup panel dengan tombol X.")

-- Drag by touching/holding the title bar
local dragging, dragStart, startPos, activeInput
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        activeInput = input
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then
        activeInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input == activeInput or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,
                                  startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)

close.Activated:Connect(function() gui:Destroy() end)
showPage("HOME")
