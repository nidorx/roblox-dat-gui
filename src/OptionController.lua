local Mouse             = game.Players.LocalPlayer:GetMouse()
local RunService        = game:GetService("RunService")
local HttpService       = game:GetService("HttpService")
local UserInputService  = game:GetService("UserInputService")

local COLOR_TEXT_HOVER 	   = Color3.fromRGB(30, 211, 111)
local COLOR_TEXT_OFF	      = Color3.fromRGB(255, 255, 255)
local COLOR_TEXT_BG_OFF    = Color3.fromRGB(48, 48, 48)
local COLOR_TEXT_BG_HOVER  = Color3.fromRGB(60, 60, 60)

local function CreateGUI()
   local Controller = Instance.new("Frame")
   Controller.Name 			            = "OptionController"
   Controller.AnchorPoint	            = Vector2.new(0, 0)
   Controller.BackgroundColor3         = Color3.fromRGB(26, 26, 26)
   Controller.BackgroundTransparency   = 0
   Controller.BorderColor3             = Color3.fromRGB(27, 42, 53)
   Controller.BorderMode 			      = Enum.BorderMode.Outline
   Controller.BorderSizePixel 			= 0
   Controller.Draggable 			      = false
   Controller.Position 			         = UDim2.new(0, 0, 0, 60)
   Controller.Selectable               = false
   Controller.Size 			            = UDim2.new(1, 0, 0, 30)
   Controller.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   Controller.Style 			            = Enum.FrameStyle.Custom
   Controller.Visible                  = true
   Controller.ZIndex                   = 1
   Controller.Archivable               = true

   local LabelValue = Instance.new('StringValue')
   LabelValue.Name = 'Label'
   LabelValue.Parent = Controller

   local UILocked = Instance.new('StringValue')
   UILocked.Name = 'UILocked'
   UILocked.Parent = Controller

   local Selected = Instance.new('IntValue')
   Selected.Name     = 'Selected'
   Selected.Value    = 0
   Selected.Parent   = Controller

   local Options = Instance.new('StringValue')
   Options.Name     = 'Options'
   Options.Parent   = Controller

   local LabelText = Instance.new('TextLabel')
   LabelText.Name 			         = "LabelText"
   LabelText.AnchorPoint	         = Vector2.new(0, 0)
   LabelText.AutomaticSize	         = Enum.AutomaticSize.None
   LabelText.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
   LabelText.BackgroundTransparency = 1
   LabelText.BorderColor3           = Color3.fromRGB(27, 42, 53)
   LabelText.BorderMode 			   = Enum.BorderMode.Outline
   LabelText.BorderSizePixel 			= 0
   LabelText.Position 			      = UDim2.new(0, 10, 0, 0)
   LabelText.Selectable             = false
   LabelText.Size 			         = UDim2.new(0.4, -10, 1, -1)
   LabelText.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   LabelText.Visible                = true
   LabelText.ZIndex                 = 1
   LabelText.Archivable             = true
   LabelText.Font                   = Enum.Font.SourceSans
   LabelText.LineHeight             = 1
   LabelText.RichText               = false
   LabelText.Text                   = 'Option Label'
   LabelText.TextColor3 			   = Color3.new(238, 238, 238)
   LabelText.TextScaled             = false
   LabelText.TextSize               = 14
   LabelText.TextStrokeColor3 		= Color3.new(0, 0, 0)
   LabelText.TextStrokeTransparency = 1
   LabelText.TextTransparency       = 0
   LabelText.TextTruncate           = Enum.TextTruncate.AtEnd
   LabelText.TextWrapped            = false
   LabelText.TextXAlignment         = Enum.TextXAlignment.Left
   LabelText.TextYAlignment         = Enum.TextYAlignment.Center
   LabelText.Parent = Controller

   local borderBottom = Instance.new("Frame")
   borderBottom.Name 			         = "border-bottom"
   borderBottom.AnchorPoint	         = Vector2.new(0, 0)
   borderBottom.BackgroundColor3       = Color3.fromRGB(44, 44, 44)
   borderBottom.BackgroundTransparency = 0
   borderBottom.BorderColor3           = Color3.fromRGB(44, 44, 44)
   borderBottom.BorderMode 			   = Enum.BorderMode.Outline
   borderBottom.BorderSizePixel 			= 0
   borderBottom.Draggable 			      = false
   borderBottom.Position 			      = UDim2.new(0, 0, 1, -1)
   borderBottom.Selectable             = false
   borderBottom.Size 			         = UDim2.new(1, 0, 0, 1)
   borderBottom.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   borderBottom.Style 			         = Enum.FrameStyle.Custom
   borderBottom.Visible                = true
   borderBottom.ZIndex                 = 1
   borderBottom.Archivable             = true
   borderBottom.Parent = Controller

   local borderLeft = Instance.new("Frame")
   borderLeft.Name 			            = "border-left"
   borderLeft.AnchorPoint	            = Vector2.new(0, 0)
   borderLeft.BackgroundColor3         = Color3.fromRGB(30, 211, 111)
   borderLeft.BackgroundTransparency   = 0
   borderLeft.BorderColor3             = Color3.fromRGB(27, 42, 53)
   borderLeft.BorderMode 			      = Enum.BorderMode.Outline
   borderLeft.BorderSizePixel 			= 0
   borderLeft.Draggable 			      = false
   borderLeft.Position 			         = UDim2.new(0, 0,0, 0)
   borderLeft.Selectable               = false
   borderLeft.Size 			            = UDim2.new(0, 3, 1, 0)
   borderLeft.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   borderLeft.Style 			            = Enum.FrameStyle.Custom
   borderLeft.Visible                  = true
   borderLeft.ZIndex                   = 2
   borderLeft.Archivable               = true
   borderLeft.Parent = Controller

   local Control = Instance.new("Frame")
   Control.Name 			            = "control"
   Control.AnchorPoint	            = Vector2.new(0, 0)
   Control.BackgroundColor3         = Color3.fromRGB(255, 255, 255)
   Control.BackgroundTransparency   = 1
   Control.BorderColor3             = Color3.fromRGB(27, 42, 53)
   Control.BorderMode 			      = Enum.BorderMode.Outline
   Control.BorderSizePixel 			= 0
   Control.Draggable 			      = false
   Control.Position 			         = UDim2.new(0.4, 0, 0, 0)
   Control.Selectable               = false
   Control.Size 			            = UDim2.new(0.6, 0, 1, -1)
   Control.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   Control.Style 			            = Enum.FrameStyle.Custom
   Control.Visible                  = true
   Control.ZIndex                   = 1
   Control.Archivable               = true
   Control.Parent = Controller

   local SelectContainer = Instance.new("Frame")
   SelectContainer.Name 			         = "items-container"
   SelectContainer.AnchorPoint	         = Vector2.new(0, 0)
   SelectContainer.BackgroundColor3       = Color3.fromRGB(48, 48, 48)
   SelectContainer.BackgroundTransparency = 1
   SelectContainer.BorderColor3           = Color3.fromRGB(27, 42, 53)
   SelectContainer.BorderMode 			   = Enum.BorderMode.Outline
   SelectContainer.BorderSizePixel 			= 0
   SelectContainer.Draggable 			      = false
   SelectContainer.Position 			      = UDim2.new(0, 0, 0, 4)
   SelectContainer.Selectable             = false
   SelectContainer.Size 			         = UDim2.new(1, -2, 1, -8)
   SelectContainer.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   SelectContainer.Style 			         = Enum.FrameStyle.Custom
   SelectContainer.Visible                = true
   SelectContainer.ZIndex                 = 1
   SelectContainer.Archivable             = true
   SelectContainer.Parent = Control

   local SelectList = Instance.new("Frame")
   SelectList.Name 			            = "inner"
   SelectList.AnchorPoint	            = Vector2.new(0, 0)
   SelectList.BackgroundColor3         = Color3.fromRGB(255, 255, 255)
   SelectList.BackgroundTransparency   = 0
   SelectList.BorderColor3             = Color3.fromRGB(27, 42, 53)
   SelectList.BorderMode 			      = Enum.BorderMode.Outline
   SelectList.BorderSizePixel 			= 0
   SelectList.Draggable 			      = false
   SelectList.Position 			         = UDim2.new(0, 0, 0, 0)
   SelectList.Selectable               = false
   SelectList.Size 			            = UDim2.new(1, 0, 1, 0)
   SelectList.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   SelectList.Style 			            = Enum.FrameStyle.Custom
   SelectList.Visible                  = true
   SelectList.ZIndex                   = 1
   SelectList.Archivable               = true
   SelectList.Parent = SelectContainer

   local List = Instance.new("UIListLayout")
   List.Name 			         = "list"
   List.Archivable            = true
   List.FillDirection         = Enum.FillDirection.Vertical
   List.HorizontalAlignment   = Enum.HorizontalAlignment.Left
   List.SortOrder             = Enum.SortOrder.LayoutOrder
   List.VerticalAlignment     = Enum.VerticalAlignment.Top
   List.Parent = SelectList

   local ItemTemplate = Instance.new("Frame")
   ItemTemplate.Name 			         = "item"
   ItemTemplate.AnchorPoint	         = Vector2.new(0, 0)
   ItemTemplate.BackgroundColor3       = Color3.fromRGB(48, 48, 48)
   ItemTemplate.BackgroundTransparency = 0
   ItemTemplate.BorderColor3           = Color3.fromRGB(27, 42, 53)
   ItemTemplate.BorderMode 			   = Enum.BorderMode.Outline
   ItemTemplate.BorderSizePixel 			= 0
   ItemTemplate.Draggable 			      = false
   ItemTemplate.Position 			      = UDim2.new(0, 0, 0, 0)
   ItemTemplate.Selectable             = false
   ItemTemplate.Size 			         = UDim2.new(1, 0, 0, 21)
   ItemTemplate.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   ItemTemplate.Style 			         = Enum.FrameStyle.Custom
   ItemTemplate.Visible                = false
   ItemTemplate.ZIndex                 = 1
   ItemTemplate.Archivable             = true
   ItemTemplate.Parent = SelectContainer

   local Text = Instance.new("TextButton")
   Text.Name 			            = "text"
   Text.Active                   = true
   Text.AutoButtonColor          = true
   Text.AnchorPoint	            = Vector2.new(0, 0)
   Text.BackgroundColor3         = Color3.fromRGB(255, 255, 255)
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
   Text.TextColor3 			      = Color3.new(30, 211, 111)
   Text.TextScaled               = false
   Text.TextSize                 = 14
   Text.TextStrokeColor3 		   = Color3.new(0, 0, 0)
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
   local controllerHover 	   = false
   local selectListHover 	   = false
   local selectListIsOpen	   = false
   
   table.insert(connections, LabelValue.Changed:connect(function()
      LabelText.Text = LabelValue.Value
   end))
   
   local function checkVisibility()
      if UILocked.Value == "LOCKED" then
         selectListIsOpen = false
         SelectList.Size = UDim2.new(1, 0, 1, 0)
         
      else
         SelectList.Size = UDim2.new(1, 0, 0, itemsSize)		
      end
      
      if UILocked.Value == "ACTIVE" and selectListIsOpen then
         
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
   
   local function checkUnlock()	
      checkVisibility()
      
      if controllerHover or selectListHover then
         return
      end
      
      spawn(function()		
         UILocked.Value = "UNLOCK"
      end)
   end
   
   table.insert(connections, Controller.MouseEnter:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      controllerHover = true
      checkVisibility()
   end))
   
   table.insert(connections, Controller.MouseMoved:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      controllerHover = true
      checkVisibility()
   end))
   
   table.insert(connections, Controller.MouseLeave:Connect(function()
      controllerHover = false
      checkUnlock()
   end))
   
   table.insert(connections, SelectList.MouseEnter:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      selectListHover = true
      checkVisibility()
   end))
   
   table.insert(connections, SelectList.MouseMoved:Connect(function()
      if UILocked.Value ~= "ACTIVE" then
         return
      end
      
      selectListHover = true
      checkVisibility()
   end))
   
   table.insert(connections, SelectList.MouseLeave:Connect(function()
      selectListHover = false
      selectListIsOpen = false
      
      checkUnlock()
   end))
   
   -- On change value (safe)
   table.insert(connections, Selected.Changed:connect(function()
      checkVisibility()
   end))

   local function ItemScript(Item, connections)
      -- controls focus effect
      local Text = Item:WaitForChild("text")

      table.insert(connections, Text.MouseEnter:Connect(function()
         if UILocked.Value ~= "ACTIVE" then
            return
         end
         
         Text.TextColor3 = COLOR_TEXT_HOVER
         Item.BackgroundColor3 = COLOR_TEXT_BG_HOVER
      end))

      table.insert(connections, Text.MouseMoved:Connect(function()
         if UILocked.Value ~= "ACTIVE" then
            return
         end
         
         Text.TextColor3 = COLOR_TEXT_HOVER
         Item.BackgroundColor3 = COLOR_TEXT_BG_HOVER
      end))

      table.insert(connections, Text.MouseLeave:Connect(function()
         Text.TextColor3 = COLOR_TEXT_OFF
         Item.BackgroundColor3 = COLOR_TEXT_BG_OFF
      end))

      -- reset when external lock (eg close folder)
      table.insert(connections, UILocked.Changed:connect(function()
         if UILocked.Value == "LOCKED" then
            Text.TextColor3 = COLOR_TEXT_OFF
            Item.BackgroundColor3 = COLOR_TEXT_BG_OFF
         end
      end))
   end
   
   table.insert(connections, Options.Changed:Connect(function()
      local labels = HttpService:JSONDecode(Options.Value)

      for _, conn in ipairs(connectionsItems) do
         conn:Disconnect()
      end
      connectionsItems = {}
      
      local size = 0
      for index, label in pairs(labels) do
         local item = ItemTemplate:Clone()		
         item.Name = "item_"..index
         item.Visible = true
         item.Parent = SelectList
         item.LayoutOrder = index
         
         -- enable script
         ItemScript(item, connectionsItems)
         
         local Text = item:WaitForChild("text")
         Text.Text = label
         
         size += Text.AbsoluteSize.Y
         
         Text.MouseButton1Click:Connect(function()
            if selectListIsOpen then				
               Selected.Value = index
               selectListIsOpen = false
               checkUnlock()
               
            else
               if UILocked.Value ~= "ACTIVE" then
                  return
               end
               
               selectListIsOpen = true
               checkVisibility()
            end
         end)
      end
      
      itemsSize = size
      checkVisibility()
   end))
   
   table.insert(connections, UILocked.Changed:connect(function()
      if UILocked.Value == "LOCKED" then
         -- reset when external lock (eg close folder)
         controllerHover 	= false
         selectListHover 	= false
         selectListIsOpen	= false
      end
      
      checkVisibility()
   end))  

   local OnRemove = function()
      for _, conn in ipairs(connections) do
         conn:Disconnect()
      end
      connections = {}

      for _, conn in ipairs(connectionsItems) do
         conn:Disconnect()
      end
      connectionsItems = {}
   end

   return Controller, OnRemove
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
	
	local frame, OnRemove = CreateGUI()
	frame.Parent = gui.content
	
	local labelValue 		= frame:WaitForChild("Label")	
	local optionsValue 		= frame:WaitForChild("Options")
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
			for index, enumItem in ipairs(enumItems) do
				table.insert(keyValue, enumItem)
				table.insert(keyLabel, enumItem.Name)
				
				if object[property] == enumItem then
					currentIndex = index
				end
			end
		elseif isArray(options) then
         local index = 1
			for index, value in ipairs(options) do
				if type(value) == 'string' then
					-- Only string values
					table.insert(keyValue, value)
					table.insert(keyLabel, value)
					
					if object[property] == value then
						currentIndex = index
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

      OnRemove()
		
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
