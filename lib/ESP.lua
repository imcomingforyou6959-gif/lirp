-- lib/ESP.lua
-- Complete ESP system (players, NPCs, containers, exits, quests, vehicles, dropped items, corpses)
-- Based on original obfuscated script's ESP logic (r25_0, r6_0, r7_0, etc.)

local ESP = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer
local Settings = require(script.Parent.Settings)
local Utils = require(script.Parent.Utils)
local Constants = require(script.Parent.Constants)

-- Internal drawing storage
local espDrawings = {}      -- entity -> drawing objects
local lastUpdate = 0
local UPDATE_INTERVAL = 0.05

-- BillboardGui template for text ESP
local billboardGui = nil
local function getBillboardTemplate()
    if not billboardGui then
        billboardGui = Instance.new("BillboardGui")
        billboardGui.ResetOnSpawn = false
        billboardGui.AlwaysOnTop = true
        billboardGui.LightInfluence = 0
        billboardGui.Size = UDim2.new(1.75, 0, 1.75, 0)
        local label = Instance.new("TextLabel", billboardGui)
        label.BackgroundColor3 = Color3.fromRGB(255,255,255)
        label.Text = ""
        label.Size = UDim2.new(0.0001,0.0001,0.0001,0.0001)
        label.BorderSizePixel = 0
        label.Font = "GothamSemibold"
        label.TextSize = 0
    end
    return billboardGui:Clone()
end

-- Highlight template for chams / highlights
local highlightTemplate = nil
local function getHighlightTemplate()
    if not highlightTemplate then
        highlightTemplate = Instance.new("Highlight")
        highlightTemplate.Name = "Sigma"
    end
    return highlightTemplate:Clone()
end

-- ============================================================================
-- Helper: Get entity color based on type (hostile, civilian, teammate, etc.)
-- ============================================================================
local function getEntityColor(model)
    if Settings:Get("TeammateESP") then
        local plr = Players:GetPlayerFromCharacter(model)
        if plr and plr ~= lp then
            return Settings:Get("TeammateColor")
        end
    end
    if Settings:Get("CivilianESP") then
        for _, pattern in ipairs(Constants.CivilianPatterns) do
            if string.find(model.Name, pattern) then
                return Settings:Get("CivilianColor")
            end
        end
    end
    if Settings:Get("HostileESP") then
        for _, pattern in ipairs(Constants.HostilePatterns) do
            if string.find(model.Name, pattern) then
                -- Specific types override
                if Settings:Get("SniperESP") and string.find(model.Name, "Sniper") then
                    return Settings:Get("SniperColor")
                end
                if Settings:Get("GunnerESP") and string.find(model.Name, "Gunner") then
                    return Settings:Get("GunnerColor")
                end
                if Settings:Get("BossESP") and string.find(model.Name, "Boss") then
                    return Settings:Get("BossColor")
                end
                return Settings:Get("HostileColor")
            end
        end
    end
    return nil
end

-- ============================================================================
-- R6 Box calculation (compact, tight)
-- ============================================================================
local function getBoxPoints(model)
    local head = model:FindFirstChild("Head")
    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
    if not head or not hrp then return nil end
    local headPos, headVis = Camera:WorldToViewportPoint(head.Position)
    local footPos, footVis = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 2, 0))
    if not headVis or not footVis then return nil end
    local height = math.abs(headPos.Y - footPos.Y)
    local width = height * 0.4
    local pos = Vector2.new(headPos.X - width/2, headPos.Y)
    return pos, width, height
end

-- ============================================================================
-- Drawing object management
-- ============================================================================
local function ensureDrawings(entity, isHighlight)
    if not espDrawings[entity] then espDrawings[entity] = {} end
    local d = espDrawings[entity]
    if isHighlight then
        if not d.highlight then
            d.highlight = getHighlightTemplate()
        end
        return d.highlight
    else
        if not d.box2d then
            d.box2d = Drawing.new("Square")
            d.box2d.Thickness = 1
            d.box2d.Filled = false
        end
        if not d.text then
            d.text = Drawing.new("Text")
            d.text.Size = 12
            d.text.Center = true
            d.text.Outline = true
            d.text.Font = 2
        end
        if not d.health then
            d.health = Drawing.new("Line")
            d.health.Thickness = 3
        end
        -- Add other drawing types as needed (tracer, skeleton, etc.)
        return d
    end
end

local function cleanupEntity(entity)
    local data = espDrawings[entity]
    if not data then return end
    if data.highlight then data.highlight:Destroy() end
    if data.box2d then data.box2d:Remove() end
    if data.text then data.text:Remove() end
    if data.health then data.health:Remove() end
    -- cleanup any other drawings
    espDrawings[entity] = nil
end

-- ============================================================================
-- Player / NPC ESP (box, name, health, distance, skeleton, chams)
-- ============================================================================
local function updatePlayerESP()
    if not Settings:Get("MasterESP") then return end
    local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    
    for _, model in ipairs(Workspace:GetChildren()) do
        if not model:IsA("Model") then continue end
        local color = getEntityColor(model)
        if not color then
            if espDrawings[model] then cleanupEntity(model) end
            continue
        end
        
        -- Distance culling
        local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
        if myRoot and hrp and (hrp.Position - myRoot.Position).Magnitude > Settings:Get("MaxDistance") then
            if espDrawings[model] then
                for _,v in pairs(espDrawings[model]) do
                    if type(v) == "userdata" and v.Visible ~= nil then v.Visible = false end
                end
            end
            continue
        end
        
        -- Use Highlight mode or Box mode
        if Settings:Get("ESPMode") == "Highlight" then
            local highlight = ensureDrawings(model, true)
            highlight.Adornee = model
            highlight.FillColor = color
            highlight.OutlineColor = color
            highlight.FillTransparency = Settings:Get("ESPFillTrans")
            highlight.Parent = model
        else
            -- Remove highlight if exists
            if espDrawings[model] and espDrawings[model].highlight then
                espDrawings[model].highlight:Destroy()
                espDrawings[model].highlight = nil
            end
            
            local pos, width, height = getBoxPoints(model)
            if pos then
                local drawings = ensureDrawings(model, false)
                
                -- Box (2D)
                if Settings:Get("ShowBox") then
                    drawings.box2d.Color = color
                    drawings.box2d.Size = Vector2.new(width, height)
                    drawings.box2d.Position = pos
                    drawings.box2d.Visible = true
                else
                    drawings.box2d.Visible = false
                end
                
                -- Health bar
                if Settings:Get("ShowHealth") then
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    local percent = hum and hum.Health / hum.MaxHealth or 1
                    local barX = pos.X - 5
                    local barY = pos.Y + height - (height * percent)
                    drawings.health.From = Vector2.new(barX, pos.Y + height)
                    drawings.health.To = Vector2.new(barX, barY)
                    drawings.health.Color = color
                    drawings.health.Visible = true
                else
                    drawings.health.Visible = false
                end
                
                -- Name and distance
                if Settings:Get("ShowName") or Settings:Get("ShowDistance") then
                    local name = model.Name
                    local pl = Players:GetPlayerFromCharacter(model)
                    if pl then name = pl.Name end
                    local dist = myRoot and hrp and (myRoot.Position - hrp.Position).Magnitude or 0
                    local str = (Settings:Get("ShowName") and name or "") ..
                                (Settings:Get("ShowDistance") and (" ["..math.floor(dist).."s]") or "")
                    drawings.text.Text = str
                    drawings.text.Color = Settings:Get("NameColor")
                    drawings.text.Position = Vector2.new(pos.X + width/2, pos.Y - 12)
                    drawings.text.Visible = true
                else
                    drawings.text.Visible = false
                end
            else
                -- Off-screen: hide drawings
                if espDrawings[model] then
                    for _,v in pairs(espDrawings[model]) do
                        if type(v) == "userdata" and v.Visible ~= nil then v.Visible = false end
                    end
                end
            end
        end
        
        -- Chams
        if Settings:Get("ShowChams") then
            local cham = ensureDrawings(model, true) -- reuse highlight for chams
            cham.Adornee = model
            cham.FillColor = Settings:Get("ChamsColor")
            cham.OutlineColor = Settings:Get("ChamsColor")
            cham.FillTransparency = Settings:Get("ChamsTransparency")
            cham.DepthMode = Settings:Get("VisibleChams") and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
            cham.Parent = model
        elseif espDrawings[model] and espDrawings[model].highlight then
            espDrawings[model].highlight:Destroy()
            espDrawings[model].highlight = nil
        end
    end
end

-- ============================================================================
-- Billboard ESP for items, containers, exits, corpses, vehicles, quests
-- ============================================================================
local function updateBillboardESP()
    -- Dropped items
    if Settings:Get("DroppedItemESP") then
        for _, item in ipairs(Workspace.DroppedItems:GetChildren()) do
            if not item:FindFirstChild("Humanoid") and not item:FindFirstChild("BillboardGui") then
                local bg = getBillboardTemplate()
                local label = bg:FindFirstChildOfClass("TextLabel")
                local amount = item:FindFirstChild("ItemProperties") and item.ItemProperties:GetAttribute("Amount") or 1
                label.Text = item.Name .. " " .. amount .. "X | Item"
                label.TextColor3 = Settings:Get("DroppedItemColor")
                label.TextSize = Settings:Get("DroppedItemTextSize")
                bg.Parent = item
            end
        end
    end
    
    -- Corpses
    if Settings:Get("CorpseESP") then
        for _, corpse in ipairs(Workspace.DroppedItems:GetChildren()) do
            if corpse:FindFirstChild("Humanoid") and not corpse:FindFirstChild("BillboardGui") then
                local bg = getBillboardTemplate()
                local label = bg:FindFirstChildOfClass("TextLabel")
                label.Text = corpse.Name .. " | Corpse"
                if corpse.Name == lp.Name then
                    label.TextColor3 = Color3.fromRGB(255,102,0)
                else
                    label.TextColor3 = Settings:Get("CorpseColor")
                end
                label.TextSize = Settings:Get("CorpseTextSize")
                bg.Parent = corpse
            elseif not corpse:FindFirstChild("Humanoid") and corpse:FindFirstChild("BillboardGui") then
                corpse:FindFirstChild("BillboardGui"):Destroy()
            end
        end
    end
    
    -- Containers
    if Settings:Get("ContainerESP") then
        for _, container in ipairs(Workspace.Containers:GetDescendants()) do
            if container:IsA("BasePart") and Constants.ContainerWhitelist[container.Name] and not container:FindFirstChild("BillboardGui") then
                local bg = getBillboardTemplate()
                local label = bg:FindFirstChildOfClass("TextLabel")
                label.Text = container.Name .. " | Container"
                label.TextColor3 = Settings:Get("ContainerColor")
                label.TextSize = Settings:Get("ContainerTextSize")
                bg.Parent = container
            end
        end
    end
    
    -- Exit locations
    if Settings:Get("ExitESP") then
        for _, exit in ipairs(Workspace.NoCollision.ExitLocations:GetChildren()) do
            if not exit:FindFirstChild("BillboardGui") then
                local bg = getBillboardTemplate()
                local label = bg:FindFirstChildOfClass("TextLabel")
                label.Text = exit.Name .. " | Extract"
                label.TextColor3 = Settings:Get("ExitColor")
                label.TextSize = Settings:Get("ExitTextSize")
                bg.Parent = exit
            end
        end
    end
    
    -- Quest items
    if Settings:Get("QuestESP") and Workspace:FindFirstChild("QuestItems") then
        for _, questItem in ipairs(Workspace.QuestItems:GetChildren()) do
            if not questItem:FindFirstChild("BillboardGui") and not questItem:GetAttribute("Hidden") then
                local bg = getBillboardTemplate()
                local label = bg:FindFirstChildOfClass("TextLabel")
                label.Text = questItem.Name .. " | Quest"
                label.TextColor3 = Settings:Get("QuestESPColor")
                label.TextSize = Settings:Get("QuestTextSize")
                bg.Parent = questItem
            end
        end
    end
    
    -- Vehicles
    if Settings:Get("VehicleTag") then
        for _, vehicle in ipairs(Workspace.Vehicles:GetChildren()) do
            if not vehicle:FindFirstChild("BillboardGui") then
                local bg = getBillboardTemplate()
                local label = bg:FindFirstChildOfClass("TextLabel")
                label.Text = vehicle.Name .. " | Vehicle"
                label.TextColor3 = Settings:Get("VehicleColor")
                label.TextSize = Settings:Get("VehicleTextSize")
                bg.Parent = vehicle
            end
        end
    end
end

-- ============================================================================
-- Cleanup orphaned billboards
-- ============================================================================
local function cleanupBillboards()
    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant:IsA("BillboardGui") and descendant.Name ~= "HellmetESP" then
            local parent = descendant.Parent
            if not parent or not parent.Parent then
                descendant:Destroy()
            end
        end
    end
end

-- ============================================================================
-- Main ESP update (throttled)
-- ============================================================================
local function fullUpdate()
    updatePlayerESP()
    updateBillboardESP()
    cleanupBillboards()
end

-- ============================================================================
-- Start ESP system
-- ============================================================================
function ESP:Start()
    RunService.RenderStepped:Connect(function()
        local now = tick()
        if now - lastUpdate >= UPDATE_INTERVAL then
            lastUpdate = now
            pcall(fullUpdate)
        end
    end)
end

return ESP
