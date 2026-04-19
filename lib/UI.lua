-- UI Creation using WindUI (or custom)

local UI = {}
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Settings = require(script.Parent.Settings)

function UI:Create()
    local Window = WindUI:CreateWindow({
        Title = "Lirp | Project Delta",
        Folder = "Lirp",
        Icon = "solar:skull-bold",
        HideSearchBar = true,
        OpenButton = { Title = "Lirp", Enabled = true, Draggable = true, Scale = 0.6 },
    })
    
    local CombatTab = Window:Tab({ Title = "Combat", Icon = "solar:sword-bold" })
    local CombatGroup = CombatTab:Group({ Title = "Aimbot" })
    
    CombatGroup:Toggle({
        Title = "Enable Aimbot",
        Value = Settings:Get("MasterAimbot"),
        Callback = function(v) Settings:Set("MasterAimbot", v) end
    })
    CombatGroup:Toggle({
        Title = "Silent Aim",
        Value = Settings:Get("SilentAimbot"),
        Callback = function(v) Settings:Set("SilentAimbot", v) end
    })
    -- ... add all other toggles, sliders, dropdowns
    
    local ESPTab = Window:Tab({ Title = "ESP", Icon = "solar:eye-bold" })
    local ESPGroup = ESPTab:Group({ Title = "General" })
    ESPGroup:Toggle({
        Title = "Master ESP",
        Value = Settings:Get("MasterESP"),
        Callback = function(v) Settings:Set("MasterESP", v) end
    })
    -- ... etc.
end

return UI
