repeat wait() until game.Players.LocalPlayer.Character

--[[
   Tests during development
]]

-- Player, Workspace & Environment
local Players 	= game:GetService("Players")
local Player 	= Players.LocalPlayer
local Character	   = Player.Character
local Humanoid 	= Character:WaitForChild("Humanoid")
local Camera 	= workspace.CurrentCamera


-- services
local TweenService = game:GetService("TweenService")

-- lib
local DatGUI = require(Character:WaitForChild("dat.GUI"))

-- Environment
local Lighting			   = game.Lighting
local Atmosphere 		   = Instance.new("Atmosphere")
local Sky 				   = Instance.new('Sky')
local ColorCorrection	= Instance.new("ColorCorrectionEffect")
local SunRays			   = Instance.new("SunRaysEffect")

Atmosphere.Parent       = Lighting
Sky.Parent              = Lighting
ColorCorrection.Parent  = Lighting
SunRays.Parent          = Lighting

-- root gui
local gui = DatGUI.new({ width = 300 })

--- Lighting
local guiLigh		 	= gui.addFolder('Lighting')

local guiLighAppearance 	= guiLigh.addFolder('Appearance')
guiLighAppearance.add(Lighting, 'Ambient').listen()
guiLighAppearance.add(Lighting, 'Brightness', 0, 10, 0.01).listen()
guiLighAppearance.add(Lighting, 'OutdoorAmbient').listen()

local guiLighData	= guiLigh.addFolder('Data')
guiLighData.add(Lighting, 'ClockTime', 0, 23.9, 0.1).listen()
guiLighData.add(Lighting, 'GeographicLatitude', 0,360, 1).listen()
guiLighData.add(Lighting, 'TimeOfDay').readonly().listen()


--- Atmosphere
local guiAtm 		= gui.addFolder('Atmosphere')

local guiAtmAppearance 	= guiAtm.addFolder('Appearance')
guiAtmAppearance.add(Atmosphere, 'Density', 0, 1, 0.001).listen()
guiAtmAppearance.add(Atmosphere, 'Offset', 0, 1, 0.001).listen()

local guiAtmState 	= guiAtm.addFolder('State')
guiAtmState.add(Atmosphere, 'Color').listen()
guiAtmState.add(Atmosphere, 'Decay').listen()
guiAtmState.add(Atmosphere, 'Glare', 0, 10, 0.01).listen()
guiAtmState.add(Atmosphere, 'Haze', 0, 10, 0.01).listen()

--- Sky
local guiSky 				= gui.addFolder('Sky')
guiSky.add(Sky, 'CelestialBodiesShown', 0, 60, 1).listen()
guiSky.add(Sky, 'SunAngularSize', 0, 60, 1).listen()
guiSky.add(Sky, 'MoonAngularSize', 0, 60, 1).listen()

--- Color Correction
local guiColorCorrection 	= gui.addFolder('Color Correction')
guiColorCorrection.add(ColorCorrection, 'Enabled').listen()
guiColorCorrection.add(ColorCorrection, 'Brightness', -1, 1, 0.1).listen()
guiColorCorrection.add(ColorCorrection, 'Contrast', -1, 1, 0.1).listen()
guiColorCorrection.add(ColorCorrection, 'Saturation', -1, 1, 0.1).listen()
guiColorCorrection.add(ColorCorrection, 'TintColor', -1, 1, 0.1).listen()

--- Sun Rays
local guiSunRays 			= gui.addFolder('Sun Rays')
guiSunRays.add(SunRays, 'Enabled').listen()
guiSunRays.add(SunRays, 'Intensity', 0, 1, 0.01).listen()
guiSunRays.add(SunRays, 'Spread', 0, 1, 0.001).listen()

--- Presets
local guiPresets 			= gui.addFolder('Presets')
local presets = {
	-- reset to roblox default
	Default =  function()

		local tweenInfo = TweenInfo.new(.5, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

		TweenService:Create(Lighting, tweenInfo, {
			Ambient 	= Color3.fromRGB(138, 138, 138),
			Brightness 		= 2,
			OutdoorAmbient 	= Color3.fromRGB(128, 128, 128),
			ClockTime 	= 14,
			GeographicLatitude 	= 41.733,
		}):Play()		

		TweenService:Create(Atmosphere, tweenInfo, {
			Density	= 0.395,
			Offset 	= 0,
			Color 	= Color3.fromRGB(199, 170, 107),
			Decay 	= Color3.fromRGB(92, 60, 13),
			Glare 	= 0,
			Haze 	= 0,
		}):Play()

		Sky.CelestialBodiesShown = true
		TweenService:Create(Sky, tweenInfo, {
			SunAngularSize = 21,
			MoonAngularSize = 11
		}):Play()

		TweenService:Create(ColorCorrection, tweenInfo, {
			Brightness 	= 0,
			Contrast 	= 0,
			Saturation 	= 0,
			TintColor 	= Color3.fromRGB(255, 255, 255),
		}):Play()		

		TweenService:Create(SunRays, tweenInfo, {
			Intensity 	= 0.25,
			Spread 		= 1
		}):Play()
	end,
	SaharaSunset =  function()

		local tweenInfo = TweenInfo.new(.5, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

		TweenService:Create(Lighting, tweenInfo, {
			Ambient 	= Color3.fromRGB(138, 138, 138),
			Brightness 		= 2,
			OutdoorAmbient 	= Color3.fromRGB(100, 70, 70),
			ClockTime 	= 17.7,
			GeographicLatitude 	= 41.733,
		}):Play()		

		TweenService:Create(Atmosphere, tweenInfo, {
			Density	= 0.35,
			Offset 	= 0,
			Color 	= Color3.fromRGB(250, 180, 120),
			Decay 	= Color3.fromRGB(255, 0, 200),
			Glare 	= 1,
			Haze 	= 2.1,
		}):Play()

		Sky.CelestialBodiesShown = true
		TweenService:Create(Sky, tweenInfo, {
			SunAngularSize = 16,
			MoonAngularSize = 11
		}):Play()

		TweenService:Create(ColorCorrection, tweenInfo, {
			Brightness 	= 0,
			Contrast 	= 2,
			Saturation 	= 0.2,
			TintColor 	= Color3.fromRGB(200, 150, 220),
		}):Play()		

		TweenService:Create(SunRays, tweenInfo, {
			Intensity 	= 0.08,
			Spread 		= 0.75
		}):Play()
	end,
	NightCove =  function()

		local tweenInfo = TweenInfo.new(.5, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

		TweenService:Create(Lighting, tweenInfo, {
			Ambient 	= Color3.fromRGB(138, 138, 138),
			Brightness 		= 2,
			OutdoorAmbient 	= Color3.fromRGB(0, 160, 250),
			ClockTime 	= 20,
			GeographicLatitude 	= 41.733,
		}):Play()		

		TweenService:Create(Atmosphere, tweenInfo, {
			Density	= 0.4,
			Offset 	= 0,
			Color 	= Color3.fromRGB(0, 140, 200),
			Decay 	= Color3.fromRGB(92, 60, 13),
			Glare 	= 0,
			Haze 	= 2,
		}):Play()

		Sky.CelestialBodiesShown = false
		TweenService:Create(Sky, tweenInfo, {
			SunAngularSize = 21,
			MoonAngularSize = 11
		}):Play()

		TweenService:Create(ColorCorrection, tweenInfo, {
			Brightness 	= 0,
			Contrast 	= 0.1,
			Saturation 	= 0.15,
			TintColor 	= Color3.fromRGB(255, 255, 255),
		}):Play()		

		TweenService:Create(SunRays, tweenInfo, {
			Intensity 	= 0.25,
			Spread 		= 1
		}):Play()
	end,
	Tranquil =  function()

		local tweenInfo = TweenInfo.new(.5, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

		TweenService:Create(Lighting, tweenInfo, {
			Ambient 	= Color3.fromRGB(120, 125, 100),
			Brightness 		= 3,
			OutdoorAmbient 	= Color3.fromRGB(0, 0, 0),
			ClockTime 	= 16.6,
			GeographicLatitude 	= 41.733,
		}):Play()		

		-- ShadowSoftness	0.15
		-- EnvironmentDiffuseScale	1
		-- EnvironmentSpecularScale	1

		TweenService:Create(Atmosphere, tweenInfo, {
			Density	= 0.225,
			Offset 	= 1,
			Color 	= Color3.fromRGB(40, 190, 200),
			Decay 	= Color3.fromRGB(50, 40, 145),
			Glare 	= 0.55,
			Haze 	= 1,
		}):Play()

		Sky.CelestialBodiesShown = true
		TweenService:Create(Sky, tweenInfo, {
			SunAngularSize = 21,
			MoonAngularSize = 11
		}):Play()

		TweenService:Create(ColorCorrection, tweenInfo, {
			Brightness 	= 0,
			Contrast 	= 0.05,
			Saturation 	= 0.2,
			TintColor 	= Color3.fromRGB(255, 255, 255),
		}):Play()		

		TweenService:Create(SunRays, tweenInfo, {
			Intensity 	= 0.025,
			Spread 		= 0.25
		}):Play()
	end,
}


guiPresets.add(presets, 'Default')
guiPresets.add(presets, 'SaharaSunset', 'Sahara Sunset')
guiPresets.add(presets, 'NightCove', 'Night Cove')
guiPresets.add(presets, 'Tranquil')

--- Other tests
local guiOthers 			= gui.addFolder('Other')
local Object = {
   Text = 'Lorem ipsum dolor',
   Number = 25,
   NumberDouble = 25
}

guiOthers.add(Object, 'Text').listen().onChange(function(value)
   print('New text = '..value)
end)

guiOthers.add(Object, 'Number').step(1).listen().onChange(function(value)
   print('Number = ', value)
end)

guiOthers.add(Object, 'NumberDouble').step(0.001).listen().onChange(function(value)
   print('NumberDouble = ', value)
end)
