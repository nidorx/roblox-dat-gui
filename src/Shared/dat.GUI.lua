--[[
   Roblox-dat.GUI v1.2.2 [2021-04-10 02:50]

   A lightweight graphical user interface and controller library. 
   
   Roblox dat.GUI allows you to easily manipulate variables and fire functions on 
   the fly, inspired by the venerable dat-gui.

   dat.GUI magically generates a graphical user interface (sliders, 
   color selector, etc) for each of your variables.

   https://github.com/nidorx/roblox-dat-gui

   Discussions about this script are at https://devforum.roblox.com/t/817209

   ------------------------------------------------------------------------------

   MIT License

   Copyright (c) 2021 Alex Rodin

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in all
   copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.
]]
local Camera 	            = workspace.CurrentCamera
local TweenService 		   = game:GetService("TweenService")
local GUIUtils             = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("GUI"))
local Constants            = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Constants"))
local Misc                 = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Misc"))


-- controllers
local Controllers             = game.ReplicatedStorage:WaitForChild("Controllers")
local ColorController			= require(Controllers:WaitForChild("ColorController"))
local OptionController 			= require(Controllers:WaitForChild("OptionController"))
local StringController 			= require(Controllers:WaitForChild("StringController"))
local BooleanController 		= require(Controllers:WaitForChild("BooleanController"))
local NumberController 			= require(Controllers:WaitForChild("NumberController"))
local FunctionController 		= require(Controllers:WaitForChild("FunctionController"))
local NumberSliderController	= require(Controllers:WaitForChild("NumberSliderController"))
local Vector3Controller			= require(Controllers:WaitForChild("Vector3Controller"))
local Vector3SliderController	= require(Controllers:WaitForChild("Vector3SliderController"))

local Constants         = require(game.ReplicatedStorage:WaitForChild("Utils"):WaitForChild("Constants"))

local BG_COLOR_ON 			= Color3.fromRGB(17, 17, 17)
local LABEL_COLOR_DISABLED	= Color3.fromRGB(136, 136, 136)

local SCROLL_WIDTH   = 5
local HEADER_SIZE    = 20

local MIN_WIDTH   = 250
local MAX_WIDTH   = 600
local MIN_HEIGHT  = HEADER_SIZE

local function CreateGUIFolder(connections)

   local Folder = GUIUtils.CreateFrame()
   Folder.Name 			         = "Folder"
   Folder.BackgroundTransparency = 1
   Folder.Size 			         = UDim2.new(1, 0, 0, 30)

   local LabelValue = Instance.new('StringValue')
   LabelValue.Name = 'Label'
   LabelValue.Parent = Folder

   local Closed = Instance.new('BoolValue')
   Closed.Name     = 'Closed'
   Closed.Value    = false
   Closed.Parent   = Folder

   local borderBottom = GUIUtils.CreateFrame()
   borderBottom.Name 			         = "BorderBottom"
   borderBottom.BackgroundColor3       = Constants.BORDER_COLOR
   borderBottom.Position 			      = UDim2.new(0, 0, 1, -1)
   borderBottom.Size 			         = UDim2.new(1, 0, 0, 1)
   borderBottom.ZIndex                 = 2
   borderBottom.Parent = Folder

   local Content = GUIUtils.CreateFrame()
   Content.Name 			            = "Content"
   Content.BackgroundTransparency   = 1
   Content.Position 			         = UDim2.new(0, 5, 1, 0)
   Content.Size 			            = UDim2.new(1, -5, 0, 100)
   Content.Parent = Folder

   local Title = GUIUtils.CreateFrame()
   Title.Name 			            = "Title"
   Title.BackgroundColor3        = Constants.FOLDER_COLOR
   Title.Size 			            = UDim2.new(1, 0, 0, 30)
   Title.Parent = Folder

   local LabelText = GUIUtils.CreateLabel()
   LabelText.Position 			      = UDim2.new(0, 16, 0, 0)
   LabelText.Size 			         = UDim2.new(1, -16, 1, -1)
   LabelText.Parent = Title

   local Chevron = GUIUtils.CreateImageLabel(Constants.ICON_CHEVRON)
   Chevron.Name 			            = "Chevron"
   Chevron.Position 			         = UDim2.new(0, 6, 0.5, -3)
   Chevron.Size 			            = UDim2.new(0, 5, 0, 5)
   Chevron.ImageColor3              = Constants.LABEL_COLOR
   Chevron.Rotation                 = 90
   Chevron.Parent = Title

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------

   table.insert(connections, GUIUtils.OnClick(Title, function(el, input)
      Closed.Value = not Closed.Value
   end))

   table.insert(connections, Closed.Changed:connect(function()
      if Closed.Value then
         Chevron.Rotation = 0
      else
         Chevron.Rotation = 90
      end
   end))

   table.insert(connections, LabelValue.Changed:connect(function()
      LabelText.Text = LabelValue.Value
   end))

   return Folder
end

local function CreateGUIScrollbar(connections)
   local Scrollbar = GUIUtils.CreateFrame()
   Scrollbar.Name 			         = "Scrollbar"
   Scrollbar.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
   Scrollbar.BackgroundTransparency = 0
   Scrollbar.Position 			      = UDim2.new(1, -SCROLL_WIDTH, 0, 0)
   Scrollbar.Size 			         = UDim2.new(0, SCROLL_WIDTH, 1, 0)

   local Thumb = GUIUtils.CreateFrame()
   Thumb.Name 			            = "thumb"
   Thumb.BackgroundColor3        = Color3.fromRGB(103, 103, 103)
   Thumb.BackgroundTransparency  = 0
   Thumb.Position 			      = UDim2.new(0, 0, 0.24, 0)
   Thumb.Size 			            = UDim2.new(1, 0, 0.2, 0)
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

--[[
   Cria o cabeçalho do GUI
]]
local function CreateHeader(gui, params)
   local Header = GUIUtils.CreateFrame()
   Header.Name 			         = "Header"
   Header.BackgroundColor3       = Constants.FOLDER_COLOR
   Header.BackgroundTransparency = 0
   Header.Size 			         = UDim2.new(1, -SCROLL_WIDTH, 0, HEADER_SIZE)

   local ClosedValue = Instance.new('BoolValue')
   ClosedValue.Name     = 'Closed'
   ClosedValue.Value    = false
   ClosedValue.Parent   = Header

   local LabelText = GUIUtils.CreateLabel()
   LabelText.Text                   = gui._name
   LabelText.TextXAlignment         = Enum.TextXAlignment.Center
   LabelText.Parent = Header

   -- SCRIPTS ----------------------------------------------------------------------------------------------------------   

   local hover = false

   table.insert(gui.connections, Header.MouseEnter:Connect(function()
      hover = true
   end))

   table.insert(gui.connections, Header.MouseMoved:Connect(function()
      hover = true
   end))

   table.insert(gui.connections, Header.MouseLeave:Connect(function()
      hover = false
   end))

   table.insert(gui.connections, ClosedValue.Changed:connect(function()
      if ClosedValue.Value then
         gui.frame.BackgroundTransparency = 1
      else
         gui.frame.BackgroundTransparency = 0.9
      end
   end))

   -- resize
   if params.resizable ~= false then
      local Resize = GUIUtils.CreateFrame()
      Resize.Name 			            = "Resize"
      Resize.BackgroundTransparency   = 0
      Resize.Size 			            = UDim2.new(0, HEADER_SIZE, 0, HEADER_SIZE)
      Resize.Position 			         = UDim2.new(0, 0, 0, 0)
      Resize.Parent = Header

      local ResizeIcon = GUIUtils.CreateImageLabel(Constants.ICON_RESIZE)
      ResizeIcon.Parent = Resize

      local isHover        = false
      local frameSizeStart = nil
      local framePosStart  = nil

      local function update()
         if frameSizeStart then 
            -- isDragging
            Resize.BackgroundColor3 = Constants.NUMBER_COLOR
            ResizeIcon.ImageColor3 	 = Constants.LABEL_COLOR
         elseif isHover then
            Resize.BackgroundColor3 = Constants.NUMBER_COLOR_HOVER
            ResizeIcon.ImageColor3 	 = Constants.LABEL_COLOR
         else
            Resize.BackgroundColor3 = Constants.FOLDER_COLOR
            ResizeIcon.ImageColor3 	 = Constants.FOLDER_COLOR
         end
      end

      table.insert(gui.connections, GUIUtils.OnHover(Resize, function(hover)
         isHover = hover
         update()
      end))

      table.insert(gui.connections, GUIUtils.OnDrag(Resize, function(el, event, startPos, position, delta)
         if event == 'start' then
            frameSizeStart = Vector2.new(gui.frame.Size.X.Offset, gui.frame.Size.Y.Offset)
            
         elseif event == 'end' then
            frameSizeStart = nil
         elseif event == 'drag' then
            local frameSize = frameSizeStart - delta
            gui.resize(frameSize.X, frameSize.Y)
         end
         update()
      end))

      update()
   end

   -- drag
   if params.fixed == false then

      local Drag = GUIUtils.CreateFrame()
      Drag.Name 			            = "Drag"
      Drag.BackgroundTransparency   = 0
      Drag.Size 			            = UDim2.new(0, HEADER_SIZE, 0, HEADER_SIZE)

      if params.resizable ~= false then 
         Drag.Position = UDim2.new(0, HEADER_SIZE, 0, 0)
      else
         Drag.Position  = UDim2.new(0, 0, 0, 0)
      end

      Drag.Parent = Header

      local DragIcon = GUIUtils.CreateImageLabel(Constants.ICON_DRAG)
      DragIcon.Parent   = Drag

      local isHover        = false
      local framePosStart  = nil

      local function update()
         if framePosStart then 
            -- isDragging
            Drag.BackgroundColor3 = Constants.NUMBER_COLOR
            DragIcon.ImageColor3 	 = Constants.LABEL_COLOR
         elseif isHover then
            Drag.BackgroundColor3 = Constants.NUMBER_COLOR_HOVER
            DragIcon.ImageColor3 	 = Constants.LABEL_COLOR
         else
            Drag.BackgroundColor3 = Constants.FOLDER_COLOR
            DragIcon.ImageColor3 	 = Constants.FOLDER_COLOR
         end
      end

      table.insert(gui.connections, GUIUtils.OnHover(Drag, function(hover)
         isHover = hover
         update()
      end))

      table.insert(gui.connections, GUIUtils.OnDrag(Drag, function(el, event, startPos, position, delta)
         if event == 'start' then
            framePosStart = Vector2.new(gui.frame.Position.X.Offset, gui.frame.Position.Y.Offset)
         elseif event == 'end' then
            framePosStart = nil
         elseif event == 'drag' then
            local framePos = framePosStart + delta
            gui.move(framePos.X, framePos.Y)
         end
         update()
      end))

      update()
   end

   if params.closeable == true then 
      -- close button
   end

   if params.minimize ~= false then
      table.insert(gui.connections, GUIUtils.OnClick(Header, function(el, input)
         ClosedValue.Value = not ClosedValue.Value
      end))
   end

   return Header
end

-- detach (remove template from UI)

-- @TODO: create controllers for the most used classes
-- https://developer.roblox.com/en-us/api-reference/data-types
-- https://roblox.fandom.com/wiki/List_of_classes_by_category

-- A lightweight controller library for Roblox. It allows you to easily 
-- manipulate variables and fire functions on the fly.
local DatGUI = {}
DatGUI.__index = DatGUI

DatGUI.DEFAULT_WIDTH = MIN_WIDTH

-- iterate across all elements to define their relative positions
local function updateScroll(gui)
	
	local root = gui.getRoot()
	
   -- itera sobre todos os elementos ajustando suas posições relativas e contabilizando o tamanho total do conteúdo
	local function iterate(gui, pos)		
		if gui.closed.Value == false then
			for index = 1, #gui.children do
				local child = gui.children[index]
				child.frame.Position = UDim2.new(0, 0, 0, pos)
				
				if child.isGui then
					local childHeight = iterate(child, 0)
					pos = pos + childHeight
				else
					pos = pos + child.height
				end
			end
		end
		
		if root ~= gui then
			-- title height
			pos = pos + gui.frameTitle.Size.Y.Offset
		elseif not gui.resizedY then
         -- root auto size while not resized by user
         gui.frame.Size = UDim2.new(0, gui.frame.Size.X.Offset, 0, math.min(pos, gui.frame.Parent.AbsoluteSize.Y))
      end
		
		return pos
	end

   -- remove events
   if root._scrollConnection ~= nil then 
      root._scrollConnection:Disconnect()
      root._scrollConnection = nil
   end
	
	local totalContentSize  = iterate(root, HEADER_SIZE)
	local frameSize 		   = root.frame.Size.Y.Offset
	if totalContentSize  > frameSize - HEADER_SIZE then

		-- scroll
		root.Content.Size 			= UDim2.new(1, -SCROLL_WIDTH, 0, totalContentSize)		
		local maxPosition			   = -(totalContentSize - frameSize)	
		
		-- animate to new position, if needed
		if root.Content.Position.Y.Offset ~= 0 then
			
			local newPosition = math.min(math.max(root.Content.Position.Y.Offset, maxPosition), 0)
			
			if root.ScrollTween ~= nil then
				root.ScrollTween:Cancel()
			end
			
			root.ScrollTween = TweenService:Create(root.Content, TweenInfo.new(0.2, Enum.EasingStyle.Quint,Enum.EasingDirection.Out), { 
				Position =  UDim2.new(0, 0, 0, newPosition)		 
			})
			
			root.ScrollTween:Play()
			
			root.ScrollContentPosition.Value = -newPosition
		end

      root._scrollConnection = GUIUtils.OnScroll(root.frame, function(el, input)
         local newPosition = math.min(math.max(root.Content.Position.Y.Offset + (input.Position.Z*50), maxPosition), 0)
				
         if root.ScrollTween ~= nil then
            root.ScrollTween:Cancel()
         end
         
         root.ScrollTween = TweenService:Create(root.Content, TweenInfo.new(0.2, Enum.EasingStyle.Quint,Enum.EasingDirection.Out), { 
            Position =  UDim2.new(0, 0, 0, newPosition)		 
         })
         
         root.ScrollTween:Play()         
         root.ScrollContentPosition.Value = -newPosition
      end)
		
		-- ContextActionService:BindAction("dat.GUI.Scroll",  function(actionName, inputState, input)
		-- 	if input.UserInputType == Enum.UserInputType.MouseWheel and input.UserInputState == Enum.UserInputState.Change and root.HOVER then 
				
		-- 		local newPosition = math.min(math.max(root.Content.Position.Y.Offset + (input.Position.Z*50), maxPosition), 0)
				
		-- 		if root.ScrollTween ~= nil then
		-- 			root.ScrollTween:Cancel()
		-- 		end
				
		-- 		root.ScrollTween = TweenService:Create(root.Content, TweenInfo.new(0.2, Enum.EasingStyle.Quint,Enum.EasingDirection.Out), { 
		-- 			Position =  UDim2.new(0, 0, 0, newPosition)		 
		-- 		})
				
		-- 		root.ScrollTween:Play()
				
		-- 		root.ScrollContentPosition.Value = -newPosition
				
		-- 		return Enum.ContextActionResult.Sink
		-- 	end
			
		-- 	return Enum.ContextActionResult.Pass
		-- end,  false,  Enum.UserInputType.MouseWheel)
	else
		root.ScrollContentPosition.Value = 0
		root.Content.Size 					= UDim2.new(1, -SCROLL_WIDTH, 1, 0)
		root.closeButton.Position 			= UDim2.new(0, 0, 0, 0)
		
		if root.Content.Position.Y.Offset ~= 0 then
			-- scroll to top
			if root.ScrollTween ~= nil then
				root.ScrollTween:Cancel()
			end		
			root.ScrollTween = TweenService:Create(root.Content, TweenInfo.new(0.2, Enum.EasingStyle.Quint,Enum.EasingDirection.Out), { 
				Position =  UDim2.new(0, 0, 0, 0)		 
			})		
			root.ScrollTween:Play()
		end
	end
	
	root.ScrollContentSize.Value	= totalContentSize
	root.ScrollFrameSize.Value    = root.frame.AbsoluteSize.Y
end


--[[
Constructor, Example: "local gui = dat.GUI.new({name = 'My GUI'})"

Params:
   [params]             Object		
	[params.name]		   String			The name of this GUI.
	[params.load]		   Object			JSON object representing the saved state of this GUI.
	[params.parent]		dat.gui.GUI		The GUI I'm nested in.
	[params.autoPlace]	Boolean	true	
	[params.hideable]    Boolean	true	If true, GUI is shown/hidden by h keypress.
	[params.closed]		Boolean	false	If true, starts closed
	[params.closeOnTop]	Boolean	false	If true, close/open button shows on top of the GUI
	[params.resizable]	Boolean	true	
	[params.fixed]	      Boolean	false	If false the panel can be moved
	[params.closeable]	Boolean	false	If false the panel can be moved
]]
function DatGUI.new(params)
	
	-- remove game UI
	game.StarterGui:SetCore("TopbarEnabled", false)
	
	if params == nil then
		params = {}
	end

   local name = params.name
   if name == nil or name == '' then
      name = 'dat.GUI'
   end
	
	local gui = {
		_name 		= name,
      resized     = false,
		isGui 		= true,
		parent 		= params.parent,
		children 	= {},
		connections = {}
	}

   local width = params.width
   if width == nil or width < DatGUI.DEFAULT_WIDTH then 
      width = DatGUI.DEFAULT_WIDTH
   end
	
	if gui.parent == nil then		
		gui.frame  = GUIUtils.CreateFrame()
		gui.frame.Name 						= "root"		
		gui.frame.Size 						= UDim2.new(0, width, 0, 0)		
		gui.frame.Position					= UDim2.new(0, Camera.ViewportSize.X-(width + 15), 0, 0)
		gui.frame.BackgroundTransparency = 0.9
		gui.frame.ClipsDescendants       = true
		gui.frame.Parent                 = Constants.SCREEN_GUI
		
		gui.Content   = GUIUtils.CreateFrame()
		gui.Content.Name 					      = "Content"		
		gui.Content.Size 					      = UDim2.new(1, 0, 1, 0)
		gui.Content.Position 				   = UDim2.new(0, 0, 0, 20)
		gui.Content.BackgroundTransparency  = 1
		gui.Content.Parent = gui.frame
		
		-- scrollbar
		local scrollbar            = CreateGUIScrollbar(gui.connections)	
		gui.ScrollFrameSize 		   = scrollbar:WaitForChild("FrameSize")	
		gui.ScrollContentSize 		= scrollbar:WaitForChild("ContentSize")	
		gui.ScrollContentPosition 	= scrollbar:WaitForChild("ContentPosition")			
		scrollbar.Parent = gui.frame
		
		-- Global close button
		gui.closeButton = CreateHeader(gui, params)
		gui.closeButton.Parent = gui.frame
		
		gui.closed = gui.closeButton:WaitForChild("Closed")	

		-- on resize screen, resize gui
		table.insert(gui.connections, Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			updateScroll(gui)
		end))
	else	
		gui.frame = CreateGUIFolder(gui.connections)
		gui.frame.Name 						   = "folder_"..gui._name
		gui.frameTitle 						   = gui.frame:WaitForChild("Title")
		gui.frame.BackgroundTransparency 	= 1	
		gui.frame.Parent = gui.parent.Content
		
		gui.Content    = gui.frame:WaitForChild("Content")		
		gui.closed 	   = gui.frame:WaitForChild("Closed")
		
		local Label = gui.frame:WaitForChild("Label")
		Label.Value = gui._name
	end
	
	--resizable: params.autoPlace,
	--hideable: params.autoPlace
	--closeOnTop: false,
	--autoPlace: true,
	
	-- On close/open
	gui.closed.Changed:connect(function()		
		gui.Content.Visible = not gui.closed.Value
		updateScroll(gui)
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
		local initialValue 		   = object[property];
		local initialValueType 	   = type(initialValue)
		local initialValueTypeOf   = typeof(initialValue)
      local isInstance           = initialValueTypeOf == "Instance" 
		local arguments 		= {...}
		
		if initialValueTypeOf == "Vector3" or (isInstance and initialValue:IsA('Vector3Value')) then
			
			local min = arguments[1]
			local max = arguments[2]
			local step = arguments[3]

         local isVector3Value = (isInstance and initialValue:IsA('Vector3Value'))
			
			-- Has min and max? (slider)
			if min ~= nil and max ~= nil then
				controller = Vector3SliderController(gui, object, property, min, max, step, isVector3Value)
			else
				controller = Vector3Controller(gui, object, property, min, max, step, isVector3Value)
			end
			
		elseif initialValueTypeOf == "Color3"  or (isInstance and initialValue:IsA('Color3Value')) then
			controller = ColorController(gui, object, property, (isInstance and initialValue:IsA('Color3Value')))
			
		elseif initialValueTypeOf == "EnumItem" or (arguments[1] ~= nil and typeof(arguments[1]) == "Enum") then
			-- Enum options
			controller = OptionController(gui, object, property, arguments[1])
			
		elseif arguments[1] ~= nil and type(arguments[1]) == "table" then
         -- Providing options
         controller = OptionController(gui, object, property, arguments[1])
         
      elseif (initialValueTypeOf == "number" or (isInstance and initialValue:IsA('NumberValue'))) then
            
         local min = arguments[1]
         local max = arguments[2]
         local step = arguments[3]

         local isNumberValue = (isInstance and initialValue:IsA('NumberValue'))
         
         -- Has min and max? (slider)
         if min ~= nil and max ~= nil and type(min) == "number" and type(max) == "number" then
            controller = NumberSliderController(gui, object, property, min, max, step, isNumberValue)
         else
            controller = NumberController(gui, object, property, min, max, step, isNumberValue)
         end
         
      elseif (initialValueTypeOf == "boolean" or (isInstance and initialValue:IsA('BoolValue'))) then
         controller = BooleanController(gui, object, property, (isInstance and initialValue:IsA('BoolValue')))
         
      elseif (initialValueTypeOf == "string" or (isInstance and initialValue:IsA('StringValue'))) then
         local isMultiline = arguments[1] == true
         controller = StringController(gui, object, property, isMultiline, (isInstance and initialValue:IsA('StringValue')))
         
      elseif (type(initialValue) == "function") then
         controller = FunctionController(gui, object, property, arguments[1])
         
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
		
      GUIUtils.OnHover(frame, function(hover)
         if hover then
            frame.BackgroundColor3 = BG_COLOR_ON
         else
            frame.BackgroundColor3 = Constants.BACKGROUND_COLOR
         end
      end)
		
		frame.BackgroundColor3 = Constants.BACKGROUND_COLOR
		
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
					controller.label.TextColor3 = Constants.LABEL_COLOR					
					if controller.label:FindFirstChild("LineThrough") ~= nil then
						controller.label:FindFirstChild("LineThrough").Parent = nil
					end
				end
			end
			
			return controller
		end
		
		-- container.appendChild(name);
		-- gui.__controllers.push(controller);
		updateScroll(gui)
		
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
		
		local folder = DatGUI.new({
			name = name, 
			parent = gui
		})
		
		table.insert(gui.children, folder)
		
		updateScroll(gui)
		
		return folder
	end	
	
	--[[
	   Removes the GUI from the game and unbinds all event listeners.
	]]
	function gui.remove()
      if gui._is_removing_parent then
         return
      end
      
		-- lockAllUI(gui)
		
		for index = table.getn(gui.children), 1, -1  do
			-- folders and controllers
			gui.children[index].remove()
		end
		
		if gui.parent ~= nil then
         -- avoid recursion
         gui._is_removing_parent = true
			gui.parent.removeChild(gui)
		end
		
		for index = 1, #gui.connections do
			gui.connections[index]:Disconnect()
		end
		
		if gui.frame ~= nil then
			gui.frame.Parent = nil
			gui.frame = nil
		end
		
		if gui.Content ~= nil then
			gui.Content.Parent = nil
			gui.Content = nil
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
      if item._is_removing_child == true then
         return
      end

		local itemIdx = -1
		for index = 1, #gui.children do
			local child = gui.children[index]
			if child == item then
            -- avoid recursion
            child._is_removing_child = true

            child.remove()
            itemIdx = index
				-- child.frame.Parent = nil
				break
			end
		end
		
		if itemIdx > 0 then
			table.remove(gui.children, itemIdx)
		end
		
		updateScroll(gui)
		
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
	
   --[[
      Permite redimensionar um root
   ]]
	function gui.resize(width, height)
		if gui.parent == nil then

         if gui.closed.Value then 
            return
         end

         local framePosStart  = Vector2.new(gui.frame.Position.X.Offset, gui.frame.Position.Y.Offset)
         local frameSizeStart = Vector2.new(gui.frame.Size.X.Offset, gui.frame.Size.Y.Offset)
           
         local parentSizeX = gui.frame.Parent.AbsoluteSize.X
         local parentSizeY = gui.frame.Parent.AbsoluteSize.Y

			width = math.clamp(width, math.min(MIN_WIDTH, parentSizeX), math.min(MAX_WIDTH, parentSizeX))
         
         if height ~= nil then
            height = math.clamp(height, math.min(MIN_HEIGHT, parentSizeY), parentSizeY)
            gui.frame.Size	= UDim2.new(0, width, 0, height)
            gui.resizedY = true
         else
            gui.frame.Size	  = UDim2.new(0, width, 0, 0)
         end

         local delta    = Vector2.new(gui.frame.Size.X.Offset, gui.frame.Size.Y.Offset) - frameSizeStart
         local framePos = framePosStart - delta
         gui.move(framePos.X, framePos.Y)

         -- gui.move(gui.frame.Size.X.Offset, gui.frame.Size.Y.Offset)
			
			updateScroll(gui)
		end
		
		return gui
	end

   --[[
      Atualiza a posição da instancia
   ]]
   function gui.move(posX, posY)
		if gui.parent == nil then
         local sizeX = gui.frame.Size.X.Offset
         local sizeY = gui.frame.Size.Y.Offset

         local posMaxX
         local posMaxY

         local frameGui = gui.frame.Parent
         if frameGui:IsA('ScreenGui') then
            posMaxX = frameGui.AbsoluteSize.X - sizeX
            posMaxY = frameGui.AbsoluteSize.Y - sizeY
         else
            -- is a FrameGui
            posMaxX = frameGui.Size.X.Offset - sizeX
            posMaxY = frameGui.Size.Y.Offset - sizeY   
         end
         
         posX = math.clamp(posX, 0, math.max(posMaxX, 0))
         posY = math.clamp(posY, 0, math.max(posMaxY, 0))
         gui.frame.Position  = UDim2.new(0, posX, 0, posY)
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


   -- unlockUI(gui, nil)
	
	return gui
end

return DatGUI
