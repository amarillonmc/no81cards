--大灾变
local cm,m,o=GetID()
function cm.initial_effect(c)
   local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.ntcon)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
 local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m+1000)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_EXTRA,0,1,nil,tp,sg)
	end
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp,sg)
	local sc=g:GetFirst()
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil):GetFirst()
	Duel.Overlay(g2,sc) --妥协实现，效果不变
	e:SetLabelObject(sc)
	Duel.SendtoDeck(sc,1-tp,nil,REASON_EFFECT)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.thfilter(c,tp,g)

	return c:IsSetCard(0xe09) and g:IsExists(cm.exifilter,1,nil,c)
end
function cm.exifilter(c,tc)
	local typec=c:GetAttribute()
	local typetc=tc:GetAttribute()
	return bit.band(typec,typetc)~=0
end
function cm.thfilter2(c,att)
	local typec=c:GetAttribute()
	return bit.band(typec,att)~=0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	local attribute=tc:GetAttribute()
	local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,attribute)
	local sc=g:GetFirst()
	Duel.SendtoDeck(sc,tp,1,REASON_EFFECT)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.ntcon(e,c,minc)
	return Duel.GetTurnCount()~=1 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,13000762) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetChainLimit(cm.chlimit)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,13000762)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end