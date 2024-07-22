--战车道少女·岛田爱里寿
dofile("expansions/script/c9910100.lua")
function c9910145.initial_effect(c)
	--special summon
	QutryZcd.SelfSpsummonEffect(c,CATEGORY_DECKDES,false,c9910145.exchk2,false,c9910145.beftd2,true,nil)
end
function c9910145.spfilter(c,e,tp)
	return c:IsCode(9910147) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9910145.exchk2(e,tp)
	return Duel.IsExistingMatchingCard(c9910145.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c9910145.beftd2(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910145.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g==0 or Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)==0 then return false end
	Duel.ShuffleDeck(tp)
	return true
end
