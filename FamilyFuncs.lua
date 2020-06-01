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
	if self.setVisibility then self:setVisibility(1) end
	self.filled=true
end

--count,debuffType,duration,expirationTime,unitCaster,canSteal,_,spellID
local function is_aura_new(self,count,expirationTime,spellID)
		local aI=self.auraInfo
		return not ((count==aI.count) and (expirationTime==aI.expirationTime) and (spellID==aI.spellID))
end

function taskFuncs:auraExtras(name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellID,isBoss)
		local ex=self.para.auraExtras
		if ex.stacks_check then
				if count<(ex.stacks_min or -1) or count>(ex.stacks_max or 10000) then return false end 
		end
		return true
end

local UnitAura=UnitAura
function taskFuncs:applyAuraAdopt(unit)
	local filter=self.para.trackType or nil
	for i=1,40 do 
		local name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,_,spellID,_,isBoss=UnitAura(unit,i,filter)
		if not name then break end
		local bool=self:auraAdopt(name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellID,isBoss) 
		local bool2=self:auraExtras(name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellID,isBoss)
		if bool and bool2 then
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

function taskFuncs:applyMsgAdopt(msg,event)

	local bool=self:msgAdopt(msg) 
	local bool2=(self.para.chatType=="ANY") or (event==self.para.chatType)


	if bool and bool2 then
		local aI=self.auraInfo
		local t=GetTime()
		aI.new_aura=true
		aI.name=msg
		aI.icon=0
		aI.count=string.match(msg, "%d+") or 0
		aI.duration=(self.para.match_duration_in_message and (aI.count~=0) and min(aI.count,60)) or self.para.chatTimed
		aI.expirationTime=t+aI.duration

		if not self.filled then self:enable() end    
		return
	end--end of if bool

end

eF.rc_status_to_icon={
	[0]="Interface\\RAIDFRAME\\ReadyCheck-NotReady.PNG",
	[1]="Interface\\RAIDFRAME\\ReadyCheck-Ready.PNG",
	[2]="Interface\\RAIDFRAME\\ReadyCheck-Waiting.PNG",
}
local rc_status_to_icon=eF.rc_status_to_icon
function taskFuncs:applyReadyCheck(status,ended,time)


	local status=status or 2
	local bool=(self.para.rcType==3) or (self.para.rcType==status)

	if bool then
		local aI=self.auraInfo
		local t=GetTime()
		aI.name=""
		aI.icon=rc_status_to_icon[status]
		aI.count=status
		if time then
			aI.duration=time
			aI.expirationTime=t+aI.duration
			aI.new_aura=true
		end

		if ended then
			aI.duration=0.01
			aI.expirationTime=GetTime()
			aI.new_aura=true
		end

		if not self.filled then self:enable() end    
		return
	end--end of if bool

	if not bool and self.filled then self:disable() end

end

function taskFuncs:iconUpdateChatTimed()
	local t,eT=GetTime(),self.auraInfo.expirationTime
	if t>eT then self:disable() end 
end

function taskFuncs:rcOnUpdate()
	local t,eT=GetTime(),self.auraInfo.expirationTime
	if t>eT+(self.para.rcLinger or 0) then self:disable() end 
end

local str_find=string.find
taskFuncs.msgAdopt={
	contains=function(self,msg)
		local arg=self.para.arg1  
		return str_find(msg,arg)
	end,
	
	is=function(self,msg)
		local arg=self.para.arg1  
		return msg==arg
	end,

	starts=function(self,msg)
		local arg=self.para.arg1  
		return msg:sub(1,#arg)==arg
	end,
	
	ends=function(self,msg)
		local arg=self.para.arg1  
		return (msg=="") or (msg:sub(-#arg)==arg)
	end,
}

local UnitThreatSituation=UnitThreatSituation
function taskFuncs:applyAnyThreatAdopt(unit)
		
		local bool=self:threatAdopt(UnitThreatSituation(unit))
		
		if bool and not self.filled then 
			self:enable()
		elseif self.filled and not bool then
			self:disable()
		end
end

function taskFuncs:setVisibility(alpha)
		local alpha_visible=(self:GetAlpha()==1)
		if alpha_visible and (alpha==0) or (alpha==false) then
				self:SetAlpha(0)
		elseif (not alpha_visible) and (alpha==1) or (alpha==true) then
				self:SetAlpha(1)
		end
end

function taskFuncs:adoptThreatByStatus(status)
	return status==self.para.arg1
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

local UnitIsUnit=UnitIsUnit
local function is_target_of(unit,k)
		local targets=eF.casting_units_targets[k]
		if not targets then return false end
		for i=1,#targets do 
				if UnitIsUnit(unit,targets[1].id or "") then return true end
		end
		return false
end

local pairs,unpack=pairs,unpack
function taskFuncs:applyListCastAdopt(unit)
		self.active=0
		local filter=self.para.trackType or nil
		local active,casts,targets=0,eF.casting_units_casts,eF.casting_units_targets
		
		for k,v in pairs(casts) do
				if is_target_of(unit,k) then
						local name,icon,duration,expirationTime,spellID,unitCaster=unpack(v)
						local bool=self:castAdopt(name,icon,nil,nil,duration,expirationTime,unitCaster,nil,spellID,nil) 
						if bool then
								active=active+1
								local frame=self[active]
								local aI=frame.auraInfo
								if is_aura_new(frame,count,expirationTime,spellID) then
										aI.new_aura=true
										aI.name=name
										aI.icon=icon
										--aI.count=nil
										--aI.debuffType=debuffType
										aI.duration=duration
										aI.expirationTime=expirationTime
										aI.unitCaster=unitCaster
										--aI.canSteal=canSteal
										aI.spellID=spellID
										--aI.isBoss=isBoss
										aI.isPermanent=aI.expirationTime==0
								else         
										aI.new_aura=false
								end
										
								if active==self.count then break end
						end--end of if bool
						
				end--end of if is_target_of(self,k)
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

function taskFuncs:iconUpdateVisibilityTrem()
		if not self.auraInfo.expirationTime then self:setVisibility(0) end
		local min,max=self.para.auraExtras.trem_min,self.para.auraExtras.trem_max
		local trem=self.auraInfo.expirationTime-GetTime()
		if (trem<(max or 0)) and (trem>(min or 0)) then self:setVisibility(1) else self:setVisibility(0) end 
end

function taskFuncs:iconAdoptAuraByNameWhitelist(name,_,_,_,dur)
	 if self.para.ignorePermanents and dur==0 then return false end
	 if (self.para.iDA or 0>0) and dur>self.para.iDA then return false end
	 return self.para.arg1[name] 
end

function taskFuncs:iconAdoptAuraByNameBlacklist(name,_,_,_,dur)
	 if self.para.ignorePermanents and dur==0 then return false end
	 if (self.para.iDA or 0>0) and dur>self.para.iDA then return false end
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
	if not self.auraInfo.debuffType then return end
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
		 tbl.dispellable=(tbl.debuffType and eF.isDispellable[tbl.debuffType]) or false
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




