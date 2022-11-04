-- Library Core Loadstring
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/centerepic/SporeHub/main/Ocerium.lua"))()
local infyield = loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))
local cmdx = loadstring(game:HttpGet('https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source'))
local findrareore = loadstring(game:HttpGet('https://raw.githubusercontent.com/centerepic/SporeHub/main/rareorefinder.lua'))
local findpurpletree= loadstring(game:HttpGet('https://raw.githubusercontent.com/centerepic/SporeHub/main/purpletreefinder.lua'))
local hopserver= loadstring(game:HttpGet('https://raw.githubusercontent.com/centerepic/SporeHub/main/serverhop.lua'))


pcall(function()
	makefolder('SporeHub')
end)

local LocalPlayer = game.Players.LocalPlayer
local DialogFrame = LocalPlayer.PlayerGui.UserGui.Dialog

if LocalPlayer.Character:FindFirstChild("OwoChan Character") then LocalPlayer.Character:FindFirstChild("OwoChan Character"):Destroy() end

-- local clientid = game:GetService("RbxAnalyticsService"):GetClientId()
-- local x= game:HttpGet("https://script.google.com/macros/s/AKfycbzRb2OZ-RZGVqwqpHd804TqmZeeYpXyhIH-d9rFgadeO6lrVeHo5p7NQhtgmtJukZlD/exec?q="..clientid)
-- local encode = game:GetService("HttpService"):JSONDecode(x)

local TweenService = game:GetService("TweenService")


-- Creating Gui
local MainWindow = Library.Main("Spore Hub","RightShift") -- Name, Keybind

--Variables
local Mouses = game.Players.LocalPlayer:GetMouse()
local cmdm = Mouses
local cmdlp = game.Players.LocalPlayer
local Flying = false
local flyspeed = 1
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

LocalPlayer.CharacterAdded:Connect(function(character)
	character.ChildAdded:Connect(function(v)
		if v.Name == "OwoChan Character" then
			wait()
			v:Destroy()
		end
	end)
end)

-- Tables
local WhitelistedBy = {}
local CarsToGoThrough = {}
local teleports = {
	["Saved Position"] = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position),
	["Sellary"] = CFrame.new(workspace.Map.Sellary.Counter.Base.Position+Vector3.new(0,3,0)),
	["Cloudnite"] = CFrame.new(538.9296875, 431.7497253417969, 1087.94873046875),
	["Sunstone"] = CFrame.new(1021.5484619140625, 254.0724639892578, 66.387451171875),
	["Emerald"] = CFrame.new(495.00634765625, 273.7499084472656, 228.2249755859375),
	["Crystal"] = CFrame.new(1306.658447265625, -197.7500457763672, 1063.591552734375),
	["Granite"] = CFrame.new(1020.7206420898438, -197.7500457763672, 964.1624145507812),
	["Amethyst Ruby Sapphire"] = CFrame.new(-3174.744873046875, 17.24998664855957, 1490.7423095703125),
	["Volcanium Obsidian"] = CFrame.new(-2804.921142578125, -770.0180053710938, 2752.66357421875),
	["Purple"] = CFrame.new(1805.0465087890625, -6.750001430511475, -100.8020248413086),
	["Marble"] = CFrame.new(414.775390625, 3.7499990463256836, -1013.8052978515625),
	["Gold Silver"] = CFrame.new(615.041259765625, 10.2249174118042, -1505.692138671875),
	["Meteor Totem Spawn"] = CFrame.new(479.09503173828125, 300.6012878417969, 709.18994140625),
	["Secret Shack To Spawn Trusty Pickaxe"] = CFrame.new(137.37252807617188, 88.7499771118164, 1087.0753173828125),
	["Bloxy Cola"] = CFrame.new(-1226.447509765625, 78.7499771118164, -91.67998504638672),
	["Mountain Top Chair"] = CFrame.new(626.7719116210938, 985.7499389648438, 1518.8201904296875),
	["Meteor"] = CFrame.new(-3475.978515625, 18.252214431762695, 1045.462890625),
	["Electronics"] = CFrame.new(-99.753173828125, 249.3109130859375, 1097.116943359375),
	["Car Store"] = CFrame.new(697.6553955078125, 7.749998569488525, -1018.1237182617188),
	["Secret Store"] = CFrame.new(-515.148193359375, 4.250003814697266, -664.9369506835938),
	["Pickaxe Store"] = CFrame.new(739.2664794921875, 2.250000476837158, 66.53274536132812),
	["Sellary "] = CFrame.new(-460.55218505859375, 5.749998569488525, -66.22949981689453),
	["Utility"] = CFrame.new(-958.949462890625, 16.74793815612793, -623.6137084960938),
	["Land"] = CFrame.new(-1007.12646484375, 10.46895980834961, -695.9650268554688),
	["Furniture"] = CFrame.new(-1018.1682739257812, 9.824016571044922, 722.9318237304688),
}

local teleportfunctions = {
	["Compactor"] = function()
		local Plot = GetPlayersBase(game.Players.LocalPlayer)
		local Compactor = Plot.Objects:findFirstChild("Compactor")
		if Compactor then
			return CFrame.new(Compactor.Conveyor.Belt.Part.Position + Vector3.new(0, 5, 0))
		else
			Library:CreateNotification("You don't have a Compactor.", 5)
		end
		return false
	end,
}

-- // Public Functions

local Events = game.ReplicatedStorage.Events
local function Grab(Bool, Part)
	task.spawn(function()
		if Bool == true then
			Part.Velocity = Vector3.new(0,1,0)
			Events.Grab:InvokeServer(Part, {}) 
		elseif Bool == false then
			Events.Ungrab:FireServer(Part, false, {})
		end
	end)
end

local NeinCliping
local function NeinClip()
	local Clip = false
	local function NeinClipLoop()
		if Clip == false and cmdlp.Character ~= nil then
			for _, child in pairs(cmdlp.Character:GetDescendants()) do
				if child:IsA("BasePart") and child.CanCollide == true then
					child.CanCollide = false
				end
			end
		end
	end
	NeinCliping = game:GetService('RunService').Stepped:connect(NeinClipLoop)
end

local function Fliegen(vfly)
	Flying = false
	while not cmdlp or not cmdlp.Character or not cmdlp.Character:FindFirstChild('HumanoidRootPart') or not game.Players.LocalPlayer.Character:FindFirstChild('Humanoid') or not cmdm do
		wait()
	end 
	local T = cmdlp.Character.HumanoidRootPart
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0
	local function Fly()
		Flying = true
		local BG = Instance.new('BodyGyro', T)
		local BV = Instance.new('BodyVelocity', T)
		BG.P = 9e4
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		spawn(function()
			while Flying do
				if not vfly then
					game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
				wait()
			end
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:destroy()
			BV:destroy()
			game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
		end)
	end
	cmdm.KeyDown:connect(function(KEY)
		if KEY:lower() == 'w' then
			if vfly then
				CONTROL.F = flyspeed
			else
				CONTROL.F = flyspeed
			end
		elseif KEY:lower() == 's' then
			if vfly then
				CONTROL.B = - flyspeed
			else
				CONTROL.B = - flyspeed
			end
		elseif KEY:lower() == 'a' then
			if vfly then
				CONTROL.L = - flyspeed
			else
				CONTROL.L = - flyspeed
			end
		elseif KEY:lower() == 'd' then
			if vfly then
				CONTROL.R = flyspeed
			else
				CONTROL.R = flyspeed
			end
		elseif KEY:lower() == 'y' then
			if vfly then
				CONTROL.Q = flyspeed*2
			else
				CONTROL.Q = flyspeed*2
			end
		elseif KEY:lower() == 't' then
			if vfly then
				CONTROL.E = -flyspeed*2
			else
				CONTROL.E = -flyspeed*2
			end
		end
	end)
	cmdm.KeyUp:connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'y' then
			CONTROL.Q = 0
		elseif KEY:lower() == 't' then
			CONTROL.E = 0
		end
	end)
	Fly()
end

local function getimage(id)
	return "https://www.roblox.com/asset-thumbnail/image?assetId="..id.."&width=420&height=420&format=png"
end


local function GetTeleportArea(Where)
	if teleports[Where] then
		return teleports[Where]
	end
	if teleportfunctions[Where] then
		return teleportfunctions[Where]()
	end
	return Where
end

local function GetPlayersBase(plr)
	local plots = workspace.Plots:GetChildren()
	for i,v in pairs(plots) do
		local owner = v:FindFirstChild("Owner")
		if owner and owner.Value == plr then
			return v
		end
	end
end

local breakyoink = false


local function TeleportPlayer(CF)
	local Seat = game.Players.LocalPlayer.Character.Humanoid.SeatPart
	if Seat~= nil then
		local model = Seat.Parent
		local orientation, size = model:GetBoundingBox()
		Seat.Parent:PivotTo(CF+ Vector3.new(0,size.Y,0))
	else
		game.Players.LocalPlayer.Character:PivotTo(CF)
	end
end

local function UpdateList()
	local tab = {}
	tab[game.Players.LocalPlayer] = true
	for _,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.UserGui.Whitelist.Scroller:GetChildren()) do
		if v:findFirstChild("Stats") then
			if v.Stats.Desc.Text == "Whitelisted you." then
				tab[game.Players[v.Name]] = true
			end
		end
	end
	WhitelistedBy = tab
end

-- ///////////////////////////////////////////////////////////////////////////////

-- Ore Teleports Category
local Category = MainWindow.Category("Ores/Items",getimage(11370638847),"Crop",0)
--[[
ImageScaleTypes : "Crop" , "Fit" , "Slice" , "Stretch"
]]
local MaxStuds = 5
local Where = "Saved Position"

local function OreTeleport(Area)
	local pos = Area.Position
	for _,v in pairs(workspace.Grabable:GetChildren()) do
		pcall(function()
			local owner = v:FindFirstChild("Owner")
			if ((owner and (WhitelistedBy[owner.Value] or owner.Value == game.Players.LocalPlayer))) then
				if v.Name == "MaterialPart" and (v.PrimaryPart.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<= MaxStuds then
					task.wait(0.1) 
					local args = {
						[1] = v.PrimaryPart,
						[2] = {}
					}
					Grab(true,v.PrimaryPart)
					pos= pos+ Vector3.new(0,2,0)
					for _=1,5 do
						v:PivotTo(CFrame.new(pos))
					end
				end
			end
		end)
	end
end


-- Creating Folders
local Folder = Category.Folder("Ores Teleporting")


local insideDropDown,DropDown = Folder.Dropdown('Positions')

Folder.Button("Save Current Position", function()
	teleports["Saved Position"] = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
end)

local Slider = Folder.Slider("Max Studs",1,100, function(Value)
	MaxStuds=tonumber(Value)
end,5,true)


local tab = {'Saved Position', 'Sellary', 'Compactor'}

-- Creating Dropdown
DropDown.Text = 'Saved Position'
local buttons = {}
local function AddButton(plr)
	-- Creating Buttons
	buttons[plr.Name] = insideDropDown.Choice(plr.Name.."'s Plot",function()
		Where =CFrame.new(GetPlayersBase(plr).Base.Position+Vector3.new(0,3,0))
		DropDown.Text = plr.Name.."'s Plot"
	end)
end

for _,v in pairs(tab) do
	-- Creating Buttons
	buttons[v] = insideDropDown.Choice(v,function()
		Where = v
		DropDown.Text = v
	end)
end


game.Players.PlayerAdded:Connect(function(plr)
	AddButton(plr)
end)
game.Players.PlayerRemoving:Connect(function(plr)
	buttons[plr.Name]:Destroy()
end)
for _,plr in pairs(game.Players:GetPlayers()) do
	AddButton(plr)
end


-- Creating Labels
Folder.Label("Buttons")

Folder.Button('Teleport Ore To Selected Area',function()
	UpdateList()
	OreTeleport(GetTeleportArea(Where))
end)

Folder.Button("Sell Ores", function()
	game:GetService("Workspace").Map.Sellary.Keeper.IPart.Interact:FireServer()
	firesignal(DialogFrame:WaitForChild("Yes",5).MouseButton1Click)
end)

Folder.Button("Teleport to Selected Area", function()
	TeleportPlayer(GetTeleportArea(Where))
end)


local MaxStuds = 5
local Where = "Saved Position"

local function ItemTeleport(Area)
	local pos = Area.Position
	for i,v in pairs( workspace.Grabable:GetChildren()) do
		pcall(function()
			local owner = v:FindFirstChild("Owner")
			if ((owner and (WhitelistedBy[owner.Value] or owner.Value == game.Players.LocalPlayer))) then
				if (v.PrimaryPart.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<= MaxStuds then
					task.wait(0.1) 
					local args = {
						[1] = v.PrimaryPart,
						[2] = {}
					}
					Grab(true,v.PrimaryPart)
					pos= pos+ Vector3.new(0,2,0)
					for i=1,5 do
						v:PivotTo(CFrame.new(pos))
					end
				end
			end
		end)
	end
end

-- Creating Folders
local Folder = Category.Folder("Entities Teleporting")

local tab = {'Saved Position', 'Sellary', 'Compactor'}

-- Creating Labels
local insideDropDown,DropDown = Folder.Dropdown('Positions')
DropDown.Text = 'Saved Position'

Folder.Button("Save Current Position", function()
	teleports["Saved Position"] = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
end)

local Slider = Folder.Slider("Max Studs",1,100, function(Value)
	MaxStuds=tonumber(Value)
end,5,true)


local buttons = {}

local function Add_Button(plr)
	-- Creating Buttons
	buttons[plr.Name] = insideDropDown.Choice(plr.Name.."'s Plot",function()
		Where = CFrame.new(GetPlayersBase(plr).Base.Position+Vector3.new(0,3,0))
		DropDown.Text = plr.Name.."'s Plot"
	end)
end

for _,v in pairs(tab) do
	-- Creating Buttons
	buttons[v] = insideDropDown.Choice(v,function()
		Where = v
		DropDown.Text = v
	end)
end


game.Players.PlayerAdded:Connect(function(plr)
	Add_Button(plr)
end)
game.Players.PlayerRemoving:Connect(function(plr)
	buttons[plr.Name]:Destroy()
end)
for _,plr in pairs(game.Players:GetPlayers()) do
	Add_Button(plr)
end
-- Creating Labels
Folder.Label("Buttons")

Folder.Button('Teleport Entities To Selected Area',function()
	UpdateList()
	ItemTeleport(GetTeleportArea(Where))
end)

Folder.Button("Teleport to Selected Area", function()
	TeleportPlayer(GetTeleportArea(Where))
end)

-- ///////////////////////////////////////////////////////////////////////////////
-- ///////////////////////////////////////////////////////////////////////////////
if (isLGPremium and isLGPremium()) then

	function antianchored(part)
		for I,V in pairs(part:GetConnectedParts(true)) do
			if V.Anchored then
				print("Assembly is anchored")
				return false
			end
		end
		return true
	end

	print("Assembly is not anchored")

	local whitelistedstuff={}

	function findoutwhitelisted(v)
		local fixedname = string.lower(v.Name)
		string.gsub(fixedname," ","")
		if whitelistedstuff[fixedname] then
			return true
		end
		if v.Name == "Tool" then
			local fixedname = string.lower(v.Configuration.Data.Tool.Value)
			string.gsub(fixedname," ","")

			if whitelistedstuff[fixedname] then
				return true
			end
		end
		if v.Name == "MaterialPart" then
			local fixedname = string.lower(v.Configuration.Data.MatInd.Value)
			string.gsub(fixedname," ","")
			if whitelistedstuff[fixedname] then
				return true
			end
		end
		return false
	end

	function Yoink(Area,who)
		breakyoink=false
		local plot = GetPlayersBase(game.Players.LocalPlayer)
		local pos = Area.Position
		local findParts = workspace.Grabable:GetChildren();
		local parts = workspace:GetPartBoundsInBox(plot.Base.CFrame,plot.Base.Size+Vector3.new(0,100,0))
		for _,v in pairs(workspace:GetPartBoundsInBox(Area,Vector3.new(150,150,150))) do
			table.insert(parts,v)
		end
		for i,v in pairs(findParts) do
			if findoutwhitelisted(v) then
				local owner = v:FindFirstChild("Owner")
				if ((owner and owner.Value == who and not table.find(parts,v.PrimaryPart)) or not owner) and not v:findFirstChild("Shop") then
					pcall(function()
						if antianchored(v.PrimaryPart) then
							if owner then
								--owner.Value = game.Players.LocalPlayer
							end

							local IsFar = true

							if (v.Part.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 15 then
								IsFar = false
							end

							if IsFar == true then
								game.Players.LocalPlayer.Character:PivotTo(v.PrimaryPart.CFrame)
								task.wait(0.2)
							end

							Grab(true,v.PrimaryPart)
							for i=1,5 do
								v:PivotTo(CFrame.new(pos))
							end
							pos= pos+Vector3.new(0,1,0)
						end
					end)
				end
			end
			if breakyoink then
				game.Players.LocalPlayer.Character:PivotTo(Area)
				breakyoink=false
				break
			end
		end
		game.Players.LocalPlayer.Character:PivotTo(Area)
	end

	function saveyoinksettings()
		pcall(function()
			writefile("SporeHub/YoinkSaveData.txt",game:GetService("HttpService"):JSONEncode(whitelistedstuff))
		end)
	end

	pcall(function()
		local val = readfile("SporeHub/YoinkSaveData.txt")
		if val then
			whitelistedstuff = game:GetService("HttpService"):JSONDecode(val)
		else
			whitelistedstuff= {}
		end
	end)

	-- Yoink Category
	local Category = MainWindow.Category("Premium Features",getimage(11371597556),"Fit",0)


	local Folder = Category.Folder("Yoink")

	local Where = "Saved Position"

	local insideDropDown,DropDown = Folder.Dropdown('Where')
	DropDown.Text = 'Saved Position'

	local Button = Folder.Button("Save Current Position", function()
		teleports["Saved Position"] = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
	end)

	pcall(function()
		for i,v in pairs(teleports) do
			insideDropDown.Choice(i,function()
				Where = i
				DropDown.Text = i
			end)

		end
		for i,v in pairs(teleportfunctions) do
			insideDropDown.Choice(i,function()
				Where = i
				DropDown.Text = i
			end)
		end
	end)

	local Label = Folder.Label("Buttons")


	-- Creating Dropdown
	local insideDropDown,DropDown = Folder.Dropdown('Who')
	DropDown.Text = "Select Player"
	local buttons = {}
	local function add_Button(plr)
		-- Creating Buttons
		buttons[plr.Name] = insideDropDown.Choice(plr.Name,function()
			Yoink(GetTeleportArea(Where),plr)
		end)
	end


	game.Players.PlayerAdded:Connect(function(plr)
		add_Button(plr)
	end)
	game.Players.PlayerRemoving:Connect(function(plr)
		buttons[plr.Name]:Destroy()
	end)
	for _,plr in pairs(game.Players:GetPlayers()) do
		add_Button(plr)
	end

	local Button = Folder.Button("Teleport to Selected Area", function()
		TeleportPlayer(GetTeleportArea(Where))
	end)

	local Button = Folder.Button("Stop Yoink", function()
		breakyoink=true
	end)

	-- // Yoink Whitelistening
	local Folder = Category.Folder('Yoink Whitelist')

	local insideDropDown,DropDown = Folder.Dropdown('Items')
	local WhitelistToggles = {}
	DropDown.Text = 'Items'

	for _,v in pairs(game:GetService("ReplicatedStorage").Items:GetChildren()) do
		local fixedname = string.lower(v.Name)
		string.gsub(fixedname," ","")
		local val = false
		if whitelistedstuff[fixedname] then
			val=true
		end
		local _,Toggle = insideDropDown.Toggle(v.Name,function(Value)
			if Value then
				whitelistedstuff[fixedname] = true
			else
				whitelistedstuff[fixedname] = nil
			end
			saveyoinksettings()
		end,val)
		table.insert(WhitelistToggles,Toggle)
	end

	local insideDropDown,DropDown = Folder.Dropdown('Tools')
	DropDown.Text = 'Tools'

	for _,v in pairs(game:GetService("ReplicatedStorage").Tools:GetChildren()) do
		local fixedname = string.lower(v.Name)
		string.gsub(fixedname," ","")
		local val = false
		if whitelistedstuff[fixedname] then
			val=true
		end
		local _,Toggle = insideDropDown.Toggle(v.Name,function(Value)
			if Value then
				whitelistedstuff[fixedname] = true
			else
				whitelistedstuff[fixedname] = nil
			end
			saveyoinksettings()
		end,val)
		table.insert(WhitelistToggles,Toggle)
	end

	local insideDropDown,DropDown = Folder.Dropdown('Ores/Materials')
	DropDown.Text = 'Ores/Materials'

	for _,v in pairs(game:GetService("ReplicatedStorage").Materials:GetChildren()) do
		local fixedname = string.lower(v.Name)
		string.gsub(fixedname," ","")
		local val = false
		if whitelistedstuff[fixedname] then
			val=true
		end
		local _,Toggle = insideDropDown.Toggle(v.Name,function(Value)
			if Value then
				whitelistedstuff[fixedname] = true
			else
				whitelistedstuff[fixedname] = nil
			end
			saveyoinksettings()
		end,val)
		table.insert(WhitelistToggles,Toggle)
	end

	Folder.Button("Whitelist All",function()
		for i,v in pairs(WhitelistToggles) do
			v.Set(true)
		end
	end)

	Folder.Button("Unwhitelist All",function()
		for i,v in pairs(WhitelistToggles) do
			v.Set(false)
		end
	end)

	-- // Other Functions

	local Folder = Category.Folder("Other")

	Folder.Button('Pickup Near Tools',function()
		for _,tool in pairs(workspace.Grabable:GetChildren()) do
			if tool.Name == "Tool" then
				if (tool.Part.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<30 then
					if tool.Part:findFirstChild("Interact") then
						tool.Part.Interact:FireServer()
					end
				end
			end
		end
	end)

	Folder.Button('Get All Blueprints',function()
		local plrsblueprints = game:GetService("Players").LocalPlayer.Values.Blueprints
		for _,v in pairs(game:GetService("ReplicatedStorage").Objects:GetChildren()) do
			if v.Configuration:findFirstChild("Category") then
				if not plrsblueprints:findFirstChild(v.Name) then
					local bool = Instance.new("BoolValue")
					bool.Name = v.Name
					bool.Parent = plrsblueprints
				end
			end
		end
	end)

	-- // Auto Mine
	local CanSpoof = true

	local oldIndex = nil 
	local Mouse = game.Players.LocalPlayer:GetMouse()
	local TargetPart = nil
	oldIndex = hookmetamethod(game, "__index", function(self, Index)
		if self == Mouse and not checkcaller() and TargetPart and CanSpoof then
			if Index == "Target" or Index == "target" then
				return TargetPart
			elseif Index == "Hit" or Index == "hit" then 
				return CFrame.new(TargetPart.Position)
			elseif Index == "X" or Index == "x" then 
				return oldIndex(self,"X")
			elseif Index == "Y" or Index == "y" then 
				return oldIndex(self,"Y")
			elseif Index == "UnitRay" then 
				return Ray.new(self.Origin, (self.Hit - self.Origin).Unit)
			end
		end

		return oldIndex(self, Index)
	end)

	-- Auto Mine Category
	local FakeMats = game:GetService("ReplicatedStorage").Mineables:GetChildren()
	local Mats = {}
	for _,Material in pairs(FakeMats) do
		if not string.lower(Material.Name):find("tree") then
			Mats[Material.Name] = {"Stage"..#Material:GetChildren()-1}
		end
	end

	function checkspored(ore)
		local desc= ore:GetDescendants()
		for _,v in pairs(desc) do
			if v:IsA("Highlight") then
				return false
			end
		end
		return true
	end

	function findore(OreName,MaxStage)
		for _,v in pairs(game:GetService("Workspace").WorldSpawn:GetChildren()) do
			if v.RockString.Value == OreName then
				if v.Rock:findFirstChild(MaxStage) and checkspored(v.Rock) then
					local rocks = {}
					for i,v in pairs(v.Rock:findFirstChild(MaxStage):GetChildren()) do
						if v.Name == "Part" then
							table.insert(rocks,v)
						end
					end
					if #rocks>0 then
						return rocks
					end
				end
			end
		end
		return
	end

	local Folder = Category.Folder("Automine")

	local AutoMines = {}
	local Mined = {}

	local safemode =false

	local function AutoFarm()
		game:GetService("ReplicatedStorage").Events.Message:Fire("Auto Farm Started", "!")
		while #AutoMines>0 do wait(1)
			for _,automine in pairs(AutoMines) do
				local ores = findore(automine,Mats[automine][1])
				print(findore(automine,Mats[automine][1]))
				if ores then
					for i,v in pairs(ores) do
						repeat
							TargetPart = ores[1]
							CanSpoof=true
							if safemode then
								game.Players.LocalPlayer.Character:PivotTo(CFrame.new(ores[1].Position+Vector3.new(0,-5,0)))
							else
								game.Players.LocalPlayer.Character:PivotTo(CFrame.new(ores[1].Position+Vector3.new(0,5,0)))
							end
							pcall(function()
								game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
							end)
							wait()
						until ores[1].Parent==nil or not table.find(AutoMines,automine) or not checkspored(ores[1].Parent)
						TargetPart=nil
						CanSpoof=false
						table.remove(ores,1)
					end
				end
			end	
			CanSpoof=false
		end
		wait(.5)
		TeleportPlayer(CFrame.new(GetPlayersBase(game.Players.LocalPlayer).Base.Position+Vector3.new(0,3,0)))
		game:GetService("ReplicatedStorage").Events.Message:Fire("Auto Farm Stopped", "!")
	end

	Folder.Toggle('SafeMode',function(value)
		safemode=value
	end)


	for i,v in pairs(Mats) do
		Folder.Toggle(i,function(value)
			local x = table.find(AutoMines,i)
			if x then
				table.remove(AutoMines,x)
			end
			if value then
				table.insert(AutoMines,i)
				if #AutoMines-1==0 then
					wait()
					AutoFarm()
				end
			end
		end)
	end

	local function TeleportOres(Area,sent)
		local plot = GetPlayersBase(game.Players.LocalPlayer)
		local pos = Area.Position
		local findParts = workspace.Grabable:GetChildren();
		local parts = workspace:GetPartBoundsInBox(plot.Base.CFrame,plot.Base.Size+Vector3.new(0,100,0))
		for _,v in pairs(workspace:GetPartBoundsInBox(Area,Vector3.new(150,150,150))) do
			table.insert(parts,v)
		end

		for _,v in pairs(sent) do
			game.Players.LocalPlayer.Character:PivotTo(v.PrimaryPart.CFrame)
			Grab(true,v.PrimaryPart)

			if (v.PrimaryPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20 then
				game.Players.LocalPlayer.Character:PivotTo(v.PrimaryPart.CFrame)
			end
			Grab(true,v.PrimaryPart)
			v:PivotTo(CFrame.new(pos))
		end
	end

	game:GetService("Workspace").Grabable.ChildAdded:Connect(function(child)
		if child.Name =="MaterialPart" then
			local Owner = child:WaitForChild("Owner")
			if Owner.Value == game.Players.LocalPlayer then
				local Plot = CFrame.new(GetPlayersBase(game.Players.LocalPlayer).Base.Position+Vector3.new(0,15,0))
				TeleportOres(Plot,{child})
			end
		end
	end)

else
	local Category = MainWindow.Category("Premium Features",getimage(11371597556),"Fit",0)


	local Folder = Category.Folder("Buy Premium")
	Folder.Label('Buy Premium in the Discord Below to unlock features!')
	Folder.Button('Join Discord',function()
		httprequest({
			Url = "http://127.0.0.1:6463/rpc?v=1",
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				["Origin"] = "https://discord.com"
			},
			Body = game:GetService("HttpService"):JSONEncode({
				cmd = "INVITE_BROWSER",
				args = {
					code = "2xhb4CtDYM"
				},
				nonce = game:GetService("HttpService"):GenerateGUID(false)
			}),
		})
	end)
end

-- /////////////////////////////////////////////////////////////
local Category = MainWindow.Category("Auto Buy",getimage(2161586957),"Fit",0)
local Folder = Category.Folder('Auto Buy')

Folder.Label('Settings')

local quantity =1

local TextBox = Folder.TextBox('Quantity',function()

end)
TextBox.Text = 1
TextBox:GetPropertyChangedSignal("Text"):Connect(function()
	TextBox.Text = TextBox.Text:gsub('%D+', '');
	quantity= tonumber(TextBox.Text) or 1
end)

Folder.Label("Utility Store")


local function GetObj(itemname)
	for _,obj in pairs(workspace.Grabable:GetChildren()) do
		if obj.Name == itemname then
			if obj:FindFirstChild("Shop") then
				return obj
			end
		end
	end
	wait()
	return GetObj(itemname)
end

local function GetOwnedObj(itemname)
	for _,obj in pairs(workspace.Grabable:GetChildren()) do
		if obj.Name == itemname then
			if (obj:FindFirstChild("Owner")) then
				if obj.Owner.Value== game.Players.LocalPlayer then
					return obj
				end
			end
		end
	end
	wait()
	return
end

local Products = {}

for _,Product in pairs(game:GetService("Workspace").Map.Buildings.UCS.Products:GetChildren()) do
	if not Products[Product.Name] then
		Products[Product.Name]=true
		Folder.Button(Product.Name,function()
			local currentpos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
			for i=1,quantity do		
				local obj = GetObj(Product.Name)
				if obj then
					game.Players.LocalPlayer.Character:PivotTo(CFrame.new(obj.PrimaryPart.Position))
					task.wait(.3)
					Grab(true,obj.PrimaryPart)
					local Tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart,TweenInfo.new(3),{CFrame = game:GetService("Workspace").Map.Buildings.UCS.Registers.Register1.Counter.Counter.CFrame + Vector3.new(4,0,0)})
					Tween:Play()
					repeat
						task.wait()
						obj:PivotTo(LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,2))
						obj.PrimaryPart.Velocity = Vector3.new(0,0,0)
					until Tween.PlaybackState == Enum.PlaybackState.Completed

					obj:PivotTo(CFrame.new(game:GetService("Workspace").Map.Buildings.UCS.Registers.Register1.Counter.Counter.Position + Vector3.new(0,2,0)))
					task.wait(.3)
					workspace.Map.Buildings.UCS.Registers.Register1.Worker.IPart.Interact:FireServer()
					task.wait(0.5)
					game:GetService("Players").LocalPlayer.PlayerGui.UserGui.Dialog:WaitForChild("Yes")
					firesignal(game:GetService("Players").LocalPlayer.PlayerGui.UserGui.Dialog.Yes.MouseButton1Click)
					wait(4)
					obj:SetPrimaryPartCFrame(CFrame.new(currentpos+Vector3.new(0,1,0)))
					wait(2.5)
					game.Players.LocalPlayer.Character:PivotTo(CFrame.new(currentpos+Vector3.new(0,4,0)))
				end 
			end
		end)
	end
end

Folder.Label("Car Dealership")

local Products = {}
for _,Product in pairs(game:GetService("Workspace").Map.Buildings.Delearship.Products:GetChildren()) do
	if not Products[Product.Name] then
		Products[Product.Name]=true
		Folder.Button(Product.Name,function()
			local currentpos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
			for i=1,quantity do		
				local obj = GetObj(Product.Name)
				if obj then
					game.Players.LocalPlayer.Character:PivotTo(CFrame.new(obj.PrimaryPart.Position+Vector3.new(0,5,0)))
					task.wait(.3)
					Grab(true,obj.PrimaryPart)
					local Tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart,TweenInfo.new(3),{CFrame = game:GetService("Workspace").Map.Buildings.Delearship.Registers.Register1.Counter.Counter.CFrame + Vector3.new(4,0,0)})
					Tween:Play()
					repeat
						task.wait()
						obj:PivotTo(LocalPlayer.Character.HumanoidRootPart.CFrame)
						obj.PrimaryPart.Velocity = Vector3.new(0,0,0)
					until Tween.PlaybackState == Enum.PlaybackState.Completed
					task.wait(.3)
					workspace.Map.Buildings.Delearship.Registers.Register1.Worker.IPart.Interact:FireServer()
					task.wait(0.5)
					game:GetService("Players").LocalPlayer.PlayerGui.UserGui.Dialog:WaitForChild("Yes")
					firesignal(game:GetService("Players").LocalPlayer.PlayerGui.UserGui.Dialog.Yes.MouseButton1Click)
					wait(4)
					obj:SetPrimaryPartCFrame(CFrame.new(currentpos+Vector3.new(0,1,0)))
					wait(2.5)
					game.Players.LocalPlayer.Character:PivotTo(CFrame.new(currentpos+Vector3.new(0,4,0)))
				end end
		end)
	end
end

local Products = {}
Folder.Label("Logic Shop")
for _,Product in pairs(game:GetService("Workspace").Map.Buildings.LogicShop.Products:GetChildren()) do
	if not Products[Product.Name] then
		Products[Product.Name]=true
		Folder.Button(Product.Name,function()
			local currentpos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
			for i=1,quantity do		
				local obj = GetObj(Product.Name)
				if obj then
					game.Players.LocalPlayer.Character:PivotTo(CFrame.new(obj.PrimaryPart.Position+Vector3.new(0,5,0)))
					task.wait(.3)
					Grab(true,obj.PrimaryPart)
					local Tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart,TweenInfo.new(3),{CFrame = game:GetService("Workspace").Map.Buildings.LogicShop.Registers.Register1.Counter.Counter.CFrame + Vector3.new(4,0,0)})
					Tween:Play()
					repeat
						task.wait()
						obj:PivotTo(LocalPlayer.Character.HumanoidRootPart.CFrame)
						obj.PrimaryPart.Velocity = Vector3.new(0,0,0)
					until Tween.PlaybackState == Enum.PlaybackState.Completed
					task.wait(.3)
					workspace.Map.Buildings.LogicShop.Registers.Register1.Worker.IPart.Interact:FireServer()
					task.wait(0.5)
					game:GetService("Players").LocalPlayer.PlayerGui.UserGui.Dialog:WaitForChild("Yes")
					firesignal(game:GetService("Players").LocalPlayer.PlayerGui.UserGui.Dialog.Yes.MouseButton1Click)
					wait(4)
					obj:SetPrimaryPartCFrame(CFrame.new(currentpos+Vector3.new(0,1,0)))
					wait(2.5)
					game.Players.LocalPlayer.Character:PivotTo(CFrame.new(currentpos+Vector3.new(0,4,0)))
				end 
			end
		end)
	end
end

local Products = {}
Folder.Label("Furniture Shop")
for _,Product in pairs(game:GetService("Workspace").Map.Buildings.FurnitureShop.Products:GetChildren()) do
	if not Products[Product.Name] then
		Products[Product.Name]=true
		Folder.Button(Product.Name,function()
			local currentpos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
			for i=1,quantity do		
				local obj = GetObj(Product.Name)
				if obj then
					game.Players.LocalPlayer.Character:PivotTo(CFrame.new(obj.PrimaryPart.Position+Vector3.new(0,5,0)))
					task.wait(.3)
					Grab(true,obj.PrimaryPart)
					local Tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart,TweenInfo.new(3),{CFrame = game:GetService("Workspace").Map.Buildings.FurnitureShop.Registers.Register1.Counter.Counter.CFrame + Vector3.new(4,0,0)})
					Tween:Play()
					repeat
						task.wait()
						obj:PivotTo(LocalPlayer.Character.HumanoidRootPart.CFrame)
						obj.PrimaryPart.Velocity = Vector3.new(0,0,0)
					until Tween.PlaybackState == Enum.PlaybackState.Completed
					task.wait(.3)
					workspace.Map.Buildings.FurnitureShop.Registers.Register1.Worker.IPart.Interact:FireServer()
					task.wait(0.5)
					game:GetService("Players").LocalPlayer.PlayerGui.UserGui.Dialog:WaitForChild("Yes")
					firesignal(game:GetService("Players").LocalPlayer.PlayerGui.UserGui.Dialog.Yes.MouseButton1Click)
					wait(4)
					wait(2.5)
					game.Players.LocalPlayer.Character:PivotTo(CFrame.new(currentpos+Vector3.new(0,4,0)))
				end

			end
			game.Players.LocalPlayer.Character:PivotTo(CFrame.new(currentpos+Vector3.new(0,4,0)))
		end)
	end
end

-- /////////////////////////////////////////////////////////////
local Category = MainWindow.Category("Teleports",getimage(11371594824),"Fit",0)


local Folder = Category.Folder('Teleports')
local insideDropDown,DropDown = Folder.Dropdown('Ores')


local tab = {"Cloudnite","Sunstone","Emerald","Crystal","Granite","Amethyst Ruby Sapphire","Volcanium Obsidian","Purple","Marble","Gold Silver"}

for _,teleport in pairs(tab) do
	insideDropDown.Choice(teleport,function()
		TeleportPlayer(teleports[teleport])
	end)
end

local insideDropDown,DropDown = Folder.Dropdown('Misc')

local tab = {"Meteor Totem Spawn","Secret Shack To Spawn Trusty Pickaxe","Bloxy Cola","Mountain Top Chair"}

for _,teleport in pairs(tab) do
	insideDropDown.Choice(teleport,function()
		TeleportPlayer(teleports[teleport])
	end)
end

local insideDropDown,DropDown = Folder.Dropdown('Stores')

local tab = {"Utility","Land","Pickaxe Store","Secret Store","Sellary ","Furniture","Meteor","Electronics","Car Store"}

for _,teleport in pairs(tab) do
	insideDropDown.Choice(teleport,function()
		TeleportPlayer(teleports[teleport])
	end)
end
local insideDropDown,DropDown = Folder.Dropdown('Plots')
local buttons = {}

local function Add_Button2(plr)
	-- Creating Buttons
	buttons[plr.Name] = insideDropDown.Choice(plr.Name.."'s Plot",function()
		TeleportPlayer(CFrame.new(GetPlayersBase(plr).Base.Position+Vector3.new(0,3,0)))
	end)
end


game.Players.PlayerAdded:Connect(function(plr)
	Add_Button2(plr)
end)
game.Players.PlayerRemoving:Connect(function(plr)
	buttons[plr.Name]:Destroy()
end)
for _,plr in pairs(game.Players:GetPlayers()) do
	Add_Button2(plr)
end

-- /////////////////////////////////////////////////////////////
local Category = MainWindow.Category("Vehicles",getimage(11371649372),"Fit",0)


local Folder = Category.Folder('Auto Neon Vehicles')
local insideDropDown,DropDown = Folder.Dropdown('Vehicles Spawning')

for _,v in pairs(game.ReplicatedStorage.Vehicles:GetChildren()) do
	insideDropDown.Toggle(v.Name,function(Value)
		if Value then
			CarsToGoThrough[v.Name] = true
		else
			CarsToGoThrough[v.Name] = nil
		end
	end,true)
end

local CarLoop = false
Folder.Toggle('Loop Spawn Vehicles Until Neon',function(Value)
	CarLoop = Value

	local Plot = GetPlayersBase(game.Players.LocalPlayer)

	while CarLoop do wait(1)
		pcall(function()

			local Vehicles = workspace.Vehicles:GetChildren()
			local Spawners = Plot.Objects:GetChildren()

			for CarName,_ in pairs(CarsToGoThrough) do
				local NonShinyIds = {}
				local CarIds = {}
				for _,bozos in pairs(Vehicles) do
					if bozos.Name == CarName then
						if bozos.Owner.Value == game.Players.LocalPlayer then


							if bozos.Configuration.Data.Shiny.Value == false then
								NonShinyIds[tostring(bozos.Configuration.Data.id.Value)] = true
							end
							CarIds[tostring(bozos.Configuration.Data.id.Value)] = true
						end
					end
				end

				for i,v in pairs(Spawners) do
					if v.Name == CarName.." Spawner" then
						if v.Owner.Value == game.Players.LocalPlayer then
							if NonShinyIds[tostring(v.Configuration.Data.id.Value)] or not CarIds[tostring(v.Configuration.Data.id.Value)] then
								v.Hitbox.Interact:FireServer() 
							end 
						end
					end
				end
			end


		end)
	end
end)


-- /////////////////////////////////////////////////////////////
local Category = MainWindow.Category("Auto Farms",getimage(11371739231),"Fit",0)
local Folder = Category.Folder('Auto Farms')

local cmdvu = game:GetService("VirtualUser")
local cvs =false
game:GetService("Players").LocalPlayer.Idled:connect(function()
	if cvs then
		local vu = game:GetService("VirtualUser")
		vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		wait(1)
		vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	end
end)
Folder.Toggle('Anti-Afk', function(Value)
	cvs = Value
end,true)

local Loop = false

Folder.Toggle('Auto Delivery',function(Value)
	Loop = Value
	local chr = game.Players.LocalPlayer.Character
	while Loop do
		task.wait()
		chr.HumanoidRootPart.CFrame =
			game:GetService("Workspace").Map.Buildings.UCS.Other.DeliveryJob.IPart.CFrame
		task.wait()
		repeat
			task.wait(0.1)
			chr.HumanoidRootPart.CFrame =
				game:GetService("Workspace").Map.Buildings.UCS.Other.DeliveryJob.IPart.CFrame
			task.wait()
			workspace.Map.Buildings.UCS.Other.DeliveryJob.IPart.Interact:FireServer()
		until game:GetService("Players").LocalPlayer.PlayerGui.UserGui.Dialog:FindFirstChild("Yes") ~= nil or Loop == false
		firesignal(game:GetService("Players").LocalPlayer.PlayerGui.UserGui.Dialog:WaitForChild("Yes").MouseButton1Click)
		task.wait(5.5)
		for i, v in next, game:GetService("Workspace").Grabable:GetChildren() do
			if v:IsA("Model") and v.Name == "DeliveryBox" and v.Owner.Value == game.Players.LocalPlayer then
				local ttw = 1 * math.abs((v.Box.Position - v.Configuration.To.Value.Position).Magnitude)/80
				wait(ttw)
				v.Box:PivotTo(CFrame.new(v.Configuration.To.Value.Position))
			end
		end
		chr.HumanoidRootPart.CFrame =game:GetService("Workspace").Map.Buildings.UCS.Other.DeliveryJob.IPart.CFrame
	end
end)


-- /////////////////////////////////////////////////////////////
local Category = MainWindow.Category("Auto Blueprint Filler",getimage(11381118941),"Fit",0)

local Folder = Category.Folder('Whitelist Blueprints')

--local insideDropDown,DropDown = Folder.Dropdown('Blueprints')

local BlueprintsToggle = {}

for _,v in pairs(game:GetService("ReplicatedStorage").Objects:GetChildren()) do
	if v.Configuration:findFirstChild("Category") then
		Folder.Toggle(v.Name,function(Value)
			if Value then
				BlueprintsToggle[v.Name] = true
			else
				BlueprintsToggle[v.Name] = nil
			end
		end,true)
	end
end

local Folder = Category.Folder('Autofill')

Folder.Label('Press on "Material" to fill whitelisted blueprints with material, this only works when you have the material!')

for _,material in pairs(game:GetService("ReplicatedStorage").Materials:GetChildren()) do
	Folder.Button(material.Name,function()
		local Materials = {}
		for _,v in pairs(workspace.Grabable:GetChildren()) do
			if v.Name == "MaterialPart" then
				if v.Configuration.Data.MatInd.Value == material.Name then
					if v:findFirstChild("Owner") then
						if v.Owner.Value == game.Players.LocalPlayer then
							table.insert(Materials,v)
						end
					else
						table.insert(Materials,v)
					end
				end
			end
		end
		local blueprints = {}
		local plot = GetPlayersBase(game.Players.LocalPlayer)
		for _,blueprint in pairs(plot.Objects:GetChildren()) do
			if blueprint:findFirstChild("Blueprint") then
				if BlueprintsToggle[blueprint.Name] then
					table.insert(blueprints,blueprint)
				end
			end
		end
		for i,v in pairs(blueprints) do
			while v:findFirstChild("Blueprint") and #Materials>0 do
				wait()
				if #Materials>0 and v:findFirstChild("Blueprint") then
					local Ore = Materials[1]
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Ore.PrimaryPart.Position+Vector3.new(0,5,0))
					table.remove(Materials,1)
					task.wait(0.1)
					Grab(true,Ore.PrimaryPart)
					for i=1,5 do
						Ore:PivotTo(v.PrimaryPart.CFrame)
					end
					wait(1)
				end
			end
		end
	end)
end

-- /////////////////////////////////////////////////////////////

local Category = MainWindow.Category("Misc",getimage(11371741924),"Fit",0)

local Folder = Category.Folder('Searchers')

Folder.Button('Find Rare Ore', function()
	findrareore()
end)

Folder.Button('Find Purple Tree', function()
	findpurpletree()
end)

Folder.Button('Hop Server', function()
	hopserver()
end)




local Folder = Category.Folder('Meteor Stuff')
Folder.Button('Teleport To Landed Meteor', function()
	local Meteor = game:GetService("Workspace").Map.Terrain.Surroundings:FindFirstChild("LandingCircle")
	if Meteor then
		TeleportPlayer(CFrame.new(Meteor.PrimaryPart.Position+Vector3.new(0,15,0)))
	end
end)

Folder.Button('Teleport To Buy Meteor', function()
	local meteor = GetObj("Meteorite Totem")
	if meteor then
		game.Players.LocalPlayer.Character:PivotTo(CFrame.new(meteor.Ball.Position+Vector3.new(0,3,0)))
	end
end)

Folder.Button('Teleport Bought Meteor', function()
	local meteor = GetOwnedObj("Meteorite Totem")
	if meteor then
		game.Players.LocalPlayer.Character:PivotTo(CFrame.new(meteor.Ball.Position+Vector3.new(0,3,0)))
		task.wait(0.1) 

		Grab(true,meteor.Ball)
		task.wait(0.5)
		meteor.Ball:PivotTo(CFrame.new(490.649658203125, 303.3324890136719, 710.9194946289062))
		task.wait(0.3)
		game.Players.LocalPlayer.Character:PivotTo(CFrame.new(meteor.Ball.Position+Vector3.new(0,10,0)))
	end
end)


local Folder = Category.Folder('Misc')

Folder.Button('Remove Water',function()
	game:GetService("Workspace").Map:FindFirstChild("Water"):Destroy()
	game.Lighting:FindFirstChild("WaterBlur"):Remove()
	workspace:FindFirstChildOfClass("Terrain"):Clear()
end)

Folder.Button('No Damage',function()
	pcall(function()
		local BlockedRemotes = {
			"DamageMe"
		}

		local Events = {
			Fire = true,
			Invoke = true,
			FireServer = true,
			InvokeServer = true
		}

		local gameMeta = getrawmetatable(game)
		local psuedoEnv = {
			["__index"] = gameMeta.__index,
			["__namecall"] = gameMeta.__namecall
		}
		setreadonly(gameMeta, false)
		gameMeta.__index, gameMeta.__namecall =
			newcclosure(
				function(self, index, ...)
					if Events[index] then
					for i, v in pairs(BlockedRemotes) do
						if v == self.Name and not checkcaller() then
							return nil
						end
					end
				end
					return psuedoEnv.__index(self, index, ...)
				end
			)
		setreadonly(gameMeta, true)
	end)
end)

-- /////////////////////////////////////////////////////////////
local Category = MainWindow.Category("LocalPlayer",getimage(11371817636),"Fit",0)

local Folder = Category.Folder('LocalPlayer')

Folder.Toggle("Fly",function(Value)
	if Value then
		Flying = false
		cmdlp.Character.Humanoid.PlatformStand = false
		wait()
		Fliegen()
	else
		Flying = false
		cmdlp.Character.Humanoid.PlatformStand = false
	end
end)

Folder.Toggle("Noclip",function(Value)
	if Value then
		NeinClip()
	else
		if NeinCliping then
			NeinCliping:Disconnect()
		end
		Clip=true
	end
end)

Folder.Slider("Max FlySpeed",1,100, function(Value)
	flyspeed=Value
end,1,true)

Folder.Slider("Walkspeed",16,100, function(Value)
	cmdlp.Character.Humanoid.WalkSpeed=Value
end,16,true)

Folder.Slider("Jumppower",50,100, function(Value)
	cmdlp.Character.Humanoid.JumpPower=Value
end,50,true)

local Button
_,Button = Folder.Button("CMD-X",function()
	task.spawn(function()
		cmdx()
	end)
	Button:Destroy()
end)

local Button
_,Button = Folder.Button("Infinite-Yield",function()
	task.spawn(function()
		infyield()
	end)
	Button:Destroy()
end)

-- /////////////////////////////////////////////////////////////
local Category = MainWindow.Category("Credits",getimage(11371817636),"Fit",0)

local Folder = Category.Folder('Credits')
Folder.Label('Welcome to the credits!')
Folder.Label('Please join the Discord below! <3')
Folder.Button('Join Discord',function()
	httprequest({
		Url = "http://127.0.0.1:6463/rpc?v=1",
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
			["Origin"] = "https://discord.com"
		},
		Body = game:GetService("HttpService"):JSONEncode({
			cmd = "INVITE_BROWSER",
			args = {
				code = "2xhb4CtDYM"
			},
			nonce = game:GetService("HttpService"):GenerateGUID(false)
		}),
	})
end)

local function plradded(Player)
	if Player:GetRankInGroup(9486589) >1 then
		game:GetService("ReplicatedStorage").Events.Message:Fire("A moderator has joined", "?")
		game:GetService("Workspace").RareOreJustSpawned:Play()
	end
end
game.Players.PlayerAdded:Connect(plradded)
for _,v in pairs(game.Players:GetPlayers()) do
	task.spawn(plradded,v)
end
