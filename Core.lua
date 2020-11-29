local defaults = {
    profile = {layouts = {}, elements = {}} -- end of profile
} -- end of defaults
elFramo = LibStub("AceAddon-3.0"):NewAddon("elFramo")

local eF = elFramo
eF.activeFrames = {}
eF.currentUnitsParaVersion = 0
eF.currentFamilyParaVersion = 0

eF.unitEvents = {
    -- "INCOMING_RESURRECT_CHANGED",
    "UNIT_HEALTH", "UNIT_MAXHEALTH", "UNIT_FLAGS", "UNIT_AURA",
    "UNIT_POWER_UPDATE", "UNIT_CONNECTION", "UNIT_HEAL_ABSORB_AMOUNT_CHANGED",
    "INCOMING_RESURRECT_CHANGED", "UNIT_PHASE", "UNIT_NAME_UPDATE",
    "UNIT_THREAT_SITUATION_UPDATE"
}

eF.inRaid = false
eF.grouped = false

local lib_embeds = {
    "AceConsole-3.0", "AceComm-3.0", "AceEvent-3.0", "AceSerializer-3.0"
}
for i, v in ipairs(lib_embeds) do LibStub(v):Embed(eF) end

local function version_update(tbl, version)

    if not version then
        if tbl.layouts then
            for k, v in pairs(tbl.layouts) do
                v.parameters.oorFadeOut = true
                v.parameters.oorDarken = false
                v.parameters.oorADarken = 0.3
            end
        end
        version = 2
    end

end

local current_version = 2
local function update_WTF()

    local para = elFramoDB or nil

    -- oor update
    for k, v in pairs(para.profiles) do version_update(v, para.version) end

    para.version = current_version
end

local wipe = table.wipe
local doIn = C_Timer.NewTimer
function elFramo:OnInitialize()

    self.db = LibStub("AceDB-3.0"):New("elFramoDB", defaults, true) -- true sets the default profile to a profile called "Default"
    -- see https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0
    self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")

    -- PROFILE CHECKING HERE

    eF.para = self.db.profile

    eF.doneLoading = true
    eF.current_layout_version = 1
    eF.current_family_version = 1

    -- LOAD DB
    update_WTF()

    -- load player info
    eF.info.playerClass = UnitClass("player")
    eF.info.playerName = UnitName("player")
    eF.info.playerRealm = GetRealmName()

    -- load player role  --doesnt work at the very start for some reason?
    -- local spec=GetSpecialization()
    -- local role=select(5,GetSpecializationInfo(spec))
    -- eF.info.playerRole=role
    local eF = eF
    doIn(1, function()
        eF.layoutEventHandler:handleEvent("GROUP_ROSTER_UPDATE")
    end)

    -- load instance
    local instanceName, _, _, _, _, _, _, instanceID = GetInstanceInfo()
    eF.info.instanceName = instanceName
    eF.info.instanceID = instanceID

    -- load group stuff
    -- eF.layoutEventHandler:handleEvent("GROUP_ROSTER_UPDATE") --(doing it above anyways)

    -- element metas
    eF:update_element_meta()

    -- load layouts and frames
    eF:register_all_headers_inits()
    eF:applyLayoutParas()

    eF.elFramo_initialised = true
    eF.loadingFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

end

function elFramo:RefreshConfig() ReloadUI() end

function elFramo:OnEnable() end
