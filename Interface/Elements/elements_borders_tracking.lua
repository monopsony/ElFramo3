local eF=elFramo
local args=eF.interface_elements_config_tables["border"].tracking_prot.args
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
    local trackTypes={
        ["PLAYER HELPFUL"]="Player Buffs",
        ["PLAYER HARMFUL"]="Player Debuffs",
        ["HELPFUL"]="Any Buffs",
        ["HARMFUL"]="Any Debuffs",
        ["Threat_any"]="Any threat",
        ["CHAT_MSG"]="Chat message",
        --["Threat_boss"]="Boss threat",
        --["Threat_nameplate"]="Nameplate threat",
        --["Threat_unitID"]="Specific unit threat",
        ["Static"]="Static",
        }
        
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

    local function aura_hide()
        local name=eF.optionsTable.currently_selected_element_key or nil
        if not name then return "N/A" end
        local trackType=eF.para.elements[name].trackType
        if (trackType=="PLAYER HELPFUL") or (trackType=="PLAYER HARMFUL") or (trackType=="HELPFUL") or (trackType=="HARMFUL") then return false else return true end 
    end

    local adoptFuncs={["Name"]="Name",["Spell ID"]="Spell ID",["Custom"]="Custom"}
    args["adoptFunc_prot"]={
        name="Adopt by",
        type="select",
        style="dropdown",
        order=2,
        hidden=aura_hide,
        values=adoptFuncs,
        set=function(self,value)
            set_current_parameter("adoptFunc",value)
            set_current_parameter("arg1",nil)
        end,
        get=function(self)
            return get_current_parameter("adoptFunc")
        end, 
    }

    args["arg1_name_prot"]={
        type="input",
        order=3,
        hidden=function() return aura_hide() or (not (eF.para.elements[eF.optionsTable.currently_selected_element_key].adoptFunc=="Name")) end,
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
        hidden=function() return aura_hide() or (not (eF.para.elements[eF.optionsTable.currently_selected_element_key].adoptFunc=="Spell ID")) end,
        name="Spell ID",
        set=function(self,value)
            value=tonumber(value)
            set_current_parameter("arg1",value)
            end,
        get=function(self) 
            return tostring(get_current_parameter("arg1"))
        end,
    }
    
    
    local function threat_hide()
        local name=eF.optionsTable.currently_selected_element_key or nil
        if not name then return "N/A" end
        local trackType=eF.para.elements[name].trackType
        return not (trackType=="Threat_any" or trackType=="Threat_boss" or trackType=="Threat_nameplate" or trackType=="Threat_unitID")        
    end

    local adoptFuncs={["threat_status"]="Threat level"}
    args["adoptFunc_threat_prot"]={
        name="Show if",
        type="select",
        style="dropdown",
        order=2,
        hidden=threat_hide,
        values=adoptFuncs,
        set=function(self,value)
            set_current_parameter("adoptFunc",value)
            set_current_parameter("arg1",nil)
        end,
        get=function(self)
            return get_current_parameter("adoptFunc")
        end, 
    }

    local threat_levels={
        [0]="Not tanking, low threat",
        [1]="Not tanking, high threat",
        [2]="Tanking, not highest threat",
        [3]="Tanking, highest threat",
    }
    
    args["arg1_threat_status_prot"]={
        name="Threat level",
        type="select",
        style="dropdown",
        order=4,
        width=1.5,
        hidden=function() return threat_hide() or (not (eF.para.elements[eF.optionsTable.currently_selected_element_key].adoptFunc=="threat_status")) end,
        values=threat_levels,
        set=function(self,value)
            set_current_parameter("arg1",value)
        end,
        get=function(self)
            return get_current_parameter("arg1")
        end, 
    }

    args["arg1_threat_unitid_prot"]={
        type="input",
        order=3,
        hidden=function() return threat_hide() or (not (eF.para.elements[eF.optionsTable.currently_selected_element_key].trackType=="Threat_unitID")) end,
        name="Unit ID",
        set=function(self,value)
            set_current_parameter("arg1",value)
            end,
        get=function(self) 
            return get_current_parameter("arg1")
        end,
    }

end

local function is_not_chat_msg()
    local tt=get_current_parameter("trackType")
    if (tt=="CHAT_MSG")
    then return false else return true end 
end

--chat msg options
do
    local chat_types={
        CHAT_MSG_RAID="Raid",
        CHAT_MSG_SAY="Say",
        CHAT_MSG_GUILD="Guild",
        ANY="Any",
        CHAT_MSG_WHISPER="Whisper",
        CHAT_MSG_YELL="Yell"
    }

    args["chat_types_prot"]={
        name="Chat type",
        type="select",
        style="dropdown",
        hidden=is_not_chat_msg,
        order=2,
        values=chat_types,
        set=function(self,value)   
            set_current_parameter("chatType",value)        
        end,
        get=function(self)
            return get_current_parameter("chatType")
        end, 
    }   

    local chat_match_types={["contains"]="contains",["is"]="is exactly",["starts"]="starts with",["ends"]="ends with"}
    args["chat_match_types_prot"]={
        name="Message",
        type="select",
        style="dropdown",
        hidden=is_not_chat_msg,
        order=3,
        values=chat_match_types,
        set=function(self,value)   
            set_current_parameter("chatMatch",value)        
        end,
        get=function(self)
            return get_current_parameter("chatMatch")
        end, 
    }   


    args["arg1_chat_prot"]={
        type="input",
        order=4,
        hidden=is_not_chat_msg,
        name="Pattern",
        set=function(self,value)
            set_current_parameter("arg1",value)
            end,
        get=function(self) 
            return get_current_parameter("arg1")
        end,
    }

    -- UNTRIGGER --

    args["chatTimed_prot"]={
        order=11,
        type="range",
        name="Timed:",
        min=1,
        softMax=30,
        isPercent=false,
        hidden=is_not_chat_msg,
        step=1,
        set=function(self,value)
            set_current_parameter("chatTimed",value)
        end,
        get=function(self)
            return get_current_parameter("chatTimed")
        end,
    }

end






























