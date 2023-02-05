--降临的破械神
function c98921007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98921007)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c98921007.target)
	e1:SetOperation(c98921007.activate)
	c:RegisterEffect(e1)	
--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921007,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,80801744)
	e2:SetCondition(c98921007.spcon)
	e2:SetTarget(c98921007.sptg)
	e2:SetOperation(c98921007.spop)
	c:RegisterEffect(e2)
end
function c98921007.spfilter(c,e,tp)
	return c:IsSetCard(0x1130) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98921007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)	
	if chkc then return chkc:IsLocation(e:GetLabel()) and chkc:IsControler(tp) end
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<-1 then return false end
		local loc=LOCATION_ONFIELD
		if ft==0 then loc=LOCATION_MZONE end
		e:SetLabel(loc)
		return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,nil,e:GetHandler())
			and Duel.IsExistingMatchingCard(c98921007.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c98921007.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
	  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	  local g=Duel.SelectMatchingCard(tp,c98921007.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp)
	  local tg=g:GetFirst()
	  if tg and Duel.SpecialSummonStep(tg,0,tp,tp,false,false,POS_FACEUP) then
		  tg:RegisterFlagEffect(98921007,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		  e1:SetCode(EVENT_PHASE+PHASE_END)
		  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		  e1:SetCondition(c98921007.descon)
		  e1:SetOperation(c98921007.desop)
		  e1:SetReset(RESET_PHASE+PHASE_END,2)
		  e1:SetCountLimit(1)
		  e1:SetLabel(Duel.GetTurnCount())
		  e1:SetLabelObject(tg)
		  Duel.RegisterEffect(e1,tp)
	   end
	   Duel.SpecialSummonComplete()	   
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e1:SetTargetRange(1,0)
	   e1:SetTarget(c98921007.splimit)
	   e1:SetReset(RESET_PHASE+PHASE_END,2)
	   Duel.RegisterEffect(e1,tp)	
   end
end
function c98921007.splimit(e,c)
	return not c:IsRace(RACE_FIEND)
end
function c98921007.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(98921007)~=0
end
function c98921007.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c98921007.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c98921007.spfilter1(c,e,tp)
	return c:IsSetCard(0x130) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98921007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98921007.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98921007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98921007.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end