-- Author: Hanif Ubaidur Rohman Syah (23106050081)
-- Deskripsi: Papan Leaderboard Global (Top 10 Poin)

local DataStoreService = game:GetService("DataStoreService")
-- OrderedDataStore khusus untuk mengurutkan angka tertinggi
local poinLeaderboard = DataStoreService:GetOrderedDataStore("TopPoinLeaderboard_V1")

local surfaceGui = script.Parent
surfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
surfaceGui.PixelsPerStud = 50

-- Bikin Wadah (Frame) Otomatis
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, 0, 1, 0)
container.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
container.Parent = surfaceGui

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = container

-- Teks Judul
local judul = Instance.new("TextLabel")
judul.Size = UDim2.new(1, 0, 0, 80)
judul.BackgroundTransparency = 1
judul.Text = "?? TOP 10 PEMAIN TERHEBAT ??"
judul.TextColor3 = Color3.fromRGB(255, 215, 0) -- Warna Emas
judul.Font = Enum.Font.GothamBlack
judul.TextScaled = true
judul.LayoutOrder = 0
judul.Parent = container

local function updatePapan()
	-- 1. Simpan Poin terbaru dari pemain yang sedang main ke OrderedDataStore
	for _, player in pairs(game.Players:GetPlayers()) do
		pcall(function()
			if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Poin") then
				poinLeaderboard:SetAsync(player.UserId, player.leaderstats.Poin.Value)
			end
		end)
	end

	-- 2. Ambil 10 Data Tertinggi
	local success, errorMessage = pcall(function()
		-- false = urut dari terbesar ke terkecil, 10 = ambil 10 orang
		local data = poinLeaderboard:GetSortedAsync(false, 10)
		local top10Page = data:GetCurrentPage()

		-- Bersihkan daftar nama yang lama (kecuali judul)
		for _, child in pairs(container:GetChildren()) do
			if child:IsA("TextLabel") and child.LayoutOrder > 0 then
				child:Destroy()
			end
		end

		-- 3. Tampilkan ke Papan
		for rank, dataPemain in ipairs(top10Page) do
			local userId = dataPemain.key
			local totalPoin = dataPemain.value
			local namaPemain = "Pemain Tidak Diketahui"

			-- Ambil nama pemain dari UserId-nya
			pcall(function()
				namaPemain = game.Players:GetNameFromUserIdAsync(userId)
			end)

			-- Bikin tulisan untuk baris ini
			local baris = Instance.new("TextLabel")
			baris.Size = UDim2.new(0.9, 0, 0, 60)
			baris.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			baris.TextColor3 = Color3.fromRGB(255, 255, 255)
			baris.Font = Enum.Font.GothamBold
			baris.TextSize = 30
			baris.LayoutOrder = rank

			-- Hiasan ranking (Juara 1 Emas, Juara 2 Perak, dst)
			if rank == 1 then
				baris.TextColor3 = Color3.fromRGB(255, 215, 0)
				baris.Text = "?? #" .. rank .. " | " .. namaPemain .. " : " .. totalPoin .. " Poin"
			elseif rank == 2 then
				baris.TextColor3 = Color3.fromRGB(192, 192, 192)
				baris.Text = "?? #" .. rank .. " | " .. namaPemain .. " : " .. totalPoin .. " Poin"
			elseif rank == 3 then
				baris.TextColor3 = Color3.fromRGB(205, 127, 50)
				baris.Text = "?? #" .. rank .. " | " .. namaPemain .. " : " .. totalPoin .. " Poin"
			else
				baris.Text = "#" .. rank .. " | " .. namaPemain .. " : " .. totalPoin .. " Poin"
			end

			baris.Parent = container
		end
	end)
end

-- Looping: Update papan secara otomatis setiap 30 detik
while true do
	updatePapan()
	task.wait(30)
end