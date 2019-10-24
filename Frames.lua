local eF=elFramo

local next=next
local ipairs=ipairs

local frameEvents={}
eF.visible_unit_frames={}
function frameEvents:OnShow()
    eF.visible_unit_frames=eF.list_all_active_unit_frames()

end

function frameEvents:OnHide()
    eF.visible_unit_frames=eF.list_all_active_unit_frames()
end

function frameEvents:OnAttributeChanged(name,value)

  if name=="unit" then
    self:updateUnit()
  end
end

local frameFunctions=eF.frameFunctions or {}
eF.frameFunctions=frameFunctions

local refresh_events={"UNIT_FLAGS","UNIT_HEALTH_FREQUENT","UNIT_AURA","UNIT_POWER_UPDATE","UNIT_HEAL_ABSORB_AMOUNT_CHANGED"}
function frameFunctions:updateUnit(name_changed)
  local unit=SecureButton_GetModifiedUnit(self)
  local unit_changed,flag1,flag2=self.id~=unit,self.current_layout_version~=eF.current_layout_version,eF.current_elements_version~=self.current_elements_version
  local previous_unit=true
  
  if unit_changed then
    previous_unit=self.id
    local playerFrame=(unit and UnitIsUnit(unit,"player")) or false
    if not unit then 
        self:unregister_events()
        self.id=unit or nil
    else
        if self.id then 
            self:unregister_events()
            self.id=unit or nil
            self:register_events()
        else
            self.id=unit or nil
            self:register_events()
        end
    end
    
    if playerFrame and (not self.playerFrame) then
        self:setInRange()
    elseif (not playerFrame) then
        self.elapsed=1
    end
    self.playerFrame=playerFrame
    
    if self.playerFrame and (not playerFrame) then
        self.playerFrame=false
    end
    
    eF.visible_unit_frames=eF.list_all_active_unit_frames()

  end
  
  --paras
  if unit_changed or flag1 or flag2 or name_changed then   
    if not unit then self.id=nil; return end 

    
    local class,CLASS=UnitClass(unit)
    local role=UnitGroupRolesAssigned(unit)
    
    if (class~=self.class) then self.class=class; self:update_load_tables(3) end
    if (role~=self.role) then self.role=role; self:update_load_tables(4) end
    
    self.class=class
    self.CLASS=CLASS
    self.role=role
    self.name=UnitName(self.id)
 
    if flag1 then 
      self:updateSize()
      self:updateHPBar()
      self:updateFlagFrames()
      self:updateBackground()
      self:updateText()
      self:updateBorders()      
      self:updateName()
      self:updateHPBarColor()  
      self:updateOORParas()
    else
      self:updateName()
      self:updateHPBarColor()
    end
    
    if flag2 then self:apply_element_paras() end
    
    if unit_changed then
        if not previous_unit then 
            self:update_load_tables()
        else
            self:update_load_tables(3)
            self:update_load_tables(4)
        end
        self:updateFlags()
        end
    
    self:apply_and_reload_loads()
    self.current_layout_version=eF.current_layout_version
    self.current_elements_version=eF.current_elements_version
    
    for i=1,#refresh_events do 
        self:unit_event(refresh_events[i])
    end
    
  end
end

local unit_events=eF.unitEvents
function frameFunctions:unregister_events()
    for _,v in ipairs(unit_events) do 
        self:UnregisterEvent(v)
    end
end

function frameFunctions:register_events()
    local unit=self.id or nil 
    if not unit then return end
    for _,v in ipairs(unit_events) do 
        self:RegisterUnitEvent(v,unit)
    end
end

function frameFunctions:updateSize()
  local unit=self.id
  local para=self.header.para
  
  if InCombatLockdown() then 
    self.flagged_post_combat_size_update=true
    eF.post_combat.updateFrameSizes=true
    return
  end
  
  if self.flagged_post_combat_size_update then self.flagged_post_combat_size_update=false end
  
  self:SetWidth(para.width)
  self:SetHeight(para.height)
end

local LSM=LibStub:GetLibrary("LibSharedMedia-3.0")
function frameFunctions:updateText()
  local unit=self.id
  local para=self.header.para
  if not self.text then self.text=self.hp:CreateFontString(nil,"OVERLAY") end
  local text=self.text
  local font=(LSM:IsValid("font",para.textFont) and LSM:Fetch("font",para.textFont)) or ""
  text:SetFont(font,para.textSize,para.textExtra)
  text:ClearAllPoints()
  text:SetPoint(para.textPos,self.hp,para.textPos,para.textXOS,para.textYOS)
  text:SetTextColor(para.textR,para.textG,para.textB,para.textA or 1)
end

local GetClassColor=GetClassColor
function frameFunctions:updateName()
  local unit=self.id
  local para=self.header.para
  local text=self.text
  local name=self.name or nil
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
  else
    tt:SetGradientAlpha("VERTICAL",1,1,1,1,1,1,1,1)
  end
end

function frameFunctions:updateOORParas()
    self.throttle=self.header.para.throttle or 0.1
    self.elapsed=1
end

local flag_frames={"dead","offline","mc"}
function frameFunctions:updateFlagFrames()
  local unit=self.id
  local para=self.header.para
  local frameName=self:GetName()
  
  self.oorA=para.oorA or 0.45
  
  for k,v in ipairs(flag_frames) do
    local name=v.."Frame"
    local p=para.flagFrames[v]
    if not self[name] then self[name]=CreateFrame("Frame",frameName..name,self.hp) end
    local f=self[name]
    f:SetAllPoints(true)
    f:SetFrameLevel(self:GetFrameLevel()+1)
    
    if not f.texture then f.texture=f:CreateTexture(nil,"BACKGROUND") end
    f.texture:SetAllPoints(true)
    f.texture:SetColorTexture(p.frameR,p.frameG,p.frameB,p.frameA)
    
    local font=(LSM:IsValid("font",p.textFont) and LSM:Fetch("font",p.textFont)) or ""
    if not f.text then f.text=f:CreateFontString(nil,"OVERLAY") end
    f.text:ClearAllPoints()
    f.text:SetPoint(p.textPos,f,p.textPos,p.textXOS or 0,p.textYOS or 0)
    f.text:SetFont(font,p.textSize,p.textExtra)
    f.text:SetTextColor(p.textR,p.textG,p.textB,p.textA)
    f.text:SetText(p.text)
    
    f:Hide()
    end   
  
  if unit then self:updateFlags() end
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

local UnitIsDeadOrGhost=UnitIsDeadOrGhost
function frameFunctions:unit_event(event)
  local unit=self.id or nil
  if not unit then return end
  
  
  if event=="UNIT_MAXHEALTH" or event=="UNIT_HEALTH_FREQUENT" then
    self:updateHealth()
    if (UnitIsDeadOrGhost(unit)~=self.dead) then self:updateFlags() end
    
  elseif event=="UNIT_AURA" then
  
    --onAura
    local task=self.tasks.onAura
    for i=1,#task,2 do
        task[i](task[i+1],unit)
    end
    
    --postAura
    local task=self.tasks.postAura
    for i=1,#task,2 do
        task[i](task[i+1],unit)
    end
    
  elseif event=="UNIT_THREAT_SITUATION_UPDATE" then
    
    --onThreat
    local task=self.tasks.onThreat
    for i=1,#task,2 do
        task[i](task[i+1],unit)
    end
  
  elseif event=="UNIT_CAST" then
    --onCast
    local task=self.tasks.onCast
    for i=1,#task,2 do 
        task[i](task[i+1],unit)
    end
    
    --postCast
    local task=self.tasks.postCast
    for i=1,#task,2 do
        task[i](task[i+1],unit)
    end
    
  elseif event=="UNIT_CONNECTION" or event=="UNIT_FLAGS" or event=="INCOMING_RESURRECT_CHANGED" or event=="UNIT_PHASE" then
    self:updateFlags()
  elseif event=="UNIT_NAME_UPDATE" then
     self:updateUnit(true)
     
  elseif event=="UNIT_POWER_UPDATE" then
    local task=self.tasks.onPower
    for i=1,#task,2 do
        task[i](task[i+1],unit)
    end
  elseif event=="UNIT_HEAL_ABSORB_AMOUNT_CHANGED" then
    local task=self.tasks.onHealAbsorb
    for i=1,#task,2 do
        task[i](task[i+1],unit)
    end
  end
  
  
end

function frameFunctions:updateFlags()
  local id=self.id
  local dead,connected,charmed=UnitIsDeadOrGhost(id),UnitIsConnected(id),UnitIsCharmed(id)
  
  self.dead=dead
  self.offlineFrame:Hide();self.deadFrame:Hide();self.mcFrame:Hide()
  if not connected then self.offlineFrame:Show()
  elseif dead then self.deadFrame:Show()
  elseif charmed then self.mcFrame:Show()
  end
end

local UnitInRange=UnitInRange
function frameFunctions:checkOOR()
  local unit=self.id
  if not unit then return end
  local oor
  if self.playerFrame then oor=false else oor=not UnitInRange(unit) end  --TBA POTENTIALLY MAKE THIS BETTER

  if oor and not self.oor then
    self:setOOR()
  elseif not oor and self.oor then
    self:setInRange()
  end
end

function frameFunctions:setInRange()
    self:SetAlpha(1)
    self.oor=false
end

function frameFunctions:setOOR()
    self:SetAlpha(self.oorA) 
    self.oor=true
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

local UnitHealth,UnitHealthMax=UnitHealth,UnitHealthMax
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
function frameFunctions:reset_tasks()
  if self.tasks then wipe(self.tasks) else self.tasks={}; setmetatable(self.tasks,{__index=metaFunction}) end
end


--load
--1: player class
--2: player role
--3: unit class
--4: unit role
--5: instance
--6: encounter(try)
local info=eF.info
local element_load_functions={
    [1]=function(frame,para)
        if para.loadAlways then return true end
        return para[info.playerClass]
    end,

    [2]=function(frame,para)
        if para.loadAlways then return true end
        return para[info.playerRole]
    end,
    
    [3]=function(frame,para)
        if para.loadAlways then return true end
        return para[frame.class]
    end,

    [4]=function(frame,para)
        if para.loadAlways then return true end
        return para[frame.role]
    end,

    [5]=function(frame,para)
        if para.loadAlways then return true end
        return para[eF.info.instanceID] or para[eF.info.instanceName]
    end,

    [6]=function(frame,para)
        if para.loadAlways then return true end
        return para[info.encounterID]
    end,
}

local function element_update_load_table(frame,self,index)
    local index=index or nil
    local para=self.para.load
    if not para then self.load_table.loadAlways=false; self.load_table.loadNever=true; return end --this will trigger when an element gets deleted
    if index then 
        self.load_table[index]=element_load_functions[index](frame,para[index])
    else 
        for index=1,6 do 
            self.load_table[index]=element_load_functions[index](frame,para[index])
        end
    end  
    self.load_table.loadAlways=para.loadAlways
    self.load_table.loadNever=para.loadNever
end

function frameFunctions:update_load_tables(index) 
    local index=index or nil 
    local el=self.elements
    for k,v in pairs(el) do 
        element_update_load_table(self,v,index)
    end    
end

function frameFunctions:apply_load_conditions()
    local el,flag=self.elements,false
    for k,v in pairs(el) do 
        local bool=self:check_element_load(k)
        if bool~=v.loaded then
            flag=true
            v.loaded=bool
        end
        if v.static and (bool~=v.filled) then 
            flag=true  --check if static element is not properly loaded
        end
    end  
    return flag
end

function frameFunctions:reload_loaded_elements()
    local el,tasks=self.elements,eF.tasks
    self:reset_tasks()
    for k,v in pairs(el) do 
        if v.loaded then
            if v.static then v:enable() end
            for event,tbl in pairs(tasks[k]) do            
                for i=1,#tbl do 
                    local n=#self.tasks[event]
                    self.tasks[event][n+1]=tbl[i]
                    self.tasks[event][n+2]=v
                end
            end
        elseif v.filled or v.static then 
            v:disable()
        end
    end
end

function frameFunctions:apply_and_reload_loads(force)
    local bool=self:apply_load_conditions() or force
    if bool then self:reload_loaded_elements() end
end

function frameFunctions:check_element_load(k)
    local l=self.elements[k].load_table
    if l.loadAlways then return true
    elseif l.loadNever then return false end
    return  l[1] and l[2] and l[3] and l[4] and l[5] and l[6] 
end

local fu=eF.familyUtils
function eF:unit_added(event,name)
  local frame=_G[name]
  
  frame.header=frame:GetParent()
  
  --populate script events and functions
  for k,v in pairs(frameEvents) do frame:SetScript(k,v) end
  for k,v in pairs(frameFunctions) do frame[k]=v end
  
  --table variables
  frame.header=frame:GetParent()
  frame.oor=false --out of range boolean
  frame.baseLevel=frame.header:GetFrameLevel()
  frame.elements={}
  
  frame:SetScript("OnEvent",frame.unit_event)
 
  if not InCombatLockdown() then
    frame:SetFrameLevel(frame.baseLevel+11)
    frame:updateSize()
  end 
  
  frame:updateHPBar()
  frame:updateFlagFrames()
  frame:updateBackground()
  frame:updateText()
  frame:updateBorders()
  
  
  frame:apply_element_paras()
  frame:reset_tasks() 
  
  frame:update_load_tables()
  frame:apply_and_reload_loads()
    
  eF.visible_unit_frames=eF.list_all_active_unit_frames()
end
eF:RegisterMessage("UNIT_ADDED","unit_added")

local pairs=pairs
function eF:fully_reload_element(key)
    local frame=self
    eF:update_element_meta(key)
    for _,frame in pairs(eF.list_all_active_unit_frames(name)) do 
        frame:apply_element_paras(key)
        frame:reset_tasks() 
        frame:update_load_tables()
        frame:apply_and_reload_loads(true)
    
        for i=1,#refresh_events do 
            frame:unit_event(refresh_events[i])
        end        
    end
end

