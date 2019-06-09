local eF=elFramo
local layouts=elFramo.optionsTable.args.layouts
local args=layouts.args
eF.optionsTable.currently_selected_layout=nil
local tContains=tContains
local deepcopy=eF.table_deep_copy
local wipe=table.wipe

local function add_new_layout_by_name(name)
    local name=eF.find_valid_name_in_table(name,eF.registered_layouts)
    eF:register_new_layout(name)
    args.layout_drop_down:set(name)
end

local function remove_layout_by_name(name)
    if not eF.registered_layouts[name] then return end
    eF.registered_layouts[name]:setVisible(false)
    eF.registered_layouts[name]=nil
    wipe(eF.para.layouts[name])
    eF.para.layouts[name]=nil
    eF.optionsTable.currently_selected_layout=nil
end

local function copy_layout_by_name_to_new(name,new)
    if not eF.registered_layouts[name] then return end
    local new=eF.find_valid_name_in_table(new,eF.registered_layouts)
    eF.para.layouts[new]=deepcopy(eF.para.layouts[name])
    
    add_new_layout_by_name(new)    
end

--add layout creator/picker
do
    args["help_message"]={
        type="description",
        fontSize="small",
        order=1,
        name="|cFFFFF569Note|r: Multiple layouts can be active at the same time. The visibility of layouts is individually controlled in the 'Show' options."
    }
    
    args["layout_drop_down"]={
        type="select",
        order=2,
        style="dropdown",
        name="Layout:",
        --values={test="test"},
        values=function(self)               
                if not eF.para then return end
                local tbl={}
                for k,v in pairs(eF.para.layouts) do tbl[k]=k end
                self.values=tbl
                return tbl
            end,
        set=function(self,val) 
                eF.optionsTable.currently_selected_layout=val
            end,
        get=function(self) 
                if not eF.optionsTable.currently_selected_layout then 
                    for k,v in pairs(args) do
                        if not (k=="layout_drop_down" or k=="add_new_layout") then v.disabled=true end
                    end
                else
                    for k,v in pairs(args) do
                        if not (k=="layout_drop_down" or k=="add_new_layout") then v.disabled=false end
                    end
                end
                return eF.optionsTable.currently_selected_layout
            end,         
    }
     
    args["add_new_layout"]={
        type="input",
        order=5,
        name="Add new layout",
        set=function(self,name)
                name=string.gsub(name, "%s+", "")
                if not name or name=="" then return end
                add_new_layout_by_name(name)
            end,
        get=function(self) 
                return "" 
            end,
    }   
    
    args["remove_current_layout"]={
        type="execute",
        order=4,
        width="half",
        confirm=function() 
            if not eF.optionsTable.currently_selected_layout then return false end
            return string.format("Are you sure you want to delete the layout '%s'. This is not reversible.",eF.optionsTable.currently_selected_layout or "(nothing selected)") 
            end,
                    name="Delete",
        func=function(self)
                if not eF.optionsTable.currently_selected_layout then
                    --TOAD ERROR MESSAGE
                else               
                    remove_layout_by_name(eF.optionsTable.currently_selected_layout) 
                end                
            end,
    }
    
    args["duplicate_current_layout"]={
        type="execute",
        order=3,
        width="half",
        confirm=false,         
        name="Duplicate",
        func=function(self,val)
                local name=eF.optionsTable.currently_selected_layout or nil
                if not name then
                    --ERROR MESSAGE
                else                               
                    copy_layout_by_name_to_new(name,name)
                end                
            end,
    }
       
    args["rename_current_layout"]={
        type="input",
        order=5,
        name="Rename layout to",
        set=function(self,name)
                name=string.gsub(name, "%s+", "")
                if not name or name=="" then return end
                local old=eF.optionsTable.currently_selected_layout or nil
                if not old then return end
                local new_name=eF.find_valid_name_in_table(name,eF.registered_layouts)
                copy_layout_by_name_to_new(old,new_name)
                remove_layout_by_name(old)
                args.layout_drop_down:set(new_name)
            end,
        get=function(self) 
                return "" 
            end,
    }   
    
end


--add layout options main frames
do

    args["layout_options"]={
        type="group",
        name="Layout",
        order=1,
        args={},
    }
        
    args["load_options"]={
        type="group",
        name="Show",
        args={},
        order=2,
    }
    
    args["frame_options"]={
        type="group",
        name="Unit Frames",
        args={},
        order=3,
    }
    
    args["flags_options"]={
        type="group",
        name="Flag Frames",
        order=4, 
        args={
            dead_frame={
                type="group",
                name="Dead",
                args={},
            },
            offline_frame={
                type="group",
                name="Offline",
                args={},
            },
            summon_frame={
                type="group",
                name="Summon",
                args={},
            },         
        },
    }
   
    args["range_options"]={
        type="group",
        name="Out of range",
        args={},
        order=5,
    }

 
end