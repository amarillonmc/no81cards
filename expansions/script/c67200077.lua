--红月骑士 仙崎美来
function c67200077.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,67200053,67200054,true,true)
	--fusion success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200077,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c67200077.addct)
	e1:SetOperation(c67200077.addc)
	c:RegisterEffect(e1) 
	--def attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c67200077.atktg)
	e2:SetValue(1)
	c:RegisterEffect(e2)	
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200077,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,67200077)
	e3:SetCondition(c67200077.negcon)
	e3:SetCost(c67200077.negcost)
	e3:SetTarget(c67200077.negtg)
	e3:SetOperation(c67200077.negop)
	c:RegisterEffect(e3)
end
--
function c67200077.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,5,0,0x1673)
end
function c67200077.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1673,5)
	end
end
--def attack
function c67200077.atktg(e,c)
	return c:IsSetCard(0x5673)
end
--neg
function c67200077.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c67200077.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1673,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1673,2,REASON_COST)
end
function c67200077.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c67200077.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
