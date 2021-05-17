function gv()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Window = Library.CreateLib("CarHub - Greenville", "BloodTheme")
    local Tab = Window:NewTab("Main")
    local Section = Tab:NewSection("Autofarms")
    Section:NewButton("Autofarm", "Greenville Autofarm", function ()
                    --Vars
            LocalPlayer = game:GetService("Players").LocalPlayer
            Camera = workspace.CurrentCamera
            RunService = game:GetService("RunService")
            VirtualUser = game:GetService("VirtualUser")
            MarketplaceService = game:GetService("MarketplaceService")

            --Get Current Vehicle
            function GetCurrentVehicle()
                return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.SeatPart and LocalPlayer.Character.Humanoid.SeatPart.Parent
            end

            --Metatables
            MT = getrawmetatable(game)
            Old_Index = MT.__index
            setreadonly(MT, false)
            MT.__index = newcclosure(function(self, K)
                if self:IsA("Sound") and self:IsDescendantOf(workspace.SessionVehicles) and AntiSkidMarkSounds then
                    self:Stop()
                    return
                end
                return Old_Index(self, K)
            end)
            setreadonly(MT, true)

            --Notification Handler
            function SendNotification(Title, Message, Duration)
                game.StarterGui:SetCore("SendNotification", {
                    Title = Title;
                    Text = Message;
                    Duration = Duration;
                })
            end

            --Regular TP
            function TP(cframe)
                GetCurrentVehicle():SetPrimaryPartCFrame(cframe)
            end

            --Velocity TP
            function VelocityTP(cframe)
                TeleportSpeed = 500
                Car = GetCurrentVehicle()
                for I,V in pairs(GetCurrentVehicle():GetDescendants()) do
                    if V:IsA("BodyGyro") then
                        V:Destroy()
                    end
                end
                local BodyGyro = Instance.new("BodyGyro", Car.PrimaryPart)
                BodyGyro.P = 5000
                BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                BodyGyro.CFrame = Car.PrimaryPart.CFrame
                local BodyVelocity = Instance.new("BodyVelocity", Car.PrimaryPart)
                BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                BodyVelocity.Velocity = CFrame.new(Car.PrimaryPart.Position, cframe.p).LookVector * TeleportSpeed
                wait((Car.PrimaryPart.Position - cframe.p).Magnitude / TeleportSpeed)
                BodyVelocity.Velocity = Vector3.new()
                wait(0.1)
                BodyVelocity:Destroy()
                BodyGyro:Destroy()
            end

            --Auto Farm
            StartPosition = CFrame.new(Vector3.new(-1818, -79, -10685), Vector3.new(-880, -79, -10769))
            EndPosition = CFrame.new(Vector3.new(-965, -79, -10761), Vector3.new(-880, -79, -10769))
            AutoFarmFunc = coroutine.create(function()
                while wait() do
                    if not AutoFarm then
                        AutoFarmRunning = false
                        coroutine.yield()
                    end
                    AutoFarmRunning = true
                    pcall(function()
                        if not GetCurrentVehicle() and tick() - (LastNotif or 0) > 5 then
                            LastNotif = tick()
                            SendNotification("Aloha Scripts", "Please Enter A Vehicle")
                        else
                            TP(StartPosition + (TouchTheRoad and Vector3.new() or Vector3.new(0, 1, 0)))
                            VelocityTP(EndPosition + (TouchTheRoad and Vector3.new() or Vector3.new(0, 1, 0)))
                            TP(EndPosition + (TouchTheRoad and Vector3.new() or Vector3.new(0, 1, 0)))
                            VelocityTP(StartPosition + (TouchTheRoad and Vector3.new() or Vector3.new(0, 1, 0)))
                        end
                    end)
                end
            end)

            --Anti AFK
            AntiAFK = true
            LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(), Camera.CFrame)
            end)

            --UI
            local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
            local venyx = library.new(MarketplaceService:GetProductInfo(game.PlaceId).Name)

            --Themes
            local themes = {
                Background = Color3.fromRGB(24, 24, 24),
                Glow = Color3.fromRGB(0, 0, 0),
                Accent = Color3.fromRGB(10, 10, 10),
                LightContrast = Color3.fromRGB(20, 20, 20),
                DarkContrast = Color3.fromRGB(14, 14, 14),
                TextColor = Color3.fromRGB(255, 255, 255)
            }

            --Pages
            local page1 = venyx:addPage("Main")
            local page2 = venyx:addPage("Other")

            --Page 1
            local FirstSection1 = page1:addSection("Auto Farm")
            local FirstSection2 = page1:addSection("Options")

            FirstSection1:addToggle(
                "Enabled",
                nil,
                function(value)
                    AutoFarm = value
                    if value and not AutoFarmRunning then
                        coroutine.resume(AutoFarmFunc)
                    end
                end
            )
            FirstSection2:addToggle(
                "Touch The Ground",
                nil,
                function(value)
                    TouchTheRoad = value
                end
            )
            FirstSection2:addToggle(
                "Anti Skid Mark Sounds",
                nil,
                function(value)
                    AntiSkidMarkSounds = value
                end
            )

            --Page 2
            local SecondSection1 = page2:addSection("Info")
            local SecondSection2 = page2:addSection("Settings")

            SecondSection2:addToggle(
                "Anti AFK",
                true,
                function(value)
                    AntiAFK = value
                end
            )
            SecondSection2:addKeybind(
                "Toggle Keybind",
                Enum.KeyCode.RightShift,
                function()
                    venyx:toggle()
                end,
                function(key)
                    Keybind = key.KeyCode.Name
                end
            )
            for theme, color in pairs(themes) do
                SecondSection2:addColorPicker(
                    theme,
                    color,
                    function(color3)
                        venyx:setTheme(theme, color3)
                    end
                )
            end

            --load
            venyx:SelectPage(venyx.pages[1], true)
        end)      
        local credits = Window:NewTab("Credits")
        local creditsection = credits:NewSection("Credits")
        creditsection:NewButton("https://discord.gg/a3trmMsU7C")
        creditsection:NewButton("Credits:")
        creditsection:NewButton("alohabeach#3448")
        creditsection:NewButton("coola#6969")
        creditsection:NewButton("Dorrow#0001")
        creditsection:NewButton("sjonks#5139")
end
------------------------------------------------------------------------------------
function de()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Window = Library.CreateLib("CarHub - Driving Empire", "BloodTheme")
    local Tab = Window:NewTab("Main")
    local Section = Tab:NewSection("Autofarms")
    Section:NewButton("Autofarm", nil, function ()
        --Vars
        LocalPlayer = game:GetService("Players").LocalPlayer
        Camera = workspace.CurrentCamera
        VirtualUser = game:GetService("VirtualUser")
        MarketplaceService = game:GetService("MarketplaceService")

        --Get Current Vehicle
        function GetCurrentVehicle()
            return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.SeatPart and LocalPlayer.Character.Humanoid.SeatPart.Parent
        end

        --Notification Handler
        function SendNotification(Title, Message, Duration)
            game.StarterGui:SetCore("SendNotification", {
                Title = Title;
                Text = Message;
                Duration = Duration;
            })
        end

        --Regular TP
        function TP(cframe)
            GetCurrentVehicle():SetPrimaryPartCFrame(cframe)
        end

        --Velocity TP
        function VelocityTP(cframe)
            TeleportSpeed = math.random(200, 600)
            Car = GetCurrentVehicle()
            local BodyGyro = Instance.new("BodyGyro", Car.PrimaryPart)
            BodyGyro.P = 5000
            BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            BodyGyro.CFrame = Car.PrimaryPart.CFrame
            local BodyVelocity = Instance.new("BodyVelocity", Car.PrimaryPart)
            BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            BodyVelocity.Velocity = CFrame.new(Car.PrimaryPart.Position, cframe.p).LookVector * TeleportSpeed
            wait((Car.PrimaryPart.Position - cframe.p).Magnitude / TeleportSpeed)
            BodyVelocity.Velocity = Vector3.new()
            wait(0.1)
            BodyVelocity:Destroy()
            BodyGyro:Destroy()
        end

        --Auto Farm
        StartPosition = CFrame.new(Vector3.new(583, 25.7, 2144), Vector3.new(-187, 25.7, 1982))
        EndPosition = CFrame.new(Vector3.new(-63, 25.7, 2010), Vector3.new(-187, 25.7, 1982))
        AutoFarmFunc = coroutine.create(function()
            while wait() do
                if not AutoFarm then
                    AutoFarmRunning = false
                    coroutine.yield()
                end
                AutoFarmRunning = true
                pcall(function()
                    if not GetCurrentVehicle() and tick() - (LastNotif or 0) > 5 then
                        LastNotif = tick()
                        SendNotification("Aloha Scripts", "Please Enter A Vehicle")
                    else
                        TP(StartPosition + (TouchTheRoad and Vector3.new() or Vector3.new(0, 1, 0)))
                        VelocityTP(EndPosition + (TouchTheRoad and Vector3.new() or Vector3.new(0, 1, 0)))
                        TP(EndPosition + (TouchTheRoad and Vector3.new() or Vector3.new(0, 1, 0)))
                        VelocityTP(StartPosition + (TouchTheRoad and Vector3.new() or Vector3.new(0, 1, 0)))
                    end
                end)
            end
        end)

        --Anti AFK
        AntiAFK = true
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(), Camera.CFrame)
        end)

        --UI
        local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
        local venyx = library.new(MarketplaceService:GetProductInfo(game.PlaceId).Name)

        --Themes
        local themes = {
            Background = Color3.fromRGB(24, 24, 24),
            Glow = Color3.fromRGB(0, 0, 0),
            Accent = Color3.fromRGB(10, 10, 10),
            LightContrast = Color3.fromRGB(20, 20, 20),
            DarkContrast = Color3.fromRGB(14, 14, 14),
            TextColor = Color3.fromRGB(255, 255, 255)
        }

        --Pages
        local page1 = venyx:addPage("Main")
        local page2 = venyx:addPage("Other")

        --Page 1
        local FirstSection1 = page1:addSection("Auto Farm")
        local FirstSection2 = page1:addSection("Options")

        FirstSection1:addToggle(
            "Enabled",
            nil,
            function(value)
                AutoFarm = value
                if value and not AutoFarmRunning then
                    coroutine.resume(AutoFarmFunc)
                end
            end
        )
        FirstSection2:addToggle(
            "Touch The Ground",
            nil,
            function(value)
                TouchTheRoad = value
            end
        )

        --Page 2
        local SecondSection1 = page2:addSection("Info")
        local SecondSection2 = page2:addSection("Settings")

        SecondSection2:addToggle(
            "Anti AFK",
            true,
            function(value)
                AntiAFK = value
            end
        )
        SecondSection2:addKeybind(
            "Toggle Keybind",
            Enum.KeyCode.RightShift,
            function()
                venyx:toggle()
            end,
            function(key)
                Keybind = key.KeyCode.Name
            end
        )
        for theme, color in pairs(themes) do
            SecondSection2:addColorPicker(
                theme,
                color,
                function(color3)
                    venyx:setTheme(theme, color3)
                end
            )
        end

        --load
        venyx:SelectPage(venyx.pages[1], true)
    end)
    local credits = Window:NewTab("Credits")
    local creditsection = credits:NewSection("Credits")
    creditsection:NewButton("https://discord.gg/a3trmMsU7C")
    creditsection:NewButton("Credits:")
    creditsection:NewButton("alohabeach#3448")
    creditsection:NewButton("coola#6969")
    creditsection:NewButton("Dorrow#0001")
    creditsection:NewButton("sjonks#5139")
end
----------------------------------------------------------------------------
function ud()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Window = Library.CreateLib("CarHub - Ultimate Driving", "BloodTheme")
    local Tab = Window:NewTab("Main")
    local Section = Tab:NewSection("Autofarms")
    Section:NewButton("Trucker Farm", nil, function ()
                --Vars
        LocalPlayer = game:GetService("Players").LocalPlayer

        --Teleport Stuff
        function GetTeleportModel()
            if LocalPlayer.Values.References.CarSeat.Value then
                return LocalPlayer.Values.References.CarSeat.Value.Parent
            end
            return LocalPlayer.Character
        end
        function TP(cframe)
            GetTeleportModel():SetPrimaryPartCFrame(cframe)
        end

        --base coords   | CFrame.new(-5916, -2, 1646)
        --load          | workspace.NavigationBeam.Locator.CFrame * CFrame.new(-30, 0, 0) * CFrame.Angles(0, math.rad(90), 0)
        --unload        | workspace.NavigationBeam.Locator.CFrame * CFrame.new(0, 0, -30)
        --fire e circle | fireproximityprompt(LocalPlayer.Character.HumanoidRootPart.CharacterPrompt)
        TP(workspace.NavigationBeam.Locator.CFrame * CFrame.new(-30, 0, 0) * CFrame.Angles(0, math.rad(90), 0))
        wait(3)
        fireproximityprompt(LocalPlayer.Character.HumanoidRootPart.CharacterPrompt)
        wait(1)
        TP(workspace.NavigationBeam.Locator.CFrame * CFrame.new(0, 0, -30))
        wait(3)
        fireproximityprompt(LocalPlayer.Character.HumanoidRootPart.CharacterPrompt)
        wait(1)
        TP(CFrame.new(-5916, -2, 1646))
    end)



Section:NewButton("Drive Farm", nil, function ()
                    LocalPlayer = game:GetService("Players").LocalPlayer
            VirtualInputManager = game:GetService("VirtualInputManager")

            --Get Current Vehicle
            function GetCurrentVehicle()
                for I,V in pairs(workspace._Main.Vehicles:GetChildren()) do
                    if V:FindFirstChild("VehicleSeat") and V.VehicleSeat.Values.Owner.Value == LocalPlayer.Name then
                        return V
                    end
                end
                return false
            end

            RandomStartingPoints = {
                CFrame.new(Vector3.new(-5199.02148, 11.2384281, 2232.14966), Vector3.new(-4895.96582, 17.4701748, 3351.20142)),
                CFrame.new(Vector3.new(-4365.95898, 4.92255068, 4035.51294), Vector3.new(-3212.04932, 23.6072636, 4682.89111)),
                CFrame.new(Vector3.new(-2411.05835, 37.2198448, 6098.20166), Vector3.new(-2122.64282, 34.9165268, 7160.03467)),
                CFrame.new(Vector3.new(-1370.33789, 40.9798126, 8576.16113), Vector3.new(-534.19104, 83.6058426, 9407.58301)),
                CFrame.new(Vector3.new(1175.35352, 14.8196917, 10630.1641), Vector3.new(1739.06274, 15.0952301, 9785.10938))
            }

            while wait() do
                GetCurrentVehicle():SetPrimaryPartCFrame(RandomStartingPoints[math.random(1, #RandomStartingPoints)])
                VirtualInputManager:SendKeyEvent(true, "W", false, game)
                local Max = 300
                repeat wait() Max = Max - 1 until GetCurrentVehicle().VehicleSeat.Velocity.Magnitude / 2 >= 70 or Max <= 0
                VirtualInputManager:SendKeyEvent(false, "W", false, game)
                VirtualInputManager:SendKeyEvent(true, "S", false, game)
                local Max = 100
                repeat wait() Max = Max - 1 until GetCurrentVehicle().VehicleSeat.Velocity.Magnitude / 2 <= 3 or Max <= 0
                VirtualInputManager:SendKeyEvent(false, "S", false, game)
            end
    end)
    local credits = Window:NewTab("Credits")
    local creditsection = credits:NewSection("Credits")
    creditsection:NewButton("https://discord.gg/a3trmMsU7C")
    creditsection:NewButton("Credits:")
    creditsection:NewButton("alohabeach#3448")
    creditsection:NewButton("coola#6969")
    creditsection:NewButton("Dorrow#0001")
    creditsection:NewButton("sjonks#5139")
end
--check place and load here
if game.PlaceId == 891852901 then
    gv()
elseif game.PlaceId == 54865335 then
    ud()
elseif game.PlaceId == 3351674303 then
    de()
end
