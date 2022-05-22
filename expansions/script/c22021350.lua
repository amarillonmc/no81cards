--人理之诗 不可见的王之手
function c22021350.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,22021350+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(aux.dscon)
	e1:SetCost(c22021350.cost)
	e1:SetTarget(c22021350.target)
	e1:SetOperation(c22021350.activate)
	c:RegisterEffect(e1)
end
c22021350.effect_with_altria=true
function c22021350.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(22021350,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(HALF_DAMAGE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c22021350.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c22021350.filter2,tp,LOCATION_MZONE,0,1,c,c:GetAttack()) and c:IsSetCard(0xff9)
end
function c22021350.filter2(c,atk)
	return c:IsFaceup()
end
function c22021350.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22021350.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c22021350.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22021350.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c22021350.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local atk=tc:GetAttack()
	local g=Duel.GetMatchingGroup(c22021350.filter2,tp,LOCATION_MZONE,0,tc,atk)
	for sc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e1)
	end
end
