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
local orientations={[1]="Right-Down",[2]="Right-Up",[3]="Left-Down",[4]="Left-Up",[5]="Up-Right",[6]="Up-Left",[7]="Down-Right",[8]="Down-Left"}
local orient_to_anchors={[1]={"TOPLEFT","BOTTOMLEFT"},
                         [2]={"BOTTOMLEFT","TOPLEFT"},
                         [3]={"TOPRIGHT","BOTTOMRIGHT"},
                         [4]={"BOTTOMRIGHT","TOPRIGHT"},
                         [5]={"BOTTOMLEFT","BOTTOMRIGHT"},
                         [6]={"BOTTOMRIGHT","BOTTOMLEFT"},
                         [7]={"TOPLEFT","TOPRIGHT"},
                         [8]={"TOPRIGHT","TOPLEFT"},
                        }
                        
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

--on their own they just really dont do what I want them to so..
local setVisible_keys={"showRaid","showParty","showSolo"}
function layout_methods:setVisible(bool)

  --[[ if self.by_group then
        local bool,keys=bool,setVisible_keys
        if not bool then bool=false end
        if bool==self.visible then return end
        self.visible=bool
        
        for i=1,#self do 
            for j=1,#keys do
                self:SetAttribute(keys[j],bool)
            end
        end
        
        self:updateFilters()
        
    else    ]]--shouldnt be needed because SetAttribute is altered (to apply to all groups if by_group==true)
    local bool,keys=bool,setVisible_keys
    if not bool then bool=false end
    if bool==self.visible then return end
    self.visible=bool
    for i=1,#keys do
        self:SetAttribute(keys[i],bool)
    end
    self:updateFilters()
    --end
    
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
    return s
end

local by_group_methods={}
function by_group_methods:SetAttribute(k,v)
    if not self.by_group then return end
    --if k=="maxColumns" or k=="groupFilter" then return end --TBA REMOVE COMMENTED
    for i=1,#self do
        self[i]:SetAttribute(k,v)
    end
end

function by_group_methods:SetPoint(...)
    self[1]:SetPoint(...)
end

function by_group_methods:ClearAllPoints()
    self[1]:ClearAllPoints()
end

function by_group_methods:Show(...)
    for i=1,#self do 
        self[i]:Show()
    end
end

function by_group_methods:Hide(...)
    for i=1,#self do 
        self[i]:Hide()
    end
end

function by_group_methods:by_group_layout()
  if not self.by_group then return end

  local para=self.para
  local g1,g2=para.grow1,para.grow2
  local prev
  self:set_position()
  self:Show()
  local prev=self[1]
  for i=2,#self do 
      local header=self[i]
      header:ClearAllPoints()
      
      local x,y
      if g2=="up" then x=0; y=para.spacing or 0
      elseif g2=="down" then x=0; y=-para.spacing or 0
      elseif g2=="left" then x=-para.spacing or 0; y=0
      elseif g2=="right" then x=para.spacing or 0; y=0 
      end
      local anchor1,anchor2=unpack(orient_to_anchors[para.grow])
      print(anchor1,anchor2)
      header:SetPoint(anchor1,prev,anchor2,x,y)
      prev=header
  end
end

function layout_methods:updateFilters()
    if not self.visible then return end 
    local player,classes,roles=self.para.filter_player,self.para.filter_classes,self.para.filter_roles
    local namelist={}
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
        local header={}
        header.index=index
        header.visible=false
        header.para=eF.para.layouts[index].parameters
        header.att=eF.para.layouts[index].attributes
        header.by_group=true
        for k,v in pairs(layout_methods) do header[k]=v end
        for k,v in pairs(by_group_methods) do header[k]=v end  
        
        for i=1,8 do
            header[i]=CreateFrame("Frame","ElFramoHeader"..tostring(index)..tostring(i),UIParent,"SecureGroupHeaderTemplate")
            header[i]:SetAttribute("groupFilter",tostring(i)) 
            header[i].initialConfigFunction=initialConfigFunction
            header[i].para=header.para
            header[i].att=header.att
        end
        
        eF.registered_layouts[index]=header
        eF.layout_indices[para.displayName]=index
        
        --initial pos. doesn't matter, paras are applied afterwards
        header:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",200,500) 
        header.initialConfigFunction=initialConfigFunction
        
        --apply layout para
        eF:apply_layout_para_index(index)
        header:Show()  --toad streamlined showing
        
    else
    
        local header=CreateFrame("Frame","ElFramoHeader"..tostring(index),UIParent,"SecureGroupHeaderTemplate")
        header.index=index
        header:SetSize(36,36) 
        header.visible=false
        header.para=eF.para.layouts[index].parameters
        header.att=eF.para.layouts[index].attributes
        header.by_group=false
        for k,v in pairs(layout_methods) do header[k]=v end
        
        --save the header for easy access
        eF.registered_layouts[index]=header        
        eF.layout_indices[para.displayName]=index
        
        --initial pos. doesn't matter, paras are applied afterwards
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

    --set order defaults
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
    
    if header.by_group then header:by_group_layout() end
    
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











