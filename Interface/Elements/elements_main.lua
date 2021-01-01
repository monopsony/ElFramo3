local eF = elFramo
local elements = elFramo.optionsTable.args.elements
local args = elements.args
eF.optionsTable.currently_selected_element_key = nil
local tContains = tContains
local wipe = table.wipe
eF.interface_element_defaults = {}
eF.interface_new_element_type = nil

local element_types = {
    icon = "Icon",
    bar = "Bar",
    border = "Border",
    list = "List",
    group = "Group"
}

local deepcopy = eF.table_deep_copy
function eF:interface_create_new_element(typ, name, duplicate)
    if not name then
        return
    end
    local para = eF.para.elements
    local name = eF.find_valid_name_in_table(name, para)

    if duplicate and para[duplicate] then
        para[name] = deepcopy(para[duplicate])
    elseif type(duplicate) == "table" then
        para[name] = deepcopy(duplicate)
        para[name].name_key = nil
    else
        if not typ then
            return
        end
        para[name] = deepcopy(eF.interface_element_defaults[typ])
    end

    --eF:update_element_meta(name)
    eF:refresh_element(name)
    eF:interface_select_tab("elements")
    eF:interface_select_element_by_key(name)
end

function eF:interface_select_element_by_key(key)
    if not key and (type(key) == "string") then
        return
    end
    local para = elFramo.para.elements[key]
    if para.interfaceGroup then
        self:interface_set_selected_group("elements", para.interfaceGroup, key)
    else
        self:interface_set_selected_group("elements", key)
    end
end

function eF:interface_remove_element_by_name(name)
    if not (name and eF.para.elements[name]) then
        return
    end
    wipe(eF.tasks[name])
    eF.tasks[name] = nil
    wipe(eF.workFuncs[name])
    eF.workFuncs[name] = nil
    wipe(eF.para.elements[name])
    eF.para.elements[name] = nil

    eF:refresh_element()
end

--add buttons
do
    local last_opened = 0
    args["invisible_prot"] = {
        type = "description",
        order = -1,
        name = "invisible",
        hidden = function()
            local t = GetTime()
            if t > last_opened then
                eF.interface_generate_element_groups()
                last_opened = t
            end
            eF.interface_tab_group:SetTitle("")
            --eF:reload_elements_options_frame()
            return true
        end
        --thanks to rivers for the suggestion
    }

    args["help_message_prot"] = {
        type = "description",
        fontSize = "small",
        order = 1,
        name = "|cFFFFF569Note|r: TBA Mierihn is very gay.",
        hidden = true
    }

    args["new_element_type_prot"] = {
        name = "Type",
        type = "select",
        style = "dropdown",
        order = 2,
        values = element_types,
        set = function(self, value)
            eF.interface_new_element_type = value
        end,
        get = function(self)
            return eF.interface_new_element_type
        end
    }

    args["new_element_prot"] = {
        type = "input",
        order = 3,
        name = "New element name",
        disabled = function()
            return not eF.interface_new_element_type
        end,
        set = function(self, name)
            name = string.gsub(name, "%s+", "")
            if not name or name == "" then
                return
            end
            name = eF.find_valid_name_in_table(name, eF.para.elements)
            eF:interface_create_new_element(eF.interface_new_element_type, name)
            eF:interface_set_selected_group("elements", name)
        end,
        get = function(self)
            return ""
        end
    }

    args["import_element_prot"] = {
        type = "execute",
        order = 4,
        width = "half",
        confirm = false,
        name = "Import",
        func = function(self)
            eF.open_import_export_window("import", nil, "element")
        end
    }
end

local function find_first_valid_order(order, tbl)
    if not tbl then
        return order
    end
    for i = order, 1000 do
        if not tbl[i] then
            return i
        end
    end
    return order
end

local pairs = pairs
local is_protected_key = eF.is_protected_key
function eF.interface_generate_element_groups()
    local elements = elFramo.optionsTable.args.elements
    local args = elements.args
    local para = eF.para.elements
    local order_max = 0

    for k, v in pairs(args) do
        if (not is_protected_key(k)) and (not para[k]) then
            wipe(args[k])
            args[k] = nil
        end
    end

    local orders_found = {}
    for k, v in pairs(para) do
        if v.interface_order and (not v.interfaceGroup) then
            orders_found[v.interface_order] = true
        end
    end

    --set option tables for orphans and groups
    local group_table = {}
    for k, v in pairs(para) do
        if (para[k].interfaceGroup and para[para[k].interfaceGroup]) then --if it's in a group and the group exists
            local group = para[k].interfaceGroup
            if not group_table[group] then
                group_table[group] = {}
            end
            local tbl = group_table[group]
            tbl[#tbl + 1] = k
        else
            para[k].interfaceGroup = nil --removes the group if group not found as well
            args[k] = args[k] or {}
            local a = args[k]
            a.name = k
            a.type = "group"
            a.childGroups = para[k].type == "group" and "tree" or "tab"
            local order = para[k].interface_order or nil
            if order then
                a.order = order
                if order > order_max then
                    order_max = order + 1
                end
            else
                order = find_first_valid_order(order_max, orders_found)
                a.order = order
                para[k].interface_order = order
                order_max = order + 1
            end
            if para[k].type == "group" then
                --groups cannot work by using literally the same table due to them having different args
                --so need to do a copy to avoid pointer bullcrap ofc (all groups would end up being the same)
                --to avoid garbage we perform a check to see if we even need to re-generate the table
                if (not a.args) or (not a.args.is_group_element) then
                    a.args =
                        deepcopy(eF.interface_elements_config_tables["group"])
                end
                --remove elements inside teh group that dont belong
                for key, _ in pairs(a.args) do
                    if
                        not (is_protected_key(key) or
                            (para[k].interfaceGroup == k))
                     then
                        a.args[key] = nil
                    end
                end
            else
                a.args = eF.interface_elements_config_tables[para[k].type] or {}
            end
        end
    end

    --set option tables for elements in groups
    for group, elements in pairs(group_table) do
        local group_args = args[group].args
        local order_max, orders_found = 0, {}
        for i, v in ipairs(elements) do
            if para[v].interface_order then
                orders_found[para[v].interface_order] = true
            end
        end

        for i, k in ipairs(elements) do
            if args[k] then
                args[k] = nil
            end --remove elements that might have been orphans in the past but aren't any more
            group_args[k] = group_args[k] or {}
            local a = group_args[k]
            a.name = k
            a.type = "group"
            a.childGroups = para[k].type == "group" and "tree" or "tab"
            local order = para[k].interface_order or nil
            if order then
                a.order = order
                if order > order_max then
                    order_max = order + 1
                end
            else
                order = find_first_valid_order(order_max, orders_found)
                a.order = order
                para[k].interface_order = order
                order_max = order + 1
            end
            a.args = eF.interface_elements_config_tables[para[k].type] or {}
        end
    end

    wipe(orders_found)
end
eF.interface_elements_config_tables = {}
