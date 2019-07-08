local eF=elFramo
local elements=elFramo.optionsTable.args.elements
local args=elements.args
eF.optionsTable.currently_selected_element_key=nil
local tContains=tContains
local deepcopy=eF.table_deep_copy
local wipe=table.wipe
eF.interface_element_defaults={}


local deepcopy=eF.table_deep_copy(orig)
function eF:interface_create_new_element(typ,name,duplicate)
    if not name then return end
    local para=eF.para.elements
    local name=eF.find_valid_name_in_table(name,para)
    if duplicate and para[duplicate] then
        para[name]=deepcopy(para[duplicate])
    else
        if not typ then return end
        para[name]=deepcopy(eF.interface_element_defaults[typ])
    end
    eF:refresh_element(name)
end


function eF:interface_remove_element_by_name(name)
    if not (name and eF.para.elements[name]) then return end
    
    wipe(eF.tasks[name])
    eF.tasks[name]=nil
    wipe(eF.workFuncs[name])
    eF.workFuncs[name]=nil
    wipe(eF.para.elements[name])
    eF.para.elements[name]=nil
    eF.refresh_element()
end


--add buttons
do
    local last_opened=0
    args["invisible"]={
        type="description",
        order=-1,
        name="invisible",
        hidden=function()
            local t=GetTime()
            if t>last_opened then
                print("IN HERE")
                eF.interface_generate_element_groups()
                last_opened=t
                eF:reload_elements_options_frame()
            end
            return true
        end,
        --thanks to rivers for the suggestion
    }

    args["help_message"]={
        type="description",
        fontSize="small",
        order=1,
        name="|cFFFFF569Note|r: TBA Mierihn is very gay."
    }
     
end

local pairs=pairs
function eF.interface_generate_element_groups()
    local elements=elFramo.optionsTable.args.elements
    local args=elements.args
    local para=eF.para.elements
    local order_max=0
    for k,v in pairs(para) do
        args[k]=args[k] or {}
        local a=args[k]
        a.name=k
        a.type="group"
        a.childGroups="tab"
        local order=para[k].interface_order or nil
        if order then a.order=order; if order>order_max then order_max=order+1 end
        else a.order=order_max; order_max=order_max+1 end
        a.args=eF.interface_elements_config_tables[para[k].type] or {}
    end  
end
eF.interface_elements_config_tables={}
--add layout options main frames
do

 
end