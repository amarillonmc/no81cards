local m=15005826
local cm=_G["c"..m]
cm.name="天翎渊的手割"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.actcon)
	e2:SetCost(cm.actcost)
	e2:SetTarget(cm.acttg)
	e2:SetOperation(cm.actop)
	c:RegisterEffect(e2)
end
function cm.thfilter(c,e,tp)
	return c:IsSetCard(0x5f43) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc,e,tp) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(cm.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function cm.pubfilter(c)
	return c:IsSetCard(0x5f43) and not c:IsPublic()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAbleToHand() then
		local b1=tc:IsAbleToHand()
		local res=false
		if b1 then
			res=Duel.SendtoHand(tc,nil,REASON_EFFECT)>0
		end
		if res and Duel.IsExistingMatchingCard(cm.pubfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			local pc=Duel.SelectMatchingCard(tp,cm.pubfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
			if pc then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetDescription(66)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				pc:RegisterEffect(e1)
			end
		end
	end
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function cm.actcostfilter(c)
	return c:IsDiscardable() and c:IsPublic()
end
function cm.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.actcostfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cm.actcostfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
	end
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=re:GetHandler()
	if Duel.NegateEffect(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		if Duel.SendtoHand(ec,nil,REASON_EFFECT)~=0 and ec:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetDescription(66)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			ec:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_ACTIVATE)
			e2:SetTargetRange(0,1)
			e2:SetValue(cm.aclimit)
			e2:SetLabel(ec:GetCode())
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end