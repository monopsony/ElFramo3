local eF = elFramo
-- eF.info={}
eF.post_combat = {}
eF.recorded_casts_start = {}
eF.recorded_casts_end = {}

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

eF.onUpdateFrame = CreateFrame("Frame", "ElFramoOnUpdateFrame", UIParent)
local eT, throttle = 0, 0.1
local pairs, ipars, wipe = pairs, ipairs, table.wipe
function eF.onUpdateFrame:onUpdateFunction(elapsed)
    if eT < throttle then
        eT = eT + elapsed;
        return
    end
    eT = 0
    for _, frame in ipairs(eF.visible_unit_frames) do frame:checkOOR() end
end
eF.onUpdateFrame:SetScript("OnUpdate", eF.onUpdateFrame.onUpdateFunction)

--------------GROUP_ROSTER_UPDATE--------------
if not eF.layoutEventHandler then
    eF.layoutEventHandler = CreateFrame("Frame", "ElFramoOnRosterUpdateFrame",
                                        UIParent)
end
eF.layoutEventHandler:RegisterEvent("GROUP_ROSTER_UPDATE")
local ipairs = ipairs
function eF.layoutEventHandler:handleEvent(event, ...)
    local all_frames = eF.list_all_active_unit_frames()

    -- check player role --ACTIVE_TALENT_GROUP_CHANGED should handle that already
    -- local check_visibility_flag=false 
    -- local spec=GetSpecialization()
    -- local role=select(5,GetSpecializationInfo(spec))
    -- if eF.info.playerRole~=role then 
    --  check_visibility_flag=true; eF.info.playerRole=role 
    --  for i_,frame in ipairs(all_frames) do 
    --      frame:update_load_tables(2)
    --  end
    -- end

    -- check roles AND NAME
    for _, frame in ipairs(all_frames) do
        local unit = frame.id
        local role = UnitGroupRolesAssigned(unit)
        local name = UnitName(unit)
        local class, CLASS = UnitClass(unit)
        frame.playerFrame = UnitIsUnit(unit, "player")
        if (class ~= frame.class) then
            frame.class = class;
            frame:update_load_tables(3)
        end
        if (name ~= frame.name) then frame:updateUnit(true) end
        if (role ~= frame.role) then
            frame.role = role;
            frame:update_load_tables(4)
        end
    end

    -- check raid or not
    local raid = IsInRaid()
    if eF.raid ~= raid then
        check_visibility_flag = true;
        eF.raid = raid;
    end

    -- check group at all
    local grouped = IsInGroup()
    if eF.grouped ~= grouped then
        eF.grouped = grouped;
        local check_visibility_flag = true
        if not grouped then
            eF.onUpdateFrame:SetScript("OnUpdate", nil) -- when alone, you're not in range of yourself??
        else
            eF.onUpdateFrame:SetScript("OnUpdate",
                                       eF.onUpdateFrame.onUpdateFunction)
        end
    end

    if check_visibility_flag then eF:check_registered_layouts_visibility() end

    for _, v in pairs(eF.registered_layouts) do v:updateFilters() end

    for _, frame in ipairs(all_frames) do frame:apply_and_reload_loads() end

    C_Timer.After(0, function()
        eF.visible_unit_frames = eF.list_all_active_unit_frames()
    end)
end
eF.layoutEventHandler:SetScript("OnEvent", eF.layoutEventHandler.handleEvent)

--------------MIST: ENCOUNTER/PLAYER_ENTERING_WORLD etc--------------
local post_combat_functions = {
    ["updateFilters"] = function()
        for k, v in pairs(eF.registered_layouts) do v:updateFilters() end
    end,
    ["updateFrameSizes"] = function()
        for k, v in pairs(eF.list_all_active_unit_frames()) do
            if v.flagged_post_combat_size_update then v:updateSize() end
        end
    end,
    ["layoutVisibility"] = function()
        eF:check_registered_layouts_visibility()
    end
}

if not eF.loadingFrame then
    eF.loadingFrame = CreateFrame("Frame", "ElFramoLoadingFrame", UIParent)
end
eF.loadingFrame:RegisterEvent("ENCOUNTER_START")
eF.loadingFrame:RegisterEvent("ENCOUNTER_END")
eF.loadingFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eF.loadingFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eF.loadingFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
function eF.loadingFrame:handleEvent(event, ID)
    local flag = false
    local all_frames = eF.list_all_active_unit_frames()
    if event == "ENCOUNTER_START" then
        if eF.info.counter ~= ID then
            eF.info.encounterID = ID;
            flag = true
            for _, v in ipairs(all_frames) do v:update_load_tables(6) end
        end
    elseif event == "PLAYER_REGEN_ENABLED" or event == "ENCOUNTER_END" then
        if eF.info.encounterID and not UnitExists("boss1") then
            eF.info.encounterID = nil
            for _, v in ipairs(all_frames) do v:update_load_tables(6) end
            flag = true
        end -- only need to reload if we were in an encounter before

        for k, v in pairs(eF.post_combat) do
            if v and post_combat_functions[k] then
                post_combat_functions[k]();
                eF.post_combat[k] = false
            end
        end

        wipe(eF.recorded_casts_start)
        wipe(eF.recorded_casts_end)

    elseif event == "PLAYER_ENTERING_WORLD" then
        self:handleEvent("ACTIVE_TALENT_GROUP_CHANGED")
        if not eF.elFramo_initialised then
            eF.info.instanceName = nil;
            eF.info.instanceID = nil;
        end
        local instanceName, _, _, _, _, _, _, instanceID = GetInstanceInfo()
        instanceID = tostring(instanceID)
        if (instanceName ~= eF.info.instanceName) or
            (instanceID ~= eF.info.instanceID) then
            eF.info.instanceName = instanceName
            eF.info.instanceID = instanceID
            for _, v in ipairs(all_frames) do v:update_load_tables(5) end
            flag = true
        end
        eF.layoutEventHandler:handleEvent("GROUP_ROSTER_UPDATE")

    elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
        local spec = GetSpecialization()
        local specID, specName, _, _, role = GetSpecializationInfo(spec)
        if eF.info.specName ~= specName then
            eF.info.specName = specName
            eF.info.specID = specID
            eF.isDispellable =
                eF.isDispellableTable[eF.info.playerClass][specName]
        end
        if role ~= eF.info.playerRole then
            eF.info.playerRole = role
            for _, v in ipairs(all_frames) do v:update_load_tables(2) end
            flag = true
        end
    end

    if flag then
        for _, v in ipairs(all_frames) do v:apply_and_reload_loads() end
    end

end
eF.loadingFrame:SetScript("OnEvent", eF.loadingFrame.handleEvent)

--------CAST TRACKER-----------
local cast_events = {
    "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_DELAYED",
    "UNIT_SPELLCAST_SUCCEEDED", "UNIT_SPELLCAST_STOP",
    "UNIT_SPELLCAST_INTERRUPTED", "UNIT_SPELLCAST_FAILED",
    "UNIT_SPELLCAST_FAILED_QUIET", "UNIT_TARGET"
}

if not eF.caster_watcher_frame then
    eF.caster_watcher_frame = CreateFrame("Frame", "ElFramoCastWatcher",
                                          UIParent)
end

for i, v in ipairs(cast_events) do eF.caster_watcher_frame:RegisterEvent(v) end

eF.casting_units_casts = {}
eF.casting_units_targets = {}
local casts, targets = eF.casting_units_casts, eF.casting_units_targets

local recorded_casts_end, recorded_casts_start, doAfter = eF.recorded_casts_end,
                                                          eF.recorded_casts_start,
                                                          C_Timer.After
local function remove_cast_timer(castID, sourceGUID, castEnd)
    local castID = castID or "None"
    if recorded_casts_end[castID] then return end

    local dur = (castEnd or (GetTime() + 3)) - GetTime() + .5
    local sourceGUID, castID, casts = sourceGUID, castID, casts
    doAfter(dur, function()
        if (not casts[sourceGUID]) or not (casts[sourceGUID][7] == castID) or
            not (targets[sourceGUID]) or (#targets[sourceGUID] == 0) then
            return
        end
        casts[sourceGUID] = nil
        local affected_frames = targets[sourceGUID]
        for i = 1, #affected_frames do
            affected_frames[i]:unit_event("UNIT_CAST")
        end
    end)

end

local wipe = table.wipe
local UnitExists, UnitIsEnemy, UnitGUID, UnitCastingInfo, UnitIsUnit =
    UnitExists, UnitIsEnemy, UnitGUID, UnitCastingInfo, UnitIsUnit
function eF.caster_watcher_frame:handleEvent(event, sourceUnit, castID)

    if (not UnitExists(sourceUnit)) or (not UnitIsEnemy(sourceUnit, "player")) then
        return
    end
    -- if not UnitExists(sourceUnit) then return end
    local sourceGUID = UnitGUID(sourceUnit)
    if not sourceGUID then return end

    if event == "UNIT_SPELLCAST_START" then
        local spellName, _, icon, castStart, castEnd, _, castID, _, spellID =
            UnitCastingInfo(sourceUnit)
        local duration = 0
        if castStart and castEnd then
            castEnd = castEnd / 1000
            castStart = castStart / 1000
            duration = castEnd - castStart
        end

        -- does this whole thing need recycling... (probably not)
        casts[sourceGUID] = {
            spellName, icon, duration, castEnd, spellID, sourceUnit, castID
        }

        -- find the sourceUnit's target
        local target = sourceUnit .. "target"
        local frames = eF.visible_unit_frames
        local affected_frames = {}
        for i = 1, #frames do
            if UnitIsUnit(target, frames[i].id or "") then
                affected_frames[#affected_frames + 1] = frames[i]
            end
        end

        targets[sourceGUID] = affected_frames

        for i = 1, #affected_frames do
            affected_frames[i]:unit_event("UNIT_CAST")
        end

        remove_cast_timer(castID, sourceGUID, castEnd)

        -- end of "UNIT_SPELLCAST_START"
    elseif event == "UNIT_TARGET" then

        if not casts[sourceGUID] then return end
        local old_affected_frames = targets[sourceGUID]
        self:handleEvent("UNIT_SPELLCAST_START", sourceUnit)

        if not old_affected_frames then return end
        for i = 1, #old_affected_frames do
            old_affected_frames[i]:unit_event("UNIT_CAST")
        end

        -- end of "UNIT_TARGET"
    elseif event == "UNIT_SPELLCAST_STOP" or event ==
        "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_FAILED" or
        event == "UNIT_SPELLCAST_FAILED_QUIET" or event ==
        "UNIT_SPELLCAST_SUCCEEDED" then

        if not casts[sourceGUID] then return end
        if castID ~= casts[sourceGUID][7] then return end

        local old_affected_frames = targets[sourceGUID]
        casts[sourceGUID] = nil

        if castID then recorded_casts_end[castID] = true; end

        if not old_affected_frames then return end
        for i = 1, #old_affected_frames do
            old_affected_frames[i]:unit_event("UNIT_CAST")
        end

    end

end
eF.caster_watcher_frame:SetScript("OnEvent", eF.caster_watcher_frame.handleEvent)

--------MSG TRACKER--------

local chat_events = {
    "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER", "CHAT_MSG_GUILD", "CHAT_MSG_SAY",
    "CHAT_MSG_GUILD", "CHAT_MSG_WHISPER", "CHAT_MSG_YELL"
}
if not eF.chat_watcher_frame then
    eF.chat_watcher_frame = CreateFrame("Frame", "ElFramoChatWatcher", UIParent)
end
for i, v in ipairs(chat_events) do eF.chat_watcher_frame:RegisterEvent(v) end
function eF.chat_watcher_frame:handleEvent(event, msg, author, language)

    local frames = eF.full_name_to_unit_frame[author]
    if #frames < 1 then return end

    if event == "CHAT_MSG_RAID_LEADER" then event = "CHAT_MSG_RAID" end
    for i, v in ipairs(frames) do v:unit_event("CHAT_MSG", msg, event) end

end
eF.chat_watcher_frame:SetScript("OnEvent", eF.chat_watcher_frame.handleEvent)

--------READY CHECK TRACKER--------
local rc_events = {"READY_CHECK", "READY_CHECK_CONFIRM", "READY_CHECK_FINISHED"}
if not eF.rc_watcher_frame then
    eF.rc_watcher_frame = CreateFrame("Frame", "ElFramoReadyCheckWatcher",
                                      UIParent)
end
for i, v in ipairs(rc_events) do eF.rc_watcher_frame:RegisterEvent(v) end
function eF.rc_watcher_frame:handleEvent(event, ...)

    if event == "READY_CHECK" then

        local frames = eF.visible_unit_frames
        if #frames < 1 then return end

        local name, time = ...
        name = eF.name_with_realm(name)
        local lead_frames = eF.full_name_to_unit_frame[name]

        eF.info.rcExpirationTime = GetTime() + time
        for i, v in ipairs(frames) do
            v.rcStatus = 2 -- 0: no, 1: yes, 2: pending
            v:unit_event("READY_CHECK", false, time)
        end

        if lead_frames then
            for i, v in ipairs(lead_frames) do
                v.rcStatus = 1 -- 0: no, 1: yes, 2: pending
                v:unit_event("READY_CHECK", false, time)
            end
        end
    elseif event == "READY_CHECK_CONFIRM" then
        local unit, status = ...
        status = (status and 1) or 0

        local frames = eF.unit_to_frame[unit]
        if #frames < 1 then return end
        for i, v in ipairs(frames) do
            v.rcStatus = status
            v:unit_event("READY_CHECK", false)
        end

    else
        local frames = eF.visible_unit_frames
        if #frames < 1 then return end

        for i, v in ipairs(frames) do
            local status = v.rcStatus
            if (not v.rcStatus) or (v.rcStatus == 2) then
                v.rcStatus = 0
            end
            v:unit_event("READY_CHECK", true)
        end

    end

end
eF.rc_watcher_frame:SetScript("OnEvent", eF.rc_watcher_frame.handleEvent)

