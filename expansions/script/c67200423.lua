--术结天缘 忍苦魔精
function c67200423.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedureLevelFree(c,c67200423.mfilter,c67200423.xyzcheck,2,99)   
	--destroy & search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200423,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c67200423.sptg)
	e1:SetOperation(c67200423.spop)
	c:RegisterEffect(e1)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200423,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetTarget(c67200423.thtg)
	e3:SetOperation(c67200423.copyop)
	c:RegisterEffect(e3)
	--leave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67200423,3))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c67200423.pencon)
	e5:SetTarget(c67200423.pentg)
	e5:SetOperation(c67200423.penop)
	c:RegisterEffect(e5) 
end
--
function c67200423.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and c:IsXyzType(TYPE_PENDULUM)
end
function c67200423.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
--
function c67200423.filter(c)
	return c:IsType(TYPE_XYZ) and c:IsType(TYPE_PENDULUM)
end
function c67200423.deckfilter(c)
	return c:IsSetCard(0x5671)
end
function c67200423.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.IsExistingMatchingCard(c67200423.deckfilter,tp,LOCATION_DECKBOT,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c67200423.filter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200423.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g==0 then return end
	local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
	Duel.MoveSequence(tc,0)
	Duel.ConfirmDecktop(tp,1)
	Duel.MoveSequence(tc,1)
	if tc:IsSetCard(0x5671) then
		if not c:IsRelateToEffect(e) then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200423,4))
		local gg=Duel.SelectMatchingCard(tp,c67200423.filter,tp,LOCATION_GRAVE,0,1,2,nil,c)
		Duel.Overlay(c,gg)
	end
end
--
function c67200423.filter2(c,e)
	return c:IsType(TYPE_XYZ) and c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_OVERLAY)
end
function c67200423.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:GetCount()>0 end
	local g=og:FilterSelect(tp,c67200423.filter2,1,1,nil,e)
	Duel.SetTargetCard(g)
end
function c67200423.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and c:IsFaceup() then
		local code=tc:GetOriginalCode()
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	end
end
--
function c67200423.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c67200423.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200423.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end


