--武神合神
function c98920477.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98920477)
	e1:SetCondition(c98920477.condition)
	e1:SetTarget(c98920477.target)
	e1:SetOperation(c98920477.activate)
	e1:SetCost(c98920477.cost)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(98920477,ACTIVITY_SUMMON,c98920477.counterfilter)
	Duel.AddCustomActivityCounter(98920477,ACTIVITY_SPSUMMON,c98920477.counterfilter)
end
function c98920477.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c98920477.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(98920477,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(98920477,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98920477.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c98920477.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c98920477.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x88)
end
function c98920477.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)
	return ct>0 and aux.dscon() and Duel.IsExistingMatchingCard(c98920477.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c98920477.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)
		if ct<=1 then return Duel.IsExistingMatchingCard(c98920477.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
		return true
	end
end
function c98920477.tgfilter(c)
	return c:IsSetCard(0x88) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c98920477.thfilter(c)
	return c:IsSetCard(0x88) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98920477.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x88) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920477.activate(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetOwner()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)
	local ct=g:GetCount()
	local g=Duel.GetMatchingGroup(c98920477.tgfilter,tp,LOCATION_DECK,0,nil)
	local mg=Duel.GetMatchingGroup(c98920477.thfilter,tp,LOCATION_DECK,0,nil)
	local tg=Duel.GetMatchingGroup(c98920477.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if ct>=1 and g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	if ct>=2 and mg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		mg=mg:Select(tp,1,1,nil)
		Duel.SendtoHand(mg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,mg)
	end
	if ct>=3 and tg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=tg:Select(tp,1,1,nil)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end