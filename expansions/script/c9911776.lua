--操偶狩人-黑瞳
function c9911776.initial_effect(c)
	--control / disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9911776.rmcost)
	e1:SetTarget(c9911776.rmtg)
	e1:SetOperation(c9911776.rmop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9911776.settg)
	e2:SetOperation(c9911776.setop)
	c:RegisterEffect(e2)
end
function c9911776.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9911776.rmfilter(c,tp)
	local ct=math.floor(c:GetAttack()/400)
	if not (c:IsFaceup() and c:IsType(TYPE_EFFECT) and ct>0) then return false end
	local g=Duel.GetDecktopGroup(tp,ct)
	local b1=Duel.GetTurnPlayer()==tp and c:IsControlerCanBeChanged()
	local b2=Duel.GetTurnPlayer()~=tp and not c:IsDisabled()
	return g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==ct and (b1 or b2)
end
function c9911776.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c9911776.rmfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9911776.rmfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c9911776.rmfilter,tp,0,LOCATION_MZONE,1,1,nil,tp):GetFirst()
	local ct=math.floor(tc:GetAttack()/400)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct,tp,LOCATION_DECK)
	if Duel.GetTurnPlayer()==tp then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_CONTROL)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
	else
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
	end
end
function c9911776.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ct=math.floor(tc:GetAttack()/400)
	if tc:IsRelateToChain() and tc:IsFaceup() and ct>0 then
		local dt=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		if dt==0 then return end
		if dt>ct then dt=ct end
		local g=Duel.GetDecktopGroup(tp,dt)
		Duel.DisableShuffleCheck()
		if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)==0 then return end
		if Duel.GetTurnPlayer()==tp and tc:IsRelateToChain() then
			Duel.GetControl(tc,tp,PHASE_END,1)
		end
		if Duel.GetTurnPlayer()~=tp and tc:IsRelateToChain() and tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
function c9911776.setfilter(c)
	return c:IsCode(9911777) and c:IsSSetable()
end
function c9911776.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911776.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9911776.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9911776.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
