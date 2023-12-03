local _ENV = getfenv()

task.spawn(function()
	require(script:FindFirstChild("Modules"):FindFirstChild("Load")).Load(script.Parent.Frame, script.Parent.Main)
end)

local Players : Players = game:GetService("Players")
local RunService : RunService = game:GetService("RunService")
local LogService : LogService = game:GetService("LogService")
local TestService : TestService = game:GetService("TestService")
local UserInputService : UserInputService = game:GetService("UserInputService")
local TweenService : TweenService = game:GetService"TweenService"

local Parent = script.Parent
local Main = Parent.Main
local Sidebar = Main.Sidebar
local Holder = Main.Holder.Holder

local Audios = script.Audios
local Buttons = script.Buttons
local Modules = script.Modules
local Values = script.Values

local FastNet2 = require(Parent.Universal.FastNet2)
local Remote = FastNet2.new("Remote")

local LocalPlayer : Player = (Players.LocalPlayer)

local PageSystem : UIPageLayout = Holder.PageSystem
local Lines = Holder.Executer.Frame.CodeBox.Lines
local Code = Holder.Executer.Frame.CodeBox.CodeBox

local Highlight = Instance.new("Highlight")
local notify : boolean = true
local val : number = 1

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

local _ENV = {
	Dragify = require(Modules.Dragify),
	Highlighter = require(Modules.Highlighter),
	Blur = require(Modules.Blur),
	Scroll = require(Modules.Scroll),
	Execute = require(Modules.Execute),
	Clear = require(Modules.Clear),
	Search = require(Modules.Search),
	Notify = require(Modules.Notify),
	Audio = require(Modules.Audio),
	Visible = require(Modules.Visible),
	Taskbar = require(Modules.Taskbar),
	Theme = require(Modules.Theme),
	Credit = require(Modules.Credit),
	Visualizer = require(Modules.VisualizerSmooth),
}

local Highlights = {}


setText = function(key, instance, text)
	if key == "SetText" then
		instance.Text = text
	end
end

ExecutorTextChanged = function() : ()
	local lin = 1
	Code.Text:gsub("\n", function()
		lin = lin + 1
	end)
	Lines.Text = ""
	for i = 1, lin do
		Lines.Text = Lines.Text .. i .. "\n"
	end
end

FixMouse = function() : ()
	Players.LocalPlayer:GetMouse().Icon = 0;
	if doNotify then
		_ENV.Notify("Fixed Mouse")
	end
end

FixCamera = function() : ()
	workspace.CurrentCamera.CameraSubject = Players.LocalPlayer.Character
	if doNotify then
		_ENV.Notify("Fixed Camera")
	end
end

openAudios = function() : ()
	if tabs.Music.Frame:FindFirstChild("ScrollingFrame").Size == UDim2.new(0,0,0,290) then
		tabs.Music.Frame:FindFirstChild("ScrollingFrame"):TweenSize(UDim2.fromOffset(225, 290))
	elseif tabs.Music.Frame:FindFirstChild("ScrollingFrame").Size ==  UDim2.new(0,225,0,290) then
		tabs.Music.Frame:FindFirstChild("ScrollingFrame"):TweenSize(UDim2.fromOffset(0, 290))
	end
end

setHubUsername = function() : ()
	Remote:Fire({"Username", tabs.Hub.Username:FindFirstChildWhichIsA("TextBox").Text})
end

ColorizeESP = function(v) : ()
	v.FillColor = script.Values.Color1.Value
	v.OutlineColor = script.Values.Color2.Value
	v.OutlineTransparency = tonumber(tabs.Settings.Frame["Chams"].Frame:FindFirstChild("T1").Text)
	v.FillTransparency = tonumber(tabs.Settings.Frame["Chams"].Frame:FindFirstChild("T2").Text)
end

DestroyHighlight = function(Character) : ()
	for i,v in (Highlights) do
		if v == Character.Name then
			table.remove(Highlights, table.find(Highlights, v))
			v:Destroy()
		end
	end
end

CreateHighlight = function(Character) : ()
	local HighlightClone = Highlight:Clone()
	table.insert(Highlights, HighlightClone)
	HighlightClone.Adornee = Character
	HighlightClone.Parent = Character:FindFirstChild("HumanoidRootPart")
	HighlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	HighlightClone.Name = Character.Name
end

CharacterAdded = function(Character) : ()
	if (tabs.Settings.Frame["Chams"].Frame:FindFirstChild("E").Text == "X") then
		repeat RunService.RenderStepped:Wait() until Character
		repeat RunService.RenderStepped:Wait() until Character:FindFirstChild("HumanoidRootPart")
		CreateHighlight(Character)
	else
		DestroyHighlight(Character)
	end
end

PlayerAdded = function(Player : Player) : ()
	Player.CharacterAdded:Connect(CharacterAdded)
	Player.CharacterRemoving:Connect(DestroyHighlight)
end

CheckESPEnabled = function() : ()
	if (tabs.Settings.Frame["Chams"].Frame:FindFirstChild("E").Text == "") then
		for i,Highlight in (Highlights) do
			Highlight:Destroy()
		end
	elseif (tabs.Settings.Frame["Chams"].Frame:FindFirstChild("E").Text == "X") then
		for i,Player in Players:GetPlayers() do
			CharacterAdded(Player.Character)
		end
	end
end

onRenderStep = function(deltaTime) : ()
	_ENV.Theme.Theme(
		Color3.fromHSV(
			tonumber(tabs.Settings.Frame["Main Color"].Frame:FindFirstChild("H").Text),
			tonumber(tabs.Settings.Frame["Main Color"].Frame:FindFirstChild("S").Text),
			tonumber(tabs.Settings.Frame["Main Color"].Frame:FindFirstChild("V").Text)
		),
		Color3.fromHSV(
			tonumber(tabs.Settings.Frame["Sub Color"].Frame:FindFirstChild("H").Text),
			tonumber(tabs.Settings.Frame["Sub Color"].Frame:FindFirstChild("S").Text),
			tonumber(tabs.Settings.Frame["Sub Color"].Frame:FindFirstChild("V").Text)
		)
	)
	for i,v in (Highlights) do
		ColorizeESP(v)
	end
	Main.Sidebar.Time.Text = "       "..os.date("%I:%M %p", os.time())
end

toggleESP = function() : ()
	if tabs.Settings.Frame["Chams"].Frame:FindFirstChild("E").Text == "" then
		tabs.Settings.Frame["Chams"].Frame:FindFirstChild("E").Text = "X"
		return;
	end
	if tabs.Settings.Frame["Chams"].Frame:FindFirstChild("E").Text == "X" then
		tabs.Settings.Frame["Chams"].Frame:FindFirstChild("E").Text = ""
		return;
	end
end

left = function() : ()
	if val == 1 then
	else
		val -= 1
	end
	tabs.Settings.Frame.Theme.Frame:FindFirstChild("Option").Text = tostring(val)
end

right = function() : ()
if val == 20 then
else
	val += 1
end
tabs.Settings.Frame.Theme.Frame:FindFirstChild("Option").Text = tostring(val)
end

Clear = function() : ()
	for i,v in (tabs.Settings.Frame.vLua.Frame:GetChildren()) do
		if (v:IsA("TextButton")) then
			v.Text = ""
		end
	end
end

opennclosedown = function() : ()
	if Main.Visible == true then
		_ENV.Blur.unBlur(Main)
		Main.Visible = false
	else
		_ENV.Blur.blur(Main)
		Main.Visible = true
	end
end

openncloseenter = function() : ()
	TweenService:Create(
		Parent["Open/Close"],
		TweenInfo.new(1),
		{
			Rotation = 360
		}
	):Play()
end

openncloseleave = function() : ()
	TweenService:Create(
		Parent["Open/Close"],
		TweenInfo.new(1),
		{
			Rotation = 0
		}
	):Play()
end

toggleAutoR6 = function() : ()
	if tabs.Settings.Frame["Toggles"].Frame:FindFirstChild("C").Text == "" then
		tabs.Settings.Frame["Toggles"].Frame:FindFirstChild("C").Text = "X"
		Remote:Fire({"AutoR6", true})
		return;
	end
	if tabs.Settings.Frame["Toggles"].Frame:FindFirstChild("C").Text == "X" then
		tabs.Settings.Frame["Toggles"].Frame:FindFirstChild("C").Text = ""
		Remote:Fire({"AutoR6", false})
		return;
	end
end

toggleNotifications = function() : ()
	if tabs.Settings.Frame["Toggles"].Frame:FindFirstChild("B").Text == "" then
		tabs.Settings.Frame["Toggles"].Frame:FindFirstChild("B").Text = "X"
		doNotify = true
		return;
	end
	if tabs.Settings.Frame["Toggles"].Frame:FindFirstChild("B").Text == "X" then
		tabs.Settings.Frame["Toggles"].Frame:FindFirstChild("B").Text = ""
		doNotify = false
		return;
	end
end

toggleConverter = function() : ()
	if tabs.Settings.Frame["Toggles"].Frame:FindFirstChild("A").Text == "" then
		tabs.Settings.Frame["Toggles"].Frame:FindFirstChild("A").Text = "X"
		Remote:Fire({"Converter", true})
		return;
	end
	if tabs.Settings.Frame["Toggles"].Frame:FindFirstChild("A").Text == "X" then
		tabs.Settings.Frame["Toggles"].Frame:FindFirstChild("A").Text = ""
		Remote:Fire({"Converter", false})
		return;
	end
end

toggleChat = function() : ()
	if tabs.Settings.Frame["Toggles2"].Frame:FindFirstChild("A").Text == "" then
		tabs.Settings.Frame["Toggles2"].Frame:FindFirstChild("A").Text = "X"
		Remote:Fire({"Chat", true})
		return;
	end
	if tabs.Settings.Frame["Toggles2"].Frame:FindFirstChild("A").Text == "X" then
		tabs.Settings.Frame["Toggles2"].Frame:FindFirstChild("A").Text = ""
		Remote:Fire({"Chat", false})
		return;
	end
end

toggleJoin = function() : ()
	if tabs.Settings.Frame["Toggles2"].Frame:FindFirstChild("B").Text == "" then
		tabs.Settings.Frame["Toggles2"].Frame:FindFirstChild("B").Text = "X"
		Remote:Fire({"Join", true})
		return;
	end
	if tabs.Settings.Frame["Toggles2"].Frame:FindFirstChild("B").Text == "X" then
		tabs.Settings.Frame["Toggles2"].Frame:FindFirstChild("B").Text = ""
		Remote:Fire({"Join", false})
		return;
	end
end

toggleOutput = function() : ()
	if tabs.Settings.Frame["Toggles2"].Frame:FindFirstChild("C").Text == "" then
		tabs.Settings.Frame["Toggles2"].Frame:FindFirstChild("C").Text = "X"
		Remote:Fire({"Output", true})
		return;
	end
	if tabs.Settings.Frame["Toggles2"].Frame:FindFirstChild("C").Text == "X" then
		tabs.Settings.Frame["Toggles2"].Frame:FindFirstChild("C").Text = ""
		Remote:Fire({"Output", false})
		return;
	end
end

OnInvoke = function(...) : ()
	local Args = ...
end

OnEvent = function(...) : ()
	local Args = ...
	if Args[1] == "Text" then
		Args[2][Args[1]] = Args[3]
	elseif Args[1] == "Notify" then
		if doNotify then
			_ENV.Notify(Args[2], script.Parent:FindFirstChild("Notifications"))
		end
	end
end

_ENV.Highlighter.highlight({textObject = tabs.Executer.Frame.CodeBox.CodeBox})
_ENV.Dragify(Main)
_ENV.Dragify(Parent["Open/Close"])
_ENV.Blur.blur(Parent["Open/Close"])
_ENV.Scroll.insertInput(scrollingFrames.Hub, 0.03, Vector2.new(0, 45))
_ENV.Scroll.insertInput(scrollingFrames.Changelogs, 0.03, Vector2.new(0, 0))
_ENV.Scroll.insertInput(scrollingFrames.Credits, 0.03, Vector2.new(0, 20))
_ENV.Scroll.insertInput(scrollingFrames.Options, 0.03, Vector2.new(0, 20))
_ENV.Scroll.insertInput(scrollingFrames.Players, 0.03, Vector2.new(0, 20))
_ENV.Scroll.insertInput(scrollingFrames.Frame, 0.03, Vector2.new(0, 0))
_ENV.Scroll.insertInput(scrollingFrames.Logs, 0.03, Vector2.new(0, 0))
_ENV.Execute(tabs.Executer.Frame.Execute, tabs.Executer.Frame.CodeBox.CodeBox, Remote)
_ENV.Clear(tabs.Executer.Frame.Clear, tabs.Executer.Frame.CodeBox.CodeBox)
_ENV.Search(tabs.Hub.Search.Search, scrollingFrames.Hub)
_ENV.Search(tabs.Logs.Search.Search, scrollingFrames.Logs)
_ENV.Visualizer(Modules.Audio.Sound, tabs.Music.Frame.BarsHolder.BarsForward,tabs.Music.Frame.BarsHolder.BarsReversed, 20)

RunService.RenderStepped:Connect(onRenderStep)
tabs.Settings.Frame.Toggles.Frame:FindFirstChild("A").MouseButton1Down:Connect(toggleConverter)
tabs.Settings.Frame.Toggles.Frame:FindFirstChild("B").MouseButton1Down:Connect(toggleNotifications)
tabs.Settings.Frame.Toggles.Frame:FindFirstChild("C").MouseButton1Down:Connect(toggleAutoR6)
tabs.Settings.Frame.Toggles2.Frame:FindFirstChild("A").MouseButton1Down:Connect(toggleChat)
tabs.Settings.Frame.Toggles2.Frame:FindFirstChild("B").MouseButton1Down:Connect(toggleJoin)
tabs.Settings.Frame.Toggles2.Frame:FindFirstChild("C").MouseButton1Down:Connect(toggleOutput)
Parent["Open/Close"].MouseEnter:Connect(openncloseenter)
Parent["Open/Close"].MouseLeave:Connect(openncloseleave)
Parent["Open/Close"].MouseButton1Down:Connect(opennclosedown)
tabs.Hub.Username:FindFirstChildWhichIsA("TextBox"):GetPropertyChangedSignal("Text"):Connect(setHubUsername)
tabs.Music.Frame.ImageButton.MouseButton1Down:Connect(openAudios)
Remote:Connect(OnEvent)
tabs.Settings.Frame.Xtra.Frame.A.MouseButton1Down:Connect(FixMouse)
tabs.Settings.Frame.Xtra.Frame.B.MouseButton1Down:Connect(FixCamera)
tabs.Hub.Username:FindFirstChildWhichIsA("TextBox").Text = Players.LocalPlayer.Name
Players.PlayerAdded:Connect(PlayerAdded)
for i,Player in Players:GetPlayers() do
	PlayerAdded(Player)
end
tabs.Settings.Frame["Chams"].Frame:FindFirstChild("E").MouseButton1Down:Connect(toggleESP)
tabs.Settings.Frame["Chams"].Frame:FindFirstChild("E"):GetPropertyChangedSignal("Text"):Connect(CheckESPEnabled)
tabs.Settings.Frame.Theme.Frame:FindFirstChild("Left").MouseButton1Down:Connect(left)
tabs.Settings.Frame.Theme.Frame:FindFirstChild("Right").MouseButton1Down:Connect(right)
tabs.Executer.Frame.CodeBox.CodeBox:GetPropertyChangedSignal("Text"):Connect(ExecutorTextChanged)
PageSystem:JumpTo(Holder:FindFirstChild("Home"))
_ENV.Blur.blur(Parent:WaitForChild("Base"))
Parent:WaitForChild("Base").CMDBar.SearchResults.ChildAdded:Connect(function(instance: Instance)
	if instance:IsA("ImageLabel") then
		_ENV.Blur.blur(instance)
		instance.Destroying:Connect(function() 
			_ENV.Blur.unBlur(instance)
		end)
	end
end)

for i,v in (tabs.Settings.Frame.vLua.Frame:GetChildren()) do
	if (v:IsA("TextButton")) then
		v.MouseButton1Down:Connect(function()
			Clear()
			v.Text = "X"
		end)
	end
end

for i,v in (_ENV.Credit) do
	local z = script.Buttons.Button:Clone()
	z.Name = v
	z.Text = v
	z.Parent = scrollingFrames.Credits
end

for i,v in (scrollingFrames.Frame:GetChildren()) do
	if (v:IsA("TextButton")) then
		v.MouseButton1Down:Connect(function()
			for i,x in (scrollingFrames.Frame:GetChildren()) do
				if (x:IsA("TextButton")) then
					if x ~= v then
						TweenService:Create(x, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
						TweenService:Create(x.TextLabel, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {TextTransparency = 0.5}):Play()
						TweenService:Create(x.Icon, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {ImageTransparency = 0.5}):Play()
						TweenService:Create(x.Shadow, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {ImageTransparency = 1}):Play()
					end
				end
			end
			TweenService:Create(v, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.5}):Play()
			TweenService:Create(v.TextLabel, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
			TweenService:Create(v.Icon, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {ImageTransparency = 0}):Play()
			TweenService:Create(v.Shadow, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {ImageTransparency = 0.5}):Play()
			PageSystem:JumpTo(Holder:FindFirstChild(v.Name))
		end)
	end
end

for i,v in (tabs.Hub.Tabs:GetChildren()) do
	if (v:IsA("TextButton")) then
		v.MouseButton1Down:Connect(function()
			for i,x in (tabs.Hub.Tabs:GetChildren()) do
				if (x:IsA("TextButton")) then
					if x ~= v then
						TweenService:Create(x, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
						TweenService:Create(x.TextLabel, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {TextTransparency = 0.5}):Play()
						TweenService:Create(x.Shadow, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {ImageTransparency = 1}):Play()
					end
				end
			end
			TweenService:Create(v, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.5}):Play()
			TweenService:Create(v.TextLabel, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
			TweenService:Create(v.Shadow, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {ImageTransparency = 0.5}):Play()
		end)
	end
end

for i,v in (tabs.Logs.Tabs:GetChildren()) do
	if (v:IsA("TextButton")) then
		v.MouseButton1Down:Connect(function()
			for i,x in (tabs.Logs.Tabs:GetChildren()) do
				if (x:IsA("TextButton")) then
					if x ~= v then
						TweenService:Create(x, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
						TweenService:Create(x.TextLabel, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {TextTransparency = 0.5}):Play()
						TweenService:Create(x.Shadow, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {ImageTransparency = 1}):Play()
					end
				end
			end
			TweenService:Create(v, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.5}):Play()
			TweenService:Create(v.TextLabel, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
			TweenService:Create(v.Shadow, TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {ImageTransparency = 0.5}):Play()
		end)
	end
end

for i,v in (tabs.Music.Frame.Input:GetChildren()) do
	if v:IsA("TextButton") then
		v.MouseButton1Down:Connect(function(x: number, y: number) 
			_ENV.Audio[v.Name](tonumber(tabs.Music.Frame.MusicId.Text))
		end)
	end
end

return false
