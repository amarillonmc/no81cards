--覆潮之下
local m=88802018
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddCodeList(c,88802004)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88802018+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c88802018.thtg)
	e1:SetOperation(c88802018.thop)
	c:RegisterEffect(e1)
	
end
function c88802018.thfilter(c)
	return aux.IsCodeListed(c,88802004) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c88802018.thfilter2(c)
	return c:IsCode(22702055) and c:IsAbleToHand()
end
function c88802018.desfilter(c,tp,solve)
	return aux.IsCodeListed(c,88802004) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c88802018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88802018.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88802018.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c88802018.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg:RandomSelect(1-tp,1)
		Duel.ShuffleDeck(tp)
		tg:GetFirst():SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		if Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 and  Duel.SelectYesNo(tp,aux.Stringid(88802018,0))  then
		   Duel.BreakEffect()
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		   local g=Duel.SelectMatchingCard(tp,c88802018.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
		   if g:GetCount()==0 then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			   g=Duel.SelectMatchingCard(tp,c88802018.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp,true)
		   end
		   local tc=g:GetFirst()
		   if tc and Duel.Destroy(tc,REASON_EFFECT)~=0 then
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local g=Duel.SelectMatchingCard(tp,c88802018.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			 if g:GetCount()>0 then
				 Duel.SendtoHand(g,nil,REASON_EFFECT)
				 Duel.ConfirmCards(1-tp,g)
			 end
		   end
		end
	end
end
