local eF=elFramo

local next=next

local frameEvents={}
function frameEvents:OnShow()
    --print(self.id,"show")
end

function frameEvents:OnHide()
    --print(self.id,"hide")
end

function frameEvents:OnAttributeChanged(name,value)
  --if not eF.doneLoading then return end
  --print(name,value)
  if name=="unit" then
    if eF.activeFrames[self.id]==self then eF.activeFrames[self.id]=nil end
    self:updateUnit()
    if self.id then eF.activeFrames[self.id]=self end 
  end
end

local frameFunctions={}
function frameFunctions:updateUnit()
  local unit=SecureButton_GetModifiedUnit(self)
  local flag1,flag2=self.current_layout_version~=eF.current_layout_version,eF.current_family_version~=self.current_family_version
  if self.id~=unit or flag1 or flag2 then   
    if not unit then self.id=nil; return end 
    self.id=unit
    
    if UnitIsUnit(unit,"player") then self.playerFrame=true else self.playerFrame=false end
    local class,CLASS=UnitClass(unit)
    local role=UnitGroupRolesAssigned(unit)
    self.class=class
    self.CLASS=CLASS
    self.role=role

 
    if flag1 then 
      self:updateSize()
      self:updateHPBar()
      self:updateFlagFrames()
      self:updateBackground()
      self:updateText()
      self:updateBorders()      
      self:updateName()
      self:updateHPBarColor()  
    else
      self:updateName()
      self:updateHPBarColor()
    end
    
    if flag2 then eF.familyUtils.applyAllElements(self) end

    
    self:loadAllElements()
    self.current_layout_version=eF.current_layout_version
    self.current_family_version=eF.current_family_version
  end
end

function frameFunctions:updateSize()
  local unit=self.id
  local para=self.header.para
  self:SetWidth(para.width)
  self:SetHeight(para.height)
end

function frameFunctions:updateText()
  local unit=self.id
  local para=self.header.para
  if not self.text then self.text=self.hp:CreateFontString(nil,"OVERLAY") end
  local text=self.text
  text:SetFont(para.textFont,para.textSize,para.textExtra)
  text:ClearAllPoints()
  text:SetPoint(para.textPos,self.hp,para.textPos,para.textXOS,para.textYOS)
  text:SetTextColor(para.textR,para.textG,para.textB,para.textA or 1)
end

local GetClassColor=GetClassColor
function frameFunctions:updateName()
  local unit=self.id
  local para=self.header.para
  local text=self.text
  local name=UnitName(unit)
  if not name then name="UNKNOWN" end
  if para.textLim then name=strsub(name,1,para.textLim) end
  self.text:SetText(name)
  if para.textColorByClass and self.CLASS then
    local r,g,b=GetClassColor(self.CLASS)
    local a=para.textA or 1
    text:SetTextColor(r,g,b,a)
  end
end

function frameFunctions:updateHPBar()
  local unit=self.id
  local para=self.header.para
  if not self.hp then self.hp=CreateFrame("StatusBar",self:GetName().."HP",self,"TextStatusBar") end
  local hp=self.hp
  hp:ClearAllPoints()
  if para.healthGrow=="up" then 
    hp:SetPoint("BOTTOMLEFT"); hp:SetPoint("BOTTOMRIGHT");  hp:SetHeight(para.height); hp:SetOrientation("VERTICAL"); hp:SetReverseFill(false)
  elseif para.healthGrow=="right" then
    hp:SetPoint("BOTTOMLEFT"); hp:SetPoint("TOPLEFT"); hp:SetWidth(para.width); hp:SetOrientation("HORIZONTAL"); hp:SetReverseFill(false)  
  elseif para.healthGrow=="down" then
    hp:SetPoint("TOPRIGHT"); hp:SetPoint("TOPLEFT"); hp:SetHeight(para.height); hp:SetOrientation("VERTICAL"); hp:SetReverseFill(true)
  elseif para.healthGrow=="left" then
    hp:SetPoint("TOPRIGHT"); hp:SetPoint("BOTTOMRIGHT"); hp:SetWidth(para.width); hp:SetOrientation("HORIZONTAL"); hp:SetReverseFill(true)
  end
  if para.hpTexture then 
    hp:SetStatusBarTexture(para.hpTexture)
    hp:SetStatusBarColor(para.hpR,para.hpG,para.hpB,para.hpA or 1)
  else
    hp:SetStatusBarTexture(para.hpR,para.hpG,para.hpB,para.hpA or 1)
  end
  hp:SetMinMaxValues(0,1)
  hp:SetFrameLevel(self.baseLevel+1)
  local tt=hp:GetStatusBarTexture()
  if para.hpGrad then
    tt:SetGradientAlpha(para.hpGradOrientation,para.hpGrad1R,para.hpGrad1G,para.hpGrad1B,para.hpGrad1A,para.hpGrad2R,para.hpGrad2G,para.hpGrad2B,para.hpGrad2A)
  end
end

function frameFunctions:updateFlagFrames()
  local unit=self.id
  local para=self.header.para
  local frameName=self:GetName()
  
  self.oorA=para.oorA or 0.45
  
  --dead frame
  if not self.deadFrame then self.deadFrame=CreateFrame("Frame",frameName.."deadFrame",self.hp) end
  self.deadFrame:SetAllPoints(true)
  self.deadFrame:SetFrameLevel(self:GetFrameLevel()+1)
  self.deadFrame.texture=self.deadFrame:CreateTexture(nil,"BACKGROUND")
  self.deadFrame.texture:SetAllPoints(true)
  self.deadFrame.texture:SetColorTexture(0.5,0.5,0.5,0.2)
  self.deadFrame.text=self.deadFrame:CreateFontString(nil,"OVERLAY")
  self.deadFrame.text:SetFont(para.textFont,para.textSize,para.textExtra)
  self.deadFrame.text:SetText("DEAD")
  self.deadFrame.text:SetPoint("CENTER")
  self.deadFrame:Hide()
  
  --offline frame
  if not self.offlineFrame then self.offlineFrame=CreateFrame("Frame",frameName.."offlineFrame",self.hp) end
  self.offlineFrame:SetAllPoints(true)
  self.offlineFrame:SetFrameLevel(self:GetFrameLevel()+1)
  self.offlineFrame.texture=self.offlineFrame:CreateTexture(nil,"BACKGROUND")
  self.offlineFrame.texture:SetAllPoints(true)
  self.offlineFrame.texture:SetColorTexture(0.3,0.3,0.3,0.3)
  self.offlineFrame.text=self.offlineFrame:CreateFontString(nil,"OVERLAY")
  self.offlineFrame.text:SetFont(para.textFont,para.textSize,para.textExtra)
  self.offlineFrame.text:SetText("OFFLINE")
  self.offlineFrame.text:SetPoint("CENTER")
  self.offlineFrame:Hide()
  
  --create MC frame
  if not self.mcFrame then self.mcFrame=CreateFrame("Frame",frameName.."mcFrame",self.hp) end
  self.mcFrame:SetAllPoints(true)
  self.mcFrame:SetFrameLevel(self:GetFrameLevel()+1)
  self.mcFrame.texture=self.mcFrame:CreateTexture(nil,"BACKGROUND")
  self.mcFrame.texture:SetAllPoints(true)
  self.mcFrame.texture:SetColorTexture(0.3,0.3,0.3,0.3)
  self.mcFrame.text=self.mcFrame:CreateFontString(nil,"OVERLAY")
  self.mcFrame.text:SetFont(para.textFont,para.textSize,para.textExtra)
  self.mcFrame.text:SetText("MC")
  self.mcFrame.text:SetPoint("CENTER")
  self.mcFrame:Hide()
  
end

local GetClassColor=GetClassColor
function frameFunctions:updateHPBarColor()
  local unit=self.id
  local para=self.header.para
  local hp=self.hp
  
  if para.byClassColor and self.CLASS then
    local r,g,b=GetClassColor(self.CLASS)
    local alpha=para.hpA or 1
    hp:SetStatusBarTexture(r,g,b,alpha)
  else
    local r,g,b,alpha=para.hpR,para.hpG,para.hpB,para.hpA
    hp:SetStatusBarTexture(r,g,b,alpha)
  end
end

function frameFunctions:updateBackground()
  local unit=self.id
  local para=self.header.para
  if not self.bg then self.bg=self.hp:CreateTexture(nil,"BACKGROUND") end
  local bg=self.bg
  bg:SetAllPoints()
  if para.bgR then bg:SetColorTexture(para.bgR,para.bgG,para.bgB) 
  else bg:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background") end
end

function frameFunctions:updateFlags()
  local id=self.id
  local dead,connected,charmed=UnitIsDeadOrGhost(id),UnitIsConnected(id),UnitIsCharmed(id)
  
  self.offlineFrame:Hide();self.deadFrame:Hide();self.mcFrame:Hide()
  if not connected then self.offlineFrame:Show()
  elseif dead then self.deadFrame:Show()
  elseif charmed then self.mcFrame:Show()
  end
  
end

function frameFunctions:checkOOR()
  if self.playerFrame then return end
  local unit=self.id
  local oor=not UnitInRange(unit)
  --local para=self.header.partyHeader and eF.para.unitsGroup or eF.para.units
  if oor and not self.oor then
    self:SetAlpha(self.oorA) 
    self.oor=true
  elseif not oor and self.oor then
    self:SetAlpha(1)
    self.oor=false 
  end
end

local borderInfo=eF.borderInfo
function frameFunctions:updateBorders()
  local unit=self.id
  local para=self.header.para
  local r,g,b,a,size=para.borderR,para.borderG,para.borderB,para.borderA,para.borderSize
  
  for _,v in next,{"RIGHT","TOP","LEFT","BOTTOM"} do
    local bn,p1,p2,w,f11,f12,f21,f22=eF.borderInfo(v)
    if not self[bn] then self[bn]=self.hp:CreateTexture(nil,"BACKGROUND") end
    local bo=self[bn]
    bo:ClearAllPoints()
    bo:SetColorTexture(r,g,b,a)
    bo:SetPoint(p1,self,p1,f11*(size),f12*(size))
    bo:SetPoint(p2,self,p2,f21*(size),f22*(size))
    if w then bo:SetWidth(size) else bo:SetHeight(size) end    
  end
  
end

function frameFunctions:updateHealth()
  local unit=self.id
  self.hp:SetValue(UnitHealth(unit)/UnitHealthMax(unit))
end

local function metaFunction(t,k)
  t[k]={}
  return t[k]
end
local setmetatable=setmetatable
local wipe=table.wipe
function frameFunctions:resetTasks()
  if self.tasks then wipe(self.tasks) else self.tasks={} end
  setmetatable(self.tasks,{__index=metaFunction})
end

local inList=eF.isInList
function frameFunctions:checkElementLoad(j,k)
  if not self then return end 
  local para,frame
  if k then para=self[j][k].para; frame=self[j][k] else para=self[j].para; frame=self[j] end
  
  if para.loadAlways then
    if not frame.loaded then
      frame.loaded=true;
      if frame.static then frame:enable() end
    end
    return true
  elseif para.loadNever then 
    if frame.loaded then
      frame.loaded=false;
      if frame.static then frame:disable() end
    end
    return false
  end
  
  local b,info=true,eF.info
  local playerRole,playerClass,instanceName,instanceID,encounterID=info.playerRole,info.playerClass,info.instanceName,info.instanceID,info.encounterID
  local unitRole,unitClass=self.role,self.class
  
  if b and (not para.instanceLoadAlways) and not (inList(instanceID,para.loadInstanceList) or inList(instanceName,para.loadInstanceList)) then b=false end
  if b and (not para.encounterLoadAlways) and not (inList(encounterID,para.loadEncounterList)) then b=false end
  if b and (not para.unitRoleLoadAlways) and not inList(unitRole,para.loadUnitRoleList) then b=false end
  if b and (not para.unitClassLoadAlways) and not inList(unitClass,para.loadUnitClassList) then b=false end
  if b and (not para.playerRoleLoadAlways) and not inList(playerRole,para.loadPlayerRoleList) then b=false end
  if b and (not para.playerClassLoadAlways) and not inList(playerClass,para.loadPlayerClassList) then b=false end

  
  if not b and frame.loaded then frame.loaded=false; frame:disable() end
  if b and not frame.loaded then 
    if frame.static then frame:enable() end
    frame.loaded=true
  end
  
  return b

end

local pairs=pairs
function frameFunctions:loadElement(j,k)
  --this one is UNCONDITIONAL: needs to be checked first (cf checkElementLoad)
  local tasks=self.tasks
  local meta,frame,workFuncs,para
  if not k then meta=eF.tasks[j]; frame=self[j]; workFuncs=eF.workFuncs[j]; para=eF.para.families[j]
  else meta=eF.tasks[j][k]; frame=self[j][k]; workFuncs=eF.workFuncs[j][k]; para=eF.para.families[j][k] end
  if not meta then return end 

  --task funcs
  for event,list in pairs(meta) do 
    for i=1,#list do 
      tasks[event][#tasks[event]+1]={list[i],frame} --applies function list[i] on element self[j][k] when event happens
    end      
  end --end of pairs( meta tasks j,k)

  --work funcs
  if workFuncs then
    for funcName,func in pairs(workFuncs) do
      frame[funcName]=func
    end
  end 

  --OnUpdate orphan
  --TBA testing if OnUpdate causing shit
  if k then
    if eF.tasks[j][k].onUpdate and #eF.tasks[j][k].onUpdate>0 and false then
      frame.throttle=math.min((0.1^math.floor(para.textDecimals or 1))*0.15,0.1)
      frame.elapsed=100
      frame:SetScript("OnUpdate",frame.onUpdateFunction)
    else
      frame:SetScript("OnUpdate",nil)
    end
  end
  
  --OnUpdate family
  if not k then 
    if eF.tasks[j].onUpdate and #eF.tasks[j].onUpdate>0 and false then
      local throttle=math.min((0.1^math.floor(para.textDecimals or 1))*0.15,0.1)
      for k=1,para.count do
        frame[k].throttle=throttle
        frame[k].elapsed=100
        frame[k]:SetScript("OnUpdate",frame[k].onUpdateFunction) --gets applied to each orphan instead for efficiency reasons
      end
    else
     for k=1,para.count do
        frame[k]:SetScript("OnUpdate",nil) 
      end
    end
  end
  
  --apply onLoads
  local c=tasks.onLoad
  for j=1,#c do
    local v=c[j]
    v[1](v[2])
  end 
  
end 

function frameFunctions:unloadElement(j,k)
  local frame,para
  if not k then frame=self[j] else frame=self[j][k] end
  frame:disable()
end

function frameFunctions:loadAllElements()
  if not self.header.active then return end
  local parafam=eF.para.families
  self:resetTasks()
  
  for j=1,#parafam do
    if parafam[j].smart then if self:checkElementLoad(j) then self:loadElement(j) else self:unloadElement(j) end
    else
      for k=1,#parafam[j] do 
        if self:checkElementLoad(j,k) then self:loadElement(j,k) else self:unloadElement(j,k) end
      end
    end   
  end

end

local fu=eF.familyUtils
function eF:unit_added(event,name)
  print("unit added",event,name)
  local frame=_G[name]
  
  frame.header=frame:GetParent()
  
  --populate script events and functions
  for k,v in pairs(frameEvents) do frame:SetScript(k,v) end
  for k,v in pairs(frameFunctions) do frame[k]=v end
  
  --table variables
  frame.header=frame:GetParent()
  frame.oor=false --out of range boolean
  frame.baseLevel=frame.header:GetFrameLevel()
 
  if not InCombatLockdown() then
    frame:SetFrameLevel(frame.baseLevel+11)
    frame:updateSize()
  end 
  
  frame:updateHPBar()
  frame:updateFlagFrames()
  frame:updateBackground()
  frame:updateText()
  frame:updateBorders()
  
  frame:resetTasks()
  eF.familyUtils.applyAllElements(frame)
  frame:loadAllElements()
end
eF:RegisterMessage("UNIT_ADDED","unit_added")

