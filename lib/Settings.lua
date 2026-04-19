-- Settings Manager - handles config saving/loading and default values

local Settings = {}

Settings.Defaults = {
    MasterESP = false,
    ShowBox = false,
    ShowName = false,
    ShowHealth = false,
    ShowDistance = false,
    ShowSkeleton = false,
    ShowChams = false,
    ChamsColor = Color3.fromRGB(255, 255, 255),
    -- Aimbot
    MasterAimbot = false,
    SilentAimbot = false,
    AimbotSmoothness = 1,
    AimbotFov = 100,
    -- Movement
    SpeedHack = false,
    SpeedHackSpeed = 17,
    NoClip = false,
    Fly = false,
    -- etc.
}

-- Current settings (will be merged with defaults)
Settings.Current = {}

-- Load from file
function Settings:Load()
    if isfile("LirpConfig.json") then
        local data = game:GetService("HttpService"):JSONDecode(readfile("LirpConfig.json"))
        for k, v in pairs(data) do
            self.Current[k] = v
        end
    end
    -- merge defaults
    for k, v in pairs(self.Defaults) do
        if self.Current[k] == nil then
            self.Current[k] = v
        end
    end
end

-- Save to file
function Settings:Save()
    local data = game:GetService("HttpService"):JSONEncode(self.Current)
    writefile("LirpConfig.json", data)
end

-- Get a setting
function Settings:Get(key)
    return self.Current[key]
end

-- Set a setting
function Settings:Set(key, value)
    self.Current[key] = value
    self:Save()
end

Settings:Load()
return Settings
