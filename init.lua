-- Lirp | Project Delta - Main Entry
-- Loads all modules and initializes the cheat

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- Load required modules
local Settings = require(script.lib.Settings)
local Utils = require(script.lib.Utils)
local ESP = require(script.lib.ESP)
local Aimbot = require(script.lib.Aimbot)
local Movement = require(script.lib.Movement)
local AntiCheat = require(script.lib.AntiCheat)
local Features = require(script.lib.Features)
local UI = require(script.lib.UI)

-- Global settings reference
_G.LirpSettings = Settings

-- Initialize subsystems
Utils:Notify("Lirp 1/5", "Main Script Is Loading...", 5)

-- Wait for game to load
task.wait(2)

-- Start ESP
ESP:Start()

-- Start Aimbot
Aimbot:Start()

-- Start Movement loop
Movement:Start()

-- Start AntiCheat loop
AntiCheat:Start()

-- Start Features (item finder, inventory checker, etc.)
Features:Start()

-- Create UI
UI:Create()

Utils:Notify("Lirp 5/5", "Cheat Has Been Loaded Successfully.", 2.5)
