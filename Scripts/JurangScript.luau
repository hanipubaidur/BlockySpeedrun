local lantaiJurang = script.Parent

lantaiJurang.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")

	-- Jika yang menyentuh lantai ini adalah karakter hidup
	if humanoid then
		-- Langsung kurangi darah jadi 0 agar sistem RespawnManager bekerja
		humanoid.Health = 0
	end
end)