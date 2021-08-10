
-- lib
local Lib = game.ReplicatedStorage:WaitForChild('Lib')
local GUIUtils    = require(Lib:WaitForChild("GUIUtils"))
local Constants   = require(Lib:WaitForChild("Constants"))


--[[
   Allows creation of custom controllers

   @param config {
      frame    = Frame,       The content that will be presented in the controller
      color    = Color3,      The color of the controller's side edge
      height   = number,      the height of the content
      onRemove = function     Invoked when controller is destroyed
      methods  = {            Allows you to add custom methods that can be invoked by the instance
         [Name:String] => function 
      } 
   }

]]
local CustomController = function(gui, name, config)

   if config == nil then 
      config = {} 
   end

   local frame, Control, DisconnectGUI = GUIUtils.createControllerWrapper({
      ['Name']     = name,
      ['Color']    = config.color or Constants.CUSTOM_COLOR,
      ['Height']   = config.height
   })
	frame.Parent = gui.Content

	config.frame.Parent = Control
   config.frame.Position   = UDim2.new(0, 0, 0, 3)
   config.frame.Size       = UDim2.new(1, 0, 1, -6)
	
	local controller = {
		['frame'] = frame,
		['height'] = frame.AbsoluteSize.Y
	}
	
	------------------------------------------------------------------
	-- Public functions
	------------------------------------------------------------------

   if config.methods ~= nil then 
      for method, func in pairs(config.methods) do
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
      
      if type(config.onRemove) == 'function' then
			return config.onRemove()
		end
	end
	
	------------------------------------------------------------------
	-- Set initial values
	------------------------------------------------------------------
	
	return controller
end

return CustomController
