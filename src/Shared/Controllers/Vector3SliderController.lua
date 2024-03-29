local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")

-- lib
local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local Misc              = require(Lib:WaitForChild("Misc"))
local GUIUtils          = require(Lib:WaitForChild("GUIUtils"))
local Constants         = require(Lib:WaitForChild("Constants"))

local function CreateGUI()

   local Controller, Control, DisconnectParent = GUIUtils.createControllerWrapper({
      ['Name']    = 'Vector3SliderController',
      ['Color']   = Constants.NUMBER_COLOR,
      ['Height']  = 90
   })

   local Readonly = Controller:WaitForChild('Readonly')
  
   local Value = Instance.new('Vector3Value')
   Value.Name     = 'Value'
   Value.Value    = Vector3.new(0, 0, 0)
   Value.Parent   = Controller

   local ValueIn = Instance.new('Vector3Value')
   ValueIn.Name     = 'ValueIn'
   ValueIn.Value    = Vector3.new(0, 0, 0)
   ValueIn.Parent   = Controller

   local Min = Instance.new('Vector3Value')
   Min.Name    = 'Min'
   Min.Value   = Vector3.new(-math.huge, -math.huge, -math.huge)
   Min.Parent  = Controller

   local Max = Instance.new('Vector3Value')
   Max.Name    = 'Max'
   Max.Value   = Vector3.new(math.huge, math.huge, math.huge)
   Max.Parent  = Controller

   local Step = Instance.new('Vector3Value')
   Step.Name    = 'Step'
   Step.Value   = Vector3.new(Misc.NUMBER_STEP, Misc.NUMBER_STEP, Misc.NUMBER_STEP)
   Step.Parent  = Controller

   local Precision = Instance.new('Vector3Value')
   Precision.Name    = 'Precision'
   Precision.Value   =  Vector3.new(Misc.NUMBER_PRECISION, Misc.NUMBER_PRECISION, Misc.NUMBER_PRECISION)
   Precision.Parent  = Controller

   -- create X, Y, Z
   local function CreateAxisController(axis, position)
      local connections = {}

      local Frame = GUIUtils.createFrame()
      Frame.Name 			            = axis
      Frame.BackgroundTransparency  = 1
      Frame.Position 			      = position
      Frame.Size 			            = UDim2.new(1, 0, 0.333, -1)
      Frame.Parent = Control

      local Label = GUIUtils.createTextLabel()
      Label.Size 			            = UDim2.new(0, 10, 1, 0)
      Label.Text                    = axis:lower()
      Label.TextColor3 			      = Constants.INPUT_COLOR_PLACEHOLDER
      Label.TextXAlignment          = Enum.TextXAlignment.Center
      Label.Parent = Frame

      local TextContainer = GUIUtils.createFrame()
      TextContainer.Name 			            = 'TextContainer'
      TextContainer.BackgroundTransparency   = 1
      TextContainer.Position 			         = UDim2.new(0.66, 3, 0, 3)
      TextContainer.Size 			            = UDim2.new(0.33, -2, 1, -6)
      TextContainer.Parent = Frame

      local AxisPrecision = Instance.new('IntValue')
      AxisPrecision.Name    = 'Precision'
      AxisPrecision.Value   = Misc.NUMBER_PRECISION

      local  RenderText = Misc.createTextNumberFn(AxisPrecision)
      
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
      SliderContainer.Name                   = 'slider-container'
      SliderContainer.BackgroundTransparency = 1
      SliderContainer.Position 			      = UDim2.new(0, 12, 0, 3)
      SliderContainer.Size 			         = UDim2.new(0.66, -12, 1, -6)
      SliderContainer.Parent = Frame
   
      local SliderFrame, SliderValue, Min, Max, Percent, SliderOnFocus, SliderOnFocusLost, SliderDisconnect = GUIUtils.createSlider({
         ['Readonly'] = Readonly
      })
      SliderFrame.Parent = SliderContainer

      -- SCRIPTS -------------------------------------------------------------------------------------------------------

      local textFocus = false

      table.insert(connections, TextOnFocus:Connect(function()
         textFocus = true
      end))
      
      table.insert(connections, TextOnFocusLost:Connect(function()
         textFocus = false
      end))

      table.insert(connections, Precision.Changed:Connect(function()
         AxisPrecision.Value = Precision.Value[axis]
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

      return TextValue, SliderValue, Min, Max, RenderText, Misc.disconnectFn(connections, TextDisconnect, SliderDisconnect) 
   end

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections = {}
   local Axes        = {}

   for i, axis in ipairs(Misc.AXES) do
      local pos = (i-1)*0.333
      local TextValue, SliderValue, SliderMin, SliderMax,  RenderText, DisconnectText =  CreateAxisController(axis, UDim2.new(0, 0, pos, 0))
      Axes[axis] = {
         ['TextValue']   = TextValue,
         ['SliderValue'] = SliderValue,
         ['SliderMin']   = SliderMin, 
         ['SliderMax']   = SliderMax,
         ['RenderText']  = RenderText,
         ['Disconnect']  = DisconnectText
      }

      table.insert(connections, SliderValue.Changed:connect(function()
         local value = Value.Value
         local values = {
            X = value.X, 
            Y = value.Y, 
            Z = value.Z, 
         }

         values[axis] = tonumber(SliderValue.Value)

         Value.Value = Vector3.new(values.X, values.Y, values.Z)
      end))
   end

   -- On change steps
   table.insert(connections, Step.Changed:connect(function()	
      Precision.Value = Vector3.new(
         Misc.countDecimals(Step.Value.X), 
         Misc.countDecimals(Step.Value.Y), 
         Misc.countDecimals(Step.Value.Z)
      )
      for _, axis in ipairs(Misc.AXES) do
         local TextValue = Axes[axis].TextValue
         local val = TextValue.Value
         if val == nil then
            val = ''
         end
         TextValue.Value = '0'..val
      end
   end))

   table.insert(connections, Min.Changed:connect(function()	
      for _, axis in ipairs(Misc.AXES) do
         Axes[axis].SliderMin.Value = Min.Value[axis]
      end
   end))

   table.insert(connections, Max.Changed:connect(function()	
      for _, axis in ipairs(Misc.AXES) do
         Axes[axis].SliderMax.Value = Max.Value[axis]
      end
   end))

   -- On change value from outside
   table.insert(connections, ValueIn.Changed:connect(function()
      for _, axis in ipairs(Misc.AXES) do
         local value = math.clamp(ValueIn.Value[axis], Min.Value[axis], Max.Value[axis])
      
         local step = Step.Value[axis]
         if value % step ~= 0 then
            value = math.round(value/step) * step
         end

         Axes[axis].SliderValue.Value = value
      end
   end))

   return Controller, Value, ValueIn, Min, Max, Step, Misc.disconnectFn(
      connections, 
      DisconnectParent, 
      Axes.X.Disconnect, 
      Axes.Y.Disconnect,
      Axes.Z.Disconnect
   )
end

-- Number slider controller
local function Vector3SliderController(gui, object, property, min, max, step, isVector3Value)
	
	local frame, valueValue, valueInValue, minValue, maxValue, stepValue,  DisconnectGUI = CreateGUI()
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
         if isVector3Value then
            object[property].Value = valueValue.Value;
         else
            object[property] = valueValue.Value;
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
		if typeof(value) == "number" then
			value = Vector3.new(value, value, value)
		end
		valueInValue.Value = value
		
		return controller;
	end
	
	function controller.getValue()
      if isVector3Value then
         return object[property].Value
      else 
         return object[property]
      end
	end
	
	function controller.min(min)
		if typeof(min) == "number" then
			min = Vector3.new(min, min, min)
		end
		minValue.Value = min
		return controller
	end
	
	function controller.max(max)
		if typeof(max) == "number" then
			max = Vector3.new(max, max, max)
		end
		maxValue.Value = max
		return controller
	end
	
	function controller.step(step)
		if typeof(step) == "number" then
			step = Vector3.new(step, step, step)
		end
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

      if isVector3Value then
         listenConnection = object[property].Changed:Connect(function(value)
				controller.setValue(object[property].Value)
			end)

      else 
         -- tables (dirty checking before render, Instance.Changed or Instance.GetPropertyChangedSignal dont work for position, CFrame, etc)
         local oldValueX = object[property].X
         local oldValueY = object[property].Y
         local oldValueZ = object[property].Z
         listenConnection = RunService.Heartbeat:Connect(function(step)
            local value = object[property]
            if value.X ~= oldValueX or value.Y ~= oldValueY or value.Z ~= oldValueZ then
               oldValueX = value.X
               oldValueY = value.Y
               oldValueZ = value.Z
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
		if typeof(min) == "number" then
			min = Vector3.new(min, min, min)
		end
		minValue.Value = min
	end
	
	if max ~= nil then
		if typeof(max) == "number" then
			max = Vector3.new(max, max, max)
		end
		maxValue.Value = max
	end
	
	if step ~= nil then
		if typeof(step) == "number" then
			step = Vector3.new(step, step, step)
		end
		stepValue.Value = step
	end
	
	return controller
end

return Vector3SliderController
