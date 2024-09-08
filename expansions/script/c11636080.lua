--渊洋前后夹击
local m=11636080
local cm=_G["c"..m]
function cm.initial_effect(c)
	--rec or dam
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)	
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x9223) and c:IsType(TYPE_MONSTER) and (c:IsAbleToExtra() or c:IsAbleToHand() )
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,2,nil,e,tp) end
		--local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e,tp)
		--return  g:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:FilterSelect(1-tp,Card.IsAbleToExtra,1,1,nil)
	local tc=tg:GetFirst()
	g:Sub(tg)
	Duel.SendtoExtraP(tc,1-tp,REASON_EFFECT)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end
