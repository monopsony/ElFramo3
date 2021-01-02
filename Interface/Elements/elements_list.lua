local eF = elFramo
local elements = elFramo.optionsTable.args.elements
eF.interface_elements_config_tables["list"] = {}
local args = eF.interface_elements_config_tables["list"]
--eF.current_elements_version
local LSM = LibStub:GetLibrary("LibSharedMedia-3.0")

eF.interface_element_defaults.list = {
    type = "list",
    width = 15,
    height = 15,
    anchor = "LEFT",
    anchorTo = "LEFT",
    grow = "right",
    spacing = 10,
    count = 3,
    ownOnly = true,
    xPos = 0,
    yPos = 0,
    hasTexture = true,
    smartIcon = true,
    textureR = 1,
    textureG = 1,
    textureB = 1,
    textureA = 1,
    hasBorder = false,
    cdWheel = true,
    cdReverse = true,
    hasText = true,
    textFont = "Friz Quadrata TT",
    textSize = 20,
    textR = 1,
    textG = 1,
    textB = 1,
    textA = 1,
    textAnchor = "CENTER",
    textAnchorTo = "CENTER",
    textXOS = 0,
    textYOS = 0,
    textDecimals = 0,
    textType = "Time left",
    hasText2 = false,
    text2Font = "Friz Quadrata TT",
    text2Size = 20,
    text2R = 1,
    text2G = 1,
    text2B = 1,
    text2A = 1,
    text2Anchor = "CENTER",
    text2AnchorTo = "CENTER",
    text2XOS = 0,
    text2YOS = 0,
    text2Decimals = 0,
    text2Type = "Time left",
    trackType = "PLAYER HELPFUL",
    adoptFunc = "Name Whitelist",
    arg1 = {},
    interface_order = nil,
    load = {
        loadAlways = true,
        [1] = {
            loadAlways = true
        },
        [2] = {
            loadAlways = true
        },
        [3] = {
            loadAlways = true
        },
        [4] = {
            loadAlways = true
        },
        [5] = {
            loadAlways = true
        },
        [6] = {
            loadAlways = true
        },
        [7] = {
            loadAlways = true
        }
    }
}

do
    args["invisible_prot"] = {
        type = "description",
        order = 0,
        name = "Type: List",
        hidden = function(self)
            local new = self[#self - 1]
            if eF.optionsTable.currently_selected_element_key ~= new then
                eF.interface_elements_extras_chosen_key = nil
            end
            eF.optionsTable.currently_selected_element_key = new
            return false
        end
        --thanks to rivers for the suggestion
    }

    args["rename_prot"] = {
        type = "input",
        order = 1,
        name = "Rename to",
        set = function(self, name)
            name = string.gsub(name, "%s+", "")
            if not name or name == "" then
                return
            end
            local old = eF.optionsTable.currently_selected_element_key or nil
            if not old then
                return
            end
            name = eF.find_valid_name_in_table(name, eF.para.elements)
            eF:interface_create_new_element("icon", name, old)
            eF:interface_remove_element_by_name(old)
            eF:interface_set_selected_group("elements", name)
        end,
        get = function(self)
            return ""
        end
    }

    args["remove_prot"] = {
        type = "execute",
        order = 5,
        width = "half",
        confirm = function()
            if not eF.optionsTable.currently_selected_element_key then
                return false
            end
            return string.format(
                "Are you sure you want to delete the element '%s'. This is not reversible.",
                eF.optionsTable.currently_selected_element_key or
                    "(nothing selected)"
            )
        end,
        name = "Delete",
        func = function(self)
            if not eF.optionsTable.currently_selected_element_key then
                --TOAD ERROR MESSAGE
            else
                eF:interface_remove_element_by_name(
                    eF.optionsTable.currently_selected_element_key
                )
            end
        end
    }

    args["export_prot"] = {
        type = "execute",
        order = 4,
        width = "half",
        confirm = false,
        name = "Export",
        func = function(self)
            eF.open_import_export_window(
                "export",
                eF.optionsTable.currently_selected_element_key,
                "element"
            )
        end
    }

    args["duplicate_prot"] = {
        type = "execute",
        order = 3,
        width = "half",
        confirm = false,
        name = "Duplicate",
        func = function(self)
            local old = eF.optionsTable.currently_selected_element_key or nil
            if not old then
                return
            end
            local name = eF.find_valid_name_in_table(old, eF.para.elements)
            eF:interface_create_new_element("list", name, old)
            eF:interface_set_selected_group("elements", name)
        end
    }

    args["toggle_test_prot"] = {
        name = "Test",
        type = "toggle",
        order = 6,
        desc = "Enable testing for this element, periodically showing the visuals on your active layouts. Resets on closing the options menu.",
        set = function(self, key)
            if not eF.optionsTable.currently_selected_element_key then
                return
            end
            eF.interface_onUpdate_frame.time_since = 10
            eF.interface_main_frame.element_tests[
                    eF.optionsTable.currently_selected_element_key
                ] = key
            if not key then
                eF:refresh_visible_unit_frames()
            end
        end,
        get = function(self)
            if not eF.optionsTable.currently_selected_element_key then
                return false
            end
            return eF.interface_main_frame.element_tests[
                eF.optionsTable.currently_selected_element_key
            ]
        end
    }

    local AceConfigDialog = LibStub("AceConfigDialog-3.0")
    args["grouping_prot"] = {
        name = "Group",
        type = "select",
        style = "dropdown",
        order = 2,
        values = function()
            local a = {None = "None"}
            local para = elFramo.para.elements
            for k, v in pairs(para) do
                if para[k].type == "group" then
                    a[k] = k
                end
            end
            return a
        end,
        set = function(self, value)
            local name = eF.optionsTable.currently_selected_element_key or nil
            if not name then
                return
            end
            local para = elFramo.para.elements
            para[name].interfaceGroup = (value == "None" and nil) or value

            --move back to the element
            if value == "None" then
                eF:interface_set_selected_group("elements", name)
            else
                eF:interface_set_selected_group("elements", value, name)
            end
        end,
        get = function(self)
            local name = eF.optionsTable.currently_selected_element_key or nil
            if not name then
                return
            end
            local para = elFramo.para.elements
            return para[name].interfaceGroup or "None"
        end
    }

    args["tracking_prot"] = {
        name = "Tracking",
        order = 10,
        type = "group",
        args = {}
    }

    args["display_prot"] = {
        name = "Display",
        order = 11,
        type = "group",
        args = {}
    }

    args["texts_prot"] = {
        name = "Texts",
        order = 12,
        type = "group",
        args = {}
    }

    args["load_prot"] = {
        name = "Load",
        order = 13,
        type = "group",
        args = eF.interface_elements_load_config_table
    }

    args["extras_prot"] = {
        name = "Functions",
        order = 14,
        type = "group",
        args = eF.interface_elements_extras_config_table
    }
end
