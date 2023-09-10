--恐龙摔跤手·过背摔暴龙
function c98920668.initial_effect(c)
	  --special summon itself
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920668,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920668)
	e1:SetCondition(c98920668.spcon1)
	e1:SetTarget(c98920668.sptg1)
	e1:SetOperation(c98920668.spop1)
	c:RegisterEffect(e1)
	--position
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920668,1))
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_ATTACK+TIMING_END_PHASE)
	e3:SetCountLimit(1,92597894)
	e3:SetCondition(c98920668.poscon)
	e3:SetTarget(c98920668.postg)
	e3:SetOperation(c98920668.posop)
	c:RegisterEffect(e3)
end
function c98920668.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x11a) and c:IsFaceup()
end
function c98920668.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local ct2=Duel.GetMatchingGroupCount(c98920668.cfilter,tp,LOCATION_MZONE,0,nil)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local tc=re:GetHandler()
	return tc:IsControler(1-tp) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) and loc==LOCATION_MZONE 
		and ct2>0
end
function c98920668.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c98920668.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.NegateEffect(ev)
	end
end
function c98920668.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c98920668.posfilter(c)
	return c:IsFaceup() and c:IsCanChangePosition()
end
function c98920668.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98920668.posfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c98920668.posfilter,tp,0,LOCATION_MZONE,1,c) and c:IsAbleToHand() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,c98920668.posfilter,tp,0,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c98920668.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_SET_ATTACK_FINAL)
		e0:SetValue(0)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e0)
		local e1=e0:Clone()
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e1)
	end
end