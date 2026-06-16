local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		-- Tunggu 0.1 detik sampai karakter selesai di-load utuh oleh Roblox
		task.wait(0.1) 

		-- Cek apakah pemain punya memori CheckpointAktif
		local cpData = player:FindFirstChild("CheckpointAktif")

		-- Kalau punya memori dan memori itu berisi karpet hijau
		if cpData and cpData.Value then
			-- Pindahkan karakter ke lokasi karpet hijau tersebut (ditambah tinggi 5 biar nggak nyangkut di dalam lantai)
			local posisiCheckpoint = cpData.Value.CFrame
			character:PivotTo(posisiCheckpoint + Vector3.new(0, 5, 0))
		end
	end)
end)