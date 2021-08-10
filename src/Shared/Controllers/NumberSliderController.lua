local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")

-- lib
local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local Misc              = require(Lib:WaitForChild("Misc"))
local GUIUtils          = require(Lib:WaitForChild("GUIUtils"))
local Constants         = require(Lib:WaitForChild("Constants"))

local function CreateGUI()

   local Controller, Control, ControllerDisconnect = GUIUtils.createControllerWrapper({
      ['Name']                 = 'NumberSliderController',
      ['Color']                = Constants.NUMBER_COLOR
   })

   local Readonly    = Controller:WaitForChild('Readonly')

   local ValueIn = Instance.new('NumberValue')
   ValueIn.Name     = 'ValueIn'
   ValueIn.Parent   = Controller

   local Step = Instance.new('NumberValue')
   Step.Name    = 'Step'
   Step.Value   = Misc.NUMBER_STEP
   Step.Parent  = Controller

   local Precision = Instance.new('IntValue')
   Precision.Name    = 'Precision'
   Precision.Value   = Misc.NUMBER_PRECISION
   Precision.Parent  = Controller

   local RenderText = Misc.createTextNumberFn(Precision)

   local TextContainer = GUIUtils.createFrame()
   TextContainer.Name 			            = 'TextContainer'
   TextContainer.BackgroundTransparency   = 1
   TextContainer.Position 			         = UDim2.new(0.66, 3, 0, 3)
   TextContainer.Size 			            = UDim2.new(0.33, -2, 1, -6)
   TextContainer.Parent = Control

   local IsControllerActive = Instance.new('BoolValue')

   local TextValue, TextFrame, TextOnFocus, TextOnFocusLost, TextDisconnect =  GUIUtils.createInput({
      ['Color']      = Constants.NUMBER_COLOR,
      ['Render']     = RenderText,
      ['Readonly']   = Readonly,
      ['Parse']      = function (text, value)
         if string.len(text) == 0 then
            -- no changes
            return '0'
         else
            local text = tonumber(text)
            if text == nil then
               -- invalid number
               return value.Value
            else
               -- valid number
               return RenderText(text)
            end
         end
      end,
   })
   TextFrame.Parent = TextContainer

   local SliderContainer = GUIUtils.createFrame()
   SliderContainer.BackgroundTransparency = 1
   SliderContainer.Position 			      = UDim2.new(0, 0, 0, 3)
   SliderContainer.Size 			         = UDim2.new(0.66, 0, 1, -6)
   SliderContainer.Parent = Control

   local SliderFrame, SliderValue, Min, Max, Percent, SliderOnFocus, SliderOnFocusLost, SliderDisconnect = GUIUtils.createSlider({
      ['Readonly'] = Readonly
   })
   SliderFrame.Parent = SliderContainer

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections = {}
   local textFocus   = false

   table.insert(connections, TextOnFocus:Connect(function()
      textFocus = true
   end))
   
   table.insert(connections, TextOnFocusLost:Connect(function()
      textFocus = false
   end))
   
   -- On change steps
   table.insert(connections, Step.Changed:connect(function()
      Precision.Value = Misc.countDecimals(Step.Value);
      if TextValue.Value ~= nil then
         TextValue.Value = '0'..TextValue.Value
      end
   end))

    -- On change value (safe)
   table.insert(connections, SliderValue.Changed:connect(function()
      TextValue.Value = tostring(SliderValue.Value)
   end))

   table.insert(connections, TextValue.Changed:connect(function()
      if textFocus then
         SliderValue.Value = tonumber(TextValue.Value)
      end
   end))

   -- On change value from outside
   table.insert(connections, ValueIn.Changed:connect(function()
      local value = math.clamp(ValueIn.Value,  Min.Value, Max.Value)
      
      if value % Step.Value ~= 0 then
         value = math.round(value/Step.Value) * Step.Value
      end

      SliderValue.Value = value
      -- if ValueIn.Value ~= value then
      --    ValueIn.Value = value
      -- else
      --    -- change slider value
      --    SliderValue.Value = value
      --    spawn(function()
      --       TextValue.Value = tostring(SliderValue.Value)
      --    end)
      -- end      
   end))

   return Controller, SliderValue, ValueIn, Min, Max, Step, 
      Misc.disconnectFn(connections, ControllerDisconnect, TextDisconnect, SliderDisconnect)
end

-- Number slider controller
local function NumberSliderController(gui, object, property, min, max, step, isNumberValue)
	
	local frame, valueValue, valueInValue, minValue, maxValue, stepValue, DisconnectGUI = CreateGUI()
	frame.Parent = gui.Content

   local readonly       = frame:WaitForChild("Readonly")
	
	-- The function to be called on change.
	local onChange
	local listenConnection
	
	local controller = {
		frame = frame,
		height = frame.AbsoluteSize.Y
	}
	
	------------------------------------------------------------------
	-- Configure events
	------------------------------------------------------------------
	valueValue.Changed:connect(function()	
		if not readonly.Value then
         if isNumberValue then
            object[property].Value = valueValue.Value
         else
            object[property] = valueValue.Value
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
		valueInValue.Value = value
		
		return controller;
	end
	
	function controller.getValue()
      if isNumberValue then
         return object[property].Value
      else
         return object[property]
      end
	end
	
	function controller.min(min)
		minValue.Value = min
		return controller
	end
	
	function controller.max(max)
		maxValue.Value = max
		return controller
	end
	
	function controller.step(step)
		stepValue.Value = step
		return controller
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
		
		if isNumberValue then
         listenConnection = object[property].Changed:Connect(function(value)
				controller.setValue(object[property].Value)
			end)

		elseif  object['IsA'] ~= nil then
			-- roblox Interface
			listenConnection = object:GetPropertyChangedSignal(property):Connect(function(value)
				controller.setValue(object[property])
			end)
			
		else
			-- tables (dirty checking before render)
			local oldValue = object[property]
			listenConnection = RunService.Heartbeat:Connect(function(step)
				if object[property] ~= oldValue then
					oldValue = object[property]
					controller.setValue(object[property])
				end
			end)
		end
		
		return controller
	end	
	
	------------------------------------------------------------------
	-- Set initial values
	------------------------------------------------------------------

   controller.setValue(controller.getValue())

	if min ~= nil then
		minValue.Value = min
	end

	if max ~= nil then
		maxValue.Value = max
	end
	
	if step ~= nil then
		stepValue.Value = step
	end

	return controller
end

return NumberSliderController
