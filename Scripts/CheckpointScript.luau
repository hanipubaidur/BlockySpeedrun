local checkpoint = script.Parent
local cpNumber = checkpoint:GetAttribute("CPNumber")

-- Fungsi utama pembagi CP dan Poin
local function prosesCP(player)
	local currentProgress = player:GetAttribute("CurrentCP") or 0
	if cpNumber == currentProgress + 1 then

		player:SetAttribute("CurrentCP", cpNumber)

		local cpData = player:FindFirstChild("CheckpointAktif")
		if not cpData then
			cpData = Instance.new("ObjectValue")
			cpData.Name = "CheckpointAktif"
			cpData.Parent = player
		end
		cpData.Value = checkpoint

		-- Tambah Poin & Update Papan Skor
		player.leaderstats.Poin.Value = player.leaderstats.Poin.Value + 10
		player.leaderstats.CP.Value = cpNumber
		return true
	end
	return false
end

checkpoint.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:GetPlayerFromCharacter(character)

	if player then
		-- 1. Berikan CP ke orang yang MENGINJAK (Carrier)
		local berhasil = prosesCP(player)

		if berhasil then
			checkpoint.BrickColor = BrickColor.new("Bright yellow")
		end

		-- 2. CEK PENUMPANG: Apakah dia sedang menggendong seseorang?
		local hrpPenggendong = character:FindFirstChild("HumanoidRootPart")
		if hrpPenggendong then
			-- Cari pemain lain yang nempel sama dia
			for _, pLain in pairs(game.Players:GetPlayers()) do
				if pLain ~= player and pLain.Character then
					local hrpLain = pLain.Character:FindFirstChild("HumanoidRootPart")
					if hrpLain then
						local weld = hrpLain:FindFirstChild("CarryWeld")
						-- Kalau Part0 dari Weld adalah milik Penginjak, berarti dia digendong!
						if weld and weld.Part0 == hrpPenggendong then
							-- Berikan CP ke penumpang tanpa dia harus nginjek tanah
							prosesCP(pLain)
						end
					end
				end
			end
		end
	end
end)