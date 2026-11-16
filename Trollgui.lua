local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local selectedTarget = nil
local isBusy = false

-- 1. Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SleekTrollGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- 2. Watermark in Corner
local watermark = Instance.new("TextLabel")
watermark.Name = "Watermark"
watermark.Size = UDim2.new(0, 240, 0, 25)
watermark.Position = UDim2.new(1, -15, 1, -10)
watermark.AnchorPoint = Vector2.new(1, 1)
watermark.BackgroundTransparency = 1
watermark.Text = "Made by AAnerfulightYT | [RightShift]"
watermark.TextColor3 = Color3.fromRGB(160, 160, 160)
watermark.TextStrokeTransparency = 0.5
watermark.Font = Enum.Font.GothamSemibold
watermark.TextSize = 12
watermark.TextXAlignment = Enum.TextXAlignment.Right
watermark.Parent = screenGui

-- 3. Sleek Black Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 460)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(45, 45, 50)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- 4. Header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
header.Text = "TROLL PANEL (RightShift)"
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Font = Enum.Font.GothamBlack
header.TextSize = 14
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- 5. Selected Target Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -24, 0, 24)
statusLabel.Position = UDim2.new(0, 12, 0, 46)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Target: None Selected"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 13
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- 6. Scrolling Player List
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, -24, 0, 125)
playerList.Position = UDim2.new(0, 12, 0, 74)
playerList.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
playerList.BorderSizePixel = 0
playerList.ScrollBarThickness = 4
playerList.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
playerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.Parent = mainFrame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 8)
listCorner.Parent = playerList

local listStroke = Instance.new("UIStroke")
listStroke.Color = Color3.fromRGB(35, 35, 40)
listStroke.Thickness = 1
listStroke.Parent = playerList

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = playerList

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 6)
listPadding.PaddingBottom = UDim.new(0, 6)
listPadding.PaddingLeft = UDim.new(0, 6)
listPadding.PaddingRight = UDim.new(0, 6)
listPadding.Parent = playerList

-- 7. Scrolling Action Buttons Container
local actionList = Instance.new("ScrollingFrame")
actionList.Size = UDim2.new(1, -24, 0, 238)
actionList.Position = UDim2.new(0, 12, 0, 208)
actionList.BackgroundTransparency = 1
actionList.BorderSizePixel = 0
actionList.ScrollBarThickness = 4
actionList.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
actionList.AutomaticCanvasSize = Enum.AutomaticSize.Y
actionList.CanvasSize = UDim2.new(0, 0, 0, 0)
actionList.Parent = mainFrame

local actionLayout = Instance.new("UIListLayout")
actionLayout.Padding = UDim.new(0, 7)
actionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
actionLayout.Parent = actionList

local actionPadding = Instance.new("UIPadding")
actionPadding.PaddingTop = UDim.new(0, 2)
actionPadding.PaddingBottom = UDim.new(0, 6)
actionPadding.PaddingLeft = UDim.new(0, 2)
actionPadding.PaddingRight = UDim.new(0, 6)
actionPadding.Parent = actionList

local function createActionButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(245, 245, 245)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Parent = actionList

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(50, 50, 60)
	stroke.Thickness = 1
	stroke.Parent = btn

	return btn
end

-- Create All 11 Feature Buttons
local flingBtn = createActionButton("1. Fling (5s Spin & Fly)")
local spookBtn = createActionButton("2. Spook (0.5s Flash)")
local orbitBtn = createActionButton("3. Orbit Target (5s)")
local headSitBtn = createActionButton("4. Sit on Head (Toggle)")
local stalkBtn = createActionButton("5. Stalk Behind (Toggle)")
local launchBtn = createActionButton("6. Sky Launch Self")
local glitchBtn = createActionButton("7. Glitch Seizure (4s)")
local tripBtn = createActionButton("8. Fake Trip Ragdoll (Toggle)")
local copycatBtn = createActionButton("9. Copycat Mirror (Toggle)")
local ankleBiterBtn = createActionButton("10. Ankle Biter (Toggle)")
local helicopterBtn = createActionButton("11. Helicopter Above (Toggle)")

-- ==========================================
-- RIGHTSHIFT TOGGLE KEYBIND
-- ==========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

-- ==========================================
-- PLAYER LIST UPDATER
-- ==========================================
local function refreshPlayerList()
	for _, child in ipairs(playerList:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local item = Instance.new("TextButton")
			item.Size = UDim2.new(1, 0, 0, 28)
			item.BackgroundColor3 = (selectedTarget == plr) and Color3.fromRGB(55, 55, 68) or Color3.fromRGB(26, 26, 32)
			item.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
			item.TextColor3 = Color3.fromRGB(240, 240, 240)
			item.Font = Enum.Font.GothamMedium
			item.TextSize = 12
			item.Parent = playerList

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = item

			item.Activated:Connect(function()
				selectedTarget = plr
				statusLabel.Text = "Target: " .. plr.DisplayName
				refreshPlayerList()
			end)
		end
	end
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(function(leavingPlayer)
	if selectedTarget == leavingPlayer then
		selectedTarget = nil
		statusLabel.Text = "Target: None Selected"
	end
	refreshPlayerList()
end)
refreshPlayerList()

-- Helper to get character roots safely
local function getRoots()
	if not selectedTarget or not selectedTarget.Character then
		statusLabel.Text = "Target: Select a player first!"
		return nil, nil, nil
	end
	local myChar = player.Character
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
	local targetRoot = selectedTarget.Character:FindFirstChild("HumanoidRootPart")
	if not (myRoot and myHum and targetRoot) then return nil, nil, nil end
	return myRoot, myHum, targetRoot
end

-- ==========================================
-- 1. FLING (5 SECONDS FLY + SPIN)
-- ==========================================
flingBtn.Activated:Connect(function()
	if isBusy then return end
	local myRoot, myHum, targetRoot = getRoots()
	if not myRoot then return end

	isBusy = true
	flingBtn.Text = "Flinging..."
	flingBtn.BackgroundColor3 = Color3.fromRGB(160, 35, 35)

	local savedCFrame = myRoot.CFrame

	local attachment = Instance.new("Attachment", myRoot)
	local alignPos = Instance.new("AlignPosition")
	alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
	alignPos.Attachment0 = attachment
	alignPos.MaxForce = math.huge
	alignPos.MaxVelocity = math.huge
	alignPos.Responsiveness = 200
	alignPos.Position = targetRoot.Position
	alignPos.Parent = myRoot

	local angularVel = Instance.new("BodyAngularVelocity")
	angularVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	angularVel.AngularVelocity = Vector3.new(0, 99999, 0)
	angularVel.P = math.huge
	angularVel.Parent = myRoot

	myHum.PlatformStand = true

	local startTime = tick()
	local conn
	conn = RunService.Heartbeat:Connect(function()
		local currentTargetRoot = selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart")
		if tick() - startTime >= 5 or not currentTargetRoot or not myRoot.Parent then
			conn:Disconnect()
			angularVel:Destroy()
			alignPos:Destroy()
			attachment:Destroy()

			if myRoot.Parent then
				myRoot.AssemblyLinearVelocity = Vector3.zero
				myRoot.AssemblyAngularVelocity = Vector3.zero
				myRoot.CFrame = savedCFrame
			end
			if myHum then myHum.PlatformStand = false end

			flingBtn.Text = "1. Fling (5s Spin & Fly)"
			flingBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
			isBusy = false
			return
		end

alignPos.Position = currentTargetRoot.Position
myRoot.CFrame = CFrame.new(currentTargetRoot.Position) * (myRoot.CFrame - myRoot.CFrame.Position)
end)
end)
-- ==========================================
-- 2. SPOOK (0.5s FLASH IN FRONT)
-- ==========================================
spookBtn.Activated:Connect(function()
if isBusy then return end
local myRoot, _, targetRoot = getRoots()
if not myRoot then return end
isBusy = true
spookBtn.Text = "Spooking!"
spookBtn.BackgroundColor3 = Color3.fromRGB(160, 35, 35)
local savedCFrame = myRoot.CFrame
myRoot.AssemblyLinearVelocity = Vector3.zero
myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -3.5) * CFrame.Angles(0, math.pi, 0)
task.wait(0.5)
if myRoot and myRoot.Parent then
myRoot.AssemblyLinearVelocity = Vector3.zero
myRoot.CFrame = savedCFrame
end
spookBtn.Text = "2. Spook (0.5s Flash)"
spookBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
isBusy = false
end)
-- ==========================================
-- 3. ORBIT TARGET (5 SECONDS)
-- ==========================================
orbitBtn.Activated:Connect(function()
if isBusy then return end
local myRoot, _, targetRoot = getRoots()
if not myRoot then return end
isBusy = true
orbitBtn.Text = "Orbiting..."
orbitBtn.BackgroundColor3 = Color3.fromRGB(160, 35, 35)
local savedCFrame = myRoot.CFrame
local startTime = tick()
local angle = 0
local conn
conn = RunService.Heartbeat:Connect(function(dt)
local currentTargetRoot = selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart")
if tick() - startTime >= 5 or not currentTargetRoot or not myRoot.Parent then
conn:Disconnect()
if myRoot.Parent then
myRoot.AssemblyLinearVelocity = Vector3.zero
myRoot.CFrame = savedCFrame
end
orbitBtn.Text = "3. Orbit Target (5s)"
orbitBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
isBusy = false
return
end
angle = angle + (dt * 12)
local offset = Vector3.new(math.cos(angle) * 5, 1, math.sin(angle) * 5)
local orbitPos = currentTargetRoot.Position + offset
myRoot.AssemblyLinearVelocity = Vector3.zero
myRoot.CFrame = CFrame.lookAt(orbitPos, currentTargetRoot.Position)
end)
end)
-- ==========================================
-- 4. SIT ON HEAD (TOGGLE)
-- ==========================================
local headSitting = false
local headConn = nil
headSitBtn.Activated:Connect(function()
if headSitting then
headSitting = false
if headConn then headConn:Disconnect() end
local myHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
if myHum then myHum.Sit = false end
headSitBtn.Text = "4. Sit on Head (Toggle)"
headSitBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
return
end
local myRoot = getRoots()
if not myRoot then return end
headSitting = true
headSitBtn.Text = "4. Sit on Head [ON]"
headSitBtn.BackgroundColor3 = Color3.fromRGB(160, 35, 35)
headConn = RunService.Heartbeat:Connect(function()
local targetHead = selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("Head")
local curRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local curHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
if not headSitting or not targetHead or not curRoot or not curHum then
headSitting = false
if headConn then headConn:Disconnect() end
headSitBtn.Text = "4. Sit on Head (Toggle)"
headSitBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
return
end
curHum.Sit = true
curRoot.AssemblyLinearVelocity = Vector3.zero
curRoot.CFrame = targetHead.CFrame * CFrame.new(0, 1.8, 0)
end)
end)
-- ==========================================
-- 5. STALK BEHIND (TOGGLE)
-- ==========================================
local stalking = false
local stalkConn = nil
stalkBtn.Activated:Connect(function()
if stalking then
stalking = false
if stalkConn then stalkConn:Disconnect() end
stalkBtn.Text = "5. Stalk Behind (Toggle)"
stalkBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
return
end
local myRoot = getRoots()
if not myRoot then return end
stalking = true
stalkBtn.Text = "5. Stalk Behind [ON]"
stalkBtn.BackgroundColor3 = Color3.fromRGB(160, 35, 35)
stalkConn = RunService.Heartbeat:Connect(function()
local currentTargetRoot = selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart")
local curRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if not stalking or not currentTargetRoot or not curRoot then
stalking = false
if stalkConn then stalkConn:Disconnect() end
stalkBtn.Text = "5. Stalk Behind (Toggle)"
stalkBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
return
end
curRoot.AssemblyLinearVelocity = Vector3.zero
curRoot.CFrame = currentTargetRoot.CFrame * CFrame.new(0, 0, 3.2)
end)
end)
-- ==========================================
-- 6. SKY LAUNCH SELF
-- ==========================================
launchBtn.Activated:Connect(function()
local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if not myRoot then return end
myRoot.AssemblyLinearVelocity = Vector3.new(0, 350, 0)
launchBtn.Text = "Launched!"
task.wait(0.8)
launchBtn.Text = "6. Sky Launch Self"
end)
-- ==========================================
-- 7. GLITCH SEIZURE AROUND TARGET (4 SECONDS)
-- ==========================================
glitchBtn.Activated:Connect(function()
if isBusy then return end
local myRoot, _, targetRoot = getRoots()
if not myRoot then return end
isBusy = true
glitchBtn.Text = "Glitching..."
glitchBtn.BackgroundColor3 = Color3.fromRGB(160, 35, 35)
local savedCFrame = myRoot.CFrame
local startTime = tick()
local conn
conn = RunService.Heartbeat:Connect(function()
local currentTargetRoot = selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart")
if tick() - startTime >= 4 or not currentTargetRoot or not myRoot.Parent then
conn:Disconnect()
if myRoot.Parent then
myRoot.AssemblyLinearVelocity = Vector3.zero
myRoot.CFrame = savedCFrame
end
glitchBtn.Text = "7. Glitch Seizure (4s)"
glitchBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
isBusy = false
return
end
local rx = math.random(-6, 6)
local ry = math.random(-1, 5)
local rz = math.random(-6, 6)
local rot = CFrame.Angles(math.random(0, 6), math.random(0, 6), math.random(0, 6))
myRoot.AssemblyLinearVelocity = Vector3.zero
myRoot.CFrame = CFrame.new(currentTargetRoot.Position + Vector3.new(rx, ry, rz)) * rot
end)
end)
-- ==========================================
-- 8. FAKE TRIP / PLAY DEAD (TOGGLE)
-- ==========================================
local tripped = false
tripBtn.Activated:Connect(function()
local myChar = player.Character
local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
if not (myRoot and myHum) then return end
tripped = not tripped
if tripped then
tripBtn.Text = "8. Fake Trip Ragdoll [ON]"
tripBtn.BackgroundColor3 = Color3.fromRGB(160, 35, 35)
myHum.PlatformStand = true
myRoot.CFrame = myRoot.CFrame * CFrame.Angles(math.rad(90), 0, 0)
else
tripBtn.Text = "8. Fake Trip Ragdoll (Toggle)"
tripBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
myHum.PlatformStand = false
end
end)
-- ==========================================
-- 9. COPYCAT MIRROR (TOGGLE)
-- ==========================================
local copying = false
local copyConn = nil
copycatBtn.Activated:Connect(function()
if copying then
copying = false
if copyConn then copyConn:Disconnect() end
copycatBtn.Text = "9. Copycat Mirror (Toggle)"
copycatBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
return
end
local myRoot = getRoots()
if not myRoot then return end
copying = true
copycatBtn.Text = "9. Copycat Mirror [ON]"
copycatBtn.BackgroundColor3 = Color3.fromRGB(160, 35, 35)
copyConn = RunService.Heartbeat:Connect(function()
local currentTargetRoot = selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart")
local targetHum = selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChildOfClass("Humanoid")
local curRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local curHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
if not copying or not currentTargetRoot or not curRoot then
copying = false
if copyConn then copyConn:Disconnect() end
copycatBtn.Text = "9. Copycat Mirror (Toggle)"
copycatBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
return
end
curRoot.AssemblyLinearVelocity = Vector3.zero
curRoot.CFrame = currentTargetRoot.CFrame * CFrame.new(4, 0, 0)
if targetHum and curHum and targetHum.Jump then
curHum.Jump = true
end
end)
end)
-- ==========================================
-- 10. ANKLE BITER (TOGGLE)
-- ==========================================
local ankleBiting = false
local ankleConn = nil
ankleBiterBtn.Activated:Connect(function()
if ankleBiting then
ankleBiting = false
if ankleConn then ankleConn:Disconnect() end
local myHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
if myHum then myHum.PlatformStand = false end
ankleBiterBtn.Text = "10. Ankle Biter (Toggle)"
ankleBiterBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
return
end
local myRoot = getRoots()
if not myRoot then return end
ankleBiting = true
ankleBiterBtn.Text = "10. Ankle Biter [ON]"
ankleBiterBtn.BackgroundColor3 = Color3.fromRGB(160, 35, 35)
ankleConn = RunService.Heartbeat:Connect(function()
local currentTargetRoot = selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart")
local curRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local curHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
if not ankleBiting or not currentTargetRoot or not curRoot or not curHum then
ankleBiting = false
if ankleConn then ankleConn:Disconnect() end
ankleBiterBtn.Text = "10. Ankle Biter (Toggle)"
ankleBiterBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
return
end
curHum.PlatformStand = true
curRoot.AssemblyLinearVelocity = Vector3.zero
curRoot.CFrame = currentTargetRoot.CFrame * CFrame.new(0, -2.5, -1.2) * CFrame.Angles(math.rad(-90), 0, 0)
end)
end)
-- ==========================================
-- 11. HELICOPTER ABOVE HEAD (TOGGLE)
-- ==========================================
local helicoptering = false
local heliConn = nil
local heliSpin = 0
helicopterBtn.Activated:Connect(function()
if helicoptering then
helicoptering = false
if heliConn then heliConn:Disconnect() end
local myHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
if myHum then myHum.PlatformStand = false end
helicopterBtn.Text = "11. Helicopter Above (Toggle)"
helicopterBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
return
end
local myRoot = getRoots()
if not myRoot then return end
helicoptering = true
helicopterBtn.Text = "11. Helicopter Above [ON]"
helicopterBtn.BackgroundColor3 = Color3.fromRGB(160, 35, 35)
heliConn = RunService.Heartbeat:Connect(function(dt)
local targetHead = selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("Head")
local curRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local curHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
if not helicoptering or not targetHead or not curRoot or not curHum then
helicoptering = false
if heliConn then heliConn:Disconnect() end
helicopterBtn.Text = "11. Helicopter Above (Toggle)"
helicopterBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
return
end
heliSpin = heliSpin + (dt * 25)
curHum.PlatformStand = true
curRoot.AssemblyLinearVelocity = Vector3.zero
curRoot.CFrame = CFrame.new(targetHead.Position + Vector3.new(0, 4.5, 0)) * CFrame.Angles(math.rad(90), heliSpin, 0)
end)
end)
