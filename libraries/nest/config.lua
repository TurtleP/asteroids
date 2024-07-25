Console = {
  NINTENDO_3DS = "ctr",
  NINTENDO_SWITCH = "hac",
  NINTENDO_WIIU = "cafe"
}
TVScanMode = {
  TV_SCAN_MODE_480p = "480p",
  TV_SCAN_MODE_720p = "720p",
  TV_SCAN_MODE_1080p = "1080p"
}
local DEFAULT = {
  scale = 1,
  console = Console.NINTENDO_3DS,
  emulate_joystick = true,
  mode = TVScanMode.TV_SCAN_MODE_720p
}
local config = { }
config.current = nil
config.update = function(user_config)
  do
    local _tab_0 = { }
    local _idx_0 = 1
    for _key_0, _value_0 in pairs(DEFAULT) do
      if _idx_0 == _key_0 then
        _tab_0[#_tab_0 + 1] = _value_0
        _idx_0 = _idx_0 + 1
      else
        _tab_0[_key_0] = _value_0
      end
    end
    local _idx_1 = 1
    for _key_0, _value_0 in pairs(user_config) do
      if _idx_1 == _key_0 then
        _tab_0[#_tab_0 + 1] = _value_0
        _idx_1 = _idx_1 + 1
      else
        _tab_0[_key_0] = _value_0
      end
    end
    config.current = _tab_0
  end
  return config.current
end
config.get = function(key)
  return config.current[key]
end
return config
