--[[
    batteries for lua

    a collection of helpful code to get your project off the ground faster
]]

local path = ...
local function require_relative(p)
    return require(table.concat({ path, p }, "."))
end

local _batteries =
{
    class = require_relative("class"),
    assert = require_relative("assert"),
    mathx = require_relative("mathx"),
    tablex = require_relative("tablex"),
    vec2 = require_relative("vec2"),
    timer = require_relative("timer"),
    colour = require_relative("colour"),
    pretty = require_relative("pretty"),
    make_pooled = require_relative("make_pooled"),
    sort = require_relative("sort"),
    stringx = require_relative("stringx"),
    functional = require_relative("functional"),
    intersect = require_relative("intersect"),
    state_machine = require_relative("state_machine"),
}

--assign aliases
for _, alias in ipairs({
    { "mathx",   "math" },
    { "tablex",  "table" },
    { "stringx", "string" },
    { "sort",    "stable_sort" },
    { "colour",  "color" },
}) do
    _batteries[alias[2]] = _batteries[alias[1]]
end

--easy export globally if required
function _batteries:export()
    for k, v in pairs(self) do
        if _G[k] == nil then
            _G[k] = v
        end
    end

    self.tablex.shallow_overlay(table, self.tablex)
    self.tablex.shallow_overlay(table, self.functional)
    self.sort:export()

    table.shallow_overlay(math, self.mathx)
    table.shallow_overlay(string, self.stringx)

    assert = self.assert
    ripairs = self.tablex.ripairs

    batteries = self
    return self
end

return _batteries
