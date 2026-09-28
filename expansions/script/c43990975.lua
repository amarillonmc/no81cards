--
function c43990975.initial_effect(c)
	 --fusion
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,{43990972,43990987},aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),2,true,true)
	aux.AddContactFusionProcedure(c,c43990975.mfilter,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,aux.ContactFusionSendToDeck(c)):SetCountLimit(1,43990975+EFFECT_COUNT_CODE_OATH)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c43990975.negcon)
	e1:SetOperation(c43990975.negop)
	c:RegisterEffect(e1)
end
function c43990975.mfilter(c)
	return (c:IsFusionCode(43990972,43990987) or c:IsRace(RACE_FIEND) and c:IsType(TYPE_MONSTER))
		and c:IsAbleToDeckOrExtraAsCost() and (c:IsFaceupEx() or c:IsOnField())
end
function c43990975.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ((re:GetActivateLocation()&LOCATION_ONFIELD)==0 and not re:IsHasType(EFFECT_TYPE_ACTIVATE)) and rp~=tp and Duel.IsChainDisablable(ev) and e:GetHandler():GetFlagEffect(43990975)==0
end
function c43990975.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(43990975,2)) then
		Duel.Hint(HINT_CARD,0,43990975)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(43990975,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
