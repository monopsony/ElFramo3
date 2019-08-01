local eF=elFramo

eF.taskFuncs=eF.taskFuncs or {}
local taskFuncs=eF.taskFuncs
local iconApplySmartIcon,iconUpdateCDWheel,iconUpdateTextTypeT,iconUpdateText2TypeT,iconUpdateTextTypeS,iconUpdateText2TypeS
local updateBorderColorDebuffType

----------------------------------ICONS--------------------------------------------------

function taskFuncs:frameDisable()
  self:Hide()
  self.filled=false
end

function taskFuncs:frameEnable()
  self:Show()
  self.filled=true
end

--count,debuffType,duration,expirationTime,unitCaster,canSteal,_,spellID
local function is_aura_new(self,count,expirationTime,spellID)
    return not ((count==self.count) and (expirationTime==self.expirationTime) and (spellID==self.spellID))
end

function taskFuncs:applyAuraAdopt(unit)
    local filter=self.para.trackType or nil
    for i=1,40 do 
        local name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,_,spellID,_,isBoss=UnitAura(unit,i,filter)
        if not name then break end
        local bool=self:auraAdopt(name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellID,isBoss) 
            
        if bool then
            if is_aura_new(self,count,expirationTime,spellID) then
                self.new_aura=true
                self.name=name
                self.icon=icon
                self.count=count
                self.debuffType=debuffType
                self.duration=duration
                self.expirationTime=expirationTime
                self.unitCaster=unitCaster
                self.canSteal=canSteal
                self.spellID=spellID
                self.isBoss=isBoss
                self.isPermanent=self.expirationTime==0
            else         
                self.new_aura=false
            end
            
            if not self.filled then self:enable() end    
            return
        end--end of if bool
    end
    
    if self.filled then self:disable() end
end

function taskFuncs:applyListAuraAdopt(unit)
    self.active=0
    local filter=self.para.trackType or nil
    local active=0
    for i=1,40 do 
        local name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,_,spellID,_,isBoss=UnitAura(unit,i,filter)
        if not name then break end
        local bool=self:auraAdopt(name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellID,isBoss) 

        if bool then
            active=active+1
            local frame=self[active]
            if is_aura_new(frame,count,expirationTime,spellID) then
                frame.new_aura=true
                frame.name=name
                frame.icon=icon
                frame.count=count
                frame.debuffType=debuffType
                frame.duration=duration
                frame.expirationTime=expirationTime
                frame.unitCaster=unitCaster
                frame.canSteal=canSteal
                frame.spellID=spellID
                frame.isBoss=isBoss
                frame.isPermanent=frame.expirationTime==0
            else         
                frame.new_aura=false
            end
                
            if active==self.count then break end
        end--end of if bool
    end
    
    if active==0 and self.filled then self:disable() end
    if active>0 then
        if not self.filled then self:enable() end
        for i=1,active do 
            if not self[i].filled then self[i]:enable() end
        end
        for i=active+1,self.count do 
            if self[i].filled then self[i]:disable() end
        end
    end
    self.active=active
end

function taskFuncs:iconAdoptAuraByName(name)
   return name==self.para.arg1
end

function taskFuncs:iconAdoptAuraByNameWhitelist(name,_,_,_,dur)
   if self.para.ignorePermanents and dur==0 then return false end
   if self.para.iDA and dur>self.para.iDA then return false end
   return self.para.arg1[name] 
end

function taskFuncs:iconAdoptAuraByNameBlacklist(name,_,_,_,dur)
   if self.para.ignorePermanents and dur==0 then return false end
   if self.para.iDA and dur>self.para.iDA then return false end
   return not self.para.arg1[name]
end

function taskFuncs:iconAdoptAuraBySpellID(_,_,_,_,_,_,_,_,spellID)
  return spellID==self.para.arg1 
end

function taskFuncs:iconApplySmartIcon()
  if self.isListElement then
    for i=1,self.active do iconApplySmartIcon(self[i]) end
    return
  end
  if not (self.filled and self.new_aura) then return end
  self.texture:SetTexture(self.icon)
end
iconApplySmartIcon=taskFuncs.iconApplySmartIcon

function taskFuncs:iconUpdateCDWheel()
  if self.isListElement then
    for i=1,self.active do iconUpdateCDWheel(self[i]) end
    return
  end
  if not (self.filled and self.new_aura) then return end
  local dur=self.duration
  self.cdFrame:SetCooldown(self.expirationTime-dur,dur)
end
iconUpdateCDWheel=taskFuncs.iconUpdateCDWheel

function taskFuncs:iconUpdateTextTypeT()
  if self.isListElement then
    for i=1,self.active do iconUpdateTextTypeT(self[i]) end
    return
  end
  local t=GetTime()
  local s=(self.isPermanent and "") or self.textDecimalFunc(self.expirationTime-t)
  self.text:SetText(s)
end
iconUpdateTextTypeT=taskFuncs.iconUpdateTextTypeT

function taskFuncs:iconUpdateText2TypeT()
  if self.isListElement then
    for i=1,self.active do iconUpdateText2TypeT(self[i]) end
    return
  end
  local t=GetTime()
  local s=(self.isPermanent and "") or self.text2DecimalFunc(self.expirationTime-t)
  self.text2:SetText(s)
end
iconUpdateText2TypeT=taskFuncs.iconUpdateText2TypeT

function taskFuncs:iconUpdateTextTypeS()
  if self.isListElement then
    for i=1,self.active do iconUpdateTextTypeS(self[i]) end
    return
  end
  local s=self.count or ""
  if (s==0) or (s==1) then s="" end  
  self.text:SetText(s)
end
iconUpdateTextTypeS=taskFuncs.iconUpdateTextTypeS

function taskFuncs:iconUpdateText2TypeS()
  if self.isListElement then
    for i=1,self.active do iconUpdateText2TypeS(self[i]) end
    return
  end
  local s=self.count or ""
  if (s==0) or (s==1) then s="" end  
  self.text2:SetText(s)
end
iconUpdateText2TypeS=taskFuncs.iconUpdateText2TypeS

local defaultColors=eF.defaultColors
local unpack=unpack
function taskFuncs:updateBorderColorDebuffType()
  if self.isListElement then
    for i=1,self.active do updateBorderColorDebuffType(self[i]) end
    return
  end
  if not self.filled then return end
  if  self.debuffType then
      local r,g,b=unpack(defaultColors[self.debuffType])
      if r then self.border:Show(); self.border:SetVertexColor(r,g,b) else self.border:Hide() end
  else self.border:Hide() end 
end
updateBorderColorDebuffType=taskFuncs.updateBorderColorDebuffType

function taskFuncs:statusBarPowerUpdate(unit)
  self:SetValue(UnitPower(unit)/UnitPowerMax(unit))
end

function taskFuncs:statusBarHAbsorbUpdate(unit)
  self:SetValue(UnitGetTotalHealAbsorbs(unit)/UnitHealthMax(unit))
end

function taskFuncs:familyDisableAll()
  self.full=false
  self.filled=false
  for k=1,self.active do self[k]:disable() end
  self.active=0
end

function taskFuncs:familyApplyAuraAdopt(...)
  if self.full then return end
  local bool=self:auraAdopt(...)
  if not bool then return end
 
  self.active=self.active+1
  self.filled=true
  self[self.active]:adopt(...)
  if self.active==self.para.count then self.full=true end
  
end

local isInList=eF.isInList
function taskFuncs:blacklistAdoptAura(name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellID,isBoss)
  if isInList(name,self.para.arg1) then return false end
  local sid=tostring(spellID)
  if isInList(sid,self.para.arg1) then return false end
  if self.para.ignorePermanents and duration==0 then return false end
  if self.para.ownOnly and not (unitCaster=="player") then return false end
  local iDA=self.para.ignoreDurationAbove
  if iDA then if duration>iDA then return false end end 
  
  return true
end

function taskFuncs:whitelistAdoptAura(name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellID,isBoss)
  if not isInList(name,self.para.arg1) then 
    local sid=tostring(spellID)
    if not isInList(sid,self.para.arg1) then return false end
  end
  
  if self.para.ignorePermanents and duration==0 then return false end
  if self.para.ownOnly and not (unitCaster=="player") then return false end
  local iDA=self.para.ignoreDurationAbove
  if iDA then if duration>iDA then return false end end 
  
  return true
end

function taskFuncs:familyUpdateCasts()
  
  --resets state (before reinserting casts)
  self:disable()
  
  --remove nils from table
  local nList={}
  for i=1,#self.castList do
  
    local entry=self.castList[i]
    if entry then 
      nList[#nList+1]=entry
    end
  end
  self.castList=nList
  
  local n=math.min(#self.castList,self.para.count)
  self.active=n
  
  for i=1,self.para.count do
    self[i].filled=false
  end
  
  local casts=eF.castWatcher.casts
  for i=1,#self.castList do
  
    local castID=self.castList[i].castID
    if not casts[castID].list then casts[castID].list={} end
    casts[castID][#casts[castID]+1]=list,{self,i}
    casts[castID].unit=self.id
  end
    
  for i=1,n do
    local l=self.castList[i]
    self[i]:adoptCast(l.name,l.icon,l.duration,l.expirationTime,l.unitCaster,l.spellID,l.castID)
  end
    
end

function taskFuncs:familyDebuffTypeBorderColor()
  for i=1,self.active do
    taskFuncs.updateBorderColorDebuffType(self[i])
  end
end

function taskFuncs:familyApplySmartIcons()
  for i=1,self.active do
    taskFuncs.iconApplySmartIcon(self[i])
  end
end

function taskFuncs:familyUpdateTextTypeS()
  for i=1,self.active do
    taskFuncs.iconUpdateTextTypeS(self[i])
  end
end

function taskFuncs:familyUpdateText2TypeS()
  for i=1,self.active do
    taskFuncs.iconUpdateText2TypeS(self[i])
  end
end

function taskFuncs:familyUpdateCDWheels()
  for i=1,self.active do
    taskFuncs.iconUpdateCDWheel(self[i])
  end
end

function taskFuncs:frameOnUpdateFunction(elapsed)
  self.elapsed=self.elapsed+elapsed
  if self.elapsed<self.throttle then return end
  self.elapsed=0
  local lst=self.tasks.onUpdate
  for i=1,#lst do
    lst[i](self)
  end
end




