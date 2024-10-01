--闪耀的放课后 杜野凛世
function c28315544.initial_effect(c)
	--hokura spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28315544,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28315544)
	e1:SetCost(c28315544.spcost)
	e1:SetTarget(c28315544.sptg)
	e1:SetOperation(c28315544.spop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28315544,1))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38315544)
	e2:SetTarget(c28315544.rectg)
	e2:SetOperation(c28315544.recop)
	c:RegisterEffect(e2)
end
function c28315544.chkfilter(c)
	return c:IsSetCard(0x283) and not c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c28315544.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28315544.chkfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28315544.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c28315544.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28315544.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28315544.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x283)
end
function c28315544.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c28315544.gcheck(sg,tp)
	return sg:FilterCount(Card.IsControler,nil,1-tp)<=1
end
function c28315544.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c28315544.cfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.Recover(tp,500,REASON_EFFECT)>0 and g:GetClassCount(Card.GetAttribute)>=3 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28315544,2)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:SelectSubGroup(tp,c28315544.gcheck,false,1,2,tp)
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
