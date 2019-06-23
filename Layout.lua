local eF=elFramo

--TOAD: layout para collapsing function at startup!! (for gaps in indices)


local default_class_order ="WARRIOR,DEATHKNIGHT,ROGUE,MONK,PALADIN,DRUID,SHAMAN,PRIEST,MAGE,WARLOCK,HUNTER,DEMONHUNTER";
local default_group_order ="1,2,3,4,5,6,7,8"
local default_role_order="TANK,HEALER,DAMAGER"
local pairs=pairs
local wipe=table.wipe
local growAnchor={up="BOTTOM",down="TOP",right="LEFT",left="RIGHT"}
local growAnchorTo={up="TOP",down="BOTTOM",right="RIGHT",left="LEFT"}
local growToAnchor={left="RIGHT",right="LEFT",up="BOTTOM",down="TOP"}
local layout_methods={}
eF.registered_layouts={}
eF.layout_indices={}

local function generate_header_anchor(g1,g2)
  local header_anchor 
  if (g1=="up" or g2=="up") then header_anchor="BOTTOM"
  elseif (g1=="down" or g2=="down") then header_anchor="TOP"
  end
  
  if (g1=="right" or g2=="right") then header_anchor=header_anchor.."LEFT"
  elseif (g1=="left" or g2=="left") then header_anchor=header_anchor.."RIGHT"
  end
  return header_anchor
end

local header_default_attributes={
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
    --groupFilter=default_group_order,
    groupBy="GROUP",
    showPlayer=true, --in para now
    --showSolo=true,
    --showRaid=true,
    --showParty=true,
    maxColumns=8,
    strictFiltering=false,
}

local header_default_parameters={
    displayName="UNKNOWN",
    xPos=1000,
    yPos=500,
    by_group=false,
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
    hpGrad1A=0.5,
    hpGrad2R=0.8,
    hpGrad2G=0.8,
    hpGrad2B=0.8, 
    hpGrad2A=0.8, 
    oorA=0.45,
    height=50,
    width=70,
    textFont = "Friz Quadrata TT",
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
    by_group=false,
    textLim=4,
    borderA=0.7,  
}

local function initialConfigFunction(self,name)
  eF:SendMessage("UNIT_ADDED",name)
end

local function ForceFramesCreation(header)
	local startingIndex = header:GetAttribute("startingIndex")
	local maxColumns = header:GetAttribute("maxColumns") or 1
	local unitsPerColumn = header:GetAttribute("unitsPerColumn") or 5
	local maxFrames = maxColumns * unitsPerColumn
	local count= header.FrameCount
	if not count or count<maxFrames then
		header:Show()
		header:SetAttribute("startingIndex", 1-maxFrames )
		header:SetAttribute("startingIndex", startingIndex)
		header.FrameCount= maxFrames
	end
end

function eF:applyLayoutParas()

  for i=1,#eF.registered_layouts do eF:apply_layout_para_index(i) end 

end

function eF:updateActiveLayout()
  --just remove funciton if needed
  if true then return end 
  
  local raid=IsInRaid()
  local groupParas,byGroup,showSolo=eF.para.groupParas,eF.para.layoutByGroup,eF.para.showSolo
  local para,layout
  
  eF.info.raid=raid
  
  if raid then layout=(byGroup and "raidGroup") or "raid"; para=eF.para.units 
  elseif (not raid) and groupParas then layout="party"; para=eF.para.unitsGroup
  elseif (not raid) and (not groupParas) then layout=(byGroup and "raidGroup") or "raid"; para=eF.para.units
  end
  
  local flag1= not (eF.activeLayout==layout)
  eF.activeLayout=layout
  
  if layout=="raidGroup" then
    if flag1 then
        eF.party_header.active=false
        eF.party_header:SetAttribute("showParty",false)
        eF.party_header:SetAttribute("showSolo",false)
        eF.party_header:SetAttribute("showPlayer",false)
        
        eF.raid_header.active=false
        eF.raid_header:SetAttribute("showRaid",false)
        eF.raid_header:SetAttribute("showSolo",false)
        eF.raid_header:SetAttribute("showParty",false)
        eF.raid_header:SetAttribute("showPlayer",false)
        
        eF.raidGroupHeaders[1]:SetAttribute("showParty", (not raid) and (not groupParas)  )
        for _,v in pairs(eF.raidGroupHeaders) do 
          ForceFramesCreation(v)
          v.active=true
          v:SetAttribute("showRaid",true)
          v:SetAttribute("showSolo",showSolo or false)
          v:SetAttribute("showPlayer",true)
        end  
    end
    
    wipe(eF.activeFrames)
    for _,v in pairs(eF.raidGroupHeaders) do
      for i=1,v.FrameCount do
        local fi=v[i]
        if fi.id then eF.activeFrames[fi.id]=fi end
      end
    end
    
  end
  
  if layout=="raid" then
    if flag1 then
        eF.party_header.active=false
        eF.party_header:SetAttribute("showParty",false)
        eF.party_header:SetAttribute("showSolo",false)
        eF.party_header:SetAttribute("showPlayer",false)
        
        eF.raid_header.active=true
        eF.raid_header:SetAttribute("showRaid",true)
        eF.raid_header:SetAttribute("showParty", (not raid) and (not groupParas)  )
        eF.raid_header:SetAttribute("showSolo",showSolo or false)
        eF.raid_header:SetAttribute("showPlayer",true)
        ForceFramesCreation(eF.raid_header)
        
        for _,v in pairs(eF.raidGroupHeaders) do     
          v.active=false
          v:SetAttribute("showRaid",false)
          v:SetAttribute("showParty",false)
          v:SetAttribute("showSolo",false)
          v:SetAttribute("showPlayer",false)
        end  
    end
    
    wipe(eF.activeFrames)
    for i=1,eF.raid_header.FrameCount do
      local fi=eF.raid_header[i]
      if fi.id then eF.activeFrames[fi.id]=fi end
    end
    
  end 
  
  if layout=="party" then
    if flag1 then
        eF.party_header.active=true
        eF.party_header:SetAttribute("showParty",true)
        eF.party_header:SetAttribute("showSolo",showSolo or false)
        eF.party_header:SetAttribute("showPlayer",true)
        ForceFramesCreation(eF.party_header)
        
        eF.raid_header.active=false
        eF.raid_header:SetAttribute("showRaid",false)
        eF.raid_header:SetAttribute("showSolo",false)
        eF.raid_header:SetAttribute("showParty",false)
        eF.raid_header:SetAttribute("showPlayer",false)
        
        for _,v in pairs(eF.raidGroupHeaders) do 
          v.active=false
          v:SetAttribute("showRaid",false)
          v:SetAttribute("showSolo",false)
          v:SetAttribute("showPlayer",false)
          v:SetAttribute("showParty",false)
        end  
    end
    
    wipe(eF.activeFrames)
    for i=1,eF.party_header.FrameCount do
      local fi=eF.party_header[i]
      if fi.id then eF.activeFrames[fi.id]=fi end
    end
    
  end 
  
  for unit,_ in pairs(eF.activeFrames) do
    for i=1,#refreshEvents do eF.unitEventHandler:handleEvent(refreshEvents[i],unit) end
  end
  
end

function eF:setHeaderPositions()

  local p1,p2=eF.para.units,eF.para.unitsGroup
  eF.raid_header:ClearAllPoints()
  local header_anchor=generate_header_anchor(p1.grow1,p1.grow2)
  eF.raid_header:SetPoint(header_anchor,UIParent,"BOTTOMLEFT",p1.xPos,p1.yPos)
  
  eF.raidGroupHeaders[1]:ClearAllPoints()
  eF.raidGroupHeaders[1]:SetPoint(header_anchor,UIParent,"BOTTOMLEFT",p1.xPos,p1.yPos)
  
  eF.party_header:ClearAllPoints()
  local header_anchor=generate_header_anchor(p2.grow1,p2.grow2)
  eF.party_header:SetPoint(header_anchor,UIParent,"BOTTOMLEFT",p2.xPos,p2.yPos)
end

--on their own they just really dont do what I want them to so..
local setVisible_keys={"showRaid","showParty","showSolo"}
function layout_methods:setVisible(bool)
    local bool,keys=bool,setVisible_keys
    if not bool then bool=false end
    if bool==self.visible then return end
    self.visible=bool
    for i=1,#keys do
        self:SetAttribute(keys[i],bool)
    end
    self:updateFilters()
end

function layout_methods:checkVisibility()
    local bool=false
    local showRaid,showParty,showSolo,classes,roles=self.para.showRaid,self.para.showParty,self.para.showSolo,self.para.show_classes,self.para.show_roles
    local inRaid,inGroup=eF.raid,eF.grouped
    
    --checks rad/party/solo
    if inRaid then 
        if showRaid then bool=true end
    elseif inGroup then 
        if showParty then bool=true end
    elseif showSolo then bool=true end
    
    if not bool then self:setVisible(bool); return end
    
    --roles
    if bool then if not (roles.Any or roles[eF.info.playerRole]) then bool=false end end    
    if not bool then self:setVisible(bool); return end
    
    --classes
    if bool then if not (classes.Any or classes[eF.info.playerClass]) then bool=false end end    
    if not bool then self:setVisible(bool); return end
    
    
    self:setVisible(bool)
end

function layout_methods:reload_layout()
    self:setVisible(not self.visible)
    self:setVisible(not self.visible)
end

function layout_methods:set_position()
    local xPos,yPos=self.para.xPos,self.para.yPos
    self:ClearAllPoints()
    self:SetPoint(self.header_anchor or "BOTTOMLEFT",UIParent,"BOTTOMLEFT",xPos,yPos)
end

local strf=string.format
local function generate_nameList(list)
    local s=""
    if not list or #list==0 then return s end 
    
    for i=1,#list-1 do 
        s=strf("%s%s,",s,list[i])
    end
    s=strf("%s%s",s,list[#list])
    print(s)
    return s
end


function layout_methods:updateFilters()
    if not self.visible then return end 
    local player,classes,roles=self.para.filter_player,self.para.filter_classes,self.para.filter_roles
    local namelist={}
    for k,v in pairs(roles) do print(k,v) end 
    if not eF.grouped then 
        --GetRaidRosterInfo doesnt work if youre alone
        local name,class,role=eF.info.playerName,eF.info.playerClass,eF.info.playerRole
        local bool=true
        
        if bool then if not (roles.Any or roles[role]) then bool=false end end 
        if bool then if not (classes.Any or classes[class]) then bool=false end end 
        if bool then if not player then bool=false end end
        
        if bool then namelist[#namelist+1]=name end
        
    else
        for i=1,40 do 
            local name,_,_,_,class,_,_,_,_,_,_,role=GetRaidRosterInfo(i)
            if not name then break end 
            print(GetRaidRosterInfo(i))
            print(role)
            local playerName=eF.info.playerName
            local bool=true
            
            if bool then if not (roles.Any or roles[role]) then bool=false end end 
            if bool then if not (classes.Any or classes[class]) then bool=false end end 
            if bool and name==playerName then if not player then bool=false end end
            
            if bool then namelist[#namelist+1]=name end
            
        end
    end
    
    self:SetAttribute("nameList",generate_nameList(namelist))
    
end

local function generate_header_anchor(g1,g2)
  local header_anchor=""
  if (g1=="up" or g2=="up") then header_anchor="BOTTOM"
  elseif (g1=="down" or g2=="down") then header_anchor="TOP"
  end
  
  if (g1=="right" or g2=="right") then header_anchor=header_anchor.."LEFT"
  elseif (g1=="left" or g2=="left") then header_anchor=header_anchor.."RIGHT"
  end
  return header_anchor
end

function eF:check_registered_layouts_visibility()
    for k,v in pairs(self.registered_layouts) do
        v:checkVisibility()
    end
end

function eF:register_new_layout(key)
    local index=key
    
    if not eF.para.layouts[index] then  
        eF.para.layouts[index]={}
        eF.para.layouts[index]["parameters"]=eF.table_deep_copy(header_default_parameters)
        eF.para.layouts[index]["attributes"]=eF.table_deep_copy(header_default_attributes)
    end
    local att,para=eF.para.layouts[index]["attributes"],eF.para.layouts[index]["parameters"]
    para.displayName=key
    
    if not att or not para then print("NO ATT/PARA in register_new_layout") end --toad proper error management
    local by_group=para.by_group

    if by_group then
        
    else
    
        local header=CreateFrame("Frame","ElFramoHeader"..tostring(index),UIParent,"SecureGroupHeaderTemplate")
        header.index=index
        header:SetSize(36,36) 
        header.visible=false
        header.para=eF.para.layouts[index].parameters
        header.att=eF.para.layouts[index].attributes
        for k,v in pairs(layout_methods) do header[k]=v end
        
        --save the header for easy access
        eF.registered_layouts[index]=header        
        eF.layout_indices[para.displayName]=index
        
        --initial pos. doesn't matter, paras are applyied afterwards
        header:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",200,500) 
        header.initialConfigFunction=initialConfigFunction
        
        --apply layout para
        eF:apply_layout_para_index(index)
        header:Show()  --toad streamlined showing
        
    end
    
    
end

function eF:apply_layout_para_index(index)
    
    
    --helping variables
    local header=eF.registered_layouts[index]
    local para,att=eF.para.layouts[index]["parameters"],eF.para.layouts[index]["attributes"]    
    local anchor,anchor2=growToAnchor[para.grow1],growToAnchor[para.grow2]   
    header.att.point=anchor
    header.att.columnAnchorPoint=anchor2

    --set oder defaults
    if header.att.groupBy=="CLASS" then att.groupingOrder=default_class_order
    elseif header.att.groupBy=="GROUP" then att.groupingOrder=default_group_order
    elseif header.att.groupBy=="ROLE" then att.gorupingOrder=default_role_order end
    
    
    --how does shit grow and shit
    if para.grow1=="up" then att.xOffset=0; att.yOffset=para.spacing or 0
    elseif para.grow1=="down" then att.xOffset=0;att.yOffset=-para.spacing or 0
    elseif para.grow1=="right" then att.xOffset=para.spacing or 0; att.yOffset=0 
    elseif para.grow1=="left" then att.xOffset=-para.spacing or 0; att.yOffset=0 
    end
    
    --apply attributes
    for k,v in pairs(att) do 
      header:SetAttribute(k,v)
    end
    
    --set header position
    header.header_anchor=generate_header_anchor(para.grow1,para.grow2)
    header:set_position()
    
    --reload and shit
    header:reload_layout()
    header:checkVisibility()
end

function eF:register_all_headers_inits()
    for k,v in pairs(eF.para.layouts) do
        eF:register_new_layout(k)
    end
end



--toad: GridLayout line 256











