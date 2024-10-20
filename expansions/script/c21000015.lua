--苦涩的决断
local s,id,o=GetID()
function s.initial_effect(c)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=5
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,5,5)
		Duel.ConfirmCards(1-tp,sg)

		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(id,1))
		local tg=sg:Select(1-tp,1,1,nil)
		sg:Sub(tg)
		Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tg:GetFirst(),SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
end