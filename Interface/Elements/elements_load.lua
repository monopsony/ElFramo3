local eF=elFramo
eF.interface_elements_load_config_table={}
local args=eF.interface_elements_load_config_table
local highlight_colour="|cFFFFF569"
local delimiters=eF.interface_list_delimiters
local isWhiteSpaces=eF.isWhiteSpaces

local function get_current_parameter(index,key)
    if not key then return end
    local name=eF.optionsTable.currently_selected_element_key or nil
    if not name then return "N/A" end
    if index then 
        return eF.para.elements[name].load[index][key]
    else 
        return eF.para.elements[name].load[key]
    end
end


local ipairs=ipairs
local function set_current_parameter(index,key,value)
    local name=eF.optionsTable.currently_selected_element_key or nil
    if not name then return end
    if index then
        eF.para.elements[name].load[index][key]=value
    else
        eF.para.elements[name].load[key]=value
    end
    eF.current_elements_version=eF.current_elements_version+1
    eF:fully_reload_element(name)
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


local pairs=pairs
local function get_multiline_parameter(index) 
    local name=eF.optionsTable.currently_selected_element_key or nil
    if not name then return "N/A" end
    if not index then return end
    local sori=eF.para.elements[name][tostring(index).."ori"] or nil
    if sori then return sori end

    local para,s=eF.para.elements[name][index],""
    if para then 
        for k,v in pairs(para) do 
            if v then s=("%s%s,\n"):format(s,tostring(k)) end
        end
    end
    return s
end

local function set_multiline_parameter(index,text) 
    local name=eF.optionsTable.currently_selected_element_key or nil
    if not name then return "N/A" end
    if not index then return end
    if type(eF.para.elements[name][index])=="list" then wipe(eF.para.elements[name][index]) end
    local para,s={},""
    for k,v in pairs({strsplit(delimiters,text)}) do 
        if v and (not isWhiteSpaces(v)) then para[v]=true end
    end
    eF.para.elements[name][tostring(index).."ori"]=text
    set_current_parameter(nil,index,para) --if you give index as the second parameter (normally the key), it'll just set the entire table
end




--roles & classes
do
        
    args["loadAlways_prot"]={
        name="Always load",
        type="toggle",
        order=2,
        set=function(self,key) 
            set_current_parameter(nil,"loadAlways",key)
        end,
        disabled=function()
            local name=eF.optionsTable.currently_selected_element_key or nil
            if not name then return false end
            return eF.para.elements[name].load.loadNever
        end,
        get=function(self) 
            return get_current_parameter(nil,"loadAlways")
        end,
    }

    args["loadNever_prot"]={
        name="Never load",
        type="toggle",
        order=3,
        set=function(self,key) 
            set_current_parameter(nil,"loadNever",key)
        end,
        disabled=function()
            local name=eF.optionsTable.currently_selected_element_key or nil
            if not name then return false end
            return eF.para.elements[name].load.loadAlways
        end,
        get=function(self) 
            return get_current_parameter(nil,"loadNever")
        end,
    }
       
    args["showPlayerClassHeader_prot"]={
        name="Own class",
        type="header",  
        order=4,
    }       
        
    args["showPlayerClassesAny_prot"]={
        name=highlight_colour.."Any",
        type="toggle",
        order=5,
        set=function(self,value) 
            set_current_parameter(1,"loadAlways",value)
        end,
        disabled=function() return hidden_function() end,
        get=function(self)
            return get_current_parameter(1,"loadAlways")
        end,
    }
  
    args["showPlayerClasses_prot"]={
        name="Show when player class is",
        type="multiselect",
        order=6,
        values={["Warrior"]="Warrior",["Death Knight"]="Death Knight",Rogue="Rogue",Monk="Monk",Paladin="Paladin",Druid="Druid",Shaman="Shaman",Priest="Priest",Mage="Mage",Warlock="Warlock",Hunter="Hunter",["Demon Hunter"]="Demon Hunter"},
        set=function(self,key,value) 
            set_current_parameter(1,key,value)
        end,
        hidden=function() return hidden_function(1) end,
        get=function(self,key)
            return get_current_parameter(1,key)
        end,
    }
       
    args["showPlayerRoleHeader_prot"]={
        name="Own role",
        type="header",  
        order=10,
    }  
       
    args["showPlayerRolesAny_prot"]={
        name=highlight_colour.."Any",
        type="toggle",
        desc="|cFFFF0000Warning:|r Player role only works when in a group at the moment. There are also some cases (e.g. island expeditions) where everyone's role is set to 'DPS' regardless. Will need to change player role independent of that and do it based on specialisation but for now it is what it is. TBA",
        order=11,
        set=function(self,value) 
            set_current_parameter(2,"loadAlways",value)
        end,
        disabled=function() return hidden_function() end,
        get=function(self)
            return get_current_parameter(2,"loadAlways")
        end,
    }
       
    args["showPlayerRoles_prot"]={
        type="multiselect",
        order=12,
        name="Show when player role is",
        values={DAMAGER="DPS",HEALER="Healer",TANK="Tank"},
        set=function(self,key,value) 
            set_current_parameter(2,key,value)
        end,
        hidden=function() return hidden_function(2) end,
        get=function(self,key) 
            return get_current_parameter(2,key)
        end,
    }
     
    args["showUnitClassesHeader_prot"]={
        name="Unit class",
        type="header",  
        order=20,
    }
     
     
    args["showUnitClassesAny_prot"]={
        name=highlight_colour.."Any",
        type="toggle",
        order=21,
        set=function(self,value) 
            set_current_parameter(3,"loadAlways",value)
        end,
        disabled=function() return hidden_function() end,
        get=function(self)
            return get_current_parameter(3,"loadAlways")
        end,
    }
     
    args["showUnitClasses_prot"]={
        type="multiselect",
        name="Show when unit class is",
        order=22,
        values={["Warrior"]="Warrior",["Death Knight"]="Death Knight",Rogue="Rogue",Monk="Monk",Paladin="Paladin",Druid="Druid",Shaman="Shaman",Priest="Priest",Mage="Mage",Warlock="Warlock",Hunter="Hunter",["Demon Hunter"]="Demon Hunter"},
        set=function(self,key,value) 
            set_current_parameter(3,key,value)
        end,
        hidden=function() return hidden_function(3) end,
        get=function(self,key)
            return get_current_parameter(3,key)
        end,
    }    
     
    args["showUnitRoleHeader_prot"]={
        name="Unit role",
        type="header",  
        order=30,
    }
     
     
    args["showUnitRolesAny_prot"]={
        name=highlight_colour.."Any",
        type="toggle",
        order=31,
        set=function(self,value) 
            set_current_parameter(4,"loadAlways",value)
        end,
        disabled=function() return hidden_function() end,
        get=function(self)
            return get_current_parameter(4,"loadAlways")
        end,
    }
       
       
    args["showUnitRoles_prot"]={
        name="Show when unit role is",
        type="multiselect",
        order=32,
        values={DAMAGER="DPS",HEALER="Healer",TANK="Tank"},
        set=function(self,key,value) 
            set_current_parameter(4,key,value)
        end,
        hidden=function() return hidden_function(4) end,
        get=function(self,key) 
            return get_current_parameter(4,key)
        end,
    }
    
end

--instance and encounter, starts at 40
do
    args["showInstancesHeader_prot"]={
        name="Instances",
        type="header",  
        order=40,
    }
     

    args["showInstancesAny_prot"]={
        name=highlight_colour.."Any",
        type="toggle",
        order=41,
        set=function(self,value) 
            set_current_parameter(5,"loadAlways",value)
        end,
        disabled=function() return hidden_function() end,
        get=function(self)
            return get_current_parameter(5,"loadAlways")
        end,
    }
       
       

    args["instances_list_prot"]={
        type="input",
        order=42,
        desc=function() return eF.interface_list_help_tooltip("instance names/IDs") end,
        width="full",
        name="Instance name/ID whitelist",
        hidden=function() return hidden_function(5) end,
        multiline=true,
        set=function(self,value)
            print(value)
            set_multiline_parameter(5,value)
        end,
        get=function(self) 
            return get_multiline_parameter(5)
        end,
    }
end






