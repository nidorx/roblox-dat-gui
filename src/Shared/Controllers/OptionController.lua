local RunService        = game:GetService("RunService")
local HttpService       = game:GetService("HttpService")
local UserInputService  = game:GetService("UserInputService")

-- lib
local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local Misc              = require(Lib:WaitForChild("Misc"))
local Popover           = require(Lib:WaitForChild("Popover"))
local GUIUtils          = require(Lib:WaitForChild("GUIUtils"))
local GuiEvents         = require(Lib:WaitForChild("GuiEvents"))
local Scrollbar         = require(Lib:WaitForChild("Scrollbar"))
local Constants         = require(Lib:WaitForChild("Constants"))

local function CreateGUI()

   local Controller, Control, DisconnectParent = GUIUtils.createControllerWrapper({
      ['Name']  = 'OptionController',
      ['Color'] = Constants.STRING_COLOR
   })

   local Selected = Instance.new('IntValue')
   Selected.Name     = 'Selected'
   Selected.Value    = 0
   Selected.Parent   = Controller

   local Options = Instance.new('StringValue')
   Options.Name     = 'Options'
   Options.Parent   = Controller

   local SelectContainer = GUIUtils.createFrame()
   SelectContainer.Name 			         = "Select"
   SelectContainer.BackgroundTransparency = 1
   SelectContainer.Position 			      = UDim2.new(0, 0, 0, 3)
   SelectContainer.Size 			         = UDim2.new(1, 0, 1, -6)
   SelectContainer.Parent = Control


   local itemHeight = SelectContainer.AbsoluteSize.Y

   local popover = Popover.new(SelectContainer, Vector2.new(122, itemHeight), 'bottom', -itemHeight)
   
   local List = GUIUtils.createFrame()
   List.Name 			            = "List"
   List.BackgroundTransparency   = 1
   List.Parent = popover.Frame

   popover.Frame.ClipsDescendants = true
   local scrollbar   = Scrollbar.new(popover.Frame, List, 0)

   local ListLayout = Instance.new("UIListLayout")
   ListLayout.Name 			               = "Layout"
   ListLayout.Archivable                  = true
   ListLayout.FillDirection               = Enum.FillDirection.Vertical
   ListLayout.HorizontalAlignment         = Enum.HorizontalAlignment.Left
   ListLayout.SortOrder                   = Enum.SortOrder.LayoutOrder
   ListLayout.VerticalAlignment           = Enum.VerticalAlignment.Top
   ListLayout.Parent = List

   local DefaultOption = GUIUtils.createFrame()
   DefaultOption.Name 			            = "Item"
   DefaultOption.BackgroundColor3         = Constants.INPUT_COLOR
   DefaultOption.BackgroundTransparency   = 0
   DefaultOption.Size 			            = UDim2.new(1, 0, 0, itemHeight)
   DefaultOption.Visible                  = true
   DefaultOption.Parent = SelectContainer

   local DefaultLabel = GUIUtils.createTextLabel()
   DefaultLabel.Name 			            = "Label"
   DefaultLabel.Position 			         = UDim2.new(0, 2, 0, 0)
   DefaultLabel.Size 			            = UDim2.new(1, -4, 1, 0)
   DefaultLabel.Text                      = 'Option'
   DefaultLabel.TextColor3                = Constants.STRING_COLOR
   DefaultLabel.Parent = DefaultOption

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local labels
   local connections          = {}
   local connectionsItems     = {}
   local itemsSize			   = 0
   local isPopoverHover 	   = false
   local isListHover 	      = false
   local listCanBeOpen	      = false
   local numItems             = 1

   local function checkVisibility()      
      if listCanBeOpen and (isListHover or isPopoverHover) then
         popover:resize(Vector2.new(SelectContainer.AbsoluteSize.X, math.min(itemHeight*numItems, itemHeight*4)))
         scrollbar:update()
         popover:show()
      else
         popover:hide()
      end
   end

   table.insert(connections, GuiEvents.onEnter(List, function(enter)
      isPopoverHover = enter
      if enter then 
         listCanBeOpen = true
      end
      checkVisibility()
   end))

   table.insert(connections, GuiEvents.onHover(SelectContainer, function(hover)
      isListHover = hover
      if hover then 
         listCanBeOpen = true
      end
      checkVisibility()
   end))

   local function setItemColor(item, itemLabel)
      if Selected.Value == item:GetAttribute('OptionIndex') then 
         itemLabel.TextColor3  = Constants.INPUT_COLOR
         item.BackgroundColor3 = Constants.STRING_COLOR
      else
         itemLabel.TextColor3 = Constants.INPUT_COLOR
         item.BackgroundColor3 = Constants.INPUT_COLOR_FOCUS_TXT
      end
   end
   
   -- On change value (safe)
   table.insert(connections, Selected.Changed:connect(function()

      -- set default value
      if labels ~= nil then
         for index, label in pairs(labels) do
            if Selected.Value == index then 
               DefaultLabel.Text = label
               break
            end
         end
      end

      -- reset list colors
      for _, item in pairs(List:GetChildren()) do
         if item:IsA('Frame') then
            setItemColor(item, item:WaitForChild('Label'))
         end
      end

      checkVisibility()
   end))
   
   table.insert(connections, Options.Changed:Connect(function()
      labels = HttpService:JSONDecode(Options.Value)

      for _, conn in ipairs(connectionsItems) do
         conn:Disconnect()
      end
      table.clear(connectionsItems)
      
      numItems = 0

      for index, label in pairs(labels) do

         local item = DefaultOption:Clone()		
         item.Name               = 'item_'..index
         item.LayoutOrder        = index
         item.BackgroundColor3   = Constants.INPUT_COLOR_FOCUS_TXT
         item:SetAttribute('OptionIndex', index)

         
         local itemLabel = item:WaitForChild('Label')
         itemLabel.Text          = label
         itemLabel.TextColor3    = Constants.INPUT_COLOR
         
         item.Parent = List

         numItems = numItems + 1

         if Selected.Value == index then 
            DefaultLabel.Text = label
         end
         
         table.insert(connectionsItems, GuiEvents.onHover(item, function(hover)
            if hover then 
               itemLabel.TextColor3    = Constants.INPUT_COLOR_HOVER
               item.BackgroundColor3   = Constants.INPUT_COLOR_PLACEHOLDER
            else
               setItemColor(item, itemLabel)
            end
         end))

         table.insert(connectionsItems, GuiEvents.onClick(item, function()
            Selected.Value    = index
            DefaultLabel.Text = label
            listCanBeOpen     = false
            checkVisibility()
            return false
         end))
      end

      List.Size = UDim2.new(1, 0, 0, itemHeight*numItems)
      checkVisibility()
   end))
   
   return Controller, Misc.disconnectFn(connections, Misc.disconnectFn(connectionsItems), function()
      popover:destroy()
      scrollbar:destroy()
   end)
end

---Checks if a table is used as an array. That is: the keys start with one and are sequential numbers
-- @param t table
-- @return nil,error string if t is not a table
-- @return true/false if t is an array/isn't an array
-- NOTE: it returns true for an empty table
local function isArray(t)
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
local function OptionController(gui, object, property,  options)
	
	local frame, DisconnectGUI = CreateGUI()
	frame.Parent = gui.Content
	
	local optionsValue 	= frame:WaitForChild("Options")
	local selectedValue 	= frame:WaitForChild("Selected")
   local readonly       = frame:WaitForChild("Readonly")
	
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
		height 	= frame.AbsoluteSize.Y
	}
	
	local function extractKeys()
		keyValue = {}
		
		if isEnum then
         local enumUseIndex = typeof(object[property]) == "number"
			for index, enumItem in ipairs(enumItems) do
				table.insert(keyValue, enumItem)
				table.insert(keyLabel, enumItem.Name)
				
            if enumUseIndex then 
               if object[property] == (index - 1) then
                  currentIndex = index
               end
            else
               if object[property] == enumItem then
                  currentIndex = index
               end
            end
			end
		elseif isArray(options) then
         local index = 1
         local useIndex = typeof(object[property]) == "number"
			for index, value in ipairs(options) do
				if type(value) == 'string' then
					-- Only string values
					table.insert(keyValue, value)
					table.insert(keyLabel, value)
					
               if useIndex then
                  if object[property] == index then
                     currentIndex = index
                  end
               else
                  if object[property] == value then
                     currentIndex = index
                  end
               end
					
               index = index + 1
				end
			end			
		else
			local index = 1
			for key, value in pairs(options) do
				if type(key) == 'string' then
					-- Only string keys
					table.insert(keyValue, key)
					table.insert(keyLabel, value)
					
					if object[property] == key then
						currentIndex = index
					end
               index = index + 1
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
		if not readonly.Value then
			object[property] = keyValue[selectedValue.Value]
		end
		
		if onChange ~= nil then
			onChange(keyValue[selectedValue.Value], keyLabel[selectedValue.Value]);
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

      local index = nil
      for i, value in ipairs(keyValue) do
         if key == value then
            index = i
            break
         end
      end

      if index == nil then
         return
      end

		selectedValue.Value = index		
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
		
		if object['IsA'] ~= nil then
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
	extractKeys()

	selectedValue.Value = currentIndex
	
	return controller
end

return OptionController
