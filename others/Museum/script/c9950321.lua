--白丝之蕾咪
function c9950321.initial_effect(c)
	 --negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCountLimit(1,9950321)
	e1:SetCost(aux.bfgcost)
	e1:SetCondition(c9950321.discon)
	e1:SetTarget(c9950321.distg)
	e1:SetOperation(c9950321.disop)
	c:RegisterEffect(e1)
 --send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950321,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c9950321.target)
	e1:SetOperation(c9950321.operation)
	c:RegisterEffect(e1)
end
function c9950321.discon(e,tp,eg,ep,ev,re,r,rp)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	local ex3,g3,gc3,dp3,dv3=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	local ex4=re:IsHasCategory(CATEGORY_DRAW)
	local ex5=re:IsHasCategory(CATEGORY_SEARCH)
	local ex6=re:IsHasCategory(CATEGORY_DECKDES)
	return ((ex2 and bit.band(dv2,LOCATION_DECK)==LOCATION_DECK)
		or (ex3 and bit.band(dv3,LOCATION_DECK)==LOCATION_DECK)
		or ex4 or ex5 or ex6) and Duel.IsChainDisablable(ev)
end
function c9950321.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c9950321.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c9950321.tgfilter(c)
	return c:IsLevelAbove(5) and c:IsAbleToGrave()
end
function c9950321.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950321.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9950321.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9950321.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end