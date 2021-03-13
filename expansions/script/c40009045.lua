--机空援护 联合出击
function c40009045.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,40009045+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c40009045.target)
	e1:SetOperation(c40009045.activate)
	c:RegisterEffect(e1)
end
function c40009045.filter(c,e,tp)
	if not (c:IsType(TYPE_LINK) and c:IsSetCard(0xf13)) then return false end
	local zone=c:GetLinkedZone(tp)
	return Duel.IsExistingMatchingCard(c40009045.gfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone)
end
function c40009045.gfilter(c,e,tp,zone)
	return c:IsSetCard(0xf13) and c:IsType(TYPE_LINK) and c:IsLink(1)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c40009045.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40009045.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c40009045.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c40009045.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40009045.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local zone=bit.band(tc:GetLinkedZone(tp),0x1f)
	local upbound=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if upbound<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40009045.gfilter),tp,LOCATION_EXTRA,0,1,upbound,nil,e,tp,zone)
	if g:GetCount()>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,zone)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end