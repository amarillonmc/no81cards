--判决牢狱的欺瞒 椋原一威
function c19209575.initial_effect(c)
	aux.AddCodeList(c,19209559)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2,c19209575.ovfilter,aux.Stringid(19209575,0),2,c19209575.xyzop)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c19209575.setcon)
	e1:SetTarget(c19209575.settg)
	e1:SetOperation(c19209575.setop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(c19209575.rmcon)
	e2:SetTarget(c19209575.rmtg)
	e2:SetOperation(c19209575.rmop)
	c:RegisterEffect(e2)
	--change name
	aux.EnableChangeCode(c,19209531,LOCATION_PZONE)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c19209575.discon)
	e3:SetOperation(c19209575.disop)
	c:RegisterEffect(e3)
end
function c19209575.cfilter(c)
	return c:IsSetCard(0xb51) and c:IsDiscardable()
end
function c19209575.ovfilter(c)
	return c:GetLeftScale()%2==1 and c:IsFaceup()
end
function c19209575.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,19209575)==0 and Duel.IsExistingMatchingCard(c19209575.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c19209575.cfilter,1,1,REASON_COST+REASON_DISCARD)
	Duel.RegisterFlagEffect(tp,19209575,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c19209575.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c19209575.setfilter(c)
	return c:GetLeftScale()%2==1 and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c19209575.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209575.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c19209575.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c19209575.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if not tc then return end
		if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
			tc:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
	end
end
function c19209575.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_PZONE)
end
function c19209575.rmfilter(c)
	return c:IsCode(19209559) and c:IsFaceupEx() and c:IsAbleToRemove()
end
function c19209575.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c19209575.rmfilter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c19209575.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c19209575.rmfilter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c19209575.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev) and ep~=tp
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.GetFlagEffect(tp,19209575)<2
end
function c19209575.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectEffectYesNo(tp,e:GetHandler()) then return end
	Duel.RegisterFlagEffect(tp,19209575,RESET_PHASE+PHASE_END,0,1)
	if not Duel.NegateEffect(ev) then return end
	Duel.BreakEffect()
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
