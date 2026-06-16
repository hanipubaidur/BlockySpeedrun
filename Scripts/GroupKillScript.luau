local folderRintangan = script.Parent

-- Looping untuk mengecek semua balok di dalam folder Rintangan
for _, part in pairs(folderRintangan:GetChildren()) do
	-- Memastikan yang dicek adalah balok (BasePart)
	if part:IsA("BasePart") then
		part.Touched:Connect(function(hit)
			local character = hit.Parent
			local humanoid = character:FindFirstChild("Humanoid")

			if humanoid then
				-- Mengurangi darah jadi 0 (Mati)
				humanoid.Health = 0
			end
		end)
	end
end