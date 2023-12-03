local MarketplaceService : MarketplaceService = (game:GetService("MarketplaceService"))
local Lighting : Lighting = game:GetService("Lighting")
local Players : Players = game:GetService("Players")
local load = function(Name : string, Color1 : Color3, Color2 : Color3, Blur : boolean)
	local Player : Player = Players:FindFirstChild(Name)
	if Player then
		local a = script.GuiMain:Clone()
		local h1 : number, s1 : number, v1 : number;
		local h2 : number, s2 : number, v2 : number;
		if Color1 ~= nil and Color2 ~= nil then
			h1, s1, v1 = Color1:ToHSV()
			h2, s2, v2 = Color2:ToHSV()
		end
		if h1 ~= nil then
			a.Main.Holder.Holder.Settings.Frame["Main Color"].Frame.H.Text = tostring(h1)
		end
		if h2 ~= nil then
			a.Main.Holder.Holder.Settings.Frame["Sub Color"].Frame.H.Text = tostring(h2)
		end
		if s1 ~= nil then
			a.Main.Holder.Holder.Settings.Frame["Main Color"].Frame.S.Text = tostring(s1)
		end
		if s2 ~= nil then
			a.Main.Holder.Holder.Settings.Frame["Sub Color"].Frame.S.Text = tostring(s2)
		end
		if v1 ~= nil then
			a.Main.Holder.Holder.Settings.Frame["Main Color"].Frame.V.Text = tostring(v1)
		end
		if v2 ~= nil then
			a.Main.Holder.Holder.Settings.Frame["Sub Color"].Frame.V.Text = tostring(v2)
		end
		a.Parent = Player.PlayerGui
		require(a.Server)
		if Blur == true then
			local Effect = Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
			if Effect == nil then 
				Effect = Instance.new("DepthOfFieldEffect", Lighting)
			end
			if Effect.Enabled == false then
				Effect.Enabled = true
			end
			if Effect.FarIntensity > 0 then
				Effect.FarIntensity = 0
			end
			if Effect.FocusDistance > 0 then
				Effect.FocusDistance = 0
			end
			if Effect.InFocusRadius > 0 then
				Effect.InFocusRadius = 0
			end
			if Effect.NearIntensity == 0 then
				Effect.NearIntensity = 1
			end
		end
	end
end
return load
