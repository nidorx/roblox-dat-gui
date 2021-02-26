local RunService  = game:GetService("RunService")
local Misc        = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Misc"))
local GUIUtils    = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("GUI"))
local Constants   = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Constants"))



local function CreateGUI()

   local UnlockOnMouseLeave = Instance.new('BoolValue')
   UnlockOnMouseLeave.Value = true

   local Controller, Control, OnLock, OnUnLock, OnMouseEnter, OnMouseMoved, OnMouseLeave, DisconnectParent 
      = GUIUtils.CreateControllerWrapper({
         Name                 = 'NumberController',
         Color                = Constants.NUMBER_COLOR,
         UnlockOnMouseLeave   = UnlockOnMouseLeave
      })

   local ValueIn = Instance.new('NumberValue')
   ValueIn.Name     = 'ValueIn'
   
   local Min = Instance.new('NumberValue')
   Min.Name    = 'Min'
   Min.Value   = Misc.NUMBER_MIN
   
   local Max = Instance.new('NumberValue')
   Max.Name    = 'Max'
   Max.Value   = Misc.NUMBER_MAX
   
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

   local function RenderText(value)
      if string.len(value) == 0 then
         value =  ''
      else
         value = tonumber(value)
         if value == nil then
            value =  ''
         else
            value = string.format("%."..Precision.Value.."f", value)
         end
      end
   
      return value
   end

   local IsTextActive = Instance.new('BoolValue')

   local Value, TextFrame, OnFocused, OnFocusLost, DisconnectText =  GUIUtils.CreateInput({
      Color    = Constants.NUMBER_COLOR,
      Active   = IsTextActive,
      Render   = RenderText,
      Parse    = function (text, value)
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

   local TextContainer = Instance.new("Frame")
   TextContainer.Name 			            = "text-container"
   TextContainer.AnchorPoint	            = Vector2.new(0, 0)
   TextContainer.BackgroundColor3         = Color3.fromRGB(48, 48, 48)
   TextContainer.BackgroundTransparency   = 1
   TextContainer.BorderColor3             = Color3.fromRGB(48, 48, 48)
   TextContainer.BorderMode 			      = Enum.BorderMode.Outline
   TextContainer.BorderSizePixel 			= 0
   TextContainer.Draggable 			      = false
   TextContainer.Position 			         = UDim2.new(0, 0, 0, 4)
   TextContainer.Selectable               = false
   TextContainer.Size 			            = UDim2.new(1, -2, 1, -8)
   TextContainer.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   TextContainer.Style 			            = Enum.FrameStyle.Custom
   TextContainer.Visible                  = true
   TextContainer.ZIndex                   = 1
   TextContainer.Archivable               = true
   TextContainer.Parent = Control
   TextFrame.Parent     = TextContainer

   Value.Parent         = Controller
   IsTextActive.Value   = false

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections       = {}

   table.insert(connections, OnLock:Connect(function()
      IsTextActive.Value         = false
      UnlockOnMouseLeave.Value   = true
   end))

   table.insert(connections, OnUnLock:Connect(function()
      IsTextActive.Value = true
   end))
   
   table.insert(connections, OnFocused:Connect(function()
      UnlockOnMouseLeave.Value   = false
   end))
   
   table.insert(connections, OnFocusLost:Connect(function()
      UnlockOnMouseLeave.Value   = true
   end))
   
   -- On change steps
   table.insert(connections, Step.Changed:connect(function()	
      Precision.Value = Misc.CountDecimals(Step.Value)
      if Value.Value ~= nil and Value.Value ~= '' then
         Value.Value = '0'..Value.Value
      end
   end))

   -- On change value from outside
   table.insert(connections, ValueIn.Changed:connect(function()
      local value = math.max(math.min(ValueIn.Value, Max.Value), Min.Value)
      
      if value % Step.Value ~= 0 then
         value = math.round(value/Step.Value) * Step.Value
      end
      
      Value.Value = RenderText(tostring(value))
   end))
   
   return Controller, Misc.DisconnectFn(connections, DisconnectParent, DisconnectText)
end

-- Represents a given property of an object that is a number.
local function NumberController(gui, object, property, min, max, step)
	
	local frame, DisconnectGUI = CreateGUI()
	frame.Parent = gui.content
	
	local labelValue 	   = frame:WaitForChild("Label")	
	local minValue 		= frame:WaitForChild("Min")
	local maxValue 		= frame:WaitForChild("Max")
	local stepValue 	   = frame:WaitForChild("Step")
	local stringValue 	= frame:WaitForChild("Value")		   -- Safe value
	local valueInValue   = frame:WaitForChild("ValueIn")		-- Input value, unsafe
	
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
	stringValue.Changed:connect(function()		
		if not controller._isReadonly then
			object[property] = tonumber(stringValue.Value)
		end		
		
		if onChange ~= nil then
			onChange(object[property])
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
		return object[property]
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

      DisconnectGUI()
		
		if listenConnection ~= nil then
			listenConnection:Disconnect()
		end
		
		gui.removeChild(controller)
		
		if controller.frame ~= nil then
			controller.frame.Parent = nil
			controller.frame = nil
		end		
		
		controller = nil
	end
	
	-- Sets controller to listen for changes on its underlying object.
	function controller.listen()
		if listenConnection ~= nil then
			return
		end
		
		if object['IsA'] ~= nil then
			-- roblox Interface
			listenConnection = object:GetPropertyChangedSignal(property):Connect(function(value)
				controller.setValue(object[property])
			end)
			
		else
			-- tables (dirty checking before render)
			local oldValue = object[property]
			listenConnection = RunService.RenderStepped:Connect(function(step)
				if object[property] ~= oldValue then
					oldValue = object[property]
					controller.setValue(oldValue)
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
	labelValue.Value     = property
	valueInValue.Value   = object[property]
	
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
