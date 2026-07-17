local plr = game.Players.LocalPlayer
local rep = game:GetService("ReplicatedStorage")
local remote = rep:WaitForChild("ByteNetReliable")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

if getgenv().DisableWatermark == nil then getgenv().DisableWatermark = false end
if getgenv().LegitMode == nil then getgenv().LegitMode = false end

local stopped = false
local exeAwkOnCD = false

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

local cooldowns = {}
local buffers = {}

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

local skillNames = {
    [1] = "Shortcut",
    [2] = "Exterminate",
    [3] = "EXE Strike",
    [4] = "Open Metavision"
}

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
    noti.TextLabel.Text = "EXE Moveset Loaded!"
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
    if char then
        local state = char:FindFirstChild("state")
        if state then
            local stun = state:FindFirstChild("stun")
            if stun then
                stun.Value = true
                task.wait(0.04)
                stun.Value = false
            end
        end
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

local function BodyVelocity(part, speed, duration)
    if not part then return end
    for _, v in pairs(part:GetChildren()) do
        if v:IsA("BodyVelocity") then v:Destroy() end
    end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(350000, 0, 350000)
    bv.Parent = part
    bv.Velocity = part.CFrame.LookVector * speed
    task.delay(duration, function()
        if bv and bv.Parent then bv:Destroy() end
    end)
    return bv
end

local function TeleportShot(char, shootDelay)
    local root = char.HumanoidRootPart
    task.delay(shootDelay, function()
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Ball") then return end
        if getgenv().LegitMode then
            remote:FireServer(buffer.fromstring(buffers["base"]), {
                {"kick", 100, false, root.CFrame.LookVector * 1e19}
            })
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
        remote:FireServer(buffer.fromstring(buffers["base"]), {
            {"kick", 100, false, root.CFrame.LookVector * 1e19}
        })
        task.wait(0.001)
        root.CFrame = originalCFrame
    end)
end

local function BlockOriginalSkills()
    task.wait(0.1)
    local hotbar = plr.PlayerGui:FindFirstChild("Hotbar")
    if hotbar then
        local buttons = hotbar.Backpack.Hotbar
        for i = 1, 4 do
            local skill = buttons:FindFirstChild("skill" .. i)
            if skill and skill:FindFirstChild("Base") then
                local base = skill.Base
                base.Active = false
                base.AutoButtonColor = false
                pcall(function()
                    base.MouseButton1Click:DisconnectAll()
                    base.MouseButton1Down:DisconnectAll()
                end)
            end
        end
    end
end

local function Shortcut()
    local char = plr.Character
    if not char or Stunned() or IsOnCD("skill1") then return end

    CancelMove()
    DoCD("skill1", 1)

    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart

    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://116455589260954"
    local track = humanoid:LoadAnimation(anim)
    track.Priority = Enum.AnimationPriority.Action
    track:Play()

    pcall(function()
        require(rep.client.replication).DashSuper(char)
    end)

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://111414558186727"
    sound.Volume = 2
    sound.Parent = root
    sound:Play()
    Debris:AddItem(sound, 3)

    Stun(0.3, false)

    task.delay(1.5, function()
        pcall(function()
            track:Stop()
        end)
    end)
end

local function Exterminate()
    local char = plr.Character
    if not char or Stunned() or IsOnCD("skill2") then return end
    if HasBall() then return end

    local ball = workspace.Terrain:FindFirstChild("Ball")
    if not ball then return end

    local root = char.HumanoidRootPart
    local dist = (root.Position - ball.Position).Magnitude
    if dist > 1050 then return end

    CancelMove()
    DoCD("skill2", 0.8)

    local humanoid = char.Humanoid
    local originalCF = root.CFrame

    local grabbed = false
    local timeout = 0
    local maxTimeout = 300 

    while not grabbed and timeout < maxTimeout do
  
        local currentBall = workspace.Terrain:FindFirstChild("Ball")
        if not currentBall then
            root.CFrame = originalCF
            return
        end

        local targetPos = currentBall.Position + Vector3.new(0, 2, 0)
        root.CFrame = CFrame.new(targetPos, targetPos + Vector3.new(0, 0, -1))
        root.AssemblyLinearVelocity = Vector3.zero

        task.wait(0.1)

        remote:FireServer(buffer.fromstring(buffers["grabball"]))
        task.wait(0.05)

        if HasBall() then
            grabbed = true
            break
        end

        timeout = timeout + 1
    end

    if not grabbed then
        root.CFrame = originalCF
        return
    end

    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://71606482166598"
    local track = humanoid:LoadAnimation(anim)
    track.Priority = Enum.AnimationPriority.Action
    track:Play()

    root.Anchored = true

    pcall(function()
        require(rep.client.replication).TP(char)
    end)

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://130820040577966"
    sound.Volume = 2
    sound.Parent = root
    sound:Play()
    Debris:AddItem(sound, 5)

    Stun(0.7, true)

    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0.3
    highlight.Parent = char
    Debris:AddItem(highlight, 1.5)

    TweenService:Create(highlight, TweenInfo.new(1.5), {FillTransparency = 1}):Play()
    TweenService:Create(highlight, TweenInfo.new(1.5), {OutlineTransparency = 1}):Play()

    task.delay(1, function()
        root.Anchored = false
        pcall(function()
            track:Stop()
            if char and char.state then
                char.state.stun.Value = false
            end
        end)
    end)
end

local function EXEStrike()
    local char = plr.Character
    if not char or Stunned() or IsOnCD("skill3") then return end
    if not HasBall() then return end

    CancelMove()
    DoCD("skill3", 8)

    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart

    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://111105572890621"
    local track = humanoid:LoadAnimation(anim)
    track.Priority = Enum.AnimationPriority.Action
    track:Play()

    TweenService:Create(humanoid, TweenInfo.new(0.3, Enum.EasingStyle.Cubic), {HipHeight = 25}):Play()

    local sound1 = Instance.new("Sound")
    sound1.SoundId = "rbxassetid://71531490355205"
    sound1.Volume = 2
    sound1.Parent = root
    sound1:Play()
    Debris:AddItem(sound1, 4)

    task.spawn(function()
        task.wait(3.9)
        local sound2 = Instance.new("Sound")
        sound2.SoundId = "rbxassetid://125906215069324"
        sound2.Volume = 3
        sound2.Parent = root
        sound2:Play()
        Debris:AddItem(sound2, 5)
    end)

    pcall(function()
        require(rep.client.replication).DASTStrike(char)
    end)
   
    task.delay(3.8, function()
        root.Anchored = false
        root.Velocity = Vector3.new(0, -200, 0)
        humanoid.HipHeight = 0
    end)

    
    TeleportShot(char, 3.9)
    
    Stun(5.2, false)

    task.delay(5.2, function()
        pcall(function()
            track:Stop()
        end)
    end)
end

local function OpenMetavision()
    local char = plr.Character
    if not char or Stunned() or IsOnCD("skill4") then return end

    CancelMove()
    DoCD("skill4", 15)

    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart

    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do track:Stop(0) end

    Stun(0.3, false)

    local screen = Instance.new("ScreenGui", plr.PlayerGui)
    screen.IgnoreGuiInset = true
    local flash = Instance.new("Frame", screen)
    flash.Size = UDim2.fromScale(1, 1)
    flash.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    flash.BackgroundTransparency = 1
    TweenService:Create(flash, TweenInfo.new(0.05), {BackgroundTransparency = 0}):Play()
    task.delay(0.1, function()
        TweenService:Create(flash, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    end)
    Debris:AddItem(screen, 0.5)

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://80157960628620"
    sound.Volume = 10
    sound.Parent = root
    sound:Play()
    Debris:AddItem(sound, 4)
end

local function ExeAwk()
    local char = plr.Character
    if not char or Stunned() or exeAwkOnCD then return end
    if not HasBall() then return end

    exeAwkOnCD = true

    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart
    local savedStyle = plr:GetAttribute("style")

    Stun(21, true)
    plr:SetAttribute("style", "exe")

    TweenService:Create(humanoid, TweenInfo.new(0.3, Enum.EasingStyle.Cubic), {HipHeight = 25}):Play()

    task.spawn(function()
        pcall(function()
            local song = rep.Resources.exe.awkSong
            song.Volume = 12
            require(rep.util.soundUtil):play(song, SoundService)
            task.delay(129, function()
                song:Stop()
            end)
        end)
    end)

    task.spawn(function()
        pcall(function()
            require(rep.util.animationUtil):loadAnimation(char, rep.Resources.exe.awk):Play()
        end)
    end)

    task.spawn(function()
        pcall(function()
            require(rep.client.replication).exeAwk(char)
        end)
    end)

    task.delay(21, function()
        if not char or not char.Parent then return end
        
        TweenService:Create(humanoid, TweenInfo.new(0.3, Enum.EasingStyle.Cubic), {HipHeight = 0}):Play()
        plr:SetAttribute("style", savedStyle)
        
        task.delay(30, function()
            exeAwkOnCD = false
        end)
    end)
end
task.spawn(function()
    while true do
        if stopped then break end
        local gui = plr:WaitForChild("PlayerGui", 2)
        if gui then
            local hotbar = gui:FindFirstChild("Hotbar")
            if hotbar then
                hotbar.MagicHealth.Awakening.Text = "FLOW"
                hotbar.MagicHealth.TextLabel.Text = "Many Souls To Play With."
                hotbar.MagicHealth.Health.Frame.UIGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 0))
                }

                local backpack = hotbar:FindFirstChild("Backpack")
                if backpack then
                    local hb = backpack:FindFirstChild("Hotbar")
                    if hb then
                        for i = 1, 4 do
                            local skill = hb:FindFirstChild("skill" .. i)
                            if skill and skill:FindFirstChild("Base") and skill.Base:FindFirstChild("ToolName") then
                                if skill.Base.ToolName.Text ~= skillNames[i] then
                                    skill.Base.ToolName.Text = skillNames[i]
                                end
                            end
                            if skill and skill:FindFirstChild("Base") and skill.Base:FindFirstChild("Reuse") then
                                local reuseTexts = {
                                    [1] = "Ball Only",
                                    [2] = "Off Ball",
                                    [3] = "Ball Only",
                                    [4] = "God Mode"
                                }
                                skill.Base.Reuse.Text = reuseTexts[i] or ""
                                skill.Base.Reuse.Visible = true
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

local function Setup(char)
    if stopped then return end
    if not char then return end
    
    repeat task.wait() until plr.Team ~= game.Teams.lobby
    task.wait(0.1)
    
    BlockOriginalSkills()
    plr:SetAttribute("style", "exe")

    local hotbar = plr.PlayerGui:WaitForChild("Hotbar")
    local buttons = hotbar.Backpack.Hotbar

    if buttons.skill1 and buttons.skill1.Base then
        buttons.skill1.Base.MouseButton1Down:Connect(Shortcut)
        buttons.skill1.Base.MouseButton1Click:Connect(Shortcut)
        buttons.skill1.Visible = true
    end

    if buttons.skill2 and buttons.skill2.Base then
        buttons.skill2.Base.MouseButton1Down:Connect(Exterminate)
        buttons.skill2.Base.MouseButton1Click:Connect(Exterminate)
        buttons.skill2.Visible = true
    end

    if buttons.skill3 and buttons.skill3.Base then
        buttons.skill3.Base.MouseButton1Down:Connect(EXEStrike)
        buttons.skill3.Base.MouseButton1Click:Connect(EXEStrike)
        buttons.skill3.Visible = true
    end

    if buttons.skill4 and buttons.skill4.Base then
        buttons.skill4.Base.MouseButton1Down:Connect(OpenMetavision)
        buttons.skill4.Base.MouseButton1Click:Connect(OpenMetavision)
        buttons.skill4.Visible = false
    end

    if buttons.skill5 then
        buttons.skill5.Visible = false
    end

    pcall(function()
        if buttons.skill1 and buttons.skill1.Base then
            buttons.skill1.Base.TouchTap:Connect(Shortcut)
        end
        if buttons.skill2 and buttons.skill2.Base then
            buttons.skill2.Base.TouchTap:Connect(Exterminate)
        end
        if buttons.skill3 and buttons.skill3.Base then
            buttons.skill3.Base.TouchTap:Connect(EXEStrike)
        end
        if buttons.skill4 and buttons.skill4.Base then
            buttons.skill4.Base.TouchTap:Connect(OpenMetavision)
        end
    end)

    pcall(function()
        local mh = hotbar:FindFirstChild("MagicHealth")
        if mh and mh:FindFirstChild("Awakening") then
            mh.Awakening.TouchTap:Connect(ExeAwk)
            mh.Awakening.MouseButton1Click:Connect(ExeAwk)
        end
    end)

    createMobileUI({Shortcut, Exterminate, EXEStrike, OpenMetavision, ExeAwk})
end
end

Setup(plr.Character)

plr.CharacterAdded:Connect(function(char)
    exeAwkOnCD = false
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
        noti.TextLabel.Text = "EXE Moveset Stopped!"
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

    if input.KeyCode == Enum.KeyCode.G then
        ExeAwk()
    elseif input.KeyCode == Enum.KeyCode.One then
        Shortcut()
    elseif input.KeyCode == Enum.KeyCode.Two then
        Exterminate()
    elseif input.KeyCode == Enum.KeyCode.Three then
        EXEStrike()
    elseif input.KeyCode == Enum.KeyCode.Four then
        OpenMetavision()
    elseif input.KeyCode == Enum.KeyCode.F4 then
        StopMoveset()
    elseif input.KeyCode == Enum.KeyCode.F5 then
        if watermarkObj and watermarkObj.Parent then watermarkObj:Destroy() end
    end
end)

print("Sonic.exe Moveset loaded!")