--战车道少女·西住真穗
dofile("expansions/script/c9910100.lua")
function c9910108.initial_effect(c)
	--special summon
	QutryZcd.SelfSpsummonEffect(c,CATEGORY_DECKDES,false,c9910108.exchk2,false,c9910108.beftd2,true,nil)
end
function c9910108.spfilter(c,e,tp)
	return c:IsSetCard(0x9958) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910108.exchk2(e,tp)
	return Duel.IsExistingMatchingCard(c9910108.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function c9910108.beftd2(e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910108.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g==0 or Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return false end
	Duel.ShuffleDeck(tp)
	return true
end
