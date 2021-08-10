
--[[
   Tests during development
]]

-- services
local TweenService = game:GetService("TweenService")

-- lib
local DatGUI = require(game.ReplicatedStorage:WaitForChild("dat.GUI"))

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
local gui = DatGUI.new({ 
   closeable = false,
   -- width = 300
})

gui.addLogo('rbxassetid://6728606847', 100)

--- Lighting
local guiLigh		 	= gui.addFolder('Lighting')


local guiLighAppearance 	= guiLigh.addFolder('Appearance')
guiLighAppearance.add(Lighting, 'Ambient').listen()
   .help('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin mollis molestie sollicitudin. Quisque efficitur sapien dui. Mauris non nibh lorem. Quisque ut neque quis ipsum elementum tincidunt a aliquet justo')
guiLighAppearance.add(Lighting, 'Brightness', 0, 10, 0.01).readonly().listen()
guiLighAppearance.add(Lighting, 'OutdoorAmbient').readonly().listen()

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
local guiOthers = gui.addFolder('Other', { 
   fixed = true
})
guiOthers.action({
   icon = "rbxassetid://181024964",
   title = "Add new item", 
   Color = Color3.fromRGB(0, 255, 255),
   ColorHover = Color3.fromRGB(0, 255, 255),
   onHover = function(isHover)
      
   end,
   onClick = function()
      print("CLicked")
   end
})

--[[
   Open new panel, can be closed
]]
local function OpenOtherPanel()

   local gui = DatGUI.new({ 
      closeable = true,
      -- width = 300
   })

   gui.move('center', 'center')
      
   --------------------------
   -- Custom controller
   --------------------------
   local customRemoved = false
   local customFrame = Instance.new("Frame")
   customFrame.BackgroundTransparency = 1
   customFrame.BorderSizePixel = 0

   gui.addCustom('CustomController', {
      frame = customFrame,
      height = 150,
      onRemove = function()
         customRemoved = true
      end
   })

   coroutine.wrap(function()
      local TweenService = game:GetService("TweenService")

      -- how much confetti per second
      local rate = 15

      while true do
         local confetti = Instance.new("Frame")
         confetti.ZIndex            = 1
         confetti.AnchorPoint       = Vector2.new(0.5, 0.5)
         confetti.Rotation          = math.random(-360,360)
         confetti.Size              = UDim2.new(0.02, 0, 0.04, 0)
         confetti.Position          = UDim2.new(math.random(3,97)/100, 0, -0.1, 0)
         confetti.BackgroundColor3  = Color3.fromRGB(math.random(150,255), math.random(150,255), math.random(150,255))
         confetti.Parent = customFrame

         local lifetime = math.random(7,15)/10

         TweenService:Create(confetti,  TweenInfo.new(lifetime, Enum.EasingStyle.Linear), {
            Size     = UDim2.new(0, 0, 0, 0), 
            Rotation = math.random(-360,360),
            Position = UDim2.new(confetti.Position.X.Scale, 0, 1.1, 0)
         }):Play()

         game.Debris:AddItem(confetti, lifetime)

         if customRemoved then 
            break
         else 
            wait(1/rate)
         end
      end
   end)()
   --------------------------


   --- Bool
   local boolValue = Instance.new('BoolValue')
   local BooleansObject = {
      Bool = true,
      BoolValue = boolValue
   }

   local guiOthersBool  = gui.addFolder('Booleans')

   guiOthersBool.add(BooleansObject, 'Bool').listen().onChange(function(value)
      print('Bool = ', value)
      assert(BooleansObject.Bool == value)
   end)

   guiOthersBool.add(BooleansObject, 'BoolValue').listen().onChange(function(value)
      print('BoolValue = ', value)
      assert(BooleansObject.BoolValue.Value == value)
   end)


   --- Numbers
   local numberValue = Instance.new('NumberValue')

   numberValue.Value = 4.00

   local NumbersObject = {
      Number = 25,
      NumberSlider = 0.5,
      NumberDouble = 33,
      NumberValue = numberValue,
      NumberValueSlider = numberValue
   }

   local guiOthersNumber  = gui.addFolder('Numbers')

   guiOthersNumber.add(NumbersObject, 'Number').step(1).listen().onChange(function(value)
      print('Number = ', value)
      assert(NumbersObject.Number == value)
   end)

   guiOthersNumber.add(NumbersObject, 'NumberSlider', 0, 1).listen().onChange(function(value)
      print('NumberSlider = ', value)
      assert(NumbersObject.NumberSlider == value)
   end)

   guiOthersNumber.add(NumbersObject, 'NumberDouble').step(0.001).listen().onChange(function(value)
      print('NumberDouble = ', value)
      assert(NumbersObject.NumberDouble == value)
   end)

   guiOthersNumber.add(NumbersObject, 'NumberValue').listen().onChange(function(value)
      print('NumberValue = ', value)
      assert(NumbersObject.NumberValue.Value == value)
   end)

   guiOthersNumber.add(NumbersObject, 'NumberValueSlider', 1, 15).listen().onChange(function(value)
      print('NumberValueSlider = ', value)
      assert(NumbersObject.NumberValueSlider.Value == value)
   end)


   --- Strings
   local stringValue = Instance.new('StringValue')
   local StringsObject = {
      String = 'Lorem ipsum dolor',
      StringValue = stringValue,
      StringMultiline = 'Lorem ipsum dolor \nLorem ipsum dolor '
   }

   local guiOthersStrings  = gui.addFolder('Strings')

   guiOthersStrings.add(StringsObject, 'String').listen().onChange(function(value)
      print('String = '..value)
      assert(StringsObject.String == value)
   end)

   guiOthersStrings.add(StringsObject, 'StringValue').listen().onChange(function(value)
      print('StringValue = '..value)
      assert(StringsObject.StringValue.Value == value)
   end)

   guiOthersStrings.add(StringsObject, 'StringMultiline', true).listen().onChange(function(value)
      print('StringMultiline = '..value)
      assert(StringsObject.StringMultiline == value)
   end)


   --- Options
   local OptionsObject = {
      OptionsEnum       = 2,
      OptionsEnumItem   = Enum.ScaleType.Slice,
      OptionsArray      = 1,
      OptionsObject     = 'THREE',
   }

   local guiOthersOptions  = gui.addFolder('Options')

   guiOthersOptions.add(OptionsObject, 'OptionsEnum', Enum.ScaleType).listen().onChange(function(value, text)
      print('OptionsEnum = ', value, text)
      assert(OptionsObject.OptionsEnum == value)
   end)

   guiOthersOptions.add(OptionsObject, 'OptionsEnumItem').listen().onChange(function(value, text)
      print('OptionsEnum = ', value, text)
      assert(OptionsObject.OptionsEnumItem == value)
   end)

   guiOthersOptions.add(OptionsObject, 'OptionsArray', {'One', 'Two', 'Three'}).listen().onChange(function(value, text)
      print('OptionsEnum = ', value, text)
      assert(OptionsObject.OptionsArray == value)
   end)

   guiOthersOptions.add(OptionsObject, 'OptionsObject', { ONE = 'One', TWO = 'Two', THREE = 'Three' }).listen().onChange(function(value, text)
      print('OptionsObject = ', value, text)
      assert(OptionsObject.OptionsObject == value)
   end)

   --- Color3
   local color3Value = Instance.new('Color3Value')
   local Color3Object = {
      Color3 = Color3.fromRGB(255, 0, 255),
      Color3Value = color3Value
   }

   local guiOthersColor3  = gui.addFolder('Color3')

   guiOthersColor3.add(Color3Object, 'Color3').listen().onChange(function(value)
      print('Color3 = ', value)
      assert(Color3Object.Color3.R == value.R)
      assert(Color3Object.Color3.G == value.G)
      assert(Color3Object.Color3.B == value.B)
   end)

   guiOthersColor3.add(Color3Object, 'Color3Value').listen().onChange(function(value)
      print('Color3Value = ', value)
      assert(Color3Object.Color3Value.Value.R == value.R)
      assert(Color3Object.Color3Value.Value.G == value.G)
      assert(Color3Object.Color3Value.Value.B == value.B)
   end)

   --- Vector3
   local vector3Value = Instance.new('Vector3Value')
   local Vector3Object = {
      Vector3 = Vector3.new(10, 11, 12),
      Vector3Slider = Vector3.new(10, 11, 12),
      Vector3Value = vector3Value
   }

   local guiOthersVector3  = gui.addFolder('Vector3')

   guiOthersVector3.add(Vector3Object, 'Vector3').step(1).listen().onChange(function(value)
      print('Vector3 = ', value)
      assert(Vector3Object.Vector3:FuzzyEq(value))
   end)

   local vec3Controller = guiOthersVector3.add(Vector3Object, 'Vector3Slider', 0, 100).listen().onChange(function(value)
      print('Vector3Slider = ', value)
      assert(Vector3Object.Vector3Slider:FuzzyEq(value))
   end)

   guiOthersVector3.add(Vector3Object, 'Vector3Value', 0, 100).listen().onChange(function(value)
      print('Vector3Value = ', value)
      assert(Vector3Object.Vector3Value.Value:FuzzyEq(value))
   end)

   -- Function, remove and name
   local guiOthersFunctions  = gui.addFolder('Functions')

   local countClick = 0
   local toggleNameController

   local testFolder
   local testControllers = {}

   local FunctionsObject = {
      ToggleName = function()
         countClick = countClick+1
         toggleNameController.name('Called ('..countClick..') times')
      end,
      AddFolder = function()
         if testFolder == nil then
            testFolder = guiOthersFunctions.addFolder('Test Folder')
         end
      end,
      AddController = function()
         if testFolder ~= nil then
            table.insert(testControllers, testFolder.add({ Value = 0.5}, 'Value', 0, 1, 0.001))
         end
      end,
      RemoveController = function()
         if testFolder ~= nil then
            local pos = table.getn(testControllers)
            if pos > 0 then 
               testControllers[pos].remove()
               table.remove(testControllers, pos)
            end
         end
      end,
      RemoveControllerByParent = function()
         if testFolder ~= nil then
            local pos = table.getn(testControllers)
            if pos > 0 then 
               testFolder.removeChild(testControllers[pos])
               table.remove(testControllers, pos)
            end
         end
      end,
      RemoveFolder = function()
         if testFolder ~= nil then
            testFolder.remove()
            testFolder = nil
         end
      end,
      RemoveFolderByParent = function()
         if testFolder ~= nil then
            guiOthersFunctions.removeChild(testFolder)
            testFolder = nil
         end
      end
   }

   toggleNameController = guiOthersFunctions.add(FunctionsObject, 'ToggleName')
   guiOthersFunctions.add(FunctionsObject, 'AddFolder')
   guiOthersFunctions.add(FunctionsObject, 'AddController')
   guiOthersFunctions.add(FunctionsObject, 'RemoveController')
   guiOthersFunctions.add(FunctionsObject, 'RemoveControllerByParent')
   guiOthersFunctions.add(FunctionsObject, 'RemoveFolder')
   guiOthersFunctions.add(FunctionsObject, 'RemoveFolderByParent')
end

guiOthers.add({Open=OpenOtherPanel},'Open')




