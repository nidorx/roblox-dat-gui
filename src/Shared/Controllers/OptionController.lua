local Mouse             = game.Players.LocalPlayer:GetMouse()
local RunService        = game:GetService("RunService")
local HttpService       = game:GetService("HttpService")
local UserInputService  = game:GetService("UserInputService")
local GUIUtils          = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("GUI"))
local Constants         = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Constants"))
local Misc              = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Misc"))

local function CreateGUI()

   local UnlockOnMouseLeave = Instance.new('BoolValue')
   UnlockOnMouseLeave.Value = true

   local Controller, Control, OnLock, OnUnLock, OnMouseEnter, OnMouseMoved, OnMouseLeave, DisconnectParent 
      = GUIUtils.CreateControllerWrapper({
         Name  = 'OptionController',
         Color = Constants.STRING_COLOR,
         UnlockOnMouseLeave = UnlockOnMouseLeave
      })

   local Selected = Instance.new('IntValue')
   Selected.Name     = 'Selected'
   Selected.Value    = 0
   Selected.Parent   = Controller

   local Options = Instance.new('StringValue')
   Options.Name     = 'Options'
   Options.Parent   = Controller

   local SelectContainer = GUIUtils.CreateFrame()
   SelectContainer.Name 			         = "items-container"
   SelectContainer.BackgroundTransparency = 1
   SelectContainer.Position 			      = UDim2.new(0, 0, 0, 4)
   SelectContainer.Size 			         = UDim2.new(1, -2, 1, -8)
   SelectContainer.Parent = Control

   local SelectList = GUIUtils.CreateFrame()
   SelectList.Name 			            = "inner"
   SelectList.BackgroundTransparency   = 1
   SelectList.Parent = SelectContainer

   local List = Instance.new("UIListLayout")
   List.Name 			         = "list"
   List.Archivable            = true
   List.FillDirection         = Enum.FillDirection.Vertical
   List.HorizontalAlignment   = Enum.HorizontalAlignment.Left
   List.SortOrder             = Enum.SortOrder.LayoutOrder
   List.VerticalAlignment     = Enum.VerticalAlignment.Top
   List.Parent = SelectList

   local ItemTemplate = GUIUtils.CreateFrame()
   ItemTemplate.Name 			         = "item"
   ItemTemplate.BackgroundColor3       = Constants.INPUT_COLOR
   ItemTemplate.BackgroundTransparency = 0
   ItemTemplate.Size 			         = UDim2.new(1, 0, 0, 21)
   ItemTemplate.Visible                = false
   ItemTemplate.Parent = SelectContainer

   local Text = Instance.new("TextButton")
   Text.Name 			            = "TextButton"
   Text.Active                   = true
   Text.AutoButtonColor          = true
   Text.AnchorPoint	            = Vector2.new(0, 0)
   Text.BackgroundTransparency   = 1
   Text.BorderColor3             = Color3.fromRGB(27, 42, 53)
   Text.BorderMode 			      = Enum.BorderMode.Outline
   Text.BorderSizePixel 			= 1
   Text.Position 			         = UDim2.new(0, 2, 0, 0)
   Text.Size 			            = UDim2.new(1, -4, 1, 0)
   Text.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   Text.Visible                  = true
   Text.ZIndex                   = 1
   Text.Archivable               = true
   Text.Font                     = Enum.Font.SourceSans
   Text.LineHeight               = 1
   Text.RichText                 = false
   Text.Text                     = 'Option'
   Text.TextColor3 			      = Constants.STRING_COLOR
   Text.TextScaled               = false
   Text.TextSize                 = 14
   Text.TextStrokeColor3 		   = Color3.fromRGB(0, 0, 0)
   Text.TextStrokeTransparency   = 1
   Text.TextTransparency         = 0
   Text.TextTruncate             = Enum.TextTruncate.None
   Text.TextWrapped              = false
   Text.TextXAlignment           = Enum.TextXAlignment.Left
   Text.TextYAlignment           = Enum.TextYAlignment.Center
   Text.Parent = ItemTemplate

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   local connections          = {}
   local connectionsItems     = {}
   local itemsSize			   = 0
   local hover 	            = false
   local locked               = true
   local listHover 	         = false
   local listIsOpen	         = false
   
   local function checkVisibility()
      if locked then
         listIsOpen = false
         SelectList.Size = UDim2.new(1, 0, 1, 0)
      else
         SelectList.Size = UDim2.new(1, 0, 0, itemsSize)		
      end
      
      if not locked and listIsOpen then
         
         SelectContainer.ZIndex = 100
         SelectContainer.ClipsDescendants = false		
         
         for _, item in pairs(SelectList:GetChildren()) do
            if item:isA("Frame") then
               item.Visible = true
            end
         end
      else
         SelectContainer.ZIndex = 1		
         SelectContainer.ClipsDescendants = true		
         
         for index, item in pairs(SelectList:GetChildren()) do
            if item:isA("Frame") then
               if item.Name ==  "item_"..Selected.Value then
                  item.Visible = true
               else
                  item.Visible = false
               end
            end
         end
      end
   end

   table.insert(connections, OnLock:Connect(function()
      hover       = false
      locked      = true
      listHover 	= false
      -- listIsOpen	= false
      checkVisibility()
   end))

   table.insert(connections, OnUnLock:Connect(function()
      locked = false
   end))

   table.insert(connections, OnMouseEnter:Connect(function()
      hover = true
      checkVisibility()
   end))

   table.insert(connections, OnMouseMoved:Connect(function()
      hover = true
      checkVisibility()
   end))

   table.insert(connections, OnMouseLeave:Connect(function()	
      hover = false
      checkVisibility()
   end))
   
   table.insert(connections, SelectList.MouseEnter:Connect(function()
      if locked then
         return
      end
      
      listHover = true
      checkVisibility()
   end))
   
   table.insert(connections, SelectList.MouseMoved:Connect(function()
      if locked then
         return
      end
      
      listHover = true
      checkVisibility()
   end))
   
   table.insert(connections, SelectList.MouseLeave:Connect(function()
      listHover = false
      listIsOpen = false
      UnlockOnMouseLeave.Value   = true
      checkVisibility()
   end))
   
   -- On change value (safe)
   table.insert(connections, Selected.Changed:connect(function()
      checkVisibility()
   end))

   local function ItemScript(Item, connections)
      -- controls focus effect
      local Text = Item:WaitForChild("TextButton")

      table.insert(connections, Text.MouseEnter:Connect(function()
         if locked then
            return
         end
         
         Text.TextColor3 = Constants.STRING_COLOR
         Item.BackgroundColor3 = Constants.INPUT_COLOR_HOVER
      end))

      table.insert(connections, Text.MouseMoved:Connect(function()
         if locked then
            return
         end
         
         Text.TextColor3 = Constants.STRING_COLOR
         Item.BackgroundColor3 = Constants.INPUT_COLOR_HOVER
      end))

      table.insert(connections, Text.MouseLeave:Connect(function()
         Text.TextColor3 = Constants.INPUT_COLOR_FOCUS_TXT
         Item.BackgroundColor3 = Constants.INPUT_COLOR
      end))

      table.insert(connections, OnLock:Connect(function()
         Text.TextColor3 = Constants.INPUT_COLOR_FOCUS_TXT
         Item.BackgroundColor3 = Constants.INPUT_COLOR
      end))
   end
   
   table.insert(connections, Options.Changed:Connect(function()
      local labels = HttpService:JSONDecode(Options.Value)

      for _, conn in ipairs(connectionsItems) do
         conn:Disconnect()
      end
      table.clear(connectionsItems)
      
      local size = 0
      for index, label in pairs(labels) do
         local item = ItemTemplate:Clone()		
         item.Name = "item_"..index
         item.Visible = true
         item.Parent = SelectList
         item.LayoutOrder = index
         
         -- enable script
         ItemScript(item, connectionsItems)
         
         local Text = item:WaitForChild("TextButton")
         Text.Text = label
         
         size = size + Text.AbsoluteSize.Y
         
         Text.MouseButton1Click:Connect(function()
            if listIsOpen then				
               Selected.Value = index
               listIsOpen = false
               UnlockOnMouseLeave.Value   = true
               checkVisibility()
               
            else
               if locked then
                  return
               end
               
               listIsOpen = true
               UnlockOnMouseLeave.Value   = false
               checkVisibility()
            end
         end)
      end
      
      itemsSize = size
      checkVisibility()
   end))
   
   return Controller, Misc.DisconnectFn(connections, Misc.DisconnectFn(connectionsItems))
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
	
	local labelValue 		= frame:WaitForChild("Label")	
	local optionsValue 	= frame:WaitForChild("Options")
	local selectedValue 	= frame:WaitForChild("Selected")
	
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
		if not controller._isReadonly then
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
	extractKeys()
	labelValue.Value = property	
	selectedValue.Value = currentIndex
	
	return controller
end

return OptionController
