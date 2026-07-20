local plr = game.Players.LocalPlayer
local cam = game.Workspace.CurrentCamera
local rep = game:FindFirstChild("ReplicatedStorage") or game:GetService("ReplicatedStorage")
if not rep then
    rep = game:WaitForChild("ReplicatedStorage")
end
local remote = rep:WaitForChild("ByteNetReliable")
local messiFolder = rep.Resources.messi
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local messiVFX = require(rep.client.replication.otherReplication.messiVFX)
local mainreplication = require(rep.client.replication.mainreplication)
local soundUtil = require(rep.util.soundUtil)

local anims = messiFolder.Animations
local sounds = messiFolder.Sounds

if getgenv().DisableWatermark == nil then getgenv().DisableWatermark = false end
if getgenv().LegitMode == nil then getgenv().LegitMode = false end
if getgenv().SkillShoot == nil then getgenv().SkillShoot = false end
if getgenv().DribbleSpeed == nil then getgenv().DribbleSpeed = 1 end
getgenv().DribbleSpeed = math.clamp(getgenv().DribbleSpeed, 0.1, 3)

local stopped = false
local flowOnCD = false
local buffers = {}
local overtimeSoundPlayed = false
local overtimeSound = nil
local timerConnection = nil

local function createMobileUI(skillFuncs)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MobileSkillUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = plr:WaitForChild("PlayerGui")
    
    local function createButton(name, index, func)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 70, 0, 70)
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.BackgroundTransparency = 0.3
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.Text = tostring(index)
        btn.Parent = screenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5)
        corner.Parent = btn
        
        local pos = UDim2.new(0, 10 + (index-1)*80, 0, 10)
        btn.Position = pos
        
        local dragging = false
        local dragStart = nil
        local posStart = nil
        
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                posStart = btn.Position
            end
        end)
        
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        btn.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                btn.Position = posStart + UDim2.new(0, delta.X, 0, delta.Y)
            end
        end)
        
        btn.TouchTap:Connect(func)
        btn.MouseButton1Click:Connect(func)
        
        return btn
    end
    
    createButton("Skill1", 1, skillFuncs[1])
    createButton("Skill2", 2, skillFuncs[2])
    createButton("Skill3", 3, skillFuncs[3])
    createButton("Skill4", 4, skillFuncs[4])
    
    local ultimateBtn = Instance.new("TextButton")
    ultimateBtn.Name = "Ultimate"
    ultimateBtn.Size = UDim2.new(0, 70, 0, 70)
    ultimateBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ultimateBtn.BackgroundTransparency = 0.3
    ultimateBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
    ultimateBtn.TextSize = 12
    ultimateBtn.Text = "G"
    ultimateBtn.Position = UDim2.new(0, 10, 0, 90)
    ultimateBtn.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = ultimateBtn
    
    local dragging = false
    local dragStart = nil
    local posStart = nil
    
    ultimateBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            posStart = ultimateBtn.Position
        end
    end)
    
    ultimateBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    ultimateBtn.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            ultimateBtn.Position = posStart + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)
    
    ultimateBtn.TouchTap:Connect(skillFuncs[5])
    ultimateBtn.MouseButton1Click:Connect(skillFuncs[5])
end

local function setupBarrierDisable(part)
    if not part then return end
    part.CanCollide = false
    part.AncestryChanged:Connect(function()
        if part and part.Parent then
            part.CanCollide = false
        end
    end)
end

local function watchGkBarriar(gkb)
    for _, name in ipairs({"Abarriar", "Bbarriar"}) do
        local p = gkb:FindFirstChild(name)
        if p then setupBarrierDisable(p) end
        gkb.ChildAdded:Connect(function(child)
            if child.Name == name then setupBarrierDisable(child) end
        end)
    end
end

local function watchMap()
    local map = workspace:FindFirstChild("map")
    if map then
        local gkb = map:FindFirstChild("gkbarriar")
        if gkb then watchGkBarriar(gkb) end
        map.ChildAdded:Connect(function(child)
            if child.Name == "gkbarriar" then watchGkBarriar(child) end
        end)
        for _, name in ipairs({"Agoal", "Bgoal"}) do
            local g = map:FindFirstChild(name)
            if g then g.CanCollide = false end
            map.ChildAdded:Connect(function(child)
                if child.Name == name then child.CanCollide = false end
            end)
        end
    end
end

task.spawn(watchMap)
workspace.ChildAdded:Connect(function(child)
    if child.Name == "map" then watchMap() end
end)

loadstring(game:HttpGet("https://pastebin.com/raw/8XJh7dzh"))()
repeat task.wait() until game.Lighting:FindFirstChild("BUFFERSTRINGS")
for _, val in ipairs(game.Lighting:FindFirstChild("BUFFERSTRINGS"):GetChildren()) do
    buffers[val.Name] = val.Value
end
game.Lighting:FindFirstChild("BUFFERSTRINGS"):Destroy()

local function DetectExecutor()
    local hasRequire = pcall(function() return require ~= nil end)
    local hasHook = hookmetamethod ~= nil
    local hasFenv = (getfenv ~= nil and setfenv ~= nil)
    local execName = "Unknown"
    if identifyexecutor then
        local success, name = pcall(identifyexecutor)
        if success and name then execName = name end
    elseif syn and syn.name then execName = syn.name
    elseif getexecutorname then execName = getexecutorname() end
    local isFull = hasRequire and hasHook and hasFenv
    return isFull, execName
end

local isFullExecutor, executorName = DetectExecutor()

if not isFullExecutor then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Not Support Executor",
        Text = string.format("%s detected. Use a better executor.", executorName),
        Duration = 5,
        Button1 = "Ok",
        Icon = "rbxassetid://75337362546331"
    })
else
    game.StarterGui:SetCore("SendNotification", {
        Title = "Full Support",
        Text = string.format("%s detected. Fully supported!", executorName),
        Duration = 3,
        Button1 = "Ok",
        Icon = "rbxassetid://130521044774541"
    })
end

local packets = require(rep:WaitForChild("packets"))
local function ShootSkill()
    packets.bytenet_use.send({"skill2"})
end

ShootSkill()


if not getgenv().MessiNotifyGUI then
    getgenv().MessiNotifyGUI = plr.PlayerGui.Notification:Clone()
    getgenv().MessiNotifyGUI.Name = string.gsub(tostring(math.random()), '0.', ''):sub(1, 1000) .. string.char(math.random(65, 90), math.random(97, 122), math.random(48, 57))
    getgenv().MessiNotifyGUI.Parent = plr:WaitForChild("PlayerGui")
end

task.spawn(function()
    local noti = getgenv().MessiNotifyGUI.Frame.base:Clone()
    noti.Parent = getgenv().MessiNotifyGUI.Frame
    noti.Visible = true
    noti.TextLabel.TextColor3 = Color3.fromRGB(0, 157, 255)
    game.Debris:AddItem(noti, 7.282)
    noti.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    noti.TextLabel.TextStrokeTransparency = 1
    noti.TextLabel.TextTransparency = 1
    noti.TextLabel.Text = "Messi Moveset Loaded!"
    TweenService:Create(noti, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {Size = UDim2.new(1.33, 0, 0.054, 0)}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 0}):Play()
    task.delay(7, function()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()
    end)
end)

task.wait(0.5)
task.spawn(function()
    local noti = getgenv().MessiNotifyGUI.Frame.base:Clone()
    noti.Parent = getgenv().MessiNotifyGUI.Frame
    noti.Visible = true
    noti.TextLabel.TextColor3 = Color3.fromRGB(0, 155, 255)
    game.Debris:AddItem(noti, 7.282)
    noti.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    noti.TextLabel.TextStrokeTransparency = 1
    noti.TextLabel.TextTransparency = 1
    noti.TextLabel.Text = "Made By tze"
    TweenService:Create(noti, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {Size = UDim2.new(1.33, 0, 0.054, 0)}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 0}):Play()
    task.delay(7, function()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()
    end)
end)

task.wait(1)
task.spawn(function()
    local noti = getgenv().MessiNotifyGUI.Frame.base:Clone()
    noti.Parent = getgenv().MessiNotifyGUI.Frame
    noti.Visible = true
    noti.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    game.Debris:AddItem(noti, 5.282)
    noti.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    noti.TextLabel.TextStrokeTransparency = 1
    noti.TextLabel.TextTransparency = 1
    noti.TextLabel.Text = "You can now join a game!"
    TweenService:Create(noti, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {Size = UDim2.new(1.33, 0, 0.054, 0)}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 0}):Play()
    task.delay(5, function()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()
    end)
end)
task.wait(0.2)
task.spawn(function()
    local noti = getgenv().MessiNotifyGUI.Frame.base:Clone()
    noti.Parent = getgenv().MessiNotifyGUI.Frame
    noti.Visible = true
    noti.TextLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    game.Debris:AddItem(noti, 5.282)
    noti.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    noti.TextLabel.TextStrokeTransparency = 1
    noti.TextLabel.TextTransparency = 1
    noti.TextLabel.Text = "DONT FORGET TO USE THE STYLE Shidou if u have shootskill turned on."
    TweenService:Create(noti, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {Size = UDim2.new(1.33, 0, 0.054, 0)}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 0}):Play()
    task.delay(5, function()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()
    end)
end)


local watermarkObj = nil
if not getgenv().DisableWatermark then
if getgenv().MessiWatermarkName == nil or getgenv().MessiWatermarkName == '' then
    getgenv().MessiWatermarkName = string.gsub(tostring(math.random()), '0.', ''):sub(1, 1000) .. string.char(math.random(65, 90), math.random(97, 122), math.random(48, 57))
end
if not game.CoreGui.RobloxGui:FindFirstChild(getgenv().MessiWatermarkName) then

    local discordText = getgenv().MessiNotifyGUI.Frame.base.TextLabel:Clone()
    discordText.Text = ' discord.gg/Zu4PnN9Wxw '
    discordText.Name = getgenv().MessiWatermarkName .. '2'
    discordText.Position = UDim2.new(0.05, 0, 0.142, 0)
    discordText.Size = discordText.Size - UDim2.new(0.1, 0, 0.1, 0)
    discordText.TextStrokeTransparency = 1
    discordText.TextColor3 = Color3.fromRGB(155, 0, 100)
    discordText.TextTransparency = 0.59

    watermarkObj = getgenv().MessiNotifyGUI.Frame.base.TextLabel:Clone()
    watermarkObj.Text = ' Made By tze '
    watermarkObj.Name = getgenv().MessiWatermarkName
    watermarkObj.Position = UDim2.new(0, 0, -0.02, 0)
    watermarkObj.TextStrokeTransparency = 1
    watermarkObj.TextColor3 = Color3.fromRGB(0, 157, 255)
    watermarkObj.TextTransparency = 0.59
    watermarkObj.Parent = plr:WaitForChild("PlayerGui")
    
    discordText.Parent = watermarkObj
end
end

local blockedSounds = {
    "rbxassetid://133946857483198",
    "rbxassetid://110043103592232",
    "rbxassetid://89551484323719",
    "rbxassetid://93479045121219",
    "rbxassetid://81199411973051",
    "rbxassetid://81199411973051",
    "rbxassetid://115699700590432",
    "rbxassetid://134456641764445",
}
SoundService.DescendantAdded:Connect(function(sound)
    if sound:IsA("Sound") then
        for _, id in pairs(blockedSounds) do
            if sound.SoundId == id then
                sound:Stop()
                sound:Destroy()
            end
        end
    end
end)

pcall(function()
    local sv = Instance.new("StringValue")
    sv.Name = "Messi"
    sv.Value = "Messi"
    sv.Parent = plr:WaitForChild("storage"):WaitForChild("styles")
end)

local function HasBall()
    return plr.Character and plr.Character:FindFirstChild("Ball")
end

local function Stunned()
    local char = plr.Character
    if not char then return true end
    local state = char:FindFirstChild("state")
    if not state then return true end
    local stun = state:FindFirstChild("stun")
    if not stun then return true end
    return stun.Value
end

local function CancelMove()
    local char = plr.Character
    if char and not char.state.stun.Value then
        char.state.stun.Value = true
        task.wait(0.04)
        char.state.stun.Value = false
    end
end

local function IsOnCD(name)
    local hotbar = plr.PlayerGui:FindFirstChild("Hotbar")
    if not hotbar then return false end
    local btn = hotbar.Backpack.Hotbar:FindFirstChild(name)
    if btn and btn:FindFirstChild("Cooldown") then return btn.Cooldown.Visible end
    return false
end

local function DoCD(name, duration)
    local hotbar = plr.PlayerGui:FindFirstChild("Hotbar")
    if not hotbar then return end
    local btn = hotbar.Backpack.Hotbar:FindFirstChild(name)
    if btn and btn:FindFirstChild("Cooldown") then
        btn.Cooldown.Visible = true
        btn.Cooldown.Size = UDim2.new(1, 0, -1, 0)
        TweenService:Create(btn.Cooldown, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0, 0)}):Play()
        task.delay(duration, function() btn.Cooldown.Visible = false end)
    end
end

local function PlaySFX(sound, parent)
    if not sound then return end
    pcall(function() soundUtil:play(sound, parent) end)
end

local function BlockBaseAnimations(humanoid, ourAnimId)
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
    local animBlock = humanoid.AnimationPlayed:Connect(function(track)
        if track.Animation.AnimationId ~= ourAnimId then track:Stop(0) end
    end)
    return animBlock
end

local function TeleportShot(char, shootDelay)
    local root = char.HumanoidRootPart
    task.delay(shootDelay, function()
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Ball") then return end
        
        local function executeShot()
            if getgenv().SkillShoot then
                ShootSkill()
            else
                remote:FireServer(buffer.fromstring(buffers["base"]), {
                    {"kick", 100, false, root.CFrame.LookVector * 1e19}
                })
            end
        end

        if getgenv().LegitMode then
            executeShot()
            return
        end

        local originalCFrame = root.CFrame
        local lookVector = root.CFrame.LookVector
        local team = char.state.team.Value
        local oppositeTeam = team == "A" and "B" or "A"
        local goal = workspace.map and workspace.map:FindFirstChild(oppositeTeam .. "goal")
        local filterList = {char, workspace.Effects}
        if goal then table.insert(filterList, goal) end
        local gkBarrier = workspace.map and workspace.map:FindFirstChild("gkbarriar")
        if gkBarrier then
            local barrierPart = gkBarrier:FindFirstChild(oppositeTeam == "A" and "Abarriar" or "Bbarriar")
            if barrierPart then table.insert(filterList, barrierPart) end
        end
        local gkCheck = workspace.map and workspace.map:FindFirstChild(oppositeTeam .. "GoalkeeperCheck")
        if gkCheck then table.insert(filterList, gkCheck) end
        char:PivotTo(CFrame.new((function()
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = filterList
            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
            local rayResult = workspace:Raycast(root.Position, lookVector * 1000, rayParams)
            return rayResult and rayResult.Position - lookVector * 2 or root.Position
        end)()))
        root.CFrame = root.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, -8.823999)
        task.wait(0.2)
        
        executeShot()
        
        task.wait(0.001)
        root.CFrame = originalCFrame
    end)
end

local function Dribble()
    local char = plr.Character
    if not char or Stunned() or not HasBall() or IsOnCD("skill1") then return end
    CancelMove()
    DoCD("skill1", 13)
    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart
    local animBlock = BlockBaseAnimations(humanoid, anims.Dribble.AnimationId)
    humanoid:LoadAnimation(anims.Dribble):Play()
    PlaySFX(sounds.Superstar, root)
    pcall(function() messiVFX.messiDribbleVFX(char, true) end)
    
    
    local speedMultiplier = math.clamp(getgenv().DribbleSpeed or 1, 0.1, 3)
    local isChanging = false
    
    if root then
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * speedMultiplier
    end

    local velocityConnection
    velocityConnection = root.ChildAdded:Connect(function(child)
        if child:IsA("BodyVelocity") or child:IsA("LinearVelocity") then
            if not isChanging then
                isChanging = true
                if child:IsA("BodyVelocity") then
                    child.Velocity = child.Velocity * speedMultiplier
                elseif child:IsA("LinearVelocity") then
                    child.VectorVelocity = child.VectorVelocity * speedMultiplier
                end
                isChanging = false
            end
            
            child:GetPropertyChangedSignal(child:IsA("BodyVelocity") and "Velocity" or "VectorVelocity"):Connect(function()
                if child and child.Parent and not isChanging then
                    isChanging = true
                    if child:IsA("BodyVelocity") then
                        child.Velocity = child.Velocity * speedMultiplier
                    elseif child:IsA("LinearVelocity") then
                        child.VectorVelocity = child.VectorVelocity * speedMultiplier
                    end
                    isChanging = false
                end
            end)
        end
    end)
    
    for _, child in pairs(root:GetChildren()) do
        if (child:IsA("BodyVelocity") or child:IsA("LinearVelocity")) and not isChanging then
            isChanging = true
            if child:IsA("BodyVelocity") then
                child.Velocity = child.Velocity * speedMultiplier
            elseif child:IsA("LinearVelocity") then
                child.VectorVelocity = child.VectorVelocity * speedMultiplier
            end
            isChanging = false
        end
    end

    task.delay(4.25, function() 
        animBlock:Disconnect() 
        if velocityConnection then
            velocityConnection:Disconnect()
        end
    end)
end
local function Riptide()
    local char = plr.Character
    if not char or Stunned() or not HasBall() or IsOnCD("skill2") then return end
    CancelMove()
    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart
    local animBlock = BlockBaseAnimations(humanoid, anims.Riptide.AnimationId)
    PlaySFX(sounds.Riptide, root)
    pcall(function() messiVFX.messiShootVFX(char) end)
    humanoid:LoadAnimation(anims.Riptide):Play()
    TeleportShot(char, 1.1)
    DoCD("skill2", 8)
    task.delay(1.1, function() animBlock:Disconnect() end)
end

local function SuperPass()
    local char = plr.Character
    if not char or Stunned() or not HasBall() or IsOnCD("skill3") then return end
    local root = char.HumanoidRootPart
    local humanoid = char.Humanoid
    local closestTeammate = nil
    local shortestDistance = 180
    for _, p in ipairs(Players:GetPlayers()) do
        if p == plr then continue end
        if not p.Character then continue end
        if p.Team ~= plr.Team then continue end
        if p.Team == game.Teams.lobby then continue end
        local targetRoot = p.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then continue end
        local dist = (root.Position - targetRoot.Position).Magnitude
        if dist < shortestDistance then
            shortestDistance = dist
            closestTeammate = p
        end
    end
    if not closestTeammate then
        CancelMove()
        return
    end
    CancelMove()
    DoCD("skill3", 7)
    local targetRoot = closestTeammate.Character.HumanoidRootPart
    local distance = shortestDistance
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
    humanoid:LoadAnimation(anims.SuperPass):Play()
    pcall(function() messiVFX.messiPassVFX(char) end)
    if sounds:FindFirstChild("Perfect Pass") then
        local s = sounds["Perfect Pass"]:Clone()
        s.Parent = root
        s:Play()
        Debris:AddItem(s, 3)
    end
    task.wait(0.3)
    local direction = (targetRoot.Position - root.Position).Unit
    local kickDir = Vector3.new(direction.X, 0.18, direction.Z).Unit
    local power = math.clamp(distance / 1.4, 18, 95)
    remote:FireServer(
        buffer.fromstring(buffers["base"]),
        { {"kick", power, true, Vector3.new(kickDir.X, kickDir.Y, kickDir.Z)} }
    )
end

local function Intercept()
    local char = plr.Character
    if not char or IsOnCD("skill4") or Stunned() then return end
    local ball = workspace.Terrain:FindFirstChild("Ball")
    if not ball then return end
    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart
    local dist = (root.Position - ball.Position).Magnitude
    if dist > 300 then return end
    CancelMove()
    DoCD("skill4", 4)
    humanoid:LoadAnimation(anims.InterceptStart):Play()
    pcall(function() 
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://89339537870505"
        s.Volume = 1
        s.Parent = root
        s:Play()
        Debris:AddItem(s, 3)
    end)
    pcall(function() messiVFX.messiInterceptStart(char) end)
    humanoid.HipHeight = 10
    task.wait(0.3)
    for _ = 1, 9 do
        remote:FireServer(buffer.fromstring(buffers["grabball"]))
        task.wait(0.05)
        if HasBall() then break end
    end
    TweenService:Create(humanoid, TweenInfo.new(0.4, Enum.EasingStyle.Cubic), {HipHeight = 0}):Play()
    if HasBall() then
        root.Anchored = true
        root.AssemblyLinearVelocity = Vector3.zero
        humanoid.AutoRotate = false
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
        local animBlock = BlockBaseAnimations(humanoid, anims.Intercept.AnimationId)
        humanoid:LoadAnimation(anims.Intercept):Play()
        PlaySFX(sounds.TrapCutscene, root)
        pcall(function() messiVFX.messiInterceptCutscene(char) end)
        task.wait(0.8)
        root.Anchored = false
        root.AssemblyLinearVelocity = Vector3.new(0, -100, 0)
        humanoid.AutoRotate = true
        task.delay(2.5, function() animBlock:Disconnect(); mainreplication.sceneEnabled(false) end)
    else
        char.state.stun.Value = true
        task.delay(1.5, function() char.state.stun.Value = false end)
    end
end

local function HeadsUpShot()
    local char = plr.Character
    if not char or Stunned() or not HasBall() or IsOnCD("skill4") then return end
    CancelMove()
    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart
    local animBlock = BlockBaseAnimations(humanoid, anims.InterceptShot.AnimationId)
    PlaySFX(sounds.TrapShot, root)
    pcall(function() messiVFX.messiShootVFX(char) end)
    humanoid:LoadAnimation(anims.InterceptShot):Play()
    pcall(function() messiVFX.messiInterceptShot(char) end)
    TeleportShot(char, 2.3)
    DoCD("skill4", 15)
    task.delay(2.9, function() animBlock:Disconnect() end)
end

local function Skill4()
    if HasBall() then
        HeadsUpShot()
    else
        Intercept()
    end
end

local function NutmegSteal()
    local char = plr.Character
    if not char or Stunned() or IsOnCD("skill5") then return end
    if HasBall() then return end
    local root = char.HumanoidRootPart
    if not root then return end
    local humanoid = char.Humanoid
    if not humanoid then return end
    local closestEnemyWithBall = nil
    local shortestDistance = 35
    for _, p in ipairs(Players:GetPlayers()) do
        if p == plr then continue end
        if not p.Character then continue end
        if p.Team == plr.Team then continue end
        if p.Team == game.Teams.lobby then continue end
        if not p.Character:FindFirstChild("Ball") then continue end
        local targetRoot = p.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then continue end
        local dist = (root.Position - targetRoot.Position).Magnitude
        if dist < shortestDistance then
            shortestDistance = dist
            closestEnemyWithBall = p
        end
    end
    if not closestEnemyWithBall then
        CancelMove()
        DoCD("skill5", 13)
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
        local animTackle = humanoid:LoadAnimation(anims.NutmegStart)
        if animTackle then animTackle:Play() end
        PlaySFX(sounds.NutmegUse, root)
        local animBlock = humanoid.AnimationPlayed:Connect(function(track)
            if track.Animation.AnimationId == "rbxassetid://109744655458082" then track:Stop(0) end
        end)
        task.wait(0.5)
        remote:FireServer(buffer.fromstring(buffers["base"]), {{"tackle"}})
        task.wait(0.3)
        animBlock:Disconnect()
        if HasBall() then
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
            local animHit = humanoid:LoadAnimation(anims.NutmegHitUser)
            if animHit then animHit:Play() end
            PlaySFX(sounds.NutmegHit, root)
            pcall(function() messiVFX.messiNutmeg(char) end)
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
            bv.Velocity = root.CFrame.LookVector * 150
            bv.Parent = root
            Debris:AddItem(bv, 0.5)
        else
            char.state.stun.Value = true
            task.delay(0.5, function()
                if char and char.state then char.state.stun.Value = false end
            end)
        end
        return
    end
    local targetRoot = closestEnemyWithBall.Character.HumanoidRootPart
    if not targetRoot then return end
    CancelMove()
    DoCD("skill5", 13)
    local behindPos = targetRoot.CFrame * CFrame.new(0, 0, 5)
    root.CFrame = CFrame.new(behindPos.Position, targetRoot.Position)
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
    local animTackle = humanoid:LoadAnimation(anims.NutmegStart)
    if animTackle then animTackle:Play() end
    PlaySFX(sounds.NutmegUse, root)
    local animBlock = humanoid.AnimationPlayed:Connect(function(track)
        if track.Animation.AnimationId == "rbxassetid://109744655458082" then track:Stop(0) end
    end)
    task.wait(0.08)
    remote:FireServer(buffer.fromstring(buffers["base"]), {{"tackle"}})
    task.wait(0.3)
    animBlock:Disconnect()
    if HasBall() then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
        local animHit = humanoid:LoadAnimation(anims.NutmegHitUser)
        if animHit then animHit:Play() end
        PlaySFX(sounds.NutmegHit, root)
        pcall(function() messiVFX.messiNutmeg(char) end)
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
        bv.Velocity = root.CFrame.LookVector * 150
        bv.Parent = root
        Debris:AddItem(bv, 0.5)
    else
        char.state.stun.Value = true
        task.delay(0.5, function()
            if char and char.state then char.state.stun.Value = false end
        end)
    end
end

local function PlayOvertimeSound()
    if overtimeSoundPlayed then return end
    if overtimeSound and overtimeSound.IsPlaying then return end
    overtimeSoundPlayed = true
    overtimeSound = Instance.new("Sound")
    overtimeSound.SoundId = "rbxassetid://83926637345099"
    overtimeSound.Name = "MessiOvertime"
    overtimeSound.Parent = SoundService
    overtimeSound.Volume = 2
    overtimeSound:Play()
    task.delay(120, function()
        if overtimeSound then
            overtimeSound:Stop()
            overtimeSound:Destroy()
            overtimeSound = nil
        end
        overtimeSoundPlayed = false
    end)
end

local function StopOvertimeSound()
    if overtimeSound then
        overtimeSound:Stop()
        overtimeSound:Destroy()
        overtimeSound = nil
    end
    overtimeSoundPlayed = false
end

local function SetupOvertimeDetector()
    local timer = workspace:FindFirstChild("timer") or rep:FindFirstChild("workspace") and rep.workspace:FindFirstChild("timer")
    if not timer then return end
    local lastValue = timer.Value
    if timerConnection then
        timerConnection:Disconnect()
        timerConnection = nil
    end
    timerConnection = timer:GetPropertyChangedSignal("Value"):Connect(function()
        local currentValue = timer.Value
        if lastValue <= 0 and currentValue > 0 then
            PlayOvertimeSound()
        end
        lastValue = currentValue
    end)
    if timer.Value <= 0 then
        PlayOvertimeSound()
    end
end

local function MessiFlow()
    local char = plr.Character
    if not char or Stunned() then return end
    if not HasBall() then return end
    if flowOnCD then return end
    flowOnCD = true
    task.wait(0.5)
    local timer = workspace:FindFirstChild("timer") or (rep:FindFirstChild("workspace") and rep.workspace:FindFirstChild("timer"))
    local isOvertime = timer and (timer.Value <= 0) or false
    local songDuration = 60
    if isOvertime then
        PlayOvertimeSound()
        songDuration = 60
    else
        if sounds.Themes and sounds.Themes:FindFirstChild("Normal") then
            local song = sounds.Themes.Normal
            songDuration = song.TimeLength > 0 and song.TimeLength or 60
            soundUtil:play(song, SoundService)
        end
    end
    pcall(function() messiVFX.messiFlow(char) end)
    if anims:FindFirstChild("Flow") then
        for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end
        char.Humanoid:LoadAnimation(anims.Flow):Play()
    end
    SetupOvertimeDetector()
    task.delay(songDuration + 10, function() flowOnCD = false end)
end

local function Setup(char)
    if stopped then return end
    repeat task.wait() until plr.Team ~= game.Teams.lobby
    task.wait(0.1)
    plr:SetAttribute("style", "messi")
    local hotbar = plr.PlayerGui:WaitForChild("Hotbar")
    local buttons = hotbar.Backpack.Hotbar
    buttons.skill1.Base.MouseButton1Down:Connect(Dribble)
    buttons.skill2.Base.MouseButton1Down:Connect(Riptide)
    buttons.skill3.Base.MouseButton1Down:Connect(SuperPass)
    buttons.skill4.Base.MouseButton1Down:Connect(Skill4)
    buttons.skill5.Base.MouseButton1Down:Connect(NutmegSteal)
    buttons.skill1.Base.MouseButton1Click:Connect(Dribble)
    buttons.skill2.Base.MouseButton1Click:Connect(Riptide)
    buttons.skill3.Base.MouseButton1Click:Connect(SuperPass)
    buttons.skill4.Base.MouseButton1Click:Connect(Skill4)
    buttons.skill5.Base.MouseButton1Click:Connect(NutmegSteal)
    pcall(function() buttons.skill1.Base.TouchTap:Connect(Dribble) end)
    pcall(function() buttons.skill2.Base.TouchTap:Connect(Riptide) end)
    pcall(function() buttons.skill3.Base.TouchTap:Connect(SuperPass) end)
    pcall(function() buttons.skill4.Base.TouchTap:Connect(Skill4) end)
    pcall(function() buttons.skill5.Base.TouchTap:Connect(NutmegSteal) end)
    buttons.skill1.Base.ToolName.Text = "Superstar"
    buttons.skill2.Base.ToolName.Text = "Riptide"
    buttons.skill3.Base.ToolName.Text = "Super Pass"
    buttons.skill4.Base.ToolName.Text = "Heads Up"
    buttons.skill5.Base.ToolName.Text = "Forced Nutmeg"
    buttons.skill1.Base.Reuse.Text = "Ball only"
    buttons.skill2.Base.Reuse.Text = "ball only"
    buttons.skill3.Base.Reuse.Text = "Auto-Pass"
    buttons.skill4.Base.Reuse.Text = ""
    buttons.skill5.Base.Reuse.Text = "Steal"
    for i = 1, 5 do 
        buttons["skill"..i].Base.Reuse.Visible = true
        buttons["skill"..i].Visible = true
    end
    hotbar.MagicHealth.Awakening.Text = "The Goat."
    hotbar.MagicHealth.TextLabel.Text = "Argentina's Best."
    hotbar.MagicHealth.Health.Frame.UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 157, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 157, 255))
    }

    createMobileUI({Dribble, Riptide, SuperPass, Skill4, MessiFlow})

    char:GetAttributeChangedSignal("FlowActive"):Connect(function()
        if char:GetAttribute("FlowActive") == true and not stopped then
            char:SetAttribute("FlowActive", false)
            MessiFlow()
        end
    end)

    pcall(function()
        local mh = hotbar:FindFirstChild("MagicHealth")
        if mh and mh:FindFirstChild("Awakening") then
            mh.Awakening.TouchTap:Connect(MessiFlow)
            mh.Awakening.MouseButton1Click:Connect(MessiFlow)
        end
    end)
end

Setup(plr.Character)
plr.CharacterAdded:Connect(function(char)
    flowOnCD = false
    overtimeSoundPlayed = false
    StopOvertimeSound()
    if timerConnection then
        timerConnection:Disconnect()
        timerConnection = nil
    end
    task.wait(1)
    Setup(char)
end)

local function StopMoveset()
    stopped = true
    if watermarkObj and watermarkObj.Parent then watermarkObj:Destroy() end
    StopOvertimeSound()
    if timerConnection then
        timerConnection:Disconnect()
        timerConnection = nil
    end
    task.spawn(function()
        local noti = getgenv().MessiNotifyGUI.Frame.base:Clone()
        noti.Parent = getgenv().MessiNotifyGUI.Frame
        noti.Visible = true
        noti.TextLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        game.Debris:AddItem(noti, 5.282)
        noti.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        noti.TextLabel.TextStrokeTransparency = 1
        noti.TextLabel.TextTransparency = 1
        noti.TextLabel.Text = "Messi Moveset Stopped!"
        TweenService:Create(noti, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {Size = UDim2.new(1.33, 0, 0.054, 0)}):Play()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 0}):Play()
        task.delay(5, function()
            TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
            TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()
        end)
    end)
end

UserInputService.InputBegan:Connect(function(input, bg)
    if bg or stopped then return end
    if input.KeyCode == Enum.KeyCode.One then Dribble()
    elseif input.KeyCode == Enum.KeyCode.Two then Riptide()
    elseif input.KeyCode == Enum.KeyCode.Three then SuperPass()
    elseif input.KeyCode == Enum.KeyCode.Four then Skill4()
    elseif input.KeyCode == Enum.KeyCode.Five then NutmegSteal()
    elseif input.KeyCode == Enum.KeyCode.G then MessiFlow()
    elseif input.KeyCode == Enum.KeyCode.F4 then StopMoveset()
    elseif input.KeyCode == Enum.KeyCode.F5 then
        if watermarkObj and watermarkObj.Parent then watermarkObj:Destroy() end
    end
end)

print("Messi Moveset loaded!")