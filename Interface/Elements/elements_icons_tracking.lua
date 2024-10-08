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

	local trackTypes={
		["PLAYER HELPFUL"]="Player Buffs",
		["PLAYER HARMFUL"]="Player Debuffs",
		["HELPFUL"]="Any Buffs",
		["HARMFUL"]="Any Debuffs",
		["CHAT_MSG"]="Chat message",
		["READY_CHECK"]="Ready check",
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

	local function aura_extra_is_checked(key)
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


	args["aura_extra_icon_check_prot"]={
		name="Watch icon ID",
		type="toggle",
		order=31,
		hidden=is_not_aura_related,
		set=function(self,key) 
			set_aura_extra("icon_check",key)
		end,
		
		get=function(self) 
			return get_aura_extra("icon_check")
		end,
	}  

	args["aura_extra_icon_min_prot"]={
		order=32,
		type="input",
		name="Icon ID",
		softMin=0,
		softMax=60,
		isPercent=false,
		hidden=function()
			return not aura_extra_is_checked("icon_check")
		end,
		step=1,
		set=function(self,value)
			set_aura_extra("icon_id",tonumber(value))
		end,
		get=function(self)
			return tostring(get_aura_extra("icon_id"))
		end,
	}


end

local function is_not_chat_msg()
	local tt=get_current_parameter("trackType")
	if (tt=="CHAT_MSG")
	then return false else return true end 
end

local function is_not_ready_check()
	local tt=get_current_parameter("trackType")
	if (tt=="READY_CHECK")
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

	args["match_duration_in_message_prot"]={
		name="Smart duration",
		desc="Uses the first occurence of a number as the duration (max 60 seconds). When no number is found, uses the default timer.",
		type="toggle",
		order=12,
		hidden=is_not_chat_msg,
		set=function(self,key) 
			set_current_parameter("match_duration_in_message",key)
		end,
		
		get=function(self) 
			return get_current_parameter("match_duration_in_message")
		end,
	}  

end


--chat msg options
do
	local rc_types={
		[3]="Any",
		[2]="Pending",
		[1]="Ready",
		[0]="Not Ready",
	}

	args["rc_types_prot"]={
		name="Show when",
		type="select",
		style="dropdown",
		hidden=is_not_ready_check,
		order=2,
		values=rc_types,
		set=function(self,value)   
			set_current_parameter("rcType",value)        
		end,
		get=function(self)
			return get_current_parameter("rcType")
		end, 
	}	


    args["rcLinger_prot"]={
        order=3,
        type="range",
        name="Linger time",
        min=0,
        softMax=30,
        isPercent=false,
        hidden=is_not_ready_check,
        step=1,
        set=function(self,value)
            set_current_parameter("rcLinger",value)
        end,
        get=function(self)
            return get_current_parameter("rcLinger")
        end,
    }


end



























