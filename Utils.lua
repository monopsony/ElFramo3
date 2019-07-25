local eF=elFramo
       
eF.partyLoop={"player","party1","party2","party3","party4"}
eF.raidLoop={}
for i=1,40 do
  local s="raid"..tostring(i)
  table.insert(eF.raidLoop,s)
end

eF.positions={"CENTER","RIGHT","TOPRIGHT","TOP","TOPLEFT","LEFT","BOTTOMLEFT","BOTTOM","BOTTOMRIGHT"}
eF.orientations={"up","down","right","left"}
eF.Classes={"Death Knight","Demon Hunter","Druid","Hunter","Mage","Monk","Paladin","Priest","Rogue","Shaman","Warlock","Warrior"}
eF.ROLES={"DAMAGER","HEALER","TANK"}
eF.fonts={"FRIZQT__","ARIALN","skurri","MORPHEUS"}
eF.OOCActions={layoutUpdate=false,groupUpdate=false}
eF.info={}
eF.info.playerClass=UnitClass("player")
eF.characterframes={
                    "Interface\\CHARACTERFRAME\\TemporaryPortrait-Vehicle-Organic",
                    "Interface\\CHARACTERFRAME\\TEMPORARYPORTRAIT-PET",
                    "Interface\\CHARACTERFRAME\\TemporaryPortrait-Monster",
                    "Interface\\CHARACTERFRAME\\TemporaryPortrait",
                    "Interface\\CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-BLOODELF",
                    "Interface\\CHARACTERFRAME\\TempPortrait",
                    "Interface\\CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-DRAENEI",
                    "Interface\\CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-ORC",
                    "Interface\\CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-TROLL",
                    "Interface\\CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-SCOURGE",
                    "Interface\\CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-GNOME",
                    "Interface\\CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-TAUREN",
                    "Interface\\CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-DWARF",
                    }
eF.defaultColors={
  Curse={0.6,0,0.1},
  Disease={0.6,0.4,0},
  Magic={0.2,0.6,1},
  Poison={0,0.6,0},
}
setmetatable(eF.defaultColors,{__index=function(t,k) t[k]={1,1,1} return t[k] end})
local pairs=pairs

function MakeMovable(frame)
  frame:SetMovable(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
end

function eF.borderInfo(pos)
  local loc,p1,p2,w,f11,f12,f21,f22
  if pos=="RIGHT" then loc="borderRight"; p1="TOPRIGHT"; p2="BOTTOMRIGHT"; w=true; f11=1; f12=0; f21=1; f22=0;
  elseif pos=="TOP" then loc="borderTop"; p1="TOPLEFT"; p2="TOPRIGHT"; w=false; f11=-1; f12=1; f21=1; f22=1;
  elseif pos=="LEFT" then loc="borderLeft"; p1="TOPLEFT"; p2="BOTTOMLEFT";w=true; f11=-1; f12=0; f21=-1; f22=0;
  elseif pos=="BOTTOM" then loc="borderBottom"; p1="BOTTOMLEFT";p2="BOTTOMRIGHT"; w=false; f11=-1; f12=-1; f21=1; f22=-1; end  
  
  return loc,p1,p2,w,f11,f12,f21,f22
end

eF.toDecimal={
    [0]=function(n)
        return ("%.0f"):format(n)
    end,
    
    [1]=function(n)
        return ("%.1f"):format(n)
    end,
    
    [2]=function(n)
        return ("%.2f"):format(n)
    end,
    
    [3]=function(n)
        return ("%.3f"):format(n)
    end,
    
    [4]=function(n)
        return ("%.4f"):format(n)
    end,
    
    [5]=function(n)
        return ("%.5f"):format(n)
    end,
}


function eF.table_deep_copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[eF.table_deep_copy(orig_key)] = eF.table_deep_copy(orig_value)
        end
        setmetatable(copy, eF.table_deep_copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local RAID_CLASS_COLORS=RAID_CLASS_COLORS 
function eF.classRGB(CLASS)
  if CLASS then return RAID_CLASS_COLORS[CLASS]:GetRGB()
  else return 0,0,0 end 
end

function eF.isInList(s,lst)
  if not s or not lst then return false end
  local found=false
  local tostring=tostring
  for i=1,#lst do 
      s=tostring(s)
      if lst[i]==s then
        found=true
        break
      end
    --end
  end
  return found
end

local tContains=tContains
local function contained_in_keys_of(tbl,val)
    if tbl[val] then return true else return false end
end


function eF.find_valid_name_in_table(name,tbl)
    local name,i=name,1
    while contained_in_keys_of(tbl,name) and i<200 do
        local n=tonumber(string.sub(name,#name,#name))       
        if n then
            name=string.sub(name,1,#name-1)..tostring(n+1)
        else 
            name=name.."_1"
        end
        i=i+1
    end
    if i>199 then print("YO YOUR NAMES ARE FUCKED UP"); return "FixYourNames" end
    return name
end

local isInList=eF.isInList
local partyLoop=eF.partyLoop
function eF.isParty(unit)
  if not unit then return false end
  if isInList(unit,partyLoop) then return true else return false end
end

function eF.posInList(s,lst)
  if not s or not lst then return nil end
  for i=1,#lst do 
    if type(lst[i])==type(s) then
      if lst[i]==s then
        break
      end
    end
  end
  return i
end

function eF.posInFamilyButtonsList(j,k)
  if (not eF.familyButtonsList) or #eF.familyButtonsList==0 then return false end
  local lst=eF.familyButtonsList
  local bool=false
  local pos=nil
  for i=1,#lst do
    if j==lst[i].familyIndex and k==lst[i].childIndex then bool=true;pos=i; break end
  end
  return (bool and pos) or false
end

function eF.list_all_active_unit_frames(layout)
    local a={}
    
    if (not layout) or (not eF.registered_layouts[layout]) then    
        for _,v in pairs(eF.registered_layouts) do 
        
            if v.by_group then
                for j=1,#v do
                    local v2=v[j]
                    for i=1,#v2 do 
                        if v2[i] and v2[i].id then a[#a+1]=v2[i] end
                    end
                end
            else
                for i=1,#v do 
                    if v[i] and v[i].id then a[#a+1]=v[i] end
                end
            end
            
        end              
    else
        local v=eF.registered_layouts[layout]
        if v.by_group then
            for j=1,#v do
                local v2=v[j]
                for i=1,#v2 do 
                    if v2[i] and v2[i].id then a[#a+1]=v2[i] end
                end
            end
        else
            for i=1,#v do 
                if v[i] and v[i].id then a[#a+1]=v[i] end
            end
        end
    end
    return a
end

function eF.get_key_for_value(t,value)
  for k,v in pairs(t) do
    if v==value then return k end
  end
  return nil
end