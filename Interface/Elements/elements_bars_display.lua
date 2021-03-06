local eF = elFramo
local args = eF.interface_elements_config_tables["bar"].display_prot.args
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
local growth = {up = "Up", down = "Down", right = "Right", left = "Left"}

--display
do
    args["layout_header_prot"] = {
        order = 1,
        name = "Layout",
        type = "header",
        hidden = true
    }

    args["textureFile_prot"] = {
        name = "Texture - NYI",
        type = "select",
        style = "dropdown",
        disabled = true,
        dialogControl = "LSM30_Statusbar",
        order = 2,
        values = LSM:HashTable("statusbar"),
        set = function(self, value)
            set_current_parameter("textureFile", value)
        end,
        get = function(self)
            return get_current_parameter("textureFile")
        end
    }

    args["flatTexture_prot"] = {
        name = "Flat Texture",
        type = "toggle",
        order = 9,
        disabled = true,
        set = function(self, key)
            set_current_parameter("flatTexture", key)
        end,
        get = function(self)
            return get_current_parameter("flatTexture")
        end
    }

    args["fixedLength_prot"] = {
        order = 10,
        type = "range",
        name = "Fixed length",
        min = 0,
        softMax = 20,
        isPercent = false,
        --disabled=function()
        --    return not get_current_parameter("flatBorder")
        --end,
        step = 1,
        disabled = function()
            return get_current_parameter("fitFixedLength")
        end,
        set = function(self, value)
            set_current_parameter("lFix", value)
        end,
        get = function(self)
            return get_current_parameter("lFix")
        end
    }

    args["fitFixedLength_prot"] = {
        name = "Fit fixed length to frame",
        type = "toggle",
        order = 11,
        set = function(self, key)
            set_current_parameter("fitFixedLength", key)
        end,
        get = function(self)
            return get_current_parameter("fitFixedLength")
        end
    }

    args["maxLength_prot"] = {
        order = 12,
        type = "range",
        name = "Max growth length",
        min = 0,
        softMax = 150,
        isPercent = false,
        disabled = function()
            return get_current_parameter("fitMaxLength")
        end,
        step = 1,
        set = function(self, value)
            set_current_parameter("lMax", value)
        end,
        get = function(self)
            return get_current_parameter("lMax")
        end
    }

    args["fitMaxLength_prot"] = {
        name = "Fit max length to frame",
        type = "toggle",
        order = 13,
        set = function(self, key)
            set_current_parameter("fitMaxLength", key)
        end,
        get = function(self)
            return get_current_parameter("fitMaxLength")
        end
    }

    args["anchorTo_prot"] = {
        name = "Anchor to",
        type = "select",
        style = "dropdown",
        order = 14,
        values = anchors,
        set = function(self, value)
            set_current_parameter("anchorTo", value)
        end,
        get = function(self)
            return get_current_parameter("anchorTo")
        end
    }

    args["grow_prot"] = {
        name = "Grow",
        type = "select",
        style = "dropdown",
        order = 15,
        values = growth,
        set = function(self, value)
            set_current_parameter("grow", value)
        end,
        get = function(self)
            return get_current_parameter("grow")
        end
    }

    args["xPos_prot"] = {
        order = 16,
        type = "range",
        name = "X Offset",
        softMin = -20,
        softMax = 20,
        isPercent = false,
        --disabled=function()
        --    return not get_current_parameter("flatBorder")
        --end,
        step = 1,
        set = function(self, value)
            set_current_parameter("xPos", value)
        end,
        get = function(self)
            return get_current_parameter("xPos")
        end
    }

    args["yPos_prot"] = {
        order = 17,
        type = "range",
        name = "Y Offset",
        softMin = -20,
        softMax = 20,
        isPercent = false,
        --disabled=function()
        --    return not get_current_parameter("flatBorder")
        --end,
        step = 1,
        set = function(self, value)
            set_current_parameter("yPos", value)
        end,
        get = function(self)
            return get_current_parameter("yPos")
        end
    }

    args["color_prot"] = {
        order = 18,
        type = "color",
        name = "Color",
        hasAlpha = true,
        set = function(self, R, G, B, A)
            local name = eF.optionsTable.currently_selected_element_key or nil
            if not name then
                return
            end
            local para = eF.para.elements[name]
            para.textureR = R
            para.textureG = G
            para.textureA = B
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
