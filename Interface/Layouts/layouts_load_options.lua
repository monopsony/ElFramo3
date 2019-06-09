local eF=elFramo
local layouts=elFramo.optionsTable.args.layouts
local args=layouts.args.load_options.args

local highlight_colour="|cFFFFF569"

--create attributes
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







