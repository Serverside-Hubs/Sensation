local _ENV = getfenv()

local Players : Players = game:GetService("Players")
local RunService : RunService = game:GetService("RunService")
local LogService : LogService = game:GetService("LogService")
local TestService : TestService = game:GetService("TestService")

local Parent = script.Parent
local Main = Parent.Main
local Sidebar = Main.Sidebar
local Holder = Main.Holder.Holder

local Instances = script.Instances
local Modules = script.Modules
local Thread = script.Thread

local FastNet2 = require(Parent.Universal.FastNet2)
local Remote = FastNet2.new("Remote")

local LocalPlayer : Player = (Parent.Parent.Parent)
local Username : string = LocalPlayer.Name

local _CUSTOMENV = require(Modules._ENV)
local admin = require(Modules.Admin)
local whitelist = require(Modules.Whitelist)

local PageSystem : UIPageLayout = Holder.PageSystem
local convert : Localscript = Thread:WaitForChild("Client")

local tabs = {
	Changelogs = Holder.Changelogs,
	Credits = Holder.Credits,
	Executer = Holder.Executer,
	Home = Holder.Home,
	Hub = Holder.Hub,
	Logs = Holder.Logs,
	Music = Holder.Music,
	Players = Holder.Players,
	Settings = Holder.Settings,
}

local scrollingFrames = {
	Changelogs = tabs.Changelogs.ScrollingFrame,
	Credits = tabs.Credits.ScrollingFrame,
	Hub = tabs.Hub.ScrollingFrame,
	Logs = tabs.Logs.ScrollingFrame,
	Music = tabs.Music.Frame.ScrollingFrame,
	Options = tabs.Players.Frame.Options,
	Players = tabs.Players.Frame.Players,
	Frame = Sidebar.Frame.Frame
}

local instances = {
	Button = Instances.Button,
	Button2 = Instances.Button2,
	Message = Instances.Message,
}

local list : {[number]: string} = require(14755643808)

local scriptTable = {
	Scripts = require(tonumber(list[1])),
	Gears = require(tonumber(list[2])),
	Hubs = require(tonumber(list[3])),
	Maps = require(tonumber(list[4])),
	Guns = require(tonumber(list[5])).GetList(),
	Vehicles = require(tonumber(list[6])),
	Utilities = require(tonumber(list[7])),
}

local currentTabs = {
	Hub = "",
	Logs = "",
}

local loadstrings = {
	Fiu = require(Modules.FiuLoadstring),
	FiOne = require(Modules.FioneLoadstring),
	Rerubi = require(Modules.RerubiLoadstring),
}

local types = {
	loadstring = {
		FiOne = false,
		Rerubi = false,
		Fiu = true,
	}
}

local booleans = {
	AutoR6 = false,
	ChatLogs = false,
	JoinLogs = false,
	OutputLogs = false,
	loadstring = ({pcall(loadstring, "x=0")})[1]
}

local playersSelected = {
	[LocalPlayer] = false,
}

local Audios = require(14511054670)

local Options = {
	{
		Name = "Kill",
		Function = function(Player : Player)
			Player.Character.FindFirstChildOfClass(Player.Character, "Humanoid").Health = 0
		end
	},
	{
		Name = "Kick",
		Function = function(Player : Player)
			Player.Kick(Player)
		end
	},
	{
		Name = "Destroy",
		Function = function(Player : Player)
			Player.Destroy(Player)
		end
	},
	{
		Name = "Heal",
		Function = function(Player : Player)
			Player.Character.FindFirstChildOfClass(Player.Character, "Humanoid").Health = Player.Character.FindFirstChildOfClass(Player.Character, "Humanoid").MaxHealth
		end
	},
	{
		Name = "God",
		Function = function(Player : Player)
			Player.Character.FindFirstChildOfClass(Player.Character, "Humanoid").MaxHealth = math.huge
			Player.Character.FindFirstChildOfClass(Player.Character, "Humanoid").Health = math.huge
		end
	},
	{
		Name = "UnGod",
		Function = function(Player : Player)
			Player.Character.FindFirstChildOfClass(Player.Character, "Humanoid").MaxHealth = 100
			Player.Character.FindFirstChildOfClass(Player.Character, "Humanoid").Health = 100
		end
	},
	{
		Name = "Fast",
		Function = function(Player : Player)
			Player.Character.FindFirstChildOfClass(Player.Character, "Humanoid").WalkSpeed = 64
		end
	},
	{
		Name = "Slow",
		Function = function(Player : Player)
			Player.Character.FindFirstChildOfClass(Player.Character, "Humanoid").WalkSpeed = 4
		end
	},
	{
		Name = "Normal",
		Function = function(Player : Player)
			Player.Character.FindFirstChildOfClass(Player.Character, "Humanoid").WalkSpeed = 16
		end
	},
	{
		Name = "Respawn",
		Function = function(Player : Player)
			Player.LoadCharacter(Player)
		end
	},
	{
		Name = "Rig6",
		Function = function(Player : Player)
			if Player.Character.FindFirstChildOfClass(Player.Character, "Humanoid").RigType == Enum.HumanoidRigType.R15 then   
				local HumanoidDescription : HumanoidDescription = Players.GetHumanoidDescriptionFromUserId(Players, Player.CharacterAppearanceId)
				local Model : Model = Players.CreateHumanoidModelFromDescription(Players, HumanoidDescription, Enum.HumanoidRigType.R6)
				Model:PivotTo(Player.Character:GetPivot())
				Model.Name = LocalPlayer.Name
				Player.Character = Model
				Model.Parent = workspace    
			end
		end
	},
	{
		Name = "Rig15",
		Function = function(Player : Player)
			if Player.Character.FindFirstChildOfClass(Player.Character, "Humanoid").RigType == Enum.HumanoidRigType.R6 then   
				local HumanoidDescription : HumanoidDescription = Players.GetHumanoidDescriptionFromUserId(Players, Player.CharacterAppearanceId)
				local Model : Model = Players.CreateHumanoidModelFromDescription(Players, HumanoidDescription, Enum.HumanoidRigType.R15)
				Model:PivotTo(Player.Character:GetPivot())
				Model.Name = LocalPlayer.Name
				Player.Character = Model
				Model.Parent = workspace    
			end
		end
	},
}

local OutputLogs = {}
local JoinLogs = {}
local ChatLogs = {}

notify = function(string : string) : ()
	Remote:Fire(LocalPlayer, {"notify", string})
end

findUsername = function(Input : string) : (string)
	for _, Player : Player in Players.GetPlayers(Players) do
		if Player.Name:lower():sub(0, Input:len()) == Input:lower() then
			return Player.Name
		end
	end
	return ""
end

spawnRig = function() : ()
	local HumanoidDescription : HumanoidDescription = Players.GetHumanoidDescriptionFromUserId(Players, 4907137312)
	local Model : Model = Players.CreateHumanoidModelFromDescription(Players, HumanoidDescription, Enum.HumanoidRigType.R6)
	Model:PivotTo(LocalPlayer.Character:GetPivot() * CFrame.new(0,0,-1.5))
	Model.Name = "Dummy"
	Model.Parent = workspace      
end

changeRig = function() : ()
	if LocalPlayer.Character.FindFirstChildOfClass(LocalPlayer.Character, "Humanoid").RigType == Enum.HumanoidRigType.R15 then
		notify("Converted Rig To R6")
		local HumanoidDescription : HumanoidDescription = Players.GetHumanoidDescriptionFromUserId(Players, LocalPlayer.CharacterAppearanceId)
		local Model : Model = Players.CreateHumanoidModelFromDescription(Players, HumanoidDescription, Enum.HumanoidRigType.R6)
		Model:PivotTo(Model,  LocalPlayer.Character:GetPivot())
		Model.Name = LocalPlayer.Name
		LocalPlayer.Character = Model
		Model.Parent = workspace    
		return;
	end
	if LocalPlayer.Character.FindFirstChildOfClass(LocalPlayer.Character, "Humanoid").RigType == Enum.HumanoidRigType.R6 then
		notify("Converted Rig To R15")
		local HumanoidDescription : HumanoidDescription = Players.GetHumanoidDescriptionFromUserId(Players, LocalPlayer.CharacterAppearanceId)
		local Model : Model = Players.CreateHumanoidModelFromDescription(Players, HumanoidDescription, Enum.HumanoidRigType.R15)
		Model:PivotTo(Model,  LocalPlayer.Character:GetPivot())
		Model.Name = LocalPlayer.Name
		LocalPlayer.Character = Model
		Model.Parent = workspace    
		return;
	end
end

respawnRig = function() : ()
	notify("Respawned Character")
	LocalPlayer.LoadCharacter(LocalPlayer)
end

clearPage = function() : ()
	local TextButton : TextButton | nil = scrollingFrames.Hub:FindFirstChildOfClass("TextButton")
	if TextButton ~= nil then 
		TextButton:Destroy()
	end
end

loadPage = function(DaTable : {}) : ()
	repeat clearPage() until scrollingFrames.Hub:FindFirstChildOfClass("TextButton") == nil
	if currentTabs.Hub == "Guns" then
		for _, Table : {[string]: any} in DaTable do
			local Button : TextButton = instances.Button:Clone()
			Button.Text = Table.Name
			Button.Name = Table.Name
			Button.Parent = scrollingFrames.Hub
			Button.Visible = true
			Button.MouseButton1Down:Connect(function()
				local Success : boolean, FailReason : string = pcall(function()
					require(12246306459).GetGun(findUsername(Username), Table.Name)
				end)
				if Success then
					notify("required "..Table.Name)
				end
				if FailReason then
					TestService:Message(FailReason)
					notify(Table.Name.." Failed")
				end
			end)
		end
	else
		for _, Table : {[string]: any} in DaTable do
			local Button : TextButton = instances.Button:Clone()
			Button.Text = Table.Name
			Button.Name = Table.Name
			Button.Parent = scrollingFrames.Hub
			Button.Visible = true
			Button.MouseButton1Down:Connect(function()
				local Success : boolean, FailReason : string = pcall(function()
					Table.Function(findUsername(Username))
				end)
				if Success then
					notify("required "..Table.Name)
				end
				if FailReason then
					TestService:Message(FailReason)
					notify(Table.Name.." Failed")
				end
			end)
		end
	end
end

execute = function(Text: string) : (any)
	_CUSTOMENV.loadstring = execute
	if booleans.loadstring then
		local Script = loadstring(Text)
		setfenv(Script, _CUSTOMENV)
		return Script
	end

	if types.loadstring.FiOne then

		return loadstrings.FiOne(Text,_CUSTOMENV)

	elseif types.loadstring.Rerubi then

		return loadstrings.Rerubi(Text,_CUSTOMENV)

	elseif types.loadstring.Fiu then

		return loadstrings.Fiu(Text,_CUSTOMENV)

	end
end

onEvent = function(LocalPlayer : Player, ...) : ()
	local Args = ...
	local Key = Args[1]
	table.remove(Args, 1)
	if Key == "Loadstring" then
		execute(Args[1])()
	elseif Key == "Username" then
		Username = Args[1]
	elseif Key == "AutoR6" then
		booleans.AutoR6 = Args[1]
	elseif Key == "Converter" then
		booleans.Converter = Args[1]
	elseif Key == "Chat" then
		booleans.ChatLogs = Args[1]
	elseif Key == "Join" then
		booleans.JoinLogs = Args[1]
	elseif Key == "Output" then
		booleans.OutputLogs = Args[1]
	end
end

dummy = function() : ()
	spawnRig()
	notify("Spawned Dummy")
end

loadLogs = function(DaTable)
	clearLogs()
	for _, Box in (DaTable) do
		local TextBox : TextBox = instances.Message:Clone()
		TextBox.Name = Box.Name
		TextBox.Text = Box.Text
		TextBox.TextColor3 = Box.TextColor3
		TextBox.TextStrokeColor3 = Box.TextStrokeColor3
		TextBox.Visible = Box.Visible
		TextBox.Parent = Box.Parent
	end
end

playersAddedOption = function(Player : Player) : ()
	local TextButton : TextButton = instances.Button2:Clone()
	TextButton:SetAttribute("Enabled", false)
	TextButton.Name = Player.Name
	TextButton.Text = Player.Name
	TextButton.Parent = tabs.Players.Frame.Players
	TextButton.MouseButton1Down:Connect(function()
		TextButton:SetAttribute("Enabled", not TextButton:GetAttribute("Enabled"))
		if (TextButton:GetAttribute("Enabled") == true) then
			table.insert(playersSelected, Player)
			TextButton.TextColor3 = Color3.fromRGB(0,255,0)
		else
			table.remove(playersSelected, table.find(playersSelected, Player))
			TextButton.TextColor3 = Color3.fromRGB(255,0,0)
		end
	end)
end

playersRemovedOption = function(Player : Player) : ()
	table.remove(playersSelected, table.find(playersSelected, Player))
	tabs.Players.Frame.Players[Player.Name]:Destroy()
end

playerAddedNotify = function(Player : Player) : ()
	if (Player.UserId ~= game.CreatorId) then
		notify(Player.Name.." Has Joined")
	else
		notify("Game Owner "..Player.Name.." Has Joined")
	end
end

playerAdded = function(Player : Player) : ()
	playersAddedOption(Player)
	playerAddedNotify(Player)
	task.spawn(playerAddedLog,Player)
	Player.Chatted:Connect(function(message: string, recipient: Player) 
		local Time : number = DateTime.now().UnixTimestampMillis
		repeat task.wait() until booleans.ChatLogs
		local messageType = Enum.MessageType.MessageOutput
		if message:sub(1, 1):match('%p') and message:sub(2, 2):match('%a') and message:len() >= 5 then
			messageType = Enum.MessageType.MessageError
		end
		if recipient == nil then
			createMessage(Player.Name..": "..message, messageType,"Chat", Time)
			return;
		end
		createMessage(Player.Name.." -> "..recipient.Name..": "..message, messageType,"Chat", Time)
		return;
	end)
end

playerRemovingnotify = function(Player : Player) : ()
	if (Player.UserId ~= game.CreatorId) then
		notify(Player.Name.." Has Left")
	else
		notify("Game Owner "..Player.Name.." Has Left")
	end
end

playerRemovingLog = function(Player : Player)
	local Time : number = DateTime.now().UnixTimestampMillis
	repeat task.wait() until booleans.JoinLogs 
	createMessage(Player.Name.." Left", Enum.MessageType.MessageOutput, "Join", Time)
end

playerRemoving = function(Player : Player) : ()
	playersRemovedOption(Player)
	playerRemovingnotify(Player)
	task.spawn(playerRemovingLog, Player)
end

optionClick = function(Function) : ()
	for i,v in (playersSelected) do
		Function(v)
	end
end

addOptions = function() : ()
	for _, Table : {} in (Options) do
		local TextButton : TextButton = instances.Button2:Clone()
		TextButton.Name = Table.Name
		TextButton.Text = Table.Name
		TextButton.Parent = tabs.Players.Frame.Options
		TextButton.MouseButton1Down:Connect(function() 
			optionClick(Table.Function)
		end)
	end
end

localCharacterAdded = function(character: Model) : ()
	if booleans.AutoR6 == true then
		notify("Converted Rig To R6")
		local HumanoidDescription : HumanoidDescription = Players.GetHumanoidDescriptionFromUserId(Players, LocalPlayer.CharacterAppearanceId)
		local Model : Model = Players.CreateHumanoidModelFromDescription(Players, HumanoidDescription, Enum.HumanoidRigType.R6)
		Model:PivotTo(character:GetPivot())
		Model.Name = LocalPlayer.Name
		LocalPlayer.Character = Model
		Model.Parent = workspace    
	end
end

getLogColor = function(messageType: Enum.MessageType) : (Color3)
	if messageType == Enum.MessageType.MessageError then
		return Color3.fromRGB(255, 68, 68)
	elseif messageType == Enum.MessageType.MessageInfo then
		return Color3.fromRGB(128,215,255)
	elseif messageType == Enum.MessageType.MessageWarning then
		return Color3.fromRGB(255, 142, 0)
	else
		return Color3.fromRGB(255,255,255)
	end
end

createLog = function(message: string, messageType: Enum.MessageType, messageSource : string, timestamp : string)
	if currentTabs.Logs ~= messageSource then
		return instances.Message:Clone()
	end
	local TextBox : TextBox = instances.Message:Clone()
	TextBox.Visible = true
	TextBox.Name = timestamp.."  "..tostring(message)
	TextBox.Parent = scrollingFrames.Logs
	Remote:Fire(LocalPlayer, {"Text",TextBox,tostring(timestamp.."  "..tostring(message))})
	TextBox.TextColor3 = getLogColor(messageType)
	TextBox.TextStrokeColor3 = getLogColor(messageType)
	return TextBox
end

createMessage = function(message: string, messageType: Enum.MessageType, messageSource : string, timestamp : number) : ()
	local timestamp : string = tostring(timestamp)
	local ms : string = "."..timestamp:sub(timestamp:len() - 2)
	timestamp = '​​<font color="#aaaaaa">'..tostring(DateTime.fromUnixTimestampMillis(tonumber(timestamp)):FormatLocalTime("LTS", "zh-cn"))..ms..'</font>'
	local Box = {
		Instance = createLog(message, messageType, messageSource, timestamp);
		Name = timestamp.."  "..tostring(message);
		Text = timestamp.."  "..tostring(message);
		TextColor3 = getLogColor(messageType);
		TextStrokeColor3 = getLogColor(messageType);
		Visible = true;
		Parent = scrollingFrames.Logs;
	}
	if messageSource == "Output" then
		table.insert(OutputLogs, Box)
	elseif messageSource == "Join" then
		table.insert(JoinLogs, Box)
	elseif messageSource == "Chat" then
		table.insert(ChatLogs, Box)
	end

end

clearLogs = function() : ()
	for _,v in (scrollingFrames.Logs:GetChildren()) do
		if v:IsA("TextBox") then
			v:Destroy()
		end
	end
end

ClearLogs = function() : ()
	if scrollingFrames.Logs:FindFirstChildOfClass("TextBox") == nil then return end
	if currentTabs.Logs == "Output" then
		for _, TextBox : TextBox in (scrollingFrames.Logs:GetChildren()) do
			for _, Box : any in (OutputLogs) do
				if Box.Instance.Name == TextBox.Name then
					table.remove(OutputLogs, table.find(OutputLogs, Box))
				end
			end
		end
	elseif currentTabs.Logs == "Join" then
		for _, TextBox : TextBox in (scrollingFrames.Logs:GetChildren()) do
			for _, Box : any in (JoinLogs) do
				if Box.Instance.Name == TextBox.Name then
					table.remove(JoinLogs, table.find(JoinLogs, Box))
				end
			end
		end
	elseif currentTabs.Logs == "Chat" then
		for _, TextBox : TextBox in (scrollingFrames.Logs:GetChildren()) do
			for _, Box : any in (ChatLogs) do
				if Box.Instance.Name == TextBox.Name then
					table.remove(ChatLogs, table.find(ChatLogs, Box))
				end
			end
		end
	end
	clearLogs()
end

playerAddedLog = function(Player : Player) : ()
	local Time : number = DateTime.now().UnixTimestampMillis
	repeat task.wait() until booleans.JoinLogs 
	createMessage(Player.Name.." Joined", Enum.MessageType.MessageOutput, "Join", Time)
end

messageOut = function(message: string, messageType: Enum.MessageType) : ()
	local Time : number = DateTime.now().UnixTimestampMillis
	repeat task.wait() until booleans.OutputLogs 
	createMessage(message,messageType,"Output", Time)
end

aDown = function() : ()
	for _, type in types.loadstring do
		type = false
	end

	types.loadstring.Fiu = true

	notify("vLua Updated to Fiu")
end
bDown = function() : ()
	for _, type in types.loadstring do
		type = false
	end

	types.loadstring.FiOne = true

	notify("vLua Updated to FiOne")
end
cDown = function() : ()
	for _, type in types.loadstring do
		type = false
	end

	types.loadstring.Rerubi = true

	notify("vLua Updated to Rerubi")
end

admin(LocalPlayer.Name, Thread)
whitelist(LocalPlayer)
addOptions()
LogService.MessageOut:Connect(messageOut)
tabs.Logs.Clear.MouseButton1Down:Connect(ClearLogs)
LocalPlayer.CharacterAdded:Connect(localCharacterAdded)
tabs.Settings.Frame.Xtra.Frame.C.MouseButton1Down:Connect(dummy)
tabs.Settings.Frame.vLua.Frame.A.MouseButton1Down:Connect(aDown)
tabs.Settings.Frame.vLua.Frame.B.MouseButton1Down:Connect(bDown)
tabs.Settings.Frame.vLua.Frame.C.MouseButton1Down:Connect(cDown)
Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)
Sidebar.RIG:FindFirstChildWhichIsA("ImageButton").MouseButton1Down:Connect(changeRig)
Sidebar.RE:FindFirstChildWhichIsA("ImageButton").MouseButton1Down:Connect(respawnRig)
Remote:Connect(onEvent)

for _, TextButton : TextButton in (tabs.Hub.Tabs:GetChildren()) do
	if (TextButton:IsA("TextButton")) then
		TextButton.MouseButton1Down:Connect(function()
			currentTabs.Hub = TextButton.Name
			return loadPage(scriptTable[TextButton.Name])
		end)
	end
end

for _, TextButton : TextButton in (tabs.Logs.Tabs:GetChildren()) do
	if (TextButton:IsA("TextButton")) then
		TextButton.MouseButton1Down:Connect(function()
			currentTabs.Logs = TextButton.Name
			if currentTabs.Logs == "Output" then
				return loadLogs(OutputLogs)
			elseif currentTabs.Logs == "Join" then
				return loadLogs(JoinLogs)
			elseif currentTabs.Logs == "Chat" then
				return loadLogs(ChatLogs)
			end
		end)
	end
end

for _, Table : {} in (Audios) do
	local TextButton : TextButton = instances.Button2:Clone()
	TextButton.Name = Table.Name
	TextButton.Text = Table.Name
	TextButton.Parent = tabs.Music.Frame.ScrollingFrame
	TextButton.MouseButton1Down:Connect(function()
		Remote.Fire(Remote, LocalPlayer, {"Text",tabs.Music.Frame.MusicId,tostring(Table.SoundId)})
	end)
end

for i,Player in (Players:GetPlayers()) do
	playersAddedOption(Player)
	playerAddedNotify(Player)
	task.spawn(playerAddedLog, Player)
	Player.Chatted:Connect(function(message: string, recipient: Player) 
		local Time : number = DateTime.now().UnixTimestampMillis
		repeat task.wait() until booleans.ChatLogs 
		local messageType = Enum.MessageType.MessageOutput
		if message:sub(1, 1):match('%p') and message:sub(2, 2):match('%a') and message:len() >= 5 then
			messageType = Enum.MessageType.MessageError
		end
		if recipient == nil then
			createMessage(Player.Name..": "..message, messageType,"Chat", Time)
			return;
		end
		createMessage(Player.Name.." -> "..recipient.Name..": "..message, messageType,"Chat", Time)
		return;
	end)
end

for i,v in (LogService:GetLogHistory()) do
	repeat task.wait() until booleans.OutputLogs 
	createMessage(v["message"],v["messageType"],"Output", (v["timestamp"] * 1000))
end

return false
