local m=90700049
local cm=_G["c"..m]
cm.name="本我本源"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,90700049)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e1_tograve=Effect.CreateEffect(c)
	e1_tograve:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1_tograve:SetCode(EVENT_TO_GRAVE)
	e1_tograve:SetOperation(cm.activate)
	c:RegisterEffect(e1_tograve)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90700049,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.scost)
	e2:SetTarget(cm.stg)
	e2:SetOperation(cm.sop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(cm.reptg)
	e3:SetOperation(cm.repop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.rcon)
	e4:SetOperation(cm.rop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(cm.rgrcon)
	c:RegisterEffect(e5)
	local e5_assis=Effect.CreateEffect(c)
	e5_assis:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5_assis:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5_assis:SetCode(EVENT_TO_GRAVE)
	e5_assis:SetOperation(cm.regop)
	c:RegisterEffect(e5_assis)
end
function cm.actfilter(c)
	return c:IsSetCard(0x6312) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not (c:IsLocation(LOCATION_REMOVED+LOCATION_EXTRA) and c:IsPosition(POS_FACEDOWN))
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetType()==EFFECT_TYPE_ACTIVATE and (not e:GetHandler():IsRelateToEffect(e)) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.actfilter),tp,0x7d,0,nil,e,tp)
	if Duel.SelectYesNo(tp,aux.Stringid(90700049,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
	end
end
function cm.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.stgfilter(c)
	return c:IsSetCard(0x6312) and c:IsType(TYPE_MONSTER) and c:IsPosition(POS_FACEUP) and c:IsAbleToHand()
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.stgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.stgfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil)
	if g then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.repfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6312) and c:IsAbleToHand(REASON_EFFECT)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE) and (Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) or Duel.IsExistingMatchingCard(cm.repfilter,tp,LOCATION_MZONE,0,1,nil)) end
	return true
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(cm.repfilter,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT)
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(90700049,2),aux.Stringid(90700049,3))
	elseif b1 then
		op=0
	else
		op=1
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.repfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil,REASON_EFFECT)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(90700049,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function cm.rfilter(c)
	if c:IsSetCard(0x6312) and c:IsSummonType(SUMMON_TYPE_RITUAL) then
		return 1
	end
	return 0
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetSum(cm.rfilter)>0 and Duel.IsPlayerCanDraw(tp,1)
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.rgrcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0 and eg:GetSum(cm.rfilter)>0 and Duel.IsPlayerCanDraw(tp,1)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x6312) and tc:IsSummonType(SUMMON_TYPE_RITUAL) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(90700049,5))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetDescription(aux.Stringid(90700049,6))
			e2:SetCode(EFFECT_IMMUNE_EFFECT)
			e2:SetValue(cm.efilter)
			tc:RegisterEffect(e2)
		end
		tc=eg:GetNext()
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_HAND) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end