local m=15000694
local cm=_G["c"..m]
cm.name="超同调"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

	if not cm.global_effect then
		cm.global_effect=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		ge1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		ge1:SetCondition(cm.syncon)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON)
		ge2:SetCondition(cm.syncon)
		ge2:SetOperation(cm.spop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.syncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,15000694)~=0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(0,15000694)
	Duel.ResetFlagEffect(1,15000694)
end
function cm.filter1(c,e,sc,chkx)
	return c:IsFaceup() and (chkx==0 or (not c:IsImmuneToEffect(e))) and c:IsCanBeSynchroMaterial(sc)
end
function cm.filter2(c,e,tp,chkx)
	local ag=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE):Filter(cm.filter1,nil,e,c,chkx)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.CheckSynchroMaterial(c,nil,nil,1,99,nil,ag)
end
function cm.filter3(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		Duel.RegisterFlagEffect(tp,15000694,RESET_CHAIN,0,1)
		Duel.RegisterFlagEffect(1-tp,15000694,RESET_CHAIN,0,1)
		local x=0
		if Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,0) then x=1 end
		Duel.ResetFlagEffect(tp,15000694)
		Duel.ResetFlagEffect(1-tp,15000694)
		return x==1
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,15000694,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(1-tp,15000694,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,1)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local ag=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE):Filter(cm.filter1,nil,e,sg:GetFirst(),1)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,ag)
	end
end