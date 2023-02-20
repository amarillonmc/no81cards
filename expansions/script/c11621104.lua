--通向未知的命运
local m=11621104
local cm=_G["c"..m]
function c11621104.initial_effect(c)
	--set top
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=1 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<2 then return end
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local tc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(m,0))
	local tc2=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
	Duel.SendtoDeck(tc,tp,0,REASON_EFFECT)
	Duel.SendtoDeck(tc2,tp,0,REASON_EFFECT)
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ShuffleSetCard(g)
	Duel.SortDecktop(1-tp,tp,3)
end

	