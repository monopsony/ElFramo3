local eF=elFramo
eF.info={}

local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

eF.onUpdateFrame=CreateFrame("Frame","ElFramoOnUpdateFrame",UIParent)
local eT,throttle=0,0.1
local pairs=pairs
function eF.onUpdateFrame:onUpdateFunction(elapsed)
  if eT<throttle then eT=eT+elapsed; return end
  eT=0
  for unit,frame in pairs(eF.activeFrames) do
    frame:checkOOR()
  end
end
eF.onUpdateFrame:SetScript("OnUpdate",eF.onUpdateFrame.onUpdateFunction)


--------------UNIT_EVENTS--------------

eF.counter=0
eF.unitEventHandler=CreateFrame("Frame","ElFramoOnUnitEventFrame",UIParent)

for _,v in pairs(eF.unitEvents) do eF.unitEventHandler:RegisterEvent(v) end
function eF.unitEventHandler:handleEvent(event,unit)
  --if true then return end  --TBA REMOVE, BENCHMARKING
  local frame=eF.activeFrames[unit]
  if not frame then return end
  local unit=frame.id
  if not unit then return end
  
  if event=="UNIT_MAXHEALTH" or event=="UNIT_HEALTH_FREQUENT" then
    frame:updateHealth()
    --it's not health ... https://i.imgur.com/KkGBLji.png
  elseif event=="UNIT_AURA" then
    --if true then return end --TBA: remove once bmark done
    --LOOK INTO UNIT_AURA! https://i.imgur.com/r8JNKlh.png
    --eF.counter=eF.counter+1

    --------ONAURA
    local tasks=frame.tasks
    local c=tasks.onAura
    for j=1,#c do
      local v=c[j]
      --eF.counter=eF.counter+1 --TBA  ------THOSE COUNTERS ARE HIGHER FOR EF2, MIGHT HAVE TOO MANY THINGS LOADED
      v[1](v[2])
    end 
    --------BUFFS
    --https://i.imgur.com/ELddpwS.png not the "HELPFUL" thing
    for i=1,40 do
      local name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,_,spellId,_,isBoss=UnitAura(unit,i,"HELPFUL")
      if not name then break end       
      local c=tasks.onBuff
      for j=1,#c do
        local v=c[j]
        --eF.counter=eF.counter+1 --TBA
        v[1](v[2],name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss)
      end   
    end
    --------DEBUFFS
    for i=1,40 do
      local name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,_,spellId,_,isBoss=UnitAura(unit,i,"HARMFUL")
      if not name then break end 
      local c=tasks.onDebuff
      for j=1,#c do
        local v=c[j]
        --eF.counter=eF.counter+1 --TBA
        v[1](v[2],name,icon,count,debuffType,duration,expirationTime,unitCaster,canSteal,spellId,isBoss)
      end 
    end 
    --------POST AURA
    local c=tasks.postAura
    for j=1,#c do
      local v=c[j]
      --eF.counter=eF.counter+1 --TBA
      v[1](v[2])
    end
  
  elseif event=="UNIT_POWER_UPDATE" then
    --if true then return end
    --NOT THAT EITHER https://i.imgur.com/rNn6AjI.png
    
    --------ONPOWER
    local tasks=frame.tasks
    local c=tasks.onPower
    for j=1,#c do
      local v=c[j]
      v[1](v[2])
    end 
    
  elseif event=="UNIT_CONNETION" or event=="UNIT_NAME_UPDATE" then
    frame:updateName()
  elseif event=="UNIT_FLAGS" then 
    frame:updateFlags()
  elseif event=="UNIT_HEAL_ABSORB_AMOUNT_CHANGED" then
  

  end
  
  
  
end
eF.unitEventHandler:SetScript("OnEvent",eF.unitEventHandler.handleEvent)


--------------GROUP_ROSTER_UPDATE--------------

if not eF.layoutEventHandler then eF.layoutEventHandler=CreateFrame("Frame","ElFramoOnRosterUpdateFrame",UIParent) end
eF.layoutEventHandler:RegisterEvent("GROUP_ROSTER_UPDATE")
function eF.layoutEventHandler:handleEvent(event,...)

  --check player role
  local check_visibility_flag=false 
  local spec=GetSpecialization()
  local role=select(5,GetSpecializationInfo(spec))
  --print("yo")
  --print(print(select(5,GetSpecializationInfo(GetSpecialization()))))
  if eF.info.playerRole~=role then check_visibility_flag=true; eF.info.playerRole=role end

  --check roles and classes
  for unit,frame in pairs(eF.activeFrames) do
    local role=UnitGroupRolesAssigned(unit)
    --local class,CLASS=UnitClass(unit)
    if role~=frame.role then frame.role=role; frame:loadAllElements() end
    --if class~=frame.class then frame.class=class; frame.CLASS=CLASS; end
  end

  --check raid or not
  local raid=IsInRaid()
  if eF.raid~=raid then check_visibility_flag=true ; eF.raid=raid; end 
  
  --check group at all
  local grouped=IsInGroup()
  if eF.grouped~=grouped then 
    eF.grouped=grouped; 
    check_visibility_flag=true 
    if not grouped then eF.onUpdateFrame:SetScript("OnUpdate",nil) --when alone, you're not in range of yourself??
    else eF.onUpdateFrame:SetScript("OnUpdate",eF.onUpdateFrame.onUpdateFunction) end     
  end
  
  if check_visibility_flag then eF:check_registered_layouts_visibility() end
  
  for _,v in pairs(eF.registered_layouts) do v:updateFilters() end
  
end
eF.layoutEventHandler:SetScript("OnEvent",eF.layoutEventHandler.handleEvent)


--------------PLAYER_ENTERING_WORLD--------------


if false then
if not eF.initFrame then eF.initFrame=CreateFrame("Frame","ElFramoOnInitFrame",UIParent) end
eF.initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
function eF.initFrame:handleEvent(event)

  eF.doneLoading=true
  eF.current_layout_version=1
  eF.current_family_version=1

  --LOAD DB
  update_WTF()
  
  --load player class
  eF.info.playerClass=UnitClass("player")
  
  --load player role
  local spec=GetSpecialization()
  local role=select(5,GetSpecializationInfo(spec))
  eF.info.playerRole=role
  
  --load instance
  local instanceName,_,_,_,_,_,_,instanceID=GetInstanceInfo()
  eF.info.instanceName=instanceName
  eF.info.instanceID=instanceID
  
  --toad: REMOVE COMMENTS, FIX
  eF:applyLayoutParas()
  --eF:updateActiveLayout()
  --eF:setHeaderPositions()
  
  --ALL INITS
  eF.familyUtils.updateAllMetas()
  for k,v in pairs(eF.activeFrames) do
    eF.familyUtils.applyAllElements(v)
    v:loadAllElements()
  end  
  --eF.intSetInitValues() --toad init values interface
  
  self:UnregisterEvent("PLAYER_ENTERING_WORLD")
  eF.loadingFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
end
eF.initFrame:SetScript("OnEvent",eF.initFrame.handleEvent)
end --TOAD IF FALSE 
--------------ENCOUNTER_START--------------

if not eF.loadingFrame then eF.loadingFrame=CreateFrame("Frame","ElFramoLoadingFrame",UIParent) end
eF.loadingFrame:RegisterEvent("ENCOUNTER_START")
eF.loadingFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eF.loadingFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
function eF.loadingFrame:handleEvent(event,ID)
    
  local flag=false --flag controls whether reloading of families is necessary
  if event=="ENCOUNTER_START" then
    eF.info.encounterID=ID
    flag=true
  elseif event=="PLAYER_REGEN_ENABLED" then
    if eF.info.encounterID then flag=true end  --only need to reload if we were in an encounter before
    eF.info.encounterID=nil
  elseif event=="PLAYER_ENTERING_WORLD" then
    local instanceName,_,_,_,_,_,_,instanceID=GetInstanceInfo()
    if (instanceName~=eF.info.instanceName) or (instanceID~=eF.info.instanceID) then
      eF.info.instanceName=instanceName
      eF.info.instanceID=instanceID
      flag=true
    end
  elseif event=="ACTIVE_TALENT_GROUP_CHANGED" then
    local spec=GetSpecialization()
    local role=select(5,GetSpecializationInfo(spec))
    if role~=eF.info.playerRole then 
      eF.info.playerRole=role
      flag=true
    end
  end
  
  if flag then
    for k,v in pairs(eF.activeFrames) do
      v:loadAllElements()
    end  
  end
end
eF.loadingFrame:SetScript("OnEvent",eF.loadingFrame.handleEvent)

