
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local GUIUtils          = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("GUI"))
local Constants         = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Constants"))
local Misc              = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Misc"))

local function CreateGUI()

   local Controller, Control, OnLock, OnUnLock, OnMouseEnter, OnMouseMoved, OnMouseLeave, DisconnectParent 
      = GUIUtils.CreateControllerWrapper({
         Name  = 'BooleanController',
         Color = Constants.BOOLEAN_COLOR
      })

   local Value = Instance.new('BoolValue')
   Value.Name     = 'Value'
   Value.Value    = false
   Value.Parent   = Controller

   local Checkbox = GUIUtils.CreateFrame()
   Checkbox.Name 			            = "Checkbox"
   Checkbox.BackgroundColor3        = Constants.CHECKBOX_COLOR_OFF
   Checkbox.BackgroundTransparency  = 0
   Checkbox.Position 			      = UDim2.new(0, 0, 0, 4)
   Checkbox.Size 			            = UDim2.new(0, 21, 1, -8)
   Checkbox.Parent = Control

   local Check = GUIUtils.CreateFrame()
   Check.Name 			            = "Check"
   Check.BackgroundColor3        = Constants.CHECKBOX_COLOR_IMAGE
   Check.BackgroundTransparency  = 0
   Check.Position 			      = UDim2.new(0.5, -3, 0.5, -7)
   Check.Size 			            = UDim2.new(0, 6, 0, 10)
   Check.Rotation                = 45
   Check.ZIndex                  = 2
   Check.Visible                 = false
   Check.Parent = Checkbox

   local CheckMask = GUIUtils.CreateFrame()
   CheckMask.Name 			         = "Mask"
   CheckMask.BackgroundColor3       = Constants.CHECKBOX_COLOR_OFF
   CheckMask.BackgroundTransparency = 0
   CheckMask.Position 			      = UDim2.new(0, -3, 0, 0)
   CheckMask.Size 			         = UDim2.new(0, 7, 0, 8)
   CheckMask.ZIndex                 = 1
   CheckMask.Parent = Check

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections    = {}
   local hover          = false
   local locked         = true
   local checkboxHover  = false

   local function updateCheckbox()
      if Value.Value then
         -- checked
         if checkboxHover then
            Checkbox.BackgroundColor3 = Constants.NUMBER_COLOR_HOVER
            CheckMask.BackgroundColor3 = Constants.NUMBER_COLOR_HOVER
         else
            Checkbox.BackgroundColor3 = Constants.NUMBER_COLOR
            CheckMask.BackgroundColor3 = Constants.NUMBER_COLOR
         end
      elseif hover then
         if checkboxHover then
            Checkbox.BackgroundColor3 = Constants.INPUT_COLOR_FOCUS
            CheckMask.BackgroundColor3 = Constants.INPUT_COLOR_FOCUS
         else
            Checkbox.BackgroundColor3 = Constants.INPUT_COLOR_HOVER
            CheckMask.BackgroundColor3 = Constants.INPUT_COLOR_HOVER
         end
      else
         Checkbox.BackgroundColor3 = Constants.INPUT_COLOR
         CheckMask.BackgroundColor3 = Constants.INPUT_COLOR
      end
   end

   table.insert(connections, OnLock:Connect(function()
      hover    = false
      locked   = true
      updateCheckbox()
   end))

   table.insert(connections, OnUnLock:Connect(function()
      locked = false
   end))

   table.insert(connections, OnMouseEnter:Connect(function()
      hover = true
      updateCheckbox()
   end))

   table.insert(connections, OnMouseMoved:Connect(function()
      hover = true
      updateCheckbox()
   end))

   table.insert(connections, OnMouseLeave:Connect(function()	
      hover = false
      updateCheckbox()
   end))

   table.insert(connections, Checkbox.MouseEnter:Connect(function()
      if locked then
         return
      end
      
      checkboxHover = true
   end))

   table.insert(connections, Checkbox.MouseMoved:Connect(function()
      if locked then
         return
      end
      
      checkboxHover = true
   end))

   table.insert(connections, Checkbox.MouseLeave:Connect(function()
      checkboxHover = false
   end))

   -- On change value (safe)
   table.insert(connections, Value.Changed:connect(function()
      Check.Visible = Value.Value
      updateCheckbox()
   end))

   table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
      if not locked and input.UserInputType == Enum.UserInputType.MouseButton1 then
         Value.Value = not Value.Value
      end
   end))

   return Controller, Misc.DisconnectFn(connections, DisconnectParent)
end

-- Provides a checkbox input to alter the boolean property of an object.
local BooleanController = function(gui, object, property, isBoolValue)
	
	local frame, DisconnectGUI = CreateGUI()
	frame.Parent = gui.Content
	
	local boolValue 	= frame:WaitForChild("Value")
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
	boolValue.Changed:connect(function()	
		if not controller._isReadonly then
         if isBoolValue then
            object[property].Value = boolValue.Value
         else
            object[property] = boolValue.Value
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
		if value == true or value == false then
			boolValue.Value = value
		end
		
		return controller;
	end
	
	function controller.getValue()
      if isBoolValue then
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

      if isBoolValue then
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
			listenConnection = RunService.RenderStepped:Connect(function(step)
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

return BooleanController
