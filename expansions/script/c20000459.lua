--龙刻魔导士 墨菲纱
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,m+1,m+2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cos)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.cos(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsAbleToGraveAsCost,e:GetHandler()):Filter(Card.IsPublic,nil)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	g=g:Select(tp,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
	Duel.Hint(24,0,aux.Stringid(m,0))
end
function cm.tgf(c,n)
	return c:IsAbleToHand() and c:IsCode(m+n)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf,tp,LOCATION_DECK,0,1,nil,1) and Duel.IsExistingMatchingCard(cm.tgf,tp,LOCATION_DECK,0,1,nil,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local v=Duel.SelectMatchingCard(tp,cm.tgf,tp,LOCATION_DECK,0,1,1,nil,1)+Duel.SelectMatchingCard(tp,cm.tgf,tp,LOCATION_DECK,0,1,1,nil,2)
	if #v==2 and Duel.SendtoHand(v,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,v)
	end
end