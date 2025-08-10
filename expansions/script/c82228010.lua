function c82228010.initial_effect(c)  
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_INSECT),2)
	--extra attack  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_EXTRA_ATTACK)  
	e1:SetValue(1)  
	c:RegisterEffect(e1)  
	--attack up  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228010,0))  
	e2:SetCategory(CATEGORY_ATKCHANGE)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)  
	e2:SetCondition(c82228010.atcon)  
	e2:SetOperation(c82228010.atop)  
	c:RegisterEffect(e2)  
	--negate  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82228010,1))  
	e3:SetCategory(CATEGORY_NEGATE)  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_CHAINING)  
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1)  
	e3:SetCondition(c82228010.discon) 
	e3:SetTarget(c82228010.distg)  
	e3:SetOperation(c82228010.disop)  
	c:RegisterEffect(e3)  
	--disable attack  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(82228010,2))  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCode(EVENT_ATTACK_ANNOUNCE) 
	e4:SetOperation(c82228010.daop) 
	e4:SetCountLimit(1)  
	e4:SetCondition(c82228010.dacon)  
	c:RegisterEffect(e4)  
end  

function c82228010.atcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsRelateToBattle()  
end  

function c82228010.atop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsFaceup() and c:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetValue(300)  
		e1:SetReset(RESET_EVENT+0x1ff0000)  
		c:RegisterEffect(e1)  
	end  
end 
 
function c82228010.discon(e,tp,eg,ep,ev,re,r,rp)  
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)  
end  

function c82228010.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
end  

function c82228010.disop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.NegateActivation(ev)  
end  
 
function c82228010.dacon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetAttacker():GetControler()~=tp
end  
function c82228010.daop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.NegateAttack()  
end  