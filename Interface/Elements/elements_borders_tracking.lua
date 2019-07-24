local eF=elFramo
local args=eF.interface_elements_config_tables["border"].tracking.args
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


do
    local trackTypes={["PLAYER HELPFUL"]="Player Buffs",["PLAYER HARMFUL"]="Player Debuffs",["HELPFUL"]="Any Buffs",["HARMFUL"]="Any Debuffs",["Static"]="Static"}
    args["trackType"]={
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

    local function aura_hide()
        local name=eF.optionsTable.currently_selected_element_key or nil
        if not name then return "N/A" end
        local trackType=eF.para.elements[name].trackType
        if trackType=="PLAYER HELPFUL" or trackType=="PLAYER HARMFUL" or trackType=="HELPFUL" or trackType=="HARMFUL" then return false else return true end 
    end

    local adoptFuncs={["Name"]="Name",["Spell ID"]="Spell ID",["Custom"]="Custom"}
    args["adoptFunc"]={
        name="Adopt by",
        type="select",
        style="dropdown",
        order=2,
        hidden=aura_hide,
        values=adoptFuncs,
        set=function(self,value)
            set_current_parameter("adoptFunc",value)
            set_current_parameter("arg1",nil)
        end,
        get=function(self)
            return get_current_parameter("adoptFunc")
        end, 
    }

    args["arg1_name"]={
        type="input",
        order=3,
        hidden=function() return aura_hide() or (not (eF.para.elements[eF.optionsTable.currently_selected_element_key].adoptFunc=="Name")) end,
        name="Name",
        set=function(self,value)
            set_current_parameter("arg1",value)
            end,
        get=function(self) 
            return get_current_parameter("arg1")
        end,
    }
    
    args["arg1_spellID"]={
        type="input",
        order=3,
        hidden=function() return aura_hide() or (not (eF.para.elements[eF.optionsTable.currently_selected_element_key].adoptFunc=="Spell ID")) end,
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



if false then 
--Dimensions
do

    args["dimensions"]={
        order=1,
        type="header",
        name="Dimensions",
    }

    args["width"]={
        order=2,
        type="range",
        name="Width",
        softMin=20,
        softMax=250,
        isPercent=false,
        step=5,
        set=function(self,value)
            set_current_parameter("width",value)
        end,
        get=function(self)
            return get_current_parameter("width")
        end,
    }
    
    args["height"]={
        order=3,
        type="range",
        name="Height",
        softMin=20,
        softMax=250,
        isPercent=false,
        step=5,
        set=function(self,value)
            set_current_parameter("height",value)
        end,
        get=function(self)
            return get_current_parameter("height")
        end,
    }
    
end

--Health
do

    args["health"]={
        order=11,
        type="header",
        name="Health bar",
    }

    args["orientation"]={
        name="Orientation",
        type="select",
        style="dropdown",
        order=12,
        values=orientations,
        set=function(self,value)
            local name=eF.optionsTable.currently_selected_layout or nil
            set_current_parameter("healthGrow",value)
        end,
        get=function(self)
            return get_current_parameter("healthGrow")
        end,
    }
    
    args["hp_color_byclass"]={
        name="Color by class",
        type="toggle",
        order=13,
        set=function(self,key) 
            set_current_parameter("byClassColor",key)
        end,
        
        get=function(self) 
            return get_current_parameter("byClassColor")
        end,
    }
    
    args["hp_color"]={
        order=14,
        type="color",
        name="Color",
        hasAlpha=true,
        disabled=function()
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            return eF.para.layouts[name].parameters["byClassColor"]
        end,
        set=function(self,R,G,B,A)
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            eF.para.layouts[name].parameters["hpR"]=R
            eF.para.layouts[name].parameters["hpG"]=G
            eF.para.layouts[name].parameters["hpB"]=B
            eF.para.layouts[name].parameters["hpA"]=A
            eF.current_layout_version=eF.current_layout_version+1
            for _,v in ipairs(eF.list_all_active_unit_frames()) do 
                v:updateUnit() 
            end 
        end,
        get=function(self)
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            R,G,B,A=eF.para.layouts[name].parameters["hpR"],eF.para.layouts[name].parameters["hpG"],eF.para.layouts[name].parameters["hpB"],eF.para.layouts[name].parameters["hpA"]
            return R,G,B,A
        end
    }
    
    args["gradient"]={
        name="Gradient",
        type="toggle",
        order=15,
        set=function(self,key) 
            set_current_parameter("hpGrad",key)
        end,
        
        get=function(self) 
            return get_current_parameter("hpGrad")
        end,
    }
    
    args["gradient_start"]={
        order=16,
        type="color",
        name="Gradient start",
        hasAlpha=true,
        disabled=function()
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            return not eF.para.layouts[name].parameters["hpGrad"]
        end,
        set=function(self,R,G,B,A)
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            eF.para.layouts[name].parameters["hpGrad1R"]=R
            eF.para.layouts[name].parameters["hpGrad1G"]=G
            eF.para.layouts[name].parameters["hpGrad1B"]=B
            eF.para.layouts[name].parameters["hpGrad1A"]=A
            eF.current_layout_version=eF.current_layout_version+1
            for _,v in ipairs(eF.list_all_active_unit_frames()) do 
                v:updateUnit() 
            end 
        end,
        get=function(self)
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            R,G,B,A=eF.para.layouts[name].parameters["hpGrad1R"],eF.para.layouts[name].parameters["hpGrad1G"],eF.para.layouts[name].parameters["hpGrad1B"],eF.para.layouts[name].parameters["hpGrad1A"]
            return R,G,B,A
        end
    }
    
    args["gradient_end"]={
        order=17,
        type="color",
        name="Gradient end",
        hasAlpha=true,
        disabled=function()
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            return not eF.para.layouts[name].parameters["hpGrad"]
        end,
        set=function(self,R,G,B,A)
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            eF.para.layouts[name].parameters["hpGrad2R"]=R
            eF.para.layouts[name].parameters["hpGrad2G"]=G
            eF.para.layouts[name].parameters["hpGrad2B"]=B
            eF.para.layouts[name].parameters["hpGrad2A"]=A
            eF.current_layout_version=eF.current_layout_version+1
            for _,v in ipairs(eF.list_all_active_unit_frames()) do 
                v:updateUnit() 
            end 
        end,
        get=function(self)
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            R,G,B,A=eF.para.layouts[name].parameters["hpGrad2R"],eF.para.layouts[name].parameters["hpGrad2G"],eF.para.layouts[name].parameters["hpGrad2B"],eF.para.layouts[name].parameters["hpGrad2A"]
            return R,G,B,A
        end
    }
    
    args["gradient_orientation"]={
        name="Gradient orientation",
        type="select",
        style="dropdown",
        order=18,
        disabled=function()
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            return not eF.para.layouts[name].parameters["hpGrad"]
        end,
        values={VERTICAL="Vertical",HORIZONTAL="Horizontal"},
        set=function(self,value)
            local name=eF.optionsTable.currently_selected_layout or nil
            set_current_parameter("hpGradOrientation",value)
        end,
        get=function(self)
            return get_current_parameter("hpGradOrientation")
        end,
    }
    
    
end

--name
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
            set_current_parameter("textSize",value)
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
            set_current_parameter("textFont",value)
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
            set_current_parameter("textLim",value)
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
            set_current_parameter("textPos",value)
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
            set_current_parameter("textXOS",value)
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
            set_current_parameter("textYOS",value)
        end,
        get=function(self)
            return get_current_parameter("textYOS")
        end,
    }
    
    
    args["text_color"]={
        order=30,
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
        order=29,
        set=function(self,key) 
            set_current_parameter("textColorByClass",key)
        end,
        
        get=function(self) 
            return get_current_parameter("textColorByClass")
        end,
    }
    
end

--border
do

    args["border"]={
        order=41,
        type="header",
        name="Border",
    }

    args["border_width"]={
        order=42,
        name="Thickness",
        type="range",
        min=0,
        softMax=6,
        isPercent=false,
        step=1,
        set=function(self,value)
            set_current_parameter("borderSize",value)
        end,
        get=function(self)
            return get_current_parameter("borderSize")
        end,
    }
    
  
    args["border_color"]={
        order=43,
        type="color",
        name="Color",
        hasAlpha=true,
        set=function(self,R,G,B,A)
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            eF.para.layouts[name].parameters["borderR"]=R
            eF.para.layouts[name].parameters["borderG"]=G
            eF.para.layouts[name].parameters["borderB"]=B
            eF.para.layouts[name].parameters["borderA"]=A
            eF.current_layout_version=eF.current_layout_version+1
            for _,v in ipairs(eF.list_all_active_unit_frames()) do 
                v:updateUnit() 
            end 
        end,
        get=function(self)
            local name=eF.optionsTable.currently_selected_layout or nil
            if not name then return end
            R,G,B,A=eF.para.layouts[name].parameters["borderR"],eF.para.layouts[name].parameters["borderG"],eF.para.layouts[name].parameters["borderB"],eF.para.layouts[name].parameters["borderA"]
            return R,G,B,A
        end
    }
    

end

end


































