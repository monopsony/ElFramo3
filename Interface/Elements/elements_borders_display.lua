local eF=elFramo
local args=eF.interface_elements_config_tables["border"].display.args
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

--display
do
    args["layout_header"]={
        order=1,
        name="Layout",
        type="header",
    }
    
    
    args["edgeFile"]={
        name="Border",
        type="select",
        style="dropdown",
        dialogControl="LSM30_Border",
        disabled=function()
            return get_current_parameter("flatBorder")
        end,
        order=2,
        values=LSM:HashTable("border"),
        set=function(self,value)
            set_current_parameter("edgeFile",value)
        end,
        get=function(self)
            return get_current_parameter("edgeFile")
        end,
    }
    
    args["flatBorder"]={
        name="Flat Colour",
        type="toggle",
        order=9,
        set=function(self,key) 
            set_current_parameter("flatBorder",key)
        end,
        
        get=function(self) 
            return get_current_parameter("flatBorder")
        end,
    }
    
    args["borderSize"]={
        order=10,
        type="range",
        name="Width",
        min=0,
        softMax=20,
        isPercent=false,
        disabled=function()
            return not get_current_parameter("flatBorder")
        end,
        step=2,
        set=function(self,value)
            set_current_parameter("borderSize",value)
        end,
        get=function(self)
            return get_current_parameter("borderSize")
        end,
    }
    

    args["color"]={
        order=5,
        type="color",
        name="Color",
        hasAlpha=true,
        set=function(self,R,G,B,A)
            local name=eF.optionsTable.currently_selected_element_key or nil
            if not name then return end
            local para=eF.para.elements[name]
            para.borderR=R
            para.borderG=G
            para.borderA=B
            set_current_parameter("borderA",A)
        end,
        get=function(self)
            local name=eF.optionsTable.currently_selected_element_key or nil
            if not name then return end
            local para=eF.para.elements[name]
            R,G,B,A=para.borderR,para.borderG,para.borderB,para.borderA
            return R,G,B,A
        end,
    } 

end











