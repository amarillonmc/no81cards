--向空挥拳！
function c33703032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c33703032.condition)
	e1:SetTarget(c33703032.target)
	e1:SetOperation(c33703032.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c33703032.handcon)
	c:RegisterEffect(e2)
end
function c33703032.condition(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
		and not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,2,e:GetHandler())) then return false end
	for i=1,ev do
		if Duel.IsChainDisablable(i) then return true end
	end
	return false
end
function c33703032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if Duel.IsChainNegatable(i) then dg:AddCard(te:GetHandler()) end
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,dg,dg:GetCount(),0,0)
end
function c33703032.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for i=1,ev do Duel.NegateEffect(i) end
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	for sc in aux.Next(sg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK_FINAL)
		e1:SetValue(5000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE_FINAL)
		sc:RegisterEffect(e2)
	end
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then
		local tg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(tg) do
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e3:SetValue(c33703032.efilter)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			tc:RegisterEffect(e3)
		end
	end
	if Duel.GetTurnPlayer()==tp then
		Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e4=Effect.CreateEffect(c)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_BP)
		e4:SetTargetRange(1,0)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
function c33703032.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end
function c33703032.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1
		and not Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,2,nil)
end
