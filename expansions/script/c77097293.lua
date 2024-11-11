--巨大的守护者
function c77097293.initial_effect(c) 
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1) 
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c) 
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO+TYPE_XYZ) end)
	e1:SetValue(1)
	c:RegisterEffect(e1)  
	--
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,77097293)
	e2:SetCondition(c77097293.atkcon)
	e2:SetTarget(c77097293.atktg)
	e2:SetOperation(c77097293.atkop)
	c:RegisterEffect(e2)
end
function c77097293.atkcon(e,tp,eg,ep,ev,re,r,rp) 
	local a,b=Duel.GetBattleMonster(tp)
	return a and a:IsCode(77097291) and Duel.GetLP(tp)<Duel.GetLP(1-tp) 
end 
function c77097293.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(77097291) end,tp,LOCATION_MZONE,0,1,nil) end
end
function c77097293.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsCode(77097291) end,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(tc:GetAttack()*2) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)  
		tc=g:GetNext() 
		end 
	end 
end 







