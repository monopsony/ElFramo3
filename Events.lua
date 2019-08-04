local eF=elFramo
eF.info={}
eF.post_combat={}

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
local ipairs=ipairs
function eF.onUpdateFrame:onUpdateFunction(elapsed)
  if eT<throttle then eT=eT+elapsed; return end
  eT=0
  for _,frame in ipairs(eF.visible_unit_frames) do
    frame:checkOOR()
  end
end
--TBA REMOVE
eF.onUpdateFrame:SetScript("OnUpdate",eF.onUpdateFrame.onUpdateFunction)


--------------GROUP_ROSTER_UPDATE--------------

if not eF.layoutEventHandler then eF.layoutEventHandler=CreateFrame("Frame","ElFramoOnRosterUpdateFrame",UIParent) end
eF.layoutEventHandler:RegisterEvent("GROUP_ROSTER_UPDATE")
local ipairs=ipairs
function eF.layoutEventHandler:handleEvent(event,...)
  local all_frames=eF.list_all_active_unit_frames()
  
  --check player role --ACTIVE_TALENT_GROUP_CHANGED should handle that already
  --local check_visibility_flag=false 
  --local spec=GetSpecialization()
  --local role=select(5,GetSpecializationInfo(spec))
  --if eF.info.playerRole~=role then 
  --  check_visibility_flag=true; eF.info.playerRole=role 
  --  for i_,frame in ipairs(all_frames) do 
  --      frame:update_load_tables(2)
  --  end
  --end

  --check roles AND NAME
  for _,frame in ipairs(all_frames) do
    local unit=frame.id
    local role=UnitGroupRolesAssigned(unit)
    local name=UnitName(unit)
    --local class,CLASS=UnitClass(unit)
    if (class~=frame.class) then frame.class=class; frame:update_load_tables(3) end
    if (name~=frame.name) then frame:updateUnit(true) end
    if (role~=frame.role) then frame.role=role; frame:update_load_tables(4) end
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
  
  for _,frame in ipairs(all_frames) do 
    frame:apply_and_reload_loads()
  end
  
  C_Timer.After(0,function() eF.visible_unit_frames=eF.list_all_active_unit_frames() end)
end
eF.layoutEventHandler:SetScript("OnEvent",eF.layoutEventHandler.handleEvent)


--------------MIST: ENCOUNTER/PLAYER_ENTERING_WORLD etc--------------
local post_combat_functions={
    ["updateFilters"]=function()
        for k,v in pairs(eF.registered_layouts) do 
            v:updateFilters()
        end
    end,    
    ["updateFrameSizes"]=function()
        for k,v in pairs(eF.list_all_active_unit_frames()) do 
            if v.flagged_post_combat_size_update then v:updateSize() end
        end
    end,
    ["layoutVisibility"]=function()
        eF:check_registered_layouts_visibility()
    end,
}


if not eF.loadingFrame then eF.loadingFrame=CreateFrame("Frame","ElFramoLoadingFrame",UIParent) end
eF.loadingFrame:RegisterEvent("ENCOUNTER_START")
eF.loadingFrame:RegisterEvent("ENCOUNTER_END")
eF.loadingFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eF.loadingFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eF.loadingFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
function eF.loadingFrame:handleEvent(event,ID)
  local flag=false
  local all_frames=eF.list_all_active_unit_frames()
  if event=="ENCOUNTER_START" then
    if eF.info.counter~=ID then 
        eF.info.encounterID=ID;  
        flag=true
        for _,v in ipairs(all_frames) do 
            v:update_load_tables(6)
        end
     end   
  elseif event=="PLAYER_REGEN_ENABLED" or event=="ENCOUNTER_END" then
    if eF.info.encounterID and not UnitExists("boss1") then 
        eF.info.encounterID=nil
        for _,v in ipairs(all_frames) do 
            v:update_load_tables(6)
        end
        flag=true 
    end  --only need to reload if we were in an encounter before
    
    for k,v in pairs(eF.post_combat) do 
        if v and post_combat_functions[k] then post_combat_functions[k](); eF.post_combat[k]=false end
    end
    
  elseif event=="PLAYER_ENTERING_WORLD" then
    self:handleEvent("ACTIVE_TALENT_GROUP_CHANGED")
    if not eF.elFramo_initialised then eF.info.instanceName=nil; eF.info.instanceID=nil; end
    local instanceName,_,_,_,_,_,_,instanceID=GetInstanceInfo()
    if (instanceName~=eF.info.instanceName) or (instanceID~=eF.info.instanceID) then
      eF.info.instanceName=instanceName
      eF.info.instanceID=instanceID
      for _,v in ipairs(all_frames) do 
          v:update_load_tables(5)
      end
      flag=true
    end
    eF.layoutEventHandler:handleEvent("GROUP_ROSTER_UPDATE")
    
  elseif event=="ACTIVE_TALENT_GROUP_CHANGED" then
    local spec=GetSpecialization()
    local specID,specName,_,_,role=GetSpecializationInfo(spec)
    if eF.info.specName~=specName then 
        eF.info.specName=specName
        eF.info.specID=specID
        eF.isDispellable=eF.isDispellableTable[eF.info.playerClass][specName]
    end
    if role~=eF.info.playerRole then 
      eF.info.playerRole=role
      for _,v in ipairs(all_frames) do 
          v:update_load_tables(2)
      end
      flag=true
    end
  end
  
  if flag then 
    for _,v in ipairs(all_frames) do 
        v:apply_and_reload_loads()
    end
  end
  
end
eF.loadingFrame:SetScript("OnEvent",eF.loadingFrame.handleEvent)

