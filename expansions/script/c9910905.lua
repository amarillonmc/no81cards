--魔导驭傀师 幻视
function c9910905.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_REMOVE+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9910905)
	e1:SetCondition(c9910905.condition1)
	e1:SetCost(c9910905.cost)
	e1:SetTarget(c9910905.target)
	e1:SetOperation(c9910905.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9910905.condition2)
	c:RegisterEffect(e2)
end
function c9910905.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c9910905.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9910905.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910905.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910905.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910905.cfilter(c,e,tp,mc)
	local b1=mc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp,c)>0
	local b2=mc:IsAbleToRemove() and Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)
	return aux.IsCodeListed(c,9910871) and c:IsAbleToHandAsCost() and (b1 or b2)
end
function c9910905.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9910905.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910905.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,c)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c9910905.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=c:IsAbleToRemove() and Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
end
function c9910905.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=c:IsAbleToRemove() and Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)
	if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(9910905,0),aux.Stringid(9910905,1))==0) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	elseif b2 and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_REMOVED) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()==0 then return end
		Duel.HintSelection(g)
		Duel.GetControl(g:GetFirst(),tp,PHASE_END,1)
	end
end
