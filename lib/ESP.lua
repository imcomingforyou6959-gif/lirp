-- ESP System - Handles all drawing (players, NPCs, containers, items, exits)

local ESP = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer
local Settings = require(script.Parent.Settings)
local Utils = require(script.Parent.Utils)

local espData = {}      -- stores drawing objects per entity
local lastUpdate = 0
local UPDATE_INTERVAL = 0.05

-- Create drawing objects for a player
function ESP:CreatePlayerDrawings(player)
    local drawings = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Line"),
        Distance = Drawing.new("Text"),
        -- etc.
    }
    drawings.Box.Thickness = 1
    drawings.Box.Filled = false
    drawings.Name.Size = 12
    drawings.Name.Center = true
    drawings.Name.Outline = true
    -- ... configure other drawings
    espData[player] = drawings
end

-- Update ESP for all entities
function ESP:Update()
    if not Settings:Get("MasterESP") then return end
    
    local myPos = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= lp and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - myPos.Position).Magnitude
                if dist <= Settings:Get("MaxDistance") then
                    -- Get screen position and draw box
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        -- calculate box size, draw
                        -- ... (original box drawing logic)
                    end
                end
            end
        end
    end
    -- Also handle NPCs, containers, etc.
end

-- Start ESP loop
function ESP:Start()
    RunService.RenderStepped:Connect(function()
        local now = tick()
        if now - lastUpdate >= UPDATE_INTERVAL then
            lastUpdate = now
            self:Update()
        end
    end)
end

return ESP
