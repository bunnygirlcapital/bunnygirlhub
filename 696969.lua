-- Bunny Girl Hub Version
local VERSION = "1.0.0"

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua")
)()

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

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

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
	Main = Window:AddTab({ Title = "Main", Icon = "home" }),
	Eggs = Window:AddTab({ Title = "Eggs", Icon = "egg" }),
	Food = Window:AddTab({ Title = "Food", Icon = "utensils" }),
	Lottery = Window:AddTab({ Title = "Lottery", Icon = "ticket" }),
	Trade = Window:AddTab({ Title = "Trade", Icon = "repeat" }),
	Webhook = Window:AddTab({ Title = "Webhook", Icon = "send" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local Options = Fluent.Options

do
	Tabs.Main:AddParagraph({
		Title = "Paragraph",
		Content = "This is a paragraph.\nSecond line!",
	})

	Tabs.Main:AddButton({
		Title = "Button",
		Description = "Very important button",
		Callback = function()
			Window:Dialog({
				Title = "Title",
				Content = "This is a dialog",
				Buttons = {
					{
						Title = "Confirm",
						Callback = function()
							print("Confirmed the dialog.")
						end,
					},
					{
						Title = "Cancel",
						Callback = function()
							print("Cancelled the dialog.")
						end,
					},
				},
			})
		end,
	})

	local Toggle = Tabs.Main:AddToggle("MyToggle", { Title = "Toggle", Default = false })

	Toggle:OnChanged(function()
		print("Toggle changed:", Options.MyToggle.Value)
	end)

	Options.MyToggle:SetValue(false)

	local Slider = Tabs.Main:AddSlider("Slider", {
		Title = "Slider",
		Description = "This is a slider",
		Default = 2,
		Min = 0,
		Max = 5,
		Rounding = 1,
		Callback = function(Value)
			print("Slider was changed:", Value)
		end,
	})

	Slider:OnChanged(function(Value)
		print("Slider changed:", Value)
	end)

	Slider:SetValue(3)

	local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
		Title = "Dropdown",
		Values = {
			"one",
			"two",
			"three",
			"four",
			"five",
			"six",
			"seven",
			"eight",
			"nine",
			"ten",
			"eleven",
			"twelve",
			"thirteen",
			"fourteen",
		},
		Multi = false,
		Default = 1,
	})

	Dropdown:SetValue("four")

	Dropdown:OnChanged(function(Value)
		print("Dropdown changed:", Value)
	end)

	local MultiDropdown = Tabs.Main:AddDropdown("MultiDropdown", {
		Title = "Dropdown",
		Description = "You can select multiple values.",
		Values = {
			"one",
			"two",
			"three",
			"four",
			"five",
			"six",
			"seven",
			"eight",
			"nine",
			"ten",
			"eleven",
			"twelve",
			"thirteen",
			"fourteen",
		},
		Multi = true,
		Default = { "seven", "twelve" },
	})

	MultiDropdown:SetValue({
		three = true,
		five = true,
		seven = false,
	})

	MultiDropdown:OnChanged(function(Value)
		local Values = {}
		for Value, State in next, Value do
			table.insert(Values, Value)
		end
		print("Mutlidropdown changed:", table.concat(Values, ", "))
	end)

	local Colorpicker = Tabs.Main:AddColorpicker("Colorpicker", {
		Title = "Colorpicker",
		Default = Color3.fromRGB(96, 205, 255),
	})

	Colorpicker:OnChanged(function()
		print("Colorpicker changed:", Colorpicker.Value)
	end)

	Colorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

	local TColorpicker = Tabs.Main:AddColorpicker("TransparencyColorpicker", {
		Title = "Colorpicker",
		Description = "but you can change the transparency.",
		Transparency = 0,
		Default = Color3.fromRGB(96, 205, 255),
	})

	TColorpicker:OnChanged(function()
		print("TColorpicker changed:", TColorpicker.Value, "Transparency:", TColorpicker.Transparency)
	end)

	local Keybind = Tabs.Main:AddKeybind("Keybind", {
		Title = "KeyBind",
		Mode = "Toggle", -- Always, Toggle, Hold
		Default = "LeftControl", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

		-- Occurs when the keybind is clicked, Value is `true`/`false`
		Callback = function(Value)
			print("Keybind clicked!", Value)
		end,

		-- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
		ChangedCallback = function(New)
			print("Keybind changed!", New)
		end,
	})

	-- OnClick is only fired when you press the keybind and the mode is Toggle
	-- Otherwise, you will have to use Keybind:GetState()
	Keybind:OnClick(function()
		print("Keybind clicked:", Keybind:GetState())
	end)

	Keybind:OnChanged(function()
		print("Keybind changed:", Keybind.Value)
	end)

	task.spawn(function()
		while true do
			wait(1)

			-- example for checking if a keybind is being pressed
			local state = Keybind:GetState()
			if state then
				print("Keybind is being held down")
			end

			if Fluent.Unloaded then
				break
			end
		end
	end)

	Keybind:SetValue("MB2", "Toggle") -- Sets keybind to MB2, mode to Hold

	local Input = Tabs.Main:AddInput("Input", {
		Title = "Input",
		Default = "Default",
		Placeholder = "Placeholder",
		Numeric = false, -- Only allows numbers
		Finished = false, -- Only calls callback when you press enter
		Callback = function(Value)
			print("Input changed:", Value)
		end,
	})

	Input:OnChanged(function()
		print("Input updated:", Input.Value)
	end)
end

-- Auto Tab Content - Build A Zoo Egg Buyer Integration
do
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local RunService = game:GetService("RunService")

	-- Helper function to get LocalPlayer (with wait if needed)
	local function getLocalPlayer()
		local player = game.Players.LocalPlayer
		if not player then
			-- Wait for LocalPlayer to be available
			local attempts = 0
			while not player and attempts < 50 do
				task.wait(0.1)
				player = game.Players.LocalPlayer
				attempts = attempts + 1
			end
		end
		return player
	end

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

	-- Helper function to get player's assigned island name
	local function getPlayerIslandName()
		local LocalPlayer = getLocalPlayer()
		if not LocalPlayer then
			return nil
		end

		-- Wait for assigned island if not set yet (matching decompiled game code)
		local assignedIsland = LocalPlayer:GetAttribute("AssignedIslandName")
		if not assignedIsland then
			-- Try waiting for it (with timeout to avoid infinite wait)
			local attempts = 0
			while not assignedIsland and attempts < 50 do
				task.wait(0.1)
				assignedIsland = LocalPlayer:GetAttribute("AssignedIslandName")
				attempts = attempts + 1
			end
		end

		return assignedIsland
	end

	-- Helper function to check if an island folder belongs to the player
	local function isPlayerIsland(islandFolder)
		if not islandFolder then
			return false
		end

		local playerIslandName = getPlayerIslandName()
		if not playerIslandName then
			return false -- Can't determine, so return false to be safe
		end

		-- Primary check: folder name matches AssignedIslandName (e.g., "Island_3" == "Island_3")
		if islandFolder.Name == playerIslandName then
			return true
		end

		-- Secondary check: Compare AssignedIslandName with IslandID attribute
		-- This matches the decompiled game code logic
		local islandID = islandFolder:GetAttribute("IslandID")
		if islandID and islandID == playerIslandName then
			return true
		end

		return false
	end

	local Section = Tabs.Eggs:AddSection("Auto Buy Egg")

	-- Select Eggs: multi dropdown
	local SelectEggs = Section:AddDropdown("SelectEggs", {
		Title = "Select Eggs",
		Values = {
			"BoneDragonEgg",
			"UltraEgg",
			"UnicornProEgg",
			"SaberCubEgg",
			"GeneralKongEgg",
			"GodzillaEgg",
			"MetroGiraffeEgg",
			"BiteForceSharkEgg",
		},
		Multi = true,
		Default = { "GeneralKongEgg", "GodzillaEgg" },
	})

	-- Select Mutations: multi dropdown
	local SelectMutations = Section:AddDropdown("SelectMutations", {
		Title = "Select Mutations",
		Values = { "Golden", "Diamond", "Fire", "Electric", "Dino", "Snow", "Halloween" },
		Multi = true,
		Default = { "Snow", "Halloween" },
	})

	-- Auto Buy Egg: toggle
	local AutoBuyEgg = Section:AddToggle("AutoBuyEgg", {
		Title = "Auto Buy Egg",
		Description = "Automatically buy the selected eggs",
		Default = false,
	})

	-- Update filters when dropdowns change
	SelectEggs:OnChanged(function()
		print("Selected eggs changed")
	end)

	SelectMutations:OnChanged(function()
		print("Selected mutations changed")
	end)

	-- Helper function to find player's island folder
	local function findPlayerIslandFolder(eggsFolder)
		local playerIslandName = getPlayerIslandName()
		if not playerIslandName then
			return nil
		end

		-- Try to find island by IslandID attribute first
		for _, islandFolder in pairs(eggsFolder:GetChildren()) do
			if islandFolder.Name:match("Island_%d+") then
				if isPlayerIsland(islandFolder) then
					return islandFolder
				end
			end
		end

		-- Fallback: try to find by name directly
		local islandFolder = eggsFolder:FindFirstChild(playerIslandName)
		if islandFolder then
			return islandFolder
		end

		return nil
	end

	-- Egg detection function - ONLY scans player's island
	local function findEggsInReplicatedStorage()
		local eggs = {}
		local eggsFolder = ReplicatedStorage:FindFirstChild("Eggs")
		if not eggsFolder then
			return eggs
		end

		-- Only find eggs from player's assigned island
		local playerIslandFolder = findPlayerIslandFolder(eggsFolder)
		if not playerIslandFolder then
			return eggs
		end

		for _, eggObject in pairs(playerIslandFolder:GetChildren()) do
			local uid = eggObject:GetAttribute("UID")
			local mutation = eggObject:GetAttribute("M")
			local eggType = eggObject:GetAttribute("T")

			if uid or eggObject.Name:match("^[a-f0-9]+$") then
				table.insert(eggs, {
					id = uid or eggObject.Name,
					name = tostring(eggType or eggObject.Name),
					mutation = tostring(mutation or "None"),
					island = playerIslandFolder.Name,
					object = eggObject,
				})
			end
		end

		return eggs
	end

	-- Filter matching function
	local function findMatchingEggs()
		local matchingEggs = {}
		local selectedEggs = {}
		local selectedMutations = {}

		-- Get selected eggs
		for egg, state in next, Options.SelectEggs.Value do
			if state then
				table.insert(selectedEggs, egg)
			end
		end

		-- Get selected mutations
		for mutation, state in next, Options.SelectMutations.Value do
			if state then
				table.insert(selectedMutations, mutation)
			end
		end

		-- Check each detected egg
		for _, eggInfo in pairs(eggBuyerState.eggData.conveyorEggs) do
			local eggMatches = false
			local mutationMatches = false

			-- Check if egg name matches
			for _, selectedEgg in pairs(selectedEggs) do
				if tostring(eggInfo.name):lower() == tostring(selectedEgg):lower() then
					eggMatches = true
					break
				end
			end

			-- Check if mutation matches
			for _, selectedMutation in pairs(selectedMutations) do
				if tostring(eggInfo.mutation):lower() == tostring(selectedMutation):lower() then
					mutationMatches = true
					break
				end
			end

			if eggMatches and mutationMatches then
				table.insert(matchingEggs, eggInfo)
			end
		end

		return matchingEggs
	end

	-- Purchase function
	local function attemptPurchaseEgg(eggInfo)
		local remote = ReplicatedStorage:FindFirstChild("Remote")
		if remote then
			local characterRemote = remote:FindFirstChild("CharacterRE")
			if characterRemote then
				local success, error = pcall(function()
					characterRemote:FireServer("BuyEgg", eggInfo.id)
				end)

				if success then
					print("✅ Purchase attempt sent for: " .. eggInfo.name .. " (" .. eggInfo.mutation .. ")")
					table.insert(eggBuyerState.eggData.purchasedEggs, {
						id = eggInfo.id,
						name = eggInfo.name,
						mutation = eggInfo.mutation,
						timestamp = os.time(),
						timeString = os.date("%H:%M:%S"),
					})
					return true
				else
					print("❌ Purchase failed: " .. tostring(error))
				end
			end
		end
		return false
	end

	-- Set up streaming for player's island ONLY
	local function setupPlayerIslandStreaming(islandFolder)
		-- Only set up if this is the player's island
		if not isPlayerIsland(islandFolder) then
			return
		end

		-- Listen for new eggs being added to this island
		local eggConnection = islandFolder.ChildAdded:Connect(function(eggObject)
			if Fluent.Unloaded then
				return
			end

			wait(0.1) -- Small delay to ensure attributes are set

			local uid = eggObject:GetAttribute("UID")
			local mutation = eggObject:GetAttribute("M")
			local eggType = eggObject:GetAttribute("T")

			if uid or eggObject.Name:match("^[a-f0-9]+$") then
				local eggInfo = {
					id = uid or eggObject.Name,
					name = tostring(eggType or eggObject.Name),
					mutation = tostring(mutation or "None"),
					island = islandFolder.Name,
					object = eggObject,
				}

				table.insert(eggBuyerState.eggData.conveyorEggs, eggInfo)

				-- print("🥚 New egg detected: " .. eggInfo.name .. " (" .. eggInfo.mutation .. ") on " .. eggInfo.island)

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
		local eggRemovedConnection = islandFolder.ChildRemoved:Connect(function(eggObject)
			if Fluent.Unloaded then
				return
			end

			for i, eggInfo in pairs(eggBuyerState.eggData.conveyorEggs) do
				if eggInfo.object == eggObject then
					table.remove(eggBuyerState.eggData.conveyorEggs, i)
					-- print("🥚 Egg removed: " .. eggInfo.name)
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

		-- Find or wait for Eggs folder
		local eggsFolder = ReplicatedStorage:FindFirstChild("Eggs")
		if not eggsFolder then
			eggsFolder = ReplicatedStorage:WaitForChild("Eggs", 10)
			if not eggsFolder then
				print("❌ Eggs folder not found!")
				return
			end
		end

		-- Get player's assigned island name
		local playerIslandName = getPlayerIslandName()
		if not playerIslandName then
			print("❌ Could not determine your assigned island!")
			return
		end

		print("🚀 Starting event-based egg streaming for YOUR island: " .. tostring(playerIslandName))

		-- Find and set up streaming ONLY for player's island folder
		local playerIslandFolder = findPlayerIslandFolder(eggsFolder)
		if playerIslandFolder then
			print("   📡 Monitoring " .. playerIslandFolder.Name)
			setupPlayerIslandStreaming(playerIslandFolder)
		else
			print("   ⚠️ Your island folder not found yet, will retry...")
			-- Try to wait for it or check periodically
			local attempts = 0
			task.spawn(function()
				while not playerIslandFolder and attempts < 50 and not Fluent.Unloaded do
					task.wait(0.5)
					playerIslandFolder = findPlayerIslandFolder(eggsFolder)
					if playerIslandFolder then
						print("   📡 Found and monitoring " .. playerIslandFolder.Name)
						setupPlayerIslandStreaming(playerIslandFolder)
						break
					end
					attempts = attempts + 1
				end
			end)
		end

		-- Listen for player's island being added (if not present yet)
		local islandConnection = eggsFolder.ChildAdded:Connect(function(islandFolder)
			if Fluent.Unloaded then
				return
			end
			if islandFolder.Name:match("Island_%d+") and isPlayerIsland(islandFolder) then
				print("   📡 Your island detected: " .. islandFolder.Name)
				setupPlayerIslandStreaming(islandFolder)
			end
		end)

		table.insert(eggBuyerState.connections, islandConnection)

		-- Initial scan
		eggBuyerState.eggData.conveyorEggs = findEggsInReplicatedStorage()

		print("✅ Egg streaming active for your island only!")
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

		print("🛑 Egg monitoring stopped!")
	end

	-- Connect auto buy toggle
	AutoBuyEgg:OnChanged(function(Value)
		if Value then
			startEggMonitoring()
			Fluent:Notify({
				Title = "Auto Buy Enabled",
				Content = "Automatically purchasing selected eggs from your island",
				Duration = 3,
			})
		else
			stopEggMonitoring()
			Fluent:Notify({
				Title = "Auto Buy Disabled",
				Content = "Stopped auto-purchasing eggs",
				Duration = 3,
			})
		end
	end)

	-- Add status section
	local StatusSection = Tabs.Eggs:AddSection("Status")

	StatusSection:AddButton({
		Title = "Start Monitoring",
		Description = "Begin monitoring for eggs",
		Callback = function()
			startEggMonitoring()
			-- Fluent:Notify({
			--     Title = "Monitoring Started",
			--     Content = "Now scanning for eggs",
			--     Duration = 3
			-- })
		end,
	})

	StatusSection:AddButton({
		Title = "Stop Monitoring",
		Description = "Stop monitoring for eggs",
		Callback = function()
			stopEggMonitoring()
			-- Fluent:Notify({
			--     Title = "Monitoring Stopped",
			--     Content = "Stopped scanning for eggs",
			--     Duration = 3
			-- })
		end,
	})

	StatusSection:AddButton({
		Title = "Scan Now",
		Description = "Force scan for available eggs",
		Callback = function()
			eggBuyerState.eggData.conveyorEggs = findEggsInReplicatedStorage()
			local eggs = eggBuyerState.eggData.conveyorEggs
			local matching = findMatchingEggs()
			-- Fluent:Notify({
			--     Title = "Scan Complete",
			--     Content = string.format("Found %d eggs, %d matching filters", #eggs, #matching),
			--     Duration = 5
			-- })
		end,
	})

	StatusSection:AddButton({
		Title = "Show Purchased Eggs",
		Description = "Display recently purchased eggs",
		Callback = function()
			local purchased = eggBuyerState.eggData.purchasedEggs
			local message = ""
			if #purchased > 0 then
				for i, egg in pairs(purchased) do
					message = message .. egg.name .. " (" .. egg.mutation .. ") - " .. egg.timeString
					if i < #purchased then
						message = message .. "\n"
					end
				end
			else
				message = "No eggs purchased yet"
			end

			Fluent:Notify({
				Title = "Purchased Eggs",
				Content = message,
				Duration = 8,
			})
		end,
	})

	StatusSection:AddButton({
		Title = "Show My Island",
		Description = "Display your assigned island name",
		Callback = function()
			local islandName = getPlayerIslandName()
			if islandName then
				Fluent:Notify({
					Title = "Your Island",
					Content = "Assigned Island: " .. tostring(islandName),
					Duration = 5,
				})
			else
				Fluent:Notify({
					Title = "Island Not Found",
					Content = "Could not determine your assigned island. Try again later.",
					Duration = 5,
				})
			end
		end,
	})

	-- Don't auto-start monitoring - let the toggle control it
	-- startEggMonitoring()

	-- Cleanup when Fluent is unloaded
	task.spawn(function()
		while not Fluent.Unloaded do
			task.wait(0.1)
		end
		-- Fluent was closed, clean up all connections
		stopEggMonitoring()
	end)
end

-- Lottery Tab Content
do
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer

	-- Define available codes
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
		"DS5523YSQ3C",
		"ADQZP3MBW6N",
		"ZTWPH3WW8SJ",
	}

	-- Function to get current lottery ticket count
	local function getLotteryTicketCount()
		local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
		local Data = PlayerGui:FindFirstChild("Data")
		if Data then
			local Asset = Data:FindFirstChild("Asset")
			if Asset then
				return Asset:GetAttribute("LotteryTicket") or 0
			end
		end
		return 0
	end

	-- Function to check if code is already redeemed
	local function isCodeRedeemed(code)
		local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
		local Data = PlayerGui:FindFirstChild("Data")
		if Data then
			local UserFlag = Data:FindFirstChild("UserFlag")
			if UserFlag then
				local attributeName = "RC_" .. code
				local attributeValue = UserFlag:GetAttribute(attributeName)
				return attributeValue == true
			end
		end
		return false
	end

	-- Function to redeem a single code
	local function redeemCode(code)
		local args = {
			[1] = {
				["event"] = "usecode",
				["code"] = code,
			},
		}
		ReplicatedStorage.Remote.RedemptionCodeRE:FireServer(unpack(args))
	end

	-- Function to use lottery tickets
	local function useLotteryTickets(count)
		local args = {
			[1] = {
				["event"] = "lottery",
				["count"] = count,
			},
		}
		ReplicatedStorage.Remote.LotteryRE:FireServer(unpack(args))
	end

	-- Add Redeem All Codes button
	Tabs.Lottery:AddButton({
		Title = "Redeem All Codes",
		Description = "Redeem all unredeemed lottery codes",
		Callback = function()
			local redeemed = 0
			local skipped = 0
			for _, code in ipairs(lotteryCodes) do
				if not isCodeRedeemed(code) then
					pcall(function()
						redeemCode(code)
						redeemed = redeemed + 1
						task.wait(0.1)
					end)
				else
					skipped = skipped + 1
				end
			end
			Fluent:Notify({
				Title = "Codes Redeemed",
				Content = string.format("Redeemed %d codes, skipped %d already redeemed", redeemed, skipped),
				Duration = 5,
			})
		end,
	})

	-- Add Use All Tickets button
	Tabs.Lottery:AddButton({
		Title = "Use All Tickets",
		Description = "Use all lottery tickets efficiently (10s, 3s, then 1s)",
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

-- Food Tab Content - Auto Buy Food Integration
do
	print("🚀🚀🚀 STARTING AUTO BUY FOOD INTEGRATION 🚀🚀🚀")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	print("✅ ReplicatedStorage retrieved")

	-- Load food config from ResPetFood
	local foodConfig = {}
	local foodNames = {}

	local function loadFoodConfig()
		local success, config = pcall(function()
			local configFolder = ReplicatedStorage:FindFirstChild("Config")
			if configFolder then
				local resPetFood = configFolder:FindFirstChild("ResPetFood")
				if resPetFood then
					-- If it's a ModuleScript, require it
					if resPetFood:IsA("ModuleScript") then
						return require(resPetFood)
					end
				end
			end
			return nil
		end)

		if success and config then
			foodConfig = config
			-- Extract food names from config
			foodNames = {} -- Clear existing list
			for foodName, foodData in pairs(config) do
				if type(foodData) == "table" and foodData.ID then
					table.insert(foodNames, foodName)
				end
			end
			-- Sort food names alphabetically
			table.sort(foodNames)
			return true
		end

		-- Fallback: try to wait for it
		local configFolder = ReplicatedStorage:WaitForChild("Config", 5)
		if configFolder then
			local resPetFood = configFolder:WaitForChild("ResPetFood", 5)
			if resPetFood and resPetFood:IsA("ModuleScript") then
				local success2, config2 = pcall(function()
					return require(resPetFood)
				end)
				if success2 and config2 then
					foodConfig = config2
					foodNames = {} -- Clear existing list
					for foodName, foodData in pairs(config2) do
						if type(foodData) == "table" and foodData.ID then
							table.insert(foodNames, foodName)
						end
					end
					table.sort(foodNames)
					return true
				end
			end
		end

		return false
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
		local Players = game:GetService("Players")
		local LocalPlayer = Players.LocalPlayer

		if not LocalPlayer then
			warn("⚠️ LocalPlayer not found, waiting...")
			task.wait(1)
			LocalPlayer = Players.LocalPlayer
			if not LocalPlayer then
				warn("❌ Could not get LocalPlayer for FoodStore listener")
				return
			end
		end

		local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
		if not PlayerGui then
			warn("❌ PlayerGui not found")
			return
		end

		local Data = PlayerGui:WaitForChild("Data", 10)
		if not Data then
			warn("❌ Data folder not found")
			return
		end

		local FoodStore = Data:WaitForChild("FoodStore", 10)
		if not FoodStore then
			warn("❌ FoodStore Configuration not found")
			return
		end

		print("✅ FoodStore Configuration found, setting up attribute listener...")

		-- Listen for V attribute changes (store refresh)
		foodBuyerState.foodStoreConnection = FoodStore:GetAttributeChangedSignal("V"):Connect(function()
			local newValue = FoodStore:GetAttribute("V")
			print("🔄 FoodStore V attribute changed to: " .. tostring(newValue))
			buySelectedFoods()
		end)

		print("✅ FoodStore attribute listener connected - will buy on store refresh!")

		-- Also buy immediately if auto-buy is already enabled
		if Options.AutoBuyFood.Value then
			task.wait(0.5) -- Small delay to ensure everything is ready
			buySelectedFoods()
		end
	end

	-- Purchase food function
	local function attemptPurchaseFood(foodName, quantity)
		local remote = ReplicatedStorage:FindFirstChild("Remote")
		if remote then
			local foodStoreRE = remote:FindFirstChild("FoodStoreRE")
			if foodStoreRE then
				local success = true
				local purchaseCount = 0

				-- Buy quantity times (if remote doesn't accept quantity parameter)
				for i = 1, quantity do
					local success2, error = pcall(function()
						foodStoreRE:FireServer(foodName)
					end)

					if success2 then
						purchaseCount = purchaseCount + 1
					else
						success = false
						print("❌ Food purchase failed: " .. tostring(error))
						break
					end

					-- Small delay between purchases to avoid spam
					if i < quantity then
						task.wait(0.1)
					end
				end

				if success and purchaseCount > 0 then
					local timeString = os.date("%H:%M:%S")
					table.insert(foodBuyerState.purchasedFoods, {
						food = foodName,
						quantity = purchaseCount,
						timestamp = os.time(),
						timeString = timeString,
					})
					-- print("✅ Purchased " .. purchaseCount .. "x " .. foodName .. " at " .. timeString)
					return true
				end
			else
				print("❌ FoodStoreRE remote not found")
			end
		else
			print("❌ Remote folder not found")
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
						-- If config is loaded and has data, verify food exists in it; otherwise trust the selection
						local configEmpty = not foodConfig or next(foodConfig) == nil
						if configEmpty or foodConfig[foodName] then
							table.insert(selectedFoods, foodName)
						end
					end
				end
			else
				-- Handle case where it might be a string (single selection fallback)
				if foodConfig[tostring(foodValue)] then
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

		print("🔄 FoodStore refreshed! Purchasing selected foods...")
		for _, foodName in pairs(selectedFoods) do
			if foodConfig[foodName] then
				local foodData = foodConfig[foodName]
				local quantity = foodData.SellStock2 or 1
				-- print("🛒 Purchasing " .. quantity .. "x " .. foodName)
				attemptPurchaseFood(foodName, quantity)
			end
		end
	end

	-- Setup FoodStore listener when auto-buy is enabled
	local function startAutoBuyLoop()
		print("🔄 Auto-buy enabled - FoodStore listener will handle purchases on refresh")

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
		print("🛑 stopAutoBuyLoop called")
		-- Disconnect FoodStore listener if connected
		if foodBuyerState.foodStoreConnection then
			foodBuyerState.foodStoreConnection:Disconnect()
			foodBuyerState.foodStoreConnection = nil
			print("🛑 FoodStore listener disconnected")
		end
	end

	-- Load food config BEFORE creating the dropdown
	print("📦 Loading food config...")
	if loadFoodConfig() then
		print("✅ Food config loaded: " .. #foodNames .. " foods found")
	else
		warn("⚠️ Could not load food config from ResPetFood. Retrying...")
		task.wait(2)
		if loadFoodConfig() then
			print("✅ Food config loaded (retry): " .. #foodNames .. " foods found")
		else
			warn("❌ Failed to load food config. Using fallback list.")
			-- Fallback: use food names from buy_food.lua
			foodNames = {
				"Strawberry",
				"Blueberry",
				"Watermelon",
				"Apple",
				"Orange",
				"Corn",
				"Banana",
				"Grape",
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
			}
			print("⚠️ Using fallback food list with " .. #foodNames .. " foods")
		end
	end

	if #foodNames == 0 then
		warn("❌ No food names available! Cannot create food dropdown.")
		return
	end

	-- Create Auto Buy Food section
	print("📦 Creating Auto Buy Food section...")
	if not Tabs or not Tabs.Food then
		warn("❌ Tabs.Food does not exist! Cannot create Auto Buy Food section.")
		return
	end
	local FoodSection = Tabs.Food:AddSection("Auto Buy Food")
	print("✅ Auto Buy Food section created")

	-- Select Food: multi dropdown
	-- Default to empty - SaveManager will automatically restore saved values when config loads
	-- This matches the pattern used by Auto Buy Egg section
	local SelectFood = FoodSection:AddDropdown("SelectFood", {
		Title = "Select Food",
		Description = "Choose which foods to auto-buy (multiple selections allowed)",
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
		}, -- SaveManager will restore saved selections automatically
	})

	print("✅ SelectFood dropdown created with " .. #foodNames .. " foods")
	print("📝 SaveManager will restore saved selections when config loads")

	-- Auto Buy Food: toggle
	local AutoBuyFood = FoodSection:AddToggle("AutoBuyFood", {
		Title = "Auto Buy Food",
		Description = "Automatically buy selected food every 5 minutes",
		Default = false,
	})

	print("✅ AutoBuyFood toggle created")

	-- Connect auto buy toggle (same pattern as Auto Buy Egg)
	print("🔗 Connecting AutoBuyFood OnChanged callback...")
	AutoBuyFood:OnChanged(function(Value)
		print("🔔 AutoBuyFood toggle changed to: " .. tostring(Value))

		local success, err = pcall(function()
			if Value then
				print("✅ Toggle is ON, getting selected foods...")
				print("🔍 Checking loopTask state: " .. tostring(foodBuyerState.loopTask))
				local selectedFoods = getSelectedFoods()
				print("📋 Found " .. #selectedFoods .. " selected foods")

				if #selectedFoods == 0 then
					print("⚠️ No food selected! Details:")
					print("  - Options.SelectFood exists: " .. tostring(Options.SelectFood ~= nil))
					if Options.SelectFood then
						print("  - SelectFood.Value type: " .. type(Options.SelectFood.Value))
						print("  - SelectFood.Value: " .. tostring(Options.SelectFood.Value))
					end
					Fluent:Notify({
						Title = "No Food Selected",
						Content = "Please select at least one food first",
						Duration = 3,
					})
					Options.AutoBuyFood:SetValue(false)
					return
				end

				print("🔄 Starting auto buy loop...")
				print("🔍 loopTask before start: " .. tostring(foodBuyerState.loopTask))
				startAutoBuyLoop()
				print("🔍 loopTask after start: " .. tostring(foodBuyerState.loopTask))
				local foodList = table.concat(selectedFoods, ", ")
				-- Fluent:Notify({
				--     Title = "Auto Buy Enabled",
				--     Content = "Automatically purchasing " .. foodList .. " every 5 minutes",
				--     Duration = 3
				-- })
				print("✅ Auto buy loop started, notification sent")
			else
				print("🛑 Toggle is OFF, stopping loop...")
				print("🔍 loopTask before stop: " .. tostring(foodBuyerState.loopTask))
				stopAutoBuyLoop()
				print("🔍 loopTask after stop: " .. tostring(foodBuyerState.loopTask))
				Fluent:Notify({
					Title = "Auto Buy Disabled",
					Content = "Stopped auto-purchasing food",
					Duration = 3,
				})
				print("✅ Loop stopped, notification sent")
			end
		end)

		if not success then
			warn("❌ ERROR in AutoBuyFood OnChanged: " .. tostring(err))
			warn(debug.traceback())
		end
	end)
	print("✅ AutoBuyFood OnChanged callback connected")

	-- Backup: Monitor toggle state periodically in case OnChanged doesn't fire
	task.spawn(function()
		task.wait(2) -- Wait for SaveManager to load
		local lastToggleState = nil

		while not Fluent.Unloaded do
			task.wait(0.5) -- Check every 0.5 seconds

			local currentToggleState = Options.AutoBuyFood.Value

			-- If toggle changed from false to true, and no loop is running, start it
			if currentToggleState == true and lastToggleState == false and not foodBuyerState.loopTask then
				print("🔄 BACKUP: Detected toggle ON but no loop running, starting loop...")
				local selectedFoods = getSelectedFoods()
				if #selectedFoods > 0 then
					startAutoBuyLoop()
					print("✅ BACKUP: Loop started via backup mechanism")
				else
					print("⚠️ BACKUP: No foods selected, cannot start loop")
				end
			end

			-- If toggle changed from true to false, make sure loop is stopped
			if currentToggleState == false and lastToggleState == true and foodBuyerState.loopTask then
				print("🛑 BACKUP: Detected toggle OFF but loop still running, stopping...")
				stopAutoBuyLoop()
			end

			lastToggleState = currentToggleState
		end
	end)

	-- Setup FoodStore listener on script load
	task.spawn(function()
		task.wait(2) -- Wait for player to load
		setupFoodStoreListener()
	end)

	-- Cleanup when Fluent is unloaded
	task.spawn(function()
		while not Fluent.Unloaded do
			task.wait(0.1)
		end
		stopAutoBuyLoop()
	end)
	print("✅✅✅ AUTO BUY FOOD INTEGRATION COMPLETE ✅✅✅")
end

-- Trade Tab Content - Auto Trading
do
	print("🔄 STARTING AUTO TRADE INTEGRATION 🔄")

	-- Store references to global functions to avoid shadowing issues
	local pairs = pairs
	local tostring = tostring
	local type = type
	local table = table

	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer

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

	-- Wait for dependencies
	local Shared, Pet, Format, ResMutate, TradeRE
	local dependenciesLoaded = false

	task.spawn(function()
		local success, err = pcall(function()
			print("⏳ [Auto Trade] Loading dependencies...")

			-- Load required modules
			Shared = require(ReplicatedStorage:WaitForChild("Shared", 10))
			print("✅ [Auto Trade] Shared loaded")

			Pet = Shared("Pet")
			print("✅ [Auto Trade] Pet loaded")

			Format = Shared("Format")
			print("✅ [Auto Trade] Format loaded")

			ResMutate = require(ReplicatedStorage:WaitForChild("Config", 10):WaitForChild("ResMutate", 10))
			print("✅ [Auto Trade] ResMutate loaded")

			TradeRE = ReplicatedStorage:WaitForChild("Remote", 10):WaitForChild("TradeRE", 10)
			print("✅ [Auto Trade] TradeRE loaded")

			dependenciesLoaded = true
			print("✅ [Auto Trade] All dependencies loaded!")
		end)

		if not success then
			print("❌ [Auto Trade] Failed to load: " .. tostring(err))
			Fluent:Notify({
				Title = "Auto Trade Error",
				Content = tostring(err),
				Duration = 5,
			})
		end
	end)

	-- Helper Functions
	local function getPetValue(petData)
		if not petData or not Pet then
			return 0
		end
		return Pet:GetPetProduce(petData, 1) or 0
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

	local function formatNumber(num)
		if not Format then
			return tostring(num)
		end
		return Format:Number2String(num, "en")
	end

	-- Function to request a new trade
	local function requestTrade()
		if not dependenciesLoaded or not TradeRE then
			print("⚠️ [Auto Trade] Cannot request - dependencies not loaded")
			return
		end
		if not autoTradeState.enabled then
			print("⚠️ [Auto Trade] Cannot request - auto trade disabled")
			return
		end
		TradeRE:FireServer({ event = "reqtrade" })
		print("🔄 [Auto Trade] Trade requested")
		Fluent:Notify({
			Title = "Trade Request",
			Content = "Requesting trade...",
			Duration = 2,
		})
	end

	-- Helper function to get table keys as strings
	local function getKeys(tbl)
		if not tbl or type(tbl) ~= "table" then
			return { "not a table" }
		end
		local keys = {}
		for k, v in pairs(tbl) do
			table.insert(keys, tostring(k))
		end
		return keys
	end

	-- Global webhook function for trade notifications
	local function sendWebhookNotification(content)
		if not Options.UrlInput or not Options.UrlInput.Value or Options.UrlInput.Value == "" then
			return false
		end

		local webhookUrl = Options.UrlInput.Value
		local data = {
			["content"] = content,
		}

		local success, err = pcall(function()
			local jsonData = game:GetService("HttpService"):JSONEncode(data)
			local response = request({
				Url = webhookUrl,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
				},
				Body = jsonData,
			})
		end)

		if success then
			print("✅ [Webhook] Notification sent")
			return true
		else
			print("❌ [Webhook] Failed to send: " .. tostring(err))
			return false
		end
	end

	-- Helper function to get key-value pairs as strings
	local function getKeyValues(tbl)
		if not tbl or type(tbl) ~= "table" then
			return { "not a table" }
		end
		local keyValuePairs = {}
		local success, err = pcall(function()
			for k, v in pairs(tbl) do
				local keyStr = tostring(k)
				local valStr
				local valSuccess, valErr = pcall(function()
					if type(v) == "table" then
						valStr = "[table]"
					else
						valStr = tostring(v)
					end
				end)
				if not valSuccess then
					valStr = "[error converting value]"
				end
				table.insert(keyValuePairs, keyStr .. ": " .. valStr)
			end
		end)
		if not success then
			return { "error iterating table: " .. tostring(err) }
		end
		return keyValuePairs
	end

	-- Trade Decision Logic
	local function handleTrade(tradeData)
		local success, err = pcall(function()
			if not tradeData then
				print("⚠️ [Auto Trade] No trade data received")
				return
			end

			if type(tradeData) ~= "table" then
				print("⚠️ [Auto Trade] Invalid trade data type: " .. type(tradeData))
				return
			end

			if not tradeData.data then
				-- This is likely a bargain response or other event, not a trade offer
				print("📨 [Auto Trade] Trade response received (not an offer)")
				if type(tradeData) == "table" then
					local keyVals = getKeyValues(tradeData)
					if keyVals and type(keyVals) == "table" then
						print("🔍 [Debug] Response data:", table.concat(keyVals, ", "))
					end
				end
				return
			end

			print("📨 [Auto Trade] Trade offer received")

			if not autoTradeState.enabled or not dependenciesLoaded then
				print("⚠️ [Auto Trade] Ignoring - auto trade disabled or not ready")
				return
			end

			local data = tradeData.data

			if not data.HoldPet or not data.TradePet then
				print("⚠️ [Auto Trade] Invalid trade data - missing HoldPet or TradePet")
				print("🔍 [Debug] data.HoldPet:", data.HoldPet)
				print("🔍 [Debug] data.TradePet:", data.TradePet)
				print("🔍 [Debug] data keys:", table.concat(getKeys(data), ", "))
				return
			end

			autoTradeState.currentTrade = data
			autoTradeState.tradeCount = autoTradeState.tradeCount + 1
			autoTradeState.lastTradeTime = os.time() -- Update last trade time
			print("📊 [Auto Trade] Evaluating trade #" .. autoTradeState.tradeCount)

			local playerPet = data.HoldPet
			local traderPets = data.TradePet
			local bargainTime = data.BargainTime or 0

			-- Auto-save held pet UID
			if playerPet and playerPet.UID then
				if Options.HeldPetUID and Options.HeldPetUID.Value ~= playerPet.UID then
					Options.HeldPetUID:SetValue(playerPet.UID)
					print("💾 [Auto Trade] Saved held pet UID: " .. playerPet.UID)
				end
			end

			local playerValue = getPetValue(playerPet)
			print(
				"💰 [Auto Trade] Your pet value: "
					.. formatNumber(playerValue)
					.. " (Type: "
					.. tostring(playerPet.T)
					.. ", Mutation: "
					.. tostring(playerPet.M)
					.. ")"
			)

			local traderValue = 0
			for i, pet in pairs(traderPets) do
				local petValue = getPetValue(pet)
				print(
					"💰 [Auto Trade] Trader pet #"
						.. i
						.. " value: "
						.. formatNumber(petValue)
						.. " (Type: "
						.. tostring(pet.T)
						.. ", Mutation: "
						.. tostring(pet.M)
						.. ")"
				)
				traderValue = traderValue + petValue
			end
			print("💰 [Auto Trade] Total trader value: " .. formatNumber(traderValue))

			local fairnessRatio = calculateFairnessRatio(playerPet, traderPets)
			print("📊 [Auto Trade] Fairness ratio: " .. string.format("%.1f%%", fairnessRatio * 100))

			-- Wait a bit to prevent spam
			task.wait(0.5)

			-- Check for auto-accept by pet name (highest priority)
			if Options.AutoAcceptPetNameToggle and Options.AutoAcceptPetNameToggle.Value then
				local selectedPetNames = Options.AutoAcceptPetName and Options.AutoAcceptPetName.Value or {}
				for i, pet in pairs(traderPets) do
					local petType = pet.T or pet:GetAttribute("T")
					for petName, isSelected in pairs(selectedPetNames) do
						if isSelected and tostring(petType):lower() == tostring(petName):lower() then
							print("✅ [Auto Trade] Auto-accepting pet by name: " .. petType)
							TradeRE:FireServer({ event = "accept" })
							autoTradeState.acceptedTrades = autoTradeState.acceptedTrades + 1

							-- Send webhook notification
							local webhookMsg = "✅ **Trade Accepted** (Pet Name)\n\n"
							webhookMsg = webhookMsg
								.. "**Your Pet:**\n- Type: "
								.. tostring(playerPet.T)
								.. "\n- Mutation: "
								.. tostring(playerPet.M)
								.. "\n- V: "
								.. formatNumber(tonumber(playerPet.V) or 0)
								.. "\n- Value: "
								.. formatNumber(playerValue)
								.. "\n\n"
							webhookMsg = webhookMsg .. "**Trader Pets:\n"
							for _, traderPet in pairs(traderPets) do
								webhookMsg = webhookMsg
									.. "- "
									.. tostring(traderPet.T)
									.. " ("
									.. tostring(traderPet.M)
									.. ") - V: "
									.. formatNumber(tonumber(traderPet.V) or 0)
									.. " - "
									.. formatNumber(getPetValue(traderPet))
									.. "\n"
							end
							webhookMsg = webhookMsg .. "\n**Reason:** Pet Name Match (" .. petType .. ")"
							sendWebhookNotification(webhookMsg)

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

					if traderType == playerType and traderMutation == playerMutation and traderV >= playerV then
						hasSamePet = true
						matchingPetUID = pet.UID
						break
					end
				end

				-- If same pet found, check if total trader value is more than player value
				if hasSamePet and traderValue > playerValue then
					print(
						"✅ [Auto Trade] Auto-accepting - trader offers "
							.. playerPet.T
							.. " ("
							.. playerPet.M
							.. ") + more value"
					)

					TradeRE:FireServer({ event = "accept" })
					autoTradeState.acceptedTrades = autoTradeState.acceptedTrades + 1

					-- Update held pet UID to the trader's pet UID
					if matchingPetUID and Options.HeldPetUID then
						Options.HeldPetUID:SetValue(matchingPetUID)
						print("💾 [Auto Trade] Updated held pet UID to received pet: " .. matchingPetUID)
					end

					-- Send webhook notification
					local webhookMsg = "✅ **Trade Accepted** (Same Pet + More Value)\n\n"
					webhookMsg = webhookMsg
						.. "**Your Pet:**\n- Type: "
						.. tostring(playerPet.T)
						.. "\n- Mutation: "
						.. tostring(playerPet.M)
						.. "\n- V: "
						.. formatNumber(tonumber(playerPet.V) or 0)
						.. "\n- Value: "
						.. formatNumber(playerValue)
						.. "\n\n"
					webhookMsg = webhookMsg .. "**Trader Pets:**\n"
					for _, traderPet in pairs(traderPets) do
						webhookMsg = webhookMsg
							.. "- "
							.. tostring(traderPet.T)
							.. " ("
							.. tostring(traderPet.M)
							.. ") - V: "
							.. formatNumber(tonumber(traderPet.V) or 0)
							.. " - "
							.. formatNumber(getPetValue(traderPet))
							.. "\n"
					end
					webhookMsg = webhookMsg
						.. "\n**Total Value Difference:** +"
						.. formatNumber(traderValue - playerValue)
					sendWebhookNotification(webhookMsg)

					return
				elseif hasSamePet then
					-- Check if trader only offered 1 pet (the same type+mutation)
					if #traderPets == 1 and bargainTime < 2 then
						print(
							"🎲 [Auto Trade] Trader offers only same pet ("
								.. playerPet.T
								.. ") - sending bargain request"
						)
						TradeRE:FireServer({ event = "bargain" })
						print("✅ [Auto Trade] Bargain event sent, waiting for server response...")
						return
					else
						print("⚠️ [Auto Trade] Trader offers same pet but no additional value - declining")
						-- Decline if more than 1 pet or bargain already used
						TradeRE:FireServer({ event = "decline" })
						autoTradeState.declinedTrades = autoTradeState.declinedTrades + 1
						return
					end
				end
			end

			-- Check fairness threshold and acceptance mode
			local minFairnessPercent = tonumber(
				Options.MinFairnessPercentage and Options.MinFairnessPercentage.Value or 0.9
			) or 0.9
			local acceptanceMode = Options.AcceptanceMode and Options.AcceptanceMode.Value or "Fairness Only"

			print(
				"📊 [Auto Trade] Final check - BargainTime: "
					.. tostring(bargainTime)
					.. ", Fairness: "
					.. string.format("%.1f%%", fairnessRatio * 100)
					.. ", Min: "
					.. string.format("%.1f%%", minFairnessPercent * 100)
					.. ", Mode: "
					.. acceptanceMode
			)

			-- Check if fairness passes
			local acceptByFairness = fairnessRatio >= minFairnessPercent

			-- Check if any pet meets high-value threshold
			local acceptByValue = false
			local acceptThreshold = tonumber(Options.AutoAcceptPetValue.Value) or 0
			local highValuePets = {} -- Track high-value pets for webhook
			if acceptThreshold > 0 then
				for i, pet in pairs(traderPets) do
					local petValue = getPetValue(pet)
					if petValue >= acceptThreshold then
						acceptByValue = true
						table.insert(highValuePets, {
							index = i,
							value = petValue,
							type = pet.T,
							mutation = pet.M,
						})
						print(
							"✅ [Auto Trade] High-value pet found #"
								.. i
								.. " ("
								.. formatNumber(petValue)
								.. " >= "
								.. formatNumber(acceptThreshold)
								.. ")"
						)
					end
				end
			end

			-- Send webhook notification if there are high-value pets
			if #highValuePets > 0 then
				local webhookMsg = "🚨 **High-Value Trade Alert** 🚨\n\n"
				webhookMsg = webhookMsg .. "**Your Pet:**\n"
				webhookMsg = webhookMsg .. "- Type: " .. tostring(playerPet.T) .. "\n"
				webhookMsg = webhookMsg .. "- Mutation: " .. tostring(playerPet.M) .. "\n"
				webhookMsg = webhookMsg .. "- Value: " .. formatNumber(playerValue) .. "\n\n"
				webhookMsg = webhookMsg .. "**Trader Offering:\n"
				for _, petInfo in pairs(highValuePets) do
					webhookMsg = webhookMsg
						.. "- Pet #"
						.. petInfo.index
						.. ": "
						.. tostring(petInfo.type)
						.. " ("
						.. tostring(petInfo.mutation)
						.. ") - **"
						.. formatNumber(petInfo.value)
						.. "**\n"
				end
				webhookMsg = webhookMsg .. "\nMode: " .. acceptanceMode
				sendWebhookNotification(webhookMsg)
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
					print(
						"🎲 [Auto Trade] Trade not accepted - attempting bargain (BargainTime: "
							.. tostring(bargainTime)
							.. ")"
					)
					TradeRE:FireServer({ event = "bargain" })
					print("✅ [Auto Trade] Bargain event sent, waiting for server response...")
					return
				end

				print(
					"❌ [Auto Trade] Trade not meeting acceptance criteria - Declining (Mode: "
						.. acceptanceMode
						.. ")"
				)
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

			if acceptByValue then
				print("✅ [Auto Trade] Accepting due to high-value pet")
			end

			-- Check if trader offers better value
			if Options.RequireBetterValue and Options.RequireBetterValue.Value then
				if traderValue < playerValue then
					print("❌ [Auto Trade] Trader value too low")
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
			end

			-- Accept trade
			print("✅ [Auto Trade] Accepting (Fairness: " .. string.format("%.1f%%", fairnessRatio * 100) .. ")")
			TradeRE:FireServer({ event = "accept" })
			autoTradeState.acceptedTrades = autoTradeState.acceptedTrades + 1

			-- Send webhook notification
			local acceptanceReason = acceptByValue and "Pet Value Only" or (acceptByFairness and "Fairness Only" or "Either")
			local webhookMsg = "✅ **Trade Accepted** (" .. acceptanceReason .. ")\n\n"
			webhookMsg = webhookMsg
				.. "**Your Pet:**\n- Type: "
				.. tostring(playerPet.T)
				.. "\n- Mutation: "
				.. tostring(playerPet.M)
				.. "\n- V: "
				.. formatNumber(tonumber(playerPet.V) or 0)
				.. "\n- Value: "
				.. formatNumber(playerValue)
				.. "\n\n"
			webhookMsg = webhookMsg .. "**Trader Pets:**\n"
			for _, traderPet in pairs(traderPets) do
				webhookMsg = webhookMsg
					.. "- "
					.. tostring(traderPet.T)
					.. " ("
					.. tostring(traderPet.M)
					.. ") - V: "
					.. formatNumber(tonumber(traderPet.V) or 0)
					.. " - "
					.. formatNumber(getPetValue(traderPet))
					.. "\n"
			end
			webhookMsg = webhookMsg
				.. "\n**Total Value Difference:** +"
				.. formatNumber(traderValue - playerValue)
				.. ", ("
				.. string.format("%.1f%%", fairnessRatio * 100)
				.. " fairness)"
			sendWebhookNotification(webhookMsg)

			-- Clear held pet UID after accepting trade (pet is now traded away)
			if Options.HeldPetUID then
				Options.HeldPetUID:SetValue("")
				print("🗑️ [Auto Trade] Cleared held pet UID (pet traded)")
			end
		end)

		if not success then
			print("❌ [Auto Trade] Error in handleTrade: " .. tostring(err))
			warn(err)
		end
	end

	-- Set up listener after handleTrade is defined
	task.spawn(function()
		while not dependenciesLoaded do
			task.wait(0.1)
		end

		if TradeRE then
			print("✅ [Auto Trade] Setting up trade listener")
			TradeRE.OnClientEvent:Connect(handleTrade)

			Fluent:Notify({
				Title = "Auto Trade Ready",
				Content = "Toggle ON then walk into trade zone",
				Duration = 4,
			})
		end
	end)

	-- Create Trade Tab UI
	local TradeSection = Tabs.Trade:AddSection("Auto Trade")

	local AutoTradeToggle = TradeSection:AddToggle("AutoTrade", {
		Title = "Enable Auto Trade",
		Description = "Automatically accept/decline trades based on criteria",
		Default = false,
	})

	AutoTradeToggle:OnChanged(function(value)
		print("🔄 [Auto Trade] Toggle changed to: " .. tostring(value))
		autoTradeState.enabled = value

		if value then
			if dependenciesLoaded then
				print("✅ [Auto Trade] Enabled - walk into trade zone with a pet")
				-- Fluent:Notify({
				--     Title = "Auto Trade ON",
				--     Content = "Walk into trade zone with a held pet",
				--     Duration = 4
				-- })
			else
				print("⚠️ [Auto Trade] Dependencies not ready")
				-- Fluent:Notify({
				--     Title = "Not Ready",
				--     Content = "Dependencies still loading, wait a moment",
				--     Duration = 3
				-- })
			end
		else
			-- print("❌ [Auto Trade] Disabled")
			-- Fluent:Notify({
			--     Title = "Auto Trade OFF",
			--     Content = "Trades will not be auto-managed",
			--     Duration = 3
			-- })
		end
	end)

	-- Initialize MinFairnessPercentage with default of 0.9 (90%)
	if not Options.MinFairnessPercentage then
		Options.MinFairnessPercentage = { Value = 0.9 }
	end

	local MinFairness = TradeSection:AddInput("MinFairness", {
		Title = "Min Fairness %",
		Description = "Minimum fairness ratio to accept trades (0-100)",
		Default = "200",
		Numeric = true,
		Finished = false,
		Placeholder = "100",
	})

	MinFairness:OnChanged(function(value)
		local numValue = tonumber(value) or 90
		-- Clamp value to 0-1000 range (allowing for values > 100%)
		numValue = math.max(0, math.min(1000, numValue))

		-- Update MinFairness in options to the 0-1000 value
		Options.MinFairness.Value = numValue

		-- Calculate MinFairnessPercentage (0-10 range for calculations, e.g., 200% = 2.0)
		Options.MinFairnessPercentage.Value = numValue / 100

		print(
			"📊 [MinFairness] Changed to: "
				.. tostring(numValue)
				.. "% (0-1: "
				.. string.format("%.2f", Options.MinFairnessPercentage.Value)
				.. ")"
		)
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
		print("💎 [AutoAcceptPetValue] Set to: " .. formatNumber(value))
	end)

	-- NEW: Auto Accept Same Type & Mutation Toggle
	local AutoAcceptSameMutation = TradeSection:AddToggle("AutoAcceptSameMutation", {
		Title = "Auto Accept Same Type & Mutation + More",
		Description = "Accept if trader offers same type+mutation pet AND more value",
		Default = false,
	})

	local RequireBetterValue = TradeSection:AddToggle("RequireBetterValue", {
		Title = "Require Better Value",
		Description = "Only accept if trader offers >= your pet value",
		Default = true,
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
		Placeholder = "ef1327451dd0459b904a3c7ae93ba486",
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
		local Players = game:GetService("Players")
		local LocalPlayer = Players.LocalPlayer
		local Workspace = game:GetService("Workspace")

		if not LocalPlayer or not LocalPlayer.Character then
			print("⚠️ [Teleport] Character not found")
			return false
		end

		-- Get player's assigned island
		local assignedIsland = LocalPlayer:GetAttribute("AssignedIslandName")
		if not assignedIsland then
			print("⚠️ [Teleport] AssignedIslandName not found")
			return false
		end

		print("🔍 [Teleport] Assigned Island: " .. assignedIsland)

		-- Navigate to trade zone: Workspace > Art > Assigned_Island > ENV > TradeZone > Zone > TradeZone5 > TradePart
		local art = Workspace:FindFirstChild("Art")
		if not art then
			print("⚠️ [Teleport] Art folder not found")
			return false
		end

		local island = art:FindFirstChild(assignedIsland)
		if not island then
			print("⚠️ [Teleport] Island not found: " .. assignedIsland)
			return false
		end

		local env = island:FindFirstChild("ENV")
		if not env then
			print("⚠️ [Teleport] ENV not found")
			return false
		end

		local tradeZoneFolder = env:FindFirstChild("TradeZone")
		if not tradeZoneFolder then
			print("⚠️ [Teleport] TradeZone folder not found")
			return false
		end

		local zone = tradeZoneFolder:FindFirstChild("Zone")
		if not zone then
			print("⚠️ [Teleport] Zone not found")
			return false
		end

		local tradeZonePart = zone:FindFirstChild("TradeZone" .. zoneNumber)
		if not tradeZonePart then
			print("⚠️ [Teleport] TradeZone" .. zoneNumber .. " not found")
			return false
		end

		local tradePart = tradeZonePart:FindFirstChild("TradePart")
		if not tradePart then
			print("⚠️ [Teleport] TradePart not found")
			return false
		end

		-- Get CFrame position
		local targetCFrame = tradePart.CFrame
		if not targetCFrame then
			print("⚠️ [Teleport] Could not get CFrame from TradePart")
			return false
		end

		-- Teleport player
		local char = LocalPlayer.Character
		local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			humanoidRootPart.CFrame = targetCFrame
			print("✅ [Teleport] Teleported to TradeZone" .. zoneNumber)
			return true
		else
			print("⚠️ [Teleport] HumanoidRootPart not found")
			return false
		end
	end

	TeleportToZone:OnChanged(function(value)
		if value then
			-- Teleport to Zone 1 by default
			task.wait(0.5) -- Wait for character to load
			local success = teleportToTradeZone(5)
			if success then
				-- Fluent:Notify({
				--     Title = "Teleported",
				--     Content = "Teleported to Trade Zone 1",
				--     Duration = 3
				-- })
			else
				-- Fluent:Notify({
				--     Title = "Teleport Failed",
				--     Content = "Could not find trade zone - check console",
				--     Duration = 3
				-- })
			end
		end
	end)

	-- Function to equip pet by UID
	local function equipPet(petUID)
		if not petUID or petUID == "" then
			print("⚠️ [Pet Focus] No pet UID provided")
			return false
		end

		local CharacterRE = ReplicatedStorage:FindFirstChild("Remote")
			and ReplicatedStorage.Remote:FindFirstChild("CharacterRE")

		if not CharacterRE then
			print("⚠️ [Pet Focus] CharacterRE not found")
			return false
		end

		print("🐾 [Pet Focus] Equipping pet: " .. petUID)
		CharacterRE:FireServer("Focus", petUID)
		print("✅ [Pet Focus] Focus command sent")
		return true
	end

	-- Auto-teleport on script load if toggle is enabled
	task.spawn(function()
		task.wait(2) -- Wait for character and SaveManager to load
		if Options.TeleportToZone and Options.TeleportToZone.Value then
			print("🔄 [Teleport] Auto-teleport enabled, teleporting...")
			local success = teleportToTradeZone(5)
			if success then
				print("✅ [Teleport] Auto-teleport successful")

				-- Auto-equip pet after teleporting
				task.wait(1) -- Wait for teleport to complete
				local petUID = Options.HeldPetUID and Options.HeldPetUID.Value or ""
				if petUID ~= "" then
					print("🐾 [Teleport] Auto-equipping saved pet...")
					equipPet(petUID)
				else
					print("⚠️ [Teleport] No saved pet UID to equip")
				end
			else
				print("⚠️ [Teleport] Auto-teleport failed")
			end
		end
	end)

	-- Background task to re-equip pet after 5 minutes of inactivity
	task.spawn(function()
		task.wait(5) -- Wait for script to fully initialize
		print("🕐 [Auto Re-equip] Started inactivity monitor (5min timeout)")

		while not Fluent.Unloaded do
			task.wait(60) -- Check every minute

			-- Only check if auto trade is enabled
			if autoTradeState.enabled then
				local timeSinceLastTrade = os.time() - autoTradeState.lastTradeTime
				local fiveMinutes = 5 * 60 -- 5 minutes in seconds

				if timeSinceLastTrade >= fiveMinutes then
					local petUID = Options.HeldPetUID and Options.HeldPetUID.Value or ""
					if petUID ~= "" then
						print("⏰ [Auto Re-equip] 5 minutes since last trade - re-equipping pet")

						local CharacterRE = ReplicatedStorage:FindFirstChild("Remote")
							and ReplicatedStorage.Remote:FindFirstChild("CharacterRE")
						if CharacterRE then
							CharacterRE:FireServer("Focus")
							task.wait(1)
							CharacterRE:FireServer("Focus", petUID)
						else
							equipPet(petUID)
						end

						autoTradeState.lastTradeTime = os.time() -- Reset timer after re-equipping
					else
						print("⚠️ [Auto Re-equip] No saved pet UID to re-equip")
					end
				end
			end
		end

		print("🛑 [Auto Re-equip] Stopped inactivity monitor")
	end)

	ZoneSection:AddParagraph({
		Title = "Trade Zones",
		Content = "Zone 1: Giraffe, Butterflyfish, Hippo\nZone 2: Okapi, Panther, Flounder\nZone 3: Kangaroo, Fox_E1, Gorilla\nZone 4: Dolphin, Dragon, Bear_E1\nZone 5: BluePhoenix, MetroGiraffe, Centaur, Toothless",
	})

	local TradeZoneDropdown = ZoneSection:AddDropdown("TradeZone", {
		Title = "Select Trade Zone",
		Description = "Switch to a different trade zone",
		Values = { "Zone 1", "Zone 2", "Zone 3", "Zone 4", "Zone 5" },
		Multi = false,
		Default = "Zone 5",
	})

	TradeZoneDropdown:OnChanged(function(value)
		if not dependenciesLoaded then
			Fluent:Notify({
				Title = "Not Ready",
				Content = "Trade system still loading...",
				Duration = 3,
			})
			return
		end

		local zoneLevel = tonumber(value:match("%d+"))
		if zoneLevel and ReplicatedStorage then
			local TradeZoneRE = ReplicatedStorage:FindFirstChild("Remote")
				and ReplicatedStorage.Remote:FindFirstChild("TradeZoneRE")
			if TradeZoneRE then
				TradeZoneRE:FireServer("Switch", zoneLevel)
				-- Fluent:Notify({
				--     Title = "Zone Switched",
				--     Content = "Switched to Trade Zone " .. zoneLevel,
				--     Duration = 3
				-- })
			end
		end
	end)

	-- Statistics Section
	local StatsSection = Tabs.Trade:AddSection("Statistics")

	StatsSection:AddButton({
		Title = "Show Stats",
		Description = "Display trade statistics",
		Callback = function()
			local message = string.format(
				"Trades: %d\nAccepted: %d\nDeclined: %d",
				autoTradeState.tradeCount,
				autoTradeState.acceptedTrades,
				autoTradeState.declinedTrades
			)

			Fluent:Notify({
				Title = "Trade Statistics",
				Content = message,
				Duration = 5,
			})
		end,
	})

	StatsSection:AddButton({
		Title = "Reset Stats",
		Description = "Reset trade counters",
		Callback = function()
			autoTradeState.tradeCount = 0
			autoTradeState.acceptedTrades = 0
			autoTradeState.declinedTrades = 0

			Fluent:Notify({
				Title = "Stats Reset",
				Content = "All counters reset to 0",
				Duration = 3,
			})
		end,
	})

	StatsSection:AddButton({
		Title = "Request Trade",
		Description = "Manually request a new trade",
		Callback = function()
			if dependenciesLoaded and TradeRE then
				TradeRE:FireServer({ event = "reqtrade" })
				Fluent:Notify({
					Title = "Trade Requested",
					Content = "Requesting new trade...",
					Duration = 3,
				})
			else
				Fluent:Notify({
					Title = "Not Ready",
					Content = "Trade system still loading...",
					Duration = 3,
				})
			end
		end,
	})

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

	print("✅ Auto Trade integration complete!")
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

	local MessageInput = WebhookSection:AddInput("MessageInput", {
		Title = "Message",
		Description = "Enter a custom message",
		Default = "",
		Placeholder = "Your message here...",
		Numeric = false,
		Finished = true,
	})

	local function sendWebhook(content)
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
			["content"] = content,
		}

		local success, err = pcall(function()
			local jsonData = game:GetService("HttpService"):JSONEncode(data)
			local response = request({
				Url = webhookUrl,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
				},
				Body = jsonData,
			})
		end)

		-- if success then
		--     Fluent:Notify({
		--         Title = "Success",
		--         Content = "Webhook sent!",
		--         Duration = 3
		--     })
		-- else
		--     Fluent:Notify({
		--         Title = "Error",
		--         Content = "Failed to send webhook",
		--         Duration = 3
		--     })
		-- end
	end

	WebhookSection:AddButton({
		Title = "Calculate Eggs",
		Description = "Count eggs in inventory and send to webhook",
		Callback = function()
			local Players = game:GetService("Players")
			local localPlayer = Players.LocalPlayer

			if not localPlayer then
				Fluent:Notify({
					Title = "Error",
					Content = "LocalPlayer not found",
					Duration = 3,
				})
				return
			end

			local eggData = localPlayer:FindFirstChild("PlayerGui")
			if eggData then
				eggData = eggData:FindFirstChild("Data")
			end
			if eggData then
				eggData = eggData:FindFirstChild("Egg")
			end

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

			for _, eggObj in pairs(eggData:GetChildren()) do
				local m = eggObj:GetAttribute("M")
				local t = eggObj:GetAttribute("T")
				local uid = eggObj:GetAttribute("UID")

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

-- Debug: Check loaded MinFairness values
print("🔍 [Config Load] MinFairness loaded as:", Options.MinFairness and Options.MinFairness.Value or "nil")
print(
	"🔍 [Config Load] MinFairnessPercentage loaded as:",
	Options.MinFairnessPercentage and string.format("%.2f", Options.MinFairnessPercentage.Value) or "nil"
)

-- Set default MinFairnessPercentage if not loaded or is 0
if
	not Options.MinFairnessPercentage
	or not Options.MinFairnessPercentage.Value
	or Options.MinFairnessPercentage.Value == 0
then
	Options.MinFairnessPercentage.Value = 0.9
	print("🔄 [Config Load] Set MinFairnessPercentage default to 0.9 (90%)")
end

-- Update input display to match loaded value (convert 0-1 range back to 0-100)
if Options.MinFairness then
	local displayValue = tostring(math.floor((Options.MinFairnessPercentage.Value or 0.9) * 100))
	Options.MinFairness:SetValue(displayValue)
end

Window:SelectTab(1)

Fluent:Notify({
	Title = "Fluent",
	Content = "The script has been loaded.",
	Duration = 8,
})

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
		print("💾 [Auto-Save] Configuration saved successfully")
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
