local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Variable para guardar el estado del Anti-Hit
local antiHitEnabled = false
local debounce = false

-- Lógica para la función Anti-Hit
local function activateAntiHit()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local webSlinger = character:FindFirstChildOfClass("Tool")
    
    if webSlinger and webSlinger.Name == "WebSlinger" then
        if antiHitEnabled and not debounce then
            debounce = true
            
            -- Ahora buscamos el RemoteEvent basándonos en el nombre de la herramienta.
            -- Hay que probar varias opciones, que es lo que haría un explorador.
            local remoteEvent = ReplicatedStorage:FindFirstChild(webSlinger.Name .. "Event")
                or ReplicatedStorage:FindFirstChild("Use" .. webSlinger.Name)
                or webSlinger:FindFirstChild("RemoteEvent")
            
            if remoteEvent and remoteEvent:IsA("RemoteEvent") then
                print("¡Bingo! Encontré el RemoteEvent: " .. remoteEvent.Name)
                
                -- Ahora intentamos dispararlo. Lo más común es enviar la posición del objetivo.
                local targetPosition = character.HumanoidRootPart.Position
                remoteEvent:FireServer(targetPosition)
                
                print("Anti-Hit activado. Invulnerabilidad por 10 segundos.")
            else
                print("Error: No se encontró un RemoteEvent compatible.")
                print("Podría ser que se llame de otra forma.")
            end
            
            wait(10)
            debounce = false
        end
    else
        print("Error: No se encontró el guante WebSlinger en tu personaje. Asegúrate de tenerlo equipado.")
    end
end

-- Función para inicializar el script (crear la GUI)
local function initializeScript()
    if PlayerGui:FindFirstChild("AntiHitMenu") then
        PlayerGui.AntiHitMenu:Destroy()
    end

    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "AntiHitMenu"
    mainGui.Parent = PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.2, 0, 0.1, 0)
    mainFrame.Position = UDim2.new(0.5, -mainFrame.Size.X.Scale * 0.5, 0.5, -mainFrame.Size.Y.Scale * 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderSizePixel = 2
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = mainGui

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0.3, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Text = "Anti-Hit Script"
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 18
    titleLabel.Parent = mainFrame
    
    local antiHitButton = Instance.new("TextButton")
    antiHitButton.Size = UDim2.new(0.8, 0, 0.5, 0)
    antiHitButton.Position = UDim2.new(0.1, 0, 0.4, 0)
    antiHitButton.BackgroundColor3 = antiHitEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(80, 80, 80)
    antiHitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    antiHitButton.Text = antiHitEnabled and "Desactivar Anti-Hit" or "Activar Anti-Hit"
    antiHitButton.Parent = mainFrame
    
    antiHitButton.MouseButton1Click:Connect(function()
        antiHitEnabled = not antiHitEnabled
        antiHitButton.BackgroundColor3 = antiHitEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(80, 80, 80)
        antiHitButton.Text = antiHitEnabled and "Desactivar Anti-Hit" or "Activar Anti-Hit"
        print("Anti-Hit ha sido " .. (antiHitEnabled and "activado" or "desactivado"))
        
        if antiHitEnabled then
            activateAntiHit()
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    initializeScript()
end)

initializeScript()
