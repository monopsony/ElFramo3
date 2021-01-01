local eF = elFramo
local args = eF.interface_elements_config_tables["icon"].display_prot.args
--eF.current_elements_version
local LSM = LibStub:GetLibrary("LibSharedMedia-3.0")

local function get_current_parameter(key)
    if not key then
        return
    end
    local name = eF.optionsTable.currently_selected_element_key or nil
    if not name then
        return "N/A"
    end
    return eF.para.elements[name][key]
end

local ipairs = ipairs
local function set_current_parameter(key, value)
    local name = eF.optionsTable.currently_selected_element_key or nil
    if not name then
        return
    end
    eF.para.elements[name][key] = value
    eF.current_elements_version = eF.current_elements_version + 1
    eF:fully_reload_element(name)
end

--Layout
do
    args["layout_header_prot"] = {
        order = 1,
        name = "Layout",
        type = "header"
    }

    args["width_prot"] = {
        order = 2,
        type = "range",
        name = "Width",
        softMin = 4,
        softMax = 100,
        isPercent = false,
        step = 2,
        set = function(self, value)
            set_current_parameter("width", value)
        end,
        get = function(self)
            return get_current_parameter("width")
        end,
        disabled = function()
            return get_current_parameter("fitWidth")
        end
    }

    args["fitWidth_prot"] = {
        name = "Fit width to frame",
        type = "toggle",
        order = 3,
        set = function(self, key)
            set_current_parameter("fitWidth", key)
        end,
        get = function(self)
            return get_current_parameter("fitWidth")
        end
    }

    args["height_prot"] = {
        order = 3,
        type = "range",
        name = "Height",
        softMin = 4,
        softMax = 100,
        isPercent = false,
        step = 2,
        set = function(self, value)
            set_current_parameter("height", value)
        end,
        get = function(self)
            return get_current_parameter("height")
        end,
        disabled = function()
            return get_current_parameter("fitHeight")
        end
    }

    args["fitHeight_prot"] = {
        name = "Fit height to frame",
        type = "toggle",
        order = 5,
        set = function(self, key)
            set_current_parameter("fitHeight", key)
        end,
        get = function(self)
            return get_current_parameter("fitHeight")
        end
    }

    args["XOffset_prot"] = {
        order = 6,
        type = "range",
        name = "X Offset",
        softMin = -50,
        softMax = 50,
        isPercent = false,
        step = 1,
        set = function(self, value)
            set_current_parameter("xPos", value)
        end,
        get = function(self)
            return get_current_parameter("xPos")
        end
    }

    args["YOffset_prot"] = {
        order = 7,
        type = "range",
        name = "Y Offset",
        softMin = -50,
        softMax = 50,
        isPercent = false,
        step = 1,
        set = function(self, value)
            set_current_parameter("yPos", value)
        end,
        get = function(self)
            return get_current_parameter("yPos")
        end
    }

    local anchors = {
        CENTER = "CENTER",
        RIGHT = "RIGHT",
        TOPRIGHT = "TOPRIGHT",
        TOP = "TOP",
        TOPLEFT = "TOPLEFT",
        LEFT = "LEFT",
        BOTTOMLEFT = "BOTTOMLEFT",
        BOTTOM = "BOTTOM",
        BOTTOMRIGHT = "BOTTOMRIGHT"
    }
    args["anchor_prot"] = {
        name = "Anchor",
        type = "select",
        style = "dropdown",
        order = 8,
        values = anchors,
        set = function(self, value)
            set_current_parameter("anchor", value)
        end,
        get = function(self)
            return get_current_parameter("anchor")
        end
    }

    args["anchorTo_prot"] = {
        name = "Anchor to",
        type = "select",
        style = "dropdown",
        order = 9,
        values = anchors,
        set = function(self, value)
            set_current_parameter("anchorTo", value)
        end,
        get = function(self)
            return get_current_parameter("anchorTo")
        end
    }
end

--icon
do
    args["icon_header_prot"] = {
        order = 20,
        name = "Icon",
        type = "header"
    }

    args["hasTexture_prot"] = {
        name = "Has icon",
        type = "toggle",
        order = 21,
        set = function(self, key)
            set_current_parameter("hasTexture", key)
        end,
        get = function(self)
            return get_current_parameter("hasTexture")
        end
    }

    args["smartIcon_prot"] = {
        name = "Smart icon",
        type = "toggle",
        order = 22,
        disabled = function()
            return (not eF.para.elements[
                eF.optionsTable.currently_selected_element_key
            ].hasTexture) or
                eF.para.elements[eF.optionsTable.currently_selected_element_key].solidTexture
        end,
        set = function(self, key)
            set_current_parameter("smartIcon", key)
        end,
        get = function(self)
            return get_current_parameter("smartIcon")
        end
    }

    args["solidTexture_prot"] = {
        name = "Solid Colour",
        type = "toggle",
        order = 23,
        disabled = function()
            return (not eF.para.elements[
                eF.optionsTable.currently_selected_element_key
            ].hasTexture) or
                eF.para.elements[eF.optionsTable.currently_selected_element_key].smartIcon
        end,
        set = function(self, key)
            set_current_parameter("solidTexture", key)
        end,
        get = function(self)
            return get_current_parameter("solidTexture")
        end
    }

    args["texture_prot"] = {
        type = "input",
        order = 24,
        name = "Texture",
        disabled = function()
            return (not eF.para.elements[
                eF.optionsTable.currently_selected_element_key
            ].hasTexture) or
                eF.para.elements[eF.optionsTable.currently_selected_element_key].solidTexture or
                eF.para.elements[eF.optionsTable.currently_selected_element_key].smartIcon
        end,
        set = function(self, value)
            value = string.gsub(value, "%s+", "")
            if not value or value == "" then
                return
            end
            set_current_parameter("texture", value)
        end,
        get = function(self)
            return get_current_parameter("texture")
        end
    }

    args["icon_color_prot"] = {
        order = 25,
        type = "color",
        name = "Color",
        hasAlpha = true,
        disabled = function()
            return (not eF.para.elements[
                eF.optionsTable.currently_selected_element_key
            ].hasTexture)
        end,
        set = function(self, R, G, B, A)
            local name = eF.optionsTable.currently_selected_element_key or nil
            if not name then
                return
            end
            local para = eF.para.elements[name]
            para.textureR = R
            para.textureG = G
            para.textureB = B
            set_current_parameter("textureA", A)
        end,
        get = function(self)
            local name = eF.optionsTable.currently_selected_element_key or nil
            if not name then
                return
            end
            local para = eF.para.elements[name]
            local R, G, B, A =
                para.textureR,
                para.textureG,
                para.textureB,
                para.textureA
            return R, G, B, A
        end
    }
end

--icon
do
    args["CDWheel_header_prot"] = {
        order = 40,
        name = "Cooldown wheel",
        type = "header"
    }

    args["cdWheel_prot"] = {
        name = "CD wheel",
        type = "toggle",
        order = 41,
        set = function(self, key)
            set_current_parameter("cdWheel", key)
        end,
        get = function(self)
            return get_current_parameter("cdWheel")
        end
    }

    args["cdReverse_prot"] = {
        name = "Reverse spin",
        type = "toggle",
        order = 42,
        disabled = function()
            return not eF.para.elements[
                eF.optionsTable.currently_selected_element_key
            ].cdWheel
        end,
        set = function(self, key)
            set_current_parameter("cdReverse", key)
        end,
        get = function(self)
            return get_current_parameter("cdReverse")
        end
    }
end

--icon
do
    args["border_headers_prot"] = {
        order = 60,
        name = "Border",
        type = "header"
    }

    args["border_NYI_prot"] = {
        order = 61,
        name = "NYI",
        type = "description"
    }
end
