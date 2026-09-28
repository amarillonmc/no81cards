--祓魔侠客
function c43990973.initial_effect(c)
	 --fusion
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,{43990974,43990987},aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),2,true,true)
	aux.AddContactFusionProcedure(c,c43990973.mfilter,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,aux.ContactFusionSendToDeck(c)):SetCountLimit(1,43990973+EFFECT_COUNT_CODE_OATH)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990973,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(c43990973.dscon)
	e1:SetTarget(c43990973.dstg)
	e1:SetOperation(c43990973.dsop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
end
function c43990973.mfilter(c)
	return (c:IsFusionCode(43990974,43990987) or c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER))
		and c:IsAbleToDeckOrExtraAsCost() and (c:IsFaceupEx() or c:IsOnField())
end
function c43990973.dscon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetCurrentChain()==0
end
function c43990973.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function c43990973.dsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
