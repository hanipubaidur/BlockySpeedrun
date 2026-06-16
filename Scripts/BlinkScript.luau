local folderRintangan = script.Parent

-- Looping tanpa henti (while true) selama game berjalan
while true do
	-- FASE MATI: Laser memudar dan aman dilewati
	for _, part in pairs(folderRintangan:GetChildren()) do
		if part:IsA("BasePart") then
			part.Transparency = 0.8 -- Bikin lasernya jadi transparan/pudar
			part.CanTouch = false -- Nonaktifkan sensor sentuh (aman dilewati)
		end
	end

	task.wait(2) -- Laser mati selama 2 detik

	-- FASE NYALA: Laser terang dan mematikan
	for _, part in pairs(folderRintangan:GetChildren()) do
		if part:IsA("BasePart") then
			part.Transparency = 0 -- Bikin lasernya terang lagi
			part.CanTouch = true -- Aktifkan sensor sentuh (akan membunuh karena terhubung ke GroupKillScript)
		end
	end

	task.wait(2) -- Laser menyala selama 2 detik
end
