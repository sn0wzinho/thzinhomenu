-- Thzinho Menu v2.0 - Sistema de Autenticação

-- ===============================================
-- CONFIGURAÇÕES (ALTERE AQUI!)
-- ===============================================
local CONFIG = {
    -- KeyAuth
    AppName = "Martinezzkq_'s Application",
    OwnerID = "bZNR9STn2V",  -- COLE SEU OWNER ID AQUI
    Version = "1.0",
    
    -- GitHub
    GitHubUser = "sn0wzinho",
    GitHubRepo = "thzinhomenu",
    GitHubBranch = "main",
    MenuFile = "menu.lua"
}

-- ===============================================
-- SERVICES
-- ===============================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- ===============================================
-- VARIÁVEIS
-- ===============================================
local LocalPlayer = Players.LocalPlayer
local authenticated = false
local sessionID = ""
local keySystemOpen = true

-- ===============================================
-- FUNÇÕES SIMPLIFICADAS
-- ===============================================

local function notify(text, color)
    color = color or Color3.fromRGB(0, 170, 255)
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "TempNotification"
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = LocalPlayer.PlayerGui end
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 0, 0, 50)
    frame.Position = UDim2.new(0.5, 0, 0.1, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BackgroundColor3 = color
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, -10)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextWrapped = true
    label.Parent = frame
    
    -- Animação de entrada
    TweenService:Create(frame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 300, 0, 50)
    }):Play()
    
    task.wait(3)
    
    -- Animação de saída
    TweenService:Create(frame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 50)
    }):Play()
    
    task.wait(0.3)
    gui:Destroy()
end

local function initKeyAuth()
    local url = string.format(
        "https://keyauth.win/api/1.1/?name=%s&ownerid=%s&type=init&ver=%s",
        CONFIG.AppName,
        CONFIG.OwnerID,
        CONFIG.Version
    )
    
    local success, response = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if not success then return false, "Erro de conexão" end
    
    local success2, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    
    if not success2 then return false, "Resposta inválida" end
    
    if data.success then
        sessionID = data.sessionid
        return true, "Sessão iniciada"
    end
    
    return false, data.message or "Erro na inicialização"
end

local function verifyKey(key)
    if sessionID == "" then
        local success, msg = initKeyAuth()
        if not success then return false, msg end
    end
    
    key = string.gsub(key, "%s+", "")
    if key == "" then return false, "Digite uma key" end
    
    local url = string.format(
        "https://keyauth.win/api/1.1/?name=%s&ownerid=%s&type=license&key=%s&ver=%s&sessionid=%s",
        CONFIG.AppName,
        CONFIG.OwnerID,
        key,
        CONFIG.Version,
        sessionID
    )
    
    local success, response = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if not success then return false, "Erro de conexão" end
    
    local success2, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    
    if not success2 then return false, "Resposta inválida" end
    
    if data.success then
        authenticated = true
        _G.ThzinhoKey = key
        return true, "✅ Key válida!"
    end
    
    return false, data.message or "❌ Key inválida"
end

local function loadThzinhoMenu()
    notify("Carregando menu Thzinho...", Color3.fromRGB(0, 200, 0))
    
    local url = string.format(
        "https://raw.githubusercontent.com/%s/%s/%s/%s",
        CONFIG.GitHubUser,
        CONFIG.GitHubRepo,
        CONFIG.GitHubBranch,
        CONFIG.MenuFile
    )
    
    print("📦 Carregando menu de:", url)
    
    local success, errorMsg = pcall(function()
        loadstring(game:HttpGet(url, true))()
    end)
    
    if success then
        notify("✅ Menu carregado! Pressione M", Color3.fromRGB(0, 200, 0))
        print("✅ Menu carregado com sucesso!")
    else
        notify("❌ Erro: " .. tostring(errorMsg), Color3.fromRGB(255, 0, 0))
        print("❌ Erro ao carregar menu:", errorMsg)
    end
end

-- ===============================================
-- INTERFACE DE AUTENTICAÇÃO
-- ===============================================

local function createAuthUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ThzinhoAuthUI"
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = LocalPlayer.PlayerGui end
    
    -- Blur effect
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = game:GetService("Lighting")
    
    -- Fundo
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.6
    bg.Parent = gui
    
    -- Container principal
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 0, 0, 0)
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    container.BorderSizePixel = 0
    container.ClipsDescendants = true
    container.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = container
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 80)
    header.BackgroundColor3 = Color3.fromRGB(30, 100, 200)
    header.BorderSizePixel = 0
    header.Parent = container
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0.1, 0)
    title.BackgroundTransparency = 1
    title.Text = "🔐 THZINHO MENU v2.0"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Parent = container
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0.25, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Sistema de Autenticação"
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 12
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    subtitle.Parent = container
    
    -- Input box
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0.8, 0, 0, 45)
    inputBox.Position = UDim2.new(0.1, 0, 0.4, 0)
    inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    inputBox.BorderSizePixel = 0
    inputBox.PlaceholderText = "Digite sua license key..."
    inputBox.Text = ""
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 14
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    inputBox.Parent = container
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputBox
    
    -- Botão de verificar
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(0.7, 0, 0, 50)
    verifyBtn.Position = UDim2.new(0.15, 0, 0.6, 0)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    verifyBtn.BorderSizePixel = 0
    verifyBtn.Text = "✅ VERIFICAR KEY"
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.TextSize = 16
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.AutoButtonColor = false
    verifyBtn.Parent = container
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = verifyBtn
    
    -- Status
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 30)
    status.Position = UDim2.new(0, 0, 0.85, 0)
    status.BackgroundTransparency = 1
    status.Text = "Digite sua license key"
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.Parent = container
    
    -- Função para fechar a UI
    local function closeUI()
        keySystemOpen = false
        TweenService:Create(container, TweenInfo.new(0.5), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        TweenService:Create(blur, TweenInfo.new(0.5), {Size = 0}):Play()
        TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        
        task.wait(0.6)
        gui:Destroy()
        if blur then blur:Destroy() end
    end
    
    -- Função para verificar
    local function doVerification()
        local key = inputBox.Text
        if string.gsub(key, "%s+", "") == "" then
            notify("Digite uma key!", Color3.fromRGB(255, 100, 100))
            return
        end
        
        verifyBtn.Text = "🔄 VERIFICANDO..."
        verifyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        status.Text = "Verificando..."
        
        local success, msg = verifyKey(key)
        
        if success then
            status.Text = "✅ Key válida!"
            verifyBtn.Text = "✅"
            verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            
            -- Salvar key
            if writefile then
                pcall(function()
                    writefile("ThzinhoKey.txt", key)
                end)
            end
            
            task.wait(1)
            closeUI()
            loadThzinhoMenu()
        else
            status.Text = "❌ " .. msg
            verifyBtn.Text = "✅ VERIFICAR KEY"
            verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            notify(msg, Color3.fromRGB(255, 100, 100))
        end
    end
    
    -- Eventos
    verifyBtn.MouseButton1Click:Connect(doVerification)
    
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            doVerification()
        end
    end)
    
    verifyBtn.MouseEnter:Connect(function()
        if verifyBtn.Text ~= "🔄 VERIFICANDO..." then
            verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        end
    end)
    
    verifyBtn.MouseLeave:Connect(function()
        if verifyBtn.Text ~= "🔄 VERIFICANDO..." and verifyBtn.Text ~= "✅" then
            verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        end
    end)
    
    -- Animar entrada
    task.wait(0.2)
    TweenService:Create(blur, TweenInfo.new(0.5), {Size = 15}):Play()
    TweenService:Create(container, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 450, 0, 350)
    }):Play()
    
    -- Inicializar KeyAuth
    spawn(function()
        task.wait(0.5)
        local success, msg = initKeyAuth()
        if success then
            status.Text = "✅ Conectado ao KeyAuth"
            inputBox.PlaceholderText = "Digite sua key para começar..."
        else
            status.Text = "⚠️ " .. msg
            notify("Aviso: " .. msg, Color3.fromRGB(255, 165, 0))
        end
    end)
    
    return gui
end

-- ===============================================
-- INICIALIZAÇÃO PRINCIPAL
-- ===============================================

print("========================================")
print("🔧 THZINHO MENU v2.0 - Sistema de Auth")
print("📱 App: " .. CONFIG.AppName)
print("👤 Owner: " .. CONFIG.OwnerID)
print("========================================")

-- Função para verificar key salva
local function checkSavedKey()
    -- Verificar em _G
    if _G.ThzinhoKey and type(_G.ThzinhoKey) == "string" and _G.ThzinhoKey ~= "" then
        print("🔑 Key encontrada em _G, verificando...")
        local success, msg = verifyKey(_G.ThzinhoKey)
        if success then
            notify("Usando key salva...", Color3.fromRGB(0, 170, 255))
            task.wait(1)
            loadThzinhoMenu()
            return true
        end
    end
    
    -- Verificar em arquivo
    if readfile and isfile and isfile("ThzinhoKey.txt") then
        local key = readfile("ThzinhoKey.txt")
        if key and key ~= "" then
            print("🔑 Key encontrada em arquivo, verificando...")
            local success, msg = verifyKey(key)
            if success then
                _G.ThzinhoKey = key
                notify("Usando key salva...", Color3.fromRGB(0, 170, 255))
                task.wait(1)
                loadThzinhoMenu()
                return true
            end
        end
    end
    
    return false
end

-- Inicializar sistema
task.wait(1)

-- Tentar usar key salva primeiro
if not checkSavedKey() then
    print("🔑 Nenhuma key válida encontrada, abrindo autenticação...")
    task.wait(0.5)
    createAuthUI()
else
    print("✅ Key válida encontrada, menu carregado!")
end

notify("Thzinho Menu v2.0", Color3.fromRGB(0, 170, 255))
