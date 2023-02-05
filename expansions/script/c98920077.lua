--古代的机械支援兵
function c98920077.initial_effect(c)
	aux.AddCodeList(c,83104731)
		--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920077,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920077)
	e1:SetCondition(aux.dscon)
	e1:SetCost(c98920077.atkcost1)
	e1:SetTarget(c98920077.atktg)
	e1:SetOperation(c98920077.atkop1)
	c:RegisterEffect(e1)  
  --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920077,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c98920077.spcon)
	e2:SetCountLimit(1,98821077)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98920077.sptg)
	e2:SetOperation(c98920077.spop)
	c:RegisterEffect(e2)
end
function c98920077.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c98920077.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7)
end
function c98920077.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98920077.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920077.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c98920077.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c98920077.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c98920077.cfilter(c)
	   return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousSetCard(0x7)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
end
function c98920077.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920077.cfilter,1,nil)
end
function c98920077.spfilter(c,e,tp)
	return (c:IsCode(83104731) or c:IsCode(95735217)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c98920077.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920077.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c98920077.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920077.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)~=0 then
	end
end