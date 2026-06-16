local finishLine = script.Parent

-- 1. Hitung total KarpetCP yang ada di map secara otomatis
local totalCP = 0
for _, objek in pairs(game.Workspace:GetDescendants()) do
	if objek.Name == "KarpetCP" and objek:IsA("BasePart") then
		totalCP = totalCP + 1
	end
end

-- 2. Fungsi untuk membuat pengumuman UI Stacking
local function buatPengumuman(namaPemain)
	for _, p in pairs(game.Players:GetPlayers()) do
		local gui = p:FindFirstChild("PlayerGui")
		if gui then
			local screenGui = gui:FindFirstChild("PengumumanFinish")
			if not screenGui then
				screenGui = Instance.new("ScreenGui")
				screenGui.Name = "PengumumanFinish"
				screenGui.Parent = gui

				local frame = Instance.new("Frame")
				frame.Name = "Container"
				frame.Size = UDim2.new(1, 0, 0.4, 0)
				frame.Position = UDim2.new(0, 0, 0.1, 0)
				frame.BackgroundTransparency = 1
				frame.Parent = screenGui

				local layout = Instance.new("UIListLayout")
				layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				layout.SortOrder = Enum.SortOrder.LayoutOrder
				layout.Padding = UDim.new(0, 5)
				layout.Parent = frame
			end

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(0, 550, 0, 35)
			label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			label.BackgroundTransparency = 0.4
			label.TextColor3 = Color3.fromRGB(255, 255, 0)
			label.Font = Enum.Font.GothamBold
			label.TextSize = 18
			label.Text = "?? LUAR BIASA! [" .. namaPemain .. "] MENYELESAIKAN BLOCKY SPEEDRUN! ??"
			label.Parent = screenGui.Container

			task.delay(4, function()
				if label then label:Destroy() end
			end)
		end
	end
end

-- 3. Fungsi Inti: Proses Kemenangan (Bisa dipakai barengan)
local function prosesMenang(p)
	if p:GetAttribute("IsFinishing") then return false end
	p:SetAttribute("IsFinishing", true)

	local currentProgress = p:GetAttribute("CurrentCP") or 0

	-- JIKA GAGAL (SKIP CP)
	if currentProgress < totalCP then
		-- Peringatan dimunculkan tanpa menghentikan script utama
		task.spawn(function()
			local warning = Instance.new("Message")
			warning.Text = "? [".. p.Name .. "] BELUM MENYELESAIKAN SEMUA CHECKPOINT! (Sisa: " .. (totalCP - currentProgress) .. " CP) ?"
			warning.Parent = p:FindFirstChild("PlayerGui")
			task.wait(3)
			if warning then warning:Destroy() end
			p:SetAttribute("IsFinishing", false)
		end)
		return false
	end

	-- JIKA LULUS
	p.leaderstats.Poin.Value = p.leaderstats.Poin.Value + 100
	p.leaderstats.Menang.Value = p.leaderstats.Menang.Value + 1
	p.leaderstats.CP.Value = 0

	buatPengumuman(p.Name)

	p:SetAttribute("CurrentCP", 0) 
	local cpData = p:FindFirstChild("CheckpointAktif")
	if cpData then cpData:Destroy() end

	return true
end

-- 4. Trigger Finish Line
finishLine.Touched:Connect(function(hit)
	local charPenginjak = hit.Parent
	local playerPenginjak = game.Players:GetPlayerFromCharacter(charPenginjak)

	if playerPenginjak and not playerPenginjak:GetAttribute("IsFinishing") then

		-- A. Cari tahu apakah Penginjak sedang menggendong seseorang
		local playerPenumpang = nil
		local charPenumpang = nil
		local weldGendong = nil

		local hrpPenginjak = charPenginjak:FindFirstChild("HumanoidRootPart")
		if hrpPenginjak then
			for _, pLain in pairs(game.Players:GetPlayers()) do
				if pLain ~= playerPenginjak and pLain.Character then
					local hrpLain = pLain.Character:FindFirstChild("HumanoidRootPart")
					if hrpLain then
						local weld = hrpLain:FindFirstChild("CarryWeld")
						-- Kalau ada yang nempel ke Penginjak, berarti dia penumpangnya
						if weld and weld.Part0 == hrpPenginjak then
							playerPenumpang = pLain
							charPenumpang = pLain.Character
							weldGendong = weld
						end
					end
				end
			end
		end

		-- B. Proses Keduanya (Anti-Skip tetap berlaku untuk masing-masing)
		local lulusPenginjak = prosesMenang(playerPenginjak)
		local lulusPenumpang = false
		if playerPenumpang then
			lulusPenumpang = prosesMenang(playerPenumpang)
		end

		-- C. Eksekusi Dunia & Teleport (Hanya kalau ada yang lulus)
		task.spawn(function()
			-- Reset Karpet CP kalau ada yang berhasil tamat
			if (lulusPenginjak or lulusPenumpang) and not game.Workspace:GetAttribute("IsResetting") then
				game.Workspace:SetAttribute("IsResetting", true)
				for _, objek in pairs(game.Workspace:GetDescendants()) do
					if objek.Name == "KarpetCP" and objek:IsA("BasePart") then
						objek.BrickColor = BrickColor.new("Bright green")
					end
				end
				task.delay(2, function()
					game.Workspace:SetAttribute("IsResetting", false)
				end)
			end

			task.wait(1) -- Jeda dramatis sebelum teleport

			-- MELEPAS GENDONGAN SECARA PAKSA SEBELUM TELEPORT
			if charPenumpang and weldGendong then
				weldGendong:Destroy()
				for _, part in pairs(charPenumpang:GetChildren()) do
					if part:IsA("BasePart") then part.Massless = false end
				end
				charPenumpang.Parent = workspace
				charPenumpang.Humanoid.PlatformStand = false

				-- Reset tulisan prompt biar rapi lagi
				local att = charPenumpang.HumanoidRootPart:FindFirstChild("CarryAttachment")
				if att and att:FindFirstChild("PromptGendong") then
					att.PromptGendong.ActionText = "Gendong"
				end
			end

			-- Pindahkan kembali ke Spawn
			local titikAwal = game.Workspace:FindFirstChild("SpawnLocation")
			if titikAwal then
				if lulusPenginjak then
					charPenginjak:PivotTo(titikAwal.CFrame + Vector3.new(0, 5, 0))
					playerPenginjak:SetAttribute("IsFinishing", false)
				end
				if lulusPenumpang then
					-- Penumpang di-teleport agak menyamping biar nggak numpuk
					charPenumpang:PivotTo(titikAwal.CFrame + Vector3.new(0, 5, 4))
					playerPenumpang:SetAttribute("IsFinishing", false)
				end
			end
		end)
	end
end)