local hook = { }
hook.registry = { }
hook.add = function(event_name, hooks)
  assert(#hooks > 0, "hooks table must contain at least one entry")
  if not hook.registry[event_name] then
    hook.registry[event_name] = {
      method = love[event_name] or function() end,
      hooks = hooks
    }
  else
    for index = 1, #hooks do
      local _obj_0 = hook.registry[event_name].hooks
      _obj_0[#_obj_0 + 1] = hooks[index]
    end
  end
  for event_name, data in pairs(hook.registry) do
    love[event_name] = function(...)
      data.method(...)
      for index = 1, #data.hooks do
        data.hooks[index](...)
      end
    end
  end
end
return hook
