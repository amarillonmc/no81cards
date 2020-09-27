--最佳搭配Build 兔兔娘
function c72100030.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e3:SetCode(EVENT_CHAIN_SOLVING)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCondition(c72100030.negcon)  
	e3:SetOperation(c72100030.negop)  
	c:RegisterEffect(e3)  
end
--------
function c72100030.cfilter(c)  
	return c:IsFaceup()
end  
function c72100030.negcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetFlagEffect(72100030)==0 and (re:IsActiveType(TYPE_MONSTER)) and rp~=tp and Duel.IsChainDisablable(ev) and Duel.IsExistingMatchingCard(c72100030.cfilter,tp,LOCATION_MZONE,0,1,nil)
end  
function c72100030.negop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then  
		Duel.Hint(HINT_CARD,0,72100030)  
		e:GetHandler():RegisterFlagEffect(72100030,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)  
		if Duel.NegateEffect(ev) then  
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)  
		end  
	end  
end 
