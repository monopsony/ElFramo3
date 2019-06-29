local eF=elFramo

eF.familyUtils={}
eF.tasks={}
eF.workFuncs={}
local fu=eF.familyUtils
local wipe=table.wipe
local setmetatable=setmetatable
local pairs=pairs
local taskFuncs=eF.taskFuncs

local function metaFunction(t,k)
  --if not k then return nil end
  t[k]={}
  return t[k]
end
setmetatable(eF.tasks,{__index=metaFunction})
setmetatable(eF.workFuncs,{__index=metaFunction})


local frameFunctions={} or eF.frameFunctions
eF.frameFunctions=frameFunctions

local function applyElement(frame,j,k)
  if not frame then return end
  local smart=eF.para.families[j].smart
  if smart and k then return end --to apply a smart family, you need to only give j 
  
  if j and k then fu.applyOrphan(frame,j,k)
  elseif j then fu.applyFamily(frame,j) end
end
fu.applyElement=applyElement

local function applyAllElements(frame)
  local parafam=eF.para.families
  
  for j=1,#parafam do
    local fam=parafam[j]
    if parafam[j].smart then applyElement(frame,j)
    else
      for k=1,#fam do
        applyElement(frame,j,k)
      end --end of k
    end --end of if para[j].smart then
  end --end of j
end
fu.applyAllElements=applyAllElements

local function applyOrphan(frame,j,k)
  local para=eF.para.families[j][k]
  if not frame[j] then frame[j]={} end --check whether family exists in frame
  
  if para.type=="icon" then 
    if not frame[j][k] then frame[j][k]=CreateFrame("Frame",("%sElement%s%s"):format(frame:GetName(),j,k),frame) end --check whether element even exists
    local el=frame[j][k] 
    el:SetFrameLevel(frame.hp:GetFrameLevel()+1+(para.displayLevel or 0))
    el.para=para
    el.enable=taskFuncs.frameEnable
    el.disable=taskFuncs.frameDisable
    el.onUpdateFunction=taskFuncs.frameOnUpdateFunction
    el.tasks=eF.tasks[j][k]
       
    --dimensions and position
    el:SetWidth(para.width)
    el:SetHeight(para.height)
    el:ClearAllPoints()
    el:SetPoint(para.anchor,frame,para.anchorTo,para.xPos,para.yPos)
    
    --static handling
    if para.trackType=="Static" then
      el:Show()
      el.static=true
      el.expirationTime=0
      el.duration=0
    else
      el.static=false
      el:Hide()
    end --end of if para.trackType=="Static" 
    
    --texture handling
    if not el.texture then el.texture=el:CreateTexture(nil,"BACKGROUND") end
    if para.hasTexture then 
      local r,g,b,a=para.textureR or 1,para.textureG or 1,para.textureB or 1, para.textureA or 1
      el.texture:Show()   
      el.texture:ClearAllPoints()
      el.texture:SetAllPoints()
      if para.texture and not (para.texture=="" or para.texture=="nil") then
        el.texture:SetTexture(para.texture)
        el.texture:SetVertexColor(r,g,b)
      elseif not para.smartIcon then
        el.texture:SetColorTexture(r,g,b,a)
      else
        el.texture:SetVertexColor(r,g,b)
        --inserting iconApplySmartIcon from meta table
      end      
    else --end of if para.hasTexture
      el.texture:Hide()
    end
    
    --border handling
    if not el.border then 
      el.border=el:CreateTexture(nil,"OVERLAY")
      el.border:SetTexture([[Interface\Buttons\UI-Debuff-Overlays]])
      el.border:SetAllPoints()
      el.border:SetTexCoord(.296875, .5703125, 0, .515625)
    end
    if para.hasBorder then
      el.border:Hide()
    else
      el.border:Hide()
    end
    
    --cdWheel handling
    if not el.cdFrame then 
      el.cdFrame=CreateFrame("Cooldown",el:GetName().."CooldownFrame",el,"CooldownFrameTemplate")
      el.cdFrame:SetAllPoints()
      el.cdFrame:SetFrameLevel(el:GetFrameLevel())
    end
    if para.cdWheel then
      if para.cdReverse then el.cdFrame:SetReverse(true) else el.cdFrame:SetReverse(false) end
      el.cdFrame:Show()
    else
      el.cdFrame:Hide()
    end
    
    --text1 handling
    if not el.text then el.text=el:CreateFontString(nil,"OVERLAY") end
    if para.hasText then
      el.text:Show()
      local font,extra=para.textFont or "Fonts\\FRIZQT__.ttf",para.textExtra or "OUTLINE"
      local size,xOS,yOS=para.textSize or 20,para.textXOS or 0, para.textYOS or 0
      local r,g,b,a=para.textR or 1,para.textG or 1,para.textB or 1, para.textA or 1
      el.text:SetFont(font,size,extra)
      el.text:ClearAllPoints()
      el.text:SetPoint(para.textAnchor,el,para.textAnchorTo,xOS,yOS)
      el.text:SetTextColor(r,g,b,a)
    else
      el.text:Hide()
    end
    
     --text2 handling
    if not el.text2 then el.text2=el:CreateFontString(nil,"OVERLAY") end
    if para.hasText2 then
      el.text2:Show()
      local font,extra=para.text2Font or "Fonts\\FRIZQT__.ttf",para.text2extra or "OUTLINE"
      local size,xOS,yOS=para.text2Size or 20,para.text2XOS or 0, para.text2YOS or 0
      local r,g,b,a=para.text2R or 1,para.text2G or 1,para.text2B or 1, para.text2A or 1
      el.text2:SetFont(font,size,extra)
      el.text2:ClearAllPoints()
      el.text2:SetPoint(para.text2Anchor,el,para.text2AnchorTo,xOS,yOS)
      el.text2:SetTextColor(r,g,b,a)
    else
      el.text2:Hide()
    end
    
  end --end of if para.type=="icon" then
  
  if para.type=="bar" then
    if not frame[j][k] then frame[j][k]=CreateFrame("StatusBar",("%sElement%s%s"):format(frame:GetName(),j,k),frame,"TextStatusBar") end
    local el=frame[j][k]
    el:SetFrameLevel(frame.hp:GetFrameLevel()+1+(para.displayLevel or 0))
    el.para=para
    el.enable=taskFuncs.frameEnable
    el.disable=taskFuncs.frameDisable
    el.onUpdateFunction=taskFuncs.frameOnUpdateFunction
    el.tasks=eF.tasks[j][k]
    
    --positional
    el:ClearAllPoints()
    if para.grow=="up" or not para.grow then 
      el:SetPoint("BOTTOM",frame,para.anchorTo,para.xPos,para.yPos)
      el:SetWidth(para.lFix)
      el:SetHeight(para.lMax)
      el:SetOrientation("VERTICAL")
      el:SetReverseFill(false)
    elseif para.grow=="down" then 
      el:SetPoint("TOP",frame,para.anchorTo,para.xPos,para.yPos)
      el:SetWidth(para.lFix)
      el:SetHeight(para.lMax)
      el:SetOrientation("VERTICAL")
      el:SetReverseFill(true)
    elseif para.grow=="right" then 
      el:SetPoint("LEFT",frame,para.anchorTo,para.xPos,para.yPos)
      el:SetWidth(para.lMax)
      el:SetHeight(para.lFix)
      el:SetOrientation("HORIZONTAL") 
      el:SetReverseFill(false)
    else
      el:SetPoint("RIGHT",frame,para.anchorTo,para.xPos,para.yPos)
      el:SetWidth(para.lMax)
      el:SetHeight(para.lFix)
      el:SetOrientation("HORIZONTAL")
      el:SetReverseFill(true)
    end
    
    --color/display
    local r,g,b,a=para.textureR or 1,para.textureG or 1,para.textureB or 1, para.textureA or 1
    el:SetStatusBarTexture(r,g,b,a)
    el:SetMinMaxValues(0,1)
    
    --static&needed info
    if para.trackType=="power" then
      el.static=true
      el:Show()
      el.id=frame.id
    elseif para.trackType=="heal absorb" then
      el.static=true
      el:Show()
      el.id=frame.id
    else
      el.static=false
    end
    
    
  end
  
  if para.type=="border" then
    if not frame[j][k] then frame[j][k]=CreateFrame("Frame",("%sElement%s%s"):format(frame:GetName(),j,k),frame) end 
    local el=frame[j][k] 
    el:SetFrameLevel(frame.hp:GetFrameLevel()+1+(para.displayLevel or 0))
    el.para=para
    el.enable=taskFuncs.frameEnable
    el.disable=taskFuncs.frameDisable
    el.onUpdateFunction=taskFuncs.frameOnUpdateFunction
    el.tasks=eF.tasks[j][k]
        
    --position and visuals
    el:ClearAllPoints()
    el:SetAllPoints()
    local r,g,b,a=para.borderR or 1,para.borderG or 1,para.borderB or 1,para.borderA or 1
    local size=para.borderSize or 2
    for k,v in next,{"RIGHT","TOP","LEFT","BOTTOM"} do
      local loc,p1,p2,w,f11,f12,f21,f22=eF.borderInfo(v)
      if not el[loc] then el[loc]=el:CreateTexture(nil,"OVERLAY") end
      el[loc]:SetColorTexture(1,1,1)
      el[loc]:ClearAllPoints()
      el[loc]:SetPoint(p1,el,p1,f11*(size),f12*(size))
      el[loc]:SetPoint(p2,el,p2,f21*(size),f22*(size))
      if w then el[loc]:SetWidth(size);
      else el[loc]:SetHeight(size); end  
    end
    
    --static handling
    if para.trackType=="Static" then
      el:Show()
      el.static=true
      el.expirationTime=0
      el.duration=0
    else
      el.static=false
      el:Hide()
    end
    
  end
  
  --apply work funcs
  if eF.workFuncs[j][k] then
    for funcName,func in pairs(eF.workFuncs[j][k]) do
      frame[j][k][funcName]=func
    end
  end 
  
  
end
fu.applyOrphan=applyOrphan

local function updateOrphanMeta(j,k)
  local para=eF.para.families[j][k]
  local smart=eF.para.families[j].smart
  if smart and k then return end
  resetTaskList(j,k)
  resetWorkFuncs(j,k)
  local tasks=eF.tasks[j][k]
  local work=eF.workFuncs[j][k]
   
  if para.type=="icon" then
    tasks.onAura[#tasks.onAura+1]=taskFuncs.frameDisable
    
    if para.trackType=="Buffs" then
      tasks.onBuff[#tasks.onBuff+1]=taskFuncs.applyAuraAdopt
      
      if para.adoptFunc=="Name" then
        work.auraAdopt=taskFuncs.iconAdoptAuraByName
      elseif para.adoptFunc=="Spell ID" then
        work.auraAdopt=taskFuncs.iconAdoptAuraBySpellID
      end  
    end --end of if para.trackType=="Buffs" then
    
    if para.trackType=="Debuffs" then
      tasks.onDebuff[#tasks.onDebuff+1]=taskFuncs.applyAuraAdopt
      
      if para.adoptFunc=="Name" then
        work.auraAdopt=taskFuncs.iconAdoptAuraByName
      elseif para.adoptFunc=="Spell ID" then
        work.auraAdopt=taskFuncs.iconAdoptAuraBySpellID
      end
    end --end of if para.trackType=="Debuffs" then
    
    if para.hasTexture and para.smartIcon then
      tasks.onAura[#tasks.onAura+1]=taskFuncs.iconApplySmartIcon
    end
    
    if para.cdWheel then
      tasks.onAura[#tasks.onAura+1]=taskFuncs.iconUpdateCDWheel
    end
    
    if para.hasText then
      if para.textType=="Time left" then tasks.onUpdate[#tasks.onUpdate+1]=taskFuncs.iconUpdateTextTypeT end
      if para.textType=="Stacks" then tasks.onAura[#tasks.onAura+1]=taskFuncs.iconUpdateTextTypeS end
    end
    
    if para.hasText2 then
      if para.text2Type=="Time left" then tasks.onUpdate[#tasks.onUpdate+1]=taskFuncs.iconUpdateText2TypeT end
      if para.text2Type=="Stacks" then tasks.onAura[#tasks.onAura+1]=taskFuncs.iconUpdateText2TypeS end
    end
    

    
  end --end of if para.type=="icon" then
  
  if para.type=="bar" then
    if para.trackType=="power" then
      tasks.onPower[#tasks.onPower+1]=taskFuncs.statusBarPowerUpdate
      tasks.onLoad[#tasks.onLoad+1]=taskFuncs.statusBarPowerUpdate
    elseif para.trackType=="heal absorb" then
      tasks.onPower[#tasks.onPower+1]=taskFuncs.statusBarHAbsorbUpdate    
      tasks.onLoad[#tasks.onLoad+1]=taskFuncs.statusBarHAbsorbUpdate    
    end 
  end
  
  if para.type=="border" then
    
    tasks.onAura[#tasks.onAura+1]=taskFuncs.frameDisable
    
    if para.trackType=="Buffs" then
      tasks.onBuff[#tasks.onBuff+1]=taskFuncs.applyAuraAdopt
      
      if para.adoptFunc=="Name" then
        work.auraAdopt=taskFuncs.iconAdoptAuraByName
      elseif para.adoptFunc=="Spell ID" then
        work.auraAdopt=taskFuncs.iconAdoptAuraBySpellID
      end  
    end --end of if para.trackType=="Buffs" then
    
    if para.trackType=="Debuffs" then
      tasks.onDebuff[#tasks.onDebuff+1]=taskFuncs.applyAuraAdopt
      
      if para.adoptFunc=="Name" then
        work.auraAdopt=taskFuncs.iconAdoptAuraByName
      elseif para.adoptFunc=="Spell ID" then
        work.auraAdopt=taskFuncs.iconAdoptAuraBySpellID
      end
    end --end of if para.trackType=="Debuffs" then
    
  end 
end
fu.updateOrphanMeta=updateOrphanMeta

local function applyFamily(frame,j)
  local para=eF.para.families[j]
  if not frame[j] then frame[j]=CreateFrame("Frame",("%sElement%s"):format(frame:GetName(),j),frame) end --check whether family exists in frame
  local ff=frame[j]
  ff.disable=taskFuncs.familyDisableAll
  ff.enable=taskFuncs.familyEnableAll
  ff.filled=false
  ff.id=frame.id
  ff.para=para
  ff.smart=true
  ff.active=0
  ff:ClearAllPoints()
  ff:SetAllPoints()
    
  --apply work funcs
  if eF.workFuncs[j] then
    for funcName,func in pairs(eF.workFuncs[j]) do
      frame[j][funcName]=func
    end
  end 
   
  for k=1,para.count do
    if not ff[k] then ff[k]=CreateFrame("Frame",("%sElement%s%s"):format(frame:GetName(),j,k),ff) end
    local cf=ff[k]
    cf:SetFrameLevel(frame.hp:GetFrameLevel()+1+(para.displayLevel or 0))
    cf.para=para
    cf.enable=taskFuncs.frameEnable
    cf.disable=taskFuncs.frameDisable    
    cf.id=frame.id 
    cf.onUpdateFunction=taskFuncs.frameOnUpdateFunction
    cf.tasks=eF.tasks[j]
    
    --adoption styles
    if para.trackType=="Buffs" or para.trackType=="Debuffs" then
      cf.adopt=taskFuncs.unconditionalAuraAdopt
    elseif para.trackType=="Casts" then
      cf.adopt=taskFuncs.unconditionalCastAdopt
    end
    
    --calculate position
    local xOS,yOS=0,0  
    if para.grow=="down" then yOS=(1-k)*(para.spacing+para.height)
    elseif para.grow=="up" then yOS=(k-1)*(para.spacing+para.height)
    elseif para.grow=="right" then xOS=(k-1)*(para.spacing+para.width)
    elseif para.grow=="left" then xOS=(1-k)*(para.spacing+para.width) 
    end
    
    --apply positions
    cf:SetWidth(para.width)
    cf:SetHeight(para.height)
    cf:ClearAllPoints()
    xOS,yOS=xOS+para.xPos,yOS+para.yPos
    cf:SetPoint(para.anchor,frame,para.anchorTo,xOS,yOS)
    cf:Hide()

    if para.hasTexture then
      if not cf.texture then cf.texture=cf:CreateTexture(nil,"BACKGROUND"); cf.texture:SetAllPoints() end
      cf.texture:Show()
      local r,g,b,a=para.textureR or 1,para.textureG or 1,para.textureB or 1, para.textureA or 1
      if para.texture and not (para.texture=="" or para.texture=="nil") then
        cf.texture:SetTexture(para.texture)
        cf.texture:SetVertexColor(r,g,b)
      elseif not para.smartIcon then
        cf.texture:SetColorTexture(r,g,b,a)
      else
        cf.texture:SetVertexColor(r,g,b)
      end    
    else
      if cf.texture then cf.texture:Hide() end
    end
    
     --border handling
    if not cf.border then 
      cf.border=cf:CreateTexture(nil,"OVERLAY")
      cf.border:SetTexture([[Interface\Buttons\UI-Debuff-Overlays]])
      cf.border:SetAllPoints()
      cf.border:SetTexCoord(.296875, .5703125, 0, .515625)
    end
    if para.hasBorder then
      cf.border:Hide()
    else
      cf.border:Hide()
    end
    
    --cdWheel handling
    if not cf.cdFrame then 
      cf.cdFrame=CreateFrame("Cooldown",cf:GetName().."CooldownFrame",cf,"CooldownFrameTemplate")
      cf.cdFrame:SetAllPoints()
      cf.cdFrame:SetFrameLevel(cf:GetFrameLevel())
    end
    if para.cdWheel then
      if para.cdReverse then cf.cdFrame:SetReverse(true) else cf.cdFrame:SetReverse(false) end
      cf.cdFrame:Show()
    else
      cf.cdFrame:Hide()
    end
    
    --text1 handling
    if not cf.text then cf.text=cf:CreateFontString(nil,"OVERLAY") end
    if para.hasText then
      cf.text:Show()
      local font,extra=para.textFont or "Fonts\\FRIZQT__.ttf",para.textExtra or "OUTLINE"
      local size,xOS,yOS=para.textSize or 20,para.textXOS or 0, para.textYOS or 0
      local r,g,b,a=para.textR or 1,para.textG or 1,para.textB or 1, para.textA or 1
      cf.text:SetFont(font,size,extra)
      cf.text:ClearAllPoints()
      cf.text:SetPoint(para.textAnchor,cf,para.textAnchorTo,xOS,yOS)
      cf.text:SetTextColor(r,g,b,a)
    else
      cf.text:Hide()
    end
    
     --text2 handling
    if not cf.text2 then cf.text2=cf:CreateFontString(nil,"OVERLAY") end
    if para.hasText2 then
      cf.text2:Show()
      local font,extra=para.text2Font or "Fonts\\FRIZQT__.ttf",para.text2extra or "OUTLINE"
      local size,xOS,yOS=para.text2Size or 20,para.text2XOS or 0, para.text2YOS or 0
      local r,g,b,a=para.text2R or 1,para.text2G or 1,para.text2B or 1, para.text2A or 1
      cf.text2:SetFont(font,size,extra)
      cf.text2:ClearAllPoints()
      cf.text2:SetPoint(para.text2Anchor,cf,para.text2AnchorTo,xOS,yOS)
      cf.text2:SetTextColor(r,g,b,a)
    else
      cf.text2:Hide()
    end
    
  end
  
end
fu.applyFamily=applyFamily

--actually do the meta
local function updateFamilyMeta(j)
  local para=eF.para.families[j]
  local smart=eF.para.families[j]
  if not smart then return end
  resetTaskList(j)
  resetWorkFuncs(j)
  local tasks=eF.tasks[j]
  local work=eF.workFuncs[j]
   
  if para.trackType=="Buffs" then
    tasks.onAura[#tasks.onAura+1]=taskFuncs.familyDisableAll
    tasks.onBuff[#tasks.onBuff+1]=taskFuncs.familyApplyAuraAdopt
    
    if para.type=="w" then
      work.auraAdopt=taskFuncs.whitelistAdoptAura
    elseif para.type=="b" then
      work.auraAdopt=taskFuncs.blacklistAdoptAura
    end
  end 
  
  if para.trackType=="Debuffs" then 
    tasks.onAura[#tasks.onAura+1]=taskFuncs.familyDisableAll
    tasks.onDebuff[#tasks.onDebuff+1]=taskFuncs.familyApplyAuraAdopt
    
    if para.type=="w" then
      work.auraAdopt=taskFuncs.whitelistAdoptAura
    elseif para.type=="b" then
      work.auraAdopt=taskFuncs.blacklistAdoptAura
    end
  end 
  
  if para.trackType=="Casts" then
    tasks.postCast[#tasks.postCast+1]=taskFuncs.familyUpdateCasts
  end
   
  if para.hasBorder and para.borderType=="debuffColor" and (para.trackType=="Debuffs" or para.trackType=="Buffs") then
    tasks.onAura[#tasks.onAura+1]=taskFuncs.familyDebuffTypeBorderColor
  end
   
  if para.hasTexture and (not para.texture or para.smartIcon) then
    if (para.trackType=="Buffs") or (para.trackType=="Debuffs") then
      tasks.onAura[#tasks.onAura+1]=taskFuncs.familyApplySmartIcons
    elseif para.trackType=="Casts" then
      tasks.postCast[#tasks.onAura+1]=taskFuncs.familyApplySmartIcons
    end
  end
    
  if para.cdWheel then
    if (para.trackType=="Buffs") or (para.trackType=="Debuffs") then
      tasks.onAura[#tasks.onAura+1]=taskFuncs.familyUpdateCDWheels
    elseif para.trackType=="Casts" then
      tasks.postCast[#tasks.onAura+1]=taskFuncs.familyUpdateCDWheels
    end
  end
   
  if para.hasText then
    if para.textType=="Time left" then tasks.onUpdate[#tasks.onUpdate+1]=taskFuncs.iconUpdateTextTypeT end
    if para.textType=="Stacks" then tasks.onAura[#tasks.onAura+1]=taskFuncs.familyUpdateTextTypeS end
  end
  
  if para.hasText2 then
    if para.text2Type=="Time left" then tasks.onUpdate[#tasks.onUpdate+1]=taskFuncs.iconUpdateText2TypeT end
    if para.text2Type=="Stacks" then tasks.onAura[#tasks.onAura+1]=taskFuncs.familyUpdateText2TypeS end
  end

end
fu.updateFamilyMeta=updateFamilyMeta

local function updateAllMetas()
  local parafam=eF.para.families
  for j=1,#parafam do
    local fam=parafam[j]
    if parafam[j].smart then updateFamilyMeta(j)
    else
      for k=1,#fam do
        updateOrphanMeta(j,k)
      end --end of k
    end --end of if para[j].smart then
  end --end of j
end
fu.updateAllMetas=updateAllMetas

local LSM=LibStub:GetLibrary("LibSharedMedia-3.0")
function frameFunctions:apply_element_paras(name)
  if not name then
    for k,_ in pairs(eF.para.elements) do self:apply_element_paras(k) end
    self.current_elements_version=eF.current_elements_version
    return
  elseif not eF.para.elements[name] then return end
  local para=eF.para.elements[name]
  local frame=self
  local taskFuncs=eF.taskFuncs
  if para.type=="icon" then 
    if not frame.elements[name] then frame.elements[name]=CreateFrame("Frame",("%sElement%s"):format(frame:GetName(),name),frame) end --check whether element even exists already
    local el=frame.elements[name] 
    el:SetFrameLevel(frame.hp:GetFrameLevel()+1+(para.displayLevel or 0))
    el.para=para
    el.enable=taskFuncs.frameEnable
    el.disable=taskFuncs.frameDisable
    el.onUpdateFunction=taskFuncs.frameOnUpdateFunction
    el.tasks=eF.tasks[name]
       
    --dimensions and position
    el:SetWidth(para.width)
    el:SetHeight(para.height)
    el:ClearAllPoints()
    el:SetPoint(para.anchor,frame,para.anchorTo,para.xPos,para.yPos)
    
    --static handling
    if para.trackType=="Static" then  --TBA STATIC HANDLING
      el:Show()
      el.static=true
      el.expirationTime=0
      el.duration=0
    else
      el.static=false
      el:Hide()
    end --end of if para.trackType=="Static" 
    
    --texture handling
    if not el.texture then el.texture=el:CreateTexture(nil,"BACKGROUND") end
    if para.hasTexture then 
      local r,g,b,a=para.textureR or 1,para.textureG or 1,para.textureB or 1, para.textureA or 1
      el.texture:Show()   
      el.texture:ClearAllPoints()
      el.texture:SetAllPoints()
      
      if para.smartIcon then
        --nothing needed here for now
      elseif para.solidTexture then
        el.texture:SetColorTexture(r,g,b,a)
      elseif para.texture=="" or para.texture=="nil" then
        el.texture:SetColorTexture(r,g,b,a)
      else
        el.texture:SetTexture(para.texture)
        el.texture:SetVertexColor(r,g,b)
      end
      
    else --end of if para.hasTexture
      el.texture:Hide()
    end
    
    --border handling
    if not el.border then 
      el.border=el:CreateTexture(nil,"OVERLAY")
      el.border:SetTexture([[Interface\Buttons\UI-Debuff-Overlays]])
      el.border:SetAllPoints()
      el.border:SetTexCoord(.296875, .5703125, 0, .515625)
    end
    if para.hasBorder then
      el.border:Hide()
    else
      el.border:Hide()
    end
    
    --cdWheel handling
    if not el.cdFrame then 
      el.cdFrame=CreateFrame("Cooldown",el:GetName().."CooldownFrame",el,"CooldownFrameTemplate")
      el.cdFrame:SetAllPoints()
      el.cdFrame:SetFrameLevel(el:GetFrameLevel())
    end
    if para.cdWheel then
      if para.cdReverse then el.cdFrame:SetReverse(true) else el.cdFrame:SetReverse(false) end
      el.cdFrame:Show()
    else
      el.cdFrame:Hide()
    end
    
    
    --TBA font handling
    --text1 handling
    if not el.text then el.text=el:CreateFontString(nil,"OVERLAY") end
    if para.hasText then
      el.text:Show()
      local font,extra=(LSM:IsValid("font",para.textFont) and LSM:Fetch("font",para.textFont)) or "",para.textExtra or "OUTLINE"
      local size,xOS,yOS=para.textSize or 20,para.textXOS or 0, para.textYOS or 0
      local r,g,b,a=para.textR or 1,para.textG or 1,para.textB or 1, para.textA or 1
      el.text:SetFont(font,size,extra)
      el.text:ClearAllPoints()
      el.text:SetPoint(para.textAnchor,el,para.textAnchorTo,xOS,yOS)
      el.text:SetTextColor(r,g,b,a)
    else
      el.text:Hide()
    end
    
     --text2 handling
    if not el.text2 then el.text2=el:CreateFontString(nil,"OVERLAY") end
    if para.hasText2 then
      el.text2:Show()
      local font,extra=LSM:IsValid("font",para.text2Font) and LSM:Fetch("font",para.text2Font)) or "",para.text2extra or "OUTLINE"
      local size,xOS,yOS=para.text2Size or 20,para.text2XOS or 0, para.text2YOS or 0
      local r,g,b,a=para.text2R or 1,para.text2G or 1,para.text2B or 1, para.text2A or 1
      el.text2:SetFont(font,size,extra)
      el.text2:ClearAllPoints()
      el.text2:SetPoint(para.text2Anchor,el,para.text2AnchorTo,xOS,yOS)
      el.text2:SetTextColor(r,g,b,a)
    else
      el.text2:Hide()
    end
    

    if #el.tasks.onUpdate>0 then
        local throttle=((para.throttleValue~=-1) and para.throttleValue) or math.min((0.1^math.floor(math.max(para.textDecimals,para.text2Decimals) or 1))*0.15,0.2)
        self.elapsed=self.throttle+1
        el:SetScript("OnUpdate",taskFuncs.frameOnUpdateFunction)
    else
        el:SetScript("OnUpdate",nil)
    end

  end --end of if para.type=="icon" then
  
  --TBA DO BAR
  if para.type=="bar" then
    if not frame[j][k] then frame[j][k]=CreateFrame("StatusBar",("%sElement%s%s"):format(frame:GetName(),j,k),frame,"TextStatusBar") end
    local el=frame[j][k]
    el:SetFrameLevel(frame.hp:GetFrameLevel()+1+(para.displayLevel or 0))
    el.para=para
    el.enable=taskFuncs.frameEnable
    el.disable=taskFuncs.frameDisable
    el.onUpdateFunction=taskFuncs.frameOnUpdateFunction
    el.tasks=eF.tasks[j][k]
    
    --positional
    el:ClearAllPoints()
    if para.grow=="up" or not para.grow then 
      el:SetPoint("BOTTOM",frame,para.anchorTo,para.xPos,para.yPos)
      el:SetWidth(para.lFix)
      el:SetHeight(para.lMax)
      el:SetOrientation("VERTICAL")
      el:SetReverseFill(false)
    elseif para.grow=="down" then 
      el:SetPoint("TOP",frame,para.anchorTo,para.xPos,para.yPos)
      el:SetWidth(para.lFix)
      el:SetHeight(para.lMax)
      el:SetOrientation("VERTICAL")
      el:SetReverseFill(true)
    elseif para.grow=="right" then 
      el:SetPoint("LEFT",frame,para.anchorTo,para.xPos,para.yPos)
      el:SetWidth(para.lMax)
      el:SetHeight(para.lFix)
      el:SetOrientation("HORIZONTAL") 
      el:SetReverseFill(false)
    else
      el:SetPoint("RIGHT",frame,para.anchorTo,para.xPos,para.yPos)
      el:SetWidth(para.lMax)
      el:SetHeight(para.lFix)
      el:SetOrientation("HORIZONTAL")
      el:SetReverseFill(true)
    end
    
    --color/display
    local r,g,b,a=para.textureR or 1,para.textureG or 1,para.textureB or 1, para.textureA or 1
    el:SetStatusBarTexture(r,g,b,a)
    el:SetMinMaxValues(0,1)
    
    --static&needed info
    if para.trackType=="power" then
      el.static=true
      el:Show()
      el.id=frame.id
    elseif para.trackType=="heal absorb" then
      el.static=true
      el:Show()
      el.id=frame.id
    else
      el.static=false
    end
    
    
  end
  
  --TBA DO BORDER
  if para.type=="border" then
    if not frame[j][k] then frame[j][k]=CreateFrame("Frame",("%sElement%s%s"):format(frame:GetName(),j,k),frame) end 
    local el=frame[j][k] 
    el:SetFrameLevel(frame.hp:GetFrameLevel()+1+(para.displayLevel or 0))
    el.para=para
    el.enable=taskFuncs.frameEnable
    el.disable=taskFuncs.frameDisable
    el.onUpdateFunction=taskFuncs.frameOnUpdateFunction
    el.tasks=eF.tasks[j][k]
        
    --position and visuals
    el:ClearAllPoints()
    el:SetAllPoints()
    local r,g,b,a=para.borderR or 1,para.borderG or 1,para.borderB or 1,para.borderA or 1
    local size=para.borderSize or 2
    for k,v in next,{"RIGHT","TOP","LEFT","BOTTOM"} do
      local loc,p1,p2,w,f11,f12,f21,f22=eF.borderInfo(v)
      if not el[loc] then el[loc]=el:CreateTexture(nil,"OVERLAY") end
      el[loc]:SetColorTexture(1,1,1)
      el[loc]:ClearAllPoints()
      el[loc]:SetPoint(p1,el,p1,f11*(size),f12*(size))
      el[loc]:SetPoint(p2,el,p2,f21*(size),f22*(size))
      if w then el[loc]:SetWidth(size);
      else el[loc]:SetHeight(size); end  
    end
    
    --static handling
    if para.trackType=="Static" then
      el:Show()
      el.static=true
      el.expirationTime=0
      el.duration=0
    else
      el.static=false
      el:Hide()
    end
    
  end
  
  --apply work funcs
  for funcName,func in pairs(eF.workFuncs[name]) do
    frame.elements[name][funcName]=func
  end
   
end

local function resetTaskList(name)
    if not name then return end

    if eF.tasks[name] then wipe(eF.tasks[name]) else eF.tasks[name]={} end
    setmetatable(eF.tasks[name],{__index=metaFunction})
end
fu.resetTaskList=resetTaskList

local function resetWorkFuncs(name)
    if not name then return end

    if eF.workFuncs[name] then wipe(eF.workFuncs[name]) else eF.workFuncs[name]={} end
    setmetatable(eF.workFuncs[name],{__index=metaFunction})
end
fu.resetWorkFuncs=resetWorkFuncs

function eF:update_element_meta(name)
    if not name then
        for k,_ in pairs(self.para.elements) do self:update_element_meta(k) end
        return
    elseif not self.para.elements[name] then return end
    local para=self.para.elements[name]
    
  resetTaskList(name)
  resetWorkFuncs(name)
  local taskFuncs=eF.taskFuncs
  local tasks=self.tasks[name]
  local work=self.workFuncs[name]
      
  --NOTE: ORDER MATTERS! first find the aura THEN CD etc
  if para.type=="icon" then
    --tasks.onAura[#tasks.onAura+1]=taskFuncs.frameDisable
    
    if para.trackType=="Buffs" then
      tasks.onAura[#tasks.onAura+1]=taskFuncs.applyBuffAdopt
      
      if para.adoptFunc=="Name" then
        work.auraAdopt=taskFuncs.iconAdoptAuraByName
      elseif para.adoptFunc=="Spell ID" then
        work.auraAdopt=taskFuncs.iconAdoptAuraBySpellID
      end  
    end --end of if para.trackType=="Buffs" then
    
    if para.trackType=="Debuffs" then
      tasks.onAura[#tasks.onAura+1]=taskFuncs.applyAuraAdopt
      
      if para.adoptFunc=="Name" then
        work.auraAdopt=taskFuncs.iconAdoptAuraByName
      elseif para.adoptFunc=="Spell ID" then
        work.auraAdopt=taskFuncs.iconAdoptAuraBySpellID
      end
    end --end of if para.trackType=="Debuffs" then
    
    if para.hasTexture and para.smartIcon then
      tasks.onAura[#tasks.onAura+1]=taskFuncs.iconApplySmartIcon
    end
    
    if para.cdWheel then
      tasks.onAura[#tasks.onAura+1]=taskFuncs.iconUpdateCDWheel
    end
    
    if para.hasText then
      if para.textType=="Time left" then tasks.onUpdate[#tasks.onUpdate+1]=taskFuncs.iconUpdateTextTypeT end
      if para.textType=="Stacks" then tasks.onAura[#tasks.onAura+1]=taskFuncs.iconUpdateTextTypeS end
    end
    
    if para.hasText2 then
      if para.text2Type=="Time left" then tasks.onUpdate[#tasks.onUpdate+1]=taskFuncs.iconUpdateText2TypeT end
      if para.text2Type=="Stacks" then tasks.onAura[#tasks.onAura+1]=taskFuncs.iconUpdateText2TypeS end
    end
    
  
    
  end --end of if para.type=="icon" then
  
  --TBA bar handling
  if para.type=="bar" then
    if para.trackType=="power" then
      tasks.onPower[#tasks.onPower+1]=taskFuncs.statusBarPowerUpdate
      tasks.onLoad[#tasks.onLoad+1]=taskFuncs.statusBarPowerUpdate
    elseif para.trackType=="heal absorb" then
      tasks.onPower[#tasks.onPower+1]=taskFuncs.statusBarHAbsorbUpdate    
      tasks.onLoad[#tasks.onLoad+1]=taskFuncs.statusBarHAbsorbUpdate    
    end 
  end
  
  --TBA bar handling
  if para.type=="border" then
    
    tasks.onAura[#tasks.onAura+1]=taskFuncs.frameDisable
    
    if para.trackType=="Buffs" then
      tasks.onBuff[#tasks.onBuff+1]=taskFuncs.applyAuraAdopt
      
      if para.adoptFunc=="Name" then
        work.auraAdopt=taskFuncs.iconAdoptAuraByName
      elseif para.adoptFunc=="Spell ID" then
        work.auraAdopt=taskFuncs.iconAdoptAuraBySpellID
      end  
    end --end of if para.trackType=="Buffs" then
    
    if para.trackType=="Debuffs" then
      tasks.onDebuff[#tasks.onDebuff+1]=taskFuncs.applyAuraAdopt
      
      if para.adoptFunc=="Name" then
        work.auraAdopt=taskFuncs.iconAdoptAuraByName
      elseif para.adoptFunc=="Spell ID" then
        work.auraAdopt=taskFuncs.iconAdoptAuraBySpellID
      end
    end --end of if para.trackType=="Debuffs" then
    
  end 

end







