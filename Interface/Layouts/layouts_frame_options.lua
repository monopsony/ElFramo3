local eF=elFramo
local layouts=elFramo.optionsTable.args.layouts
local args=layouts.args.frame_options.args

local LSM=LibStub:GetLibrary("LibSharedMedia-3.0")

local ipairs=ipairs
local function set_current_layout_parameter(key,value)
    local name=eF.optionsTable.currently_selected_layout or nil
    if not name then return end
    eF.para.layouts[name].parameters[key]=value
    eF.current_layout_version=eF.current_layout_version+1
    for _,v in ipairs(eF.list_all_active_unit_frames()) do 
        v:updateUnit() 
    end 
end

local function get_current_parameter(key)
    local name=eF.optionsTable.currently_selected_layout or nil
    if not name then return end
    return eF.para.layouts[name].parameters[key]
end

local positions={CENTER="CENTER",RIGHT="RIGHT",TOPRIGHT="TOPRIGHT",TOP="TOP",TOPLEFT="TOPLEFT",LEFT="LEFT",BOTTOMLEFT="BOTTOMLEFT",BOTTOM="BOTTOM",BOTTOMRIGHT="BOTTOMRIGHT"}

do 

    args["Name"]={
        order=21,
        type="header",
        name="Name",
    }
    
    args["font_size"]={
        order=22,
        type="range",
        name="Font size",
        softMin=5,
        softMax=25,
        isPercent=false,
        step=1,
        set=function(self,value)
            set_current_layout_parameter("textSize",value)
        end,
        get=function(self)
            return get_current_parameter("textSize")
        end,
    }
    

    args["text_font"]={
        name="Font",
        type="select",
        style="dropdown",
        dialogControl="LSM30_Font",
        order=23,
        values=LSM:HashTable("font"),
        set=function(self,value)
            set_current_layout_parameter("textFont",value)
        end,
        get=function(self)
            return get_current_parameter("textFont")
        end,
    }
    
    
    args["text_limit"]={
        order=24,
        type="range",
        name="Characters",
        min=1,
        softMax=10,
        isPercent=false,
        step=1,
        set=function(self,value)
            set_current_layout_parameter("textLim",value)
        end,
        get=function(self)
            return get_current_parameter("textLim")
        end,
    }
    
    args["text_position"]={
        name="Position",
        type="select",
        style="dropdown",
        order=26,
        values=positions,
        set=function(self,value)
            local name=eF.optionsTable.currently_selected_layout or nil
            set_current_layout_parameter("textPos",value)
        end,
        get=function(self)
            return get_current_parameter("textPos")
        end,
    }
    
    args["text_XOS"]={
        order=27,
        type="range",
        name="X Offset",
        softMax=20,
        softMin=-20,
        isPercent=false,
        step=1,
        set=function(self,value)
            set_current_layout_parameter("textXOS",value)
        end,
        get=function(self)
            return get_current_parameter("textXOS")
        end,
    }
    
    args["text_YOS"]={
        order=28,
        type="range",
        name="Y Offset",
        softMax=20,
        softMin=-20,
        isPercent=false,
        step=1,
        set=function(self,value)
            set_current_layout_parameter("textYOS",value)
        end,
        get=function(self)
            return get_current_parameter("textYOS")
        end,
    }
    
    
    args["text_color"]={
        order=29,
        type="color",
        name="Color",
        hasAlpha=true,
        disabled=function()
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            return eF.para.layouts[name].parameters["textColorByClass"]
        end,
        set=function(self,R,G,B,A)
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            eF.para.layouts[name].parameters["textR"]=R
            eF.para.layouts[name].parameters["textG"]=G
            eF.para.layouts[name].parameters["textB"]=B
            eF.para.layouts[name].parameters["textA"]=A
            eF.current_layout_version=eF.current_layout_version+1
            for _,v in ipairs(eF.list_all_active_unit_frames()) do 
                v:updateUnit() 
            end 
        end,
        get=function(self)
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            R,G,B,A=eF.para.layouts[name].parameters["textR"],eF.para.layouts[name].parameters["textG"],eF.para.layouts[name].parameters["textB"],eF.para.layouts[name].parameters["textA"]
            return R,G,B,A
        end
    }
    
    
    args["text_color_byclass"]={
        name="Color by class",
        type="toggle",
        order=30,
        set=function(self,key) 
            set_current_layout_parameter("textColorByClass",key)
        end,
        
        get=function(self) 
            return get_current_parameter("textColorByClass")
        end,
    }
    
end





































