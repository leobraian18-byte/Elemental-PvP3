
-- ELEMENTAL: PvP
-- Control del poder Bola de Fuego 🔥
-- LocalScript del jugador

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("CastFireball")

local function castFireball()
    local camera = workspace.CurrentCamera
    if not camera then return end

    remote:FireServer(camera.CFrame.LookVector)
end

-- Tecla Q en PC
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.Q then
        castFireball()
    end
end)

-- Botón para celular
local gui = Instance.new("ScreenGui")
gui.Name = "ElementalControls"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Name = "FireballButton"
button.Size = UDim2.new(0, 125, 0, 60)
button.Position = UDim2.new(1, -150, 1, -130)
button.BackgroundColor3 = Color3.fromRGB(220, 65, 20)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "🔥 FUEGO"
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = button

button.Activated:Connect(castFireball)
