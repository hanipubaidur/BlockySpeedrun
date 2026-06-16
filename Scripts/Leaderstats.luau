local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

-- Pakai versi 3 karena kita nambahin Poin ke dalam paket data
local myDataStore = DataStoreService:GetDataStore("SaveDataUAS_V3") 

Players.PlayerAdded:Connect(function(player)
	-- Bikin Folder
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	-- === VARIABEL ===
	local poin = Instance.new("IntValue")
	poin.Name = "Poin"
	poin.Value = 0
	poin.Parent = leaderstats

	local mati = Instance.new("IntValue")
	mati.Name = "Mati"
	mati.Value = 0
	mati.Parent = leaderstats

	local menang = Instance.new("IntValue")
	menang.Name = "Menang"
	menang.Value = 0
	menang.Parent = leaderstats

	-- CP tetap reset tiap masuk
	local cp = Instance.new("IntValue")
	cp.Name = "CP"
	cp.Value = 0
	cp.Parent = leaderstats
	player:SetAttribute("CurrentCP", 0)

	-- === PROSES LOAD DATA SAAT JOIN ===
	local success, savedData = pcall(function()
		return myDataStore:GetAsync(player.UserId)
	end)

	if success and type(savedData) == "table" then
		poin.Value = savedData.Poin or 0
		mati.Value = savedData.Mati or 0
		menang.Value = savedData.Menang or 0
	end

	-- === SISTEM MATI ===
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.Died:Connect(function()
			mati.Value = mati.Value + 1
		end)
	end)
end)

-- === PROSES SAVE DATA SAAT LEAVE ===
Players.PlayerRemoving:Connect(function(player)
	-- Bungkus Poin, Mati, dan Menang
	local dataToSave = {
		Poin = player.leaderstats.Poin.Value,
		Mati = player.leaderstats.Mati.Value,
		Menang = player.leaderstats.Menang.Value
	}

	local success, errorMessage = pcall(function()
		myDataStore:SetAsync(player.UserId, dataToSave)
	end)
end)