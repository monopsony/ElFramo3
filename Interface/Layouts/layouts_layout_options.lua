local eF=elFramo
local layouts=elFramo.optionsTable.args.layouts
local args=layouts.args.layout_options.args
--eF.optionsTable.currently_selected_layout
local highlight_colour="|cFFFFF569"
local deepcopy=eF.table_deep_copy


local function set_current_layout_parameter(key,value)
    local name=eF.optionsTable.currently_selected_layout or nil
    if not name then return end
    eF.para.layouts[name].parameters[key]=value
    eF:apply_layout_para_index(name)
end

local function get_current_parameter(key)
    local name=eF.optionsTable.currently_selected_layout or nil
    if not name then return end
    return eF.para.layouts[name].parameters[key]
end

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


--growth
do
    local orientations={[1]="Right-Down",[2]="Right-Up",[3]="Left-Down",[4]="Left-Up",[5]="Up-Right",[6]="Up-Left",[7]="Down-Right",[8]="Down-Left"}
    local orientation_to_grow12={[1]={"right","down"},
                                 [2]={"right","up"},
                                 [3]={"left","down"},
                                 [4]={"left","up"},
                                 [5]={"up","right"},
                                 [6]={"up","left"},
                                 [7]={"down","right"},
                                 [8]={"down","left"}}
    
    args["growth"]={
        name="Growth",
        type="header",  
        order=1,
    }

    args["grow"]={
        name="Grows...",
        type="select",
        style="dropdown",
        order=2,
        values=orientations,
        set=function(self,value)
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            local grow1,grow2=unpack(orientation_to_grow12[value])
            eF.para.layouts[name].parameters.grow1=grow1
            eF.para.layouts[name].parameters.grow2=grow2
            set_current_layout_parameter("grow",value)
        end,
        get=function(self)
            return get_current_parameter("grow")
        end,
    }

--[[
    args["grow2"]={
        name="then...",
        type="select",
        style="dropdown",
        order=3,
        values=orientations,
        set=function(self,value)
            set_current_layout_parameter("grow2",value)
        end,
        get=function(self)
            return get_current_parameter("grow2")
        end,
    } ]]--
    
    args["spacing"]={
        name="Spacing",
        type="range",
        softMin=0,
        softMax=50,
        order=4,
        isPercent=false,
        step=1,
        set=function(self,value)
            set_current_layout_parameter("spacing",value)
        end,
        get=function(self)
            return get_current_parameter("spacing")
        end,
    }  
        

end

--grouping
do
  
    args["grouping"]={
        name="Grouping",
        type="header",  
        order=11,
    }
    
    --toad: way to choose own order
    --toad group with gaps
    args["groupBy"]={
        name="Group by",
        type="select",
        style="dropdown",
        order=12,
        values={GROUP="Group",CLASS="Class",ROLE="Role"},
        set=function(self,value)
            set_current_layout_attribute("groupBy",value)
        end,
        get=function(self)
            return get_current_attribute("groupBy")
        end,
    }      
    
    args["by_group"]={
        name="Keep groups separated",
        type="toggle",
        order=13,
        set=function(self,value) 
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            local old=eF.para.layouts[name].parameters["by_group"]
            eF.para.layouts[name].parameters["by_group"]=value
            if old~=value then 
                if value then 
                    eF.para.layouts[name].attributes.unitsPerColumn=5
                end
                local tbl=deepcopy(eF.para.layouts[name])
                eF:remove_layout_by_name(name)                
                eF.para.layouts[name]=tbl
                eF:add_new_layout_by_name(name)   
                eF.layoutEventHandler:handleEvent("GROUP_ROSTER_UPDATE")
            end
            
        end,
        
        get=function(self) 
            return eF.para.layouts[eF.optionsTable.currently_selected_layout].parameters.by_group
        end,
    }
    
end

--positions
do
  
    args["position"]={
        name="Position",
        type="header",  
        order=21,
    }    
    
    local function move_header_to(x,y)
        local name=eF.optionsTable.currently_selected_layout or nil
        if x then eF.para.layouts[name].parameters.xPos=x end
        if y then eF.para.layouts[name].parameters.yPos=y end
        eF.registered_layouts[name]:set_position()
    end
    
    local screen_width,screen_height=math.floor(GetScreenWidth()+1),math.floor(GetScreenHeight()+1)
    
    args["xPos"]={
        name="X",
        type="range",
        min=0,
        max=screen_width,
        order=22,
        isPercent=false,
        step=1,
        set=function(self,value)
            move_header_to(value,nil)
        end,
        get=function(self)
            return get_current_parameter("xPos")
        end,
    }      
    
    args["yPos"]={
        name="Y",
        type="range",
        min=0,
        max=screen_height,
        order=23,
        isPercent=false,
        step=1,
        set=function(self,value)
            move_header_to(nil,value)
        end,
        get=function(self)
            return get_current_parameter("yPos")
        end
    }
end

--misc
do
  
    args["misc"]={
        name="Misc",
        type="header",  
        order=31,
    }  
    
    args["unitsPerColumn"]={
        name="Units per column/row",
        type="range",
        min=1,
        max=30,
        order=32,
        isPercent=false,
        step=1,
        disabled=function()
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            return eF.para.layouts[name].parameters["by_group"]
            end,
        set=function(self,value)
            set_current_layout_attribute("unitsPerColumn",value)
        end,
        get=function(self)
            return get_current_attribute("unitsPerColumn")
        end,
    }  
    
end










