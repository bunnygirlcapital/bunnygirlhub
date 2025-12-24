--[[
    @author 0xfinder (0xfinder)
    @description BAZ script
    https://www.roblox.com/games/105555311806207
]]
local VERSION = "1.0.0"

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua")
)()

--// Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local VirtualUser = cloneref(game:GetService("VirtualUser"))
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local PlaceId = game.PlaceId
local JobId = game.JobId

--// Folders
local AssignedIslandName = LocalPlayer:GetAttribute("AssignedIslandName")
local Eggs = ReplicatedStorage.Eggs
local Pets = Workspace.Pets
local Art = Workspace.Art
local Data = PlayerGui:WaitForChild("Data")
local FoodStore = Data:WaitForChild("FoodStore")
local Egg = Data:WaitForChild("Egg")
local Remote = ReplicatedStorage.Remote

local Config = ReplicatedStorage.Config
local ResPet = require(Config.ResPet)
local ResPetFood = require(Config.ResPetFood)
local ResMutate = require(Config.ResMutate)

-- Load required modules
Shared = require(ReplicatedStorage:WaitForChild("Shared", 10))
Pet = Shared("Pet")
Format = Shared("Format")

--// Remotes
local CharacterRE = Remote.CharacterRE
local TradeZoneRE = Remote.TradeZoneRE
local TradeRE = Remote.TradeRE
local RedemptionCodeRE = Remote.RedemptionCodeRE
local LotteryRE = Remote.LotteryRE
local GiftRE = Remote.GiftRE
local DeployRE = Remote.DeployRE

--// Mutations from Config.MutateEnum
--//  "Golden", "Diamond", "Electirc", "Fire",
local mutationValues = { "Dino", "Snow", "Halloween", "Thanksgiving", "Christmas" } -- All available mutations

local function getMutationIndex(mutation)
	for i, m in ipairs(mutationValues) do
		if m:lower() == mutation:lower() then
			return i
		end
	end
	return 0
end

--// Lottery codes
local lotteryCodes = {
	"N7A68Q82H83",
	"4XW5RG4CHRY",
	"DelayGift",
	"60KCCU919",
	"FIXERROR819",
	"3XKK8Z2WB6G",
	"Halloween1018",
	"subtoZRGZeRoGhost",
	"NA5Y874BAGG",
	"Nyaa",
	"ADQZP3MBW6N",
	"ZTWPH3WW8SJ",
	"9HDARHCQMWS",
	"A38JBJ3TSSE",
	"E5GSDBK7ATX",
	"9WC77XXCM5A",
	"LandCompensation",
	"9WC77XXCM5A",
	"E5GSDBK7ATX",
	"BLACKFRIDAY",
	"ZooFarmers",
	"FRIDAYGIFT5",
	"XMASADVENT5",
	"ACORN251204",
	"ADMINABUSE1",
	"FIXTHEBUGS1",
	"CHRISTMAS12",
}

--// Embed setting
local EmbedSettings = {
	Color = 8388736, -- Purple (#800080)
	Author = {
		Name = LocalPlayer.Name,
		Icon = "https://i.pinimg.com/1200x/37/6f/7b/376f7b3b727c3848842a864693b697bb.jpg",
	},
}

local Window = Fluent:CreateWindow({
	Title = "Bunny Girl Hub | Version " .. VERSION,
	SubTitle = "by finder",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	-- Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
	Transparency = true,
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl, -- Used when theres no MinimizeKeybind
})

--// Draggable Minimized Icon
do
	local iconGui = Instance.new("ScreenGui")
	iconGui.Name = "BunnyGirlHubIcon"
	iconGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	iconGui.ResetOnSpawn = false
	iconGui.Enabled = true -- Make sure it's enabled
	iconGui.Parent = PlayerGui

	local iconFrame = Instance.new("ImageButton")
	iconFrame.Name = "Icon"
	iconFrame.Size = UDim2.new(0, 50, 0, 50)
	iconFrame.Position = UDim2.new(0, 20, 0, 20)
	iconFrame.BackgroundColor3 = Color3.fromRGB(128, 0, 128) -- Purple (#800080), same as embed color
	iconFrame.BackgroundTransparency = 0
	iconFrame.BorderSizePixel = 0
	iconFrame.Parent = iconGui
	iconFrame.Visible = false -- Hidden by default, shown when minimized
	iconFrame.ZIndex = -1

	local iconCorner = Instance.new("UICorner")
	iconCorner.CornerRadius = UDim.new(0, 12)
	iconCorner.Parent = iconFrame

	-- Use ImageLabel inside ImageButton for better image display
	local iconImage = Instance.new("ImageLabel")
	iconImage.Name = "IconImage"
	iconImage.Size = UDim2.new(1, -6, 1, -6)
	iconImage.Position = UDim2.new(0, 3, 0, 3)
	iconImage.BackgroundTransparency = 1
	iconImage.BorderSizePixel = 0
	iconImage.Image = "rbxassetid://82292792267705"
	iconImage.ImageTransparency = 0
	iconImage.ZIndex = 1
	iconImage.Visible = true
	iconImage.Parent = iconFrame

	local imageCorner = Instance.new("UICorner")
	imageCorner.CornerRadius = UDim.new(0, 8)
	imageCorner.Parent = iconImage

	-- Make icon draggable
	local dragging = false
	local dragStartPos = nil
	local frameStartPos = nil

	iconFrame.InputBegan:Connect(function(input)
		if Fluent.Unloaded then
			return
		end
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragging = true
			dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
			frameStartPos = iconFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if Fluent.Unloaded then
			return
		end
		if
			dragging
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
			iconFrame.Position = UDim2.new(
				frameStartPos.X.Scale,
				frameStartPos.X.Offset + delta.X,
				frameStartPos.Y.Scale,
				frameStartPos.Y.Offset + delta.Y
			)
		end
	end)

	-- Click to restore window
	iconFrame.MouseButton1Click:Connect(function()
		if Fluent.Unloaded then
			return
		end
		if Window and Window.Minimized then
			Window:Minimize()
		end
	end)

	-- Monitor window minimized state and update icon visibility
	task.spawn(function()
		while not Fluent.Unloaded do
			task.wait(0.1)
			if Window then
				iconFrame.Visible = Window.Minimized
			end
		end
		iconGui:Destroy()
	end)
end

--// Check if the script is already running
-- if _G.BuildAZoo then
-- 	return
-- end
-- _G.BuildAZoo = true

--// Tabs
local Tabs = {
	Main = Window:AddTab({ Title = "Main", Icon = "home" }),
	Eggs = Window:AddTab({ Title = "Eggs", Icon = "egg" }),
	Food = Window:AddTab({ Title = "Food", Icon = "utensils" }),
	Lottery = Window:AddTab({ Title = "Lottery", Icon = "ticket" }),
	Trade = Window:AddTab({ Title = "Trade", Icon = "repeat" }),
	Pets = Window:AddTab({ Title = "Pets", Icon = "heart" }),
	Gift = Window:AddTab({ Title = "Gift", Icon = "gift" }),
	Webhook = Window:AddTab({ Title = "Webhook", Icon = "send" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

--// Options
local Options = Fluent.Options

--// General section
local GeneralSection = Tabs.Main:AddSection("General")

local AntiAFK = GeneralSection:AddToggle("AntiAFK", {
	Title = "Anti-AFK",
	Description = "Prevents being kicked for inactivity",
	Default = true,
})

local AutoReconnect = GeneralSection:AddToggle("AutoReconnect", {
	Title = "Auto-Reconnect",
	Description = "Automatically reconnect on disconnect",
	Default = true,
})

local RenderingEnabled = GeneralSection:AddToggle("RenderingEnabled", {
	Title = "Rendering Enabled",
	Description = "Enable 3D rendering (disable for performance)",
	Default = true,
})

local AutoLike = GeneralSection:AddToggle("AutoLike", {
	Title = "Auto Like",
	Description = "Automatically give likes to all players every 5 minutes",
	Default = true,
})

--// TAB: Eggs
do
	-- Egg buyer state
	local eggBuyerState = {
		isRunning = false,
		connections = {},
		eggData = {
			purchasedEggs = {},
			detectedEggs = {},
			conveyorEggs = {},
			lastEggId = nil,
			lastScanTime = 0,
		},
	}

	local Section = Tabs.Eggs:AddSection("Auto Buy Egg")

	-- Select Mutations: multi dropdown
	local SelectMutations = Section:AddDropdown("SelectMutations", {
		Title = "Select Mutations",
		Values = mutationValues,
		Multi = true,
		Default = { "Dino", "Snow", "Halloween" },
	})

	-- Select Eggs: multi dropdown
	local SelectEggs = Section:AddDropdown("SelectEggs", {
		Title = "Select Eggs",
		Values = {
			"GodzillaEgg",
			"MetroGiraffeEgg",
			"BiteForceSharkEgg",
			"GreenStormEgg",
			"DrakespineEgg",
			"RedPandaEgg",
			"SwanEgg",
			"SpaceMouseEgg",
			"NanoRamEgg",
		},
		Multi = true,
		Default = { "GodzillaEgg" },
	})

	-- Auto Buy Egg: toggle
	local AutoBuyEgg = Section:AddToggle("AutoBuyEgg", {
		Title = "Auto Buy Egg",
		Default = false,
	})

	-- Egg detection function - ONLY scans player's island
	local function findEggsInReplicatedStorage()
		local eggs = {}

		for _, egg in pairs(Eggs[AssignedIslandName]:GetChildren()) do
			local uid = egg:GetAttribute("UID")
			local mutation = egg:GetAttribute("M")
			local eggType = egg:GetAttribute("T")

			if uid or egg.Name:match("^[a-f0-9]+$") then
				table.insert(eggs, {
					id = uid or egg.Name,
					name = tostring(eggType or egg.Name),
					mutation = tostring(mutation or "None"),
					island = AssignedIslandName,
					object = egg,
				})
			end
		end

		return eggs
	end

	-- Purchase function
	local function attemptPurchaseEgg(egg)
		local success, error = pcall(function()
			CharacterRE:FireServer("BuyEgg", egg.id)
		end)

		if success then
			table.insert(eggBuyerState.eggData.purchasedEggs, {
				id = egg.id,
				name = egg.name,
				mutation = egg.mutation,
				timestamp = os.time(),
				timeString = os.date("%H:%M:%S"),
			})
			return true
		else
			return false
		end
	end

	-- Set up streaming for player's island ONLY
	local function setupPlayerIslandStreaming(islandFolder)
		-- Listen for new eggs being added to this island
		local eggConnection = islandFolder.ChildAdded:Connect(function(egg)
			if Fluent.Unloaded then
				return
			end

			local uid = egg:GetAttribute("UID")
			local mutation = egg:GetAttribute("M")
			local eggType = egg:GetAttribute("T")

			if uid or egg.Name:match("^[a-f0-9]+$") then
				local eggInfo = {
					id = uid or egg.Name,
					name = tostring(eggType or egg.Name),
					mutation = tostring(mutation or "None"),
					island = islandFolder.Name,
					object = egg,
				}

				table.insert(eggBuyerState.eggData.conveyorEggs, eggInfo)

				-- Auto-purchase if enabled and egg matches filters
				if Options.AutoBuyEgg.Value then
					local selectedEggs = {}
					local selectedMutations = {}

					for egg, state in next, Options.SelectEggs.Value do
						if state then
							table.insert(selectedEggs, egg)
						end
					end

					for mutation, state in next, Options.SelectMutations.Value do
						if state then
							table.insert(selectedMutations, mutation)
						end
					end

					local eggMatches = false
					local mutationMatches = false

					for _, selectedEgg in pairs(selectedEggs) do
						if tostring(eggInfo.name):lower() == tostring(selectedEgg):lower() then
							eggMatches = true
							break
						end
					end

					for _, selectedMutation in pairs(selectedMutations) do
						if tostring(eggInfo.mutation):lower() == tostring(selectedMutation):lower() then
							mutationMatches = true
							break
						end
					end

					if eggMatches and mutationMatches then
						attemptPurchaseEgg(eggInfo)
					end
				end
			end
		end)

		table.insert(eggBuyerState.connections, eggConnection)

		-- Listen for eggs being removed
		local eggRemovedConnection = islandFolder.ChildRemoved:Connect(function(egg)
			if Fluent.Unloaded then
				return
			end

			for i, eggInfo in pairs(eggBuyerState.eggData.conveyorEggs) do
				if eggInfo.object == egg then
					table.remove(eggBuyerState.eggData.conveyorEggs, i)
					break
				end
			end
		end)

		table.insert(eggBuyerState.connections, eggRemovedConnection)
	end

	-- Efficient event-based egg streaming - ONLY for player's island
	local function startEggMonitoring()
		if eggBuyerState.isRunning then
			return
		end

		eggBuyerState.isRunning = true

		-- Find and set up streaming ONLY for player's island folder
		local playerIslandFolder = Eggs[AssignedIslandName]
		if playerIslandFolder then
			setupPlayerIslandStreaming(playerIslandFolder)
		else
			-- Try to wait for it or check periodically
			local attempts = 0
			task.spawn(function()
				while not playerIslandFolder and attempts < 50 and not Fluent.Unloaded do
					task.wait(0.5)
					playerIslandFolder = Eggs[AssignedIslandName]
					attempts = attempts + 1
				end
				setupPlayerIslandStreaming(playerIslandFolder)
			end)
		end
		local islandConnection = Eggs[AssignedIslandName].ChildAdded:Connect(function(islandFolder)
			if Fluent.Unloaded then
				return
			end
			setupPlayerIslandStreaming(Eggs[AssignedIslandName])
		end)

		table.insert(eggBuyerState.connections, islandConnection)

		-- Initial scan
		eggBuyerState.eggData.conveyorEggs = findEggsInReplicatedStorage()
	end

	-- Stop monitoring function
	local function stopEggMonitoring()
		if not eggBuyerState.isRunning then
			return
		end

		eggBuyerState.isRunning = false

		for _, connection in pairs(eggBuyerState.connections) do
			if connection then
				connection:Disconnect()
			end
		end
		eggBuyerState.connections = {}
	end

	-- Connect auto buy toggle
	AutoBuyEgg:OnChanged(function(Value)
		if Value then
			startEggMonitoring()
		else
			stopEggMonitoring()
		end
	end)

	-- Cleanup when Fluent is unloaded
	task.spawn(function()
		while not Fluent.Unloaded do
			task.wait(0.1)
		end
		-- Fluent was closed, clean up all connections
		stopEggMonitoring()
	end)
end

--// TAB: Food
do
	-- Load foods from ResPetFood (already loaded at top of script)
	local foods = ResPetFood

	-- Extract food names from foods
	local foodNames = {}
	for foodName, foodData in pairs(foods) do
		if type(foodData) == "table" and foodData.ID then
			table.insert(foodNames, foodName)
		end
	end

	-- Food buyer state
	local foodBuyerState = {
		purchasedFoods = {},
		loopTask = nil, -- Track the running loop task
		foodStoreConnection = nil, -- Track the FoodStore attribute listener
	}

	-- Function to buy selected foods when store refreshes (defined after helper functions)
	local buySelectedFoods

	-- Setup FoodStore attribute listener
	local function setupFoodStoreListener()
		-- Listen for V attribute changes (store refresh)
		foodBuyerState.foodStoreConnection = FoodStore:GetAttributeChangedSignal("V"):Connect(function()
			-- local newValue = FoodStore:GetAttribute("V")
			buySelectedFoods()
		end)

		-- Also buy immediately if auto-buy is already enabled
		if Options.AutoBuyFood.Value then
			task.wait(0.5) -- Small delay to ensure everything is ready
			buySelectedFoods()
		end
	end

	-- Purchase food function
	local function attemptPurchaseFood(foodName, quantity)
		local foodStoreRE = Remote.FoodStoreRE
		for i = 1, quantity do
			foodStoreRE:FireServer(foodName)

			if i < quantity then
				task.wait(0.1)
			end
		end

		return false
	end

	-- Helper function to get selected foods from multi-dropdown
	local function getSelectedFoods()
		local selectedFoods = {}

		if not Options.SelectFood then
			warn("❌ Options.SelectFood is nil!")
			return selectedFoods
		end

		local foodValue = Options.SelectFood.Value

		if foodValue then
			if type(foodValue) == "table" then
				for foodName, isSelected in pairs(foodValue) do
					if isSelected then
						-- Verify food exists in foods; otherwise trust the selection
						if foods[foodName] then
							table.insert(selectedFoods, foodName)
						end
					end
				end
			else
				-- Handle case where it might be a string (single selection fallback)
				if foods[tostring(foodValue)] then
					table.insert(selectedFoods, tostring(foodValue))
				end
			end
		end
		return selectedFoods
	end

	-- Define buySelectedFoods function after helper functions are available
	buySelectedFoods = function()
		if not Options.AutoBuyFood.Value then
			return -- Auto-buy is disabled
		end

		local selectedFoods = getSelectedFoods()
		if #selectedFoods == 0 then
			return -- No foods selected
		end

		for _, foodName in pairs(selectedFoods) do
			if foods[foodName] then
				local foodData = foods[foodName]
				local quantity = foodData.SellStock2 or 1
				attemptPurchaseFood(foodName, quantity)
			end
		end
	end

	-- Setup FoodStore listener when auto-buy is enabled
	local function startAutoBuyLoop()
		-- Setup listener if not already done
		if not foodBuyerState.foodStoreConnection then
			setupFoodStoreListener()
		end

		-- Buy immediately when toggled on
		task.spawn(function()
			task.wait(0.5) -- Small delay
			buySelectedFoods()
		end)
	end

	-- Stop auto buy function
	local function stopAutoBuyLoop()
		if foodBuyerState.foodStoreConnection then
			foodBuyerState.foodStoreConnection:Disconnect()
			foodBuyerState.foodStoreConnection = nil
		end
	end

	local FoodSection = Tabs.Food:AddSection("Auto Buy Food")
	local SelectFood = FoodSection:AddDropdown("SelectFood", {
		Title = "Select Food",
		Values = foodNames,
		Multi = true,
		Default = {
			"Pear",
			"Pineapple",
			"DragonFruit",
			"GoldMango",
			"BloodstoneCycad",
			"ColossalPinecone",
			"VoltGinkgo",
			"DeepseaPearlFruit",
			"CandyCorn",
			"Durian",
			"Pumpkin",
			"FrankenKiwi",
			"Acorn",
			"Cranberry",
		},
	})

	-- Auto Buy Food: toggle
	local AutoBuyFood = FoodSection:AddToggle("AutoBuyFood", {
		Title = "Auto Buy Food",
		Description = "Automatically buy selected food when store refreshes",
		Default = false,
	})

	AutoBuyFood:OnChanged(function(Value)
		local success, err = pcall(function()
			if Value then
				startAutoBuyLoop()
			else
				stopAutoBuyLoop()
			end
		end)

		if not success then
			warn("❌ ERROR in AutoBuyFood OnChanged: " .. tostring(err))
		end
	end)

	-- Setup FoodStore listener on script load
	task.spawn(function()
		setupFoodStoreListener()
	end)

	-- Cleanup when Fluent is unloaded
	task.spawn(function()
		while not Fluent.Unloaded do
			task.wait(0.1)
		end
		stopAutoBuyLoop()
	end)
end

--// TAB: Lottery
do
	-- Function to get current lottery ticket count
	local function getLotteryTicketCount()
		return Data.Asset:GetAttribute("LotteryTicket")
	end

	-- Function to check if code is already redeemed
	local function isCodeRedeemed(code)
		local attributeName = "RC_" .. code
		local attributeValue = Data.UserFlag:GetAttribute(attributeName)
		return attributeValue == true
	end

	-- Function to redeem a single code
	local function redeemCode(code)
		local args = {
			[1] = {
				["event"] = "usecode",
				["code"] = code,
			},
		}
		RedemptionCodeRE:FireServer(unpack(args))
	end

	-- Function to use lottery tickets
	local function useLotteryTickets(count)
		local args = {
			[1] = {
				["event"] = "lottery",
				["count"] = count,
			},
		}
		LotteryRE:FireServer(unpack(args))
	end

	-- Add Redeem All Codes button
	Tabs.Lottery:AddButton({
		Title = "Redeem All Codes",
		Description = "Redeem all unredeemed lottery codes",
		Callback = function()
			local redeemed = 0
			local skipped = 0
			local attempted = {}
			for _, code in ipairs(lotteryCodes) do
				if not isCodeRedeemed(code) then
					pcall(function()
						redeemCode(code)
						table.insert(attempted, code)
						redeemed = redeemed + 1
						task.wait(0.1)
					end)
				else
					skipped = skipped + 1
				end
			end
			-- Wait a bit for attributes to update
			task.wait(1)
			local invalid = {}
			for _, code in ipairs(attempted) do
				if not isCodeRedeemed(code) then
					table.insert(invalid, code)
				end
			end
			local invalidStr = #invalid > 0 and "Invalid codes: " .. table.concat(invalid, ", ")
				or "All codes redeemed successfully"
			Fluent:Notify({
				Title = "Codes Redeemed",
				Content = string.format(
					"Redeemed %d codes, skipped %d already redeemed\n%s",
					redeemed,
					skipped,
					invalidStr
				),
				Duration = 10,
			})
			-- print("✅ [Lottery] Redeemed: " .. redeemed .. ", Skipped: " .. skipped)
			if #invalid > 0 then
				-- print("❌ [Lottery] Invalid codes: " .. table.concat(invalid, ", "))
			end
		end,
	})

	-- Add Use All Tickets button
	Tabs.Lottery:AddButton({
		Title = "Use All Tickets",
		Callback = function()
			local ticketCount = getLotteryTicketCount()
			if ticketCount == 0 then
				Fluent:Notify({
					Title = "No Tickets",
					Content = "You don't have any lottery tickets",
					Duration = 3,
				})
				return
			end

			local totalUsed = 0

			-- Use tickets in batches of 10
			while ticketCount >= 10 do
				useLotteryTickets(10)
				ticketCount = ticketCount - 10
				totalUsed = totalUsed + 10
				task.wait(0.5)
			end

			-- Use tickets in batches of 3
			while ticketCount >= 3 do
				useLotteryTickets(3)
				ticketCount = ticketCount - 3
				totalUsed = totalUsed + 3
				task.wait(0.5)
			end

			-- Use remaining tickets one by one
			while ticketCount > 0 do
				useLotteryTickets(1)
				ticketCount = ticketCount - 1
				totalUsed = totalUsed + 1
				task.wait(0.5)
			end

			Fluent:Notify({
				Title = "Tickets Used",
				Content = string.format("Used %d lottery tickets", totalUsed),
				Duration = 5,
			})
		end,
	})
end

--// TAB: Trade
do
	-- Auto Trade State
	local autoTradeState = {
		enabled = false,
		currentTrade = nil,
		tradeCount = 0,
		acceptedTrades = 0,
		declinedTrades = 0,
		connections = {},
		lastTradeTime = os.time(), -- Track time of last trade
	}

	-- Helper Functions
	local function getPetValue(petData)
		if not petData or not Pet then
			return 0
		end
		return Pet:GetPetProduce(petData, 1) or 0
	end

	local function getPetRarity(petData)
		if not petData or not petData.T then
			return 0
		end
		local petDef = ResPet[petData.T]
		return petDef and petDef.Rarity or 0
	end

	local function findBestPetFromTrader(traderPets)
		if not traderPets or #traderPets == 0 then
			return nil
		end

		local bestPet = nil
		local bestRarity = 0
		local bestValue = 0

		for _, pet in pairs(traderPets) do
			local rarity = getPetRarity(pet)
			local value = getPetValue(pet)

			if rarity > bestRarity or (rarity == bestRarity and value > bestValue) then
				bestPet = pet
				bestRarity = rarity
				bestValue = value
			end
		end

		return bestPet
	end

	local function calculateFairnessRatio(playerPet, traderPets)
		if not playerPet or not traderPets then
			return 0
		end

		local playerValue = getPetValue(playerPet)
		if playerValue == 0 then
			return 0
		end

		local traderValue = 0
		for _, traderPet in pairs(traderPets) do
			traderValue = traderValue + getPetValue(traderPet)
		end

		return (traderValue - playerValue) / playerValue
	end

	local function isPetInPool(petType, poolPets)
		if not poolPets then
			return false
		end
		for name, selected in pairs(poolPets) do
			if selected and tostring(petType):lower() == tostring(name):lower() then
				return true
			end
		end
		return false
	end

	local function formatNumber(num)
		if not Format then
			return tostring(num)
		end
		return Format:Number2String(num, "en")
	end

	-- Global webhook function for trade notifications
	local function sendTradeWebhook(heldPet, traderPets, acceptanceType, playerValue, traderValue, fairnessRatio)
		if not Options.WebhookEnabled.Value then
			return
		end
		if not Options.UrlInput or not Options.UrlInput.Value or Options.UrlInput.Value == "" then
			return
		end

		local fields = {}

		-- Field for Your Pet
		local yourPetField = {
			name = "Your Pet",
			value = string.format(
				"%s (%s) - V: %s - %s\n",
				tostring(heldPet.T),
				tostring(heldPet.M),
				formatNumber(tonumber(heldPet.V) or 0),
				formatNumber(playerValue)
			),
			inline = true,
		}
		table.insert(fields, yourPetField)

		-- Field for Trader Pets
		local traderValueStr = ""
		for _, pet in pairs(traderPets) do
			traderValueStr = traderValueStr
				.. string.format(
					"- %s (%s) - V: %s - %s\n",
					tostring(pet.T),
					tostring(pet.M),
					formatNumber(tonumber(pet.V) or 0),
					formatNumber(getPetValue(pet))
				)
		end
		local traderField = {
			name = "Trader Pets",
			value = traderValueStr,
			inline = true,
		}
		table.insert(fields, traderField)

		-- Field for Value Difference
		local differenceField = {
			name = "Value Difference",
			value = string.format(
				"+%s (%s fairness)",
				formatNumber(traderValue - playerValue),
				string.format("%.1f%%", fairnessRatio * 100)
			),
			inline = true,
		}
		table.insert(fields, differenceField)

		local embed = {
			author = {
				name = EmbedSettings.Author.Name,
				icon_url = EmbedSettings.Author.Icon,
			},
			description = string.format("**Trade Accepted** (%s)", acceptanceType),
			fields = fields,
			color = EmbedSettings.Color,
			timestamp = DateTime.now():ToIsoDate(),
		}

		local data = {
			embeds = { embed },
		}

		local success, err = pcall(function()
			local jsonData = HttpService:JSONEncode(data)
			local response = HttpService:RequestAsync({
				Url = Options.UrlInput.Value,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
				},
				Body = jsonData,
			})
		end)
	end

	-- Trade Decision Logic
	local function handleTrade(tradeData)
		if Fluent.Unloaded or not autoTradeState.enabled then
			return
		end

		local success, err = pcall(function()
			if not tradeData then
				return
			end

			if type(tradeData) ~= "table" then
				return
			end

			if not tradeData.data then
				-- Handle responses like bargainresult
				if tradeData.event == "bargainresult" then
					-- Bargain result handled silently
				end
				return
			end

			local data = tradeData.data

			if not data.HoldPet or not data.TradePet then
				return
			end

			autoTradeState.currentTrade = data
			autoTradeState.tradeCount = autoTradeState.tradeCount + 1
			autoTradeState.lastTradeTime = os.time() -- Update last trade time

			local playerPet = data.HoldPet
			local traderPets = data.TradePet
			local bargainTime = data.BargainTime or 0

			-- Auto-save held pet UID
			if playerPet and playerPet.UID then
				if Options.HeldPetUID and Options.HeldPetUID.Value ~= playerPet.UID then
					Options.HeldPetUID:SetValue(playerPet.UID)
				end
			end

			local playerValue = getPetValue(playerPet)

			local traderValue = 0
			for i, pet in pairs(traderPets) do
				local petValue = getPetValue(pet)
				traderValue = traderValue + petValue
			end

			local fairnessRatio = calculateFairnessRatio(playerPet, traderPets)

			-- Wait a bit to prevent spam
			task.wait(0.5)

			-- Check for auto-accept by pet name (highest priority)
			if Options.AutoAcceptPetNameToggle and Options.AutoAcceptPetNameToggle.Value then
				local selectedPetNames = Options.AutoAcceptPetName and Options.AutoAcceptPetName.Value or {}
				for i, pet in pairs(traderPets) do
					local petType = pet.T or pet:GetAttribute("T")
					for petName, isSelected in pairs(selectedPetNames) do
						if isSelected and tostring(petType):lower() == tostring(petName):lower() then
							TradeRE:FireServer({ event = "accept" })
							autoTradeState.acceptedTrades = autoTradeState.acceptedTrades + 1

							-- Send webhook notification
							sendTradeWebhook(playerPet, traderPets, "Pet Name", playerValue, traderValue, fairnessRatio)

							return
						end
					end
				end
			end

			-- Check for auto-accept by same type & mutation (with more value) - second priority
			if Options.AutoAcceptSameMutation and Options.AutoAcceptSameMutation.Value then
				local playerType = tostring(playerPet.T):lower()
				local playerMutation = tostring(playerPet.M):lower()
				local playerV = tonumber(playerPet.V) or 0

				-- Check if trader offers a pet with same type+mutation and >= V value
				local hasSamePet = false
				local matchingPetUID = nil
				for i, pet in pairs(traderPets) do
					local traderType = tostring(pet.T):lower()
					local traderMutation = tostring(pet.M):lower()
					local traderV = tonumber(pet.V) or 0
					local traderPetValue = getPetValue(pet)

					if
						traderType == playerType
						and getMutationIndex(traderMutation) >= getMutationIndex(playerMutation)
						and traderPetValue >= playerValue
					then
						hasSamePet = true
						matchingPetUID = pet.UID
						break
					end
				end

				-- If same pet found, check if total trader value is more than player value
				if hasSamePet and traderValue > playerValue then
					TradeRE:FireServer({ event = "accept" })
					autoTradeState.acceptedTrades = autoTradeState.acceptedTrades + 1

					-- Update held pet UID to the trader's pet UID
					if matchingPetUID and Options.HeldPetUID then
						Options.HeldPetUID:SetValue(matchingPetUID)
					end

					-- Send webhook notification
					sendTradeWebhook(
						playerPet,
						traderPets,
						"Same Pet + More Value",
						playerValue,
						traderValue,
						fairnessRatio
					)

					return
				elseif hasSamePet then
					-- Check if trader only offered 1 pet (the same type+mutation)
					if #traderPets == 1 and bargainTime < 2 then
						TradeRE:FireServer({ event = "bargain" })
						return
					else
						-- Decline if more than 1 pet or bargain already used
						TradeRE:FireServer({ event = "decline" })
						autoTradeState.declinedTrades = autoTradeState.declinedTrades + 1
						return
					end
				end
			end

			-- Check for auto-accept by higher rarity + higher value - third priority
			if Options.AutoAcceptHigherRarity and Options.AutoAcceptHigherRarity.Value then
				local playerRarity = getPetRarity(playerPet)

				-- Check if trader offers any pet with higher rarity and >= value
				for i, pet in pairs(traderPets) do
					local traderRarity = getPetRarity(pet)
					local traderPetValue = getPetValue(pet)

					if traderRarity > playerRarity and traderPetValue >= playerValue then
						TradeRE:FireServer({ event = "accept" })
						autoTradeState.acceptedTrades = autoTradeState.acceptedTrades + 1

						-- Update held pet UID to the higher rarity pet
						if pet.UID and Options.HeldPetUID then
							Options.HeldPetUID:SetValue(pet.UID)
						end

						-- Send webhook notification
						sendTradeWebhook(
							playerPet,
							traderPets,
							"Higher Rarity + Higher Value",
							playerValue,
							traderValue,
							fairnessRatio
						)

						return
					end
				end
			end

			-- Check for pool system - fourth priority
			if Options.AutoTradePool and Options.AutoTradePool.Value then
				local poolPets = Options.PoolPets and Options.PoolPets.Value or {}
				local percentage = tonumber(Options.PoolPercentage and Options.PoolPercentage.Value or 10) / 100
				local minValue = playerValue * (1 - percentage)

				local traderPetsInPool = {}
				for _, pet in pairs(traderPets) do
					if isPetInPool(pet.T, poolPets) then
						table.insert(traderPetsInPool, pet)
					end
				end

				local shouldAccept = false
				local acceptanceReason = ""

				if #traderPetsInPool > 0 then
					local playerInPool = isPetInPool(playerPet.T, poolPets)

					-- Check if any trader's pool pet meets the value threshold
					local anyPoolPetMeetsThreshold = false
					for _, pet in pairs(traderPetsInPool) do
						if getPetValue(pet) >= minValue then
							anyPoolPetMeetsThreshold = true
							break
						end
					end

					-- Trade into pool: only if player pet not in pool and any pool pet meets threshold
					if not playerInPool and anyPoolPetMeetsThreshold then
						shouldAccept = true
						acceptanceReason = "Trade into Pool"
					end

					-- Pool upgrade: if player pet in pool and trader has pet in pool worth more
					if not shouldAccept and playerInPool then
						for _, pet in pairs(traderPetsInPool) do
							if getPetValue(pet) > playerValue then
								shouldAccept = true
								acceptanceReason = "Pool Upgrade"
								break
							end
						end
					end

					-- Pool downgrade: only if player pet in pool and 2+ trader pets in pool
					if
						not shouldAccept
						and Options.AllowDowngrade
						and Options.AllowDowngrade.Value
						and playerInPool
						and #traderPetsInPool >= 2
					then
						local allTraderPetsMeetValue = true
						for _, pet in pairs(traderPetsInPool) do
							local petValue = getPetValue(pet)
							if petValue < minValue then
								allTraderPetsMeetValue = false
								break
							end
						end
						if allTraderPetsMeetValue then
							shouldAccept = true
							acceptanceReason = "Pool Downgrade"
						end
					end
				end

				if shouldAccept then
					TradeRE:FireServer({ event = "accept" })
					autoTradeState.acceptedTrades = autoTradeState.acceptedTrades + 1

					sendTradeWebhook(playerPet, traderPets, acceptanceReason, playerValue, traderValue, fairnessRatio)

					-- Auto-equip highest rarity pet (or highest value if same rarity)
					local bestPet = findBestPetFromTrader(traderPets)
					if bestPet and bestPet.UID and Options.HeldPetUID then
						Options.HeldPetUID:SetValue(bestPet.UID)
					end

					return
				end
			end

			-- Check fairness threshold and acceptance mode
			local minFairnessPercent =
				tonumber(Options.MinFairnessPercentage and Options.MinFairnessPercentage.Value or 0.9)
			local acceptanceMode = Options.AcceptanceMode and Options.AcceptanceMode.Value or "Fairness Only"

			-- Check if fairness passes
			local acceptByFairness = fairnessRatio >= minFairnessPercent

			-- Check if any pet meets high-value threshold
			local acceptByValue = false
			local acceptThreshold = tonumber(Options.AutoAcceptPetValue.Value) or 0
			local highValuePets = {} -- Track high-value pets for webhook
			if acceptThreshold > 0 then
				for i, pet in pairs(traderPets) do
					local petValue = getPetValue(pet)
					if petValue >= acceptThreshold and petValue > playerValue then
						acceptByValue = true
						table.insert(highValuePets, {
							index = i,
							value = petValue,
							type = pet.T,
							mutation = pet.M,
						})
					end
				end
			end

			-- Send webhook notification if there are high-value pets
			if #highValuePets > 0 then
				sendTradeWebhook(playerPet, traderPets, "High-Value Pet", playerValue, traderValue, fairnessRatio)
			end

			-- Determine if trade should be accepted based on mode
			local shouldAccept = false
			if acceptanceMode == "Fairness Only" then
				shouldAccept = acceptByFairness
			elseif acceptanceMode == "Pet Value Only" then
				shouldAccept = acceptByValue
			elseif acceptanceMode == "Either" then
				shouldAccept = acceptByFairness or acceptByValue
			end

			if not shouldAccept then
				-- Try bargaining if available before declining
				if Options.AutoBargain and Options.AutoBargain.Value and bargainTime < 2 then
					TradeRE:FireServer({ event = "bargain" })
					return
				end
				TradeRE:FireServer({ event = "decline" })
				autoTradeState.declinedTrades = autoTradeState.declinedTrades + 1

				-- Re-focus pet after declining
				local CharacterRE = ReplicatedStorage:FindFirstChild("Remote")
					and ReplicatedStorage.Remote:FindFirstChild("CharacterRE")
				if CharacterRE then
					CharacterRE:FireServer("Focus")
					local petUID = Options.HeldPetUID and Options.HeldPetUID.Value or ""
					if petUID ~= "" then
						task.wait(1)
						CharacterRE:FireServer("Focus", petUID)
					end
				end

				return
			end

			-- Accept trade
			TradeRE:FireServer({ event = "accept" })
			autoTradeState.acceptedTrades = autoTradeState.acceptedTrades + 1

			-- Auto-equip highest rarity pet (or highest value if same rarity)
			local bestPet = findBestPetFromTrader(traderPets)
			if bestPet and bestPet.UID and Options.HeldPetUID then
				Options.HeldPetUID:SetValue(bestPet.UID)
			end

			-- Send webhook notification
			local acceptanceReason = acceptByValue and "Pet Value Only"
				or (acceptByFairness and "Fairness Only" or "Either")
			sendTradeWebhook(playerPet, traderPets, acceptanceReason, playerValue, traderValue, fairnessRatio)
		end)

		if not success then
			warn(err)
		end
	end

	-- Create Trade Tab UI
	local TradeSection = Tabs.Trade:AddSection("Auto Trade")

	local AutoTradeToggle = TradeSection:AddToggle("AutoTrade", {
		Title = "Auto Trade",
		Default = false,
	})

	AutoTradeToggle:OnChanged(function(value)
		autoTradeState.enabled = value
		if value then
			TradeRE.OnClientEvent:Connect(handleTrade)
		end
	end)

	local MinFairness = TradeSection:AddInput("MinFairness", {
		Title = "Min Fairness %",
		Description = "Minimum fairness ratio to accept trades (0-100)",
		Default = 200,
		Numeric = true,
		Finished = false,
	})

	MinFairness:OnChanged(function(value)
		local numValue = tonumber(value)

		-- Update MinFairness in options to the 0-1000 value
		Options.MinFairness.Value = numValue

		if not Options.MinFairnessPercentage then
			Options.MinFairnessPercentage = { Value = Options.MinFairness.Value / 100 }
		else
			Options.MinFairnessPercentage.Value = numValue / 100
		end
	end)

	local AcceptanceMode = TradeSection:AddDropdown("AcceptanceMode", {
		Title = "Acceptance Mode",
		Description = "How to decide whether to accept trades",
		Values = { "Fairness Only", "Pet Value Only", "Either" },
		Multi = false,
		Default = 1,
	})

	local AutoAcceptPetNameToggle = TradeSection:AddToggle("AutoAcceptPetNameToggle", {
		Title = "Auto Accept Pet Name",
		Description = "Automatically accept trades for specific pet names",
		Default = false,
	})

	local AutoAcceptPetName = TradeSection:AddDropdown("AutoAcceptPetName", {
		Title = "Select Pet Name",
		Description = "Which pet to auto-accept",
		Values = { "Toothless" },
		Multi = true,
		Default = { "Toothless" },
	})

	local AutoAcceptPetValue = TradeSection:AddInput("AutoAcceptPetValue", {
		Title = "Auto Accept Pet Value",
		Description = "Accept trade if any trader pet >= this value (0 = disabled)",
		Default = 1000000,
		Numeric = true,
		Finished = false,
		Placeholder = "1000000",
	})

	AutoAcceptPetValue:OnChanged(function(value)
		-- Value changed
	end)

	-- NEW: Auto Accept Same Type & Mutation Toggle
	local AutoAcceptSameMutation = TradeSection:AddToggle("AutoAcceptSameMutation", {
		Title = "Auto Accept Same Type & Mutation + More",
		Description = "Accept if trader offers same type+mutation pet AND more value",
		Default = false,
	})

	-- NEW: Auto Accept Higher Rarity + Higher Value Toggle
	local AutoAcceptHigherRarity = TradeSection:AddToggle("AutoAcceptHigherRarity", {
		Title = "Auto Accept Higher Rarity + Higher Value",
		Description = "Accept if trader offers any pet with higher rarity AND value >= your pet",
		Default = false,
	})

	-- Pool System UI
	local PoolPets = TradeSection:AddDropdown("PoolPets", {
		Title = "Pool Pets",
		Description = "Select pets for the pool system",
		Values = {
			"NightOwl",
			"MetroGiraffe",
			"Griffin_E1",
			"Godzilla",
			"BluePhoenix",
			"SkeletonHorse",
			"Centaur",
			"Red-crownedCrane",
		},
		Multi = true,
		Default = {
			"NightOwl",
			"MetroGiraffe",
			"Griffin_E1",
			"Godzilla",
			"BluePhoenix",
			"SkeletonHorse",
			"Centaur",
			"Red-crownedCrane",
		},
	})

	local AutoTradePool = TradeSection:AddToggle("AutoTradePool", {
		Title = "Auto Trade Pool",
		Description = "Enable pool system for trades",
		Default = false,
	})

	local PoolPercentage = TradeSection:AddInput("PoolPercentage", {
		Title = "Pool Percentage",
		Description = "Maximum % less value allowed (e.g., 10)",
		Default = 10,
		Numeric = true,
		Finished = false,
		Placeholder = "10",
	})

	local AllowDowngrade = TradeSection:AddToggle("AllowDowngrade", {
		Title = "Allow Downgrade in Pool",
		Description = "Allow trading pool pet for multiple pool pets of similar value",
		Default = false,
	})

	local AutoBargain = TradeSection:AddToggle("AutoBargain", {
		Title = "Auto Bargain",
		Description = "Automatically bargain for better deals (max 2 times)",
		Default = true,
	})

	-- Trade Zone Controls
	local ZoneSection = Tabs.Trade:AddSection("Trade Zone")

	-- Held Pet UID Input
	local HeldPetInput = ZoneSection:AddInput("HeldPetUID", {
		Title = "Held Pet UID",
		Description = "Pet UID to auto-equip after teleport (detected automatically)",
		Default = "",
		Placeholder = "towa",
		Numeric = false,
		Finished = true,
	})

	-- Teleport to Trade Zone Toggle
	local TeleportToZone = ZoneSection:AddToggle("TeleportToZone", {
		Title = "Auto Teleport to Zone",
		Description = "Teleport to trade zone on script load",
		Default = false,
	})

	local function teleportToTradeZone(zoneNumber)
		-- print("🔍 [Teleport] Assigned Island: " .. AssignedIslandName)

		-- Navigate to trade zone: Workspace > Art > Assigned_Island > ENV > TradeZone > Zone > TradeZone5 > TradePart
		local tradePart = Workspace.Art[AssignedIslandName].ENV.TradeZone.Zone:WaitForChild(
			string.format("TradeZone%d", zoneNumber)
		).TradePart

		-- Get CFrame position
		local targetCFrame = tradePart.CFrame
		if not targetCFrame then
			return false
		end

		-- Teleport player
		local char = LocalPlayer.Character
		local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			humanoidRootPart.CFrame = targetCFrame
			return true
		else
			return false
		end
	end

	TeleportToZone:OnChanged(function(value)
		if value then
			-- Teleport to Zone 1 by default
			task.wait(0.5)
			teleportToTradeZone(5)
		end
	end)

	-- Function to equip pet by UID
	local function equipPet(petUID)
		if not petUID or petUID == "" then
			return false
		end

		CharacterRE:FireServer("Focus", petUID)
		return true
	end

	-- Auto-teleport on script load if toggle is enabled
	task.spawn(function()
		task.wait(2) -- Wait for character and SaveManager to load
		if Options.TeleportToZone and Options.TeleportToZone.Value then
			local success = teleportToTradeZone(Options.TradeZone.Value)
			if success then
				-- Auto-equip pet after teleporting
				task.wait(1) -- Wait for teleport to complete
				local petUID = Options.HeldPetUID and Options.HeldPetUID.Value or ""
				if petUID ~= "" then
					equipPet(petUID)
				end
			end
		end
	end)

	-- Background task to re-equip pet after 5 minutes of inactivity
	task.spawn(function()
		task.wait(5) -- Wait for script to fully initialize

		while not Fluent.Unloaded do
			task.wait(60) -- Check every minute

			-- Only check if auto trade is enabled
			if autoTradeState.enabled then
				local timeSinceLastTrade = os.time() - autoTradeState.lastTradeTime
				local fiveMinutes = 5 * 60 -- 5 minutes in seconds

				if timeSinceLastTrade >= fiveMinutes then
					local petUID = Options.HeldPetUID and Options.HeldPetUID.Value or ""
					if petUID ~= "" then
						CharacterRE:FireServer("Focus")
						task.wait(1)
						CharacterRE:FireServer("Focus", petUID)

						autoTradeState.lastTradeTime = os.time() -- Reset timer after re-equipping
					end
				end
			end
		end
	end)

	-- ZoneSection:AddParagraph({
	-- 	Title = "Trade Zones",
	-- 	Content = "Zone 1: Giraffe, Butterflyfish, Hippo\nZone 2: Okapi, Panther, Flounder\nZone 3: Kangaroo, Fox_E1, Gorilla\nZone 4: Dolphin, Dragon, Bear_E1\nZone 5: BluePhoenix, MetroGiraffe, Centaur, Toothless",
	-- })

	local TradeZoneDropdown = ZoneSection:AddDropdown("TradeZone", {
		Title = "Select Trade Zone",
		Description = "Switch to a different trade zone",
		Values = { 1, 2, 3, 4, 5 },
		Numeric = true,
		Multi = false,
		Default = 5,
	})

	TradeZoneDropdown:OnChanged(function(value)
		teleportToTradeZone(value)
	end)

	-- Auto Claim Kitsune toggle
	local AutoClaimKitsune = TradeSection:AddToggle("AutoClaimKitsune", {
		Title = "Auto Claim Kitsune",
		Description = "Automatically claim Kitsune every 5 minutes",
		Default = true,
	})

	-- Auto Claim Kitsune coroutine
	task.spawn(function()
		while not Fluent.Unloaded do
			task.wait(5 * 60) -- Wait 5 minutes

			if Options.AutoClaimKitsune and Options.AutoClaimKitsune.Value then
				local counterText =
					Workspace.Art[AssignedIslandName].ENV.TradeZone.Zone:WaitForChild("Kitsune").SellPart.BillboardGui.Root.Title.Text
				local current = tonumber(counterText:match("(%d+)/1000"))

				if current < 1000 then
					return
				end

				local success, error = pcall(function()
					TradeRE:FireServer({ event = "claimreward" })
				end)
			end
		end
	end)

	-- Cleanup
	task.spawn(function()
		while not Fluent.Unloaded do
			task.wait(0.1)
		end
		for _, conn in pairs(autoTradeState.connections) do
			if conn then
				conn:Disconnect()
			end
		end
	end)
end

--// Shared Helper Functions
-- Helper function to get user's pets from Workspace.Pets
local function getMyPets()
	local userId = LocalPlayer.CharacterAppearanceId

	local myPets = {}
	for _, petObject in pairs(Pets:GetChildren()) do
		-- Filter by UserId attribute matching CharacterAppearanceId
		local petUserId = petObject:GetAttribute("UserId")
		-- Exclude pets with BigPetType attribute
		local bigPetType = petObject:GetAttribute("BigPetType")
		if petUserId == userId and not bigPetType then
			table.insert(myPets, petObject)
		end
	end

	return myPets
end

--// TAB: Pets
do
	-- Helper function to get CFrame from a pet object
	local function getPetCFrame(petObject)
		local petPart = nil
		if petObject:IsA("BasePart") then
			petPart = petObject
		else
			-- Look for a BasePart child (like a PrimaryPart or main part)
			petPart = petObject:FindFirstChildOfClass("BasePart")
			-- If no BasePart found, try PrimaryPart
			if not petPart and petObject:IsA("Model") then
				petPart = petObject.PrimaryPart
			end
		end

		if petPart then
			return petPart.CFrame
		end
		return nil
	end

	Tabs.Pets:AddButton({
		Title = "Claim All",
		Description = "Teleport to all your pets and claim them",
		Callback = function()
			if Fluent.Unloaded then
				return
			end

			local char = LocalPlayer.Character
			local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart then
				return
			end

			-- Save original position
			local originalCFrame = humanoidRootPart.CFrame

			-- Get my pets using shared function
			local petObjects = getMyPets()

			if #petObjects == 0 then
				return
			end

			-- Teleport to each pet
			for i, petObject in ipairs(petObjects) do
				if Fluent.Unloaded then
					return
				end

				local targetCFrame = getPetCFrame(petObject)
				if targetCFrame then
					humanoidRootPart.CFrame = targetCFrame
					task.wait(0.5)
				end
			end

			-- Teleport back to original position
			task.wait(0.5)
			humanoidRootPart.CFrame = originalCFrame
		end,
	})

	-- Helper function to calculate max value: ProduceSpeed / (sum of ProduceRate from mutations)
	-- Then multiply base by Mutate.ProduceRate to get base + mutate value
	local function calculateMaxValue(produceSpeed, mutate, mutate2)
		if not produceSpeed or produceSpeed == 0 then
			return 0
		end

		local mutateDefProduceRate = 0
		local mutate2DefProduceRate = 0

		-- Get ProduceRate from Mutate
		if mutate and mutate ~= "" then
			local mutateDef = ResMutate[mutate]
			if mutateDef and mutateDef.ProduceRate then
				mutateDefProduceRate = mutateDef.ProduceRate
			end
		end

		-- Get ProduceRate from Mutate2
		if mutate2 and mutate2 ~= "" then
			local mutate2Def = ResMutate[mutate2]
			if mutate2Def and mutate2Def.ProduceRate then
				mutate2DefProduceRate = mutate2Def.ProduceRate
			end
		end

		-- Total multiplier = Mutate + Mutate2
		local totalProduceRate = mutateDefProduceRate + mutate2DefProduceRate

		-- If no mutations, default to 1 to avoid division by zero
		if totalProduceRate == 0 then
			totalProduceRate = 1
		end

		-- Calculate base: ProduceSpeed / (Mutate + Mutate2)
		local base = produceSpeed / totalProduceRate

		-- Calculate max value: base * (Mutate + 5) -- 5 Admin Abuse Mutation
		local maxValue = base * (mutateDefProduceRate + 5)

		-- Round to whole number
		return math.floor(maxValue + 0.5)
	end

	-- Helper function to find lowest pet by category
	local function findLowestPetByCategory(isOcean, useBase)
		if Fluent.Unloaded then
			return
		end

		local char = LocalPlayer.Character
		local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
		local petObjects = getMyPets()
		local petsWithValue = {}

		for _, petObject in ipairs(petObjects) do
			local produceSpeed = petObject:GetAttribute("ProduceSpeed")
			local petType = petObject:GetAttribute("Type")

			if produceSpeed and petType then
				-- Look up category from ResPet
				local petDef = ResPet[petType]
				local category = petDef and petDef.Category or ""

				-- Filter by category
				local matchesCategory = false
				if isOcean then
					matchesCategory = (category == "Ocean")
				else
					matchesCategory = (category ~= "Ocean")
				end

				if matchesCategory then
					local mutate = petObject:GetAttribute("Mutate")
					local mutate2 = petObject:GetAttribute("Mutate2")

					local value
					if useBase then
						-- For max value calculation, exclude Mutate2 from ProduceRate calculation
						value = calculateMaxValue(produceSpeed, mutate, mutate2)
					else
						value = produceSpeed
					end

					table.insert(petsWithValue, {
						object = petObject,
						value = value,
						produceSpeed = produceSpeed,
						mutate = mutate,
						mutate2 = mutate2,
					})
				end
			end
		end

		if #petsWithValue == 0 then
			local categoryName = isOcean and "Ocean" or "Land"
			Fluent:Notify({
				Title = "No Pets Found",
				Content = string.format("No %s pets with ProduceSpeed found", categoryName),
				Duration = 3,
			})
			return
		end

		-- Sort by value (lowest first)
		table.sort(petsWithValue, function(a, b)
			return a.value < b.value
		end)

		-- Get the lowest value pet
		local lowestPet = petsWithValue[1]
		local petObject = lowestPet.object
		local value = lowestPet.value
		local produceSpeed = lowestPet.produceSpeed

		-- Get pet name from Type attribute
		local petType = petObject:GetAttribute("Type")
		local petName = petType or petObject.Name

		-- Get Mutate and Mutate2 attributes
		local mutate = lowestPet.mutate
		local mutate2 = lowestPet.mutate2
		local mutateStr = mutate and tostring(mutate) or "None"
		local mutate2Str = mutate2 and tostring(mutate2) or "None"

		local targetCFrame = getPetCFrame(petObject)
		if targetCFrame then
			-- Teleport to pet
			humanoidRootPart.CFrame = targetCFrame

			-- Send notification
			local categoryName = isOcean and "Ocean" or "Land"
			local titleSuffix = useBase and " (Max)" or ""
			local valueLabel = useBase and "Max Value" or "Value"
			local valueStr = tostring(value)

			Fluent:Notify({
				Title = string.format("%s Pet Found%s", categoryName, titleSuffix),
				Content = string.format(
					"Pet: %s\n%s: %s\nProduceSpeed: %s\nMutate: %s\nMutate2: %s",
					petName,
					valueLabel,
					valueStr,
					tostring(produceSpeed),
					mutateStr,
					mutate2Str
				),
				Duration = 8,
			})
		end
	end

	Tabs.Pets:AddButton({
		Title = "Find Lowest Ocean Pet",
		Description = "Find and teleport to your ocean pet with the lowest ProduceSpeed",
		Callback = function()
			findLowestPetByCategory(true, false)
		end,
	})

	Tabs.Pets:AddButton({
		Title = "Find Lowest Land Pet",
		Description = "Find and teleport to your land pet with the lowest ProduceSpeed",
		Callback = function()
			findLowestPetByCategory(false, false)
		end,
	})

	Tabs.Pets:AddButton({
		Title = "Find Lowest Ocean Pet (Max)",
		Description = "Find and teleport to your ocean pet with the lowest max value (with AA)",
		Callback = function()
			findLowestPetByCategory(true, true)
		end,
	})

	Tabs.Pets:AddButton({
		Title = "Find Lowest Land Pet (Max)",
		Description = "Find and teleport to your land pet with the lowest max value (with AA)",
		Callback = function()
			findLowestPetByCategory(false, true)
		end,
	})
end

do
	local GiftSection = Tabs.Gift:AddSection("Gift Eggs")

	local SelectPlayer = GiftSection:AddDropdown("SelectPlayer", {
		Title = "Select Player",
		Values = {},
		Multi = false,
		Default = "",
	})

	local SelectEgg = GiftSection:AddDropdown("SelectEgg", {
		Title = "Select Egg Type",
		Values = {},
		Multi = false,
		Default = "",
	})

	local function refreshData()
		-- Refresh players
		local players = Players:GetPlayers()
		local playerNames = {}
		for _, p in ipairs(players) do
			if p ~= LocalPlayer then
				table.insert(playerNames, p.Name)
			end
		end
		SelectPlayer:SetValues(playerNames)

		-- Refresh eggs
		local eggs = Egg:GetChildren()
		local eggTypes = {}
		for _, e in ipairs(eggs) do
			local t = e:GetAttribute("T")
			if t then
				eggTypes[t] = true
			end
		end
		local final = {}
		for k in pairs(eggTypes) do
			table.insert(final, k)
		end
		SelectEgg:SetValues(final)
	end

	Tabs.Gift:AddButton({
		Title = "Refresh",
		Description = "Refresh players and eggs",
		Callback = refreshData,
	})

	local function giftEggs()
		local selectedPlayerName = Options.SelectPlayer and Options.SelectPlayer.Value or ""
		if selectedPlayerName == "" then
			Fluent:Notify({
				Title = "Error",
				Content = "Please select a player",
				Duration = 3,
			})
			return
		end
		local targetPlayer = Players:FindFirstChild(selectedPlayerName)
		if not targetPlayer then
			Fluent:Notify({
				Title = "Error",
				Content = "Player not found",
				Duration = 3,
			})
			return
		end

		local selectedEggType = Options.SelectEgg and Options.SelectEgg.Value or ""
		if selectedEggType == "" then
			Fluent:Notify({
				Title = "Error",
				Content = "Please select an egg type",
				Duration = 3,
			})
			return
		end

		local eggsToGift = {}
		for _, e in ipairs(Egg:GetChildren()) do
			local t = e:GetAttribute("T")
			local uid = e:GetAttribute("UID")
			if t == selectedEggType and uid then
				table.insert(eggsToGift, { uid = uid })
			end
		end

		if #eggsToGift == 0 then
			Fluent:Notify({
				Title = "No Eggs",
				Content = "No eggs found matching criteria",
				Duration = 3,
			})
			return
		end

		-- Teleport to target
		local targetCharacter = targetPlayer.Character
		if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
			local humanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart then
				humanoidRootPart.CFrame = targetCharacter.HumanoidRootPart.CFrame
				task.wait(0.5)
			end
		end

		task.spawn(function()
			for _, egg in ipairs(eggsToGift) do
				if Fluent.Unloaded then
					return
				end
				DeployRE:FireServer({ event = "deploy", uid = egg.uid })
				task.wait(0.4)
				CharacterRE:FireServer("Focus", egg.uid)
				task.wait(0.4)
				local success = pcall(function()
					local UpdateBE = LocalPlayer.PlayerGui.ScreenGiftC.ScreenGiftC.UpdateBE
					UpdateBE:Fire({ TPlayer = targetPlayer })
				end)
				task.wait(0.4)
				GiftRE:FireServer(targetPlayer)
				task.wait(0.4)
			end
			Fluent:Notify({
				Title = "Gifting Complete",
				Content = "Gifted " .. #eggsToGift .. " eggs",
				Duration = 3,
			})
		end)
	end

	Tabs.Gift:AddButton({
		Title = "Gift",
		Description = "Gift selected eggs to selected player",
		Callback = giftEggs,
	})
end

do
	local WebhookSection = Tabs.Webhook:AddSection("Discord Webhook")

	local UrlInput = WebhookSection:AddInput("UrlInput", {
		Title = "Webhook URL",
		Description = "Enter your Discord webhook URL",
		Default = "",
		Placeholder = "https://discord.com/api/webhooks/...",
		Numeric = false,
		Finished = true,
	})

	local WebhookEnabled = WebhookSection:AddToggle("WebhookEnabled", {
		Title = "Webhook Enabled",
		Default = true,
	})

	local MessageInput = WebhookSection:AddInput("MessageInput", {
		Title = "Message",
		Description = "Enter a custom message",
		Default = "",
		Placeholder = "Your message here...",
		Numeric = false,
		Finished = true,
	})

	local function sendWebhook(content)
		if not Options.WebhookEnabled.Value then
			return
		end
		local webhookUrl = Options.UrlInput.Value or ""

		if webhookUrl == "" then
			Fluent:Notify({
				Title = "Error",
				Content = "Please enter a webhook URL",
				Duration = 3,
			})
			return
		end

		local data = {
			embeds = {
				{
					author = {
						name = EmbedSettings.Author.Name,
						icon_url = EmbedSettings.Author.Icon,
					},
					description = content,
					color = EmbedSettings.Color,
					timestamp = DateTime.now():ToIsoDate(),
				},
			},
		}

		local success, err = pcall(function()
			local jsonData = HttpService:JSONEncode(data)
			local response = HttpService:RequestAsync({
				Url = webhookUrl,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
				},
				Body = jsonData,
			})
		end)
	end

	WebhookSection:AddButton({
		Title = "Calculate Eggs",
		Description = "Count eggs in inventory and send to webhook",
		Callback = function()
			local eggData = Egg
			if not eggData then
				Fluent:Notify({
					Title = "Error",
					Content = "Egg data not found",
					Duration = 3,
				})
				return
			end

			local eggCount = 0
			local eggGroups = {} -- Table to group eggs by mutation and type

			for _, egg in pairs(eggData:GetChildren()) do
				local m = egg:GetAttribute("M")
				local t = egg:GetAttribute("T")
				local uid = egg:GetAttribute("UID")

				if m and t and uid then
					eggCount = eggCount + 1
					local mutation = tostring(m)
					local eggType = tostring(t)

					-- Create a key for grouping (mutation + eggType)
					local groupKey = mutation .. "|" .. eggType

					-- Initialize count if this combination doesn't exist
					if not eggGroups[groupKey] then
						eggGroups[groupKey] = {
							mutation = mutation,
							eggType = eggType,
							count = 0,
						}
					end

					-- Increment count for this group
					eggGroups[groupKey].count = eggGroups[groupKey].count + 1
				end
			end

			-- Build the grouped details list
			local eggDetails = {}
			for groupKey, groupData in pairs(eggGroups) do
				local displayName = groupData.mutation
				if displayName == "None" or displayName == "" then
					displayName = "Normal"
				end
				table.insert(eggDetails, string.format("%s %s: %d", displayName, groupData.eggType, groupData.count))
			end

			-- Sort the details alphabetically
			table.sort(eggDetails)

			local message = string.format(
				"**Egg Inventory Report**\nTotal Eggs: %d\n\n%s",
				eggCount,
				table.concat(eggDetails, "\n")
			)

			local customMessage = Options.MessageInput.Value or ""
			if customMessage ~= "" then
				message = customMessage .. "\n\n" .. message
			end

			sendWebhook(message)
		end,
	})

	WebhookSection:AddButton({
		Title = "Calculate Pets",
		Description = "Count all pets by value bins and send to webhook",
		Callback = function()
			if Fluent.Unloaded then
				return
			end

			local petObjects = getMyPets()
			if #petObjects == 0 then
				return
			end

			-- Initialize bins
			local bins = {
				["<100k"] = 0,
				["100k+"] = 0,
				["200k+"] = 0,
				["300k+"] = 0,
				["400k+"] = 0,
				["500k+"] = 0,
				["600k+"] = 0,
				["700k+"] = 0,
				["800k+"] = 0,
				["900k+"] = 0,
				["1m+"] = 0,
				["1.1m+"] = 0,
				["1.2m+"] = 0,
				["1.3m+"] = 0,
				["1.4m+"] = 0,
				["1.5m+"] = 0,
			}

			-- Calculate values and bin pets
			for _, petObject in ipairs(petObjects) do
				local value = petObject:GetAttribute("ProduceSpeed")

				if value < 100000 then
					bins["<100k"] = bins["<100k"] + 1
				elseif value < 200000 then
					bins["100k+"] = bins["100k+"] + 1
				elseif value < 300000 then
					bins["200k+"] = bins["200k+"] + 1
				elseif value < 400000 then
					bins["300k+"] = bins["300k+"] + 1
				elseif value < 500000 then
					bins["400k+"] = bins["400k+"] + 1
				elseif value < 600000 then
					bins["500k+"] = bins["500k+"] + 1
				elseif value < 700000 then
					bins["600k+"] = bins["600k+"] + 1
				elseif value < 800000 then
					bins["700k+"] = bins["700k+"] + 1
				elseif value < 900000 then
					bins["800k+"] = bins["800k+"] + 1
				elseif value < 1000000 then
					bins["900k+"] = bins["900k+"] + 1
				elseif value < 1100000 then
					bins["1m+"] = bins["1m+"] + 1
				elseif value < 1200000 then
					bins["1.1m+"] = bins["1.1m+"] + 1
				elseif value < 1300000 then
					bins["1.2m+"] = bins["1.2m+"] + 1
				elseif value < 1400000 then
					bins["1.3m+"] = bins["1.3m+"] + 1
				elseif value < 1500000 then
					bins["1.4m+"] = bins["1.4m+"] + 1
				else
					bins["1.5m+"] = bins["1.5m+"] + 1
				end
			end

			-- Build message
			local message = "**Pet Value Distribution**\n\n"
			message = message .. string.format("<100k pets: %d\n", bins["<100k"])
			message = message .. string.format("100k+ pets: %d\n", bins["100k+"])
			message = message .. string.format("200k+ pets: %d\n", bins["200k+"])
			message = message .. string.format("300k+ pets: %d\n", bins["300k+"])
			message = message .. string.format("400k+ pets: %d\n", bins["400k+"])
			message = message .. string.format("500k+ pets: %d\n", bins["500k+"])
			message = message .. string.format("600k+ pets: %d\n", bins["600k+"])
			message = message .. string.format("700k+ pets: %d\n", bins["700k+"])
			message = message .. string.format("800k+ pets: %d\n", bins["800k+"])
			message = message .. string.format("900k+ pets: %d\n", bins["900k+"])
			message = message .. string.format("1m+ pets: %d\n", bins["1m+"])
			message = message .. string.format("1.1m+ pets: %d\n", bins["1.1m+"])
			message = message .. string.format("1.2m+ pets: %d\n", bins["1.2m+"])
			message = message .. string.format("1.3m+ pets: %d\n", bins["1.3m+"])
			message = message .. string.format("1.4m+ pets: %d\n", bins["1.4m+"])
			message = message .. string.format("1.5m+ pets: %d\n", bins["1.5m+"])

			local totalPets = #petObjects
			message = message .. string.format("\n**Total Pets: %d**", totalPets)

			local customMessage = Options.MessageInput.Value or ""
			if customMessage ~= "" then
				message = customMessage .. "\n\n" .. message
			end

			sendWebhook(message)
		end,
	})
end

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("BunnyGirlHub")
SaveManager:SetFolder("BunnyGirlHub/buildazoo")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Load config immediately after SaveManager is set up (before UI is shown)
-- This ensures saved settings are loaded before the UI displays
local CONFIG_NAME = "autosave"
pcall(function()
	-- Try loading the autosave config first
	SaveManager:Load(CONFIG_NAME)
end)

-- Fallback: load any config marked as autoload (in case user manually set another config)
pcall(function()
	SaveManager:LoadAutoloadConfig()
end)

Window:SelectTab(1)

--// Set rendering enabled
RunService:Set3dRenderingEnabled(Options.RenderingEnabled.Value)

--// Anti idle
LocalPlayer.Idled:Connect(function()
	if not Options.AntiAFK.Value then
		return
	end

	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

--// Auto reconnect
GuiService.ErrorMessageChanged:Connect(function()
	if not Options.AutoReconnect.Value then
		return
	end

	--// Execute the script after teleporting
	queue_on_teleport(
		"loadstring(game:HttpGet('https://raw.githubusercontent.com/bunnygirlcapital/bunnygirlhub/main/696969.lua'))()"
	)

	TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
end)

-- Auto-save configuration system (CONFIG_NAME defined above)
local saveCooldown = 1 -- Save at most once per second (increased to reduce file conflicts)
local lastSaveTime = 0
local isInitialLoad = true
local saveQueued = false

-- Function to auto-save config
local function autoSaveConfig()
	if isInitialLoad then
		return -- Don't save during initial load
	end

	if saveQueued then
		return -- Already queued for saving
	end

	local currentTime = tick()
	if currentTime - lastSaveTime < saveCooldown then
		saveQueued = true
		task.spawn(function()
			task.wait(saveCooldown - (currentTime - lastSaveTime))
			if Fluent.Unloaded then
				return
			end
			saveQueued = false
			autoSaveConfig()
		end)
		return
	end

	saveQueued = false
	lastSaveTime = currentTime

	local success, errorMsg = pcall(function()
		-- Check if SaveManager is ready
		if not SaveManager or Fluent.Unloaded then
			return false
		end
		SaveManager:Save(CONFIG_NAME)
		return true
	end)

	if not success then
		-- Only warn if it's not because SaveManager isn't ready or Fluent is unloaded
		if not Fluent.Unloaded and SaveManager then
			warn("Failed to auto-save config: " .. tostring(errorMsg))
		end
		-- Reset saveQueued so we can try again later
		saveQueued = false
	end
end

-- Hook into all options after they're created to add auto-save
local function setupAutoSave()
	-- Wait for all options to be initialized and SaveManager to be ready
	task.wait(0.5)

	-- Double-check SaveManager is ready before enabling auto-save
	if not SaveManager then
		warn("SaveManager not ready, retrying...")
		task.wait(1)
		if not SaveManager then
			warn("SaveManager failed to initialize, auto-save disabled")
			return
		end
	end

	isInitialLoad = false

	-- Add OnChanged callback to all existing options
	for optionName, option in pairs(Options) do
		if option and option.OnChanged then
			-- Add auto-save callback without overriding existing callbacks
			option:OnChanged(function()
				-- Debounce: only save if SaveManager is ready and not unloaded
				if SaveManager and not Fluent.Unloaded then
					autoSaveConfig()
				end
			end)
		end
	end

	-- Also monitor for new options being added
	local optionCheckConnection
	optionCheckConnection = task.spawn(function()
		while not Fluent.Unloaded do
			task.wait(1)
			for optionName, option in pairs(Options) do
				if option and option.OnChanged and not option._autoSaveHooked then
					option._autoSaveHooked = true
					option:OnChanged(function()
						autoSaveConfig()
					end)
				end
			end
		end
	end)
end

-- Start auto-save setup
-- Config is already loaded above, this section just handles auto-saving on changes
task.spawn(setupAutoSave)

-- Auto Like task
task.spawn(function()
	while not Fluent.Unloaded do
		task.wait(5 * 60) -- 5 minutes
		if not Options.AutoLike.Value then
			continue
		end
		local players = Players:GetPlayers()
		for _, player in ipairs(players) do
			if Fluent.Unloaded then
				return
			end
			if player == LocalPlayer then
				continue
			end
			local appearanceId = player.CharacterAppearanceId
			if appearanceId then
				CharacterRE:FireServer("GiveLike", appearanceId)
			end
			task.wait(60) -- 1 minute
		end
	end
end)
