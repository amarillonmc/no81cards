local m=53718012
local cm=_G["c"..m]
cm.name="神算鬼谋"
function cm.initial_effect(c)
	aux.AddCodeList(c,53718001)
	aux.AddCodeList(c,53718002)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(2)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsDiscardable(REASON_EFFECT)
end
function cm.tgfilter(c)
	return c:IsCode(53718001,53718002) and c:IsAbleToGrave()
end
function cm.tdfilter(c)
	return c:IsCode(53718001,53718002) and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g1=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE,0,nil)
	local b1=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) and g1:CheckSubGroup(aux.gfcheck,2,2,Card.IsCode,53718001,53718002)
	local b2=g2:CheckSubGroup(aux.gfcheck,2,2,Card.IsCode,53718001,53718002) and Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return b1 or b2 end
	local sel=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if b1 and b2 then
		sel=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then
		sel=Duel.SelectOption(tp,aux.Stringid(m,0))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	if sel==0 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
	e:SetLabel(sel)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil)
		if g:CheckSubGroup(aux.gfcheck,2,2,Card.IsCode,53718001,53718002) and Duel.DiscardHand(tp,cm.filter,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsCode,53718001,53718002)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	else
		local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsCode,53718001,53718002)
		if #sg>0 then
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			local dg=Duel.GetOperatedGroup()
			if dg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
