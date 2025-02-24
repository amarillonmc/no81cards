--闪耀的放课后 西城树里
function c28316048.initial_effect(c)
	--hokura spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28316048,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28316048)
	e1:SetCost(c28316048.spcost)
	e1:SetTarget(c28316048.sptg)
	e1:SetOperation(c28316048.spop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28316048,1))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38316048)
	e2:SetCondition(c28316048.reccon)
	e2:SetTarget(c28316048.rectg)
	e2:SetOperation(c28316048.recop)
	c:RegisterEffect(e2)
end
function c28316048.chkfilter(c)
	return c:IsSetCard(0x283) and c:IsNonAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c28316048.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28316048.chkfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28316048.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c28316048.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28316048.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28316048.chkfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsReason(REASON_DRAW) and (c:IsPublic() or (not c:IsStatus(STATUS_TO_HAND_WITHOUT_CONFIRM) and (c:IsPreviousLocation(LOCATION_DECK) or c:IsPreviousPosition(POS_FACEUP))))
end
function c28316048.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28316048.chkfilter,1,nil)
end
function c28316048.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x283)
end
function c28316048.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x283)
end
function c28316048.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c28316048.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,500,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetClassCount(Card.GetAttribute)>=3 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c28316048.thfilter),tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28316048,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c28316048.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
