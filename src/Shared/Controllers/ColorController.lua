local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")

-- lib
local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local Misc              = require(Lib:WaitForChild("Misc"))
local Popover           = require(Lib:WaitForChild("Popover"))
local GUIUtils          = require(Lib:WaitForChild("GUI"))
local GuiEvents         = require(Lib:WaitForChild("GuiEvents"))
local Constants         = require(Lib:WaitForChild("Constants"))

local WHITE = Color3.fromRGB(255, 255, 255)

local function CreateGUI()

   local Controller, Control, DisconnectParent = GUIUtils.CreateControllerWrapper({
      Name                 = 'ColorController',
      Color                = Constants.BACKGROUND_COLOR
   })

   local BorderLeft = Controller:WaitForChild('BorderLeft')

   local Value = Instance.new('Color3Value')
   Value.Name     = 'Value'
   Value.Value    = Color3.fromRGB(0, 0, 0)
   Value.Parent   = Controller

   local Hue = Instance.new('IntValue')
   Hue.Name     = 'Hue'
   Hue.Value    = 0
   Hue.Parent   = Controller

   local Luminance = Instance.new('IntValue')
   Luminance.Name     = 'Luminance'
   Luminance.Value    = 0
   Luminance.Parent   = Controller

   local Saturation = Instance.new('IntValue')
   Saturation.Name     = 'Saturation'
   Saturation.Value    = 0
   Saturation.Parent   = Controller

   local IsTextActive = Instance.new('BoolValue')

   local function RenderText(value)
      if string.len(value) == 0 then
         return '#000000'
      else
         local color = Misc.Color3FromString(value)
         if color == nil then
            -- invalid color
            return '#000000'
         else
            -- valid color
            return string.format("#%.2X%.2X%.2X", color.R * 255, color.G * 255, color.B * 255)
         end
      end
   end

   local TextValue, TextFrame, OnFocused, OnFocusLost, DisconnectText =  GUIUtils.CreateInput({
      Color          = Constants.NUMBER_COLOR,
      Active         = IsTextActive,
      -- Render         = RenderText,
      ChangeColors   = false,
      -- Parse          = function (text, value)
      --    if string.len(text) == 0 then
      --       return '#000000'
      --    else
      --       local color = Misc.Color3FromString(text)
      --       if color == nil then
      --          -- invalid color
      --          return '#000000'
      --       else
      --          -- valid color
      --          return string.format("#%.2X%.2X%.2X", color.R * 255, color.G * 255, color.B * 255)
      --       end
      --    end
      -- end,
   })

   TextFrame.Position 			         = UDim2.new(0, 0, 0, 4)
   TextFrame.Size 			            = UDim2.new(1, -2, 1, -8)
   TextFrame.Parent = Control

   local TextFake = TextFrame:WaitForChild('TextBoxFake')
   TextFake.Position 			      = UDim2.new(0, 0, 0, 0)
   TextFake.Size 			            = UDim2.new(1, 0, 1, 0)
   TextFake.TextXAlignment          = Enum.TextXAlignment.Center

   local Text = TextFrame:WaitForChild('TextBox')
   Text.Position 			         = UDim2.new(0, 0, 0, 0)
   Text.Size 			            = UDim2.new(1, 0, 1, 0)
   Text.TextXAlignment           = Enum.TextXAlignment.Center

   local Selector = GUIUtils.CreateFrame()
   Selector.Name 			            = "Selector"
   Selector.BackgroundColor3        = Constants.BACKGROUND_COLOR_HOVER
   Selector.BorderColor3            = Constants.BACKGROUND_COLOR_HOVER
   Selector.BorderSizePixel 			= 3
   Selector.Position 			      = UDim2.new(0, 0, 0, 0)
   Selector.Size 			            = UDim2.new(0, 122, 0, 102)

   local HueSelector = GUIUtils.CreateFrame()
   HueSelector.Name 			            = "Hue"
   HueSelector.BorderColor3            = Constants.BORDER_COLOR_2
   HueSelector.BorderSizePixel 			= 1
   HueSelector.Position 			      = UDim2.new(1, -16, 0, 1)
   HueSelector.Size 			            = UDim2.new(0, 15, 0, 100)
   HueSelector.Parent = Selector

   local HueSaturationContainer = GUIUtils.CreateFrame()
   HueSaturationContainer.Name 			      = "SaturationContainer"
   HueSaturationContainer.BackgroundColor3   = WHITE
   HueSaturationContainer.Parent = HueSelector

   local HueSelectorSaturation = Instance.new('UIGradient')
   HueSelectorSaturation.Name          = 'Saturation'
   HueSelectorSaturation.Enabled       = true
   HueSelectorSaturation.Rotation      = 90
   HueSelectorSaturation.Transparency  = NumberSequence.new({
      NumberSequenceKeypoint.new(0, 0),
      NumberSequenceKeypoint.new(1, 0)
   })
   HueSelectorSaturation.Color         = ColorSequence.new({
      ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
      ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
      ColorSequenceKeypoint.new(0.34, Color3.fromRGB(0, 0, 255)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
      ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
      ColorSequenceKeypoint.new(0.84, Color3.fromRGB(255, 255, 0)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
   })  
   HueSelectorSaturation.Parent   = HueSaturationContainer

   local HueKnob = GUIUtils.CreateFrame()
   HueKnob.Name 			            = "Knob"
   HueKnob.BackgroundColor3         = WHITE
   HueKnob.BorderColor3             = Constants.BORDER_COLOR_2
   HueKnob.BorderSizePixel 			= 1
   HueKnob.Position 			         = UDim2.new(1, -2, 0.1, 0)
   HueKnob.Size 			            = UDim2.new(0, 4, 0, 2)
   HueKnob.ZIndex                   = 2
   HueKnob.Parent = HueSelector

   local SatLumSelector = GUIUtils.CreateFrame()
   SatLumSelector.Name 			            = "SatLum"
   SatLumSelector.BackgroundColor3        = WHITE
   SatLumSelector.BorderColor3            = Constants.BORDER_COLOR_2
   SatLumSelector.BorderSizePixel 			= 1
   SatLumSelector.Position 			      = UDim2.new(0, 1, 0, 1)
   SatLumSelector.Size 			            = UDim2.new(0, 100, 0, 100)
   SatLumSelector.ZIndex                  = 2
   SatLumSelector.Parent = Selector

   local Brightness = GUIUtils.CreateImageLabel('rbxassetid://5787992121')
   Brightness.Name 			            = "Brightness"
   Brightness.BackgroundColor3         = WHITE
   Brightness.BorderColor3             = Color3.fromRGB(27, 42, 53)
   Brightness.BorderMode 			      = Enum.BorderMode.Outline
   Brightness.BorderSizePixel 			= 1
   Brightness.Position 			         = UDim2.new(0, 0, 0, 0)
   Brightness.Size 			            = UDim2.new(0, 100, 0, 100)
   Brightness.ImageColor3              = WHITE
   Brightness.Parent = SatLumSelector

   local SaturationImage = GUIUtils.CreateImageLabel('rbxassetid://5787998939')
   SaturationImage.Name 			         = "Saturation"
   SaturationImage.BackgroundColor3       = WHITE
   SaturationImage.BorderColor3           = Color3.fromRGB(27, 42, 53)
   SaturationImage.BorderMode 			   = Enum.BorderMode.Outline
   SaturationImage.BorderSizePixel 			= 1
   SaturationImage.Position 			      = UDim2.new(0, 0, 0, 0)
   SaturationImage.Rotation 			      = -90
   SaturationImage.Size 			         = UDim2.new(0, 100, 0, 100)
   SaturationImage.ZIndex                 = 1
   SaturationImage.ImageColor3            = Color3.fromRGB(255, 0, 0)
   SaturationImage.Parent = SatLumSelector

   local SatLumKnob = GUIUtils.CreateFrame()
   SatLumKnob.Name 			            = "Knob"
   SatLumKnob.BackgroundColor3         = Color3.fromRGB(255, 3, 7)
   SatLumKnob.BorderColor3             = WHITE
   SatLumKnob.BorderSizePixel 			= 2
   SatLumKnob.Position 			         = UDim2.new(0.4, 0, 0.1, 0)
   SatLumKnob.Rotation                 = 45
   SatLumKnob.Size 			            = UDim2.new(0, 10, 0, 10)
   SatLumKnob.ZIndex                   = 3
   SatLumKnob.Parent = SatLumSelector

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections       = {}
   local controlHover 	   = false
   local selectorHover 	   = false
   local hueHover 			= false
   local hueMouseDown 		= false
   local satLumHover 		= false
   local satLumMouseDown   = false
   local textFocused 		= false

   IsTextActive.Value         = false

   local ignoreUpdateColorValue = false

   -- Updates the color after modifying parameters
   local function updateColorValue()
      if ignoreUpdateColorValue then 
         return
      end
      
      local hue, sat, lum = Value.Value:ToHSV()	
      
      local changed = false
      
      if math.floor(239*hue+0.5) ~= Hue.Value then
         hue = Hue.Value/239
         changed = true
      end
      
      if math.floor(240*sat+0.5) ~= Saturation.Value  then
         sat = Saturation.Value/240
         changed = true
      end
      
      if  math.floor(240*lum+0.5) ~= Luminance.Value  then
         lum = Luminance.Value/240
         changed = true
      end
      
      if changed then
         Value.Value = Color3.fromHSV(hue, sat, lum)
      end
   end

   -- Updates the selector from the current color
   local function updateSelector()
      local hue, sat, lum  = Value.Value:ToHSV()	
      
      ignoreUpdateColorValue = true

      Hue.Value 			= math.floor(239 * hue + 0.5)	
      Saturation.Value	= math.floor(240 * sat + 0.5)
      Luminance.Value   = math.floor(240 * lum + 0.5)

      ignoreUpdateColorValue = false
      
      SatLumKnob.Position 			   = UDim2.new(sat, -5, 1-lum , -5)
      SatLumKnob.BorderColor3 		= Misc.BestContrast(Value.Value)	
      SatLumKnob.BackgroundColor3 	= Value.Value	
   end

   local popover = Popover.new(TextFrame, Vector2.new(122, 102), 'bottom', -4)
   Selector.Parent = popover.Frame

   -- Checks the selector's visibility
   local function checkVisibility()
      if textFocused then
         popover:Hide()
      elseif controlHover or selectorHover or hueHover or satLumHover or hueMouseDown or satLumMouseDown then
         popover:Show()
      else
         popover:Hide()
      end
   end

   local function parseHueMouse(input)
      local posY 		= input.Position.Y
      local absSizeY = HueSelector.AbsoluteSize.Y		
      local absPosY 	= HueSelector.AbsolutePosition.Y
      
      local percent = (posY - absPosY)/absSizeY
      
      if percent < 0 then
         percent = 0
      elseif percent > 1 then
         percent = 1
      end
      
      -- 0 to 239	
      Hue.Value =  math.floor(239 *(1-percent) + 0.5)
   end

   local function parseSatLumMouse(input)
      -- Saturation
      local posX 		= input.Position.X
      local absPosX 	= SatLumSelector.AbsolutePosition.X
      local absSizeX = SatLumSelector.AbsoluteSize.X
      local percentX	= (posX - absPosX)/absSizeX
      
      if percentX < 0 then
         percentX = 0
      elseif percentX > 1 then
         percentX = 1
      end
      
      Saturation.Value = math.floor(240 * percentX + 0.5)
      
      -- Luminance
      local posY 		= input.Position.Y		
      local absPosY 	= SatLumSelector.AbsolutePosition.Y	
      local absSizeY = SatLumSelector.AbsoluteSize.Y		
      local percentY	= (posY - absPosY)/absSizeY
      
      if percentY < 0 then
         percentY = 0
      elseif percentY > 1 then
         percentY = 1
      end
      
      Luminance.Value = math.floor(240 * (1-percentY) + 0.5)
   end

   local function updateTextColor()
      local color = Value.Value

      Text.TextColor3               = Misc.BestContrast(color)
      TextFake.TextColor3           = Text.TextColor3
      BorderLeft.BackgroundColor3   = color
      TextFrame.BackgroundColor3    = color
   end

   table.insert(connections, Value.Changed:Connect(function()
      
      spawn(function()
         local color = Value.Value
         TextValue.Value = string.format("#%.2X%.2X%.2X", color.R * 255, color.G * 255, color.B * 255)
      end)
      
      updateTextColor()
      updateSelector()
   end))

   table.insert(connections, TextValue.Changed:Connect(function()
      local color = Misc.Color3FromString(TextValue.Value)
      if color == nil then
         color = Color3.fromRGB(0, 0, 0)
      end

      Value.Value = color
   end))

   table.insert(connections, OnFocused:Connect(function()
      textFocused 		= true
      checkVisibility()	
   end))
   
   table.insert(connections, OnFocusLost:Connect(function()
      textFocused 		= false
      updateTextColor()
      checkVisibility()	
   end))

   table.insert(connections, Hue.Changed:Connect(function()
      local hue = Hue.Value
      if hue == 0 then
         hue = 1
      end
      
      HueKnob.Position              = UDim2.new(1, -2, 1-hue/239, -1)	
      SaturationImage.ImageColor3   = Color3.fromHSV(Hue.Value/239, 1, 1)
      
      updateColorValue()
   end))

   table.insert(connections, Saturation.Changed:Connect(function()
      updateColorValue()
   end))

   table.insert(connections, Luminance.Changed:Connect(function()
      updateColorValue()
   end))

   table.insert(connections, GuiEvents.OnHover(TextFrame, function(hover)
      controlHover = hover
      checkVisibility()
   end))

   table.insert(connections, GuiEvents.OnHover(popover.Frame, function(hover)
      selectorHover = hover
      checkVisibility()
   end))

   table.insert(connections, GuiEvents.OnHover(SatLumSelector, function(hover)
      satLumHover = hover
      if hover then 
         selectorHover = true
      end
      checkVisibility()
   end))

   table.insert(connections, GuiEvents.OnHover(HueSelector, function(hover)
      hueHover = hover
      if hover then 
         selectorHover = true
      end
      checkVisibility()
   end))

   table.insert(connections, GuiEvents.OnDrag(SatLumSelector, function(event, startPos, position, delta)
      if event == 'start' then
         satLumMouseDown = true
         checkVisibility()

      elseif event == 'end' then
         satLumMouseDown = false
         checkVisibility()

      elseif event == 'drag' then
         parseSatLumMouse({
            Position = position
         })
      end
   end))

   table.insert(connections, GuiEvents.OnDrag(HueSelector, function(event, startPos, position, delta)
      if event == 'start' then
         hueMouseDown = true
         checkVisibility()

      elseif event == 'end' then
         hueMouseDown = false
         checkVisibility()

      elseif event == 'drag' then
         parseHueMouse({
            Position = position
         })
      end
   end))
   

   return Controller, Misc.DisconnectFn(connections, DisconnectParent, DisconnectText, function()
      popover:Destroy()
   end)
end

-- Provides a text input to alter the string property of an object.
local function ColorController(gui, object, property, isColor3Value)
	
	local frame, DisconnectGUI = CreateGUI()
	frame.Parent = gui.Content
	
	local colorValue 	= frame:WaitForChild("Value")
	local labelValue 	= frame:WaitForChild("Label")
	
	-- The function to be called on change.
	local onChange
	local listenConnection
	
	local controller = {
		frame = frame,
		label = frame:WaitForChild("LabelText"),
		height = frame.AbsoluteSize.Y
	}
	
	------------------------------------------------------------------
	-- Configure events
	------------------------------------------------------------------
	colorValue.Changed:Connect(function()		
		if not controller._isReadonly then
         if isColor3Value then
            object[property].Value = colorValue.Value
         else 
            object[property] = colorValue.Value
         end
		end		
		
		if onChange ~= nil then
			onChange(controller.getValue())
		end
	end)
	
	
	------------------------------------------------------------------
	-- Public functions
	------------------------------------------------------------------
	
	function controller.onChange(fnc)
		onChange = fnc;
		return controller;
	end	
	
	function controller.setValue(value)
		colorValue.Value = value		
		return controller;
	end
	
	function controller.getValue()
      if isColor3Value then
         return object[property].Value
      else 
         return object[property]
      end
	end
	
	-- Removes the controller from its parent GUI.
	function controller.remove()
      if controller._is_removing_parent then
         return
      end

      DisconnectGUI()
		
		if listenConnection ~= nil then
			listenConnection:Disconnect()
		end
		
      -- avoid recursion
      controller._is_removing_parent = true
      
		gui.removeChild(controller)
		
		if controller.frame ~= nil then
			controller.frame.Parent = nil
			controller.frame = nil
		end		
	end
	
	-- Sets controller to listen for changes on its underlying object.
	function controller.listen()
		if listenConnection ~= nil then
			return
		end

      if isColor3Value then 
         listenConnection = object[property].Changed:Connect(function(value)
				controller.setValue(object[property].Value)
			end)
		
		elseif object['IsA'] ~= nil then
			-- roblox Interface
			listenConnection = object:GetPropertyChangedSignal(property):Connect(function(value)
				controller.setValue(object[property])
			end)
			
		else
			-- tables (dirty checking before render)
			local oldValue = object[property]
			listenConnection = RunService.Heartbeat:Connect(function()
				if object[property] ~= oldValue then
					oldValue = object[property]
					controller.setValue(object[property])
				end
			end)
		end
		
		return controller
	end
	
	-- Sets the name of the controller.
	function controller.name(name)
		labelValue.Value = name
		return controller
	end
	
	------------------------------------------------------------------
	-- Set initial values
	------------------------------------------------------------------
	labelValue.Value = property	
	
   controller.setValue(controller.getValue())
	
	return controller
end

return ColorController
