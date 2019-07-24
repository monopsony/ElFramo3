local eF=elFramo
local elements=elFramo.optionsTable.args.elements
eF.interface_elements_config_tables["bar"]={}
local args=eF.interface_elements_config_tables["bar"]
--eF.current_elements_version
local LSM=LibStub:GetLibrary("LibSharedMedia-3.0")

eF.interface_element_defaults.border={
    type="bar",
    anchorTo="BOTTOMLEFT",
    xPos=5,
    yPos=0,
    lMax=50,
    lFix=10,
    textureR=0,
    textureG=0,
    textureB=1,
    texutreA=1,
    trackType="Power",
    load={
        loadAlways=true,
        loadNever=false,
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
            eF.optionsTable.currently_selected_element_key=self[2]
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
       
    args["load"]={
        name="Load",
        order=13,
        type="group",
        args=eF.interface_elements_load_config_table,
    }

end

