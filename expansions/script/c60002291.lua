if not pcall(function() require("expansions/script/c60002290") end) then require("script/c60002290") end
local cm,m=lanp.U("设置卡","黄昏+黄昏教廷","黄昏教廷圣女·圣依莉娜")
dusk[m]={}
function cm.initial_effect(c)
    c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(lanc.Filter,"IsSeries+IsTyp+IsNName","黄昏教廷,PE,黄昏教廷圣女·圣依莉娜"),2,2)
	local e1=lane.STO(c,c,{m,0},"TE,SP,DE+DAM+CAL,,,",cm.tg,cm.op)
	local e2=lane.I(c,c,{m,1},",,,M,",cm.con,",",cm.op1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,function(c) return c:IsSummonType(SUMMON_TYPE_PENDULUM) and lanc.IsTyp(c,"PE") end)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return lang.GetFilter(tp,"D","IsSeries+IsTyp+AbleTo","黄昏教廷,PE,E",1) end
    lanp.U("连锁信息",0,"TE",nil,1,tp,"D")
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    lanp.U("提示","S",tp,"TD")
    local g=lang.SelectFilter(tp,"D","IsSeries+IsTyp+AbleTo","黄昏教廷,PE,E")
    if #g==0 then return false end
    if lanp.U("效果处理",Duel.SendtoExtraP,g,{nil,"EFF"})>0 and lang.Get(tp,"E"):GetCount()>15 and Duel.IsPlayerCanDraw(tp,1) and lanp.U("是否",tp,m,1) then
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetFlagEffect(tp,m)==0
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=lane.FC(e,tp,"",EVENT_PREDRAW,",,",cm.con2,cm.op2,{RESET_PHASE+PHASE_END,3})
    local e2=lane.FC(e,tp,",SP,,,",cm.con1,cm.op3,{RESET_PHASE+PHASE_END,3})
    table.insert(dusk.begin,e1)
    table.insert(dusk[m],c)
    table.insert(dusk[m],e1)
    table.insert(dusk[m],e2)
    lanp.U("标识",tp,m,RESET_PHASE+PHASE_END,0,3)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=dusk[m][1]
    if Duel.Recover(tp,2000,REASON_EFFECT)>0 and lanc.Filter(c,"IsLoc+CanSp",{"G/R",{e,0,tp}}) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.SpecialSummon(c,e,0,tp,false,false,POS_FACEUP)
    end
    for i=1,#dusk[m] do
        if aux.GetValueType(dusk[m][i])=="Effect" then 
            dusk[m][i]:Reset() 
            dusk[m][i]=0
        end
    end
    for i=1,#dusk[m] do
        table.remove(dusk[m])
    end
    Duel.ResetFlagEffect(tp,m)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
    return lang.Filter(eg,"IsSummonPlayer",tp,1)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Recover(tp,200,REASON_EFFECT)
end