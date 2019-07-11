local eF=elFramo
local args=eF.interface_elements_config_tables["icon"].texts.args
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

    args["text_header"]={
        order=1,
        name="Text 1",
        type="header",  
    }
    
    args["hasText"]={
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
    
    args["textType"]={
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
      
    args["textFont"]={
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
      
    args["textColor"]={
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
    
    args["decimals"]={
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
         
    args["textSize"]={
        order=7,
        type="range",
        name="Text size",
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
    
    args["textAnchor"]={
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

    args["textAnchorTo"]={
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

    args["XOffset"]={
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
 
    args["YOffset"]={
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

    args["text2_header"]={
        order=31,
        name="text 2",
        type="header",  
    }
    
    args["hastext2"]={
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
    
    args["text2Type"]={
        order=33,
        name="Track",
        type="select",
        style="dropdown",
        values=text2_tracks,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hastext2)
        end,
        set=function(self,value)
            set_current_parameter("text2Type",value)
        end,
        get=function(self)
            return get_current_parameter("text2Type")
        end,
    }
      
    args["text2Font"]={
        name="Font",
        type="select",
        style="dropdown",
        dialogControl="LSM30_Font",
        order=34,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hastext2)
        end,
        values=LSM:HashTable("font"),
        set=function(self,value)
            set_current_parameter("text2Font",value)
        end,
        get=function(self)
            return get_current_parameter("text2Font")
        end,
    }
      
    args["text2Color"]={
        order=35,
        type="color",
        name="Color",
        hasAlpha=true,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hastext2)
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
    
    args["decimals"]={
        order=36,
        type="range",
        name="Decimal places",
        min=0,
        max=6,
        isPercent=false,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hastext2)
        end,
        step=1,
        set=function(self,value)
            set_current_parameter("text2Decimals",value)
        end,
        get=function(self)
            return get_current_parameter("text2Decimals")
        end,
    }
         
    args["text2Size"]={
        order=37,
        type="range",
        name="text2 size",
        min=1,
        softMax=50,
        isPercent=false,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hastext2)
        end,
        step=1,
        set=function(self,value)
            set_current_parameter("text2Size",value)
        end,
        get=function(self)
            return get_current_parameter("text2Size")
        end,
    }
    
    args["text2Anchor"]={
        name="Anchor",
        type="select",
        style="dropdown",
        order=38,
        values=anchors,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hastext2)
        end,
        set=function(self,value)
            set_current_parameter("text2Anchor",value)
        end,
        get=function(self)
            return get_current_parameter("text2Anchor")
        end,
    }

    args["text2AnchorTo"]={
        name="Anchor to",
        type="select",
        style="dropdown",
        order=39,
        values=anchors,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hastext2)
        end,
        set=function(self,value)
            set_current_parameter("text2AnchorTo",value)
        end,
        get=function(self)
            return get_current_parameter("text2AnchorTo")
        end,
    }

    args["XOffset"]={
        order=40,
        type="range",
        name="X Offset",
        softMin=-50,
        softMax=50,
        isPercent=false,
        step=1,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hastext2)
        end,
        set=function(self,value)
            set_current_parameter("text2XOS",value)
        end,
        get=function(self)
            return get_current_parameter("text2XOS")
        end,
    }
 
    args["YOffset"]={
        order=41,
        type="range",
        name="Y Offset",
        softMin=-50,
        softMax=50,
        isPercent=false,
        step=1,
        hidden=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hastext2)
        end,
        set=function(self,value)
            set_current_parameter("text2YOS",value)
        end,
        get=function(self)
            return get_current_parameter("text2YOS")
        end,
    }
        
end

if false then 

--Layout
do
    args["layout_header"]={
        order=1,
        name="Layout",
        type="header",
    }
    
    
    args["width"]={
        order=2,
        type="range",
        name="Width",
        softMin=4,
        softMax=100,
        isPercent=false,
        step=2,
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
        softMin=4,
        softMax=100,
        isPercent=false,
        step=2,
        set=function(self,value)
            set_current_parameter("height",value)
        end,
        get=function(self)
            return get_current_parameter("height")
        end,
    }
  
    args["XOffset"]={
        order=4,
        type="range",
        name="X Offset",
        softMin=-50,
        softMax=50,
        isPercent=false,
        step=1,
        set=function(self,value)
            set_current_parameter("xPos",value)
        end,
        get=function(self)
            return get_current_parameter("xPos")
        end,
    }
 
    args["YOffset"]={
        order=5,
        type="range",
        name="Y Offset",
        softMin=-50,
        softMax=50,
        isPercent=false,
        step=1,
        set=function(self,value)
            set_current_parameter("yPos",value)
        end,
        get=function(self)
            return get_current_parameter("yPos")
        end,
    }

    local anchors={CENTER="CENTER",RIGHT="RIGHT",TOPRIGHT="TOPRIGHT",TOP="TOP",TOPLEFT="TOPLEFT",LEFT="LEFT",BOTTOMLEFT="BOTTOMLEFT",BOTTOM="BOTTOM",BOTTOMRIGHT="BOTTOMRIGHT"} 
    args["anchor"]={
        name="Anchor",
        type="select",
        style="dropdown",
        order=6,
        values=anchors,
        set=function(self,value)
            set_current_parameter("anchor",value)
        end,
        get=function(self)
            return get_current_parameter("anchor")
        end,
    }


    args["anchorTo"]={
        name="Anchor to",
        type="select",
        style="dropdown",
        order=7,
        values=anchors,
        set=function(self,value)
            set_current_parameter("anchorTo",value)
        end,
        get=function(self)
            return get_current_parameter("anchorTo")
        end,
    }

    
    

end

--icon
do
    args["icon_header"]={
        order=20,
        name="Icon",
        type="header",
    }
    
    args["hasTexture"]={
        name="Has icon",
        type="toggle",
        order=21,
        set=function(self,key) 
            set_current_parameter("hasTexture",key)
        end,
        
        get=function(self) 
            return get_current_parameter("hasTexture")
        end,
    }  
    
    args["smartIcon"]={
        name="Smart icon",
        type="toggle",
        order=22,
        disabled=function() 
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasTexture) or eF.para.elements[eF.optionsTable.currently_selected_element_key].solidTexture 
        end,
        set=function(self,key) 
            set_current_parameter("smartIcon",key)
        end,       
        get=function(self) 
            return get_current_parameter("smartIcon")
        end,
    }
    
    args["solidTexture"]={
        name="Solid Colour",
        type="toggle",
        order=23,
        disabled=function() 
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasTexture) or eF.para.elements[eF.optionsTable.currently_selected_element_key].smartIcon 
         end,
        set=function(self,key) 
            set_current_parameter("solidTexture",key)
        end,
        
        get=function(self) 
            return get_current_parameter("solidTexture")
        end,
    }
    
    args["texture"]={
        type="input",
        order=24,
        name="Texture",
        disabled=function() 
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasTexture) or eF.para.elements[eF.optionsTable.currently_selected_element_key].solidTexture or eF.para.elements[eF.optionsTable.currently_selected_element_key].smartIcon 
        end,
        set=function(self,value)
                value=string.gsub(value, "%s+", "")
                if not value or value=="" then return end
                set_current_parameter("texture",value)
            end,
        get=function(self) 
                return get_current_parameter("texture")
            end,
    }  

    args["icon_color"]={
        order=25,
        type="color",
        name="Color",
        hasAlpha=true,
        disabled=function()
            return (not eF.para.elements[eF.optionsTable.currently_selected_element_key].hasTexture) or (eF.para.elements[eF.optionsTable.currently_selected_element_key].smartIcon)
        end,
        set=function(self,R,G,B,A)
            local name=eF.optionsTable.currently_selected_element_key or nil
            if not name then return end
            local para=eF.para.elements[name]
            para.textureR=R
            para.textureG=G
            para.textureB=B
            set_current_parameter("textureA",A)
        end,
        get=function(self)
            local name=eF.optionsTable.currently_selected_element_key or nil
            if not name then return end
            local para=eF.para.elements[name]
            R,G,B,A=para.textureR,para.textureG,para.textureB,para.textureA
            return R,G,B,A
        end
    } 

end

--icon
do
    args["CDWheel_header"]={
        order=40,
        name="Cooldown wheel",
        type="header",
    }
    
    args["cdWheel"]={
        name="CD wheel",
        type="toggle",
        order=41,
        set=function(self,key) 
            set_current_parameter("cdWheel",key)
        end,
        
        get=function(self) 
            return get_current_parameter("cdWheel")
        end,
    }  
    
    args["cdReverse"]={
        name="Reverse spin",
        type="toggle",
        order=42,
        disabled=function() return not eF.para.elements[eF.optionsTable.currently_selected_element_key].cdWheel end,
        set=function(self,key) 
            set_current_parameter("cdReverse",key)
        end,
        
        get=function(self) 
            return get_current_parameter("cdReverse")
        end,
    }  
    
end

--icon
do
    args["border_headers"]={
        order=60,
        name="Border",
        type="header",
    }
    
    args["border_NYI"]={
        order=61,
        name="NYI",
        type="description",  
    }
end

end




























