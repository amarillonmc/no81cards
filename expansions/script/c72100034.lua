--光の巨人 银河酱
function c72100034.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),4)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c72100034.mtop)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c72100034.immcon)
	e1:SetValue(c72100034.efilter)
	c:RegisterEffect(e1)
	-----
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e3:SetCode(EVENT_CHAIN_SOLVING)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCondition(c72100034.negcon)  
	e3:SetOperation(c72100034.negop)  
	c:RegisterEffect(e3)
end
function c72100034.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,10000) then
		Duel.PayLPCost(tp,10000)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
-----
function c72100034.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c72100034.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true
	else return te:IsActiveType(TYPE_LINK) and te:IsActivated() and te:GetOwner()~=e:GetOwner() end
end
------
function c72100034.cfilter(c)  
	return c:IsFaceup()
end  
function c72100034.negcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetFlagEffect(72100034)==0 and (re:IsActiveType(TYPE_MONSTER)) and rp~=tp and Duel.IsChainDisablable(ev) and Duel.IsExistingMatchingCard(c72100034.cfilter,tp,LOCATION_MZONE,0,1,nil)
end  
function c72100034.negop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then  
		Duel.Hint(HINT_CARD,0,72100034)   
		if Duel.NegateEffect(ev) then  
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)  
		end  
	end  
end 