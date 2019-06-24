--default paras 
if false then
eF.para={throttle=0.1, --currently not actually applying, it's set to 0.1
         familyButtonsIndexList={},
         groupParas=true,
         version=1,
         units={
                 height=50,
                 width=70,
                 bg=true,
                 bgR=nil,
                 bgG=nil,
                 bgB=nil,
                 --spacing=10,
                 --grow1="down",
                 --grow2="right",
                 healthGrow="up",
                 textLim=4,
                 textFont="Fonts\\FRIZQT__.ttf",
                 textExtra="OUTLINE",
                 textPos="CENTER",
                 textSize=13,
                 textA=0.7,
                 textColorByClass=true,
                 textR=1,
                 textG=1,
                 textB=1,
                 hpTexture=nil, --would put path in here, e.g. "Interface\\TargetingFrame\\UI-StatusBar"
                 --hpTexture="Interface\\TargetingFrame\\UI-StatusBar", if no texture given, uses SetColorTexture instead
                 hpR=0.2,
                 hpG=0.4,
                 hpB=0.6,
                 hpA=1,
                 nA=1, --normal alpha
                 checkOOR=true, --true if dim when oor
                 oorA=0.45, --alpha to be set to if out of range
                 hpGrad=true,
                 hpGradOrientation="VERTICAL",
                 hpGrad1R=0.5,
                 hpGrad1G=0.5,
                 hpGrad1B=0.5,
                 hpGrad1A=1,
                 hpGrad2R=0.8,
                 hpGrad2G=0.8,
                 hpGrad2B=0.8,
                 hpGrad2A=5,
                 borderSize=2,
                 borderR=0,
                 borderG=0,
                 borderB=0,
                 borderA=0.7,
                 spacing=5,
                 grow1="down",
                 grow2="right",   
                 byClassColor=true,
                 byGroup=false,
                 maxInLine=5,
                 showSolo=true,
                 }, 
         unitsGroup={
                 height=50,
                 width=70,
                 bg=true,
                 bgR=nil,
                 bgG=nil,
                 bgB=nil,
                 --spacing=10,
                 --grow1="down",
                 --grow2="right",
                 healthGrow="up",
                 textLim=4,
                 textFont="Fonts\\FRIZQT__.ttf",
                 textExtra="OUTLINE",
                 textPos="CENTER",
                 textSize=13,
                 textA=0.7,
                 textColorByClass=true,
                 textR=1,
                 textG=1,
                 textB=1,
                 hpTexture=nil, --would put path in here, e.g. "Interface\\TargetingFrame\\UI-StatusBar"
                 --hpTexture="Interface\\TargetingFrame\\UI-StatusBar", if no texture given, uses SetColorTexture instead
                 hpR=0.2,
                 hpG=0.4,
                 hpB=0.6,
                 hpA=1,
                 nA=1, --normal alpha
                 checkOOR=true, --true if dim when oor
                 oorA=0.45, --alpha to be set to if out of range
                 hpGrad=true,
                 hpGradOrientation="VERTICAL",
                 hpGrad1R=0.5,
                 hpGrad1G=0.5,
                 hpGrad1B=0.5,
                 hpGrad1A=1,
                 hpGrad2R=0.8,
                 hpGrad2G=0.8,
                 hpGrad2B=0.8,
                 hpGrad2A=1,
                 borderSize=1,
                 borderR=0.35,
                 borderG=0.35,
                 borderB=0.35,
                 borderA=1,
                 spacing=5,
                 grow1="down",
                 grow2="right",   
                 byClassColor=true,
                 byGroup=true,
                 maxInLine=5,
                 showSolo=true,
                 },                    
         colors={
                 debuff={Disease={0.6,0.4,0},Poison={0,0.6,0},Curse={0.6,0,0.1},Magic={0.2,0.6,1}},
                }, --end of colors
         families={[1]={displayName="void",
                       smart=false,
                       count=0,  
                       [1]={
                          ["extra1checkOn"] = "None",
                          ["trackType"] = "Buffs",
                          ["xPos"] = 0,
                          ["ownOnly"] = true,
                          ["unitRoleLoadAlways"] = true,
                          ["trackBy"] = "Name",
                          ["anchor"] = "BOTTOMRIGHT",
                          ["textType"] = "Time left",
                          ["instanceLoadAlways"] = true,
                          ["textAnchor"] = "CENTER",
                          ["encounterLoadAlways"] = true,
                          ["smartIcon"] = true,
                          ["height"] = 20,
                          ["textureR"] = 1,
                          ["textureB"] = 1,
                          ["playerClassLoadAlways"] = false,
                          ["textExtra"] = "OUTLINE",
                          ["anchorTo"] = "BOTTOMRIGHT",
                          ["textR"] = 0.811764705882353,
                          ["cdReverse"] = true,
                          ["playerRoleLoadAlways"] = true,
                          ["unitClassLoadAlways"] = true,
                          ["hasTexture"] = true,
                          ["textA"] = 1,
                          ["cdWheel"] = true,
                          ["textureG"] = 1,
                          ["textXOS"] = 0,
                          ["textG"] = 0.850980392156863,
                          ["textDecimals"] = 0,
                          ["loadPlayerClassList"] = {
                            "Druid", -- [1]
                          },
                          ["textFont"] = "Fonts\\FRIZQT__.ttf",
                          ["type"] = "icon",
                          ["extra1string"] = "",
                          ["loadAlways"] = false,
                          ["textAnchorTo"] = "CENTER",
                          ["displayName"] = "New Icon",
                          ["width"] = 20,
                          ["hasText"] = true,
                          ["textB"] = 0.337254901960784,
                          ["hasBorder"] = false,
                          ["arg1"] = "Lifebloom",
                          ["textSize"] = 14,
                          ["yPos"] = 0,
                          ["textYOS"] = 0,
                          ["displayLevel"]=1,
                          ["loadPlayerRoleList"] = {
                            "HEALER", -- [1]
                          },
                        }
                       }, --end of ...families[1]                        
                  }--end of all  
         }  --end of default para
end 
   
local defaults={
    profile={
        layouts={
            ["Default"]={
                attributes={
                    templateType="Button",
                    template="SecureUnitButtonTemplate",
                    point="TOP",
                    xOffset=10,
                    yOffset=-10,
                    columnSpacing=10,
                    columnAnchorPoint="LEFT",
                    initialConfigFunction=[[
                    --RegisterUnitWatch(self);
                    self:SetAttribute("*type1","target");
                    self:SetHeight(34)
                    self:SetWidth(34)
                    local header=self:GetParent();
                    self:SetFrameLevel(header:GetFrameLevel()+11)
                    header:CallMethod("initialConfigFunction",self:GetName())
                    ]],
                    allowVehicleTarget=false,
                    toggleForVehicle=false,
                    unitsPerColumn=5,
                    groupingOrder="1,2,3,4,5,6,7,8",
                    groupFilter=default_group_order,
                    groupBy="GROUP", --TBA PUT BACL
                    groupBy=nil,
                    showPlayer=true, --in para now
                    --showSolo=true,
                    --showRaid=true,
                    --showParty=true,
                    maxColumns=8,
                    strictFiltering=false,
                },
                parameters={
                    by_group=false,
                    displayName="Default",
                    xPos=1000,
                    yPos=500,
                    grow1="down",
                    grow2="right",
                    grow=7,
                    spacing=10,
                    hpR=0.2,
                    hpG=0.4,
                    hpB=0.6,
                    showPlayer=true,
                    showSolo=true,
                    showRaid=true,
                    showParty=true,
                    show_classes={Any=true},
                    show_roles={Any=true},
                    filter_classes={Any=true},
                    filter_roles={Any=true},
                    filter_player=true,
                    hpOrientation="VERTICAL",
                    hpGrad=true,
                    hpGradOrientation="VERTICAL",
                    hpGrad1R=0.5,
                    hpGrad1G=0.5,
                    hpGrad1B=0.5,  
                    hpGrad2R=0.8,
                    hpGrad2G=0.8,
                    hpGrad2B=0.8, 
                    oorA=0.45,
                    height=50,
                    width=70,
                    textFont ="Friz Quadrata TT",
                    textExtra="OUTLINE",
                    textR=1,
                    textPos="CENTER",
                    textA=1,
                    borderR=0,
                    borderG=0,
                    borderB=0,
                    textSize=13,
                    borderSize=2,
                    healthGrow="up", 
                    textColorByClass=true,
                    bg=true,
                    textLim=4,
                    borderA=0.7,   
                },                   
            },  --end of layouts[1]
        },  --end of layouts
        families={
        },  --end of families
    },  --end of profile
}--end of defaults

elFramo=LibStub("AceAddon-3.0"):NewAddon("elFramo")
elFramoGlobal3=elFramo

local eF=elFramo    
eF.activeFrames={}
eF.currentUnitsParaVersion=0
eF.currentFamilyParaVersion=0
   
eF.unitEvents={
"UNIT_HEALTH_FREQUENT",
"UNIT_MAXHEALTH",
"UNIT_FLAGS",
"UNIT_AURA",
"UNIT_POWER_UPDATE",
"UNIT_CONNECTION",
"UNIT_FLAGS",
"UNIT_HEAL_ABSORB_AMOUNT_CHANGED",
"UNIT_NAME_UPDATE",
}

eF.inRaid=false 
eF.grouped=false


local lib_embeds={"AceConsole-3.0","AceComm-3.0","AceEvent-3.0","AceSerializer-3.0"}
for i,v in ipairs(lib_embeds) do LibStub(v):Embed(eF) end

local current_version=2
local function update_WTF()
    --TOAD WTF HANDLING
    if true then return end 
    local para=elFramoDB or nil
    
    if not para then 
      para=_eF_savVar or nil
      if not para then elFramoDB=eF.para --sets default if it doesnt exist
      else --WTF from ElFramo1
        --grow1/2 to grow conversion
        elFramoDB=deepcopy(para.profiles.default)
        local ug,grow=elFramoDB.unitsGroup,""
        if (not ug.grow1) or not ug.grow2 then grow="down-right" --defaulting
        else grow=ug.grow1.."-"..ug.grow2 end
        ug.grow=grow
        
        local u,grow=elFramoDB.units,""
        if (not u.grow1) or not u.grow2 then grow="down-right" --defaulting
        else grow=u.grow1.."-"..u.grow2 end
        ug.grow=grow
        
        --by group out of ug and showSolo
        elFramoDB.layoutByGroup=u.byGroup or false
        elFramoDB.showSolo=true
        
        --dont ask
        elFramoDB.unitsGroup.xPos=elFramoDB.units.xPos+25
        elFramoDB.unitsGroup.yPos=elFramoDB.units.yPos+25
        elFramoDB.units.xPos=elFramoDB.units.xPos+25
        elFramoDB.units.yPos=elFramoDB.units.yPos+25
        
        --setting to new version
        elFramoDB.version=2
      end
      
    else --elFramoDB.version checking for the future
    
    end
  eF.para=elFramoDB
end

local doIn=C_Timer.NewTimer
function elFramo:OnInitialize()
    self.db=LibStub("AceDB-3.0"):New("elFramoDB",defaults)
    
    --PROFILE CHECKING HERE
    
    eF.para=self.db.profile

    eF.doneLoading=true
    eF.current_layout_version=1
    eF.current_family_version=1

    --LOAD DB
    update_WTF()

    --load player class
    eF.info.playerClass=UnitClass("player")
    eF.info.playerName=UnitName("player")

    --load player role  --doesnt work at the very start for some reason?
    --local spec=GetSpecialization()
    --local role=select(5,GetSpecializationInfo(spec))
    --eF.info.playerRole=role
    local eF=eF
    doIn(1,function() eF.layoutEventHandler:handleEvent("GROUP_ROSTER_UPDATE") end)
    

    --load instance
    local instanceName,_,_,_,_,_,_,instanceID=GetInstanceInfo()
    eF.info.instanceName=instanceName
    eF.info.instanceID=instanceID
    
    --load group stuff
    --eF.layoutEventHandler:handleEvent("GROUP_ROSTER_UPDATE") (doing it above anyways)
    
    
    --load layouts
    --toad: REMOVE COMMENTS, FIX
    eF:register_all_headers_inits()
    eF:applyLayoutParas()
    --eF:updateActiveLayout()
    --eF:setHeaderPositions()
    
    --ALL INITS
    if eF.para.families and (#eF.para.families>0) then 
        eF.familyUtils.updateAllMetas()
        for k,v in pairs(eF.activeFrames) do
            eF.familyUtils.applyAllElements(v)
            v:loadAllElements()
        end  
    end
    --eF.intSetInitValues() --toad init values interface

    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    eF.loadingFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    
   
end

--self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
--function MyAddon:RefreshConfig()
  -- do stuff
--end

function elFramo:OnEnable()
    
end