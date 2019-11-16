
local test_profile={
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
                    groupBy="GROUP", 
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
                    textG=1,
                    textB=1,
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
                    hasNamelist=false,
                    flagFrames={
                        dead={
                            textFont ="Friz Quadrata TT",
                            textSize=13,
                            textR=1,
                            textPos="CENTER",
                            textR=1,
                            textG=1,
                            textB=1,       
                            textExtra="OUTLINE",
                            frameR=.5,
                            frameG=.5,
                            frameB=.5,
                            frameA=.2,
                            text="DEAD",
                        },
                        offline={
                            textFont ="Friz Quadrata TT",
                            textSize=13,
                            textR=1,
                            textPos="CENTER",
                            textR=1,
                            textG=1,
                            textB=1,       
                            textExtra="OUTLINE",
                            frameR=.5,
                            frameG=.5,
                            frameB=.5,
                            frameA=.2,
                            text="Offline",
                        },
                        mc={
                            textFont ="Friz Quadrata TT",
                            textSize=13,
                            textR=1,
                            textPos="CENTER",
                            textR=1,
                            textG=1,
                            textB=1,       
                            textExtra="OUTLINE",
                            frameR=.5,
                            frameG=.5,
                            frameB=.5,
                            frameA=.2,
                            text="MC",
                        },
                    },
                },                   
            },  --end of layouts[1]
        },  --end of layouts
        elements={
            ["rejuv"]={
                type="icon",
                width=15,
                height=15,
                anchor="TOPRIGHT",
                anchorTo="TOPRIGHT",
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
                trackType="PLAYER HELPFUL",
                adoptFunc="Name",
                arg1="Rejuvenation",  
                interface_order=nil,
                load={
                    loadAlways=false,
                    loadNever=false,
                    [1]={
                           loadAlways=true,
                          },
                    [2]={
                           loadAlways=true,
                          },
                    [3]={
                           loadAlways=true,
                            Druid=true,
                          },
                    [4]={
                           loadAlways=true,
                            Druid=true,
                          },
                    [5]={
                           loadAlways=true,
                          },
                    [6]={
                           loadAlways=true,
                          },
                },
            },
            ["germ"]={
                type="icon",
                width=15,
                height=15,
                anchor="RIGHT",
                anchorTo="RIGHT",
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
                trackType="PLAYER HELPFUL",
                adoptFunc="Name",
                arg1="Rejuvenation (Germination)",  
                interface_order=nil,
                load={
                    loadAlways=false,
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
            },
            ["wild"]={
                type="icon",
                width=15,
                height=15,
                anchor="BOTTOM",
                anchorTo="BOTTOM",
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
                trackType="PLAYER HELPFUL",
                adoptFunc="Name",
                arg1="Wild Growth",   
                interface_order=nil,
                load={
                    loadAlways=false,
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
            },
            ["lifebloom"]={
                interfaceGroup="grouptest",
                type="icon",
                width=15,
                height=15,
                anchor="BOTTOMRIGHT",
                anchorTo="BOTTOMRIGHT",
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
                trackType="PLAYER HELPFUL",
                adoptFunc="Name",
                arg1="Lifebloom",   
                interface_order=nil,
                load={
                    loadAlways=false,
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
            },
            ["bufflist"]={
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
                trackType="PLAYER HELPFUL",
                adoptFunc="Name Whitelist",
                arg1={["Lifebloom"]=true,["Rejuvenation"]=true,["Wild Growth"]=true,["Rejuvenation (Germination)"]=true},   
                interface_order=nil,
                load={
                    [1]={
                           loadAlways=false,
                           Druid=true,
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
            },
            ["bordertest"]={
                type="border",
                borderSize=2,
                borderR=1,
                borderG=1,
                borderB=1,
                borderA=1,
                trackType="Static",
                flatBorder=true, 
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
            },
            ["bartest"]={
                type="bar",
                interfaceGroup="grouptest",
                anchorTo="BOTTOMLEFT",
                xPos=5,
                yPos=0,
                lMax=50,
                lFix=10,
                textureFile=nil,
                flatTexture=true,
                textureR=0,
                textureG=0,
                textureB=1,
                texutreA=1,
                trackType="Power",
                grow="up",
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
            },
            ["grouptest"]={
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
            },
     },  --end of families
    },  --end of profile
}--end of defaults

local defaults={
    profile={
        layouts={},
        elements={},
    },  --end of profile
}--end of defaults
elFramo=LibStub("AceAddon-3.0"):NewAddon("elFramo")

local eF=elFramo    
eF.activeFrames={}
eF.currentUnitsParaVersion=0
eF.currentFamilyParaVersion=0
   
eF.unitEvents={
--"INCOMING_RESURRECT_CHANGED",
"UNIT_HEALTH_FREQUENT",
"UNIT_MAXHEALTH",
"UNIT_FLAGS",
"UNIT_AURA",
"UNIT_POWER_UPDATE",
"UNIT_CONNECTION",
"UNIT_HEAL_ABSORB_AMOUNT_CHANGED",
"INCOMING_RESURRECT_CHANGED",
"UNIT_PHASE",
"UNIT_NAME_UPDATE",
"UNIT_THREAT_SITUATION_UPDATE",
--"UNIT_HEALTH",
}

eF.inRaid=false 
eF.grouped=false


local lib_embeds={"AceConsole-3.0","AceComm-3.0","AceEvent-3.0","AceSerializer-3.0"}
for i,v in ipairs(lib_embeds) do LibStub(v):Embed(eF) end

local current_version=2
local function update_WTF()
    --TOAD WTF HANDLING
    --this function will be used when changes are made that a change in WTF files
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

local wipe=table.wipe
local doIn=C_Timer.NewTimer
function elFramo:OnInitialize()

    self.db=LibStub("AceDB-3.0"):New("elFramoDB",defaults,true)  --true sets the default profile to a profile called "Default"
                                                                 --see https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0
    self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
    
    --PROFILE CHECKING HERE
    
    eF.para=self.db.profile

    eF.doneLoading=true
    eF.current_layout_version=1
    eF.current_family_version=1

    --LOAD DB
    update_WTF()

    --load player info
    eF.info.playerClass=UnitClass("player")
    eF.info.playerName=UnitName("player")
    eF.info.playerRealm=GetRealmName()

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
    --eF.layoutEventHandler:handleEvent("GROUP_ROSTER_UPDATE") --(doing it above anyways)
    
    --element metas
    eF:update_element_meta()
    
    
    --load layouts and frames
    eF:register_all_headers_inits()
    eF:applyLayoutParas()

    eF.elFramo_initialised=true
    eF.loadingFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
   
end

function elFramo:RefreshConfig()
    ReloadUI()
end

--self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
--function MyAddon:RefreshConfig()
  -- do stuff
--end

function elFramo:OnEnable()
    
end
