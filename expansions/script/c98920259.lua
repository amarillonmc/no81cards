--战争之圣像骑士
function c98920259.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,98920259+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c98920259.spcon)
	e1:SetValue(c98920259.spval)
	c:RegisterEffect(e1)
--extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920259,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98930259)
	e3:SetCondition(c98920259.condition)
	e3:SetTarget(c98920259.eatg)
	e3:SetOperation(c98920259.eaop)
	c:RegisterEffect(e3)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920259,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98940259)
	e1:SetCondition(c98920259.scondition)
	e1:SetTarget(c98920259.sptg)
	e1:SetOperation(c98920259.spop)
	c:RegisterEffect(e1)
end
function c98920259.scondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c98920259.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=Duel.GetLinkedZone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c98920259.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end
function c98920259.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c98920259.eafilter(c)
	return c:IsFaceup() and c:IsSetCard(0x116) and c:IsType(TYPE_LINK) and not c:IsHasEffect(EFFECT_CANNOT_ATTACK)
end
function c98920259.eatg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920259.eafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920259.eafilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c98920259.eafilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c98920259.eaop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c98920259.ftarget)
	e2:SetLabel(tc:GetFieldID())
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c98920259.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c98920259.spfilter(c,e,tp,ec)
	local zone=c:GetLinkedZone(tp)
	return c:IsFaceup() and c:IsSetCard(0x116) and c:IsType(TYPE_LINK) and ec:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c98920259.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920259.spfilter(chkc,e,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(c98920259.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c98920259.spfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c98920259.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local zone=tc:GetLinkedZone(tp)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and zone&0x1f~=0
		and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	end
end