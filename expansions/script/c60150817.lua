--爱莎-窒息的痛楚
function c60150817.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c60150817.spcon)
	e2:SetOperation(c60150817.spop)
	c:RegisterEffect(e2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60150817,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,60150817)
	e1:SetCondition(c60150817.rmcon)
	e1:SetTarget(c60150817.sptg2)
	e1:SetOperation(c60150817.spop2)
	c:RegisterEffect(e1)
end
function c60150817.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,2,nil)
end
function c60150817.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c60150817.filter(c,e,tp)
	return c:IsSetCard(0x3b23) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150817.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE+LOCATION_REMOVED)
end
function c60150817.afilter(c)
	return c:IsAbleToRemove()
end
function c60150817.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60150817.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	local g=Duel.GetMatchingGroup(c60150817.afilter,tp,LOCATION_DECK,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c60150817.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60150817.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=Duel.GetFieldCard(tp,LOCATION_DECK,0)
		local tc2=Duel.GetFieldCard(1-tp,LOCATION_DECK,0)
		if (tc:IsAbleToRemove() and tc2:IsAbleToRemove()) and Duel.SelectYesNo(tp,aux.Stringid(60150810,0)) then
			if Duel.SelectYesNo(tp,aux.Stringid(60150810,1)) then
				Duel.BreakEffect()
				Duel.DisableShuffleCheck()
				Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)
			else
				Duel.BreakEffect()
				Duel.DisableShuffleCheck()
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			end
		elseif (tc:IsAbleToRemove() and not tc2:IsAbleToRemove()) and Duel.SelectYesNo(tp,aux.Stringid(60150810,0)) then
			Duel.BreakEffect()
			Duel.DisableShuffleCheck()
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		elseif (not tc:IsAbleToRemove() and tc2:IsAbleToRemove()) and Duel.SelectYesNo(tp,aux.Stringid(60150810,0)) then
			Duel.BreakEffect()
			Duel.DisableShuffleCheck()
			Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)
		end
	end
end