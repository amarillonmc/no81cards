--SWEEP·特种干员-红
function c79029038.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79029038)
	e1:SetCondition(c79029038.discon)
	e1:SetCost(c79029038.discost)
	e1:SetTarget(c79029038.distg)
	e1:SetOperation(c79029038.disop)
	c:RegisterEffect(e1)
end
function c79029038.cfilter(c)
	return c:IsSetCard(0xa900)
end
function c79029038.discon(e,tp,eg,ep,ev,re,r,rp)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	local ex3,g3,gc3,dp3,dv3=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	local ex4=re:IsHasCategory(CATEGORY_DRAW)
	local ex5=re:IsHasCategory(CATEGORY_SEARCH)
	local ex6=re:IsHasCategory(CATEGORY_DECKDES)
	return ((ex2 and bit.band(dv2,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED)==LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED)
		or (ex3 and bit.band(dv3,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED)==LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED)
		or ex4 or ex5 or ex6) and Duel.IsChainDisablable(ev) and Duel.IsExistingMatchingCard(c79029038.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end  
function c79029038.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c79029038.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c79029038.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	Duel.Destroy(eg,REASON_EFFECT)
end