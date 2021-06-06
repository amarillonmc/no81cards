--卡西米尔·特种干员-砾
function c79029016.initial_effect(c)
	--end battle phase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029016.condition)
	e1:SetCost(c79029016.cost)
	e1:SetOperation(c79029016.operation)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029016,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c79029016.negcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029016.negtg)
	e2:SetOperation(c79029016.negop)
	c:RegisterEffect(e2)
end
function c79029016.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return tp~=Duel.GetTurnPlayer() and at and at:IsFaceup() and at:IsSetCard(0xa900)
end
function c79029016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c79029016.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	Debug.Message("鼠群，聚集起来吧！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029016,1))
	end
end
function c79029016.tfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0xa900)
end
function c79029016.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c79029016.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c79029016.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c79029016.negop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("我是你的影子。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029016,2))
	Duel.NegateEffect(ev)
end






