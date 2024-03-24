--闪耀的放课后 小宫果穗
function c28316345.initial_effect(c)
	aux.AddCodeList(c,28335405)
	--hokura spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28316345,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28316345)
	e1:SetCost(c28316345.spcost)
	e1:SetTarget(c28316345.sptg)
	e1:SetOperation(c28316345.spop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28316345,1))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38316345)
	e2:SetTarget(c28316345.rectg)
	e2:SetOperation(c28316345.recop)
	c:RegisterEffect(e2)
end
function c28316345.chkfilter(c)
	return ((c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_FIRE)) or c:IsCode(28335405)) and not c:IsPublic()
end
function c28316345.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28316345.chkfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28316345.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetFirst():IsSetCard(0x286) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c28316345.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28316345.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x286) and c:IsType(TYPE_MONSTER)
end
function c28316345.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and sel==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c28316345.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(28316345,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c28316345.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()==1 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c28316345.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x283)
end
function c28316345.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x283)
end
function c28316345.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c28316345.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c28316345.cfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.Recover(tp,500,REASON_EFFECT)>0 and g:GetClassCount(Card.GetAttribute)>=3 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c28316345.thfilter),tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28316345,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28316345.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
