--龙源机兵 红莲零
function c12057825.initial_effect(c) 
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),aux.Tuner(nil),nil,aux.NonTuner(nil),2,99)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--cannot release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12057825,1))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,12057825)
	e4:SetCondition(c12057825.discon)
	e4:SetTarget(c12057825.distg)
	e4:SetOperation(c12057825.disop)
	c:RegisterEffect(e4)   
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(12057825,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,22057825)
	e5:SetCondition(c12057825.atkcon2)
	e5:SetCost(c12057825.atkcost2)
	e5:SetOperation(c12057825.atkop2)
	c:RegisterEffect(e5) 
end
function c12057825.discon(e,tp,eg,ep,ev,re,r,rp) 
	return (bit.band(re:GetCategory(),CATEGORY_REMOVE)~=0 or bit.band(re:GetCategory(),CATEGORY_TOGRAVE)~=0) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)  
end
function c12057825.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c12057825.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev) 
	if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(12057825,0)) then 
	local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil) 
	Duel.SendtoHand(dg,nil,REASON_EFFECT) 
	end 
end
function c12057825.atkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(12057825)==0 end
	c:RegisterFlagEffect(12057825,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c12057825.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and a:GetControler()~=d:GetControler() 
end
function c12057825.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget() 
	local sc,tc=Duel.GetBattleMonster(tp)
	if a:IsFaceup() and a:IsRelateToBattle() and d:IsFaceup() and d:IsRelateToBattle() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)   
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(0) 
		e3:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e3) 
		local e4=e3:Clone() 
		e4:SetCode(EFFECT_SET_DEFENSE_FINAL) 
		tc:RegisterEffect(e4) 
	end
end






