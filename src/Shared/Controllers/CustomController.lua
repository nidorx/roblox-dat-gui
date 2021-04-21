
-- lib
local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local GUIUtils          = require(Lib:WaitForChild("GUI"))
local Constants         = require(Lib:WaitForChild("Constants"))


--[[
   Permite a criação de controladores parsonalizadas

   @param config {
      Frame    = Frame,
      Color    = Color3,
      OnRemove = function
      Height   = number,
      Methods  = { [Name:String] => function }
   }

]]
local CustomController = function(gui, name, config)

   if config == nil then 
      config = {} 
   end

   local frame, Control, DisconnectGUI = GUIUtils.CreateControllerWrapper({
      Name     = name,
      Color    = config.Color or Constants.CUSTOM_COLOR,
      Height   = config.Height
   })
	frame.Parent = gui.Content

	config.Frame.Parent = Control
	
	local labelValue 	= frame:WaitForChild("Label")
	
	local controller = {
		frame = frame,
		label = frame:WaitForChild("LabelText"),
		height = frame.AbsoluteSize.Y
	}
	
	------------------------------------------------------------------
	-- Public functions
	------------------------------------------------------------------

   if config.Methods ~= nil then 
      for method, func in pairs(config.Methods) do
         controller[method] = func
      end
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

      if type(config.OnRemove) == 'funtion' then
			return config.OnRemove()
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
	labelValue.Value = name
	
	return controller
end

return CustomController
