-- Movement Features: speed hack, fly, noclip, jump, third person

local Movement = {}
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Settings = require(script.Parent.Settings)

local flyConnection = nil
local noclipConnection = nil

-- Speed hack
function Movement:UpdateSpeed()
    local char = lp.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum and Settings:Get("SpeedHack") then
            hum.WalkSpeed = Settings:Get("SpeedHackSpeed")
        elseif hum then
            hum.WalkSpeed = 16
        end
    end
end

-- Fly
function Movement:ToggleFly(enabled)
    if enabled and not flyConnection then
        flyConnection = RunService.RenderStepped:Connect(function()
            local char = lp.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local move = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        move = move + Camera.CFrame.LookVector
                    end
                    -- ... handle other keys
                    hrp.Velocity = move * Settings:Get("FlySpeed")
                end
            end
        end)
    elseif not enabled and flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end

-- Noclip
function Movement:ToggleNoClip(enabled)
    if enabled and not noclipConnection then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = lp.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    elseif not enabled and noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
        -- restore collision (optional)
    end
end

-- Main loop
function Movement:Start()
    RunService.RenderStepped:Connect(function()
        self:UpdateSpeed()
        self:ToggleFly(Settings:Get("Fly"))
        self:ToggleNoClip(Settings:Get("NoClip"))
    end)
end

return Movement
