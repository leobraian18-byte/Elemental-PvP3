
-- ELEMENTAL: PvP
-- Poder: Bola de Fuego 🔥
-- Script del servidor

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local remote = Instance.new("RemoteEvent")
remote.Name = "CastFireball"
remote.Parent = ReplicatedStorage

local cooldowns = {}

local DAMAGE = 25
local COOLDOWN = 3
local SPEED = 85
local RANGE = 120

remote.OnServerEvent:Connect(function(player, direction)

    if typeof(direction) ~= "Vector3" then return end

    local now = os.clock()

    if cooldowns[player] and now - cooldowns[player] < COOLDOWN then
        return
    end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then return end
    if direction.Magnitude < 0.9 then return end

    cooldowns[player] = now
    direction = direction.Unit

    local fireball = Instance.new("Part")
    fireball.Name = "Fireball"
    fireball.Shape = Enum.PartType.Ball
    fireball.Size = Vector3.new(3, 3, 3)
    fireball.Material = Enum.Material.Neon
    fireball.Color = Color3.fromRGB(255, 75, 0)
    fireball.Anchored = true
    fireball.CanCollide = false
    fireball.Position = root.Position + direction * 4
    fireball.Parent = workspace

    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255, 100, 0)
    light.Brightness = 3
    light.Range = 12
    light.Parent = fireball

    local distance = 0
    local connection

    connection = game:GetService("RunService").Heartbeat:Connect(function(dt)

        if not fireball.Parent then
            connection:Disconnect()
            return
        end

        local movement = direction * SPEED * dt

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {character, fireball}

        local hit = workspace:Raycast(fireball.Position, movement, params)

        if hit then
            local enemy = hit.Instance:FindFirstAncestorOfClass("Model")
            local humanoid = enemy and enemy:FindFirstChildOfClass("Humanoid")

            if humanoid and enemy ~= character then
                humanoid:TakeDamage(DAMAGE)
            end

            fireball:Destroy()
            connection:Disconnect()
            return
        end

        fireball.Position += movement
        distance += movement.Magnitude

        if distance >= RANGE then
            fireball:Destroy()
            connection:Disconnect()
        end

    end)

    Debris:AddItem(fireball, 3)

end)

Players.PlayerRemoving:Connect(function(player)
    cooldowns[player] = nil
end)
