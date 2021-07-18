local m=15000800
local cm=_G["c"..m]
cm.name="耀的刻证兽"
function cm.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--stats up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf3d))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--SearchCard
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,15000800)
	e5:SetCost(cm.srcost)
	e5:SetTarget(cm.srtg)
	e5:SetOperation(cm.srop)
	c:RegisterEffect(e5)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
end
function cm.tdfilter(c,tp)
	return Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_DECK,0,1,nil,c:GetOriginalAttribute()) and c:IsAbleToDeckAsCost() and c:IsType(TYPE_MONSTER)
end
function cm.srfilter(c,att)
	return c:IsSetCard(0xf3d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetOriginalAttribute()~=att
end
function cm.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_HAND,0,1,nil,tp)
	end
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.SetTargetParam(g:GetFirst():GetOriginalAttribute())
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	local att=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if att==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_DECK,0,1,1,nil,att)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end