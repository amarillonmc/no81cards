--恐啡肽狂龙·无限制钉状压制
function c43990244.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--act in set turn
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(43990244,0))
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e10:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e10:SetCondition(c43990244.actcon)
	c:RegisterEffect(e10)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)--TIMING_END_PHASE
	e1:SetDescription(aux.Stringid(43990244,0))
	e1:SetCategory(CATEGORY_SSET+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,43990244)
	e1:SetTarget(c43990244.settg)
	e1:SetOperation(c43990244.setop)
	c:RegisterEffect(e1)
	--Trap activate in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990244,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x173))
	c:RegisterEffect(e2)
	--[[--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c43990244.immcon)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x173))
	e3:SetValue(c43990244.immval)
	c:RegisterEffect(e3)]]
	--negate damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e4:SetCountLimit(1,43990244+1)
	e4:SetCondition(c43990244.damcon1)
	e4:SetCost(c43990244.damcost)
	e4:SetOperation(c43990244.damop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetCondition(c43990244.damcon2)
	c:RegisterEffect(e5)
end
function c43990244.actfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsFaceupEx()
end
function c43990244.actcon(e)
	return Duel.IsExistingMatchingCard(c43990244.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE+0x10,0,1,nil)
end
function c43990244.setfilter(c)
	return c:IsSetCard(0x173) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c43990244.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990244.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c43990244.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c43990244.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if not sc or Duel.SSet(tp,sc)==0 or not Duel.SelectYesNo(tp,aux.Stringid(43990244,2)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.HintSelection(dg)
	Duel.Destroy(dg,REASON_EFFECT)
end
function c43990244.immcon(e)
	return Duel.GetLP(e:GetHandlerPlayer())<=2000
end
function c43990244.immval(e,re)
	return re:IsActivated() and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c43990244.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000 and rp~=tp
end
function c43990244.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000 and Duel.GetBattleDamage(tp)>0
end
function c43990244.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c43990244.damop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
