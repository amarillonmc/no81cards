if not pcall(function() require("expansions/script/c60002290") end) then require("script/c60002290") end
local cm,m=lanp.U("设置卡","黄昏+黄昏教廷","黄昏教廷神秩·麦尔忒")
dusk[m]={}
function cm.initial_effect(c)
    local e1=lane.FTO(c,c,{m,0},"SP,DES,DE+CAL+DAM,E,O",cm.con,"",cm.tg,cm.op)
    ------------------------
    aux.EnablePendulumAttribute(c)
    local e2=dusk.Pe(c,c)
    local e3=lane.I(c,c,{m,1},"TE+DR+DES,,,P",m+100,",",cm.tg1,cm.op2)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return lanc.Filter(c,"IsLoc+IsFaceup","E") and lang.Get(tp,"E"):GetCount()>=15 and lang.Filter(eg,"IsSeries+IsRea+IsLoc+IsPreviousControler",{"黄昏,BAT/EFF",{"N","Previous"},tp},1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return lanc.Filter(c,"CanSp",{e,0,tp}) and  Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    lanp.U("连锁信息",0,"SP",c,1,tp,"0")
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return false end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.GetFlagEffect(tp,m)==0 then
        local e1=lane.FC(e,tp,"",EVENT_PREDRAW,",,",cm.con1,cm.op1,{RESET_PHASE+PHASE_END,3})
        local e2=lane.F(e,tp,"",EFFECT_CHANGE_BATTLE_DAMAGE,"PTG,,1+0",HALF_DAMAGE,",,,",{RESET_PHASE+PHASE_END,3})
        table.insert(dusk.begin,e1)
        table.insert(dusk[m],c)
        table.insert(dusk[m],e1)
        table.insert(dusk[m],e2)
        lanp.U("标识",tp,m,RESET_PHASE+PHASE_END,0,3)
    end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=dusk[m][1]
    local g=lang.GetFilter(tp,"M","IsSeries+IsFaceup","黄昏教廷")
    if #g~=0 then
        for i=1,#g do
            local tc=lanc.GetNumberCardInGroup(g,i)
            local e1=lane.S(e,tc,"",42,",M,1,,,",{RESET_PHASE+PHASE_END,1})
            if lanc.Filter(c,"(IsLoc/IsLoc)+CanSp",{"G,R",{e,0,tp}}) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
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
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=lang.Get(tp,"HD")
    local c=e:GetHandler()
    if chk==0 then return g:CheckSubGroup(cm.f,2,2,tp) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	lanp.U("连锁信息",0,"DR",0,1,tp,"D")
    lanp.U("连锁信息",0,"TE",g,2,tp,"H+D")
    lanp.U("连锁信息",0,"DES",c,1,tp,"P")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=lang.Get(tp,"HD")
    lanp.U("提示","S",tp,"TD")
    local sg=g:SelectSubGroup(tp,cm.f,true,2,2,tp)
    if #sg==0 then return false end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if lanp.U("效果处理",Duel.SendtoExtraP,sg,{nil,"EFF"})>0 and Duel.Draw(p,d,REASON_EFFECT)>0 then
	    lanp.U("效果处理",Duel.Destroy,c,{"EFF"})
	end
end
function cm.f(g,tp)
    return g:GetClassCount(Card.GetLocation)~=1 and lang.Filter(g,"IsSeries+IsTyp+AbleTo","黄昏教廷,PE,E",2)
end