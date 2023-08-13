--黑 影 之 源
local m=64600101
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,53129443)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c64600101.condition)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(64600101,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,64600101)
	e3:SetCost(c64600101.thcost)
	e3:SetTarget(c64600101.thtg)
	e3:SetOperation(c64600101.thop)
	c:RegisterEffect(e3)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64600101,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,64610101)
	e2:SetCondition(c64600101.chcon)
	e2:SetTarget(c64600101.rectg)
	e2:SetOperation(c64600101.recop)
	c:RegisterEffect(e2)
end
function c64600101.condition(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c64600101.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c64600101.thfilter(c)
	return (aux.IsCodeListed(c,53129443) or c:IsCode(43487744)) and not c:IsCode(64600101) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c64600101.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64600101.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
end
function c64600101.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c64600101.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	end
end
function c64600101.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT) and not c:GetReasonEffect():IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
function c64600101.chcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c64600101.cfilter,1,nil)
end
function c64600101.recfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,53129443)
end
function c64600101.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local Rec=Duel.GetMatchingGroupCount(c64600101.recfilter,tp,LOCATION_GRAVE,0,nil)*500
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(Rec)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,Rec)
end
function c64600101.recop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local Rec=Duel.GetMatchingGroupCount(c64600101.recfilter,tp,LOCATION_GRAVE,0,nil)*500
	Duel.Recover(p,Rec,REASON_EFFECT)
end

