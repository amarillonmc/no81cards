--喀兰贸易·重装干员-角峰
function c79029068.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c79029068.matfilter,2,2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c79029068.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--battle indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c79029068.valcon)
	c:RegisterEffect(e2)   
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,79029068)
	e3:SetTarget(c79029068.sptg)
	e3:SetOperation(c79029068.spop)
	c:RegisterEffect(e3)  
end
function c79029068.matfilter(c)
	return c:IsLinkSetCard(0xa900)
end
function c79029068.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c79029068.valcon(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		e:GetHandler():RegisterFlagEffect(79029068,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		return true
	else return false end
end
function c79029068.spfilter1(c,e,tp)
	if c:IsFaceup() and c:IsType(TYPE_LINK) then
		local zone=c:GetLinkedZone(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(c79029068.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,zone)
	else return false end
end
function c79029068.spfilter2(c,e,tp,zone)
	return c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c79029068.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c79029068.spfilter1(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c79029068.spfilter1,tp,LOCATION_MZONE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c79029068.spfilter1,tp,LOCATION_MZONE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end 
function c79029068.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lc=Duel.GetFirstTarget()
	if lc:IsRelateToEffect(e) and lc:IsFaceup() then
		local zone=lc:GetLinkedZone(tp)
		if zone==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c79029068.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,zone):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone) 
end
end