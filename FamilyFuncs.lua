local eF=elFramo

eF.taskFuncs=eF.taskFuncs or {}
local taskFuncs=eF.taskFuncs
local iconApplySmartIcon,iconUpdateCDWheel,iconUpdateTextTypeT,iconUpdateText2TypeT,iconUpdateTextTypeS,iconUpdateText2TypeS
local updateBorderColorDebuffType,changeDispellableDebuffSize,orderByDispellable
local wipe,table_sort=table.wipe,table.sort

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
    local aI=self.auraInfo
    return not ((count==aI.count) and (expirationTime==aI.expirationTime) and (spellID==aI.spellID))
end

function taskFuncs:applyAuraAdopt(unit)
    local filter=self.para.trackType or nil
    for i=1,40 do 
        local name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,_,spellID,_,isBoss=UnitAura(unit,i,filter)
        if not name then break end
        local bool=self:auraAdopt(name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellID,isBoss) 
            
        if bool then
            local aI=self.auraInfo
            if is_aura_new(self,count,expirationTime,spellID) then
                aI.new_aura=true
                aI.name=name
                aI.icon=icon
                aI.count=count
                aI.debuffType=debuffType
                aI.duration=duration
                aI.expirationTime=expirationTime
                aI.unitCaster=unitCaster
                aI.canSteal=canSteal
                aI.spellID=spellID
                aI.isBoss=isBoss
                aI.isPermanent=aI.expirationTime==0
            else         
                aI.new_aura=false
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
            local aI=frame.auraInfo
            if is_aura_new(frame,count,expirationTime,spellID) then
                aI.new_aura=true
                aI.name=name
                aI.icon=icon
                aI.count=count
                aI.debuffType=debuffType
                aI.duration=duration
                aI.expirationTime=expirationTime
                aI.unitCaster=unitCaster
                aI.canSteal=canSteal
                aI.spellID=spellID
                aI.isBoss=isBoss
                aI.isPermanent=aI.expirationTime==0
            else         
                aI.new_aura=false
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
  if not (self.filled and self.auraInfo.new_aura) then return end
  self.texture:SetTexture(self.auraInfo.icon)
end
iconApplySmartIcon=taskFuncs.iconApplySmartIcon

function taskFuncs:changeDispellableDebuffSize()
  if self.isListElement then
    for i=1,self.active do changeDispellableDebuffSize(self[i]) end
    return
  end
  if not (self.filled and self.auraInfo.new_aura) then return end
  if eF.isDispellable[self.auraInfo.debuffType] then 
    self:SetSize(self.para.dispellableHeight or self.para.height,self.para.dispellableWidth or self.para.width)
  else
    self:SetSize(self.para.height,self.para.width)
  end
end
changeDispellableDebuffSize=taskFuncs.changeDispellableDebuffSize

local function dispellable_compare(v1,v2)
    return ((v1.dispellable==v2.dispellable) and v1.index<v2.index) or (v1.dispellable and (not v2.dispellable)) 
end

local help_table1={}
function taskFuncs:orderByDispellable()
   if not self.isListElement then return end
   wipe(help_table1)
   local bool=false
   for i=1,self.active do 
     help_table1[i]=self[i].auraInfo
     local tbl=help_table1[i]
     tbl.dispellable=eF.isDispellable[tbl.debuffType]
     if (not bool) and tbl.dispellable then bool=true end
     tbl.index=i
   end
   
   if not bool then return end --if no dispellable aura, just leave
   
   table_sort(help_table1,dispellable_compare)
   
   for i=1,self.active do 
     self[i].auraInfo=help_table1[i]
     if i~=help_table1[i].index then help_table1[i].new_aura=true end
   end
   
end
orderByDispellable=taskFuncs.orderByDispellable

function taskFuncs:iconUpdateCDWheel()
  if self.isListElement then
    for i=1,self.active do iconUpdateCDWheel(self[i]) end
    return
  end
  local aI=self.auraInfo
  if not (self.filled and aI.new_aura) then return end
  local dur=aI.duration
  self.cdFrame:SetCooldown(aI.expirationTime-dur,dur)
end
iconUpdateCDWheel=taskFuncs.iconUpdateCDWheel

function taskFuncs:iconUpdateTextTypeT()
  if self.isListElement then
    for i=1,self.active do iconUpdateTextTypeT(self[i]) end
    return
  end
  local t,aI=GetTime(),self.auraInfo
  local s=(aI.isPermanent and "") or self.textDecimalFunc(aI.expirationTime-t)
  self.text:SetText(s)
end
iconUpdateTextTypeT=taskFuncs.iconUpdateTextTypeT

function taskFuncs:iconUpdateText2TypeT()
  if self.isListElement then
    for i=1,self.active do iconUpdateText2TypeT(self[i]) end
    return
  end
  local t,aI=GetTime(),self.auraInfo
  local s=(aI.isPermanent and "") or self.text2DecimalFunc(aI.expirationTime-t)
  self.text2:SetText(s)
end
iconUpdateText2TypeT=taskFuncs.iconUpdateText2TypeT

function taskFuncs:iconUpdateTextTypeS()
  if self.isListElement then
    for i=1,self.active do iconUpdateTextTypeS(self[i]) end
    return
  end
  local s=self.auraInfo.count or ""
  if (s==0) or (s==1) then s="" end  
  self.text:SetText(s)
end
iconUpdateTextTypeS=taskFuncs.iconUpdateTextTypeS

function taskFuncs:iconUpdateText2TypeS()
  if self.isListElement then
    for i=1,self.active do iconUpdateText2TypeS(self[i]) end
    return
  end
  local s=self.auraInfo.count or ""
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
  if  self.auraInfo.debuffType then
      local r,g,b=unpack(defaultColors[self.auraInfo.debuffType])
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

function taskFuncs:frameOnUpdateFunction(elapsed)
  self.elapsed=self.elapsed+elapsed
  if self.elapsed<self.throttle then return end
  self.elapsed=0
  local lst=self.tasks.onUpdate
  for i=1,#lst do
    lst[i](self)
  end
end




