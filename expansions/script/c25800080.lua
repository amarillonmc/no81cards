--指挥官2
function c25800080.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,c25800080.ffilter,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),2,true)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25800080,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,25800080)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c25800080.discon)
	e1:SetTarget(c25800080.distg)
	e1:SetOperation(c25800080.disop)
	c:RegisterEffect(e1)
end
function c25800080.ffilter(c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x211)
end
function c25800080.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c25800080.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c25800080.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
