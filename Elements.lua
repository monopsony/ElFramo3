local eF=elFramo

eF.familyUtils={}
eF.tasks={}
eF.workFuncs={}
local fu=eF.familyUtils
local wipe=table.wipe
local setmetatable=setmetatable
local pairs=pairs
local taskFuncs=eF.taskFuncs
eF.current_elements_version=0
local growAnchorTo={up="TOP",down="BOTTOM",right="RIGHT",left="LEFT"}
local growToAnchor={left="RIGHT",right="LEFT",up="BOTTOM",down="TOP"}

local function metaFunction(t,k)
  --if not k then return nil end
  t[k]={}
  return t[k]
end
setmetatable(eF.tasks,{__index=metaFunction})
setmetatable(eF.workFuncs,{__index=metaFunction})

local frameFunctions={} or eF.frameFunctions
eF.frameFunctions=frameFunctions

local LSM=LibStub:GetLibrary("LibSharedMedia-3.0")
function frameFunctions:apply_element_paras(name)
  if not name then
    for k,_ in pairs(eF.para.elements) do self:apply_element_paras(k) end
    self.current_elements_version=eF.current_elements_version
    return
  elseif not eF.para.elements[name] then return end
  local para=eF.para.elements[name]
  
  if para.type=="group" then return end

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
      el.static=true
      el.expirationTime=0
      el.duration=0
      el:disable()
    else
      el.static=false
      el:disable()
    end --end of if para.trackType=="Static" 
    
    --texture handling
    if not el.texture then el.texture=el:CreateTexture(nil,"BACKGROUND") end
    if para.hasTexture then 
      local r,g,b,a=para.textureR or 1,para.textureG or 1,para.textureB or 1, para.textureA or 1
      el.texture:Show()   
      el.texture:ClearAllPoints()
      el.texture:SetAllPoints()
      
      if para.smartIcon then
        --el.texture:SetColorTexture(r,g,b,a)
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
      local font,extra=(LSM:IsValid("font",para.text2Font) and LSM:Fetch("font",para.text2Font)) or "",para.text2extra or "OUTLINE"
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
        local throttle=((para.throttleValue~=-1) and para.throttleValue) or math.min((0.1^math.floor(math.max(para.textDecimals or 0,para.text2Decimals or 0) or 1))*0.2,0.2)
        el.throttle=throttle
        el.elapsed=throttle+1
        el:SetScript("OnUpdate",taskFuncs.frameOnUpdateFunction)
    else
        el:SetScript("OnUpdate",nil)
    end
  
  end --end of if para.type=="icon" then
  
  if para.type=="bar" then
    if not frame.elements[name] then frame.elements[name]=CreateFrame("StatusBar",("%sElement%s"):format(frame:GetName(),name),frame,"TextStatusBar") end --check whether element even exists already
    local el=frame.elements[name] 
    el:SetFrameLevel(frame.hp:GetFrameLevel()+1+(para.displayLevel or 0))
    el.para=para
    el.enable=taskFuncs.frameEnable
    el.disable=taskFuncs.frameDisable
    el.onUpdateFunction=taskFuncs.frameOnUpdateFunction
    el.tasks=eF.tasks[name]
    
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
    if para.flatTexture then 
        local r,g,b,a=para.textureR or 1,para.textureG or 1,para.textureB or 1, para.textureA or 1
        el:SetStatusBarTexture(r,g,b,a)       
    else
    
    end
    el:SetMinMaxValues(0,1)
    
    --static&needed info
    if para.trackType=="Power" then
      el.static=true
      el:disable()
    elseif para.trackType=="Heal absorb" then
      el.static=true
      el:disable()
    else
      el.static=false
      el:disable()
    end
    
    
  end
  
  if para.type=="border" then
    if not frame.elements[name] then frame.elements[name]=CreateFrame("Frame",("%sElement%s"):format(frame:GetName(),name),frame) end --check whether element even exists already
    local el=frame.elements[name] 
    el:SetFrameLevel(frame.hp:GetFrameLevel()+1+(para.displayLevel or 0))
    el.para=para
    el.enable=taskFuncs.frameEnable
    el.disable=taskFuncs.frameDisable
    el.onUpdateFunction=taskFuncs.frameOnUpdateFunction
    el.tasks=eF.tasks[name]
        
    el:ClearAllPoints()
    el:SetPoint("TOPRIGHT",frame,"TOPRIGHT",para.xOS or 0,para.yOS or 0)
    el:SetPoint("BOTTOMLEFT",frame,"BOTTOMLEFT",-(para.xOS or 0),-(para.yOS or 0))
        
        
    if para.flatBorder or (not para.edgeFile) then
        --position and visuals

        --el:SetAllPoints()
        el:SetBackdrop(nil)
        
        local r,g,b,a=para.borderR or 1,para.borderG or 1,para.borderB or 1,para.borderA or 1
        local size=para.borderSize or 2
        for k,v in next,{"RIGHT","TOP","LEFT","BOTTOM"} do
          local loc,p1,p2,w,f11,f12,f21,f22=eF.borderInfo(v)
          if not el[loc] then el[loc]=el:CreateTexture(nil,"OVERLAY") end
          el[loc]:SetColorTexture(r,g,b,a)
          el[loc]:ClearAllPoints()
          el[loc]:SetPoint(p1,el,p1,f11*(size),f12*(size))
          el[loc]:SetPoint(p2,el,p2,f21*(size),f22*(size))
          if w then el[loc]:SetWidth(size);
          else el[loc]:SetHeight(size); end  
        end    
        
    else
        local r,g,b,a=para.borderR or 1,para.borderG or 1,para.borderB or 1,para.borderA or 1
        local edgeFile=(LSM:IsValid("border",para.edgeFile) and LSM:Fetch("border",para.edgeFile)) or ""
        el:SetBackdrop({edgeFile=edgeFile,edgeSize=para.borderSize})
        el:SetBackdropBorderColor(r,g,b,a)
        
        for k,v in next,{"RIGHT","TOP","LEFT","BOTTOM"} do
          local loc,p1,p2,w,f11,f12,f21,f22=eF.borderInfo(v)
          if el[loc] then 
              el[loc]:SetColorTexture(0,0,0,0)
          end
        end    
    end
    
    --static handling
    if para.trackType=="Static" then  
      el:disable()
      el.static=true
      el.expirationTime=0
      el.duration=0
    else
      el.static=false
      el:disable()
    end --end of if para.trackType=="Static" 
    
  end
  
  if para.type=="list" then 
    if not frame.elements[name] then frame.elements[name]=CreateFrame("Frame",("%sElement%s"):format(frame:GetName(),name),frame) end
    local list=frame.elements[name]
    list:SetAllPoints()
    list.para=para
    list.isListElement=true
    list.active=0
    list.enable=taskFuncs.frameEnable
    list.disable=taskFuncs.frameDisable
    list.tasks=eF.tasks[name]
    local N=para.count
    list.count=N

    --list elements creation
    for i=1,N do 
        if not list[i] then list[i]=CreateFrame("Frame",("%sList%sElement%s"):format(frame:GetName(),name,tostring(i)),list) end
        local el=list[i]
        
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
        if i==1 then  el:SetPoint(para.anchor,frame,para.anchorTo,para.xPos,para.yPos)            
        else
            local a1,a2=growToAnchor[para.grow],growAnchorTo[para.grow]
            local xOS=(para.grow=="right" and para.spacing) or (para.grow=="left" and -para.spacing) or 0
            local yOS=(para.grow=="up" and para.spacing) or (para.grow=="down" and -para.spacing) or 0
            el:SetPoint(a1,list[i-1],a2,xOS,yOS) 
        end

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
          local font,extra=(LSM:IsValid("font",para.text2Font) and LSM:Fetch("font",para.text2Font)) or "",para.text2extra or "OUTLINE"
          local size,xOS,yOS=para.text2Size or 20,para.text2XOS or 0, para.text2YOS or 0
          local r,g,b,a=para.text2R or 1,para.text2G or 1,para.text2B or 1, para.text2A or 1
          el.text2:SetFont(font,size,extra)
          el.text2:ClearAllPoints()
          el.text2:SetPoint(para.text2Anchor,el,para.text2AnchorTo,xOS,yOS)
          el.text2:SetTextColor(r,g,b,a)
        else
          el.text2:Hide()
        end
    end 
    
    --hide elements if perhaps coutn was lowered
    for i=N+1,#list do 
        list[i]:disable()
    end

    if #list.tasks.onUpdate>0 then
        local throttle=((para.throttleValue~=-1) and para.throttleValue) or math.min((0.1^math.floor(math.max(para.textDecimals or 0,para.text2Decimals or 0) or 1))*0.2,0.2)
        list.throttle=throttle
        list.elapsed=throttle+1
        list:SetScript("OnUpdate",taskFuncs.frameOnUpdateFunction)
    else
        list:SetScript("OnUpdate",nil)
    end
    list:disable()
  end

  --apply work funcs
  local el=frame.elements[name]
  if not el.load_table then el.load_table={} end
  if el.isListElement then 
      for funcName,func in pairs(eF.workFuncs[name]) do
        el[funcName]=func
        for i=1,el.count do el[i][funcName]=func end      
      end
  else
      for funcName,func in pairs(eF.workFuncs[name]) do
        el[funcName]=func
      end
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

function eF:refresh_element(name)
    eF.current_elements_version=eF.current_elements_version+1
    if name then eF:update_element_meta(name) end
    eF:reload_all_layouts()
end

function eF:update_element_meta(name)
    if not name then
        for k,_ in pairs(self.para.elements) do self:update_element_meta(k) end
        return
    elseif not self.para.elements[name] then return end
    local para=self.para.elements[name]
  if para.type=="group" then return end
  
  resetTaskList(name)
  resetWorkFuncs(name)
  local taskFuncs=eF.taskFuncs
  local tasks=self.tasks[name]
  local work=self.workFuncs[name]
      
  --NOTE: ORDER MATTERS! first find the aura THEN CD etc
  if para.type=="icon" then
    --tasks.onAura[#tasks.onAura+1]=taskFuncs.frameDisable
    local tt=para.trackType
    if tt=="HELPFUL" or tt=="HARMFUL" or tt=="PLAYER HELPFUL" or tt=="PLAYER HARMFUL"  then
      tasks.onAura[#tasks.onAura+1]=taskFuncs.applyAuraAdopt
      
      if para.adoptFunc=="Name" then
        work.auraAdopt=taskFuncs.iconAdoptAuraByName
      elseif para.adoptFunc=="Spell ID" then
        work.auraAdopt=taskFuncs.iconAdoptAuraBySpellID
      end  
    end --end of if para.trackType=="Buffs" then
    

    if para.hasTexture and para.smartIcon then
      tasks.onAura[#tasks.onAura+1]=taskFuncs.iconApplySmartIcon
    end
    
    if para.cdWheel then
      tasks.onAura[#tasks.onAura+1]=taskFuncs.iconUpdateCDWheel
    end
    
    if para.hasText then
      if para.textType=="Time left" then 
        tasks.onUpdate[#tasks.onUpdate+1]=taskFuncs.iconUpdateTextTypeT 
        work.textDecimalFunc=eF.toDecimal[para.textDecimals]
      end
      if para.textType=="Stacks" then tasks.onAura[#tasks.onAura+1]=taskFuncs.iconUpdateTextTypeS end
    end
    
    if para.hasText2 then
      if para.text2Type=="Time left" then 
        tasks.onUpdate[#tasks.onUpdate+1]=taskFuncs.iconUpdateText2TypeT 
        work.text2DecimalFunc=eF.toDecimal[para.text2Decimals]
      end
      if para.text2Type=="Stacks" then tasks.onAura[#tasks.onAura+1]=taskFuncs.iconUpdateText2TypeS end
    end
    
  
    
  end --end of if para.type=="icon" then
  
  if para.type=="bar" then
    if para.trackType=="Power" then
      tasks.onPower[#tasks.onPower+1]=taskFuncs.statusBarPowerUpdate
      tasks.onLoad[#tasks.onLoad+1]=taskFuncs.statusBarPowerUpdate
    elseif para.trackType=="Heal absorb" then
      tasks.onHealAbsorb[#tasks.onHealAbsorb+1]=taskFuncs.statusBarHAbsorbUpdate    
      tasks.onLoad[#tasks.onLoad+1]=taskFuncs.statusBarHAbsorbUpdate    
    end 
  end
  
  if para.type=="border" then
    local tt=para.trackType
    if tt=="HELPFUL" or tt=="HARMFUL" or tt=="PLAYER HELPFUL" or tt=="PLAYER HARMFUL"  then
      tasks.onAura[#tasks.onAura+1]=taskFuncs.applyAuraAdopt
      if para.adoptFunc=="Name" then
        work.auraAdopt=taskFuncs.iconAdoptAuraByName
      elseif para.adoptFunc=="Spell ID" then
        work.auraAdopt=taskFuncs.iconAdoptAuraBySpellID
      end  
    end --end of if para.trackType=="Buffs" then
  end 

  if para.type=="list" then
    --tasks.onAura[#tasks.onAura+1]=taskFuncs.frameDisable
    local tt=para.trackType
    if tt=="HELPFUL" or tt=="HARMFUL" or tt=="PLAYER HELPFUL" or tt=="PLAYER HARMFUL"  then
      tasks.onAura[#tasks.onAura+1]=taskFuncs.applyListAuraAdopt
      
      if para.adoptFunc=="Name Whitelist" then
        work.auraAdopt=taskFuncs.iconAdoptAuraByNameWhitelist
      elseif para.adoptFunc=="Name Blacklist" then
        work.auraAdopt=taskFuncs.iconAdoptAuraByNameBlacklist
      end  
    end --end of if para.trackType=="Buffs" then
    
    
    if para.hasTexture and para.smartIcon then
      tasks.onAura[#tasks.onAura+1]=taskFuncs.iconApplySmartIcon
    end
    
    if para.cdWheel then
      tasks.onAura[#tasks.onAura+1]=taskFuncs.iconUpdateCDWheel
    end
    
    if para.hasText then
      if para.textType=="Time left" then 
        tasks.onUpdate[#tasks.onUpdate+1]=taskFuncs.iconUpdateTextTypeT 
        work.textDecimalFunc=eF.toDecimal[para.textDecimals]
      end
      if para.textType=="Stacks" then tasks.onAura[#tasks.onAura+1]=taskFuncs.iconUpdateTextTypeS end
    end
    
    if para.hasText2 then
      if para.text2Type=="Time left" then 
        tasks.onUpdate[#tasks.onUpdate+1]=taskFuncs.iconUpdateText2TypeT 
        work.text2DecimalFunc=eF.toDecimal[para.text2Decimals]
      end
      if para.text2Type=="Stacks" then tasks.onAura[#tasks.onAura+1]=taskFuncs.iconUpdateText2TypeS end
    end

  end --end of if para.type=="list" then
  
  
end







