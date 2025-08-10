--希望的魅力
function c22024120.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,22024120+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c22024120.target)
	e1:SetOperation(c22024120.operation)
	c:RegisterEffect(e1)
end
c22024120.effect_with_avalon=true
c22024120.effect_with_altria=true
function c22024120.cfilter(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c22024120.spfilter(c,e,tp)
	return c:IsSetCard(0xff9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22024120.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCounter(0,1,0,0xfee)
	if chk==0 then return Duel.IsExistingMatchingCard(c22024120.cfilter,tp,LOCATION_MZONE,0,1,nil) and ct>=3 end
end
function c22024120.filter(c)
	return c:IsSetCard(0xff1) and c:IsAbleToHand()
end
function c22024120.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22024120.cfilter,tp,LOCATION_EXTRA,0,nil)
	local ct=Duel.GetCounter(0,1,0,0xfee)
	local b1=ct>=3
	local b2=ct>=6 and Duel.IsExistingMatchingCard(c22024120.filter,tp,LOCATION_DECK,0,1,nil)
	local b3=ct>=12 and Duel.IsExistingMatchingCard(c22024120.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if b1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c22024120.atktg)
		e1:SetValue(c22024120.atkval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if b2 and Duel.SelectYesNo(tp,aux.Stringid(22024120,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c22024120.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if b3 and Duel.SelectYesNo(tp,aux.Stringid(22024120,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c22024120.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #sg==0 then return end
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22024120.atktg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xff1)
end
function c22024120.atkval(e,c)
	return Duel.GetCounter(0,1,1,0xfee)*100
end