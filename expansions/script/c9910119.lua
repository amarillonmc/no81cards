--战车道少女·冷泉麻子
dofile("expansions/script/c9910100.lua")
function c9910119.initial_effect(c)
	--special summon
	QutryZcd.SelfSpsummonEffect(c,CATEGORY_TOHAND,true,nil,true,nil,false,c9910119.afttd2)
end
function c9910119.thfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToHand()
end
function c9910119.afttd2(e,tp)
	if Duel.IsExistingMatchingCard(c9910119.thfilter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910119,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910119.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
