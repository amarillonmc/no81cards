--引火烧身
function c33701327.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c33701327.activate)
	c:RegisterEffect(e1)
end
function c33701327.xspfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33701327.activate(e,tp,eg,ep,ev,re,r,rp)
	local opt=0
	opt=Duel.SelectOption(1-tp,aux.Stringid(33701327,0),aux.Stringid(33701327,1))
	if opt==0 then
	local x1=Duel.GetFieldGroup(tp,LOCATION_HAND,0):GetCount()
	local x2=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):GetCount()
	if x1>6 then 
	Duel.DiscardHand(tp,aux.TRUE,x1-6,x1-6,REASON_EFFECT,nil)
	else
	Duel.Draw(tp,6-x1,REASON_EFFECT)
	end
	if x2>6 then 
	Duel.DiscardHand(1-tp,aux.TRUE,x2-6,x2-6,REASON_EFFECT,nil)
	else
	Duel.Draw(1-tp,6-x2,REASON_EFFECT)
	end
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	Duel.SendtoHand(g1,1-tp,REASON_EFFECT)
	Duel.SendtoHand(g2,tp,REASON_EFFECT)
	else
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT) 
	if Duel.IsExistingMatchingCard(c33701327.xspfil,tp,0,LOCATION_DECK,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(33701327,2)) then
	local ag=Duel.GetMatchingGroup(c33701327.xspfil,1-tp,0,LOCATION_DECK,nil,e,tp)
	Duel.ConfirmCards(tp,ag)
	local g=Duel.SelectMatchingCard(tp,c33701327.xspfil,1-tp,0,LOCATION_DECK,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)
	end
	if Duel.IsExistingMatchingCard(c33701327.xspfil,1-tp,0,LOCATION_DECK,1,nil,e,tp) and Duel.SelectYesNo(1-tp,aux.Stringid(33701327,2)) then
	local ag=Duel.GetMatchingGroup(c33701327.xspfil,tp,0,LOCATION_DECK,nil,e,tp)
	Duel.ConfirmCards(1-tp,ag)
	local g=Duel.SelectMatchingCard(1-tp,c33701327.xspfil,1-tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,1-tp,tp,false,false,POS_FACEUP)
	end
	end
end




