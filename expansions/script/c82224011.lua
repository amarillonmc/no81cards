function c82224011.initial_effect(c)  
	--link summon  
	aux.AddLinkProcedure(c,c82224011.matfilter,3)  
	c:EnableReviveLimit()  
	--atkup  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e1:SetCode(EFFECT_UPDATE_ATTACK)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetValue(c82224011.atkval)  
	c:RegisterEffect(e1) 
	--extra att  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_EXTRA_ATTACK)  
	e2:SetValue(2)  
	c:RegisterEffect(e2) 
	 --negate  
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(82224011,0)) 
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)  
	e3:SetCode(EVENT_CHAINING)  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e3:SetCountLimit(3,82224011)  
	e3:SetCondition(c82224011.negcon)  
	e3:SetCost(c82224011.negcost)  
	e3:SetTarget(c82224011.negtg)  
	e3:SetOperation(c82224011.negop)  
	c:RegisterEffect(e3)
	--cannot diratk  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)  
	c:RegisterEffect(e4)  
end  
function c82224011.matfilter(c)  
	return c:GetSummonLocation()==LOCATION_EXTRA  
end  
function c82224011.atkval(e,c,tp)  
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):Filter(c82224011.atkfilter,e:GetHandler())  
	return g:GetSum(Card.GetBaseAttack)  
end  
function c82224011.atkfilter(c,e,tp)  
	return c:IsType(TYPE_LINK) and c:IsFaceup()
end  
function c82224011.negcon(e,tp,eg,ep,ev,re,r,rp)  
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and (Duel.GetCurrentPhase()==PHASE_BATTLE_START or Duel.GetCurrentPhase()==PHASE_BATTLE or Duel.GetCurrentPhase()==PHASE_BATTLE_STEP or Duel.GetCurrentPhase()==PHASE_DAMAGE)
end  
function c82224011.cfilter(c)  
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsType(TYPE_LINK) 
end  
function c82224011.negcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckReleaseGroup(tp,c82224011.cfilter,1,nil) end  
	local g=Duel.SelectReleaseGroup(tp,c82224011.cfilter,1,1,nil)  
	Duel.Release(g,REASON_COST)  
end  
function c82224011.negtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return re:GetHandler():IsAbleToRemove() end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)  
	end  
end  
function c82224011.negop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then  
		Duel.Destroy(eg,REASON_EFFECT)  
	end  
end  