local eF = elFramo
local gui = LibStub("AceGUI-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local bool = true

elFramo.optionsTable = {
    type = "group",
    childGroups = "tab",
    args = {
        layouts = {name = "Layouts", type = "group", args = {}},
        profiles = {name = "Profiles", type = "group", args = {}},
        elements = {name = "Elements", type = "group", args = {}}
    }
}

local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local pairs, ipairs = pairs, ipairs

-- Callback function for OnGroupSelected
local last_selected_tab = "layouts"
local function SelectGroup(container, event, group)
    container:ReleaseChildren()
    last_selected_tab = group
    if group == "elements" then
        AceConfigDialog:Open("elFramo_" .. group, container) -- I dont remember why but it's needed (except for the first time it's clicked)
    end
    AceConfigDialog:Open("elFramo_" .. group, container)
    container:SetTitle("")
end

eF.interface_main_frame = AceGUI:Create("Frame")
local frame = eF.interface_main_frame
frame:SetTitle("elFramo")
frame:SetLayout("Fill")
frame:SetWidth(1000)
frame:SetHeight(650)
frame:Hide()

-- Tabs
eF.interface_tab_group = AceGUI:Create("TabGroup")
local tabs = eF.interface_tab_group
tabs:SetLayout("Flow")
tabs:SetTabs(
    {
        {text = "Layouts", value = "layouts"},
        {text = "Elements", value = "elements"},
        {text = "Profiles", value = "profiles"}
    }
)
tabs:SetCallback("OnGroupSelected", SelectGroup)
frame:AddChild(tabs)

for k, v in pairs(eF.optionsTable.args) do
    AceConfig:RegisterOptionsTable("elFramo_" .. k, v)
end
tabs:SelectTab("layouts")
function eF:interface_select_tab(s)
    eF.interface_tab_group:SelectTab(s)
end

frame:SetCallback(
    "OnShow",
    function(...)
        tabs:SelectTab(last_selected_tab or "layouts")
        eF.interface_main_frame:onShow()
    end
)
frame:SetCallback(
    "OnClose",
    function(...)
        eF.interface_main_frame:onClose()
    end
)

frame.element_tests = {}

-- AChat command /ef3
local initialised = false
function eF:open_options_frame()
    -- if not initialised then eF.interface_generate_element_groups(); initialised=true end
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end
eF:RegisterChatCommand("ef3", eF.open_options_frame)

eF.interface_onUpdate_frame =
    CreateFrame("Frame", "ElFramoInterfaceOnUpdateFrame", UIParent)
local ouf = eF.interface_onUpdate_frame
ouf.throttle = 3
ouf.time_since = 10

function eF.interface_main_frame:onClose()
    ouf:SetScript("OnUpdate", nil)
    if not (next(self.element_tests) == nil) then
        eF:refresh_visible_unit_frames()
    end -- check if table is not empty
    wipe(self.element_tests)
end

function eF.interface_main_frame:onShow()
    ouf:SetScript("OnUpdate", ouf.onUpdate)
    ouf.time_since = 0
end

function ouf:onUpdate(elapsed)
    local t = GetTime()
    self.time_since = self.time_since + elapsed
    if self.time_since < self.throttle then
        return
    end
    self.time_since = 0

    for k, v in pairs(eF.interface_main_frame.element_tests) do
        if v then
            eF:test_element_by_key(k)
        end
    end
end

function eF:test_element_by_key(key)
    for i, f in ipairs(eF.visible_unit_frames) do
        self:test_element_by_ref(f.elements[key])
    end
end

-- RANDOM AURAS
local random_aura_names = {
    "Rejuvenation",
    "Atonement",
    "Big dumb",
    "Shadow Word: Pain",
    "Riptide"
}
local random_aura_spellID = {1123, 34536, 47567}
local random_aura_icons = {458720, 134206, 136081, 135940, 252995, 136207}
local random_aura_count = {nil, 0, 1, 2, 5, 10}
local random_aura_debufftype = {"Magic", nil, "Curse", "Poison", nil, "Disease"}
local function make_random_aura()
    local aI = {}
    aI.new_aura = true
    aI.name = random_aura_names[math.random(#random_aura_names)]
    aI.icon = random_aura_icons[math.random(#random_aura_icons)]
    aI.count = random_aura_count[math.random(#random_aura_count)]
    aI.debuffType = random_aura_debufftype[math.random(#random_aura_debufftype)]
    aI.duration = 3 + math.random(15)
    aI.expirationTime = GetTime() + aI.duration
    aI.unitCaster = "player"
    aI.canSteal = false
    aI.spellID = random_aura_spellID[math.random(#random_aura_spellID)]
    aI.isBoss = true
    aI.isPermanent = aI.expirationTime == 0
    return aI
end

local function make_random_rc_aura_info()
    local aI = {}
    aI.new_aura = true
    local rand = math.random(3) - 1
    aI.name = ""
    aI.icon = eF.rc_status_to_icon[rand]
    aI.count = rand
    aI.debuffType = nil
    aI.duration = 10
    aI.expirationTime = GetTime() + 10
    aI.unitCaster = "player"
    aI.canSteal = false
    aI.spellID = 0
    aI.isBoss = true
    aI.isPermanent = aI.expirationTime == 0
    return aI
end

function eF:test_element_by_ref(ele)
    local para = ele.para

    -- icon
    if para.type == "icon" then
        -- aura
        local tt = para.trackType
        if
            (tt == "PLAYER HELPFUL") or (tt == "PLAYER HARMFUL") or
                (tt == "HELPFUL") or
                (tt == "HARMFUL")
         then
            ele.auraInfo = make_random_aura()
            if not ele.filled then
                ele:enable()
            end
            for i, v in ipairs(ele.tasks.onAura) do
                if i > 1 then
                    v(ele, ele.id or "player")
                end
            end -- i>1 to avoid searching for auras again
            for i, v in ipairs(ele.tasks.postAura) do
                v(ele, ele.id or "player")
            end
        end -- end of aura

        -- MSG
        if (tt == "CHAT_MSG") then
            ele.auraInfo = make_random_aura()
            if not ele.filled then
                ele:enable()
            end
            for i, v in ipairs(ele.tasks.onMsg) do
                if i > 1 then
                    v(ele, ele.id or "player")
                end
            end
        end -- MSG

        -- RC
        if (tt == "READY_CHECK") then
            ele.auraInfo = make_random_rc_aura_info()
            if not ele.filled then
                ele:enable()
            end
            for i, v in ipairs(ele.tasks.onRC) do
                if i > 1 then
                    v(ele, ele.id or "player")
                end
            end
        end -- RC
    end

    -- border
    if para.type == "border" then
        -- aura
        local tt = para.trackType
        if
            (tt == "PLAYER HELPFUL") or (tt == "PLAYER HARMFUL") or
                (tt == "HELPFUL") or
                (tt == "HARMFUL")
         then
            ele.auraInfo = make_random_aura()
            if not ele.filled then
                ele:enable()
            end
            for i, v in ipairs(ele.tasks.onAura) do
                if i > 1 then
                    v(ele, ele.id or "player")
                end
            end -- i>1 to avoid searching for auras again
            for i, v in ipairs(ele.tasks.postAura) do
                v(ele, ele.id or "player")
            end
        end -- end of aura

        -- MSG
        if (tt == "CHAT_MSG") then
            ele.auraInfo = make_random_aura()
            if not ele.filled then
                ele:enable()
            end
            for i, v in ipairs(ele.tasks.onMsg) do
                if i > 1 then
                    v(ele, ele.id or "player")
                end
            end
        end -- MSG

        if (tt == "Threat_any") then
            ele:enable()
            for i, v in ipairs(ele.tasks.onThreat) do
                if i > 1 then
                    v(ele, ele.id or "player")
                end
            end
        end

        -- Static
        if (tt == "Static") then
            ele:enable()
        end
    end

    -- bar
    if para.type == "bar" then
        ele:enable()
        ele:SetValue(math.random())
    end

    -- list
    if para.type == "list" then
        -- aura
        local tt = para.trackType
        if
            (tt == "PLAYER HELPFUL") or (tt == "PLAYER HARMFUL") or
                (tt == "HELPFUL") or
                (tt == "HARMFUL")
         then
            local n = ele.para.count
            for i = 1, n do
                ele[i].auraInfo = make_random_aura()
                if not ele[i].filled then
                    ele[i]:enable()
                end
            end
            if not ele.filled then
                ele:enable()
            end
            ele.active = n
            for i, v in ipairs(ele.tasks.onAura) do
                if i > 1 then
                    v(ele, ele.id or "player")
                end
            end -- i>1 to avoid searching for auras again
            for i, v in ipairs(ele.tasks.postAura) do
                v(ele, ele.id or "player")
            end
        end -- end of aura

        -- MSG
        if (tt == "Casts") then
            local n = ele.para.count
            for i = 1, n do
                ele[i].auraInfo = make_random_aura()
                if not ele[i].filled then
                    ele[i]:enable()
                end
            end
            if not ele.filled then
                ele:enable()
            end
            ele.active = n
            for i, v in ipairs(ele.tasks.onCast) do
                if i > 1 then
                    v(ele, ele.id or "player")
                end
            end -- i>1 to avoid searching for Casts again
            for i, v in ipairs(ele.tasks.postCast) do
                v(ele, ele.id or "player")
            end
        end -- MSG
    end
end

function eF:interface_set_selected_group(tab, ...)
    -- if (not tbl) or not (type(tbl)=="table") then return end
    AceConfigDialog:SelectGroup("elFramo_" .. tab, ...)
end
