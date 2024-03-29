
local UserInputService  = game:GetService("UserInputService")

-- lib
local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local Misc              = require(Lib:WaitForChild("Misc"))
local GUIUtils          = require(Lib:WaitForChild("GUIUtils"))
local GuiEvents         = require(Lib:WaitForChild("GuiEvents"))
local Constants         = require(Lib:WaitForChild("Constants"))

local function CreateGUI()

   local Controller, Control, DisconnectParent = GUIUtils.createControllerWrapper({
      ['Name']  = 'FunctionController',
      ['Color'] = Constants.FUNCTION_COLOR
   })

   local OnClickEvent = Instance.new('BindableEvent')
   OnClickEvent.Name     = 'OnClick'
   OnClickEvent.Parent   = Controller

   local LabelText = Controller:WaitForChild('LabelText')
   LabelText.Size = UDim2.new(1, -10, 1, -1)
   
   Controller:WaitForChild('Control').Parent = nil

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections = {}

   table.insert(connections, GuiEvents.onClick(Controller, function()
      OnClickEvent:Fire()
      return false
   end))

   return Controller, Misc.disconnectFn(connections, DisconnectParent)
end

-- Provides a GUI interface to fire a specified method, a property of an object.
-- @TODO: Disabled
local function FunctionController(gui, object, property, text)
	
	local frame, DisconnectGUI =  CreateGUI()
	frame.Parent = gui.Content
	
	local onClickEvent   = frame:WaitForChild("OnClick")
	local labelValue 	   = frame:WaitForChild("Label")	
   local readonly       = frame:WaitForChild("Readonly")
	
	-- The function to be called on change.
	local onChange
	
	local controller = {
		['frame'] = frame,
		['height'] = frame.AbsoluteSize.Y
	}
	
	------------------------------------------------------------------
	-- Configure events
	------------------------------------------------------------------
	onClickEvent.Event:connect(function()	
		if not readonly.Value then
			if onChange ~= nil then
				onChange();
			end
			controller.getValue()(object)
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
		if not readonly.Value then
			object[property] = value
		end
		
		return controller;
	end
	
	function controller.getValue()		
		return object[property]
	end
	
	-- Removes the controller from its parent GUI.
	function controller.remove()
      if controller._is_removing_parent then
         return
      end

      DisconnectGUI()
		
      -- avoid recursion
      controller._is_removing_parent = true
      
		gui.removeChild(controller)
		
		if controller.frame ~= nil then
			controller.frame.Parent = nil
			controller.frame = nil
		end		
	end
	
	-- Sets the name of the controller.
	function controller.name(name)
		labelValue.Value = name
		return controller
	end
	
	------------------------------------------------------------------
	-- Set initial values
	------------------------------------------------------------------
	
	if text == nil or string.len(text) == 0 then
		labelValue.Value = property	
	else
		labelValue.Value = text	
	end
	
	return controller
end

return FunctionController
