local RunService  = game:GetService("RunService")
local GUIUtils    = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("GUI"))
local Constants   = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Constants"))
local Misc        = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Misc"))

local function CreateGUI()

   local UnlockOnMouseLeave = Instance.new('BoolValue')
   UnlockOnMouseLeave.Value = true

   local Controller, Control, OnLock, OnUnLock, OnMouseEnter, OnMouseMoved, OnMouseLeave, DisconnectParent 
      = GUIUtils.CreateControllerWrapper({
         Name                 = 'StringController',
         Color                = Constants.STRING_COLOR,
         UnlockOnMouseLeave   = UnlockOnMouseLeave
      })

   local TextContainer = GUIUtils.CreateFrame()
   TextContainer.Name 			            = 'TextContainer'
   TextContainer.BackgroundTransparency   = 1
   TextContainer.Position 			         = UDim2.new(0, 0, 0, 4)
   TextContainer.Size 			            = UDim2.new(1, -2, 1, -8)
   TextContainer.Parent = Control

   local IsTextActive = Instance.new('BoolValue')

   local Value, TextFrame, OnFocused, OnFocusLost, DisconnectText =  GUIUtils.CreateInput({
      Color    = Constants.STRING_COLOR,
      Active   = IsTextActive
   })

   Value.Parent         = Controller
   TextFrame.Parent     = TextContainer
   IsTextActive.Value   = false

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections = {}

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
   
   return Controller, Misc.DisconnectFn(connections, DisconnectParent, DisconnectText)
end

-- Provides a text input to alter the string property of an object.
local function StringController(gui, object, property)
	
	local frame, DisconnectGUI = CreateGUI()
	frame.Parent = gui.Content
	
	local stringValue = frame:WaitForChild("Value")
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
	stringValue.Changed:connect(function()		
		if not controller._isReadonly then
			object[property] = stringValue.Value
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
		stringValue.Value = value
		
		return controller;
	end
	
	function controller.getValue()
		return object[property]
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
	stringValue.Value = object[property]
	
	return controller
end

return StringController
