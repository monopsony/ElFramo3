local eF=elFramo
local profiles=elFramo.optionsTable.args.profiles
local args=profiles.args
local tContains=tContains
local wipe=table.wipe
local deepcopy=eF.table_deep_copy
eF.interface_selected_copy_profile=nil
local db=eF.db

--add buttons
do

    args["warning_message"]={
        type="description",
        fontSize="small",
        order=0,
        name="|cFFFF0000Warning:|r Most settings in here will result in an immediate UI reload when altered.\nBut Greg, isn't that really lazy?. Yes. Yes it is.",
    }

    args["help_message"]={
        type="description",
        fontSize="small",
        order=1,
        name=function() return ("Currently selected profile: |cFFFFF569%s|r."):format(elFramo.db:GetCurrentProfile()) end,
    }
     
    
    args["select_profile"]={
        name="Select profile",
        type="select",
        style="dropdown",
        order=2,
        values=function() return elFramo.db:GetProfiles() end,
        set=function(self,value)
            local a=elFramo.db:GetProfiles()
            elFramo.db:SetProfile(a[value])
        end,
        get=function(self)
            local a=elFramo.db:GetProfiles()
            local b=elFramo.get_key_for_value(a,elFramo.db:GetCurrentProfile())
            return b
        end,
    }


    args["spacer_0"]={
        type="description",
        width="full",
        fontSize="small",
        order=4,
        name="",
    }

    args["new_profile"]={
        type="input",
        order=5,
        name="New profile",
        set=function(self,name)
                local name=name or nil
                if not name then return false end
                elFramo.db:SetProfile(name)
            end,
        get=function(self) 
                return "" 
            end,
    }  
   
    args["spacer_1"]={
        type="description",
        width="full",
        fontSize="small",
        order=10,
        name="",
    }
  
    args["remove"]={
        type="select",
        style="dropdown",
        order=11,
        values=function()
                local a=elFramo.db:GetProfiles()
                local b=elFramo.get_key_for_value(a,elFramo.db:GetCurrentProfile())
                a[b]=nil
                return a
            end,
        disabled=function() local a=elFramo.db:GetProfiles(); return #a<2 end,
        confirm=function(self,key) 
                local a=elFramo.db:GetProfiles()
                local name=a[key] or nil
                if not name then return false end
                return string.format("Are you sure you want to delete the profile '%s'. This is not reversible.",name) 
            end,
        name="Delete",
        set=function(self,key)
                local a=elFramo.db:GetProfiles()
                local name=a[key] or nil
                if not name then return false end
                elFramo.db:DeleteProfile(name)
            end,
        get=function(self)
                return nil
            end,
    }
    
 
    
    args["spacer_2"]={
        type="description",
        width="full",
        fontSize="small",
        order=20,
        name="",
    }
    
    
    args["select_profile_copy"]={
        name="Copy from",
        type="select",
        style="dropdown",
        order=21,
        values=function()
                local a=elFramo.db:GetProfiles()
                local b=elFramo.get_key_for_value(a,elFramo.db:GetCurrentProfile())
                a[b]=nil
                return a
            end,
        disabled=function() local a=elFramo.db:GetProfiles(); return #a<2 end,
        set=function(self,key)
            local a=elFramo.db:GetProfiles()
            elFramo.db:CopyProfile(a[key],silent)
        end,
        get=function(self)
            return nil
        end,
    }
     
     
     
end
