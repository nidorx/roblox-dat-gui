
local RunService = game:GetService("RunService")

local TEMPLATE = script.Parent:WaitForChild("TEMPLATE"):WaitForChild("MAIN"):WaitForChild("Vector3SliderController")

-- Number slider controller
local function Vector3SliderController(gui, object, property, min, max, step)
	
	local frame = TEMPLATE:Clone()
	frame.Parent = gui.content
	
	local labelValue 	= frame:WaitForChild("Label")	
	local minValue 		= frame:WaitForChild("Min")
	local maxValue 		= frame:WaitForChild("Max")
	local stepValue 	= frame:WaitForChild("Step")
	local valueValue 	= frame:WaitForChild("Value")		-- Safe value
	local valueInValue	= frame:WaitForChild("ValueIn")		-- Input value, unsafe
	
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
	valueValue.Changed:connect(function()	
		if not controller._isReadonly then
			object[property] = valueValue.Value;
		end
		
		if onChange ~= nil then
			onChange(object[property]);
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
		return object[property]
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
		
		-- tables (dirty checking before render, Instance.Changed or Instance.GetPropertyChangedSignal dont work for position, CFrame, etc)
		local oldValueX = object[property].X
		local oldValueY = object[property].Y
		local oldValueZ = object[property].Z
		listenConnection = RunService.RenderStepped:Connect(function(step)
			local value = object[property]
			if value.X ~= oldValueX or value.Y ~= oldValueY or value.Z ~= oldValueZ then
				oldValueX = value.X
				oldValueY = value.Y
				oldValueZ = value.Z
				controller.setValue(object[property])
			end
		end)
		
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
	
	valueInValue.Value = object[property]
	
	return controller
end

return Vector3SliderController
