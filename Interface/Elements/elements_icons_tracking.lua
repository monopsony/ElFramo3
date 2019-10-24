local eF=elFramo
local args=eF.interface_elements_config_tables["icon"].tracking_prot.args
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


local function set_aura_extra(key,value)
    local name=eF.optionsTable.currently_selected_element_key or nil
    if not name then return end
    if not eF.para.elements[name].auraExtras then eF.para.elements[name].auraExtras={} end 
    eF.para.elements[name].auraExtras[key]=value
    eF.current_elements_version=eF.current_elements_version+1
    eF:fully_reload_element(name)
end

local function get_aura_extra(key)
    if not key then return end 
    local name=eF.optionsTable.currently_selected_element_key or nil
    if not name then return end
    if not eF.para.elements[name].auraExtras then return nil end 
    return eF.para.elements[name].auraExtras[key]
end

local function is_not_aura_related()
    local tt=get_current_parameter("trackType")
    if (tt=="PLAYER HARMFUL") or (tt=="PLAYER HELPFUL") or (tt=="HELPFUL") or (tt=="HARMFUL") 
    then return false else return true end 
end

--tracktype and other basics
do

    local trackTypes={["PLAYER HELPFUL"]="Player Buffs",["PLAYER HARMFUL"]="Player Debuffs",["HELPFUL"]="Any Buffs",["HARMFUL"]="Any Debuffs"}
    args["trackType_prot"]={
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
    args["adoptFunc_prot"]={
        name="Adopt by",
        type="select",
        style="dropdown",
        order=2,
        values=adoptFuncs,
        hidden=is_not_aura_related,
        set=function(self,value)   
            set_current_parameter("arg1",nil)
            set_current_parameter("adoptFunc",value)        
        end,
        get=function(self)
            return get_current_parameter("adoptFunc")
        end, 
    }

    args["arg1_name_prot"]={
        type="input",
        order=3,
        hidden=function() 
            if is_not_aura_related() then return true end 
            return not (eF.para.elements[eF.optionsTable.currently_selected_element_key].adoptFunc=="Name") 
        end,
        name="Name",
        set=function(self,value)
            set_current_parameter("arg1",value)
            end,
        get=function(self) 
            return get_current_parameter("arg1")
        end,
    }
    
    args["arg1_spellID_prot"]={
        type="input",
        order=3,
        hidden=function() 
            if is_not_aura_related() then return true end 
            return not (eF.para.elements[eF.optionsTable.currently_selected_element_key].adoptFunc=="Spell ID") 
        end,
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

--just a bunch of extra headers
do 
    args["icon_extra_header_10_prot"]={
        order=10,
        name="",
        type="header",  
    }

    args["icon_extra_header_20_prot"]={
        order=20,
        name="",
        type="header",  
    }

    args["icon_extra_header_30_prot"]={
        order=30,
        name="",
        type="header",  
    }

end

--aura extras
do

    function aura_extra_is_checked(key)
        if is_not_aura_related() then return false end
        if get_aura_extra(key)==true then return true end 
        return false
    end

    args["aura_extra_stacks_check_prot"]={
        name="Watch stacks",
        type="toggle",
        order=11,
        hidden=is_not_aura_related,
        set=function(self,key) 
            set_aura_extra("stacks_check",key)
        end,
        
        get=function(self) 
            return get_aura_extra("stacks_check")
        end,
    }  

    args["aura_extra_stacks_min_prot"]={
        order=12,
        type="range",
        name="Minimum stacks",
        softMin=0,
        softMax=10,
        isPercent=false,
        hidden=function()
            return not aura_extra_is_checked("stacks_check")
        end,
        step=1,
        set=function(self,value)
            set_aura_extra("stacks_min",value)
        end,
        get=function(self)
            return get_aura_extra("stacks_min")
        end,
    }

    args["aura_extra_stacks_max_prot"]={
        order=13,
        type="range",
        name="Maximum stacks",
        softMin=0,
        softMax=10,
        isPercent=false,
        hidden=function()
            return not aura_extra_is_checked("stacks_check")
        end,
        step=1,
        set=function(self,value)
            set_aura_extra("stacks_max",value)
        end,
        get=function(self)
            return get_aura_extra("stacks_max")
        end,
    }


    args["aura_extra_trem_check_prot"]={
        name="Watch rem. duration",
        type="toggle",
        order=21,
        hidden=is_not_aura_related,
        set=function(self,key) 
            set_aura_extra("trem_check",key)
        end,
        
        get=function(self) 
            return get_aura_extra("trem_check")
        end,
    }  

    args["aura_extra_trem_min_prot"]={
        order=22,
        type="range",
        name="Minimum rem. duration",
        softMin=0,
        softMax=60,
        isPercent=false,
        hidden=function()
            return not aura_extra_is_checked("trem_check")
        end,
        step=1,
        set=function(self,value)
            set_aura_extra("trem_min",value)
        end,
        get=function(self)
            return get_aura_extra("trem_min")
        end,
    }

    args["aura_extra_trem_max_prot"]={
        order=23,
        type="range",
        name="Maximum rem. duration",
        softMin=0,
        softMax=60,
        isPercent=false,
        hidden=function()
            return not aura_extra_is_checked("trem_check")
        end,
        step=1,
        set=function(self,value)
            set_aura_extra("trem_max",value)
        end,
        get=function(self)
            return get_aura_extra("trem_max")
        end,
    }

end




























