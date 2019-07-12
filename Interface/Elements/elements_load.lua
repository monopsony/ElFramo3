local eF=elFramo
eF.interface_elements_load_config_table={}
local args=eF.interface_elements_load_config_table
local highlight_colour="|cFFFFF569"

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
        return bool or eF.para.elements[name].load[index].Any
    end
end

--roles & classes
do
        
    args["loadAlways"]={
        name="Always load",
        type="toggle",
        order=2,
        set=function(self,key) 
            set_current_parameter(nil,"loadAlways",key)
        end,
        
        get=function(self) 
            return get_current_parameter(nil,"loadAlways")
        end,
    }

    args["loadNever"]={
        name="Never load",
        type="toggle",
        order=3,
        set=function(self,key) 
            set_current_parameter(nil,"loadNever",key)
        end,
        
        get=function(self) 
            return get_current_parameter(nil,"loadNever")
        end,
    }
       
    args["showPlayerClassHeader"]={
        name="Show when player class is",
        type="header",  
        order=4,
    }
    
        
       
    args["showPlayerClassesAny"]={
        name=highlight_colour.."Any",
        type="toggle",
        order=5,
        set=function(self,value) 
            set_current_parameter(1,"Any",value)
        end,
        disabled=function() hidden_function() end,
        get=function(self)
            return get_current_parameter(1,"Any")
        end,
    }
 
  
    args["showPlayerClasses"]={
        name="Show when player class is",
        type="multiselect",
        order=6,
        values={["Warrior"]="Warrior",["Death Knight"]="Death Knight",Rogue="Rogue",Monk="Monk",Paladin="Paladin",Druid="Druid",Shaman="Shaman",Priest="Priest",Mage="Mage",Warlock="Warlock",Hunter="Hunter",["Demon Hunter"]="Demon Hunter"},
        set=function(self,key,value) 
            set_current_parameter(1,key,value)
        end,
        disabled=function() hidden_function(1) end,
        get=function(self,key)
            return get_current_parameter(1,key)
        end,
    }
       
    args["showPlayerRoleHeader"]={
        name="Show when player role is",
        type="header",  
        order=10,
    }
       
    args["showPlayerRolesAny"]={
        name=highlight_colour.."Any",
        type="toggle",
        order=11,
        set=function(self,value) 
            set_current_parameter(2,"Any",value)
        end,
        disabled=function() hidden_function() end,
        get=function(self)
            return get_current_parameter(2,"Any")
        end,
    }
       
    args["showPlayerRoles"]={
        type="multiselect",
        order=12,
        values={DAMAGER="DPS",HEALER="Healer",TANK="Tank"},
        set=function(self,key,value) 
            set_current_parameter(2,key,value)
        end,
        disabled=function() hidden_function(2) end,
        get=function(self,key) 
            return get_current_parameter(2,key)
        end,
    }
     
     
    args["showUnitClassesHeader"]={
        name="Show when unit class is",
        type="header",  
        order=20,
    }
     
     
    args["showPlayerRolesAny"]={
        name=highlight_colour.."Any",
        type="toggle",
        order=21,
        set=function(self,value) 
            set_current_parameter(3,"Any",value)
        end,
        disabled=function() hidden_function() end,
        get=function(self)
            return get_current_parameter(3,"Any")
        end,
    }
     
    args["showUnitClasses"]={
        type="multiselect",
        order=21,
        values={["Warrior"]="Warrior",["Death Knight"]="Death Knight",Rogue="Rogue",Monk="Monk",Paladin="Paladin",Druid="Druid",Shaman="Shaman",Priest="Priest",Mage="Mage",Warlock="Warlock",Hunter="Hunter",["Demon Hunter"]="Demon Hunter"},
        set=function(self,key,value) 
            set_current_parameter(3,key,value)
        end,
        disabled=function() hidden_function(3) end,
        get=function(self,key)
            return get_current_parameter(3,key)
        end,
    }
       
     
    args["showUnitRoleHeader"]={
        name="Show when unit role is",
        type="header",  
        order=30,
    }
     
     
    args["showUnitRolesAny"]={
        name=highlight_colour.."Any",
        type="toggle",
        order=31,
        set=function(self,value) 
            set_current_parameter(4,"Any",value)
        end,
        disabled=function() hidden_function() end,
        get=function(self)
            return get_current_parameter(4,"Any")
        end,
    }
       
       
    args["showUnitRoles"]={
        type="multiselect",
        order=32,
        values={DAMAGER="DPS",HEALER="Healer",TANK="Tank"},
        set=function(self,key,value) 
            set_current_parameter(4,key,value)
        end,
        disabled=function() hidden_function(4) end,
        get=function(self,key) 
            return get_current_parameter(4,key)
        end,
    }
    
    
end


