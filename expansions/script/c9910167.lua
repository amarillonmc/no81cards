--战车道少女·蔷薇果
Duel.LoadScript("c9910100.lua")
function c9910167.initial_effect(c)
	--special summon
	QutryZcd.SelfSpsummonEffect(c,CATEGORY_DECKDES+CATEGORY_GRAVE_SPSUMMON,false,c9910167.exchk2,false,c9910167.beftd2,true,nil)
end
function c9910167.spfilter(c,e,tp)
	return c:IsCode(9910167) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910167.exchk2(e,tp)
	return Duel.IsExistingMatchingCard(c9910167.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
end
function c9910167.beftd2(e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910167.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if #g==0 or Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return false end
	if g:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	return true
end
