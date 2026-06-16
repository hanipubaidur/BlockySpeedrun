local UserInputService = game:GetService("UserInputService")
local pemain = game.Players.LocalPlayer

-- Kecepatan normal Roblox adalah 16, lari kita set ke 24 (jangan terlalu cepat biar nggak gampang jatuh)
local lariCepat = 24
local jalanNormal = 16

-- Saat tombol ditekan
UserInputService.InputBegan:Connect(function(input, sedangMengetik)
	if not sedangMengetik and input.KeyCode == Enum.KeyCode.LeftShift then
		local character = pemain.Character
		if character and character:FindFirstChild("Humanoid") then
			character.Humanoid.WalkSpeed = lariCepat
		end
	end
end)

-- Saat tombol dilepas
UserInputService.InputEnded:Connect(function(input, sedangMengetik)
	if not sedangMengetik and input.KeyCode == Enum.KeyCode.LeftShift then
		local character = pemain.Character
		if character and character:FindFirstChild("Humanoid") then
			character.Humanoid.WalkSpeed = jalanNormal
		end
	end
end)