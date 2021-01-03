function c82221053.initial_effect(c)  
	--pendulum summon  
	aux.EnablePendulumAttribute(c,false) 
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunFun(c,c82221053.mfilter,c82221053.mfilter2,2,false)
	aux.AddContactFusionProcedure(c,c82221053.mfilter2,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,0,Duel.Remove,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL)  
	--spsummon condition  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)  
	c:RegisterEffect(e1) 
	--negate  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82221053,0))  
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)  
	e2:SetCode(EVENT_CHAINING)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e2:SetCountLimit(1)  
	e2:SetCondition(c82221053.negcon)  
	e2:SetCost(c82221053.negcost)  
	e2:SetTarget(c82221053.negtg)  
	e2:SetOperation(c82221053.negop)  
	c:RegisterEffect(e2)  
	--indestructable  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e3:SetCondition(c82221053.indcon)  
	e3:SetValue(1)  
	c:RegisterEffect(e3)  
	local e4=e3:Clone()  
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	c:RegisterEffect(e4)  
	--pendulum  
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(82221053,1))  
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e5:SetCode(EVENT_DESTROYED)  
	e5:SetProperty(EFFECT_FLAG_DELAY)  
	e5:SetCondition(c82221053.pencon)  
	e5:SetTarget(c82221053.pentg)  
	e5:SetOperation(c82221053.penop)  
	c:RegisterEffect(e5)  
	--pindes
	local e6=Effect.CreateEffect(c)  
	e6:SetType(EFFECT_TYPE_SINGLE)  
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e6:SetRange(LOCATION_PZONE)  
	e6:SetCode(EFFECT_INDESTRUCTABLE_COUNT)  
	e6:SetCountLimit(1)  
	e6:SetValue(c82221053.valcon)  
	c:RegisterEffect(e6)  
end 
 
function c82221053.mfilter(c)  
	return c:IsAbleToRemoveAsCost() and (c:IsFusionSetCard(0x98) or c:IsFusionSetCard(0x99) or c:IsFusionSetCard(0x9f)) and c:IsFusionType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end  
function c82221053.mfilter2(c)  
	return c:IsAbleToRemoveAsCost() and c:IsFusionType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_ONFIELD) or c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end   
function c82221053.negcon(e,tp,eg,ep,ev,re,r,rp)  
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)  
end  
function c82221053.cfilter(c)  
	return c:IsFaceup() and (c:IsSetCard(0x9f) or c:IsSetCard(0x98) or c:IsSetCard(0x99)) and c:IsAbleToRemoveAsCost()  
end  
function c82221053.negcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221053.cfilter,tp,LOCATION_EXTRA,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,c82221053.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)  
	Duel.Remove(g,POS_FACEUP,REASON_COST)  
end  
function c82221053.negtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return re:GetHandler():IsAbleToRemove() end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)  
	end  
end  
function c82221053.negop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then  
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)  
	end  
end  
function c82221053.indfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0xf2)  
end  
function c82221053.indcon(e)  
	return Duel.IsExistingMatchingCard(c82221053.indfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)  
end  
function c82221053.pencon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()  
end  
function c82221053.pentg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end  
end  
function c82221053.penop(e,tp,eg,ep,ev,re,r,rp)  
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)  
	end  
end  
function c82221053.valcon(e,re,r,rp)  
	return bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetHandlerPlayer()
end  