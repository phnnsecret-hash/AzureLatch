local ReplicatedStorage = game.ReplicatedStorage

local buffers = {}
loadstring(game:HttpGet("https://pastebin.com/raw/8XJh7dzh"))()
repeat task.wait() until game.Lighting:FindFirstChild("BUFFERSTRINGS")
for _, val in ipairs(game.Lighting:FindFirstChild("BUFFERSTRINGS"):GetChildren()) do
    buffers[val.Name] = val.Value
end
game.Lighting:FindFirstChild("BUFFERSTRINGS"):Destroy()

game:GetService("ReplicatedStorage").Resources.shidou.NEWthemes.SoundId = "rbxassetid://101265113960897"
game:GetService("ReplicatedStorage").Resources.shidou.AwkOvertime.BGM.SoundId = "rbxassetid://101265113960897"

local plr = game.Players.LocalPlayer
local rep = game:GetService("ReplicatedStorage")
local remote = rep:WaitForChild("ByteNetReliable")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
if getgenv().DisableWatermark == nil then getgenv().DisableWatermark = false end
if getgenv().LegitMode == nil then getgenv().LegitMode = false end

local initialized = false
local disabled = false

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

local mobileUICreated = false

local lastAccelerate = 0
local accelerateCooldown = 7.5
local ronaldoAwkOnCD = false
local cooldowns = {}

local skillNames = {
    [1] = "CR7 Dribble",
    [2] = "Bicycle Kick",
    [3] = "Flawless Pass",
    [4] = "Reaction Dash"
}

if not getgenv().MessiNotifyGUI then
    getgenv().MessiNotifyGUI = plr.PlayerGui.Notification:Clone()
    getgenv().MessiNotifyGUI.Name = string.gsub(tostring(math.random()), '0.', ''):sub(1, 1000) .. string.char(math.random(65, 90), math.random(97, 122), math.random(48, 57))
    getgenv().MessiNotifyGUI.Parent = game.CoreGui
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
    noti.TextLabel.Text = "Ronaldo Moveset Loaded!"
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
    noti.TextLabel.Text = "Made By tze and celeron"
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
    watermarkObj.Text = ' Made By tze and celeron '
    watermarkObj.Name = getgenv().MessiWatermarkName
    watermarkObj.Position = UDim2.new(0, 0, -0.02, 0)
    watermarkObj.TextStrokeTransparency = 1
    watermarkObj.TextColor3 = Color3.fromRGB(0, 157, 255)
    watermarkObj.TextTransparency = 0.59
    watermarkObj.Parent = game.CoreGui.RobloxGui
    
    discordText.Parent = watermarkObj
end
end

local function IsOnCD(name)
    return cooldowns[name] == true
end

local function DoCD(name, duration)
    cooldowns[name] = true
    task.delay(duration, function()
        cooldowns[name] = false
    end)
end

local function ToggleAttachment(attachment, enabled, duration)
    if not attachment then return end
    for _, descendant in ipairs(attachment:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = enabled
        end
    end
    if duration and duration > 0 then
        task.delay(duration, function()
            ToggleAttachment(attachment, false)
        end)
    end
end

local function EmitAttachment(attachment)
    if not attachment then return end
    for _, descendant in ipairs(attachment:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            local delayTime = descendant:GetAttribute("EmitDelay") or 0
            local count = descendant:GetAttribute("EmitCount") or 1
            if delayTime > 0 then
                task.delay(delayTime, function()
                    descendant:Emit(count)
                end)
            else
                descendant:Emit(count)
            end
        end
    end
end

local function GroupWeld(model, rootPart)
    for _, part in ipairs(rootPart:GetDescendants()) do
        if part:IsA("BasePart") and model:FindFirstChild(part.Name) then
            local weld = Instance.new("Weld")
            weld.Name = "weld"
            weld.Part0 = model:FindFirstChild(part.Name)
            weld.Part1 = part
            weld.Parent = part
        end
    end
end

local function hasball()
    return plr.Character and plr.Character:FindFirstChild("Ball") ~= nil
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

local function BodyVelocity(part, speed, duration, startAtZero, easingInfo, delayTween, delayStart, useCustomTween)
    for _, v in pairs(part:GetChildren()) do
        if v:IsA("BodyVelocity") then v:Destroy() end
    end

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(350000, 0, 350000)
    bv.Parent = part
    task.delay(duration, function()
        if bv and bv.Parent then bv:Destroy() end
    end)

    local valueHolder = Instance.new("NumberValue")
    valueHolder.Value = startAtZero and 0 or speed
    valueHolder.Parent = bv

    if not useCustomTween then
        local tweenInfo = easingInfo or TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local goal = { Value = startAtZero and 0 or speed }
        game.TweenService:Create(valueHolder, tweenInfo, goal):Play()
    else
        task.delay(useCustomTween, function()
            local easingStyle = easingInfo or Enum.EasingStyle.Linear
            local goal = { Value = startAtZero and 0 or speed }
            local tweenInfo = TweenInfo.new(duration, easingStyle, Enum.EasingDirection.Out)
            game.TweenService:Create(valueHolder, tweenInfo, goal):Play()
        end)
    end

    if not delayStart then
        bv.Velocity = part.CFrame.LookVector * speed
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if not bv or not bv.Parent then
                connection:Disconnect()
                return
            end
            bv.Velocity = part.CFrame.LookVector * valueHolder.Value
        end)
    end

    return bv, valueHolder
end

local function sfx(sound, part)
    local s = sound:Clone()
    s.Parent = part
    s:Play()
    game.Debris:AddItem(s, s.TimeLength + 20)
end

local function StartCooldownUI(slotNumber, duration)
    local gui = plr:WaitForChild("PlayerGui", 5)
    if not gui then return end
    local hotbar = gui:FindFirstChild("Hotbar")
    if not hotbar then return end
    local backpack = hotbar:FindFirstChild("Backpack")
    if not backpack then return end
    local hb = backpack:FindFirstChild("Hotbar")
    if not hb then return end
    local skill = hb:FindFirstChild("skill" .. slotNumber)
    if not skill then return end
    local cdFrame = skill:FindFirstChild("Cooldown")
    if not cdFrame then return end
    cdFrame.Size = UDim2.new(1, 0, -1, 0)
    cdFrame.Visible = true
    local tween = TweenService:Create(cdFrame, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        cdFrame.Visible = false
    end)
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

local function RonaldoDribble()
    local char = plr.Character
    if not char or Stunned() or not hasball() or IsOnCD("skill1") then return end
    
    DoCD("skill1", 5)
    StartCooldownUI(1, 5)
    Stun(4.6, false)
    
    local anim = char.Humanoid:LoadAnimation(rep.Resources.ronaldo.running)
    anim:Play()

    local dribbleClone = rep.Resources.RonaldoDribble:Clone()
    GroupWeld(char, dribbleClone)
    dribbleClone.Parent = workspace.Effects
    sfx(rep.Resources.ronaldo.RonaldoDribble, char.HumanoidRootPart)
    game.Debris:AddItem(dribbleClone, 5)

    local root = char.HumanoidRootPart
    task.spawn(function()
        task.delay(1.5, function() if not disabled then BodyVelocity(root, 40, 1) end end)
        task.delay(1.8, function() if not disabled then BodyVelocity(root, 120, 1.1) end end)
        task.delay(2.5, function() if not disabled then BodyVelocity(root, 90, 0.75) end end)
        task.delay(2.9, function() if not disabled then BodyVelocity(root, 100, 0.85) end end)
        task.delay(3.2, function() if not disabled then BodyVelocity(root, 175, 1.7) end end)
        task.delay(3.9, function() if not disabled then BodyVelocity(root, 40, 0.65) end end)
    end)

    task.spawn(function()
        local attach = dribbleClone.Rig.Head["1"]
        EmitAttachment(attach)
        ToggleAttachment(attach, true, 1)
    end)

    task.delay(2.5, function() if not disabled then EmitAttachment(dribbleClone.Rig.HumanoidRootPart["3"]) end end)
    task.delay(2.933, function() if not disabled then EmitAttachment(dribbleClone.Rig.HumanoidRootPart["4"]) end end)
    task.delay(3.2, function() if not disabled then EmitAttachment(dribbleClone.Rig.HumanoidRootPart["3.2"]) end end)
    task.delay(3.417, function() if not disabled then EmitAttachment(dribbleClone.Rig.HumanoidRootPart["3.5"]) end end)
    task.delay(3.933, function() if not disabled then EmitAttachment(dribbleClone.Rig.HumanoidRootPart["5"]) end end)
end

local function RonaldoBicycle()
    local char = plr.Character
    if not char or Stunned() or not hasball() or IsOnCD("skill2") then return end
    
    DoCD("skill2", 8)
    StartCooldownUI(2, 8)
    Stun(1.5, false)

    local bicycle1 = Instance.new("Animation")
    bicycle1.AnimationId = "rbxassetid://126734456236034"
    local bicycle = char.Humanoid:LoadAnimation(bicycle1)
    bicycle.Priority = Enum.AnimationPriority.Action2
    bicycle:Play()

    sfx(rep.Resources.ronaldo.KICK, char.HumanoidRootPart)

    task.delay(0.8, function()
        if disabled then return end
        local boom = rep.Resources.ronaldo.bicyclekick:Clone()
        boom.Parent = char.HumanoidRootPart
        boom.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
        for _, v in pairs(boom:GetDescendants()) do
            if v:IsA("ParticleEmitter") then
                v:Emit(v:GetAttribute("EmitCount"))
            end
        end
        game.Debris:AddItem(boom, 5)
    end)

    TeleportShot(char, 0.9)
end

local function RonaldoPass()
    local char = plr.Character
    if not char or Stunned() or not hasball() or IsOnCD("skill3") then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local closestTeammate = nil
    local shortestDistance = 180

    for _, p in ipairs(game.Players:GetPlayers()) do
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

    if not closestTeammate then return end

    local targetRoot = closestTeammate.Character.HumanoidRootPart
    local distance = shortestDistance

    DoCD("skill3", 6)
    StartCooldownUI(3, 6)
    Stun(0.7, false)
    char.Humanoid.WalkSpeed = 0

    local passAnim = Instance.new("Animation")
    passAnim.AnimationId = "rbxassetid://129737241094076"
    local track = char.Humanoid:LoadAnimation(passAnim)
    track.Priority = Enum.AnimationPriority.Action
    track:Play()

    sfx(rep.Resources.ronaldo.KICK, root)

    task.wait(0.35)

    if not char or not root.Parent then return end

    local direction = (targetRoot.Position - root.Position).Unit
    local kickDir = Vector3.new(direction.X, 0.18, direction.Z).Unit
    local power = math.clamp(distance / 1.4, 18, 95)

    remote:FireServer(
        buffer.fromstring(buffers["base"]),
        { {"kick", power, true, vector.create(kickDir.X, kickDir.Y, kickDir.Z)} }
    )

    task.delay(0.7, function()
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = 40
        end
    end)
end

local function RonaldoDash()
    local char = plr.Character
    if not char or Stunned() or hasball() or IsOnCD("skill4") then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    DoCD("skill4", accelerateCooldown)
    StartCooldownUI(4, accelerateCooldown)
    Stun(1, false)

    local accelAnim = Instance.new("Animation")
    accelAnim.AnimationId = "rbxassetid://73266865968554"
    local track = char.Humanoid:LoadAnimation(accelAnim)
    track.Priority = Enum.AnimationPriority.Action
    track.TimePosition = 0
    track:Play()

    local accelSound = Instance.new("Sound")
    accelSound.SoundId = "rbxassetid://80157960628620"
    accelSound.Volume = 4
    accelSound.Parent = root
    accelSound:Play()
    game.Debris:AddItem(accelSound, 10)

    local effect1 = rep.Resources.nagi.newgroundcontroleffect["1"]:Clone()
    local effect2 = rep.Resources.nagi.newgroundcontroleffect["2"]:Clone()
    effect1.Parent = root
    effect2.Parent = root
    effect1.CFrame = root.CFrame
    effect2.CFrame = root.CFrame

    local allParticles = {}
    local colorToggle = true
    for _, obj in ipairs(effect1:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then
            local cloned = obj:Clone()
            cloned.Color = ColorSequence.new(colorToggle and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0))
            cloned.Size = NumberSequence.new(obj.Size.Keypoints[1].Value * 1.5)
            cloned.Parent = root
            cloned.Enabled = true
            table.insert(allParticles, cloned)
            colorToggle = not colorToggle
        end
    end
    for _, obj in ipairs(effect2:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then
            local cloned = obj:Clone()
            cloned.Color = ColorSequence.new(colorToggle and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0))
            cloned.Size = NumberSequence.new(obj.Size.Keypoints[1].Value * 1.1)
            cloned.Parent = root
            cloned.Enabled = true
            table.insert(allParticles, cloned)
            colorToggle = not colorToggle
        end
    end

    task.spawn(function()
        BodyVelocity(root, 120, 1, false, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
        task.delay(1, function()
            for _, p in allParticles do if p and p.Parent then p.Enabled = false end end
        end)
        task.delay(3, function()
            for _, p in allParticles do if p then p:Destroy() end end
            if effect1 then effect1:Destroy() end
            if effect2 then effect2:Destroy() end
        end)
    end)
end

local function RonaldoAwk()
    local char = plr.Character
    if not char or ronaldoAwkOnCD then return end
    if not hasball() then return end

    ronaldoAwkOnCD = true

    local humanoid = char.Humanoid
    local savedStyle = plr:GetAttribute("style")

    Stun(5.333, true)

    plr:SetAttribute("style", "ronaldo")

    task.spawn(function()
        pcall(function()
            require(rep.util.soundUtil):play(rep.Resources.ronaldo["0508"], game:GetService("SoundService"))
            local sound = game:GetService("SoundService"):WaitForChild("0508", 3)
            if sound then
                require(rep.client.replication).awkScreen(sound, Color3.fromRGB(255, 225, 150))
            end
        end)
    end)

    task.spawn(function()
        pcall(function()
            require(rep.util.animationUtil):loadAnimation(char, rep.Resources.ronaldo.newawk):Play()
        end)
    end)

    task.spawn(function()
        pcall(function()
            require(rep.client.replication).ronaldoAwk(char)
        end)
    end)

    task.delay(5.333, function()
        plr:SetAttribute("style", savedStyle)

        task.delay(30, function()
            ronaldoAwkOnCD = false
        end)
    end)
end

task.spawn(function()
    while true do
        if disabled then break end
        local gui = plr:WaitForChild("PlayerGui", 2)
        if gui then
            local hotbar = gui:FindFirstChild("Hotbar")
            if hotbar then
                hotbar.MagicHealth.Awakening.Text = "The Awakening of The Goat"
                hotbar.MagicHealth.TextLabel.Text = " Greatest Of All Time."
                hotbar.MagicHealth.Health.Frame.UIGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 225, 150)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 148, 0))
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
                                if i == 1 then skill.Base.Reuse.Text = "Ball" end
                                if i == 2 then skill.Base.Reuse.Text = "Shot" end
                                if i == 3 then skill.Base.Reuse.Text = "Pass" end
                                if i == 4 then skill.Base.Reuse.Text = "Off The Ball" end
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

if not mobileUICreated then
    mobileUICreated = true
    task.spawn(function()
        task.wait(2)
        if not disabled then
            createMobileUI({
                RonaldoDribble,
                RonaldoBicycle,
                RonaldoPass,
                RonaldoDash,
                RonaldoAwk
            })
        end
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

UserInputService.InputBegan:Connect(function(input, bg)
    if bg then return end
    if disabled then return end

    if input.KeyCode == Enum.KeyCode.F4 then
        disabled = true
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
            noti.TextLabel.Text = "Ronaldo Moveset Stopped!"
            TweenService:Create(noti, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {Size = UDim2.new(1.33, 0, 0.054, 0)}):Play()
            TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
            TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 0}):Play()
            task.delay(5, function()
                TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
                TweenService:Create(noti.TextLabel, TweenInfo.new(0.28, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()
            end)
        end)
    elseif input.KeyCode == Enum.KeyCode.One then
        RonaldoDribble()
    elseif input.KeyCode == Enum.KeyCode.Two then
        RonaldoBicycle()
    elseif input.KeyCode == Enum.KeyCode.Three then
        RonaldoPass()
    elseif input.KeyCode == Enum.KeyCode.Four then
        RonaldoDash()
    elseif input.KeyCode == Enum.KeyCode.G then
        RonaldoAwk()
    end
end)

local function load(char)
    if initialized then return end
    initialized = true
    repeat task.wait() until plr.Team ~= game.Teams.lobby
    task.wait(0.1)
    plr:SetAttribute("style", "ronaldo")
    BlockOriginalSkills()

    local hotbar = plr.PlayerGui:FindFirstChild("Hotbar")
    if hotbar then
        local buttons = hotbar.Backpack.Hotbar
        pcall(function()
            if buttons.skill1 and buttons.skill1.Base then
                buttons.skill1.Base.TouchTap:Connect(function()
                    if disabled or Stunned() or not hasball() or IsOnCD("skill1") then return end
                    local char = plr.Character
                    if not char then return end
                    DoCD("skill1", 5)
                    StartCooldownUI(1, 5)
                    Stun(4.6, false)
                    local anim = char.Humanoid:LoadAnimation(rep.Resources.ronaldo.running)
                    anim:Play()
                    local dribbleClone = rep.Resources.RonaldoDribble:Clone()
                    GroupWeld(char, dribbleClone)
                    dribbleClone.Parent = workspace.Effects
                    sfx(rep.Resources.ronaldo.RonaldoDribble, char.HumanoidRootPart)
                    game.Debris:AddItem(dribbleClone, 5)
                    local root = char.HumanoidRootPart
                    task.spawn(function()
                        task.delay(1.5, function() if not disabled then BodyVelocity(root, 40, 1) end end)
                        task.delay(1.8, function() if not disabled then BodyVelocity(root, 120, 1.1) end end)
                        task.delay(2.5, function() if not disabled then BodyVelocity(root, 90, 0.75) end end)
                        task.delay(2.9, function() if not disabled then BodyVelocity(root, 100, 0.85) end end)
                        task.delay(3.2, function() if not disabled then BodyVelocity(root, 175, 1.7) end end)
                        task.delay(3.9, function() if not disabled then BodyVelocity(root, 40, 0.65) end end)
                    end)
                end)
            end
            if buttons.skill2 and buttons.skill2.Base then
                buttons.skill2.Base.TouchTap:Connect(function()
                    local char = plr.Character
                    if not char or disabled or Stunned() or not hasball() or IsOnCD("skill2") then return end
                    DoCD("skill2", 8)
                    StartCooldownUI(2, 8)
                    Stun(1.5, false)
                    local bicycle1 = Instance.new("Animation")
                    bicycle1.AnimationId = "rbxassetid://126734456236034"
                    local bicycle = char.Humanoid:LoadAnimation(bicycle1)
                    bicycle.Priority = Enum.AnimationPriority.Action2
                    bicycle:Play()
                    sfx(rep.Resources.ronaldo.KICK, char.HumanoidRootPart)
                    task.delay(0.8, function()
                        if disabled then return end
                        local boom = rep.Resources.ronaldo.bicyclekick:Clone()
                        boom.Parent = char.HumanoidRootPart
                        boom.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                        for _, v in pairs(boom:GetDescendants()) do
                            if v:IsA("ParticleEmitter") then v:Emit(v:GetAttribute("EmitCount")) end
                        end
                        game.Debris:AddItem(boom, 5)
                    end)
                    TeleportShot(char, 0.9)
                end)
            end
            if buttons.skill3 and buttons.skill3.Base then
                buttons.skill3.Base.TouchTap:Connect(function()
                    local char = plr.Character
                    if not char or disabled or Stunned() or not hasball() or IsOnCD("skill3") then return end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then return end
                    local closestTeammate, shortestDistance = nil, 180
                    for _, p in ipairs(game.Players:GetPlayers()) do
                        if p == plr or not p.Character or p.Team ~= plr.Team or p.Team == game.Teams.lobby then continue end
                        local tr = p.Character:FindFirstChild("HumanoidRootPart")
                        if not tr then continue end
                        local d = (root.Position - tr.Position).Magnitude
                        if d < shortestDistance then shortestDistance = d; closestTeammate = p end
                    end
                    if not closestTeammate then return end
                    local targetRoot = closestTeammate.Character.HumanoidRootPart
                    DoCD("skill3", 6)
                    StartCooldownUI(3, 6)
                    Stun(0.7, false)
                    char.Humanoid.WalkSpeed = 0
                    local passAnim = Instance.new("Animation")
                    passAnim.AnimationId = "rbxassetid://129737241094076"
                    local track = char.Humanoid:LoadAnimation(passAnim)
                    track.Priority = Enum.AnimationPriority.Action
                    track:Play()
                    sfx(rep.Resources.ronaldo.KICK, root)
                    task.wait(0.35)
                    if not char or not root.Parent then return end
                    local direction = (targetRoot.Position - root.Position).Unit
                    local kickDir = Vector3.new(direction.X, 0.18, direction.Z).Unit
                    local power = math.clamp(shortestDistance / 1.4, 18, 95)
                    remote:FireServer(buffer.fromstring(buffers["base"]), { {"kick", power, true, vector.create(kickDir.X, kickDir.Y, kickDir.Z)} })
                    task.delay(0.7, function() if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 40 end end)
                end)
            end
            if buttons.skill4 and buttons.skill4.Base then
                buttons.skill4.Base.TouchTap:Connect(function()
                    local char = plr.Character
                    if not char or disabled or Stunned() or hasball() or IsOnCD("skill4") then return end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then return end
                    DoCD("skill4", accelerateCooldown)
                    StartCooldownUI(4, accelerateCooldown)
                    Stun(1, false)
                    local accelAnim = Instance.new("Animation")
                    accelAnim.AnimationId = "rbxassetid://73266865968554"
                    local track = char.Humanoid:LoadAnimation(accelAnim)
                    track.Priority = Enum.AnimationPriority.Action
                    track.TimePosition = 0
                    track:Play()
                    local accelSound = Instance.new("Sound")
                    accelSound.SoundId = "rbxassetid://80157960628620"
                    accelSound.Volume = 4
                    accelSound.Parent = root
                    accelSound:Play()
                    game.Debris:AddItem(accelSound, 10)
                    task.spawn(function() BodyVelocity(root, 120, 1, false, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)) end)
                end)
            end
        end)
    end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
end

load(plr.Character)

plr.CharacterAdded:Connect(function(char)
    ronaldoAwkOnCD = false
    initialized = false
    task.wait(1)
    load(char)
end)

task.spawn(function()
    local hotbar = plr.PlayerGui:WaitForChild("Hotbar", 10)
    if not hotbar then return end
    local awakening = hotbar:FindFirstChild("MagicHealth") and hotbar.MagicHealth:FindFirstChild("Awakening")
    if awakening then
        pcall(function() awakening.TouchTap:Connect(RonaldoAwk) end)
        pcall(function() awakening.MouseButton1Click:Connect(RonaldoAwk) end)
    end
end)

print("Ronaldo Moveset loaded!")
