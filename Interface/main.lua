local eF=elFramo
local gui = LibStub("AceGUI-3.0")
local AceConfig=LibStub("AceConfig-3.0")
local bool=true
elFramo.optionsTable = {
  type = "group",
  childGroups = "tab",
  args = {
--    enable = {
--      name = "Enable",
--      desc = "Enables / disables the addon",
--      type = "toggle",
--      set = function(info,val) print("setting "); bool=val end,
--      get = function(info) return bool end
--    }


    layouts={
      name = "Layouts",
      type = "group",
      args={

      },      
    },
    profiles={
      name = "Profiles",
      type = "group",
      args={

      },      
    },
    elements={
      name = "Elements",
      type = "group",
      args={

      },      
    },
  }
}

AceConfig:RegisterOptionsTable("elFramo",elFramo.optionsTable)
local AceConfigDialog=LibStub("AceConfigDialog-3.0")
AceConfigDialog:SetDefaultSize("elFramo", 1000, 650)
local initialised=false
function eF:open_options_frame()
    --if not initialised then eF.interface_generate_element_groups(); initialised=true end
    AceConfigDialog:Open("elFramo")
end
eF:RegisterChatCommand("ef3",eF.open_options_frame)

function eF:close_options_frame()
    --if not initialised then eF.interface_generate_element_groups(); initialised=true end
    AceConfigDialog:Close("elFramo")
end

function eF:interface_set_selected_group(...)
    --if (not tbl) or not (type(tbl)=="table") then return end
    AceConfigDialog:SelectGroup("elFramo",...)
end

function eF:reload_elements_options_frame()
    eF:interface_set_selected_group()
end

function eF:interface_select_element_by_key(key)
    if not key and (type(key)=="string") then return end
    local para=elFramo.para.elements[key]
    if para.interfaceGroup then 
        self:interface_set_selected_group("elements",para.interfaceGroup,key)
    else
        self:interface_set_selected_group("elements",key)
    end
end

