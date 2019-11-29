local eF=elFramo
local layouts=elFramo.optionsTable.args.layouts

local flag_frames={"dead","offline","mc"}
local positions={CENTER="CENTER",RIGHT="RIGHT",TOPRIGHT="TOPRIGHT",TOP="TOP",TOPLEFT="TOPLEFT",LEFT="LEFT",BOTTOMLEFT="BOTTOMLEFT",BOTTOM="BOTTOM",BOTTOMRIGHT="BOTTOMRIGHT"}
local LSM=LibStub:GetLibrary("LibSharedMedia-3.0")

local ipairs=ipairs
local function set_current_parameter(flag,key,value)
    local name=eF.optionsTable.currently_selected_layout or nil
    if not name then return end
    if not flag then return end
    eF.para.layouts[name].parameters.flagFrames[flag][key]=value
    eF.current_layout_version=eF.current_layout_version+1
    for _,v in ipairs(eF.list_all_active_unit_frames(name)) do 
        v:updateUnit() 
    end 
end

local function get_current_parameter(flag,key)
    local name=eF.optionsTable.currently_selected_layout or nil
    if not name then return end
    if not flag then return end
    return eF.para.layouts[name].parameters.flagFrames[flag][key]
end


--general settings
for k,v in ipairs(flag_frames) do 
    local name=v
    local args=layouts.args.flags_options.args[name].args
    
    args["frame_color"]={
        order=10,
        type="color",
        name="Frame color",
        hasAlpha=true,
        set=function(self,R,G,B,A)
            local flag=self[2]
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end       
            eF.para.layouts[name].parameters.flagFrames[flag]["frameR"]=R
            eF.para.layouts[name].parameters.flagFrames[flag]["frameG"]=G
            eF.para.layouts[name].parameters.flagFrames[flag]["frameB"]=B
            set_current_parameter(flag,"frameA",A)
        end,
        get=function(self)
            local name=eF.optionsTable.currently_selected_layout or nil
            local flag=self[2]
            if not name then return end
            R,G,B,A=get_current_parameter(flag,"frameR"),get_current_parameter(flag,"frameG"),get_current_parameter(flag,"frameB"),get_current_parameter(flag,"frameA")
            return R,G,B,A
        end
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
            local flag=self[2]
            set_current_parameter(flag,"textSize",value)
        end,
        get=function(self)
            local flag=self[2]
            return get_current_parameter(flag,"textSize")
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
            local flag=self[2]
            set_current_parameter(flag,"textFont",value)
        end,
        get=function(self)
            local flag=self[2]
            return get_current_parameter(flag,"textFont")
        end,
    }
    
    
    args["text_position"]={
        name="Position",
        type="select",
        style="dropdown",
        order=26,
        values=positions,
        set=function(self,value)
            local flag=self[2]
            set_current_parameter(flag,"textPos",value)
        end,
        get=function(self)
            local flag=self[2]
            return get_current_parameter(flag,"textPos")
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
            local flag=self[2]
            set_current_parameter(flag,"textXOS",value)
        end,
        get=function(self)
            local flag=self[2]
            return get_current_parameter(flag,"textXOS")
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
            local flag=self[2]
            set_current_parameter(flag,"textYOS",value)
        end,
        get=function(self)
            local flag=self[2]
            return get_current_parameter(flag,"textYOS")
        end,
    }
    
    
    args["text_color"]={
        order=29,
        type="color",
        name="Text color",
        hasAlpha=true,
        set=function(self,R,G,B,A)
            local flag=self[2]
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end       
            eF.para.layouts[name].parameters.flagFrames[flag]["textR"]=R
            eF.para.layouts[name].parameters.flagFrames[flag]["textG"]=G
            eF.para.layouts[name].parameters.flagFrames[flag]["textB"]=B
            set_current_parameter(flag,"textA",A)
        end,
        get=function(self)
            local name=eF.optionsTable.currently_selected_layout or nil
            local flag=self[2]
            if not name then return end
            R,G,B,A=get_current_parameter(flag,"textR"),get_current_parameter(flag,"textG"),get_current_parameter(flag,"textB"),get_current_parameter(flag,"textA")
            return R,G,B,A
        end
    }
    
    
end