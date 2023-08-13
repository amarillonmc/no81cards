if not pcall(function() require("expansions/script/c60002290") end) then require("script/c60002290") end
local cm,m=lanp.U("设置卡","黄昏+黄昏教廷","黄昏教廷教宗·圣弗伦")
dusk[m]={}
function cm.initial_effect(c)
    local e0=lane.F(c,c,{m,0},EFFECT_SPSUMMON_PROC,"OE,H,,,",cm.con4,cm.tg2,cm.op5)
    local e1=lane.FTO(c,c,{m,1},"TH,DES,DE+CAL+DAM,E",m,cm.con,"",cm.tg,cm.op)
    local e2=lane.QO(c,c,{m,2},"NEGE+DES",EVENT_CHAINING,",M",m+100,cm.con1,"",cm.tg1,cm.op1)
    ------------------------
    aux.EnablePendulumAttribute(c)
    local e3=dusk.Pe(c,c)
    local e4=lane.I(c,c,{m,3},"SH+DES,,,P",m+1000,",",cm.tg3,cm.op6)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return lanc.Filter(c,"IsLoc+IsFaceup","E") and lang.Get(tp,"E"):GetCount()>=15 and lang.Filter(eg,"IsRea+IsSummonType+IsLoc+IsPreviousControler",{"BAT/EFF",SUMMON_TYPE_PENDULUM,{"N","Previous"},tp},1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return lanc.Filter(c,"AbleTo","H") end
    lanp.U("连锁信息",0,"SP",c,1,tp,"E")
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return false end
    lanp.U("效果处理",Duel.SendtoHand,c,{nil,"EFF"})
end
function cm.con1(e,tp,eg,ev,ep,re,r,rp)
    local ct=Duel.GetCurrentChain()
	if ct<2 then return end
	local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return te and p==tp and rp==1-tp and Duel.IsChainDisablable(ev)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	lanp.U("连锁信息",0,"NEGE",nil,1,1-tp,"0")
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		lanp.U("连锁信息",0,"DES",eg,1,1-tp,"0")
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		lanp.U("效果处理",Duel.Destroy,eg,{"EFF"})
		if Duel.GetFlagEffect(tp,m)==0 then
    	    local e1=lane.FC(e,tp,"",EVENT_PREDRAW,",,",cm.con2,cm.op2,{RESET_PHASE+PHASE_END,3})
            local e2=lane.FC(e,tp,"",EVENT_CHAINING,",,",cm.con3,cm.op3,{RESET_PHASE+PHASE_END,3})
            table.insert(dusk.begin,e1)
            table.insert(dusk[m],c)
            table.insert(dusk[m],e1)
            table.insert(dusk[m],e2)
            lanp.U("标识",tp,m,RESET_PHASE+PHASE_END,0,3)
    	end
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlaye()==1-tp
end
function cm.op2(e,tp,eg,ev,ep,re,r,rp)
    local e1=lane.FC(e,tp,"",EVENT_CHAINING,",,",cm.con3,cm.op4,{RESET_PHASE+PHASE_END,1})
    local c=dusk[m][1]
    if lanc.Filter(c,"IsLoc+CanSp",{"G/R",{e,0,tp}}) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
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
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
    return rp==tp
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
    local e1=lane.F(e,tp,"",EFFECT_CANNOT_ACTIVATE,"PTG,,0+1",cm.act,",,,",RESET_CHAIN)
end
function cm.act(e,re,tp)
    local rc=re:GetHandler()
	return lanc.Filter(rc,"IsLoc+IsTyp","M,M")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimit(cm.cha)
end
function cm.cha(e,rp,tp)
	return tp==rp
end
function cm.con4(e,tp,eg,ev,ep,re,r,rp)
    return lang.GetFilter(tp,"M","IsSummonType+IsReleasable",{SUMMON_TYPE_PENDULUM},2)
end
function cm.tg2(e,tp,eg,ev,ep,re,r,rp,chk)
    local g=lang.SelectFilter(tp,"M","IsSummonType+IsReleasable",{SUMMON_TYPE_PENDULUM},tp,2)
    if g then
		    g:KeepAlive()
		    e:SetLabelObject(g)
		return true
	else return false end
end
function cm.op5(e,tp,eg,ev,ep,re,r,rp)
    local g=e:GetLabelObject()
    if #g==0 then return false end
    lanp.U("效果处理",Duel.Release,g,{"COS"})
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return lang.GetFilter(tp,"D","IsName+AbleTo","黄昏圣堂,H",1) end
    lanp.U("连锁信息",0,"DES",c,1,tp,"P")
    lanp.U("连锁信息",0,"TH",0,1,tp,"D")
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
    lanp.U("提示","S",tp,"ATH")
    local c=e:GetHandler()
    local g=lang.SelectFilter(tp,"D","IsName+AbleTo","黄昏圣堂,H")
    if #g==0 then return false end
    if lanp.U("效果处理",Duel.SendtoHand,g,{nil,"EFF"})>0 then
        Duel.ConfirmCards(1-tp,g)
        lanp.U("效果处理",Duel.Destroy,c,{"EFF"})
    end
end