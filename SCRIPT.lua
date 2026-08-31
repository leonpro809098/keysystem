--[[
    ================================================================
    [ SCRIPT INFORMATION ]
    Project: Custom Script
    Author: OYB
    YouTube: https://www.youtube.com/channel/UCAlXXV1Hbvf7WbfXARuVtiQ
    
    [ TERMS AND CONDITIONS ]
    - You ARE allowed to use and modify this script for your own games.
    - You ARE NOT allowed to re-upload, redistribute, or claim 
      ownership of this script.
    - Removing or altering these credits is strictly prohibited.
    
    Copyright (c) 2026 OYB. All rights reserved.
    ================================================================
]]

-- ⚠️ IMPORTANT: Put this code at the VERY TOP of your Main Script (before obfuscating) ⚠️

local ProtectionConfig = {
    -- 🔴 CRITICAL: This MUST exactly match the 'Secret' value in your Key System's Config!
    -- If your Key System has: Secret = "Test"
    -- Then this must also be: SecretKey = "Test"
    SecretKey = "Leonpro809098",
    
    -- The name of your Hub (shown in the kick message if they try to bypass)
    HubName = "Sovich HUB"
}

-- Anti-Bypass Logic: Checks if the Key System successfully set the global variable
if not _G[ProtectionConfig.SecretKey] then
    local player = game:GetService("Players").LocalPlayer
    if player then
        player:Kick("\n🛡️ Unauthorized Execution 🛡️\n\nPlease use the official Key System to run " .. ProtectionConfig.HubName)
    end
    return -- Stops the rest of the script from loading!
end

-------------------------------------------------------------------------------
-- 👇 YOUR MAIN SCRIPT CODE STARTS HERE 👇
-------------------------------------------------------------------------------

print(ProtectionConfig.HubName .. " Loaded Successfully!") 

-- =================================================================
-- SOVICH v4.0 - SCRIPT COMPLETO (UI + COMBAT + VISUALS + SKINS + TP)
-- =================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = localPlayer:GetMouse()

-- Referencia a las configuraciones globales de armas (si existe en el juego)
local WeaponConfig = getgenv().WeaponConfig or _G.WeaponConfig

-- -----------------------------------------------------------------
-- CONFIGURACIÓN GLOBAL
-- -----------------------------------------------------------------
local settings = {
    -- Player
    walkSpeed = 16,
    speedEnabled = false,
    jumpPower = 50,
    superJumpEnabled = false,
    infJumpEnabled = false,
    noclipEnabled = false,
    -- Combat
    aimbotEnabled = false,
    aimSmooth = 0.2,
    aimFov = 150,
    aimPart = "Head",
    hitboxEnabled = false,
    hitboxSize = 2,
    spinbotEnabled = false,
    spinSpeed = 20,
    -- Visuals
    espEnabled = false,
    espBoxes = true,
    espTracers = false,
    espNames = true,
    espColor = Color3.fromRGB(0, 230, 120),
    fullbrightEnabled = false,
    -- Settings
    uiScale = 1.0
}

local connections = {}
local espObjects = {}

-- Limpieza previa si ya existe la interfaz
if CoreGui:FindFirstChild("SovichUI") then
    CoreGui.SovichUI:Destroy()
end

-- Check de Soporte para Drawing API
local hasDrawing = pcall(function()
    local d = Drawing.new("Line")
    d.Visible = false
    d:Remove()
end)

-- -----------------------------------------------------------------
-- INTERFAZ GRÁFICA PRINCIPAL
-- -----------------------------------------------------------------
local COL = {
    bg = Color3.fromRGB(18, 20, 24),
    panel = Color3.fromRGB(25, 27, 32),
    sidebar = Color3.fromRGB(21, 23, 27),
    accent = Color3.fromRGB(0, 230, 120),
    text = Color3.fromRGB(240, 240, 240),
    muted = Color3.fromRGB(140, 145, 155),
    btn = Color3.fromRGB(32, 35, 42),
    btnActive = Color3.fromRGB(45, 50, 60)
}

local gui = Instance.new("ScreenGui")
gui.Name = "SovichUI"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 350)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -175)
MainFrame.BackgroundColor3 = COL.bg
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = MainFrame

local uiScaleObj = Instance.new("UIScale")
uiScaleObj.Scale = settings.uiScale
uiScaleObj.Parent = MainFrame

-- Círculo de FOV para Aimbot
local fovCircle
if hasDrawing then
    fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1
    fovCircle.NumSides = 30
    fovCircle.Radius = settings.aimFov
    fovCircle.Color = COL.accent
    fovCircle.Visible = false
    fovCircle.Filled = false
end

-- Drag System
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + (delta.X / uiScaleObj.Scale),
            startPos.Y.Scale, startPos.Y.Offset + (delta.Y / uiScaleObj.Scale)
        )
    end
end)

-- TopBar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = COL.panel
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "SOVICH <font color='#00E678'>v4.0</font>"
Title.RichText = true
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = COL.text
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0, 150, 1, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.TextColor3 = COL.muted
CloseBtn.Size = UDim2.new(0, 32, 1, 0)
CloseBtn.Position = UDim2.new(1, -32, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = TopBar

-- SideBar
local SideBar = Instance.new("Frame")
SideBar.Name = "SideBar"
SideBar.Size = UDim2.new(0, 40, 1, -38)
SideBar.Position = UDim2.new(0, 6, 0, 35)
SideBar.BackgroundColor3 = COL.sidebar
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 6)
sideCorner.Parent = SideBar

local sideList = Instance.new("UIListLayout")
sideList.SortOrder = Enum.SortOrder.LayoutOrder
sideList.Padding = UDim.new(0, 4)
sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideList.Parent = SideBar

local sidePadding = Instance.new("UIPadding")
sidePadding.PaddingTop = UDim.new(0, 6)
sidePadding.Parent = SideBar

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -58, 1, -44)
ContentContainer.Position = UDim2.new(0, 52, 0, 38)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local tabs = {}
local tabButtons = {}

local function createTab(id)
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = "Tab_" .. id
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.ScrollBarThickness = 2
    tabFrame.ScrollBarImageColor3 = COL.accent
    tabFrame.Visible = false
    tabFrame.Parent = ContentContainer
    
    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 8)
    list.Parent = tabFrame
    
    tabs[id] = tabFrame
    
    local btn = Instance.new("TextButton")
    btn.Name = "Btn_" .. id
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Text = id
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = COL.muted
    btn.BackgroundColor3 = COL.btn
    btn.BorderSizePixel = 0
    btn.Parent = SideBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for tId, frame in pairs(tabs) do frame.Visible = (tId == id) end
        for tId, b in pairs(tabButtons) do
            b.BackgroundColor3 = (tId == id) and COL.btnActive or COL.btn
            b.TextColor3 = (tId == id) and COL.accent or COL.muted
        end
    end)
    
    tabButtons[id] = btn
    return tabFrame
end

local tabP = createTab("P")
local tabC = createTab("C")
local tabM = createTab("M")
local tabV = createTab("V")
local tabT = createTab("T")
local tabS = createTab("S")
local tabA = createTab("A")

tabP.Visible = true
tabButtons["P"].BackgroundColor3 = COL.btnActive
tabButtons["P"].TextColor3 = COL.accent

-- -----------------------------------------------------------------
-- COMPONENTES UI (Toggles, Sliders, Buttons)
-- -----------------------------------------------------------------
local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 36)
    frame.BackgroundColor3 = COL.panel
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = COL.text
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local switch = Instance.new("TextButton")
    switch.Text = ""
    switch.Size = UDim2.new(0, 36, 0, 18)
    switch.Position = UDim2.new(1, -44, 0.5, -9)
    switch.BackgroundColor3 = default and COL.accent or COL.btn
    switch.Parent = frame
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    dot.BackgroundColor3 = COL.text
    dot.Parent = switch
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    local state = default
    switch.MouseButton1Click:Connect(function()
        state = not state
        switch.BackgroundColor3 = state and COL.accent or COL.btn
        dot.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        callback(state)
    end)
end

local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 46)
    frame.BackgroundColor3 = COL.panel
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = COL.text
    label.Position = UDim2.new(0, 10, 0, 4)
    label.Size = UDim2.new(0.6, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valLabel = Instance.new("TextLabel")
    valLabel.Text = tostring(default)
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 12
    valLabel.TextColor3 = COL.accent
    valLabel.Position = UDim2.new(1, -60, 0, 4)
    valLabel.Size = UDim2.new(0, 50, 0, 18)
    valLabel.BackgroundTransparency = 1
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = frame
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 6)
    track.Position = UDim2.new(0, 10, 0, 30)
    track.BackgroundColor3 = COL.btn
    track.Parent = frame
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame")
    local initPct = math.clamp((default - min) / (max - min), 0, 1)
    fill.Size = UDim2.new(initPct, 0, 1, 0)
    fill.BackgroundColor3 = COL.accent
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local sliding = false
    local function update(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (max - min) * pos)
        if min < 2 and max <= 2 then
            val = math.floor((min + (max - min) * pos) * 100) / 100
        end
        valLabel.Text = tostring(val)
        callback(val)
    end
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
            update(input)
        end
    end)
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
    end)
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextColor3 = COL.text
    btn.Size = UDim2.new(1, -6, 0, 32)
    btn.BackgroundColor3 = COL.btn
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

-- -----------------------------------------------------------------
-- CONTENIDO DE PESTAÑAS
-- -----------------------------------------------------------------

-- P: Player
createToggle(tabP, "Activar Speed", settings.speedEnabled, function(v) settings.speedEnabled = v end)
createSlider(tabP, "WalkSpeed", 16, 150, settings.walkSpeed, function(v) settings.walkSpeed = v end)
createToggle(tabP, "Super Jump", settings.superJumpEnabled, function(v) settings.superJumpEnabled = v end)
createSlider(tabP, "JumpPower", 50, 300, settings.jumpPower, function(v) settings.jumpPower = v end)
createToggle(tabP, "Salto Infinito", settings.infJumpEnabled, function(v) settings.infJumpEnabled = v end)
createToggle(tabP, "Noclip", settings.noclipEnabled, function(v) settings.noclipEnabled = v end)

-- C: Combat
createToggle(tabC, "Activar Aimbot", settings.aimbotEnabled, function(v)
    settings.aimbotEnabled = v
    if fovCircle then fovCircle.Visible = v end
end)
createSlider(tabC, "Suavizado Aimbot", 0.05, 1, settings.aimSmooth, function(v) settings.aimSmooth = v end)
createSlider(tabC, "Radio FOV", 50, 400, settings.aimFov, function(v)
    settings.aimFov = v
    if fovCircle then fovCircle.Radius = v end
end)
createToggle(tabC, "Hitbox Expander", settings.hitboxEnabled, function(v) settings.hitboxEnabled = v end)
createSlider(tabC, "Tamaño Hitbox", 2, 20, settings.hitboxSize, function(v) settings.hitboxSize = v end)
createToggle(tabC, "Spinbot", settings.spinbotEnabled, function(v) settings.spinbotEnabled = v end)

-- M: Visuals
createToggle(tabM, "Activar ESP 2D", settings.espEnabled, function(v) settings.espEnabled = v end)
createToggle(tabM, "ESP Cajas (Boxes)", settings.espBoxes, function(v) settings.espBoxes = v end)
createToggle(tabM, "ESP Líneas (Tracers)", settings.espTracers, function(v) settings.espTracers = v end)
createToggle(tabM, "Fullbright", settings.fullbrightEnabled, function(v)
    settings.fullbrightEnabled = v
    if not v then Lighting.Ambient = Color3.fromRGB(127, 127, 127) end
end)

-- V: Skins System (Parche seguro para mantener el disparo)
local function safeApplySkin(targetKey, sourceSkinKey)
    if WeaponConfig and WeaponConfig[targetKey] and WeaponConfig[sourceSkinKey] then
        local target = WeaponConfig[targetKey]
        local source = WeaponConfig[sourceSkinKey]
        
        -- Copia únicamente las propiedades cosméticas para evitar romper el script de disparo
        if source.FirstPersonModel then target.FirstPersonModel = source.FirstPersonModel end
        if source.ThirdPersonModel then target.ThirdPersonModel = source.ThirdPersonModel end
        if source.Textures then target.Textures = source.Textures end
        if source.MeshId then target.MeshId = source.MeshId end
    end
end

createButton(tabV, "Aplicar Skin Gold / Premium", function()
    safeApplySkin("AK47", "AK47_Gold")
    safeApplySkin("M4A1", "M4A1_Hyperbeast")
end)

-- T: Teleport System
local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(1, -6, 0, 180)
playerListFrame.BackgroundColor3 = COL.panel
playerListFrame.Parent = tabT
Instance.new("UICorner", playerListFrame).CornerRadius = UDim.new(0, 6)

local tpScroll = Instance.new("ScrollingFrame")
tpScroll.Size = UDim2.new(1, -10, 1, -10)
tpScroll.Position = UDim2.new(0, 5, 0, 5)
tpScroll.BackgroundTransparency = 1
tpScroll.Parent = playerListFrame
local tpList = Instance.new("UIListLayout")
tpList.Padding = UDim.new(0, 4)
tpList.Parent = tpScroll

local function refreshTPList()
    for _, child in ipairs(tpScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            local btn = Instance.new("TextButton")
            btn.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 11
            btn.TextColor3 = COL.text
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Size = UDim2.new(1, 0, 0, 26)
            btn.BackgroundColor3 = COL.btn
            btn.Parent = tpScroll
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            
            btn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character then
                    localPlayer.Character:MoveTo(p.Character.HumanoidRootPart.Position)
                end
            end)
        end
    end
end
createButton(tabT, "Actualizar Lista Jugadores", refreshTPList)
refreshTPList()

-- S: Settings
createSlider(tabS, "Escala de Interfaz", 0.5, 1.5, settings.uiScale, function(v)
    settings.uiScale = v
    uiScaleObj.Scale = v
end)

local function unload()
    for _, conn in pairs(connections) do conn:Disconnect() end
    if fovCircle then fovCircle:Remove() end
    for _, obj in pairs(espObjects) do
        if obj.box then obj.box:Remove() end
        if obj.line then obj.line:Remove() end
        if obj.holder then obj.holder:Destroy() end
    end
    gui:Destroy()
end

createButton(tabS, "Desactivar y Limpiar Script (Unload)", unload)
CloseBtn.MouseButton1Click:Connect(unload)

-- A: About
local aboutText = Instance.new("TextLabel")
aboutText.Size = UDim2.new(1, -6, 0, 100)
aboutText.BackgroundColor3 = COL.panel
aboutText.TextColor3 = COL.muted
aboutText.Text = "SOVICH v4.0 Full Version\nSistemas incluidos: Movement, Aimbot, ESP, Skins Safe-Patch, Teleport y UIScale Manager."
aboutText.Font = Enum.Font.GothamMedium
aboutText.TextSize = 12
aboutText.Parent = tabA
Instance.new("UICorner", aboutText).CornerRadius = UDim.new(0, 6)

-- -----------------------------------------------------------------
-- SISTEMAS LÓGICOS DE EJECUCIÓN (LOOPS & CHEATS)
-- -----------------------------------------------------------------

-- ESP Manager
local function createESP(player)
    if espObjects[player] then return end
    if hasDrawing then
        local box = Drawing.new("Square")
        box.Thickness = 1
        box.Filled = false
        box.Color = settings.espColor
        
        local line = Drawing.new("Line")
        line.Thickness = 1
        line.Color = settings.espColor
        
        espObjects[player] = { box = box, line = line }
    else
        local holder = Instance.new("Folder")
        holder.Name = "ESP_" .. player.Name
        holder.Parent = gui
        
        local box = Instance.new("Frame")
        box.BackgroundTransparency = 1
        box.Visible = false
        box.Parent = holder
        local stroke = Instance.new("UIStroke")
        stroke.Color = settings.espColor
        stroke.Thickness = 1
        stroke.Parent = box
        
        espObjects[player] = { holder = holder, boxGui = box }
    end
end

local function removeESP(player)
    if espObjects[player] then
        local data = espObjects[player]
        if data.box then data.box:Remove() end
        if data.line then data.line:Remove() end
        if data.holder then data.holder:Destroy() end
        espObjects[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= localPlayer then createESP(p) end
end
table.insert(connections, Players.PlayerAdded:Connect(createESP))
table.insert(connections, Players.PlayerRemoving:Connect(removeESP))

-- Main Loop (RenderStepped)
table.insert(connections, RunService.RenderStepped:Connect(function()
    -- FOV Position
    if fovCircle then
        fovCircle.Position = UserInputService:GetMouseLocation()
    end
    
    -- Aimbot Target & Lock
    if settings.aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local targetPart = nil
        local shortestDist = settings.aimFov
        local mousePos = UserInputService:GetMouseLocation()
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild(settings.aimPart) then
                local part = p.Character[settings.aimPart]
                local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        targetPart = part
                    end
                end
            end
        end
        
        if targetPart then
            local targetCamPos = camera:WorldToViewportPoint(targetPart.Position)
            local currentCamPos = camera:WorldToViewportPoint(camera.CFrame.Position + camera.CFrame.LookVector)
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
        end
    end
    
    -- ESP Rendering
    for player, data in pairs(espObjects) do
        if settings.espEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local sizeY = (camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y - camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y)
                local sizeX = sizeY * 0.6
                
                if data.box then
                    data.box.Size = Vector2.new(math.abs(sizeX), math.abs(sizeY))
                    data.box.Position = Vector2.new(pos.X - (sizeX / 2), pos.Y - (sizeY / 2))
                    data.box.Visible = settings.espBoxes
                    
                    if settings.espTracers then
                        data.line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        data.line.To = Vector2.new(pos.X, pos.Y)
                        data.line.Visible = true
                    else
                        data.line.Visible = false
                    end
                elseif data.boxGui then
                    data.boxGui.Size = UDim2.new(0, math.abs(sizeX), 0, math.abs(sizeY))
                    data.boxGui.Position = UDim2.new(0, pos.X - (sizeX / 2), 0, pos.Y - (sizeY / 2))
                    data.boxGui.Visible = settings.espBoxes
                end
            else
                if data.box then data.box.Visible = false data.line.Visible = false end
                if data.boxGui then data.boxGui.Visible = false end
            end
        else
            if data.box then data.box.Visible = false data.line.Visible = false end
            if data.boxGui then data.boxGui.Visible = false end
        end
    end
end))

-- Physical Loops (Stepped)
table.insert(connections, RunService.Stepped:Connect(function()
    local char = localPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if settings.speedEnabled then hum.WalkSpeed = settings.walkSpeed end
        if settings.superJumpEnabled then hum.JumpPower = settings.jumpPower end
        if settings.noclipEnabled then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        if settings.spinbotEnabled and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(settings.spinSpeed), 0)
        end
    end
    if settings.fullbrightEnabled then Lighting.Ambient = Color3.fromRGB(255, 255, 255) end
end))

-- Hitbox Expander Loop
table.insert(connections, RunService.RenderStepped:Connect(function()
    if settings.hitboxEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                head.Size = Vector3.new(settings.hitboxSize, settings.hitboxSize, settings.hitboxSize)
                head.Transparency = 0.6
                head.CanCollide = false
            end
        end
    end
end))

-- Infinite Jump
table.insert(connections, UserInputService.JumpRequest:Connect(function()
    if settings.infJumpEnabled and localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
        localPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))
