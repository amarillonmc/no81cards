--超古代的巨人 影之继承者
function c98930026.initial_effect(c)
	 --synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c98930026.matfilter1,nil,nil,c98930026.matfilter2,1,99)
   --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98930026,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetCondition(c98930026.descon1)
	e1:SetTarget(c98930026.destg)
	e1:SetOperation(c98930026.desop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98930026,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c98930026.descon2)
	e2:SetTarget(c98930026.indtg)
	e2:SetOperation(c98930026.indop)
	c:RegisterEffect(e2) 
   --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98930026,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,84330568)
	e3:SetCondition(c98930026.spcon)
	e3:SetTarget(c98930026.sptg)
	e3:SetOperation(c98930026.spop)
	c:RegisterEffect(e3)
end
function c98930026.matfilter1(c,syncard)
	return c:IsTuner(syncard) or c:IsSetCard(0xad0)
end
function c98930026.matfilter2(c,syncard)
	return c:IsNotTuner(syncard) and c:IsSetCard(0xad0)
end
function c98930026.descon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_DARK)
end
function c98930026.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_LIGHT)
end
function c98930026.desfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_XYZ)
end
function c98930026.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c98930026.tgfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98930026.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c98930026.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT) and g:GetFirst():IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c98930026.tgfilter(c)
	return c:IsSetCard(0xad0) and c:IsAbleToGrave()
end
function c98930026.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xb2)
end
function c98930026.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c98930026.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98930026.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c98930026.tgfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c98930026.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c98930026.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c98930026.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT) and g:GetFirst():IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetValue(c98930026.valcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c98930026.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c98930026.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98930026.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98930026.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_LIGHT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
	if not re then return false end
	local rc=re:GetHandler()
	if rc:IsCode(98930021) and Duel.SelectYesNo(tp,aux.Stringid(98930026,2)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	   local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	   if g:GetCount()>0 then
		   Duel.HintSelection(g)
		   Duel.Destroy(g,REASON_EFFECT) 
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_UPDATE_ATTACK)
		   e1:SetValue(900)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   c:RegisterEffect(e1)
	   end
	end
end