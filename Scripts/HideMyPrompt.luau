-- LocalScript di StarterPlayerScripts
local player = game.Players.LocalPlayer

game.Workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("ProximityPrompt") and obj.Name == "PromptGendong" then
		if obj:GetAttribute("OwnerName") == player.Name then
			obj.Enabled = false
		end
	end
end)

for _, obj in pairs(game.Workspace:GetDescendants()) do
	if obj:IsA("ProximityPrompt") and obj.Name == "PromptGendong" then
		if obj:GetAttribute("OwnerName") == player.Name then
			obj.Enabled = false
		end
	end
end