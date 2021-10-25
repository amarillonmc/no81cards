--动物朋友学
function GetID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g<=0 then return end
	Duel.ConfirmCards(1-tp,g)
	if g:GetClassCount(Card.GetCode)==#g then
		local sg=g:Filter(Card.IsAbleToHand,nil)
		if #sg>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local tg=sg:Select(1-tp,1,1,nil)
			if #tg>0 then
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
			end
		end
	end
	Duel.ShuffleDeck(tp)
end