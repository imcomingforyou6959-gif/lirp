-- lib/Aimbot.lua
-- Complete aimbot system (silent/lock aim, prediction, resolver, FOV circle, keybinds)
-- Based on original obfuscated script's r39_0 aimbot logic

local Aimbot = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer
local Settings = require(script.Parent.Settings)
local Utils = require(script.Parent.Utils)
local Constants = require(script.Parent.Constants)

-- Internal state
local aimbotActive = false
local currentTarget = nil
local lastTargetSwitchTime = 0
local targetSwitchDelay = 0.05
local resolverCache = {}
local lastInstantHitTime = 0
local lastBulletTime = 0
local viewModel = nil
local projectileRemote = nil
local inflictRemote = nil
local fovCircle = nil

-- FOV Circle setup
local function setupFOVCircle()
    if not fovCircle then
        fovCircle = Drawing.new("Circle")
        fovCircle.NumSides = 64
        fovCircle.Thickness = 3
        fovCircle.Transparency = 0.5
        fovCircle.Visible = false
    end
    fovCircle.Position = Camera.ViewportSize / 2
    fovCircle.Radius = Settings:Get("AimbotFov")
    fovCircle.Color = Settings:Get("FovColor")
    return fovCircle
end

-- Helper: World to viewport distance from center
local function getScreenDistance(position)
    local screenPos, onScreen = Camera:WorldToViewportPoint(position)
    if not onScreen then return math.huge end
    local center = Camera.ViewportSize / 2
    return (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
end

-- Check if target is valid (alive, not self, team check, wall check)
local function isValidTarget(target)
    if target == lp then return false end
    local character = target:IsA("Model") and target or target.Character
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    -- Team check (clan based)
    if Settings:Get("TeamCheck") then
        local targetClan = ReplicatedStorage.Players:FindFirstChild(target.Name) 
            and ReplicatedStorage.Players[target.Name].Status.Journey.Clan:GetAttribute("CurrentClan")
        local myClan = ReplicatedStorage.Players[lp.Name].Status.Journey.Clan:GetAttribute("CurrentClan")
        if myClan and targetClan and myClan == targetClan then
            return false
        end
    end
    
    -- Wall check
    if Settings:Get("WallCheck") then
        local origin = Camera.CFrame.Position
        local aimPart = character:FindFirstChild(Settings:Get("RealAimPart")) or character:FindFirstChild("Head")
        if not aimPart then return false end
        local direction = aimPart.Position - origin
        local ray = Utils:Raycast(origin, direction, {lp.Character})
        if ray and not ray.Instance:IsDescendantOf(character) then
            return false
        end
    end
    
    return true
end

-- Get closest target within FOV
function Aimbot:GetClosestTarget()
    local closest = nil
    local closestDist = Settings:Get("AimbotFov")
    local center = Camera.ViewportSize / 2
    
    -- Players
    if Settings:Get("AimbotPlayer") then
        for _, player in ipairs(Players:GetPlayers()) do
            if isValidTarget(player) then
                local aimPart = player.Character:FindFirstChild(Settings:Get("RealAimPart")) or player.Character:FindFirstChild("Head")
                if aimPart then
                    local dist = getScreenDistance(aimPart.Position)
                    if dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    
    -- AI / NPCs
    if Settings:Get("AimbotTargetAi") then
        for _, zone in ipairs(Workspace.AiZones:GetChildren()) do
            for _, npc in ipairs(zone:GetChildren()) do
                if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    local aimPart = npc:FindFirstChild(Settings:Get("RealAimPart")) or npc:FindFirstChild("Head")
                    if aimPart then
                        local dist = getScreenDistance(aimPart.Position)
                        if dist < closestDist then
                            closestDist = dist
                            closest = npc
                        end
                    end
                end
            end
        end
    end
    
    return closest
end

-- Randomize hit part (if enabled)
local function randomizeHitPart()
    if Settings:Get("AimbotRandomizeHitPart") then
        local parts = Constants.AimbotParts
        Settings:Set("RealAimPart", parts[math.random(#parts)])
    else
        Settings:Set("RealAimPart", Settings:Get("AimPart"))
    end
end

-- Prediction: calculate target position with velocity
local function getPredictedPosition(part)
    if not Settings:Get("Prediction") then return part.Position end
    local velocity = part.AssemblyLinearVelocity or Vector3.new()
    local distance = (part.Position - Camera.CFrame.Position).Magnitude
    local muzzleVelocity = 0
    -- Get muzzle velocity from current weapon (original logic)
    local currentWeapon = ReplicatedStorage.Players[lp.Name].Status.GameplayVariables.EquippedTool.Value
    if currentWeapon then
        local ammoType = ReplicatedStorage.AmmoTypes:FindFirstChild(currentWeapon)
        if ammoType then
            muzzleVelocity = ammoType:GetAttribute("MuzzleVelocity") or 0
        end
    end
    if muzzleVelocity > 100 then
        local travelTime = distance / muzzleVelocity
        return part.Position + velocity * travelTime
    end
    return part.Position
end

-- Silent aim (manipulate viewmodel or fire remotes)
local function silentAim(target)
    if not target then return end
    local aimPart = target:IsA("Model") and target:FindFirstChild(Settings:Get("RealAimPart")) 
                   or target.Character and target.Character:FindFirstChild(Settings:Get("RealAimPart"))
    if not aimPart then return end
    local predictedPos = getPredictedPosition(aimPart)
    
    -- Get viewmodel's aim part (usually Item.Offsets.AimPart)
    local vm = Camera:FindFirstChild("ViewModel")
    if vm and vm:FindFirstChild("Item") and vm.Item:FindFirstChild("Offsets") then
        local aimPoint = vm.Item.Offsets:FindFirstChild("AimPart")
        if aimPoint then
            aimPoint.CFrame = CFrame.lookAt(aimPoint.Position, predictedPos)
        end
    end
    
    -- Auto shoot
    if Settings:Get("AutoShoot") and Settings:Get("AutoShootType") == "Regular" then
        -- Simulate mouse click
        if mouse1press and mouse1release then
            mouse1press()
            task.wait(0.01)
            mouse1release()
        end
    elseif Settings:Get("AutoShoot") and Settings:Get("AutoShootType") == "Instant" then
        -- Instant hit via remote (original logic)
        local now = tick()
        if now - lastInstantHitTime >= Settings:Get("InstantHitDelay") then
            lastInstantHitTime = now
            local randomSeed = math.random(-10000, 10000)
            local remote = ReplicatedStorage.Remotes.FireProjectile
            if remote then
                remote:InvokeServer(Vector3.new(lp.Character.HumanoidRootPart.CFrame.Position), randomSeed, now)
                task.spawn(function()
                    local inflict = ReplicatedStorage.Remotes.ProjectileInflict
                    if inflict then
                        inflict:FireServer(aimPart, aimPart.CFrame:ToObjectSpace(CFrame.new(aimPart.Position + Vector3.new(0,1,0)*0.01)), randomSeed, now)
                    end
                end)
            end
        end
    end
end

-- Lock aim (lerp camera)
local function lockAim(target)
    if not target then return end
    local aimPart = target:IsA("Model") and target:FindFirstChild(Settings:Get("RealAimPart")) 
                   or target.Character and target.Character:FindFirstChild(Settings:Get("RealAimPart"))
    if not aimPart then return end
    local predictedPos = getPredictedPosition(aimPart)
    local targetCF = CFrame.lookAt(Camera.CFrame.Position, predictedPos)
    local smooth = 1 / Settings:Get("AimbotSmoothness")
    Camera.CFrame = Camera.CFrame:Lerp(targetCF, smooth)
end

-- Resolver: detect desync / cheating
local function resolverCheck()
    if not Settings:Get("Resolver") then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= lp and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local lastPos = ReplicatedStorage.Players[player.Name].Status.UAC:GetAttribute("LastVerifiedPos")
                if lastPos then
                    local dist = (hrp.Position - lastPos).Magnitude
                    if not resolverCache[player.Name] then resolverCache[player.Name] = 1 end
                    if dist >= 10 then
                        resolverCache[player.Name] = resolverCache[player.Name] + 1
                        if resolverCache[player.Name] >= 250 then
                            Utils:Notify("Cheat Detector", "Player: " .. player.Name .. " suspected of cheating!", 5)
                            Settings.Current.Cheaters[player.Name] = true
                            hrp.CFrame = CFrame.new(lastPos)
                        elseif resolverCache[player.Name] > 250 then
                            hrp.CFrame = CFrame.new(lastPos)
                        end
                    elseif resolverCache[player.Name] > 0 then
                        resolverCache[player.Name] = resolverCache[player.Name] - 1
                    end
                end
            end
        end
    end
end

-- Update FOV circle
local function updateFOVCircle()
    if Settings:Get("FovVisible") and Settings:Get("MasterAimbot") then
        local circle = setupFOVCircle()
        local dynamic = Settings:Get("DynamicFov")
        if dynamic then
            local defaultFOV = 90
            local currentFOV = Camera.FieldOfView
            circle.Radius = Settings:Get("ActualAimbotFov") * defaultFOV / currentFOV
        else
            circle.Radius = Settings:Get("ActualAimbotFov")
        end
        circle.Visible = true
    elseif fovCircle then
        fovCircle.Visible = false
    end
end

-- Tracer line to target
local tracerLine = nil
local function updateTracer()
    if Settings:Get("AimbotTracer") and currentTarget then
        local aimPart = currentTarget:IsA("Model") and currentTarget:FindFirstChild("RealAimPart") 
                       or currentTarget.Character and currentTarget.Character:FindFirstChild("RealAimPart")
        if aimPart then
            local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
            if onScreen then
                if not tracerLine then
                    tracerLine = Drawing.new("Line")
                    tracerLine.Thickness = 2
                    tracerLine.Transparency = 1
                end
                tracerLine.Color = Settings:Get("AimbotTracerColor")
                tracerLine.From = Camera.ViewportSize / 2
                tracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
                tracerLine.Visible = true
                return
            end
        end
    end
    if tracerLine then tracerLine.Visible = false end
end

-- Main aimbot update (called every frame)
function Aimbot:Update(dt)
    if not Settings:Get("MasterAimbot") then return end
    
    -- Handle keybind state (set externally via InputBegan/Ended)
    if not aimbotActive then
        currentTarget = nil
        if tracerLine then tracerLine.Visible = false end
        return
    end
    
    -- Randomize hit part if needed
    randomizeHitPart()
    
    -- Target acquisition with sticky aim
    local now = tick()
    if Settings:Get("StickyAim") and currentTarget and isValidTarget(currentTarget) then
        -- keep current target
    else
        local newTarget = Aimbot:GetClosestTarget()
        if newTarget and (currentTarget ~= newTarget or now - lastTargetSwitchTime >= targetSwitchDelay) then
            currentTarget = newTarget
            lastTargetSwitchTime = now
        elseif not newTarget then
            currentTarget = nil
        end
    end
    
    -- Apply aim
    if currentTarget then
        if Settings:Get("SilentAimbot") then
            silentAim(currentTarget)
        else
            lockAim(currentTarget)
        end
    end
    
    -- Update visuals
    updateFOVCircle()
    updateTracer()
end

-- Resolver loop (runs every few seconds)
function Aimbot:ResolverLoop()
    while true do
        task.wait(5)
        resolverCheck()
    end
end

-- Keybind handling
function Aimbot:SetupKeybinds()
    local aimKey = Settings:Get("AimbotKey") or "MouseButton2"
    local keyEnum = (aimKey:find("Button") and Enum.UserInputType[aimKey]) or Enum.KeyCode[aimKey]
    if not keyEnum then return end
    
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == keyEnum or input.KeyCode == keyEnum then
            aimbotActive = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == keyEnum or input.KeyCode == keyEnum then
            aimbotActive = false
        end
    end)
end

-- Start aimbot system
function Aimbot:Start()
    self:SetupKeybinds()
    task.spawn(function() self:ResolverLoop() end)
    
    -- Get remote references for instant hit
    projectileRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("FireProjectile")
    inflictRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("ProjectileInflict")
    
    -- Update every render step
    RunService.RenderStepped:Connect(function(dt)
        self:Update(dt)
    end)
end

return Aimbot
