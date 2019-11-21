local eF=elFramo
eF.interface_elements_extras_config_table={}
local args=eF.interface_elements_extras_config_table
local highlight_colour="|cFFFFF569"
local delimiters=eF.interface_list_delimiters
local isWhiteSpaces=eF.isWhiteSpaces
eF.interface_elements_extras_chosen_key=nil
local ipairs,pairs=ipairs,pairs
local wipe=table.wipe

local function get_current_parameter(key)
    if not key then return end
    local ele=eF.optionsTable.currently_selected_element_key or nil
    if not ele then return "N/A" end
    local name=eF.interface_elements_extras_chosen_key or nil
    if not name then return "N/A" end
    
    return eF.para.elements[ele].extras[name][key]
end

local function set_current_parameter(key,value)
    if not key then return end
    local ele=eF.optionsTable.currently_selected_element_key or nil
    if not ele then return "N/A" end
    local name=eF.interface_elements_extras_chosen_key or nil
    if not name then return "N/A" end
    eF.para.elements[ele].extras[name][key]=value
    
    eF.current_elements_version=eF.current_elements_version+1
    eF:fully_reload_element(ele)
end


local function get_normal_parameter(key)
    if not key then return end
    local ele=eF.optionsTable.currently_selected_element_key or nil
    if not ele then return "N/A" end
    local name=eF.interface_elements_extras_chosen_key or nil
    if not name then return "N/A" end
    
    return eF.para.elements[ele][key]
end

local function set_normal_parameter(key,value)
    if not key then return end
    local ele=eF.optionsTable.currently_selected_element_key or nil
    if not ele then return "N/A" end
    local name=eF.interface_elements_extras_chosen_key or nil
    if not name then return "N/A" end
    eF.para.elements[ele][key]=value
    
    eF.current_elements_version=eF.current_elements_version+1
    eF:fully_reload_element(ele)
end


local function hidden_function(index)
    local name=eF.optionsTable.currently_selected_element_key or nil
    if not name then return false end
    local bool=(eF.para.elements[name].load.loadAlways or eF.para.elements[name].load.loadNever)
    if not index then 
        return bool
    else
        return bool or eF.para.elements[name].load[index].loadAlways
    end
end


local function no_key_chosen()   
    return not (eF.interface_elements_extras_chosen_key)
end


local function_events={OnPower="Power update",onAura="Aura update",postAura="Post aura update"}

local default_functions={
    ["icon"]={updateBorderColorDebuffType="Border color by aura type",Custom="Custom"},

    ["list"]={updateBorderColorDebuffType="Border color by aura type",Custom="Custom",changeDispellableDebuffSize="Change size of dispellable auras",orderByDispellable="Sort dispellable auras first"},

    ["border"]={Custom="Custom"},
    
    ["bar"]={Custom="Custom"},
}

do
    
    local function generate_functions_dropdown()
        local ele=eF.optionsTable.currently_selected_element_key or nil
        if not ele then return end
        
        return default_functions[elFramo.para.elements[ele].type] 
    end
    
    
    local function generate_name_dropdown()
        local ele=eF.optionsTable.currently_selected_element_key or nil
        if not ele then return end
        local extras=elFramo.para.elements[ele].extras or nil
        if not extras then elFramo.para.elements[ele].extras={}; extras=elFramo.para.elements[ele].extras end
        
        local a={}
        for k,v in pairs(extras) do 
            a[k]=k
        end
        return a
    end
    
    args["warning_message"]={
        type="description",
        fontSize="small",
        order=1,
        name="|cFFFF0000Warning:|r This tab is highly experimental and mostly non-functional at the moment. Can safely be ignored.",
    }

    args["grouping_prot"]={
        name="Select",
        type="select",
        style="dropdown",
        order=2,
        values=generate_name_dropdown,
        set=function(self,key)
            eF.interface_elements_extras_chosen_key=key
        end,
        get=function(self)
            return eF.interface_elements_extras_chosen_key
        end,
    }
    
    args["new_prot"]={
        type="input",
        order=3,
        name="New function",
        set=function(self,name)
                name=string.gsub(name, "%s+", "")
                if not name or name=="" then return end
                local ele=eF.optionsTable.currently_selected_element_key or nil
                if not ele then return end
                
                local extras=elFramo.para.elements[ele].extras or nil
                if not extras then elFramo.para.elements[ele].extras={}; extras=elFramo.para.elements[ele].extras end
                
                name=eF.find_valid_name_in_table(name,extras)
                extras[name]={nil,nil,nil}
            end,
        get=function(self) 
                return "" 
            end,
    }  
    
    args["remove_prot"]={
        type="execute",
        order=4,
        width="half",
        name="Remove",
        disabled=no_key_chosen,
        func=function(self)
            local ele=eF.optionsTable.currently_selected_element_key or nil
            if not ele then return "N/A" end
            local name=eF.interface_elements_extras_chosen_key or nil
            if not name then return "N/A" end
            
            eF.interface_elements_extras_chosen_key=nil
            wipe(eF.para.elements[ele].extras[name])
            eF.para.elements[ele].extras[name]=nil
            
            eF.current_elements_version=eF.current_elements_version+1
            eF:fully_reload_element(ele)
        end,
    }

    args["name_header_prot"]={
        order=10,
        hidden=no_key_chosen,
        type="header",
        name=function() return tostring(eF.interface_elements_extras_chosen_key) end,
    }
    
    args["events_dd_prot"]={
        name="Trigger on",
        type="select",
        style="dropdown",
        desc=("Decides when the selected function should be called. Note: use %sAura update|r for setting aura infos (searching/adopting auras, aura positioning in lists etc) and %sPost aura aupdate|r for visuals (update CD wheel, apply smart icon texture etc"):format(highlight_colour,highlight_colour),
        hidden=no_key_chosen,
        order=11,
        values=function_events,
        set=function(self,value)
            set_current_parameter(1,value)
        end,
        get=function(self)
            return get_current_parameter(1)
        end,
    }
    
    args["functions_dd_prot"]={
        name="Function",
        type="select",
        style="dropdown",
        hidden=no_key_chosen,
        order=12,
        values=generate_functions_dropdown,
        set=function(self,value)
            set_current_parameter(2,value)
        end,
        get=function(self)
            return get_current_parameter(2)
        end,
    }
    
    args["edit_prot"]={
        type="execute",
        order=16,
        width="half",
        name="Edit - NYI",
        hidden=function()
            return not (get_current_parameter(2)=="Custom")
        end,
        func=function(self)
             
        end,
    }
    
end

--changeDispellableDebuffSize
do
    local function hidden_function()
        return not (get_current_parameter(2)=="changeDispellableDebuffSize")
    end
    
    args["dispellableHeight_prot"]={
        order=21,
        type="range",
        name="Height",
        softMin=0,
        softMax=50,
        isPercent=false,
        hidden=hidden_function,
        step=1,
        set=function(self,value)
            set_normal_parameter("dispellableHeight",value) 
        end,
        get=function(self)
            return get_normal_parameter("dispellableHeight") or get_normal_parameter("height")
        end,
    }
    
    args["dispellableWidth_prot"]={
        order=22,
        type="range",
        name="Width",
        softMin=0,
        softMax=50,
        isPercent=false,
        hidden=hidden_function,
        step=1,
        set=function(self,value)
            set_normal_parameter("dispellableWidth",value)
        end,
        get=function(self)
            return get_normal_parameter("dispellableWidth") or get_normal_parameter("width")
        end,
    }
    
end

















