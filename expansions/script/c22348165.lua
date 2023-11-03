--洛 伊 德
local m=22348165
local cm=_G["c"..m]
function cm.initial_effect(c)
	--search 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348165,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c22348165.cost)
	e1:SetTarget(c22348165.target)
	e1:SetOperation(c22348165.operation)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c22348165.atklimit)
	c:RegisterEffect(e2)
	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c22348165.negcon)
	e6:SetOperation(c22348165.negop)
	c:RegisterEffect(e6)
	
end
function c22348165.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c22348165.filter(c)
	return aux.IsCodeListed(c,22348157) and c:IsType(TYPE_TUNER) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function c22348165.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348165.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22348165.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348165.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22348165.atklimit(e,c)
	return c~=e:GetHandler()
end
function c22348165.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return (g and #g>0) and rp==1-tp and not g:IsContains(c) and Duel.IsChainDisablable(ev)
end
function c22348165.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22348165)
	Duel.NegateEffect(ev)
end
