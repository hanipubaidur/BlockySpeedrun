local player = game.Players.LocalPlayer
local starterGui = game:GetService("StarterGui")
local debounce = false 

-- Fungsi untuk mengaktifkan touch event pada karpet
local function setupCP(objek)
	if objek:IsA("BasePart") and objek.Name == "KarpetCP" then
		objek.Touched:Connect(function(hit)
			if hit.Parent == player.Character and not debounce then
				debounce = true

				-- Ambil nomor CP dari Attribute karpet
				local nomorCP = objek:GetAttribute("CPNumber") or 0
				-- Ambil progress terakhir pemain
				local currentProgress = player:GetAttribute("CurrentCP") or 0

				if nomorCP == currentProgress + 1 then
					-- JIKA URUT: Muncul notif berhasil
					starterGui:SetCore("SendNotification", {
						Title = "Checkpoint!",
						Text = "Kamu mencapai CP " .. nomorCP,
						Duration = 3,
						Icon = "rbxassetid://6031280883"
					})

				elseif nomorCP > currentProgress + 1 then
					-- JIKA SKIP/TERLEWAT: Muncul peringatan!
					starterGui:SetCore("SendNotification", {
						Title = "CP Terlewat!",
						Text = "Waduh, kamu harus injak CP " .. (currentProgress + 1) .. " dulu biar dapet poin!",
						Duration = 4,
					})
				end

				-- Jeda 3 detik biar notifikasi nggak spam
				task.wait(3) 
				debounce = false
			end
		end)
	end
end

-- 1. Deteksi semua karpet yang SUDAH ADA di map
for _, obj in pairs(game.Workspace:GetDescendants()) do
	setupCP(obj)
end

-- 2. Deteksi karpet yang BARU MUNCUL saat game jalan
game.Workspace.DescendantAdded:Connect(setupCP)