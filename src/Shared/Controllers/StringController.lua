local RunService  = game:GetService("RunService")

-- lib
local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local Misc        = require(Lib:WaitForChild("Misc"))
local GUIUtils    = require(Lib:WaitForChild("GUI"))
local Constants   = require(Lib:WaitForChild("Constants"))

local function CreateGUI(isMultiline)

   local Height = 30
   if isMultiline then
      Height = 120
   end

   local Controller, Control, DisconnectParent = GUIUtils.CreateControllerWrapper({
      ['Name']    = 'StringController',
      ['Color']   = Constants.STRING_COLOR,
      ['Height']  = Height
   })

   local TextContainer = GUIUtils.CreateFrame()
   TextContainer.Name 			            = 'TextContainer'
   TextContainer.BackgroundTransparency   = 1
   TextContainer.Position 			         = UDim2.new(0, 0, 0, 3)
   TextContainer.Size 			            = UDim2.new(1, 0, 1, -6)
   TextContainer.Parent = Control

   local Value, TextFrame, OnFocused, OnFocusLost, DisconnectText = GUIUtils.CreateInput({
      ['Color']       = Constants.STRING_COLOR,
      ['MultiLine']   = isMultiline,
      ['Readonly']    = Controller:WaitForChild('Readonly')
   })

   Value.Parent         = Controller
   TextFrame.Parent     = TextContainer

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections = {}
   
   return Controller, Misc.DisconnectFn(connections, DisconnectParent, DisconnectText)
end

-- Provides a text input to alter the string property of an object.
local function StringController(gui, object, property, isMultiline, isStringValue)
	
	local frame, DisconnectGUI = CreateGUI(isMultiline)
	frame.Parent = gui.Content
	
   local readonly    = frame:WaitForChild("Readonly")
	local stringValue = frame:WaitForChild("Value")
	
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
         if isStringValue then
            object[property].Value = stringValue.Value
         else 
            object[property] = stringValue.Value
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
		stringValue.Value = value
		
		return controller;
	end
	
	function controller.getValue()
      if isStringValue then 
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
		
      if isStringValue then 
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
	
	return controller
end

return StringController
