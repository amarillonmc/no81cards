--渊灵-灭世黑莲
function c10200042.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetDescription(aux.Stringid(10200042,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(c10200042.descon)
	e1:SetTarget(c10200042.destg)
	e1:SetOperation(c10200042.desop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200042,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10200042)
	e2:SetTarget(c10200042.settg)
	e2:SetOperation(c10200042.setop)
	c:RegisterEffect(e2)
end
function c10200042.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()--Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c10200042.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10200042)==0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200042.desop(e,tp,eg,ep,ev,re,r,rp)
	--destroy
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
	--immune
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetTargetRange(LOCATION_ONFIELD,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe21))
	e0:SetValue(c10200042.efilter)
	if Duel.GetCurrentPhase()==PHASE_MAIN1 then
		e0:SetReset(RESET_PHASE+PHASE_MAIN1)
		Duel.RegisterFlagEffect(tp,10200042,RESET_PHASE+PHASE_MAIN1,0,1)
	else
		e0:SetReset(RESET_PHASE+PHASE_MAIN2)
		Duel.RegisterFlagEffect(tp,10200042,RESET_PHASE+PHASE_MAIN2,0,1)
	end
	Duel.RegisterEffect(e0,tp)
	--reg
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c10200042.regcon)
	e1:SetOperation(c10200042.regop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10200042.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function c10200042.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,0xe21)
		--and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c10200042.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_EXTRA)
	if #g==0 then return end
	Duel.Hint(HINT_CARD,0,10200042)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:Select(tp,1,1,nil)
	Duel.Destroy(dg,REASON_EFFECT)
end
function c10200042.setfilter(c,tp)
	return c:IsCode(10200018) and c:IsType(TYPE_FIELD) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c10200042.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200042.setfilter,tp,LOCATION_DECK+0x10,0,1,1,nil,tp) end
end
function c10200042.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10200042.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
