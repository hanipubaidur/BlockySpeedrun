local player = game.Players.LocalPlayer
local starterGui = game:GetService("StarterGui")
local debounce = false 

-- 1. NOTIFIKASI BERHASIL (Merespon sistem, bukan sentuhan fisik)
-- Jadi meskipun digendong, kalau sistem bilang dia dapet CP, notifnya bakal muncul!
player:GetAttributeChangedSignal("CurrentCP"):Connect(function()
	local nomorCP = player:GetAttribute("CurrentCP")

	-- Cegah notif muncul saat CP di-reset ke 0 (Pas menang/mati)
	if nomorCP > 0 then
		starterGui:SetCore("SendNotification", {
			Title = "Checkpoint!",
			Text = "Kamu mencapai CP " .. nomorCP,
			Duration = 3,
			Icon = "rbxassetid://6031280883"
		})
	end
end)

-- 2. NOTIFIKASI TERLEWAT / SKIP (Tetap menggunakan deteksi sentuhan fisik)
local function setupCP(objek)
	if objek:IsA("BasePart") and objek.Name == "KarpetCP" then
		objek.Touched:Connect(function(hit)
			if hit.Parent == player.Character and not debounce then
				debounce = true

				local nomorCP = objek:GetAttribute("CPNumber") or 0
				local currentProgress = player:GetAttribute("CurrentCP") or 0

				-- Peringatan kalau nyoba curang/skip
				if nomorCP > currentProgress + 1 then
					starterGui:SetCore("SendNotification", {
						Title = "CP Terlewat!",
						Text = "Waduh, kamu harus injak CP " .. (currentProgress + 1) .. " dulu biar dapet poin!",
						Duration = 4,
					})
				end

				task.wait(3) 
				debounce = false
			end
		end)
	end
end

for _, obj in pairs(game.Workspace:GetDescendants()) do
	setupCP(obj)
end
game.Workspace.DescendantAdded:Connect(setupCP)