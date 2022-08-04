--兽神集结
local m=40009983
local cm=_G["c"..m]
cm.named_with_BeastDeity=1
function cm.BeastDeity(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BeastDeity
end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)	
end
function cm.tdfilter(c,tp)
	return cm.BeastDeity(c) and c:IsType(TYPE_MONSTER) and not c:IsPublic() and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function cm.thfilter(c,code)
	return cm.BeastDeity(c) and not c:IsCode(code) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		local code=tc:GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
		local hc=hg:GetFirst()
		if hc and Duel.SendtoHand(hc,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,hc)
			Duel.RaiseEvent(tc,EVENT_CUSTOM+40009964,e,REASON_REVEAL,0,tp,0)
			Duel.RaiseEvent(hc,EVENT_CUSTOM+40009964,e,REASON_REVEAL,0,tp,0)
			if hc:IsLocation(LOCATION_HAND) then
				Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end
