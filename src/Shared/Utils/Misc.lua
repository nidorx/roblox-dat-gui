local Misc = {}

--[[
   Create an event disconnect function, a pattern used on all controllers
]]
function Misc.DisconnectFn(connections, ...)

   local disconnectFns = {...}

   return function()

      for _, disconnect in ipairs(disconnectFns) do
         disconnect()
      end

      for _, conn in ipairs(connections) do
         conn:Disconnect()
      end

      table.clear(connections)
   end
end

return Misc

