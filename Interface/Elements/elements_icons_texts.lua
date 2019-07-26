local eF=elFramo
local args=eF.interface_elements_config_tables["icon"].texts_prot.args
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

local text_tracks={["Time left"]="Time left",["Stacks"]="Stacks"}
local anchors={CENTER="CENTER",RIGHT="RIGHT",TOPRIGHT="TOPRIGHT",TOP="TOP",TOPLEFT="TOPLEFT",LEFT="LEFT",BOTTOMLEFT="BOTTOMLEFT",BOTTOM="BOTTOM",BOTTOMRIGHT="BOTTOMRIGHT"} 


--text 1
do

    args["text_header_prot"]={
        order=1,
        name="Text 1",
        type="header",  
    }
    
    args["hasText_prot"]={
        name="Has text 1",
        type="toggle",
        order=2,
        set=function(self,key) 
            set_current_parameter("hasText",key)
        end,
        
        get=function(self) 
            return get_current_parameter("hasText")
        end,
    }  
    
    args["textType_prot"]={
        order=3,
        name="Track",
        type="select",
        style="dropdown",
        values=text_tracks,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText)
        end,
        set=function(self,value)
            set_current_parameter("textType",value)
        end,
        get=function(self)
            return get_current_parameter("textType")
        end,
    }
      
    args["textFont_prot"]={
        name="Font",
        type="select",
        style="dropdown",
        dialogControl="LSM30_Font",
        order=4,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText)
        end,
        values=LSM:HashTable("font"),
        set=function(self,value)
            set_current_parameter("textFont",value)
        end,
        get=function(self)
            return get_current_parameter("textFont")
        end,
    }
      
    args["textColor_prot"]={
        order=5,
        type="color",
        name="Color",
        hasAlpha=true,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText)
        end,
        set=function(self,R,G,B,A)
            local name=eF.optionsTable.currently_selected_element_key or nil
            if not name then return end
            local para=eF.para.elements[name]
            para.textR=R
            para.textG=G
            para.textB=B
            set_current_parameter("textA",A)
        end,
        get=function(self)
            local name=eF.optionsTable.currently_selected_element_key or nil
            if not name then return end
            local para=eF.para.elements[name]
            R,G,B,A=para.textR,para.textG,para.textB,para.textA
            return R,G,B,A
        end
    } 
    
    args["decimals_prot"]={
        order=6,
        type="range",
        name="Decimal places",
        min=0,
        max=6,
        isPercent=false,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText)
        end,
        step=1,
        set=function(self,value)
            set_current_parameter("textDecimals",value)
        end,
        get=function(self)
            return get_current_parameter("textDecimals")
        end,
    }
         
    args["textSize_prot"]={
        order=7,
        type="range",
        name="Size",
        min=1,
        softMax=50,
        isPercent=false,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText)
        end,
        step=1,
        set=function(self,value)
            set_current_parameter("textSize",value)
        end,
        get=function(self)
            return get_current_parameter("textSize")
        end,
    }
    
    args["textAnchor_prot"]={
        name="Anchor",
        type="select",
        style="dropdown",
        order=8,
        values=anchors,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText)
        end,
        set=function(self,value)
            set_current_parameter("textAnchor",value)
        end,
        get=function(self)
            return get_current_parameter("textAnchor")
        end,
    }

    args["textAnchorTo_prot"]={
        name="Anchor to",
        type="select",
        style="dropdown",
        order=9,
        values=anchors,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText)
        end,
        set=function(self,value)
            set_current_parameter("textAnchorTo",value)
        end,
        get=function(self)
            return get_current_parameter("textAnchorTo")
        end,
    }

    args["XOffset_prot"]={
        order=10,
        type="range",
        name="X Offset",
        softMin=-50,
        softMax=50,
        isPercent=false,
        step=1,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText)
        end,
        set=function(self,value)
            set_current_parameter("textXOS",value)
        end,
        get=function(self)
            return get_current_parameter("textXOS")
        end,
    }
 
    args["YOffset_prot"]={
        order=11,
        type="range",
        name="Y Offset",
        softMin=-50,
        softMax=50,
        isPercent=false,
        step=1,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText)
        end,
        set=function(self,value)
            set_current_parameter("textYOS",value)
        end,
        get=function(self)
            return get_current_parameter("textYOS")
        end,
    }
        
end

--text2 2
do

    args["text2_header_prot"]={
        order=31,
        name="Text 2",
        type="header",  
    }
    
    args["hastext2_prot"]={
        name="Has text 2",
        type="toggle",
        order=32,
        set=function(self,key) 
            set_current_parameter("hasText2",key)
        end,
        
        get=function(self) 
            return get_current_parameter("hasText2")
        end,
    }  
    
    args["text2Type_prot"]={
        order=33,
        name="Track",
        type="select",
        style="dropdown",
        values=text_tracks,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText2)
        end,
        set=function(self,value)
            set_current_parameter("text2Type",value)
        end,
        get=function(self)
            return get_current_parameter("text2Type")
        end,
    }
      
    args["text2Font_prot"]={
        name="Font",
        type="select",
        style="dropdown",
        dialogControl="LSM30_Font",
        order=34,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText2)
        end,
        values=LSM:HashTable("font"),
        set=function(self,value)
            set_current_parameter("text2Font",value)
        end,
        get=function(self)
            return get_current_parameter("text2Font")
        end,
    }
      
    args["text2Color_prot"]={
        order=35,
        type="color",
        name="Color",
        hasAlpha=true,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText2)
        end,
        set=function(self,R,G,B,A)
            local name=eF.optionsTable.currently_selected_element_key or nil
            if not name then return end
            local para=eF.para.elements[name]
            para.text2R=R
            para.text2G=G
            para.text2B=B
            set_current_parameter("text2A",A)
        end,
        get=function(self)
            local name=eF.optionsTable.currently_selected_element_key or nil
            if not name then return end
            local para=eF.para.elements[name]
            R,G,B,A=para.text2R,para.text2G,para.text2B,para.text2A
            return R,G,B,A
        end
    } 
    
    args["text2Decimals_prot"]={
        order=36,
        type="range",
        name="Decimal places",
        min=0,
        max=6,
        isPercent=false,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText2)
        end,
        step=1,
        set=function(self,value)
            set_current_parameter("text2Decimals",value)
        end,
        get=function(self)
            return get_current_parameter("text2Decimals")
        end,
    }
         
    args["text2Size_prot"]={
        order=37,
        type="range",
        name="Size",
        min=1,
        softMax=50,
        isPercent=false,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText2)
        end,
        step=1,
        set=function(self,value)
            set_current_parameter("text2Size",value)
        end,
        get=function(self)
            return get_current_parameter("text2Size")
        end,
    }
    
    args["text2Anchor_prot"]={
        name="Anchor",
        type="select",
        style="dropdown",
        order=38,
        values=anchors,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText2)
        end,
        set=function(self,value)
            set_current_parameter("text2Anchor",value)
        end,
        get=function(self)
            return get_current_parameter("text2Anchor")
        end,
    }

    args["text2AnchorTo_prot"]={
        name="Anchor to",
        type="select",
        style="dropdown",
        order=39,
        values=anchors,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText2)
        end,
        set=function(self,value)
            set_current_parameter("text2AnchorTo",value)
        end,
        get=function(self)
            return get_current_parameter("text2AnchorTo")
        end,
    }

    args["text2XOffset_prot"]={
        order=40,
        type="range",
        name="X Offset",
        softMin=-50,
        softMax=50,
        isPercent=false,
        step=1,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText2)
        end,
        set=function(self,value)
            set_current_parameter("text2XOS",value)
        end,
        get=function(self)
            return get_current_parameter("text2XOS")
        end,
    }
 
    args["text2YOffset_prot"]={
        order=41,
        type="range",
        name="Y Offset",
        softMin=-50,
        softMax=50,
        isPercent=false,
        step=1,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasText2)
        end,
        set=function(self,value)
            set_current_parameter("text2YOS",value)
        end,
        get=function(self)
            return get_current_parameter("text2YOS")
        end,
    }
        
end





