--王棋之主
function c43990978.initial_effect(c)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,{43990985,43990987},aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),2,true,true)
	aux.AddContactFusionProcedure(c,c43990978.mfilter,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,aux.ContactFusionSendToDeck(c)):SetCountLimit(1,43990978+EFFECT_COUNT_CODE_OATH)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c43990978.negcon)
	e1:SetOperation(c43990978.negop)
	c:RegisterEffect(e1)
end
function c43990978.mfilter(c)
	return (c:IsFusionCode(43990985,43990987) or c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER))
		and c:IsAbleToDeckOrExtraAsCost() and (c:IsFaceupEx() or c:IsOnField())
end
function c43990978.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and ((re:GetActivateLocation()&LOCATION_ONFIELD)>0 or re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev)
		and e:GetHandler():GetFlagEffect(43990978)==0
end
function c43990978.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(43990978,2)) then
		Duel.Hint(HINT_CARD,0,43990978)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(43990978,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
