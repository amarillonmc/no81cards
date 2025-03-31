--祭礼巡林士 埃莉尔
function c3052.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3052,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,3052)
	e1:SetCost(c3052.spcost)
	e1:SetTarget(c3052.sptg)
	e1:SetOperation(c3052.spop)
	c:RegisterEffect(e1)
	--deck check
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3052,1))
	e2:SetRange(LOCATION_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,3052)
	e2:SetCost(c3052.cost)
	e2:SetTarget(c3052.target)
	e2:SetOperation(c3052.operation)
	c:RegisterEffect(e2)
end 
function c3052.cfilter(c)
	return c:IsSetCard(0x851) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c3052.spfilter(c,e,tp)
	return c:IsSetCard(0x851) and c:IsType(TYPE_MONSTER) and c:GetLevel()==6 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3052.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3052.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c3052.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c3052.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c3052.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c3052.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c3052.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
		Duel.BreakEffect()
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end
function c3052.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c3052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c3052.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x851) then
		Duel.DisableShuffleCheck()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		Duel.MoveSequence(tc,1)
	end
end