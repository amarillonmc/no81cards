local m=53705001
local cm=_G["c"..m]
cm.name="幻海袭 噬魔"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.SeadowRover(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.pubfilter(c)
	return not c:IsPublic()
end
function cm.thfilter(c)
	return c:IsSetCard(0x3534) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function cm.tdfilter(c)
	return c:IsPublic() and c:IsAbleToDeck()
end
function cm.gselect(g,e)
	return g:IsExists(Card.IsSetCard,1,nil,0x3534) and not g:IsContains(e:GetHandler())
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.pubfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
		and not c:IsPublic()
		and #g>1 and g:IsExists(Card.IsSetCard,1,c,0x3534) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local hg=g:SelectSubGroup(tp,cm.gselect,false,1,2,e)
	Duel.ConfirmCards(1-tp,hg)
	SNNM.SetPublic(c,3)
	for tc in aux.Next(hg) do
		SNNM.SetPublic(tc,3)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_HAND,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		local sg=g2:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
