--薪焰之理
function c43990976.initial_effect(c)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,{43990982,43990987},aux.FilterBoolFunction(Card.IsRace,RACE_ILLUSION),2,true,true)
	aux.AddContactFusionProcedure(c,c43990976.mfilter,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,aux.ContactFusionSendToDeck(c)):SetCountLimit(1,43990976+EFFECT_COUNT_CODE_OATH)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c43990976.negcon)
	e1:SetOperation(c43990976.negop)
	c:RegisterEffect(e1)
end
function c43990976.mfilter(c)
	return (c:IsFusionCode(43990982,43990987) or c:IsRace(RACE_ILLUSION) and c:IsType(TYPE_MONSTER))
		and c:IsAbleToDeckOrExtraAsCost() and (c:IsFaceupEx() or c:IsOnField())
end
function c43990976.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
		and e:GetHandler():GetFlagEffect(43990976)==0
end
function c43990976.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(43990976,2)) then
		Duel.Hint(HINT_CARD,0,43990976)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(43990976,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
