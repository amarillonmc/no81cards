--重兵装型女子高生・出击
function c67670314.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67670314,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,67670314)
	e1:SetCondition(c67670314.discon)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(c67670314.disop)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67670314,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,67670314)
	e2:SetCondition(c67670314.limcon)
	e2:SetTarget(c67670314.limtg)
	e2:SetOperation(c67670314.limop)
	c:RegisterEffect(e2)
	--double damge
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67670314,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,67670314)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c67670314.operation)
	c:RegisterEffect(e3)
end
--Activate1
function c67670314.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1b7)
end
function c67670314.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(c67670314.cfilter,tp,LOCATION_REMOVED,0,nil):GetClassCount(Card.GetCode)>=6
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c67670314.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
	end
end
--Activate2
function c67670314.limcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(c67670314.cfilter,tp,LOCATION_REMOVED,0,nil):GetClassCount(Card.GetCode)>=13
end
function c67670314.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c67670314.chainlm)
end
function c67670314.chainlm(e,rp,tp)
	return tp==rp
end
function c67670314.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c67670314.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c67670314.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
--double damge
function c67670314.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c67670314.efftg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c67670314.efftg(e,c)
	return c:IsSetCard(0x1b7)
end
