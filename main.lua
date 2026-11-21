– FRIES AUTO FARM | Compact UI – BlueStacks / Delta X – Количество
картофеля: 1-30

local Players = game:GetService(“Players”) local VIM =
game:GetService(“VirtualInputManager”) local CoreGui =
game:GetService(“CoreGui”) local player = Players.LocalPlayer

local Settings = { Amount = 4, CollectDelay = 0.25, DropDelay = 0.25,
TeleportDelay = 1 }

local PotatoPosition, BeltPosition = nil, nil local Running = false

local gui = Instance.new(“ScreenGui”) gui.Name = “FriesAutoFarmCompact”
gui.ResetOnSpawn = false local ok = pcall(function() gui.Parent =
CoreGui end) if not ok then gui.Parent =
player:WaitForChild(“PlayerGui”) end

– Компактное окно local frame = Instance.new(“Frame”) frame.Size =
UDim2.fromOffset(220, 300) frame.Position = UDim2.new(0.5, -110, 0.5,
-150) frame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
frame.BorderSizePixel = 0 frame.Parent = gui Instance.new(“UICorner”,
frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new(“TextLabel”) title.Size = UDim2.new(1, 0, 0,
32) title.BackgroundColor3 = Color3.fromRGB(230, 125, 30) title.Text =
“🍟 FRIES FARM” title.TextColor3 = Color3.new(1,1,1) title.Font =
Enum.Font.GothamBold title.TextSize = 15 title.Parent = frame
Instance.new(“UICorner”, title).CornerRadius = UDim.new(0, 10)

– Перетаскивание окна мышью/тачем local dragging, dragStart, startPos
title.InputBegan:Connect(function(input) if input.UserInputType ==
Enum.UserInputType.MouseButton1 or input.UserInputType ==
Enum.UserInputType.Touch then dragging = true dragStart = input.Position
startPos = frame.Position end end)
title.InputChanged:Connect(function(input) if input.UserInputType ==
Enum.UserInputType.MouseMovement or input.UserInputType ==
Enum.UserInputType.Touch then if dragging then local delta =
input.Position - dragStart frame.Position = UDim2.new( startPos.X.Scale,
startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset +
delta.Y ) end end end) title.InputEnded:Connect(function(input) if
input.UserInputType == Enum.UserInputType.MouseButton1 or
input.UserInputType == Enum.UserInputType.Touch then dragging = false
end end)

local function makeButton(text, y, color, callback) local b =
Instance.new(“TextButton”) b.Size = UDim2.new(0.90, 0, 0, 30) b.Position
= UDim2.new(0.05, 0, 0, y) b.BackgroundColor3 = color b.BorderSizePixel
= 0 b.TextColor3 = Color3.new(1,1,1) b.Text = text b.TextSize = 11
b.Font = Enum.Font.GothamBold b.Parent = frame Instance.new(“UICorner”,
b).CornerRadius = UDim.new(0, 7) b.MouseButton1Click:Connect(callback)
return b end

local amountLabel = Instance.new(“TextLabel”) amountLabel.Size =
UDim2.new(0.90, 0, 0, 18) amountLabel.Position = UDim2.new(0.05, 0, 0,
38) amountLabel.BackgroundTransparency = 1 amountLabel.Text =
“Количество (1–30)” amountLabel.TextColor3 = Color3.new(1,1,1)
amountLabel.TextSize = 11 amountLabel.Font = Enum.Font.Gotham
amountLabel.Parent = frame

local amountBox = Instance.new(“TextBox”) amountBox.Size =
UDim2.new(0.90, 0, 0, 27) amountBox.Position = UDim2.new(0.05, 0, 0, 57)
amountBox.BackgroundColor3 = Color3.fromRGB(50,50,60)
amountBox.BorderSizePixel = 0 amountBox.TextColor3 = Color3.new(1,1,1)
amountBox.Text = “4” amountBox.PlaceholderText = “1–30”
amountBox.TextSize = 13 amountBox.Font = Enum.Font.GothamBold
amountBox.Parent = frame Instance.new(“UICorner”,
amountBox).CornerRadius = UDim.new(0, 6)

amountBox.FocusLost:Connect(function() local n =
tonumber(amountBox.Text) Settings.Amount = n and
math.clamp(math.floor(n), 1, 30) or 4 amountBox.Text =
tostring(Settings.Amount) end)

local status = Instance.new(“TextLabel”) status.Size = UDim2.new(0.90,
0, 0, 22) status.Position = UDim2.new(0.05, 0, 0, 88)
status.BackgroundTransparency = 1 status.Text = “Ожидание”
status.TextColor3 = Color3.fromRGB(255, 210, 100) status.TextSize = 10
status.Font = Enum.Font.Gotham status.Parent = frame

local function getRoot() local char = player.Character return char and
char:FindFirstChild(“HumanoidRootPart”) end

makeButton(“СОХРАНИТЬ ТОЧКУ СБОРА”, 113, Color3.fromRGB(55, 100, 170),
function() local root = getRoot() if root then PotatoPosition =
root.CFrame status.Text = “Точка сбора сохранена” end end)

makeButton(“СОХРАНИТЬ ТОЧКУ ЛЕНТЫ”, 150, Color3.fromRGB(55, 100, 170),
function() local root = getRoot() if root then BeltPosition =
root.CFrame status.Text = “Точка ленты сохранена” end end)

local function click() local camera = workspace.CurrentCamera local size
= camera.ViewportSize local x, y = size.X / 2, size.Y / 2
VIM:SendMouseButtonEvent(x, y, 0, true, game, 0) task.wait(0.05)
VIM:SendMouseButtonEvent(x, y, 0, false, game, 0) end

local function drop() VIM:SendKeyEvent(true, Enum.KeyCode.Q, false,
game) task.wait(0.1) VIM:SendKeyEvent(false, Enum.KeyCode.Q, false,
game) end

local function teleport(position) local root = getRoot() if root and
position then root.CFrame = position + Vector3.new(0, 3, 0)
task.wait(Settings.TeleportDelay) end end

local startButton local function stopFarm() Running = false status.Text
= “Остановлено” if startButton then startButton.Text = “START AUTO FARM”
end end

startButton = makeButton(“START AUTO FARM”, 187, Color3.fromRGB(35, 155,
80), function() if Running then return end if not PotatoPosition or not
BeltPosition then status.Text = “Сначала сохрани 2 точки” return end

    Running = true
    startButton.Text = "AUTO FARM: ON"

    task.spawn(function()
        while Running do
            local amount = Settings.Amount
            status.Text = "Сбор картофеля..."
            teleport(PotatoPosition)

            for i = 1, amount do
                if not Running then break end
                click()
                status.Text = "Сбор: " .. i .. "/" .. amount
                task.wait(Settings.CollectDelay)
            end
            if not Running then break end

            status.Text = "Переход к ленте..."
            teleport(BeltPosition)

            for i = 1, amount do
                if not Running then break end
                drop()
                status.Text = "Выгрузка: " .. i .. "/" .. amount
                task.wait(Settings.DropDelay)
            end
            task.wait(0.5)
        end
        startButton.Text = "START AUTO FARM"
        status.Text = "Остановлено"
    end)

end)

makeButton(“STOP”, 224, Color3.fromRGB(180, 45, 45), stopFarm)
makeButton(“СКРЫТЬ МЕНЮ”, 261, Color3.fromRGB(65, 65, 75), function()
stopFarm() gui.Enabled = false end)

print(“FRIES AUTO FARM COMPACT LOADED”)
