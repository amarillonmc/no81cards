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
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38316345)
	e2:SetCondition(c28316345.reccon)
	e2:SetTarget(c28316345.rectg)
	e2:SetOperation(c28316345.recop)
	c:RegisterEffect(e2)
end
function c28316345.chkfilter(c)
	return (c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsNonAttribute(ATTRIBUTE_FIRE) or c:IsCode(28335405)) and not c:IsPublic()
end
function c28316345.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28316345.chkfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28316345.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetFirst():IsLevel(4) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c28316345.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
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
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and sel==1 and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c28316345.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(28316345,3)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c28316345.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		local sc=g:GetFirst()
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sc=g:Select(tp,1,1,nil):GetFirst()
		end
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28316345.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND+LOCATION_EXTRA) and #eg==1 and not eg:IsContains(e:GetHandler())
end
function c28316345.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x283)
end
function c28316345.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c28316345.recop(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(ag) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
	end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if aux.GetAttributeCount(g)>=3 and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c28316345.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(28316345,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c28316345.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
