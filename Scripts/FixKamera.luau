local RunService = game:GetService("RunService")
local character = script.Parent
local hrp = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local waktuMulai = os.clock()

-- Kunci kamera di belakang punggung di setiap frame secara terus-menerus
-- Ini akan menutupi delay teleport dari server karena kameranya akan selalu ikut dengan mulus
local kameraLock
kameraLock = RunService.RenderStepped:Connect(function()
	local letakKameraDiBelakang = hrp.Position - (hrp.CFrame.LookVector * 12) + Vector3.new(0, 3, 0)
	local titikPandangDepan = hrp.Position + (hrp.CFrame.LookVector * 10)

	camera.CFrame = CFrame.lookAt(letakKameraDiBelakang, titikPandangDepan)

	-- Lepaskan paksaan kamera ini setelah 0.3 detik
	-- Waktu ini cukup buat server selesai teleport, dan pemain bisa putar-putar mouse lagi
	if os.clock() - waktuMulai > 0.3 then
		kameraLock:Disconnect()
	end
end)