local plr = game.Players.LocalPlayer
local cam = game.Workspace.CurrentCamera
local rep = game:GetService("ReplicatedStorage")
local remote = rep:WaitForChild("ByteNetReliable")
local izaFolder = rep.Resources.izayoi
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local mainreplication = require(rep.client.replication.mainreplication)
local soundUtil = require(rep.util.soundUtil)
local izayoiVFX = require(rep.client.replication.otherReplication.izayoiVFX)

local anims = izaFolder:FindFirstChild("Animations") or izaFolder
local sounds = izaFolder:FindFirstChild("Sounds") or izaFolder

if getgenv().DisableWatermark == nil then getgenv().DisableWatermark = false end
if getgenv().LegitMode == nil then getgenv().LegitMode = false end
if getgenv().SkillShoot == nil then getgenv().SkillShoot = false end

local stopped = false
local flowOnCD = false
local buffers = {}

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

local packets = require(ReplicatedStorage:WaitForChild("packets"))
local function ShootSkill()
    packets.bytenet_use.send({"skill1"})
end

ShootSkill()


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

if not getgenv().MessiNotifyGUI then
    getgenv().MessiNotifyGUI = plr.PlayerGui.Notification:Clone()
    getgenv().MessiNotifyGUI.Name = string.gsub(tostring(math.random()), '0.', ''):sub(1, 1000) .. string.char(math.random(65, 90), math.random(97, 122), math.random(48, 57))
    getgenv().MessiNotifyGUI.Parent = game.CoreGui
end

task.spawn(function()
    local noti = getgenv().MessiNotifyGUI.Frame.base:Clone()
    noti.Parent = getgenv().MessiNotifyGUI.Frame
    noti.Visible = true
    noti.TextLabel.TextColor3 = Color3.fromRGB(200, 180, 0)
    game.Debris:AddItem(noti, 7.282)
    noti.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    noti.TextLabel.TextStrokeTransparency = 1
    noti.TextLabel.TextTransparency = 1
    noti.TextLabel.Text = "Izayoi Moveset Loaded!"
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
    noti.TextLabel.TextColor3 = Color3.fromRGB(200, 180, 0)
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
wait(0.2)
task.spawn(function()
    local noti = getgenv().MessiNotifyGUI.Frame.base:Clone()
    noti.Parent = getgenv().MessiNotifyGUI.Frame
    noti.Visible = true
    noti.TextLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    game.Debris:AddItem(noti, 5.282)
    noti.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    noti.TextLabel.TextStrokeTransparency = 1
    noti.TextLabel.TextTransparency = 1
    noti.TextLabel.Text = "DONT FORGET TO USE THE STYLE Isagi"
    TweenService:Create(noti, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {Size = UDim2.new(1.33, 0, 0.054, 0)}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
    TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 0}):Play()
    task.delay(5, function()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
        TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()
    end)
end)


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

local watermarkObj = nil
if not getgenv().DisableWatermark then
if getgenv().MessiWatermarkName == nil or getgenv().MessiWatermarkName == '' then
    getgenv().MessiWatermarkName = string.gsub(tostring(math.random()), '0.', ''):sub(1, 1000) .. string.char(math.random(65, 90), math.random(97, 122), math.random(48, 57))
end
if not game.CoreGui.RobloxGui:FindFirstChild(getgenv().MessiWatermarkName) then
    setclipboard('https://discord.gg/Zu4PnN9Wxw')

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
    watermarkObj.TextColor3 = Color3.fromRGB(200, 180, 0)
    watermarkObj.TextTransparency = 0.59
    watermarkObj.Parent = game.CoreGui.RobloxGui
    
    discordText.Parent = watermarkObj
end
end

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
    if char and char.state and not char.state.stun.Value then
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
        task.delay(duration, function() 
            if btn and btn.Cooldown then
                btn.Cooldown.Visible = false 
            end
        end)
    end
end

local function PlaySFX(sound, parent)
    if not sound then return end
    pcall(function() soundUtil:play(sound, parent) end)
end

local function Stun(time, disableRotate)
    local char = plr.Character
    if not char then return end
    if char.state then
        char.state.stun.Value = true
    end
    if disableRotate then char:SetAttribute("disableRotate", true) end
    local cfg = Instance.new("Configuration")
    cfg:SetAttribute("speed", 0)
    cfg:SetAttribute("jump", 0)
    local movements = char:FindFirstChild("movements")
    if movements then
        cfg.Parent = movements
    end
    task.delay(time, function()
        pcall(function()
            if char and char.state then
                char.state.stun.Value = false
            end
            if disableRotate then 
                pcall(function() char:SetAttribute("disableRotate", false) end)
            end
        end)
    end)
    Debris:AddItem(cfg, time)
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

local killingDollAnim = Instance.new("Animation")
killingDollAnim.AnimationId = "rbxassetid://103525064961760"

local function StepBehind()
    local char = plr.Character
    if not char or Stunned() or not HasBall() or IsOnCD("skill1") then return end

    CancelMove()
    DoCD("skill1", 0.7)

    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart
    
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end

    task.delay(0.1, function()
        pcall(function()
            require(rep.client.replication).izayoistepbehind(char)
        end)
    end)

    local setpsound = Instance.new("Sound")
    setpsound.SoundId = "rbxassetid://120061457092432"
    setpsound.Volume = 5
    setpsound.Parent = root
    task.spawn(function()
        setpsound:Play()
    end)
    Debris:AddItem(setpsound, 10)
    
    if anims:FindFirstChild("skill1") then
        humanoid:LoadAnimation(anims.skill1):Play()
    end

    Stun(0.9, false)
end

local function PowerfulStriker()
    local char = plr.Character
    if not char or Stunned() or not HasBall() or IsOnCD("skill2") then return end

    CancelMove()
    DoCD("skill2", 8)

    local root = char.HumanoidRootPart
    local humanoid = char.Humanoid

    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end

    local animBlock = humanoid.AnimationPlayed:Connect(function(track)
        if track.Animation.AnimationId ~= killingDollAnim.AnimationId then
            track:Stop(0)
        end
    end)

    local animTrack = humanoid:LoadAnimation(killingDollAnim)
    animTrack.Priority = Enum.AnimationPriority.Action
    animTrack:Play()

    pcall(function()
        if izayoiVFX and izayoiVFX.killingDollShot then
            izayoiVFX.killingDollShot(char)
        end
    end)

    local killingSound = Instance.new("Sound")
    killingSound.SoundId = "rbxassetid://100940978483777"
    killingSound.Volume = 3
    killingSound.Parent = root
    killingSound:Play()
    Debris:AddItem(killingSound, 6)

    TeleportShot(char, 1.1)

    task.delay(1.7, function()
        animTrack:Stop()
        animBlock:Disconnect()
    end)

    Stun(1.5, false)
end

local function TimeStop()
    local char = plr.Character
    if not char or Stunned() or not HasBall() or IsOnCD("skill3") then return end

    CancelMove()
    DoCD("skill3", 6.76)
    Stun(3.48, true)

    local humanoid = char.Humanoid
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end

    task.delay(0.37, function()
        TweenService:Create(humanoid, TweenInfo.new(0.28, Enum.EasingStyle.Cubic), {HipHeight = 30}):Play()
    end)

    pcall(function()
        require(rep.client.replication).TimeStop(char)
    end)

    if anims:FindFirstChild("TimeStopAnim") then
        humanoid:LoadAnimation(anims.TimeStopAnim):Play()
    end

    task.delay(3.48, function()
        humanoid.HipHeight = 0
    end)
end

local afterimageAnim = Instance.new("Animation")
afterimageAnim.AnimationId = "rbxassetid://106523204807221"

local function Afterimage()
    local char = plr.Character
    if not char or Stunned() or IsOnCD("skill4") then return end

    CancelMove()
    DoCD("skill4", 8)

    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart

    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end

    local animBlock = humanoid.AnimationPlayed:Connect(function(track)
        if track.Animation.AnimationId ~= afterimageAnim.AnimationId then
            track:Stop(0)
        end
    end)

    local animTrack = humanoid:LoadAnimation(afterimageAnim)
    animTrack.Priority = Enum.AnimationPriority.Action
    animTrack:Play()

    task.spawn(function()
        local afterimageSound = Instance.new("Sound")
        afterimageSound.SoundId = "rbxassetid://90202563345773"
        afterimageSound.Volume = 3
        afterimageSound.Parent = root
        afterimageSound:Play()
        Debris:AddItem(afterimageSound, 6)
    end)

    pcall(function()
        if izayoiVFX and izayoiVFX.izayoiAfterimageWalk then
            izayoiVFX.izayoiAfterimageWalk(char)
        end
    end)

    task.spawn(function()
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(400000, 0, 400000)
        bv.Velocity = root.CFrame.LookVector * 150
        bv.Parent = root
        Debris:AddItem(bv, 2)
        task.delay(1.5, function()
            if bv and bv.Parent then
                bv.Velocity = root.CFrame.LookVector * 50
            end
        end)
    end)

    task.spawn(function()
        local screen = Instance.new("ScreenGui", plr.PlayerGui)
        screen.IgnoreGuiInset = true
        local flash = Instance.new("Frame", screen)
        flash.Size = UDim2.fromScale(1, 1)
        flash.BackgroundColor3 = Color3.fromRGB(200, 180, 255)
        flash.BackgroundTransparency = 1
        TweenService:Create(flash, TweenInfo.new(0.05), {BackgroundTransparency = 0}):Play()
        task.delay(0.1, function()
            TweenService:Create(flash, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        end)
        Debris:AddItem(screen, 0.5)
    end)

    task.spawn(function()
        pcall(function()
            mainreplication.springcamerashake(0.5, 30)
            mainreplication.fov(false, 85)
            task.delay(0.5, function()
                mainreplication.fov(true, 70, 0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            end)
        end)
    end)

    if char and char.state then
        char.state.stun.Value = true
        task.delay(0.8, function()
            if char and char.state then
                char.state.stun.Value = false
            end
        end)
    end

    task.delay(3.9, function()
        pcall(function()
            animTrack:Stop()
            animBlock:Disconnect()
            if char and char.state then
                char.state.stun.Value = false
            end
        end)
    end)
end

local function IzayoiFlow()
    local char = plr.Character
    if not char or Stunned() or flowOnCD then return end
    
    flowOnCD = true

    local humanoid = char.Humanoid

    task.spawn(function()
        if sounds:FindFirstChild("sakuya theme") then
            local sakuyaTheme = sounds["sakuya theme"]:Clone()
            sakuyaTheme.Parent = char.HumanoidRootPart
            sakuyaTheme:Play()
            Debris:AddItem(sakuyaTheme, 60)

            pcall(function()
                require(rep.client.replication).awkScreen(
                    sakuyaTheme,
                    Color3.fromRGB(255, 238, 0)
                )
            end)
        end
    end)

    Stun(10.65, true)
    TweenService:Create(humanoid, TweenInfo.new(0.3, Enum.EasingStyle.Cubic), {HipHeight = 15}):Play()

    pcall(function()
        require(rep.util.animationUtil):loadAnimation(char, anims.ultawk):Play()
    end)

    pcall(function()
        require(rep.client.replication).izayoiAwk(char)
    end)

    task.delay(10.65, function()
        TweenService:Create(humanoid, TweenInfo.new(0.3, Enum.EasingStyle.Cubic), {HipHeight = 0}):Play()
        task.delay(30, function()
            flowOnCD = false
        end)
    end)
end

local function Setup(char)
    if stopped then return end
    if not char then return end
    
    repeat task.wait() until plr.Team ~= game.Teams.lobby
    task.wait(0.1)
    
    plr:SetAttribute("style", "izayoi")

    local hotbar = plr.PlayerGui:WaitForChild("Hotbar")
    local buttons = hotbar.Backpack.Hotbar

    if buttons.skill1 and buttons.skill1.Base then
        buttons.skill1.Base.MouseButton1Down:Connect(StepBehind)
        buttons.skill1.Base.MouseButton1Click:Connect(StepBehind)
        buttons.skill1.Base.ToolName.Text = "Step Behind"
        buttons.skill1.Base.Reuse.Text = "Ball Only"
        buttons.skill1.Base.Reuse.Visible = true
        buttons.skill1.Visible = true
    end

    if buttons.skill2 and buttons.skill2.Base then
        buttons.skill2.Base.MouseButton1Down:Connect(PowerfulStriker)
        buttons.skill2.Base.MouseButton1Click:Connect(PowerfulStriker)
        buttons.skill2.Base.ToolName.Text = "Killing Doll"
        buttons.skill2.Base.Reuse.Text = "Shot"
        buttons.skill2.Base.Reuse.Visible = true
        buttons.skill2.Visible = true
    end

    if buttons.skill3 and buttons.skill3.Base then
        buttons.skill3.Base.MouseButton1Down:Connect(TimeStop)
        buttons.skill3.Base.MouseButton1Click:Connect(TimeStop)
        buttons.skill3.Base.ToolName.Text = "Time Stop"
        buttons.skill3.Base.Reuse.Text = "Ball Only"
        buttons.skill3.Base.Reuse.Visible = true
        buttons.skill3.Visible = true
    end

    if buttons.skill4 and buttons.skill4.Base then
        buttons.skill4.Base.MouseButton1Down:Connect(Afterimage)
        buttons.skill4.Base.MouseButton1Click:Connect(Afterimage)
        buttons.skill4.Base.ToolName.Text = "Afterimage"
        buttons.skill4.Base.Reuse.Text = "Dash"
        buttons.skill4.Base.Reuse.Visible = true
        buttons.skill4.Visible = true
    end

    if buttons.skill5 then
        buttons.skill5.Visible = false
    end

    pcall(function()
        if buttons.skill1 and buttons.skill1.Base then
            buttons.skill1.Base.TouchTap:Connect(StepBehind)
        end
        if buttons.skill2 and buttons.skill2.Base then
            buttons.skill2.Base.TouchTap:Connect(PowerfulStriker)
        end
        if buttons.skill3 and buttons.skill3.Base then
            buttons.skill3.Base.TouchTap:Connect(TimeStop)
        end
        if buttons.skill4 and buttons.skill4.Base then
            buttons.skill4.Base.TouchTap:Connect(Afterimage)
        end
    end)

    if hotbar:FindFirstChild("MagicHealth") then
        local mh = hotbar.MagicHealth
        if mh:FindFirstChild("Awakening") then
            mh.Awakening.Text = "Time Manipulation"
        end
        if mh:FindFirstChild("TextLabel") then
            mh.TextLabel.Text = "The Maid of Time"
            mh.TextLabel.Visible = true
        end
        if mh:FindFirstChild("Health") and mh.Health:FindFirstChild("Frame") and mh.Health.Frame:FindFirstChild("UIGradient") then
            mh.Health.Frame.UIGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 238, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 157, 0))
            }
        end
    end

    createMobileUI({StepBehind, PowerfulStriker, TimeStop, Afterimage, IzayoiFlow})

    char:GetAttributeChangedSignal("FlowActive"):Connect(function()
        if char:GetAttribute("FlowActive") == true and not stopped then
            char:SetAttribute("FlowActive", false)
            IzayoiFlow()
        end
    end)

    pcall(function()
        local mh = hotbar:FindFirstChild("MagicHealth")
        if mh and mh:FindFirstChild("Awakening") then
            mh.Awakening.TouchTap:Connect(IzayoiFlow)
            mh.Awakening.MouseButton1Click:Connect(IzayoiFlow)
        end
    end)
end

Setup(plr.Character)

plr.CharacterAdded:Connect(function(char)
    flowOnCD = false
    task.wait(1)
    Setup(char)
end)

local function StopMoveset()
    stopped = true
    if watermarkObj and watermarkObj.Parent then watermarkObj:Destroy() end
    
    task.spawn(function()
        local noti = getgenv().MessiNotifyGUI.Frame.base:Clone()
        noti.Parent = getgenv().MessiNotifyGUI.Frame
        noti.Visible = true
        noti.TextLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        game.Debris:AddItem(noti, 5.282)
        noti.TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        noti.TextLabel.TextStrokeTransparency = 1
        noti.TextLabel.TextTransparency = 1
        noti.TextLabel.Text = "Izayoi Moveset Stopped!"
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
    
    if input.KeyCode == Enum.KeyCode.One then 
        StepBehind()
    elseif input.KeyCode == Enum.KeyCode.Two then 
        PowerfulStriker()
    elseif input.KeyCode == Enum.KeyCode.Three then 
        TimeStop()
    elseif input.KeyCode == Enum.KeyCode.Four then 
        Afterimage()
    elseif input.KeyCode == Enum.KeyCode.G then 
        IzayoiFlow()
    elseif input.KeyCode == Enum.KeyCode.F4 then 
        StopMoveset()
    elseif input.KeyCode == Enum.KeyCode.F5 then
        if watermarkObj and watermarkObj.Parent then watermarkObj:Destroy() end
    end
end)

print("Izayoi Moveset loaded!")