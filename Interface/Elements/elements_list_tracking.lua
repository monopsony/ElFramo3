local eF=elFramo
local args=eF.interface_elements_config_tables["list"].tracking_prot.args
--eF.current_elements_version
local LSM=LibStub:GetLibrary("LibSharedMedia-3.0")
local wipe=table.wipe
local delimiters=eF.interface_list_delimiters

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

local isWhiteSpcaes=eF.info.isWhiteSpaces


local pairs=pairs
local function get_multiline_arg1() 
    local name=eF.optionsTable.currently_selected_element_key or nil
    if not name then return "N/A" end
    local sori=eF.para.elements[name].arg1ori or nil
    if sori then return sori end

    local para,s=eF.para.elements[name].arg1,""
    if para then 
        for k,v in pairs(para) do 
            if v then s=("%s%s,\n"):format(s,tostring(k)) end
        end
    end
    return s
end

local function set_multiline_arg1(text) 
    local name=eF.optionsTable.currently_selected_element_key or nil
    if not name then return "N/A" end
    if type(eF.para.elements[name].arg1)=="list" then wipe(eF.para.elements[name].arg1) end
    local para,s={},""
    for k,v in pairs({strsplit(delimiters,text)}) do 
        if v and (not isWhiteSpaces(v)) then para[v]=true end
    end
    eF.para.elements[name].arg1ori=text
    set_current_parameter("arg1",para)
end




do
    
    local function name_black_white_list()
        local auraAdopt=get_current_parameter("adoptFunc")
        if auraAdopt=="Name Whitelist" or auraAdopt=="Name Blacklist" then return false else return true end
    end
    
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

    local adoptFuncs={["Name Whitelist"]="Name whitelist",["Name Blacklist"]="Name blacklist",["Custom"]="Custom"}
    args["adoptFunc_prot"]={
        name="Adopt by",
        type="select",
        style="dropdown",
        order=2,
        values=adoptFuncs,
        set=function(self,value)
            if value=="Name Whitelist" or value=="Name Blacklist" then 
                set_current_parameter("arg1",{})
            else 
                set_current_parameter("arg1",nil)
            end
            set_current_parameter("adoptFunc",value)
        end,
        get=function(self)
            return get_current_parameter("adoptFunc")
        end, 
    }

    args["arg1_name_whitelist_prot"]={
        type="input",
        order=3,
        hidden=function() return not (eF.para.elements[eF.optionsTable.currently_selected_element_key].adoptFunc=="Name Whitelist") end,
        name="Name whitelist",
        multiline=true,
        desc=function() return eF.interface_list_help_tooltip("spell names") end,
        width=3,
        height=3,
        set=function(self,value)
            set_multiline_arg1(value)
        end,
        get=function(self) 
            return get_multiline_arg1()
        end,
    }
    
    args["arg1_name_blacklist_prot"]={
        type="input",
        order=3,
        hidden=function() return not (eF.para.elements[eF.optionsTable.currently_selected_element_key].adoptFunc=="Name Blacklist") end,
        name="Name Blacklist",
        multiline=true,
        width=3,
        height=3,
        set=function(self,value)
            set_multiline_arg1(value)
        end,
        get=function(self) 
            return get_multiline_arg1()
        end,
    }
    
    args["spacer_0_prot"]={
        type="description",
        order=4,
        name="",
        width="full",
    }
    
    
    args["ignore_permanents_prot"]={
        name="Ignore permanents",
        type="toggle",
        order=5,
        hidden=name_black_white_list,
        set=function(self,key) 
            set_current_parameter("ignorePermanents",key)
        end,
        
        get=function(self) 
            return get_current_parameter("ignorePermanents")
        end,
    }
    
    args["iDA_prot"]={
        order=6,
        name="Ignore durations above",
        type="range",
        min=0,
        softMax=1000,
        hidden=name_black_white_list,
        isPercent=false,
        step=1,
        set=function(self,value)
            set_current_parameter("iDA",tonumber(value))
        end,
        get=function(self)
            return get_current_parameter("iDA")
        end,
    }
    
    args["count_prot"]={
        order=7,
        name="Max. number of icons",
        type="range",
        min=1,
        softMax=10,
        hidden=name_black_white_list,
        isPercent=false,
        step=1,
        set=function(self,value)
            set_current_parameter("count",tonumber(value))
        end,
        get=function(self)
            return get_current_parameter("count")
        end,
    }
    
  
    
end














