local states = {}
local files = love.filesystem.getDirectoryItems("states")

for _, file in ipairs(files) do
    if file:match("%.lua$") then
        local name = file:gsub("%.lua$", "")

        if name ~= "init" then
            states[name] = require("states." .. name)
        end
    end
end

return state_machine(states, "intro")
