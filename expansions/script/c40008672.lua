--魔妖转相
function c40008672.initial_effect(c)
	c:SetUniqueOnField(1,0,40008672)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c40008672.target)
	e1:SetOperation(c40008672.operation)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c40008672.ttarget)
	e2:SetOperation(c40008672.activate)
	c:RegisterEffect(e2)
end
function c40008672.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x121) and c:IsAbleToGrave()
end
function c40008672.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008672.tgfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c40008672.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c40008672.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c40008672.ttarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>0 end
end
function c40008672.activate(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	Duel.ConfirmCards(1-tp,cg)
	local tc=cg:GetFirst()
	while tc do
			local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_SETCODE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(0x121)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=cg:GetNext()
	end
end
