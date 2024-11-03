function c10111136.initial_effect(c)
	aux.AddCodeList(c,10111128)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111136,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10111136)
	e1:SetCondition(c10111136.spcon1)
	e1:SetCost(c10111136.cost)
	e1:SetTarget(c10111136.target)
	e1:SetOperation(c10111136.operation)
	c:RegisterEffect(e1)
    	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111136,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101111360)
	e2:SetCondition(c10111136.atkcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c10111136.atkop)
	c:RegisterEffect(e2)
    		--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,10111136)
	e3:SetTarget(c10111136.thtg2)
	e3:SetOperation(c10111136.thop2)
	c:RegisterEffect(e3)
    end
function c10111136.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf008) and c:IsFaceup()
end
function c10111136.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local ct2=Duel.GetMatchingGroupCount(c10111136.cfilter,tp,LOCATION_MZONE,0,nil)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local tc=re:GetHandler()
	return tc:IsControler(1-tp) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) and loc==LOCATION_MZONE 
		and ct2>0
end
function c10111136.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c10111136.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c10111136.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
		Duel.BreakEffect()
     	Duel.Damage(tp,1000,REASON_EFFECT,true)
	    Duel.Damage(1-tp,1000,REASON_EFFECT,true)
    	Duel.RDComplete()
end
function c10111136.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local c=Duel.GetAttackTarget()
	if not c then return false end
	if c:IsControler(1-tp) then c=Duel.GetAttacker() end
	return c and c:IsSetCard(0x8) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRelateToBattle()
end
function c10111136.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or a:IsFacedown() or not d:IsRelateToBattle() or d:IsFacedown() then return end
	if a:IsControler(1-tp) then a,d=d,a end
	if a:IsImmuneToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	e1:SetValue(d:GetAttack()+1000)
	a:RegisterEffect(e1)
end
function c10111136.thfilter2(c)
	return c:IsCode(10111128) and c:IsAbleToHand()
end
function c10111136.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111136.thfilter2,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c10111136.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10111136.thfilter2,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end