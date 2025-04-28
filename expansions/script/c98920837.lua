--元素英雄 未来新宇侠
function c98920837.initial_effect(c)
	c:SetUniqueOnField(1,0,98920837)
	aux.AddCodeList(c,89943723)
	--material
	aux.AddMaterialCodeList(c,89943723)
	aux.AddFusionProcFun2(c,c98920837.ffilter1,c98920837.ffilter2,true)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920837,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,98920837)
	e1:SetCondition(c98920837.spcon1)
	e1:SetTarget(c98920837.target)
	e1:SetOperation(c98920837.operation)
	c:RegisterEffect(e1)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920837,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c98920837.sumcon)
	e4:SetTarget(c98920837.sumtg)
	e4:SetOperation(c98920837.sumop)
	c:RegisterEffect(e4)
end
c98920837.material_setcode=0x8
function c98920837.ffilter1(c)
	return (c:IsCode(89943723) or (c:IsType(TYPE_FUSION) and c:IsSetCard(0x8))) and c:IsLocation(LOCATION_ONFIELD)
end
function c98920837.ffilter2(c)
	return c:IsSetCard(0x9,0x1f)
end
function c98920837.negfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x8)
end
function c98920837.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c98920837.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local count=0
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x1f) then count=count+1 end
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x9) then count=count+1 end
	if Duel.IsExistingMatchingCard(c98920837.negfilter,tp,LOCATION_GRAVE,0,1,nil) then count=count+1 end
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.NegateAnyFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(98920837)<count end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	c:RegisterFlagEffect(98920837,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c98920837.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e,false) then
		   Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e1:SetCode(EFFECT_DISABLE)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		   tc:RegisterEffect(e1)
		   local e2=Effect.CreateEffect(c)
		   e2:SetType(EFFECT_TYPE_SINGLE)
		   e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e2:SetCode(EFFECT_DISABLE_EFFECT)
		   e2:SetValue(RESET_TURN_SET)
		   e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		   tc:RegisterEffect(e2)
		   if tc:IsType(TYPE_TRAPMONSTER) then
			   local e3=Effect.CreateEffect(c)
			   e3:SetType(EFFECT_TYPE_SINGLE)
			   e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			   e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			   e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			   tc:RegisterEffect(e3)
		   end
	   end
	end
end
function c98920837.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c98920837.filter(c,e,tp)
	return c:IsCode(31111109) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,true) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c98920837.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920837.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920837.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c98920837.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if tg then
		Duel.SpecialSummon(tg,SUMMON_TYPE_FUSION,tp,tp,false,true,POS_FACEUP)
	end
end