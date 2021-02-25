local Misc = {}

--[[
   Create an event disconnect function, a pattern used on all controllers
]]
function Misc.DisconnectFn(connections, disconnectParent)
   return function()

      if disconnectParent ~= nil then
         disconnectParent()
      end

      for _, conn in ipairs(connections) do
         conn:Disconnect()
      end

      table.clear(connections)
   end
end


return Misc

