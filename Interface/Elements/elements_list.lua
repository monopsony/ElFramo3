local eF=elFramo
local elements=elFramo.optionsTable.args.elements
eF.interface_elements_config_tables["list"]={}
local args=eF.interface_elements_config_tables["list"]
--eF.current_elements_version
local LSM=LibStub:GetLibrary("LibSharedMedia-3.0")

eF.interface_element_defaults.list={
                type="list",
                width=15,
                height=15,
                anchor="LEFT",
                anchorTo="LEFT",
                grow="right",
                spacing=10,
                count=3,
                ownOnly=true,
                xPos=0,
                yPos=0,
                hasTexture=true,
                smartIcon=true,
                textureR=1,
                textureG=1,
                textureB=1,
                textureA=1,
                hasBorder=false,
                cdWheel=true,
                cdReverse=true,
                hasText=true,
                textFont="Friz Quadrata TT",
                textSize=20,
                textR=1,
                textG=1,
                textB=1,
                textA=1,
                textAnchor="CENTER",
                textAnchorTo="CENTER",
                textXOS=0,
                textYOS=0,
                textDecimals=0,
                textType="Time left",
                hasText2=false,
                text2Font="Friz Quadrata TT",
                text2Size=20,
                text2R=1,
                text2G=1,
                text2B=1,
                text2A=1,
                text2Anchor="CENTER",
                text2AnchorTo="CENTER",
                text2XOS=0,
                text2YOS=0,
                text2Decimals=0,
                text2Type="Time left",
                trackType="PLAYER HELPFUL",
                adoptFunc="Name Whitelist",
                arg1={},  
                interface_order=nil,
                load={
                    loadAlways=true,
                    [1]={
                           loadAlways=true,
                          },
                    [2]={
                           loadAlways=true,
                          },
                    [3]={
                           loadAlways=true,
                          },
                    [4]={
                           loadAlways=true,
                          },
                    [5]={
                           loadAlways=true,
                          },
                    [6]={
                           loadAlways=true,
                          },                        
                },
            }

do

    args["invisible"]={
        type="description",
        order=0,
        name="invisible",
        hidden=function(self)
            eF.optionsTable.currently_selected_element_key=self[#self-1]
            return true
        end,
        --thanks to rivers for the suggestion
    }

    args["rename"]={
        type="input",
        order=1,
        name="Rename to",
        set=function(self,name)
                name=string.gsub(name, "%s+", "")
                if not name or name=="" then return end
                local old=eF.optionsTable.currently_selected_element_key or nil
                if not old then return end
                name=eF.find_valid_name_in_table(name,eF.para.elements)
                eF:interface_create_new_element("icon",name,old)
                eF:interface_remove_element_by_name(old)
                eF:interface_set_selected_group("elements",name)
            end,
        get=function(self) 
                return "" 
            end,
    }   
  
    args["remove"]={
        type="execute",
        order=2,
        width="half",
        confirm=function() 
            if not eF.optionsTable.currently_selected_element_key then return false end
            return string.format("Are you sure you want to delete the element '%s'. This is not reversible.",eF.optionsTable.currently_selected_element_key or "(nothing selected)") 
            end,
        name="Delete",
        func=function(self)
                if not eF.optionsTable.currently_selected_element_key then
                    --TOAD ERROR MESSAGE
                else               
                    eF:interface_remove_element_by_name(eF.optionsTable.currently_selected_element_key) 
                end                
            end,
    }
    
    
    args["duplicate"]={
        type="execute",
        order=3,
        width="half",
        confirm=false,
        name="Duplicate",
        func=function(self)
                local old=eF.optionsTable.currently_selected_element_key or nil
                if not old then return end
                local name=eF.find_valid_name_in_table(old,eF.para.elements)
                eF:interface_create_new_element("list",name,old)
                eF:interface_set_selected_group("elements",name)
            end,
    }
    
    local AceConfigDialog=LibStub("AceConfigDialog-3.0")
    args["grouping"]={
        name="Group",
        type="select",
        style="dropdown",
        order=3,
        values=function()
            local a={None="None"}
            local para=elFramo.para.elements
            for k,v in pairs(para) do 
                if para[k].type=="group" then a[k]=k end
            end
            return a
        end,
        set=function(self,value)
            local name=eF.optionsTable.currently_selected_element_key or nil
            if not name then return end
            local para=elFramo.para.elements
            para[name].interfaceGroup=(value=="None" and nil) or value
            
            --move back to the element
            if value=="None" then
                AceConfigDialog:SelectGroup("elFramo","elements",name)
            else
                AceConfigDialog:SelectGroup("elFramo","elements",value,name)
            end
        end,
        get=function(self)
            local name=eF.optionsTable.currently_selected_element_key or nil
            if not name then return end
            local para=elFramo.para.elements
            return para[name].interfaceGroup or "None"
        end,
    }
    

    args["tracking"]={
        name="Tracking",
        order=10,
        type="group",
        args={},
    }
    
    args["display"]={
        name="Display",
        order=11,
        type="group",
        args={},
    }
       
    args["texts"]={
        name="Texts",
        order=12,
        type="group",
        args={},
    }
    
    args["load"]={
        name="Load",
        order=13,
        type="group",
        args=eF.interface_elements_load_config_table,
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
            set_current_layout_parameter("width",value)
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
            set_current_layout_parameter("height",value)
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
            set_current_layout_parameter("healthGrow",value)
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
            set_current_layout_parameter("byClassColor",key)
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
            set_current_layout_parameter("hpGrad",key)
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
            set_current_layout_parameter("hpGradOrientation",value)
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
            set_current_layout_parameter("textColorByClass",key)
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
            set_current_layout_parameter("borderSize",value)
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


































