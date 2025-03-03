--炎志灼心 姜维
local s,id,o=GetID()
function s.initial_effect(c)
	--leave field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCondition(s.lvcon)
	e1:SetTarget(s.lvtg)
	e1:SetOperation(s.lvop)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.ctltg)
	e2:SetOperation(s.ctlop)
	c:RegisterEffect(e2)
end
function s.lvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT)
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsPreviousControler(tp) or rp==tp then
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,1))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_ACTIVATE_COST)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(0,1)
		e2:SetTarget(s.actarget)
		e2:SetCost(s.costchk)
		e2:SetOperation(s.costop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
	if not c:IsPreviousControler(tp) or rp==1-tp then
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,2))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVING)
		e3:SetCondition(s.discon)
		e3:SetOperation(s.disop)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.actarget(e,te,tp)
	return true
end
function s.cfilter(c,ctype)
	return c:IsType(ctype) and c:IsAbleToGraveAsCost()
end
function s.costchk(e,te,tp)
	local tc=te:GetHandler()
	local ctype=tc:GetType()&0x7
	e:SetLabelObject(tc)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,tc,ctype)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local tc=e:GetLabelObject()
	local ctype=tc:GetType()&0x7
	local cg=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,tc,ctype)
	Duel.SendtoGrave(cg,REASON_COST)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	local first=g:GetFirst()
	for tc in aux.Next(g) do
		if tc:GetSequence()>first:GetSequence() then first=tc end
	end
	return first and first:GetType()&0x7==rc:GetType()&0x7
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.NegateEffect(ev)
end
function s.ctltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.GetControl(c,1-tp)
	end
end