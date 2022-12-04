--人理之诗 终局的犯罪
function c22022170.initial_effect(c)
	aux.AddCodeList(c,22022160)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_ATTACK)
	e1:SetCountLimit(1,22022170+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22022170.condition)
	e1:SetOperation(c22022170.activate)
	c:RegisterEffect(e1)
end
function c22022170.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x2ff1)
end
function c22022170.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x108)
end
function c22022170.cfilter3(c)
	return c:IsFaceup() and c:IsCode(22022160)
end
function c22022170.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(c22022170.cfilter1,tp,LOCATION_MZONE,0,nil)
	local ct2=Duel.GetMatchingGroupCount(c22022170.cfilter2,tp,LOCATION_MZONE,0,nil)
	local ct3=Duel.GetMatchingGroupCount(c22022170.cfilter3,tp,LOCATION_MZONE,0,nil)
	local mct=Duel.GetMatchingGroupCount(c22022170.filter1,tp,0,LOCATION_MZONE,nil)
	local stct=Duel.GetMatchingGroupCount(c22022170.filter2,tp,0,LOCATION_ONFIELD,nil)
	return ct3>0 or (ct1>0 and mct>0) or (ct2>0 and stct>0)
end
function c22022170.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c22022170.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c22022170.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c22022170.cfilter1,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c22022170.cfilter2,tp,LOCATION_MZONE,0,nil)
	local g3=Duel.GetMatchingGroup(c22022170.cfilter3,tp,LOCATION_MZONE,0,nil)
	local ct1=g1:GetCount()
	local ct2=g2:GetCount()
	local ct3=g3:GetCount()
	if ct1>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c22022170.filter1,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	if ct2>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g4=Duel.SelectMatchingCard(tp,c22022170.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(g4)
		Duel.SendtoGrave(g4,REASON_EFFECT)
	end
	if ct3>=1 then
		Duel.Damage(1-tp,2500,REASON_EFFECT)
	end
end