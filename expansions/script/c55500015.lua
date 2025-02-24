--呼唤神之名
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,55500000)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return aux.IsCodeListed(c,55500000) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.upfilter(c)
	return c:IsCode(55500000) and c:IsFaceup()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,55500000) and g:GetFirst():IsType(TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				local lv=g:GetFirst():GetLevel()
				local tc=Duel.SelectMatchingCard(tp,s.upfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst()
				tc:AddCounter(0x189c,lv)
			end
		end
	end
end