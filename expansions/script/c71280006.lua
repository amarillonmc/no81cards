--闪光无力化
function c71280006.initial_effect(c)
	aux.AddCodeList(c,2061963)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c71280006.condition1)
	e1:SetTarget(c71280006.target)
	e1:SetOperation(c71280006.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c71280006.condition2)
	e2:SetOperation(c71280006.activate2)
	c:RegisterEffect(e2)
end
function c71280006.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c71280006.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.IsExistingMatchingCard(c71280006.sprfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c71280006.sprfilter(c)
	return c:IsFaceup() and (c:IsCode(2061963) or aux.IsCodeListed(c,2061963) or c:IsCode(49456901) or c:IsCode(98920929)) and c:IsType(TYPE_MONSTER)
end
function c71280006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c71280006.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToEffect(e) and Duel.NegateAttack() then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		local atk=tc:GetAttack()
		if atk>0 then Duel.Damage(tp,math.floor(atk/2),REASON_EFFECT) end
	end
end
function c71280006.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToEffect(e) and Duel.NegateAttack() then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		local atk=tc:GetAttack()
		if atk>0 then Duel.Recover(tp,math.floor(atk/2),REASON_EFFECT) end
	end
end