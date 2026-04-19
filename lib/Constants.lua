-- Game-specific constants

local Constants = {}

Constants.HostilePatterns = {"Hostile", "TaskForce", "Enemy", "Sniper", "Gunner", "Boss"}
Constants.CivilianPatterns = {"Civilian", "Civillain", "Civ", "NPC"}

Constants.HitSounds = {
    Default = "rbxassetid://4585351098",
    Rust = "rbxassetid://1255040462",
    Gamesense = "rbxassetid://4817809188",
    -- ... etc.
}

Constants.ContainerWhitelist = {
    "MilitaryCrate", "SmallMilitaryBox", "Safe", "CashRegister", -- ...
}

return Constants
