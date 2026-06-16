local Players = game:GetService("Players")

local function pasangTombol(player)
	player.CharacterAdded:Connect(function(character)
		local hrp = character:WaitForChild("HumanoidRootPart")
		if hrp:FindFirstChild("CarryAttachment") then return end

		local attachment = Instance.new("Attachment")
		attachment.Name = "CarryAttachment"
		attachment.Parent = hrp

		local prompt = Instance.new("ProximityPrompt")
		prompt.Name = "PromptGendong"
		prompt.ActionText = "Gendong" 
		prompt.ObjectText = player.Name
		prompt.HoldDuration = 0.2
		prompt.KeyboardKeyCode = Enum.KeyCode.E
		prompt.RequiresLineOfSight = false
		prompt.MaxActivationDistance = 10
		prompt:SetAttribute("OwnerName", player.Name) 
		prompt.Parent = attachment

		prompt.Triggered:Connect(function(interactor)
			local charPrompt = character -- Karakter yang PUNYA tombol ini
			local hrpPrompt = hrp

			local charInteractor = interactor.Character -- Karakter yang MENCET tombol ini
			if not charInteractor then return end
			local hrpInteractor = charInteractor:FindFirstChild("HumanoidRootPart")
			if not hrpInteractor then return end

			-- === KONDISI 1: POV PLAYER 1 (YANG DIGENDONG) MENCET "TURUN" ===
			-- Cek apakah yang mencet (Player 1) sedang digendong oleh pemilik tombol (Player 2)
			local weldDiPencet = hrpInteractor:FindFirstChild("CarryWeld")
			if weldDiPencet and weldDiPencet.Part0 == hrpPrompt then
				weldDiPencet:Destroy()
				for _, part in pairs(charInteractor:GetChildren()) do
					if part:IsA("BasePart") then part.Massless = false end
				end
				charInteractor.Parent = workspace
				hrpInteractor.CFrame = hrpPrompt.CFrame * CFrame.new(0, 0, 3)
				task.wait(0.1)
				charInteractor.Humanoid.PlatformStand = false

				-- Kembalikan semua teks jadi "Gendong"
				prompt.ActionText = "Gendong"
				local att = hrpInteractor:FindFirstChild("CarryAttachment")
				if att and att:FindFirstChild("PromptGendong") then
					att.PromptGendong.ActionText = "Gendong"
				end
				return
			end

			-- === KONDISI 2: POV PLAYER 2 (CARRIER) MENCET "LEPAS" ===
			-- Cek apakah pemilik tombol (Player 1) sedang digendong oleh yang mencet (Player 2)
			local weldDiPrompt = hrpPrompt:FindFirstChild("CarryWeld")
			if weldDiPrompt and weldDiPrompt.Part0 == hrpInteractor then
				weldDiPrompt:Destroy()
				for _, part in pairs(charPrompt:GetChildren()) do
					if part:IsA("BasePart") then part.Massless = false end
				end
				charPrompt.Parent = workspace
				hrpPrompt.CFrame = hrpInteractor.CFrame * CFrame.new(0, 0, 3)
				task.wait(0.1)
				charPrompt.Humanoid.PlatformStand = false

				-- Kembalikan semua teks jadi "Gendong"
				prompt.ActionText = "Gendong"
				local att = hrpInteractor:FindFirstChild("CarryAttachment")
				if att and att:FindFirstChild("PromptGendong") then
					att.PromptGendong.ActionText = "Gendong"
				end
				return
			end

			-- === KONDISI 3: PROSES GENDONG AWAL ===
			-- Anti-gendong diri sendiri
			if interactor.Name == prompt:GetAttribute("OwnerName") then return end
			-- Cek apakah target udah digendong orang lain
			if hrpPrompt:FindFirstChild("CarryWeld") then return end 

			charPrompt.Humanoid.PlatformStand = true 
			for _, part in pairs(charPrompt:GetChildren()) do
				if part:IsA("BasePart") then part.Massless = true end
			end

			local weld = Instance.new("WeldConstraint")
			weld.Name = "CarryWeld"
			weld.Part0 = hrpInteractor
			weld.Part1 = hrpPrompt
			hrpPrompt.CFrame = hrpInteractor.CFrame * CFrame.new(0, 1, 1.5)
			weld.Parent = hrpPrompt
			charPrompt.Parent = charInteractor

			-- TRICK POV: Ganti teks secara silang!
			prompt.ActionText = "Lepas" -- Tombol di punggung (dilihat oleh Carrier)

			local attCarrier = hrpInteractor:FindFirstChild("CarryAttachment")
			if attCarrier and attCarrier:FindFirstChild("PromptGendong") then
				attCarrier.PromptGendong.ActionText = "Turun" -- Tombol di Carrier (dilihat oleh yang digendong)
			end
		end)
	end)
end

Players.PlayerAdded:Connect(pasangTombol)
for _, p in pairs(Players:GetPlayers()) do pasangTombol(p) end