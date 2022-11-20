--科维努斯
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10133011)
function cm.initial_effect(c)
	rscf.SetSummonCondition(c,false,cm.slimit)
	aux.AddCodeList(c,10133001)
	aux.AddFusionProcCodeRep(c,10133001,3,false,false)
	local e0 = aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_ONFIELD,0,Duel.Release,REASON_COST)
	e0:SetValue(SUMMON_VALUE_SELF)
	local e1=rsef.QO(c,nil,"des",nil,"des",nil,LOCATION_MZONE,nil,cm.descost,rsop.target(aux.TRUE,"des",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.desop)
	local e2=rsef.FTO(c,EVENT_DESTROYED,"sp",1,"sp","de,dsp",LOCATION_MZONE,cm.spcon,nil,rsop.target2(cm.reg,cm.spfilter,"dum",
		LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND),cm.spop)
end
function cm.slimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function cm.cfilter(c)
	return (c:IsCode(10133001) or (c:IsType(TYPE_FUSION) and c:IsSetCard(0x3334))) and c:IsFaceup()
end
function cm.maxct(e,tp)
	return Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_ONFIELD,0,nil)
end
function cm.desop(e,tp)
	rsop.SelectDestroy(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,{})
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk == 0 then return c:GetFlagEffect(m) == 0 or c:GetFlagEffectLabel(m) < cm.maxct(e,tp) end
	local ct = c:GetFlagEffect(m) == 0 and 0 or c:GetFlagEffectLabel(m)
	c:ResetFlagEffect(m)
	c:RegisterFlagEffect(m,rsrst.std_ep,EFFECT_FLAG_CLIENT_HINT,1,ct+1,aux.Stringid(m,ct))
end
function cm.spcfilter(c,tp)
	return c:GetPreviousControler()~=tp and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.spcon(e,tp,eg)
	return eg:IsExists(cm.spcfilter,1,nil,tp)
end
function cm.reg(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spfilter(c,e,tp)
	return (c:IsCode(10133001) or c:IsHasEffect(10133009)) and rscf.spfilter2()(c,e,tp)
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0,1,1,nil,{},e,tp)
end