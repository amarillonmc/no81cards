--真挚的韶光 卡米娜尔
function c9910465.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910465)
	e1:SetCondition(c9910465.spcon)
	e1:SetCost(c9910465.spcost)
	e1:SetTarget(c9910465.sptg)
	e1:SetOperation(c9910465.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910466)
	e2:SetCondition(c9910465.thcon)
	e2:SetTarget(c9910465.thtg)
	e2:SetOperation(c9910465.thop)
	c:RegisterEffect(e2)
end
function c9910465.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9910465.costfilter(c)
	return c:IsSetCard(0x9950) and not c:IsCode(9910465) and c:IsAbleToGraveAsCost()
end
function c9910465.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910465.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910465.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910465.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910465.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9950)
end
function c9910465.ctfilter(c)
	local g=Group.FromCards(c)
	g:Merge(c:GetColumnGroup())
	return c:IsCanAddCounter(0x1950,1) and g:IsExists(c9910465.cfilter,1,nil)
end
function c9910465.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		local sg=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,0x1950,1)
		local opt=0
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		if #sg>0 then
			opt=Duel.SelectOption(tp,aux.Stringid(9910465,0),aux.Stringid(9910465,1))
		else
			opt=Duel.SelectOption(tp,aux.Stringid(9910465,0))
		end
		if opt==0 then
			if Duel.IsPlayerAffectedByEffect(tp,9910467) then
				Duel.Recover(tp,2000,REASON_EFFECT)
			else
				Duel.Recover(tp,1000,REASON_EFFECT)
			end
		else
			local lp=Duel.GetLP(tp)
			Duel.SetLP(tp,lp-2000)
			for i=1,2 do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
				local tc=sg:Select(tp,1,1,nil):GetFirst()
				tc:AddCounter(0x1950,1)
			end
		end
	end
end
function c9910465.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9910465.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c9910465.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9910465,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_HAND)
		tc:RegisterEffect(e1,true)
	end
end
