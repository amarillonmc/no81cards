--乌萨斯·先锋干员-凛冬
function c79029021.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029021,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c79029021.atkcost)
	e1:SetTarget(c79029021.atktg)
	e1:SetOperation(c79029021.atkop)
	c:RegisterEffect(e1)
	--level down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029021,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029021)
	e2:SetCondition(c79029021.spcon)
	e2:SetOperation(c79029021.operation)
	c:RegisterEffect(e2)
end
function c79029021.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa903)
end
function c79029021.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029021.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029021.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c79029021.atkop(e,tp,eg,ep,ev,re,r,rp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_BATTLE_DESTROYING)
		e3:SetProperty(EFFECT_FLAG_DELAY)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetCondition(c79029021.condition)
		e3:SetOperation(c79029021.op)
		e:GetHandler():RegisterEffect(e3)
	local g=Duel.GetMatchingGroup(c79029021.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(500)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)
		tc=g:GetNext()
	end
end
function c79029021.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	return tc:IsRelateToBattle() and tc:IsStatus(STATUS_OPPO_BATTLE) and tc:IsControler(tp) and tc:IsSetCard(0xa903)
		and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE)
end
function c79029021.op(e,tp,eg,ep,ev,re,r,rp)
		  e:GetHandler():AddCounter(0x1099,1)
	end
function c79029021.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCounter(0x1099)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_MAIN2 and g>0
end
function c79029021.operation(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetHandler():GetCounter(0x1099)
	if chk==0 then return Card.IsCanRemoveCounter(e:GetHandler(),tp,0x1099,x,REASON_COST) end
	e:GetHandler():RemoveCounter(e:GetHandler(),tp,0x1099,x,REASON_COST)
	local c=e:GetHandler()
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0):Filter(Card.IsLevelAbove,nil,1)
	local tc=hg:GetFirst()
	while tc do
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_UPDATE_LEVEL)
		e5:SetValue(-x)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e5)
		tc=hg:GetNext()
	end
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_TO_HAND)
	e6:SetReset(RESET_PHASE+PHASE_END)
	e6:SetOperation(c79029021.hlvop)
	Duel.RegisterEffect(e6,tp)
end
function c79029021.hlvfilter(c,tp)
	return c:IsLevelAbove(1) and c:IsControler(tp)
end
function c79029021.hlvop(e,tp,eg,ep,ev,re,r,rp)
	local hg=eg:Filter(c79029021.hlvfilter,nil,tp)
	local tc=hg:GetFirst()
	while tc do
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_UPDATE_LEVEL)
		e7:SetValue(-x)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e7)
		tc=hg:GetNext()
	end
end
