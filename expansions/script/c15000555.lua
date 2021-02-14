local m=15000555
local cm=_G["c"..m]
cm.name="『蛇』缠罪"
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(aux.dscon)
	c:RegisterEffect(e0)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,15000555)
	e1:SetCondition(cm.negcon)
	e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
	--nooooooooooooooooooooooooo!
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(cm.nocon)
	e3:SetOperation(cm.noop)
	c:RegisterEffect(e3)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(cm.retcon)
	e4:SetCost(cm.cost)
	e4:SetOperation(cm.retop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_HAND,0)
	e5:SetTarget(cm.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function cm.tfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(cm.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,15000555)==0
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.RegisterFlagEffect(tp,15000555,RESET_PHASE+PHASE_END,0,1)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.sfilter(c,tp)
	return c:IsFacedown() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function cm.nocon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(cm.sfilter,1,nil,tp) and Duel.GetFlagEffect(tp,15000555)==0
end
function cm.noop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,2)) then
		Duel.Hint(HINT_CARD,0,15000555)
		Duel.RegisterFlagEffect(tp,15000555,RESET_PHASE+PHASE_END,0,1)
		if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST,nil) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetValue(cm.actlimit)
			e1:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)
end
function cm.eftg(e,c)
	return c:IsSetCard(0xf3b) and c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER)
end
function cm.swfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return Duel.IsExistingMatchingCard(cm.swfilter,tp,0,LOCATION_SZONE,1,nil) and Duel.GetFlagEffect(tp,15000550)==0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.RegisterFlagEffect(tp,15000550,RESET_PHASE+PHASE_END,0,1)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,cm.swfilter,tp,0,LOCATION_SZONE,1,1,nil):GetFirst()
	if tc:IsCanTurnSet() then
		tc:CancelToGrave()
		Duel.ChangePosition(tc,POS_FACEDOWN)
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end