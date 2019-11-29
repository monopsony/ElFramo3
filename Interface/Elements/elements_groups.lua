local eF=elFramo
local elements=elFramo.optionsTable.args.elements
eF.interface_elements_config_tables["group"]={}
local args=eF.interface_elements_config_tables["group"]
--eF.current_elements_version
local LSM=LibStub:GetLibrary("LibSharedMedia-3.0")

eF.interface_element_defaults.group={
        type="group",
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

    args["is_group_element_prot"]={
        type="description",
        order=0,
        name="Type: Group",
        hidden=function(self)
            eF.optionsTable.currently_selected_element_key=self[#self-1]
            return false
        end,
        --thanks to rivers for the suggestion
    }

    local function apply_group_rename_to_elements(old,new)
        local para=elFramo.para.elements
        for k,v in pairs(para) do 
            if v.interfaceGroup==old then v.interfaceGroup=new end
        end
        
    end

    args["rename_prot"]={
        type="input",
        order=1,
        name="Rename to",
        set=function(self,name)
                name=string.gsub(name, "%s+", "")
                if not name or name=="" then return end
                local old=eF.optionsTable.currently_selected_element_key or nil
                if not old then return end
                name=eF.find_valid_name_in_table(name,eF.para.elements)
                apply_group_rename_to_elements(old,name)
                eF:interface_create_new_element("icon",name,old)
                eF:interface_remove_element_by_name(old)
                eF:interface_set_selected_group("elements",name)
            end,
        get=function(self) 
                return "" 
            end,
    }   
  
    args["remove_prot"]={
        type="execute",
        order=2,
        width="half",
        confirm=function() 
            if not eF.optionsTable.currently_selected_element_key then return false end
            return string.format("Are you sure you want to delete the group '%s'. This is not reversible. This will not delete its children.",eF.optionsTable.currently_selected_element_key or "(nothing selected)") 
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
    
end
































