if not pcall(function() require("expansions/script/c60002290") end) then require("script/c60002290") end
local cm,m=lanp.U("设置卡","黄昏+黄昏教廷+黄昏骑士","黄昏教廷骑士·赫尔")
dusk[m]={}
function cm.initial_effect(c)
    local e1=lane.QO(c,c,{m,0},"SP,FC,DAM+CAL,H,",dusk.con1,"",cm.tg,cm.op)
    local e2=lane.QO(c,c,{m,0},"SP,FC,DAM+CAL,E",m,dusk.con2,"",cm.tg,cm.op)
    local e3=lane.STO(c,c,{m,1},"SP,FC,DAM+CAL,,,",cm.tg1,cm.op1)
    ------------------------
    aux.EnablePendulumAttribute(c)
    local e4=dusk.Pe(c,c)
    local e5=lane.I(c,c,{m,2},"SP,,,P",m+100,cm.con2,cm.cost,cm.tg,cm.op4)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return lanc:Filter(c,"CanSp",{e,0,tp}) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    lanp.U("连锁信息",0,"SP",c,1,tp,"0")
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return false end
   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=lane.FC(e,tp,"",EVENT_PREDRAW,",,",cm.con,cm.op2,{RESET_PHASE+PHASE_END,3})
    local e2=lane.FC(e,tp,",SP,,,",cm.con1,cm.op3,{RESET_PHASE+PHASE_END,3})
    table.insert(dusk.begin,e1)
    table.insert(dusk[m],c)
    table.insert(dusk[m],e1)
    table.insert(dusk[m],e2)
    lanp.U("标识",tp,m,RESET_PHASE+PHASE_END,0,3)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=dusk[m][1]
    if lang.GetFilter(tp,{"0","N"},"AbleTo","R",1) then
        lanp.U("提示","S",tp,"RM")
        local g=lang.SelectFilter(tp,{"0","N"},"AbleTo","R",tp,2)
        if #g~=0  then
            if lanp.U("效果处理",Duel.Remove,g,{POS_FACEUP,"EFF"})>0 and lanc.Filter(c,"IsLoc+CanSp",{"G/R",{e,0,tp}}) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
                Duel.SpecialSummon(c,e,0,tp,false,false,POS_FACEUP)
            end
        end
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
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
    lanp.U("提示","S",tp,"SEL")
    local tc=lang.Get(tp,{"0","M"}):Select(tp,1,1,nil):GetFirst()
    local e1=lane.S(e,tc,100,"",500,",",RESET_EVENT+RESETS_STANDARD)
    local atk=tc:GetAttack()
    if atk==0 then lanp.U("效果处理",Duel.Destroy,tc,{"EFF"}) end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
    return lang.GetFilter(tp,"M","(IsSeries/IsSeries)+IsFaceup","黄昏教廷教宗·圣弗伦,黄昏教廷圣女·圣依莉娜",1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return lang.GetFilter(tp,"H","IsDiscardable","",1) end
    lanp.U("提示","S",tp,"DC")
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return false end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        local e1=lane.S(c,c,"",EFFECT_LEAVE_FIELD_REDIRECT,"CD,",LOCATION_REMOVED,",,",RESET_EVENT+RESETS_STANDARD)
    end
end