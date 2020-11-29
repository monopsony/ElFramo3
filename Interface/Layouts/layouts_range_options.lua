local eF = elFramo
local args = elFramo.optionsTable.args.layouts.args.range_options.args

local function set_current_parameter(key, value)
    local name = eF.optionsTable.currently_selected_layout or nil
    if not name then return end
    eF.para.layouts[name].parameters[key] = value
    eF.current_layout_version = eF.current_layout_version + 1
    for _, v in ipairs(eF.list_all_active_unit_frames(name)) do
        v:updateUnit()
    end
end

local function get_current_parameter(key)
    local name = eF.optionsTable.currently_selected_layout or nil
    if not name then return end
    return eF.para.layouts[name].parameters[key]
end

-- v.parameters.oorFadeOut = true
-- v.parameters.oorDarken = true
-- v.parameters.oorADarken = 0.3

args["oorFadeOut"] = {
    name = "Fade out",
    type = "toggle",
    order = 2,
    set = function(self, key) set_current_parameter('oorFadeOut', key) end,

    get = function(self) return get_current_parameter('oorFadeOut') end
}

args["oorA"] = {
    order = 3,
    type = "range",
    name = "Fade alpha",
    min = 0,
    softMax = 1,
    isPercent = false,
    disabled = function() return not get_current_parameter("oorFadeOut") end,
    step = 0.01,
    set = function(self, value) set_current_parameter("oorA", value) end,
    get = function(self) return get_current_parameter("oorA") end
}

args["oorDarken"] = {
    name = "Darken",
    type = "toggle",
    order = 4,
    set = function(self, key) set_current_parameter('oorDarken', key) end,

    get = function(self) return get_current_parameter('oorDarken') end
}

args["oorADarken"] = {
    order = 5,
    type = "range",
    name = "Darken alpha",
    min = 0,
    softMax = 1,
    isPercent = false,
    disabled = function() return not get_current_parameter("oorDarken") end,
    step = 0.01,
    set = function(self, value) set_current_parameter("oorADarken", value) end,
    get = function(self) return get_current_parameter("oorADarken") end
}
