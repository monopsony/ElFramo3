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
--    },
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
function eF:open_options_frame()
    AceConfigDialog:Open("elFramo")
end
eF:RegisterChatCommand("ef",eF.open_options_frame)

