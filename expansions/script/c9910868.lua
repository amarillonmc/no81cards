--千恋 马庭芦花
function c9910868.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910868)
	e1:SetCondition(c9910868.spcon)
	e1:SetCost(c9910868.spcost)
	e1:SetTarget(c9910868.sptg)
	e1:SetOperation(c9910868.spop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910869)
	e2:SetCondition(c9910868.discon1)
	e2:SetTarget(c9910868.distg)
	e2:SetOperation(c9910868.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c9910868.discon2)
	c:RegisterEffect(e3)
end
function c9910868.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c9910868.cfilter(c)
	return c:IsSetCard(0xa951) and not c:IsPublic()
end
function c9910868.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910868.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c9910868.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c9910868.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910868.sumfilter(c)
	return c:IsSetCard(0xa951) and c:IsSummonable(true,nil)
end
function c9910868.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if Duel.IsExistingMatchingCard(c9910868.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910868,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910868.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end

function c9910868.discon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9910868.filter,tp,LOCATION_MZONE,0,2,nil,false)
end
function c9910868.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910868.filter,tp,LOCATION_MZONE,0,2,nil,false)
end
function c9910868.filter(c,flag)
	return c:IsFaceup() and c:IsSetCard(0xa951) and c:GetLevel()>0 and (flag or c:IsLevelBelow(3))
end
function c9910868.negfilter(c)
	return aux.NegateAnyFilter(c) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9910868.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c9910868.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c9910868.filter,tp,LOCATION_MZONE,0,1,nil,true)
		and Duel.IsExistingTarget(c9910868.negfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,c9910868.negfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c9910868.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9910868.filter,tp,LOCATION_MZONE,0,nil,true)
	if g:GetCount()==0 then return end
	local sc=g:GetFirst()
	while sc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		sc=g:GetNext()
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
end
