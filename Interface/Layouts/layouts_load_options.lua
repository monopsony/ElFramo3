local eF=elFramo
local layouts=elFramo.optionsTable.args.layouts
local args=layouts.args.load_options.args

local highlight_colour="|cFFFFF569"

--when to show
do  

    local function update_selected_layout_attribute(key,value)
        eF.para.layouts[eF.optionsTable.currently_selected_layout].parameters[key]=value
        eF.registered_layouts[eF.optionsTable.currently_selected_layout]:checkVisibility()      
    end
    
    args["show_options"]={
        name="When to show",
        type="header",  
        order=1,
    }
    
    args["showRaid"]={
        name="Show in raid",
        type="toggle",
        order=2,
        set=function(self,key) 
            update_selected_layout_attribute("showRaid",key)
        end,
        
        get=function(self) 
            return eF.para.layouts[eF.optionsTable.currently_selected_layout].parameters.showRaid
        end,
    }

    args["showParty"]={
        name="Show in party",
        type="toggle",
        order=3,
        set=function(self,key) 
            update_selected_layout_attribute("showParty",key)
        end,
        
        get=function(self) 
            return eF.para.layouts[eF.optionsTable.currently_selected_layout].parameters.showParty
        end,
    }
      
    args["showSolo"]={
        name="Show when solo",
        type="toggle",
        order=4,
        set=function(self,key) 
            update_selected_layout_attribute("showSolo",key)
        end,
        
        get=function(self) 
            return eF.para.layouts[eF.optionsTable.currently_selected_layout].parameters.showSolo
        end,
    }
      
    local function update_selected_layout_show_classes(key,value)
        eF.para.layouts[eF.optionsTable.currently_selected_layout].parameters.show_classes[key]=value
        eF.registered_layouts[eF.optionsTable.currently_selected_layout]:checkVisibility()   
    end
    local function update_selected_layout_show_roles(key,value)
        eF.para.layouts[eF.optionsTable.currently_selected_layout].parameters.show_roles[key]=value
        eF.registered_layouts[eF.optionsTable.currently_selected_layout]:checkVisibility()   
    end
    
    args["showRoles"]={
        name="Show when player role is",
        type="multiselect",
        order=5,
        values={Any=highlight_colour.."Any|r",DAMAGER="DPS",HEALER="Healer",TANK="Tank"},
        set=function(self,key,value) 
            update_selected_layout_show_roles(key,value)
        end,
        
        get=function(self,key) 
            return eF.para.layouts[eF.optionsTable.currently_selected_layout].parameters.show_roles[key]
        end,
    }
     
    args["showClasses"]={
        name="Show when player class is",
        type="multiselect",
        order=6,
        values={Any=highlight_colour.."Any|r",["Warrior"]="Warrior",["Death Knight"]="Death Knight",Rogue="Rogue",Monk="Monk",Paladin="Paladin",Druid="Druid",Shaman="Shaman",Priest="Priest",Mage="Mage",Warlock="Warlock",Hunter="Hunter",["Demon Hunter"]="Demon Hunter"},
        set=function(self,key,value) 
            update_selected_layout_show_classes(key,value)
        end,
        
        get=function(self,key)
            local bool=eF.para.layouts[eF.optionsTable.currently_selected_layout].parameters.show_classes[key]
            return bool
        end,
    }
    
end


--filters
do
    local function set_current_layout_attribute(key,value)
        local name=eF.optionsTable.currently_selected_layout or nil
        if not name then return end
        eF.para.layouts[name].attributes[key]=value
        eF:apply_layout_para_index(name)
    end

    local function get_current_attribute(key)
        local name=eF.optionsTable.currently_selected_layout or nil
        if not name then return end
        return eF.para.layouts[name].attributes[key]
    end
    
    local function update_selected_layout_parameter(key,value)
        eF.para.layouts[eF.optionsTable.currently_selected_layout].parameters[key]=value
        eF.registered_layouts[eF.optionsTable.currently_selected_layout]:updateFilters()     
        
    end
    
    args["filter_options"]={
        name="Filters",
        type="header",  
        order=21,
    }
    
    args["filter_player"]={
        name="Create frame for player",
        type="toggle",
        order=22,
        set=function(self,key) 
            update_selected_layout_parameter("filter_player",key)
        end,
        
        get=function(self) 
            return eF.para.layouts[eF.optionsTable.currently_selected_layout].parameters.filter_player
        end,
    }
      
    local function update_selected_layout_filter_classes(key,value)
        eF.para.layouts[eF.optionsTable.currently_selected_layout].parameters.filter_classes[key]=value
        eF.registered_layouts[eF.optionsTable.currently_selected_layout]:updateFilters()   
    end
    local function update_selected_layout_filter_roles(key,value)
        eF.para.layouts[eF.optionsTable.currently_selected_layout].parameters.filter_roles[key]=value
        eF.registered_layouts[eF.optionsTable.currently_selected_layout]:updateFilters()   
    end
    
    args["filter_roles"]={
        name="Create frames for roles:",
        type="multiselect",
        order=23,
        values={Any=highlight_colour.."Any|r",DAMAGER="DPS",HEALER="Healer",TANK="Tank"},
        set=function(self,key,value) 
            update_selected_layout_filter_roles(key,value)
        end,
        
        get=function(self,key) 
            return eF.para.layouts[eF.optionsTable.currently_selected_layout].parameters.filter_roles[key]
        end,
    }
     
    args["filter_classes"]={
        name="Create frames for classes:",
        type="multiselect",
        order=24,
        values={Any=highlight_colour.."Any|r",["Warrior"]="Warrior",["Death Knight"]="Death Knight",Rogue="Rogue",Monk="Monk",Paladin="Paladin",Druid="Druid",Shaman="Shaman",Priest="Priest",Mage="Mage",Warlock="Warlock",Hunter="Hunter",["Demon Hunter"]="Demon Hunter"},
        set=function(self,key,value) 
            update_selected_layout_filter_classes(key,value)
        end,
        
        get=function(self,key)
            local bool=eF.para.layouts[eF.optionsTable.currently_selected_layout].parameters.filter_classes[key]
            return bool
        end,
    }
    
    
--mess with this
end




