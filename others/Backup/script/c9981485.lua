--单眼假发
function c9981485.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,9981485+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9981485.target)
	e1:SetOperation(c9981485.activate)
	c:RegisterEffect(e1)
end
function c9981485.filter(c,e,tp,ft)
	return c:IsFaceup() and c:IsSetCard(0xba5) and c:IsLevelBelow(4) and (ft>0 or c:GetSequence()<5)
		and Duel.IsExistingMatchingCard(c9981485.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function c9981485.spfilter(c,code,e,tp)
	return c:IsSetCard(0xba5) and c:IsLevelBelow(8) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9981485.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9981485.filter(chkc,e,tp,ft) end
	if chk==0 then return ft>-1 and Duel.IsExistingTarget(c9981485.filter,tp,LOCATION_MZONE,0,1,nil,e,tp,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c9981485.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,ft)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c9981485.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local code=tc:GetCode()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_GRAVE) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9981485.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,code,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end