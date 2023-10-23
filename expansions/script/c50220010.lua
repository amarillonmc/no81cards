--海波之圣像骑士
function c50220010.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,50220010+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c50220010.spcon)
	e1:SetValue(c50220010.spval)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50220010,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,50220011)
	e2:SetCondition(c50220010.descon)
	e2:SetTarget(c50220010.destg)
	e2:SetOperation(c50220010.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c50220010.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=Duel.GetLinkedZone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c50220010.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end
function c50220010.descon(e,tp,eg,ep,ev,re,r,rp)
	local lg1=Duel.GetLinkedGroup(tp,1,1)
	local lg2=Duel.GetLinkedGroup(1-tp,1,1)
	lg1:Merge(lg2)
	return lg1 and lg1:IsContains(e:GetHandler())
end
function c50220010.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x116)
end
function c50220010.spfilter(c,e)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsSetCard(0x116)
end
function c50220010.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1
		and Duel.IsExistingTarget(c50220010.desfilter,tp,LOCATION_ONFIELD,0,1,nil,ft)
		and Duel.IsExistingTarget(c50220010.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c50220010.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c50220010.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function c50220010.desop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	if tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e) and Duel.Destroy(tc1,REASON_EFFECT)~=0 then
		local s1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local s2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		local op=0
		Duel.Hint(HINT_SELECTMSG,tp,0)
		if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(50220010,1),aux.Stringid(50220010,2))
		elseif s1 then op=Duel.SelectOption(tp,aux.Stringid(50220010,1))
		elseif s2 then op=Duel.SelectOption(tp,aux.Stringid(50220010,2))+1
		else return end
		if op==0 then Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
		else Duel.SpecialSummon(tc2,0,tp,1-tp,false,false,POS_FACEUP) end
	end
end