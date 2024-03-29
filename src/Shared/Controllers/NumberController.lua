local RunService  = game:GetService("RunService")

-- lib
local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local Misc        = require(Lib:WaitForChild("Misc"))
local GUIUtils    = require(Lib:WaitForChild("GUIUtils"))
local Constants   = require(Lib:WaitForChild("Constants"))

local function CreateGUI()

   local Controller, Control, DisconnectParent = GUIUtils.createControllerWrapper({
      ['Name']                 = 'NumberController',
      ['Color']                = Constants.NUMBER_COLOR
   })

   local Readonly    = Controller:WaitForChild('Readonly')

   local ValueIn = Instance.new('NumberValue')
   ValueIn.Name     = 'ValueIn'
   
   local Min = Instance.new('NumberValue')
   Min.Name    = 'Min'
   Min.Value   = -math.huge
   
   local Max = Instance.new('NumberValue')
   Max.Name    = 'Max'
   Max.Value   = math.huge
   
   local Step = Instance.new('NumberValue')
   Step.Name    = 'Step'
   Step.Value   = Misc.NUMBER_STEP
   
   local Precision = Instance.new('IntValue')
   Precision.Name    = 'Precision'
   Precision.Value   = Misc.NUMBER_PRECISION

   ValueIn.Parent       = Controller
   Min.Parent           = Controller
   Max.Parent           = Controller
   Step.Parent          = Controller
   Precision.Parent     = Controller

   local RenderText = Misc.createTextNumberFn(Precision)

   local Value, TextFrame, OnFocused, OnFocusLost, DisconnectText =  GUIUtils.createInput({
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

   local TextContainer = GUIUtils.createFrame()
   TextContainer.Name 			            = 'TextContainer'
   TextContainer.BackgroundTransparency   = 1
   TextContainer.Position 			         = UDim2.new(0, 0, 0, 3)
   TextContainer.Size 			            = UDim2.new(1, 0, 1, -6)
   TextContainer.Parent = Control
   TextFrame.Parent     = TextContainer

   Value.Parent         = Controller

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections       = {}

   -- On change steps
   table.insert(connections, Step.Changed:connect(function()	
      Precision.Value = Misc.countDecimals(Step.Value)
      if Value.Value ~= nil then
         Value.Value = '0'..Value.Value
      end
   end))

   -- On change value from outside
   table.insert(connections, ValueIn.Changed:connect(function()
      local value = math.clamp(ValueIn.Value, Min.Value, Max.Value)
      
      local step = Step.Value
      if value % step ~= 0 then
         value = math.round(value/step) * step
      end
      
      Value.Value = RenderText(tostring(value))
   end))
   
   return Controller, Misc.disconnectFn(connections, DisconnectParent, DisconnectText)
end

-- Represents a given property of an object that is a number.
local function NumberController(gui, object, property, min, max, step, isNumberValue)
	
	local frame, DisconnectGUI = CreateGUI()
	frame.Parent = gui.Content
	
	local minValue 		= frame:WaitForChild("Min")
	local maxValue 		= frame:WaitForChild("Max")
	local stepValue 	   = frame:WaitForChild("Step")
	local stringValue 	= frame:WaitForChild("Value")		   -- Safe value
	local valueInValue   = frame:WaitForChild("ValueIn")		-- Input value, unsafe
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
	stringValue.Changed:connect(function()		
		if not readonly.Value then
         if isNumberValue then
            object[property].Value = tonumber(stringValue.Value)
         else
            object[property] = tonumber(stringValue.Value)
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
					controller.setValue(oldValue)
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

return NumberController
