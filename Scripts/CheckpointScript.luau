local checkpoint = script.Parent
local cpNumber = checkpoint:GetAttribute("CPNumber")

checkpoint.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:GetPlayerFromCharacter(character)

	if player then
		local currentProgress = player:GetAttribute("CurrentCP") or 0

		-- KUNCI KEAMANAN: Cuma merespon kalau ini adalah CP BERIKUTNYA secara urut
		if cpNumber == currentProgress + 1 then

			player:SetAttribute("CurrentCP", cpNumber)

			local cpData = player:FindFirstChild("CheckpointAktif")
			if not cpData then
				cpData = Instance.new("ObjectValue")
				cpData.Name = "CheckpointAktif"
				cpData.Parent = player
			end
			cpData.Value = checkpoint

			-- Tambah Poin (Aman dari cheater yang skip)
			player.leaderstats.Poin.Value = player.leaderstats.Poin.Value + 10
			-- Update tampilan CP di papan skor
			player.leaderstats.CP.Value = cpNumber
			-- Ubah warna jadi kuning (tanda berhasil)
			checkpoint.BrickColor = BrickColor.new("Bright yellow")
		end
	end
end)