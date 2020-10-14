
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local TEMPLATE = script.Parent:WaitForChild("TEMPLATE"):WaitForChild("MAIN"):WaitForChild("OptionController")

---Checks if a table is used as an array. That is: the keys start with one and are sequential numbers
-- @param t table
-- @return nil,error string if t is not a table
-- @return true/false if t is an array/isn't an array
-- NOTE: it returns true for an empty table
function isArray(t)
	if type(t)~="table" then return nil,"Argument is not a table! It is: "..type(t) end
	--check if all the table keys are numerical and count their number
	local count=0
	for k,v in pairs(t) do
		if type(k)~="number" then return false else count=count+1 end
	end
	--all keys are numerical. now let's see if they are sequential and start with 1
	for i=1,count do
		--Hint: the VALUE might be "nil", in that case "not t[i]" isn't enough, that's why we check the type
		if not t[i] and type(t[i])~="nil" then return false end
	end
	return true
end

-- Provides a select input to alter the property of an object, using a list of accepted values.
function OptionController(gui, object, property,  options)
	
	local frame = TEMPLATE:Clone()
	frame.Parent = gui.content
	
	local labelValue 		= frame:WaitForChild("Label")	
	local optionsValue 		= frame:WaitForChild("Options")
	local selectedValue 	= frame:WaitForChild("Selected")
	local selectedValueIn 	= frame:WaitForChild("SelectedIn")
	
	-- The function to be called on change.
	local onChange
	local listenConnection
	
	local keyValue = {}
	local keyLabel = {}
	local currentIndex = 1
	local isEnum = typeof(object[property]) == "EnumItem" or typeof(options) == "Enum"
	local enumItems
	
	if isEnum then
		if typeof(object[property]) == "EnumItem" then
			enumItems = object[property].EnumType:GetEnumItems()
		else
			enumItems = options:GetEnumItems()
		end
	end
	
	local controller = {
		frame 	= frame,
		label = frame:WaitForChild("LabelText"),
		height 	= frame.AbsoluteSize.Y
	}
	
	local function extractKeys()
		keyValue = {}
		
		if isEnum then
			for index, enumItem in ipairs(enumItems) do
				table.insert(keyValue, enumItem)
				table.insert(keyLabel, enumItem.Name)
				
				if object[property] == enumItem then
					currentIndex = index
				end
			end		
		elseif isArray(options) then
			for index, value in ipairs(options) do
				if type(value) == 'string' then
					-- Only string values
					table.insert(keyValue, value)
					table.insert(keyLabel, value)
					
					if object[property] == value then
						currentIndex = index
					end
				end
			end			
		else
			local index = 1
			for key, value in pairs(options) do
				if type(key) == 'string' then
					-- Only string keys
					table.insert(keyValue, value)
					table.insert(keyLabel, key)
					
					if object[property] == value then
						currentIndex = index
					end
				end
			end
		end 
		
		-- sendo to script
		optionsValue.Value 	= HttpService:JSONEncode(keyLabel)
	end
	
	------------------------------------------------------------------
	-- Configure events
	------------------------------------------------------------------
	selectedValue.Changed:connect(function()		
		if not controller._isReadonly then
			object[property] = keyValue[selectedValue.Value]
		end
		
		if onChange ~= nil then
			onChange(keyLabel[selectedValue.Value], object[property]);
		end
	end)
	
	
	------------------------------------------------------------------
	-- Public functions
	------------------------------------------------------------------
	
	function controller.onChange(fnc)
		onChange = fnc;
		return controller;
	end	
	
	function controller.setValue(key)
		selectedValueIn.Value = key		
		return controller;
	end
	
	function controller.getValue()
		return selectedValue.Value
	end
	
	function controller.options(newOptions)
		-- enum is static
		if isEnum == false then
			options = newOptions		
		end
		
		return controller;
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
	extractKeys()
	labelValue.Value = property	
	selectedValue.Value = currentIndex
	
	return controller
end

return OptionController
