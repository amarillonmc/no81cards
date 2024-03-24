--闪耀的放课后 园田智代子
function c28314946.initial_effect(c)
	--hokura spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28314946,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28314946)
	e1:SetCost(c28314946.spcost)
	e1:SetTarget(c28314946.sptg)
	e1:SetOperation(c28314946.spop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28314946,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38314946)
	e2:SetTarget(c28314946.rectg)
	e2:SetOperation(c28314946.recop)
	c:RegisterEffect(e2)
end
function c28314946.chkfilter(c)
	return c:IsSetCard(0x283) and not c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c28314946.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28314946.chkfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28314946.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c28314946.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28314946.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28314946.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x283)
end
function c28314946.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c28314946.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c28314946.cfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.Recover(tp,500,REASON_EFFECT)>0 and g:GetClassCount(Card.GetAttribute)>=3 and Duel.SelectYesNo(tp,aux.Stringid(28314946,2)) then
		Duel.BreakEffect()
		Duel.Recover(tp,1000,REASON_EFFECT,true)
		Duel.Recover(1-tp,1000,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end
