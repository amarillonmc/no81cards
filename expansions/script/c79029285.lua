--企鹅战法·且战且息
function c79029285.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,79029285)
	e1:SetCondition(c79029285.condition)
	e1:SetTarget(c79029285.target)
	e1:SetOperation(c79029285.activate)
	c:RegisterEffect(e1)	
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c79029285.handcon)
	c:RegisterEffect(e2)
	--re
	local e3=Effect.CreateEffect(c)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,09029285)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c79029285.reop)
	c:RegisterEffect(e3)
end
function c79029285.handcon(e)
	return Duel.GetLP(e:GetHandlerPlayer())<Duel.GetLP(1-e:GetHandlerPlayer())
end
function c79029285.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c79029285.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_GRAVE,1,nil) end
	local xg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToHand,tp,0,LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	Duel.SetTargetCard(g1)
	local atk=xg:GetSum(Card.GetAttack)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),0,0)
	if not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) then
	Duel.SetChainLimit(c79029285.chlimit)
	end
end
function c79029285.chlimit(e,ep,tp)
	return tp==ep
end
function c79029285.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:Filter(Card.IsControler,nil,tp)
	local tc2=g:Filter(Card.IsControler,nil,1-tp)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(tp,tc1)
	Duel.ConfirmCards(tp,tc2)
	Duel.BreakEffect()
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	Debug.Message("现在是休息时间吗？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029285,0))
end
function c79029285.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Debug.Message("报酬的话，这些足够了")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029285,1))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c79029285.damcon)
	e1:SetTarget(c79029285.damtg)
	e1:SetOperation(c79029285.damop)
	Duel.RegisterEffect(e1,tp)
end
function c79029285.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c79029285.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c79029285.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029285)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end





