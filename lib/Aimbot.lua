-- Aimbot System - Silent aim, lock aim, prediction, resolver

local Aimbot = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer
local Settings = require(script.Parent.Settings)
local Utils = require(script.Parent.Utils)

local aimbotActive = false
local currentTarget = nil

-- Find closest target within FOV
function Aimbot:GetClosestTarget()
    local closest = nil
    local closestDist = Settings:Get("AimbotFov")
    local screenCenter = Camera.ViewportSize / 2
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= lp and player.Character then
            local targetPart = player.Character:FindFirstChild(Settings:Get("AimPart"))
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

-- Apply aim (silent or lock)
function Aimbot:Apply()
    if not Settings:Get("MasterAimbot") then return end
    if not aimbotActive then return end
    
    local target = self:GetClosestTarget()
    if target then
        currentTarget = target
        local targetPart = target.Character:FindFirstChild(Settings:Get("AimPart"))
        if targetPart then
            if Settings:Get("SilentAimbot") then
                -- silent aim logic (manipulate viewmodel or fire remote)
                -- ...
            else
                -- lock aim (lerp camera)
                local targetCF = CFrame.lookAt(Camera.CFrame.Position, targetPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCF, 1 / Settings:Get("AimbotSmoothness"))
            end
        end
    end
end

-- Keybind handling
function Aimbot:Start()
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode[Settings:Get("AimbotKey")] then
            aimbotActive = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode[Settings:Get("AimbotKey")] then
            aimbotActive = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        self:Apply()
    end)
end

return Aimbot
