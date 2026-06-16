local finishLine = script.Parent

-- 1. Hitung total KarpetCP yang ada di map secara otomatis
local totalCP = 0
for _, objek in pairs(game.Workspace:GetDescendants()) do
	if objek.Name == "KarpetCP" and objek:IsA("BasePart") then
		totalCP = totalCP + 1
	end
end

-- 2. Fungsi untuk membuat pengumuman UI yang bisa menumpuk (Stacking) ke semua pemain
local function buatPengumuman(namaPemain)
	for _, p in pairs(game.Players:GetPlayers()) do
		local gui = p:FindFirstChild("PlayerGui")
		if gui then
			-- Bikin wadah pengumuman kalau belum ada
			local screenGui = gui:FindFirstChild("PengumumanFinish")
			if not screenGui then
				screenGui = Instance.new("ScreenGui")
				screenGui.Name = "PengumumanFinish"
				screenGui.Parent = gui

				local frame = Instance.new("Frame")
				frame.Name = "Container"
				frame.Size = UDim2.new(1, 0, 0.4, 0)
				frame.Position = UDim2.new(0, 0, 0.1, 0) -- Posisinya di atas layar
				frame.BackgroundTransparency = 1
				frame.Parent = screenGui

				-- UIListLayout ini yang bikin teks otomatis numpuk rapi ke bawah
				local layout = Instance.new("UIListLayout")
				layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				layout.SortOrder = Enum.SortOrder.LayoutOrder
				layout.Padding = UDim.new(0, 5)
				layout.Parent = frame
			end

			-- Bikin Teks Pengumuman Baru
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(0, 550, 0, 35)
			label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			label.BackgroundTransparency = 0.4
			label.TextColor3 = Color3.fromRGB(255, 255, 0)
			label.Font = Enum.Font.GothamBold
			label.TextSize = 18
			label.Text = "?? LUAR BIASA! [" .. namaPemain .. "] MENYELESAIKAN BLOCKY SPEEDRUN! ??"
			label.Parent = screenGui.Container

			-- Hapus teks setelah 4 detik (Fade-out logic sederhana)
			task.delay(4, function()
				if label then label:Destroy() end
			end)
		end
	end
end

-- 3. Trigger Finish Line
finishLine.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:GetPlayerFromCharacter(character)

	if player and not player:GetAttribute("IsFinishing") then

		-- === CEK ANTI-SKIP ===
		local currentProgress = player:GetAttribute("CurrentCP") or 0

		-- Kalau CP yang dilewati kurang dari total CP di map
		if currentProgress < totalCP then
			player:SetAttribute("IsFinishing", true)

			-- Kasih peringatan merah besar di layar dia (Pakai Message biar kaget)
			local warning = Instance.new("Message")
			warning.Text = "? KAU BELUM MENYELESAIKAN SEMUA CHECKPOINT! (Sisa: " .. (totalCP - currentProgress) .. " CP) ?"
			warning.Parent = player:FindFirstChild("PlayerGui")

			task.wait(3)
			warning:Destroy()
			player:SetAttribute("IsFinishing", false)
			return -- Hentikan script di sini, dia tidak boleh finish!
		end

		-- === PROSES FINISH ASLI JIKA LULUS ===
		player:SetAttribute("IsFinishing", true)

		-- 1. Berikan bonus poin
		player.leaderstats.Poin.Value = player.leaderstats.Poin.Value + 100
		player.leaderstats.Menang.Value = player.leaderstats.Menang.Value + 1
		player.leaderstats.CP.Value = 0
		
		-- 2. Pesan Kemenangan (Panggil fungsi UI Stacking tadi)
		buatPengumuman(player.Name)

		-- 3. Reset memori checkpoint pemain ini biar bisa main lagi
		player:SetAttribute("CurrentCP", 0) 
		local cpData = player:FindFirstChild("CheckpointAktif")
		if cpData then cpData:Destroy() end

		-- 4. RESET SEMUA CHECKPOINT DI MAP
		if not game.Workspace:GetAttribute("IsResetting") then
			game.Workspace:SetAttribute("IsResetting", true)
			for _, objek in pairs(game.Workspace:GetDescendants()) do
				if objek.Name == "KarpetCP" and objek:IsA("BasePart") then
					objek.BrickColor = BrickColor.new("Bright green")
				end
			end
			task.wait(2)
			game.Workspace:SetAttribute("IsResetting", false)
		end

		-- 5. Pindahkan karakter kembali ke Start
		task.wait(1)
		local titikAwal = game.Workspace:FindFirstChild("SpawnLocation")
		if titikAwal then
			character:PivotTo(titikAwal.CFrame + Vector3.new(0, 5, 0))
		end

		player:SetAttribute("IsFinishing", false)
	end
end)