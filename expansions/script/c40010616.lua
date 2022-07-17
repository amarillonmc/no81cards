--珠宝态幼龙
local m=40010616
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,40010618)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)

	
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,40010618) and not c:IsCode(m) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.cfilter(c)
	return c:IsLevelAbove(1)
end
function cm.thfilter(c)
	return aux.IsCodeListed(c,40010618) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
		if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
			if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) and lg:GetClassCount(Card.GetLevel)>=3 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local stg=tg:Select(tp,1,1,nil)
				Duel.SendtoHand(stg,nil,REASON_EFFECT)
			end
		end
	end
end