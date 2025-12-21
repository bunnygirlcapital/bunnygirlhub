-- Universal Loader for bunnygirlhub
-- Detects the current game via PlaceId and loads the corresponding script from GitHub

local placeId = tostring(game.PlaceId)
local url = "https://raw.githubusercontent.com/bunnygirlcapital/bunnygirlhub/refs/heads/main/" .. placeId .. ".lua"

print("Loading script for PlaceId: " .. placeId)

local success, err = pcall(function()
	loadstring(game:HttpGet(url))()
end)

if not success then
	warn("Failed to load script for PlaceId " .. placeId .. ": " .. err)
end
