--Am:End of a Miracle
function c33741094.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33741094,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c33741094.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RECOVER+CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33741094.target)
	e1:SetOperation(c33741094.activate)
	c:RegisterEffect(e1)
	--counter
	Duel.AddCustomActivityCounter(33741094,ACTIVITY_CHAIN,aux.FALSE)
end
function c33741094.handcon(e)
	return Duel.GetCustomActivityCount(33741094,1-e:GetHandlerPlayer(),ACTIVITY_CHAIN)>0
end
function c33741094.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(33741094,1-tp,ACTIVITY_CHAIN)>=7 end
end
function c33741094.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCustomActivityCount(33741094,1-tp,ACTIVITY_CHAIN)
	if ct>=7 then
		local t=Duel.GetTurnPlayer()~=tp and 2 or 1
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,t)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		Duel.RegisterEffect(e2,tp)
	end
	if ct>=13 then
		Duel.BreakEffect()
		local t=Duel.GetTurnPlayer()==tp and 2 or 1
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAINING)
		e3:SetOperation(c33741094.chainop)
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,t)
		Duel.RegisterEffect(e3,tp)
		--actlimit
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_ACTIVATE)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetTargetRange(0,1)
		e4:SetCondition(c33741094.actcon)
		e4:SetValue(1)
		e4:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,t)
		Duel.RegisterEffect(e4,tp)
	end
end
function c33741094.chainop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then Duel.SetChainLimit(c33741094.chainlm) end
end
function c33741094.chainlm(e,rp,tp)
	return tp==rp
end
function c33741094.actcon(e)
	local tc,_=Duel.GetBattleMonster(e:GetHandlerPlayer())
	return tc
end
