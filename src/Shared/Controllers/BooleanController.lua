
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")

-- lib
local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local Misc              = require(Lib:WaitForChild("Misc"))
local GUIUtils          = require(Lib:WaitForChild("GUI"))
local GuiEvents         = require(Lib:WaitForChild("GuiEvents"))
local Constants         = require(Lib:WaitForChild("Constants"))

local function CreateGUI()

   local Controller, Control, DisconnectParent = GUIUtils.CreateControllerWrapper({
      ['Name']  = 'BooleanController',
      ['Color'] = Constants.BOOLEAN_COLOR
   })

   local Readonly    = Controller:WaitForChild('Readonly')

   local Value = Instance.new('BoolValue')
   Value.Name     = 'Value'
   Value.Value    = false
   Value.Parent   = Controller

   local Checkbox = GUIUtils.CreateFrame()
   Checkbox.Name 			            = "Checkbox"
   Checkbox.BackgroundColor3        = Constants.CHECKBOX_COLOR_OFF
   Checkbox.BackgroundTransparency  = 0
   Checkbox.Position 			      = UDim2.new(0, 0, 0, 3)
   Checkbox.Size 			            = UDim2.new(0, 23, 1, -6)
   Checkbox.Parent = Control

   local Check = GUIUtils.CreateImageLabel(Constants.ICON_CHECKMARK)
   Check.Name 			            = "Check"
   Check.ImageColor3             = Constants.CHECKBOX_COLOR_IMAGE
   Check.Parent = Checkbox

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections    = {}
   local isHover        = false

   local function updateCheckbox()
      if Value.Value then
         -- checked
         if isHover and not Readonly.Value then
            Checkbox.BackgroundColor3 = Constants.NUMBER_COLOR_HOVER
         else
            Checkbox.BackgroundColor3 = Constants.NUMBER_COLOR
         end
      elseif isHover and not Readonly.Value then
         Checkbox.BackgroundColor3 = Constants.INPUT_COLOR_FOCUS
      else
         Checkbox.BackgroundColor3 = Constants.INPUT_COLOR
      end
   end

   -- On change value (safe)
   table.insert(connections, Value.Changed:connect(function()
      Check.Visible = Value.Value
      updateCheckbox()
   end))

   table.insert(connections, GuiEvents.OnHover(Controller, function(hover)
      isHover = hover
      updateCheckbox()
   end))
   
   table.insert(connections, GuiEvents.OnClick(Controller, function(el, input)
      Value.Value = not Value.Value
      return false
   end))

   return Controller, Misc.DisconnectFn(connections, DisconnectParent)
end

-- Provides a checkbox input to alter the boolean property of an object.
local BooleanController = function(gui, object, property, isBoolValue)
	
	local frame, DisconnectGUI = CreateGUI()
	frame.Parent = gui.Content
	
	local boolValue 	= frame:WaitForChild("Value")
   local readonly    = frame:WaitForChild("Readonly")
   
	
	-- The function to be called on change.
	local onChange	
	local listenConnection
	
	local controller = {
		['frame'] = frame,
		['height'] = frame.AbsoluteSize.Y
	}
	
	------------------------------------------------------------------
	-- Configure events
	------------------------------------------------------------------
	boolValue.Changed:connect(function()	
		if not readonly.Value then
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
			listenConnection = RunService.Heartbeat:Connect(function()
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
	
	return controller
end

return BooleanController
