-- Thzinho Menu Loader v2.0

print("🚀 Thzinho Menu - Carregando sistema...")

-- Carregar o sistema de autenticação
local success, errorMsg = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/sn0wzinho/thzinhomenu/main/auth_system.lua"))()
end)

if not success then
    warn("❌ Erro ao carregar:", errorMsg)
    
    -- Notificação de erro
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Thzinho Menu",
        Text = "Erro ao carregar. Tente novamente.",
        Duration = 5
    })
end

print("✅ Loader executado!")
