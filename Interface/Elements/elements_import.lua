local eF=elFramo

local gui=LibStub("AceGUI-3.0")

local f=gui:Create("Frame")
f:Hide()
eF.interface_import_export_element=f
f:SetTitle("Import/Export")
f:SetAutoAdjustHeight(false)
f:SetLayout("Fill")


function f:SetText(s,select)
    local s=s or ""
    self.editBox:SetText(eF.encode_for_print(s))
    if select then 
        self.editBox:HighlightText() 
        self.editBox:SetFocus()
    end
end

function f:error(s)
    if not s or type(s)~="string" then return nil end
    f:SetStatusText(("|cFFFF0000%s|r"):format(s))
end

local hook_show=f.Show
function f:Show(...)
    hook_show(f,...)
    f:SetStatusText("")
end

local eb=gui:Create("MultiLineEditBox")
eb:SetLabel(nil)
eb:SetRelativeWidth(1)
eb:SetFullHeight(true)
f:AddChild(eb)
f.editBox=eb

local btn=eb.button
btn:SetText("Import")

eb:SetCallback("OnEnterPressed",function(self,s)
    local s=self:GetText() or s
    s=eF.encode_for_print(s,true)
    local a,success=eF.serialize_and_deflate(s,true)
    if not (success and a and type(a)=="table" and a.type and a.name_key) then eF.interface_import_export_element:error("Unable to import string."); return end
    f:Hide()    
    eF:interface_create_new_element(a.type,a.name_key,a)
end)

function eF.open_import_export_window(mode,key,typ)

    if typ=="element" then
        if not mode and type(mode)=="string" then return end 
        if mode=="export" then 
            if not key and type(key)=="string" then return end
            local para=elFramo.para.elements
            if not para[key] then return end
            para[key].name_key=key
            local s=eF.serialize_and_deflate(para[key],false)
            para[key].name_key=nil
            local f=eF.interface_import_export_element
            f:Show()
            f:SetTitle("Export string")
            f:SetText(s,true)
            f.editBox.button:Hide()
        elseif mode=="import" then
            local para=elFramo.para.elements
            local f=eF.interface_import_export_element
            f:Show()
            f:SetText(nil,true)
            f:SetTitle("Import string")
            f.editBox.button:Show()
        end
    else --end of if typ=="element"
    
    end
end
