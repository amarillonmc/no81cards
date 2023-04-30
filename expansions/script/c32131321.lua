--浮生的战士 华
function c32131321.initial_effect(c)
	aux.AddCodeList(c,32131320)
	aux.AddMaterialCodeList(c,32131320)
	--code
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_ADD_CODE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE) 
	e0:SetRange(0xff) 
	e0:SetValue(32131320) 
	c:RegisterEffect(e0)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,32131320),aux.NonTuner(nil),1)
	c:EnableReviveLimit()   
	--cannot be target
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	--e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e1:SetRange(LOCATION_MZONE)
	--e1:SetValue(1)
	--e1:SetCondition(c32131321.indcon) 
	--c:RegisterEffect(e1)  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	e1:SetCondition(c32131321.indcon) 
	c:RegisterEffect(e1)
	--atk up 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,32131321) 
	e2:SetTarget(c32131321.aptg) 
	e2:SetOperation(c32131321.apop) 
	c:RegisterEffect(e2) 
end
c32131321.SetCard_HR_flame13=true 
c32131321.HR_Flame_CodeList=32131320   
function c32131321.ckfil(c) 
	return c:IsFaceup() and c.SetCard_HR_flame13   
end 
function c32131321.indcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c32131321.ckfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
end 
function c32131321.aptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end 
end 
function c32131321.apop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
	local x=g:GetCount()
	if x>0 and c:IsRelateToEffect(e) and c:IsFaceup() then 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(100*x) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
	c:RegisterEffect(e1) 
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
	c:RegisterEffect(e2)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
	c:RegisterEffect(e2)
	end 
end 






