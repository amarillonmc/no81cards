--奏乐之月神
function c9910078.initial_effect(c)
	--turn set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910078)
	e1:SetTarget(c9910078.target)
	e1:SetOperation(c9910078.operation)
	c:RegisterEffect(e1)
	--salvage or negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910079)
	e2:SetCondition(c9910078.condition2)
	e2:SetTarget(c9910078.target2)
	e2:SetOperation(c9910078.operation2)
	c:RegisterEffect(e2)
end
function c9910078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND+LOCATION_DECK)
end
function c9910078.spfilter(c,e,tp)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910078.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.AdjustAll()
		local g=Duel.GetMatchingGroup(c9910078.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910078,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9910078.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910078.splimit(e,c)
	return not c:IsRace(RACE_FAIRY) and c:IsLocation(LOCATION_EXTRA)
end
function c9910078.filter2(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x9951)
end
function c9910078.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c9910078.filter2,1,nil,tp)
end
function c9910078.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=e:GetHandler():IsAbleToHand()
	local b2=e:GetHandler():IsAbleToRemove() and Duel.IsChainDisablable(ev)
	if chk==0 then return b1 or b2 end
end
function c9910078.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1=c:IsAbleToHand()
	local b2=c:IsAbleToRemove() and Duel.IsChainDisablable(ev)
	if b1 and (not b2 or Duel.SelectOption(tp,1190,1192)==0) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	elseif Duel.Remove(c,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.NegateEffect(ev)
	end
end
