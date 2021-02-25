
local Mouse 	            = game.Players.LocalPlayer:GetMouse()
local TweenService 		   = game:GetService("TweenService")
local UserInputService     = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local Players 	= game:GetService("Players")
local Player 	= Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera 	= workspace.CurrentCamera

local BG_COLOR_ON 			= Color3.fromRGB(17, 17, 17)
local BG_COLOR_OFF 			= Color3.fromRGB(26, 26, 26)
local LABEL_COLOR_ENABLED	= Color3.fromRGB(238, 238, 238)
local LABEL_COLOR_DISABLED	= Color3.fromRGB(136, 136, 136)

local function CreateGUIFolder(connections)

   local Folder = Instance.new("Frame")
   Folder.Name 			         = "Folder"
   Folder.AnchorPoint	         = Vector2.new(0, 0)
   Folder.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
   Folder.BackgroundTransparency = 1
   Folder.BorderColor3           = Color3.fromRGB(27, 42, 53)
   Folder.BorderMode 			   = Enum.BorderMode.Outline
   Folder.BorderSizePixel 			= 0
   Folder.Draggable 			      = false
   Folder.Position 			      = UDim2.new(0, 0, 0, 0)
   Folder.Selectable             = false
   Folder.Size 			         = UDim2.new(1, 0, 0, 30)
   Folder.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   Folder.Style 			         = Enum.FrameStyle.Custom
   Folder.Visible                = true
   Folder.ZIndex                 = 1
   Folder.Archivable             = true

   local LabelValue = Instance.new('StringValue')
   LabelValue.Name = 'Label'
   LabelValue.Parent = Folder

   local UILocked = Instance.new('StringValue')
   UILocked.Name = 'UILocked'
   UILocked.Parent = Folder

   local Closed = Instance.new('BoolValue')
   Closed.Name     = 'Closed'
   Closed.Value    = false
   Closed.Parent   = Folder

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
   borderBottom.ZIndex                 = 2
   borderBottom.Archivable             = true
   borderBottom.Parent = Folder

   local content = Instance.new("Frame")
   content.Name 			            = "content"
   content.AnchorPoint	            = Vector2.new(0, 0)
   content.BackgroundColor3         = Color3.fromRGB(255, 255, 255)
   content.BackgroundTransparency   = 1
   content.BorderColor3             = Color3.fromRGB(27, 42, 53)
   content.BorderMode 			      = Enum.BorderMode.Outline
   content.BorderSizePixel 			= 0
   content.Draggable 			      = false
   content.Position 			         = UDim2.new(0, 5, 1, 0)
   content.Selectable               = false
   content.Size 			            = UDim2.new(1, -5, 0, 100)
   content.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   content.Style 			            = Enum.FrameStyle.Custom
   content.Visible                  = true
   content.ZIndex                   = 1
   content.Archivable               = true
   content.Parent = Folder

   local Title = Instance.new("Frame")
   Title.Name 			            = "title"
   Title.AnchorPoint	            = Vector2.new(0, 0)
   Title.BackgroundColor3        = Color3.fromRGB(0, 0, 0)
   Title.BackgroundTransparency  = 0
   Title.BorderColor3            = Color3.fromRGB(27, 42, 53)
   Title.BorderMode 			      = Enum.BorderMode.Outline
   Title.BorderSizePixel 			= 0
   Title.Draggable 			      = false
   Title.Position 			      = UDim2.new(0, 0, 0, 0)
   Title.Selectable              = false
   Title.Size 			            = UDim2.new(1, 0, 0, 30)
   Title.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   Title.Style 			         = Enum.FrameStyle.Custom
   Title.Visible                 = true
   Title.ZIndex                  = 1
   Title.Archivable              = true
   Title.Parent = Folder

   local LabelText = Instance.new('TextLabel')
   LabelText.Name 			         = "LabelText"
   LabelText.AnchorPoint	         = Vector2.new(0, 0)
   LabelText.AutomaticSize	         = Enum.AutomaticSize.None
   LabelText.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
   LabelText.BackgroundTransparency = 1
   LabelText.BorderColor3           = Color3.fromRGB(27, 42, 53)
   LabelText.BorderMode 			   = Enum.BorderMode.Outline
   LabelText.BorderSizePixel 			= 0
   LabelText.Position 			      = UDim2.new(0, 15, 0, 0)
   LabelText.Selectable             = false
   LabelText.Size 			         = UDim2.new(1, -15, 1, -1)
   LabelText.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   LabelText.Visible                = true
   LabelText.ZIndex                 = 1
   LabelText.Archivable             = true
   LabelText.Font                   = Enum.Font.SourceSans
   LabelText.LineHeight             = 1
   LabelText.RichText               = false
   LabelText.Text                   = 'Folder Title'
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
   LabelText.Parent = Title

   local Chevron = Instance.new("Frame")
   Chevron.Name 			            = "chevron"
   Chevron.AnchorPoint	            = Vector2.new(0, 0)
   Chevron.BackgroundColor3         = Color3.fromRGB(214, 214, 214)
   Chevron.BackgroundTransparency   = 1
   Chevron.BorderColor3             = Color3.fromRGB(27, 42, 53)
   Chevron.BorderMode 			      = Enum.BorderMode.Outline
   Chevron.BorderSizePixel 			= 0
   Chevron.Draggable 			      = false
   Chevron.Position 			         = UDim2.new(0, 5, 0, 0)
   Chevron.Selectable               = false
   Chevron.Size 			            = UDim2.new(0, 10, 1, 0)
   Chevron.SizeConstraint 			   = Enum.SizeConstraint.RelativeXY
   Chevron.Style 			            = Enum.FrameStyle.Custom
   Chevron.Visible                  = true
   Chevron.ZIndex                   = 2
   Chevron.Archivable               = true
   Chevron.Parent = Title

   local ChevronImage = Instance.new("ImageLabel")
   ChevronImage.Name 			         = "image"
   ChevronImage.AnchorPoint	         = Vector2.new(0, 0)
   ChevronImage.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
   ChevronImage.BackgroundTransparency = 1
   ChevronImage.BorderColor3           = Color3.fromRGB(27, 42, 53)
   ChevronImage.BorderMode 			   = Enum.BorderMode.Outline
   ChevronImage.BorderSizePixel 			= 0
   ChevronImage.Position 			      = UDim2.new(0, 0, 0, 12)
   ChevronImage.Selectable             = false
   ChevronImage.Size 			         = UDim2.new(0, 6, 1, -24)
   ChevronImage.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   ChevronImage.Visible                = true
   ChevronImage.ZIndex                 = 1
   ChevronImage.Archivable             = true
   ChevronImage.Image                  = 'rbxassetid://5780747753'
   ChevronImage.ImageColor3            = Color3.fromRGB(255, 255, 255)
   ChevronImage.ImageTransparency 	   = 0
   ChevronImage.ScaleType              = Enum.ScaleType.Stretch
   ChevronImage.SliceScale             = 1
   ChevronImage.Parent = Chevron

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   -- variables
   local hover = false

   table.insert(connections, Title.MouseEnter:Connect(function()
      hover = true
   end))

   table.insert(connections, Title.MouseMoved:Connect(function()
      hover = true
   end))

   table.insert(connections, Title.MouseLeave:Connect(function()
      hover = false
   end))

   table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
      if gameProcessed then
         return
      end
      if hover and UILocked.Value == "ACTIVE"  and input.UserInputType == Enum.UserInputType.MouseButton1 then
         Closed.Value = not Closed.Value
      end
   end))

   table.insert(connections, Closed.Changed:connect(function()
      if Closed.Value then
         ChevronImage.Rotation = -90
      else
         ChevronImage.Rotation = 0
      end
   end))

   table.insert(connections, LabelValue.Changed:connect(function()
      LabelText.Text = LabelValue.Value
   end))

   return Folder
end

local function CreateGUIScrollbar(connections)
   local Scrollbar = Instance.new("Frame")
   Scrollbar.Name 			         = "Scrollbar"
   Scrollbar.AnchorPoint	         = Vector2.new(0, 0)
   Scrollbar.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
   Scrollbar.BackgroundTransparency = 0
   Scrollbar.BorderColor3           = Color3.fromRGB(27, 42, 53)
   Scrollbar.BorderMode 			   = Enum.BorderMode.Outline
   Scrollbar.BorderSizePixel 			= 0
   Scrollbar.Draggable 			      = false
   Scrollbar.Position 			      = UDim2.new(1, 0, 0, 0)
   Scrollbar.Selectable             = false
   Scrollbar.Size 			         = UDim2.new(0, 5, 1, 0)
   Scrollbar.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   Scrollbar.Style 			         = Enum.FrameStyle.Custom
   Scrollbar.Visible                = true
   Scrollbar.ZIndex                 = 1
   Scrollbar.Archivable             = true

   local Thumb = Instance.new("Frame")
   Thumb.Name 			            = "thumb"
   Thumb.AnchorPoint	            = Vector2.new(0, 0)
   Thumb.BackgroundColor3        = Color3.fromRGB(103, 103, 103)
   Thumb.BackgroundTransparency  = 0
   Thumb.BorderColor3            = Color3.fromRGB(27, 42, 53)
   Thumb.BorderMode 			      = Enum.BorderMode.Outline
   Thumb.BorderSizePixel 			= 0
   Thumb.Draggable 			      = false
   Thumb.Position 			      = UDim2.new(0, 0, 0.24, 0)
   Thumb.Selectable              = false
   Thumb.Size 			            = UDim2.new(1, 0, 0.2, 0)
   Thumb.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   Thumb.Style 			         = Enum.FrameStyle.Custom
   Thumb.Visible                 = true
   Thumb.ZIndex                  = 1
   Thumb.Archivable              = true
   Thumb.Parent = Scrollbar

   local ContentPosition = Instance.new('NumberValue')
   ContentPosition.Name    = 'ContentPosition'
   ContentPosition.Value   = 0
   ContentPosition.Parent  = Scrollbar

   local ContentSize = Instance.new('NumberValue')
   ContentSize.Name    = 'ContentSize'
   ContentSize.Value   = 0
   ContentSize.Parent  = Scrollbar

   local FrameSize = Instance.new('IntValue')
   FrameSize.Name    = 'FrameSize'
   FrameSize.Value   = 0
   FrameSize.Parent  = Scrollbar

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------   

   local visible = false
   local ScrollTween, SizeTween 

   local function updatePosition()
      if Scrollbar.Visible == false then
         return
      end

      if ScrollTween ~= nil then
         ScrollTween:Cancel()
      end		
      ScrollTween = TweenService:Create(Thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quint,Enum.EasingDirection.Out), { 
         Position = UDim2.new(0.3, 0, ContentPosition.Value/ContentSize.Value, 0)
      })		
      ScrollTween:Play()
   end

   local function updateSize()
      local contentSize 	= ContentSize.Value
      local scrollSize 	= Scrollbar.AbsoluteSize.Y

      local thumbSize = scrollSize/contentSize

      if thumbSize >= 1 then
         Scrollbar.Visible = false
         
      else
         Scrollbar.Visible = true
         
         if SizeTween ~= nil then
            SizeTween:Cancel()
         end		
         SizeTween = TweenService:Create(Thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quint,Enum.EasingDirection.Out), { 
            Size = UDim2.new(0.7, 0, thumbSize, 0)
         })		
         SizeTween:Play()
         
         updatePosition()
      end
   end

   table.insert(connections, FrameSize.Changed:connect(updateSize))
   table.insert(connections, ContentSize.Changed:connect(updateSize))
   table.insert(connections, ContentPosition.Changed:connect(updatePosition))

   return Scrollbar
end

local function CreateGUICloseButton(connections)
   local Button = Instance.new("Frame")
   Button.Name 			         = "CloseButton"
   Button.AnchorPoint	         = Vector2.new(0, 0)
   Button.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
   Button.BackgroundTransparency = 0
   Button.BorderColor3           = Color3.fromRGB(27, 42, 53)
   Button.BorderMode 			   = Enum.BorderMode.Outline
   Button.BorderSizePixel 			= 0
   Button.Draggable 			      = false
   Button.Position 			      = UDim2.new(0, 0, 0, 0)
   Button.Selectable             = false
   Button.Size 			         = UDim2.new(1, 0, 0, 20)
   Button.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   Button.Style 			         = Enum.FrameStyle.Custom
   Button.Visible                = true
   Button.ZIndex                 = 1
   Button.Archivable             = true

   local ClosedValue = Instance.new('BoolValue')
   ClosedValue.Name     = 'Closed'
   ClosedValue.Value    = false
   ClosedValue.Parent   = Button

   local LabelText = Instance.new('TextLabel')
   LabelText.Name 			         = "LabelText"
   LabelText.AnchorPoint	         = Vector2.new(0, 0)
   LabelText.AutomaticSize	         = Enum.AutomaticSize.None
   LabelText.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
   LabelText.BackgroundTransparency = 1
   LabelText.BorderColor3           = Color3.fromRGB(27, 42, 53)
   LabelText.BorderMode 			   = Enum.BorderMode.Outline
   LabelText.BorderSizePixel 			= 0
   LabelText.Position 			      = UDim2.new(0, 0, 0, 0)
   LabelText.Selectable             = false
   LabelText.Size 			         = UDim2.new(1, 0, 1, 0)
   LabelText.SizeConstraint 			= Enum.SizeConstraint.RelativeXY
   LabelText.Visible                = true
   LabelText.ZIndex                 = 1
   LabelText.Archivable             = true
   LabelText.Font                   = Enum.Font.SourceSans
   LabelText.LineHeight             = 1
   LabelText.RichText               = false
   LabelText.Text                   = 'Close Controls'
   LabelText.TextColor3 			   = Color3.new(238, 238, 238)
   LabelText.TextScaled             = false
   LabelText.TextSize               = 14
   LabelText.TextStrokeColor3 		= Color3.new(0, 0, 0)
   LabelText.TextStrokeTransparency = 1
   LabelText.TextTransparency       = 0
   LabelText.TextTruncate           = Enum.TextTruncate.AtEnd
   LabelText.TextWrapped            = false
   LabelText.TextXAlignment         = Enum.TextXAlignment.Center
   LabelText.TextYAlignment         = Enum.TextYAlignment.Center
   LabelText.Parent = Button

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------   

   local hover = false

   table.insert(connections, Button.MouseEnter:Connect(function()
      hover = true
   end))

   table.insert(connections, Button.MouseMoved:Connect(function()
      hover = true
   end))

   table.insert(connections, Button.MouseLeave:Connect(function()
      hover = false
   end))

   table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
      if hover and input.UserInputType == Enum.UserInputType.MouseButton1 then
         ClosedValue.Value = not ClosedValue.Value
      end
   end))

   table.insert(connections, ClosedValue.Changed:connect(function()
      if ClosedValue.Value then
         LabelText.Text = "Open Controls"
      else
         LabelText.Text = "Close Controls"
      end
   end))

   return Button
end


-- controllers
local ColorController			= require(script:WaitForChild("ColorController"))
local OptionController 			= require(script:WaitForChild("OptionController"))
local StringController 			= require(script:WaitForChild("StringController"))
local BooleanController 		= require(script:WaitForChild("BooleanController"))
local NumberController 			= require(script:WaitForChild("NumberController"))
local FunctionController 		= require(script:WaitForChild("FunctionController"))
local NumberSliderController	= require(script:WaitForChild("NumberSliderController"))
local Vector3Controller			= require(script:WaitForChild("Vector3Controller"))
local Vector3SliderController	= require(script:WaitForChild("Vector3SliderController"))

-- detach (remove template from UI)

script:WaitForChild("TEMPLATE").Enabled = false

-- @TODO: create controllers for the most used classes
-- https://developer.roblox.com/en-us/api-reference/data-types
-- https://roblox.fandom.com/wiki/List_of_classes_by_category

-- A lightweight controller library for Roblox. It allows you to easily 
-- manipulate variables and fire functions on the fly.
local GUI = {}
GUI.__index = GUI

GUI.DEFAULT_WIDTH = 250

-- defines the control or GUI that has mastery over UI events
local function lockUI(gui, controller)
	
	local root = gui.getRoot()	
	
	if root.LockedController and root.LockedController ~= controller then
		root.LockedControllerNext = controller
		
		-- remove next lock after timeout
		spawn(function()
			wait(0.1)
			if root.LockedControllerNext == controller then
				root.LockedControllerNext = nil
			end
		end)
	elseif root.LockedController == nil then
		root.LockedController = controller		
		
		local function iterate(gui)	
			local locked = false
			for index = 1, #gui.children do
				local child = gui.children[index]
				if child.isGui then
					-- ignore if parent is closed
					if child.closed ~= false then
						if iterate(child) then
							-- set folder z-index
							locked = true
							child.frame.ZIndex 	 = 100	
							child.UILocked.Value 	= "ACTIVE"
						else
							child.UILocked.Value = "LOCKED"
						end
					else
						child.UILocked.Value = "LOCKED"
					end
					
				else
					if child ~= controller then
						-- Lock others
						child.frame.ZIndex 	 = 1
						child.UILocked.Value = "LOCKED"
					else
						-- Activate this	
						child.frame.ZIndex  	= 100
						child.UILocked.Value 	= "ACTIVE"
						locked = true
					end
				end
			end

			return locked
		end
		
		iterate(root)
	end
end

-- faz o unlock da controller ativa apenas quando ela solicita
local function unlockUI(gui, controller)
	
	local root = gui.getRoot()	
	
	if root.LockedController ~= nil and  root.LockedController ~= controller then		
		-- relock, only the locked component can remove the lock
		controller.frame.ZIndex  	= 1
		controller.UILocked.Value 	= "LOCKED"
		return
	end
	
	root.LockedController = nil
	
	local function iterate(gui)	
		for index = 1, #gui.children do
			local child = gui.children[index]
			
			-- reset folder and controller z-index
			child.frame.ZIndex = 1
			
			if child.isGui then
				-- dont ignores closed
				child.UILocked.Value = "ACTIVE"
				iterate(child)
			else
				child.UILocked.Value 	= "LOCKED"
			end
		end
	end
	
	iterate(root)
	
	-- has next?		
	if root.LockedControllerNext ~= nil and  root.LockedControllerNext ~= controller then	
		local nextCtrl = root.LockedControllerNext
		root.LockedControllerNext = nil
		lockUI(gui, nextCtrl)			
	end
end

-- defines the control or GUI that has mastery over UI events
local function lockAllUI(gui)
	-- controller.UILocked
	local root = gui.getRoot()
	
	root.LockedController = nil
	root.LockedControllerNext = nil
	
	local function iterate(gui)	
		for index = 1, #gui.children do
			local child = gui.children[index]
			if child.isGui then
				iterate(child)
				
			else
				child.UILocked.Value = "LOCKED"
			end
		end
	end
	
	iterate(root)
end

-- iterate across all elements to define their relative positions
local function resize(gui)
	
	local root = gui.getRoot()
	
	lockAllUI(root)
	
	local function iterate(gui, pos)
		
		if gui.closed.Value == false then
			for index = 1, #gui.children do
				local child = gui.children[index]
				child.frame.Position = UDim2.new(0, 0, 0, pos)
				
				if child.isGui then
					local childHeight = iterate(child, 0)
					pos += childHeight
				else
					pos += child.height
				end
			end
		end
		
		if root == gui then
			gui.frame.Size = UDim2.new(0, gui.width, 0, pos)
		else
			-- title height
			pos += gui.frameTitle.Size.Y.Offset
		end	
		
		return pos
	end
	
	iterate(root, 20)
	
	-- scroll	
	
	local contentSize 		= root.frame.AbsoluteSize.Y
	local screenSize 		   = Camera.ViewportSize.Y
	local closeButtonSize   = root.closeButton.AbsoluteSize.Y
	if contentSize > screenSize - closeButtonSize then
		
		-- scroll
		local totalContentSize 		= root.frame.Size.Y.Offset
		root.content.Size 			= UDim2.new(1, 0, 0, totalContentSize)		
		root.frame.Size 			   = UDim2.new(0, root.width, 0, screenSize)
		local maxPosition			   = -(totalContentSize - screenSize)	
		
		-- animate to new position, if needed
		if root.content.Position.Y.Offset ~= 0 then
			
			local newPosition = math.min(math.max(root.content.Position.Y.Offset, maxPosition), 0)
			
			if root.ScrollTween ~= nil then
				root.ScrollTween:Cancel()
			end
			
			root.ScrollTween = TweenService:Create(root.content, TweenInfo.new(0.2, Enum.EasingStyle.Quint,Enum.EasingDirection.Out), { 
				Position =  UDim2.new(0, 0, 0, newPosition)		 
			})
			
			root.ScrollTween:Play()
			
			root.ScrollContentPosition.Value = -newPosition
		end
		
		ContextActionService:BindAction("dat.GUI.Scroll",  function(actionName, inputState, input)
			if input.UserInputType == Enum.UserInputType.MouseWheel and input.UserInputState == Enum.UserInputState.Change and root.HOVER then 
				
				local newPosition = math.min(math.max(root.content.Position.Y.Offset + (input.Position.Z*50), maxPosition), 0)
				
				if root.ScrollTween ~= nil then
					root.ScrollTween:Cancel()
				end
				
				root.ScrollTween = TweenService:Create(root.content, TweenInfo.new(0.2, Enum.EasingStyle.Quint,Enum.EasingDirection.Out), { 
					Position =  UDim2.new(0, 0, 0, newPosition)		 
				})
				
				root.ScrollTween:Play()
				
				root.ScrollContentPosition.Value = -newPosition
				
				return Enum.ContextActionResult.Sink
			end
			
			return Enum.ContextActionResult.Pass
		end,  false,  Enum.UserInputType.MouseWheel)
	else
		root.ScrollContentPosition.Value = 0
		root.content.Size 					= UDim2.new(1, 0, 1, 0)
		root.closeButton.Position 			= UDim2.new(0, 0, 0, 0)
		
		if root.content.Position.Y.Offset ~= 0 then
			-- scroll to top
			if root.ScrollTween ~= nil then
				root.ScrollTween:Cancel()
			end		
			root.ScrollTween = TweenService:Create(root.content, TweenInfo.new(0.2, Enum.EasingStyle.Quint,Enum.EasingDirection.Out), { 
				Position =  UDim2.new(0, 0, 0, 0)		 
			})		
			root.ScrollTween:Play()
		end
		
		-- remove events
		ContextActionService:UnbindAction("dat.GUI.Scroll")
	end
	
	root.ScrollContentSize.Value	= contentSize
	root.ScrollFrameSize.Value    = root.frame.AbsoluteSize.Y
end


--[[
Constructor, Example: "local gui = dat.GUI.new({name = 'My GUI'})"

Params:
	[params]			Object		
	[params.name]		String			The name of this GUI.
	[params.load]		Object			JSON object representing the saved state of this GUI.
	[params.parent]		dat.gui.GUI		The GUI I'm nested in.
	[params.autoPlace]	Boolean	true	
	[params.hideable]	Boolean	true	If true, GUI is shown/hidden by h keypress.
	[params.closed]		Boolean	false	If true, starts closed
	[params.closeOnTop]	Boolean	false	If true, close/open button shows on top of the GUI
]]
function GUI.new(params)
	
	-- remove game UI
	game.StarterGui:SetCore("TopbarEnabled", false)
	
	if params == nil then
		params = {}
	end
	
	local gui = {
		isGui 		= true,
		parent 		= params.parent,
		_name 		= params.name,
		width 		= GUI.DEFAULT_WIDTH,
		children 	= {},
		connections = {},
	}
	
	if params == nil then
		params = {}
	end
	
	if gui.parent == nil then
		gui.GUI = Instance.new("ScreenGui")
		gui.GUI.Name 			= "dat.GUI"
		gui.GUI.IgnoreGuiInset	= true -- fullscreen
		gui.GUI.ZIndexBehavior 	= Enum.ZIndexBehavior.Sibling
		gui.GUI.Parent 			= PlayerGui
		
		gui.frame  = Instance.new("Frame")
		gui.frame.Name 						= "root"		
		gui.frame.Size 						= UDim2.new(0, gui.width, 0, 0)		
		gui.frame.Position					= UDim2.new(1, -(gui.width +15), 0, 0)
		gui.frame.BackgroundTransparency = 1
		gui.frame.Parent = gui.GUI
		
		gui.content   = Instance.new("Frame")
		gui.content.Name 					      = "content"		
		gui.content.Size 					      = UDim2.new(1, 0, 1, 0)
		gui.content.Position 				   = UDim2.new(0, 0, 0, 20)
		gui.content.BackgroundTransparency  = 1
		gui.content.Parent = gui.frame
		
		-- scrollbar
		local scrollbar            = CreateGUIScrollbar(gui.connections)	
		gui.ScrollFrameSize 		   = scrollbar:WaitForChild("FrameSize")	
		gui.ScrollContentSize 		= scrollbar:WaitForChild("ContentSize")	
		gui.ScrollContentPosition 	= scrollbar:WaitForChild("ContentPosition")			
		scrollbar.Parent = gui.frame
		
		-- Global close button
		gui.closeButton = CreateGUICloseButton(gui.connections);
		gui.closeButton.Parent = gui.frame
		
		gui.closed = gui.closeButton:WaitForChild("Closed")	
		
		-- used for scroll
		gui.frame.MouseEnter:Connect(function()
			gui.HOVER = true
		end)
		
		gui.frame.MouseLeave:Connect(function()
			gui.HOVER = false
		end)
		
		-- on resize screen, resize gui		
		local onResize = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			resize(gui)
		end)
		
		table.insert(gui.connections, onResize)
		
	else	
		gui.frame = CreateGUIFolder(gui.connections)
		gui.frame.Name 						   = "folder_"..gui._name
		gui.frameTitle 						   = gui.frame:WaitForChild("title")
		gui.frame.BackgroundTransparency 	= 1	
		gui.frame.Parent = gui.parent.content
		
		gui.content    = gui.frame:WaitForChild("content")		
		gui.closed 	   = gui.frame:WaitForChild("Closed")
		gui.UILocked   = gui.frame:WaitForChild("UILocked")
		
		local Label = gui.frame:WaitForChild("Label")
		Label.Value = gui._name
	end
	
	--resizable: params.autoPlace,
	--hideable: params.autoPlace
	--closeOnTop: false,
	--autoPlace: true,
	
	-- On close/open
	gui.closed.Changed:connect(function()		
		gui.content.Visible = not gui.closed.Value
		resize(gui)
	end)	
	
	--[[
	Adds a new Controller to the GUI. The type of controller created is inferred from the 
	initial value of object[property]. For color properties, see addColor.

	Returns: Controller - The controller that was added to the GUI.

	Params:
		object	Object	The object to be manipulated
		property	String	The name of the property to be manipulated
		[min]	Number	Minimum allowed value
		[max]	Number	Maximum allowed value
		[step]	Number	Increment by which to change value
		
	Examples:
		Add a string controller.
			gui:add({name = 'Sam'}, 'name')
			
		Add a number controller slider.
			gui:add({age = 45}, 'age', 0, 100)
	]]
	function gui.add(object, property, ...)
		
		if object[property] == nil then
			error("Object has no property ".. property)
		end		
		
		local controller
		local initialValue 		= object[property];
		local initialValueType 	= typeof(initialValue)
		local arguments 		= {...}
		
		if initialValueType == "Vector3" then
			
			local min = arguments[1]
			local max = arguments[2]
			local step = arguments[3]
			
			-- Has min and max? (slider)
			if min ~= nil and max ~= nil then
				controller = Vector3SliderController(gui, object, property, min, max, step);
			else
				controller = Vector3Controller(gui, object, property, min, max, step);
			end
			
		elseif initialValueType == "Color3" then
			controller = ColorController(gui, object, property)
			
		elseif initialValueType == "EnumItem" or (arguments[1] ~= nil and typeof(arguments[1]) == "Enum") then
			-- Enum options
			controller = OptionController(gui, object, property, arguments[1])
			
		else
			-- @TODO: Vector3, CFRAME, UDIM2		
			if arguments[1] ~= nil and type(arguments[1]) == "table" then
				-- Providing options
				controller = OptionController(gui, object, property, arguments[1])
				
			else			
				if (initialValueType == "number") then
					
					local min = arguments[1]
					local max = arguments[2]
					local step = arguments[3]
					
					-- Has min and max? (slider)
					if min ~= nil and max ~= nil and type(min) == "number" and type(max) == "number" then
						controller = NumberSliderController(gui, object, property, min, max, step);
					else
						controller = NumberController(gui, object, property, min, max, step);
					end
					
				elseif (initialValueType == "boolean") then
					controller = BooleanController(gui, object, property);
					
				elseif (initialValueType == "string") then
					controller = StringController(gui, object, property);
					
				elseif (type(initialValue) == "function") then
					controller = FunctionController(gui, object, property, arguments[1]);
					
				end			
			end
		end		
		
		if controller == nil then
			return error("It was not possible to identify the controller builder, check the parameters")
		end
		
		table.insert(gui.children, controller)
		
		-------------------------------------------------------------------------------
		-- UI Lock mechanism
		-- @see https://devforum.roblox.com/t/guis-sink-input-even-when-covered/343684
		-------------------------------------------------------------------------------
		local frame = controller.frame
		frame.Name 		= property
		controller._name = property
		
		local UILocked
		
		-- Indicates locked state UNLOCK, ACTIVE, LOCKED
		if frame:FindFirstChild("UILocked") == nil then
			UILocked = Instance.new("StringValue")
			UILocked.Name = "UILocked"
			UILocked.Parent = frame			
		end
		
		UILocked = controller.frame:WaitForChild("UILocked")
		UILocked.Value = "LOCKED"
		
		controller.UILocked = UILocked
		
		-- On mouse enter, try to register in the lock queue 	
		frame.MouseEnter:Connect(function()
			if not controller._isReadonly then
				lockUI(gui, controller)
			end			
		end)
		
		-- On mouse move, try to register in the lock queue 
		frame.MouseMoved:Connect(function()
			if not controller._isReadonly then
				lockUI(gui, controller)
			end
		end)
		
		UILocked.Changed:connect(function()			
			if UILocked.Value == "UNLOCK" then
				-- try to unlock
				unlockUI(gui, controller)	
			end
			
			if controller._isReadonly then
				frame.BackgroundColor3 = BG_COLOR_OFF
				
			else
				if UILocked.Value == "ACTIVE" then
					frame.BackgroundColor3 = BG_COLOR_ON
				else				
					frame.BackgroundColor3 = BG_COLOR_OFF
				end
			end
		end)
		
		frame.BackgroundColor3 = BG_COLOR_OFF
		
		-------------------------------------------------------------------------------
		
		
		-- adds readonly/disabled method
		controller._isReadonly = false
		controller.readonly = function(option)
			if option == nil then
				option = true
			end
			
			controller._isReadonly = option
			
			if controller.label ~= nil then
				if controller._isReadonly then
					local lineThrough = Instance.new('Frame')
					lineThrough.Size = UDim2.new(0, controller.label.TextBounds.X, 0, 1)
					lineThrough.Position = UDim2.new(0, 0, 0.5, 0)
					lineThrough.BackgroundColor3 = LABEL_COLOR_DISABLED
					lineThrough.BackgroundTransparency = 0.4
					lineThrough.BorderSizePixel = 0
					lineThrough.Name = "LineThrough"
					lineThrough.Parent = controller.label
					
					controller.label.TextColor3 = LABEL_COLOR_DISABLED					
				else
					controller.label.TextColor3 = LABEL_COLOR_ENABLED					
					if controller.label:FindFirstChild("LineThrough") ~= nil then
						controller.label:FindFirstChild("LineThrough").Parent = nil
					end
				end
			end
			
			return controller
		end
		
		-- container.appendChild(name);
		-- gui.__controllers.push(controller);
		resize(gui)
		
		return controller
	end
	
	--[[
	Creates a new subfolder GUI instance.
	
	Returns: dat.GUI - The new folder.
	
	Params:
		name String The new folder.
		
	Error:
		if this GUI already has a folder by the specified name
	]]
	function gui.addFolder(name)
		
		-- We have to prevent collisions on names in order to have a key 
		-- by which to remember saved values (@TODO Future implementation, save as JSON)
		for index = 1, #gui.children do
			local child = gui.children[index]
			if child.isGui and child._name == name then
				error("You already have a folder in this GUI by the name \""..name.."\"");
			end
		end
		
		local folder = GUI.new({
			name = name, 
			parent = gui
		})
		
		table.insert(gui.children, folder)
		
		resize(gui)
		
		return folder
	end	
	
	--[[
	Removes the GUI from the game and unbinds all event listeners.
	]]
	function gui.remove()
		lockAllUI(gui)
		
		for index = 1, #gui.children do
			-- folders and controllers
			gui.children[index].remove()
		end
		
		if gui.parent ~= nil then
			gui.parent.removeChild(gui)
		end
		
		for index = 1, #gui.connections do
			gui.connections[index]:Disconnect()
		end
		
		if gui.GUI ~= nil then
			gui.GUI.Parent = nil
			gui.GUI = nil
		end
		
		if gui.frame ~= nil then
			gui.frame.Parent = nil
			gui.frame = nil
		end
		
		if gui.content ~= nil then
			gui.content.Parent = nil
			gui.content = nil
		end
		
		if gui.closeButton ~= nil then
			gui.closeButton.Parent = nil
			gui.closeButton = nil
		end
		
		-- clear all references
		gui.children = {}
		gui.connections = {}
		gui.ScrollFrameSize = nil
		gui.ScrollContentSize = nil
		gui.ScrollContentPosition = nil
		gui.closed = nil
		
		-- finally
		gui = nil
	end
	
	--[[
	Removes the given controller/folder from the GUI.

	Params:
		controller	Controller
	]]
	function gui.removeChild(item)
		local itemIdx = -1
		for index = 1, #gui.children do
			local child = gui.children[index]
			if child == item then
				child.frame.Parent = nil
				break
			end
		end
		
		if itemIdx > 0 then
			table.remove(gui.children, itemIdx)
		end
		
		resize(gui)
		
		return gui
	end
	
	-- Opens the GUI
	function gui.open()
		gui.closed.Value = false
		return gui
	end
	
	-- Closes the GUI
	function gui.close()
		gui.closed.Value = true
		return gui
	end
	
	function gui.setWidth(width)
		if gui.parent == nil then			
			gui.width = width			
			gui.frame.Size		= UDim2.new(0, gui.width, 0, 0)		
			gui.frame.Position  = UDim2.new(1, -(gui.width +15), 0, 0)
			
			resize(gui)
		end
		
		return gui
	end	
	
	-- Returns: dat.GUI - the topmost parent GUI of a nested GUI.
	function gui.getRoot()
		local g = gui;
		while g.parent ~= nil do
			g = g.parent;
		end
		return g;
	end
	
	return gui
end

return GUI
