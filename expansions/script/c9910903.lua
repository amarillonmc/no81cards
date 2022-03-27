--斩灵的德涅芙拉
function c9910903.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910903)
	e1:SetCondition(c9910903.spcon)
	e1:SetTarget(c9910903.sptg)
	e1:SetOperation(c9910903.spop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910904)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(c9910903.atkcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c9910903.atkop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(9910903,ACTIVITY_CHAIN,aux.FALSE)
end
function c9910903.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local sg=g:Filter(Card.IsFaceup,nil)
	return sg and sg:GetClassCount(Card.GetRace)>=2
end
function c9910903.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910903.desfilter(c)
	return aux.IsCodeListed(c,9910871)
end
function c9910903.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g1=Duel.GetMatchingGroup(c9910903.desfilter,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.GetCustomActivityCount(9910903,1-tp,ACTIVITY_CHAIN)~=0
		and g1:GetCount()>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910903,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg1=g1:Select(tp,1,1,nil)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		if sg1:GetCount()~=2 then return end
		Duel.HintSelection(sg1)
		Duel.Destroy(sg1,REASON_EFFECT)
	end
end
function c9910903.cfilter2(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function c9910903.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and Duel.IsExistingMatchingCard(c9910903.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c9910903.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	Duel.RegisterEffect(e2,tp)
end
