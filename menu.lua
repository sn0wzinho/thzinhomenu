-- Thzinho Menu v2.0 - Menu Principal
-- Menu completo SEM sistema de autenticação

-- ===============================================
-- SERVICES
-- ===============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ===============================================
-- VARIÁVEIS DE CONTROLE
-- ===============================================
local menuOpen = false
local flyEnabled = false
local noclipEnabled = false
local flySpeed = 50
local espEnabled = false
local espDistance = 1000
local espLines = true
local espNames = true
local flyConnection, noclipConnection, espConnection

-- ===============================================
-- GUI PRINCIPAL
-- ===============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThzinhoMenu"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer.PlayerGui
end

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Sombra
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 10, 10)
Shadow.ZIndex = -1
Shadow.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local HeaderBottom = Instance.new("Frame")
HeaderBottom.Size = UDim2.new(1, 0, 0, 12)
HeaderBottom.Position = UDim2.new(0, 0, 1, -12)
HeaderBottom.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
HeaderBottom.BorderSizePixel = 0
HeaderBottom.Parent = Header

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "THZINHO MENU v2.0"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Linha divisória
local Divider = Instance.new("Frame")
Divider.Name = "Divider"
Divider.Size = UDim2.new(1, -40, 0, 1)
Divider.Position = UDim2.new(0, 20, 0, 50)
Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- Container de Tabs
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 150, 0, 330)
TabContainer.Position = UDim2.new(0, 10, 0, 60)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- Container de Conteúdo
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(0, 420, 0, 330)
ContentContainer.Position = UDim2.new(0, 170, 0, 60)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- ===============================================
-- FUNÇÕES DE CRIAÇÃO DE UI
-- ===============================================

-- Função para criar botão de tab
local function createTabButton(name, index)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Tab"
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, (index - 1) * 45)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.AutoButtonColor = false
    btn.Parent = TabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    return btn
end

-- Função para criar conteúdo de tab
local function createTabContent(name)
    local content = Instance.new("ScrollingFrame")
    content.Name = name .. "Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
    content.Visible = false
    content.Parent = ContentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content
    
    return content
end

-- Criar tabs
local tabs = {"Scripts", "Visual", "Misc", "Config"}
local tabButtons = {}
local tabContents = {}

for i, tabName in ipairs(tabs) do
    tabButtons[tabName] = createTabButton(tabName, i)
    tabContents[tabName] = createTabContent(tabName)
end

-- Função para criar checkbox
local function createCheckbox(parent, text, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container
    
    local checkbox = Instance.new("TextButton")
    checkbox.Size = UDim2.new(0, 20, 0, 20)
    checkbox.Position = UDim2.new(0, 10, 0.5, -10)
    checkbox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    checkbox.BorderSizePixel = 0
    checkbox.Text = ""
    checkbox.Parent = container
    
    local checkCorner = Instance.new("UICorner")
    checkCorner.CornerRadius = UDim.new(0, 4)
    checkCorner.Parent = checkbox
    
    local checkmark = Instance.new("TextLabel")
    checkmark.Size = UDim2.new(1, 0, 1, 0)
    checkmark.BackgroundTransparency = 1
    checkmark.Text = "✓"
    checkmark.Font = Enum.Font.GothamBold
    checkmark.TextSize = 16
    checkmark.TextColor3 = Color3.fromRGB(100, 200, 255)
    checkmark.Visible = false
    checkmark.Parent = checkbox
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -45, 1, 0)
    label.Position = UDim2.new(0, 40, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local enabled = false
    
    checkbox.MouseButton1Click:Connect(function()
        enabled = not enabled
        checkmark.Visible = enabled
        
        TweenService:Create(checkbox, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(35, 35, 40)
        }):Play()
        
        if callback then
            callback(enabled)
        end
    end)
    
    return container
end

-- Função para criar slider
local function createSlider(parent, text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 55)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -70, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container
    
    local sliderBack = Instance.new("Frame")
    sliderBack.Size = UDim2.new(1, -20, 0, 6)
    sliderBack.Position = UDim2.new(0, 10, 0, 35)
    sliderBack.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    sliderBack.BorderSizePixel = 0
    sliderBack.Parent = container
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local dragging = false
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        valueLabel.Text = tostring(value)
        
        if callback then
            callback(value)
        end
    end
    
    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    
    sliderBack.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    return container
end

-- Função para criar botão
local function createButton(parent, text, color, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 45)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 15
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.AutoButtonColor = false
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.new(color.R * 1.2, color.G * 1.2, color.B * 1.2)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = color
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, 0, 0, 40)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, 0, 0, 45)
        }):Play()
        
        if callback then
            callback()
        end
    end)
    
    return button
end

-- ===============================================
-- FUNÇÕES DO MENU
-- ===============================================

-- Função para puxar TODAS as tools do jogo
local function puxarArmas()
    local notification = Instance.new("ScreenGui")
    notification.Name = "TempNotif"
    notification.Parent = ScreenGui.Parent
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(1, -320, 1, -80)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.Parent = notification
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "Procurando todas as Tools..."
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(1, -320, 1, -80)}):Play()
    
    task.wait(1)
    
    local toolsFound = 0
    local character = LocalPlayer.Character
    
    if character then
        if not LocalPlayer:FindFirstChild("Backpack") then
            Instance.new("Backpack").Parent = LocalPlayer
        end
        
        -- Procurar tools
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Tool") then
                toolsFound = toolsFound + 1
                
                local clone = obj:Clone()
                if not clone:FindFirstChild("Handle") then
                    local handle = Instance.new("Part")
                    handle.Name = "Handle"
                    handle.Size = Vector3.new(1, 1, 1)
                    handle.Parent = clone
                end
                
                clone.Parent = LocalPlayer.Backpack
                
                if toolsFound % 5 == 0 then
                    task.wait(0.05)
                end
            end
        end
        
        label.Text = string.format("✅ %d Tools coletadas!", toolsFound)
    else
        label.Text = "❌ Personagem não encontrado!"
    end
    
    task.wait(3)
    
    TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 1, -80)}):Play()
    task.wait(0.3)
    notification:Destroy()
end

-- Função ESP
local espFolder = Instance.new("Folder")
espFolder.Name = "ESP"
espFolder.Parent = ScreenGui

local espUpdaters = {}

local function createESP(player)
    if player == LocalPlayer then return end
    
    local esp = Instance.new("Folder")
    esp.Name = player.Name
    esp.Parent = espFolder
    
    return function()
        if not espEnabled then return end
        if not player.Character then return end
        
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        local head = player.Character:FindFirstChild("Head")
        
        if not rootPart or not head then return end
        
        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
        
        if distance > espDistance then
            for _, v in pairs(esp:GetChildren()) do
                v.Visible = false
            end
            return
        end
        
        -- Line ESP
        if espLines then
            local line = esp:FindFirstChild("Line") or Instance.new("Line")
            line.Name = "Line"
            line.Visible = true
            line.Color = Color3.fromRGB(100, 200, 255)
            line.Thickness = 1
            line.Transparency = 0.5
            line.ZIndex = 1
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                line.To = Vector2.new(screenPos.X, screenPos.Y)
            else
                line.Visible = false
            end
            
            if not line.Parent then
                line.Parent = esp
            end
        else
            local line = esp:FindFirstChild("Line")
            if line then line:Destroy() end
        end
        
        -- Name ESP
        if espNames then
            local nameLabel = esp:FindFirstChild("NameLabel") or Instance.new("TextLabel")
            nameLabel.Name = "NameLabel"
            nameLabel.Visible = true
            nameLabel.BackgroundTransparency = 1
            nameLabel.Size = UDim2.new(0, 200, 0, 20)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 14
            nameLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            nameLabel.TextStrokeTransparency = 0.5
            nameLabel.Text = string.format("%s [%.0fm]", player.Name, distance)
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
            if onScreen then
                nameLabel.Position = UDim2.new(0, screenPos.X - 100, 0, screenPos.Y)
            else
                nameLabel.Visible = false
            end
            
            if not nameLabel.Parent then
                nameLabel.Parent = esp
            end
        else
            local nameLabel = esp:FindFirstChild("NameLabel")
            if nameLabel then nameLabel:Destroy() end
        end
    end
end

-- Função Fly
local function toggleFly(enabled)
    flyEnabled = enabled
    
    if enabled then
        local char = LocalPlayer.Character
        if not char then return end
        
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local bodyVel = Instance.new("BodyVelocity")
            bodyVel.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVel.Velocity = Vector3.new(0, 0, 0)
            bodyVel.Parent = rootPart
            
            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
            bodyGyro.P = 10000
            bodyGyro.CFrame = rootPart.CFrame
            bodyGyro.Parent = rootPart
            
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flyEnabled or not char.Parent then
                    if bodyVel then bodyVel:Destroy() end
                    if bodyGyro then bodyGyro:Destroy() end
                    if flyConnection then flyConnection:Disconnect() end
                    return
                end
                
                local moveDir = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - Camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + Camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                end
                
                bodyVel.Velocity = moveDir * flySpeed
                bodyGyro.CFrame = Camera.CFrame
            end)
        end
    else
        if flyConnection then
            flyConnection:Disconnect()
        end
        
        local char = LocalPlayer.Character
        if char then
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            if rootPart then
                for _, v in pairs(rootPart:GetChildren()) do
                    if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                        v:Destroy()
                    end
                end
            end
        end
    end
end

-- Função Noclip
local function toggleNoclip(enabled)
    noclipEnabled = enabled
    
    if enabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if not noclipEnabled then
                if noclipConnection then noclipConnection:Disconnect() end
                return
            end
            
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- ===============================================
-- POPULAR ABA SCRIPTS
-- ===============================================
createCheckbox(tabContents["Scripts"], "Fly (WASD)", toggleFly)
createSlider(tabContents["Scripts"], "Velocidade do Fly", 0, 200, 50, function(value)
    flySpeed = value
end)

createCheckbox(tabContents["Scripts"], "Noclip", toggleNoclip)

createButton(tabContents["Scripts"], "🔫 Puxar Todas as Tools", Color3.fromRGB(200, 100, 100), puxarArmas)

-- ===============================================
-- POPULAR ABA VISUAL
-- ===============================================
createCheckbox(tabContents["Visual"], "ESP Lines", function(enabled)
    espLines = enabled
    if not enabled then
        for _, esp in pairs(espFolder:GetChildren()) do
            local line = esp:FindFirstChild("Line")
            if line then line:Destroy() end
        end
    end
end)

createCheckbox(tabContents["Visual"], "ESP Names", function(enabled)
    espNames = enabled
    if not enabled then
        for _, esp in pairs(espFolder:GetChildren()) do
            local nameLabel = esp:FindFirstChild("NameLabel")
            if nameLabel then nameLabel:Destroy() end
        end
    end
end)

createSlider(tabContents["Visual"], "Distância do ESP", 100, 5000, 1000, function(value)
    espDistance = value
end)

createCheckbox(tabContents["Visual"], "Ativar ESP", function(enabled)
    espEnabled = enabled
    
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                espUpdaters[player] = createESP(player)
            end
        end
        
        espConnection = RunService.RenderStepped:Connect(function()
            if not espEnabled then
                if espConnection then espConnection:Disconnect() end
                return
            end
            
            for player, updater in pairs(espUpdaters) do
                pcall(updater)
            end
        end)
    else
        if espConnection then
            espConnection:Disconnect()
        end
        
        for _, v in pairs(espFolder:GetChildren()) do
            v:Destroy()
        end
        
        espUpdaters = {}
    end
end)

-- Player connections para ESP
Players.PlayerAdded:Connect(function(player)
    if espEnabled and player ~= LocalPlayer then
        espUpdaters[player] = createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if espUpdaters[player] then
        espUpdaters[player] = nil
    end
    
    local esp = espFolder:FindFirstChild(player.Name)
    if esp then esp:Destroy() end
end)

-- ===============================================
-- POPULAR ABA MISC
-- ===============================================
createButton(tabContents["Misc"], "🔄 Rejoin Server", Color3.fromRGB(100, 150, 255), function()
    local ts = game:GetService("TeleportService")
    local player = game.Players.LocalPlayer
    if player then
        ts:Teleport(game.PlaceId, player)
    end
end)

createButton(tabContents["Misc"], "🟩 Criar Baseplate", Color3.fromRGB(80, 200, 120), function()
    local existing = workspace:FindFirstChild("ThzinhoBaseplate")
    if existing then return end
    
    local baseplate = Instance.new("Part")
    baseplate.Name = "ThzinhoBaseplate"
    baseplate.Size = Vector3.new(512, 4, 512)
    baseplate.Position = Vector3.new(0, -2, 0)
    baseplate.Anchored = true
    baseplate.Material = Enum.Material.Grass
    baseplate.BrickColor = BrickColor.new("Bright green")
    baseplate.TopSurface = Enum.SurfaceType.Smooth
    baseplate.BottomSurface = Enum.SurfaceType.Smooth
    baseplate.Locked = true
    baseplate.Parent = workspace
end)

-- ===============================================
-- POPULAR ABA CONFIG
-- ===============================================
createButton(tabContents["Config"], "🗑️ DESINJETAR MENU", Color3.fromRGB(220, 50, 50), function()
    -- Desativar tudo
    flyEnabled = false
    noclipEnabled = false
    espEnabled = false
    
    if flyConnection then flyConnection:Disconnect() end
    if noclipConnection then noclipConnection:Disconnect() end
    if espConnection then espConnection:Disconnect() end
    
    -- Limpar personagem
    local char = LocalPlayer.Character
    if char then
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            for _, v in pairs(rootPart:GetChildren()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                    v:Destroy()
                end
            end
        end
    end
    
    -- Animação de saída
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    task.wait(0.3)
    ScreenGui:Destroy()
end)

-- ===============================================
-- SISTEMA DE TABS
-- ===============================================
local currentTab = "Scripts"

local function switchTab(tabName)
    for name, btn in pairs(tabButtons) do
        local isActive = name == tabName
        
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = isActive and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(30, 30, 35),
            TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
        }):Play()
        
        tabContents[name].Visible = isActive
    end
    
    currentTab = tabName
end

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- Iniciar com tab Scripts
switchTab("Scripts")

-- ===============================================
-- SISTEMA DE ARRASTAR
-- ===============================================
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ===============================================
-- TOGGLE DO MENU (TECLA M)
-- ===============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.M then
        menuOpen = not menuOpen
        
        if menuOpen then
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 600, 0, 400),
                Position = UDim2.new(0.5, -300, 0.5, -200)
            }):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }):Play()
            
            task.wait(0.2)
            MainFrame.Visible = false
        end
    end
end)

-- ===============================================
-- NOTIFICAÇÃO INICIAL
-- ===============================================
task.wait(0.5)

local notif = Instance.new("ScreenGui")
notif.Parent = ScreenGui.Parent

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 60)
frame.Position = UDim2.new(1, -320, 1, -80)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BorderSizePixel = 0
frame.Parent = notif

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -20, 1, 0)
label.Position = UDim2.new(0, 10, 0, 0)
label.BackgroundTransparency = 1
label.Text = "Thzinho Menu carregado!\nPressione M para abrir."
label.Font = Enum.Font.Gotham
label.TextSize = 13
label.TextColor3 = Color3.fromRGB(200, 200, 200)
label.TextWrapped = true
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = frame

TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(1, -320, 1, -80)}):Play()

task.wait(3)

TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 1, -80)}):Play()
task.wait(0.3)
notif:Destroy()

print("✅ Thzinho Menu v2.0 carregado!")
