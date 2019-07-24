local eF=elFramo
local args=eF.interface_elements_config_tables["icon"].tracking.args
--eF.current_elements_version
local LSM=LibStub:GetLibrary("LibSharedMedia-3.0")

local function get_current_parameter(key)
    if not key then return end
    local name=eF.optionsTable.currently_selected_element_key or nil
    if not name then return "N/A" end
    return eF.para.elements[name][key]
end


local ipairs=ipairs
local function set_current_parameter(key,value)
    local name=eF.optionsTable.currently_selected_element_key or nil
    if not name then return end
    eF.para.elements[name][key]=value
    eF.current_elements_version=eF.current_elements_version+1
    eF:fully_reload_element(name)
end


do
    local trackTypes={["PLAYER HELPFUL"]="Player Buffs",["PLAYER HARMFUL"]="Player Debuffs",["HELPFUL"]="Any Buffs",["HARMFUL"]="Any Debuffs"}
    args["trackType"]={
        name="Track",
        type="select",
        style="dropdown",
        order=1,
        values=trackTypes,
        set=function(self,value)
            set_current_parameter("trackType",value)
        end,
        get=function(self)
            return get_current_parameter("trackType")
        end,

    }

    local adoptFuncs={["Name"]="Name",["Spell ID"]="Spell ID",["Custom"]="Custom"}
    args["adoptFunc"]={
        name="Adopt by",
        type="select",
        style="dropdown",
        order=2,
        values=adoptFuncs,
        set=function(self,value)   
            set_current_parameter("arg1",nil)
            set_current_parameter("adoptFunc",value)        
        end,
        get=function(self)
            return get_current_parameter("adoptFunc")
        end, 
    }

    args["arg1_name"]={
        type="input",
        order=3,
        hidden=function() return not (eF.para.elements[eF.optionsTable.currently_selected_element_key].adoptFunc=="Name") end,
        name="Name",
        set=function(self,value)
            set_current_parameter("arg1",value)
            end,
        get=function(self) 
            return get_current_parameter("arg1")
        end,
    }
    
    args["arg1_spellID"]={
        type="input",
        order=3,
        hidden=function() return not (eF.para.elements[eF.optionsTable.currently_selected_element_key].adoptFunc=="Spell ID") end,
        name="Spell ID",
        set=function(self,value)
            value=tonumber(value)
            set_current_parameter("arg1",value)
            end,
        get=function(self) 
            return tostring(get_current_parameter("arg1"))
        end,
    }
    
    
end






























