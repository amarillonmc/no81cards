--战车道少女·角谷杏
Duel.LoadScript("c9910100.lua")
function c9910166.initial_effect(c)
	--special summon
	QutryZcd.SelfSpsummonEffect(c,0,false,c9910166.exchk2,false,c9910166.beftd2,true,nil)
end
function c9910166.setfilter(c)
	return c:IsSetCard(0x9958) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9910166.exchk2(e,tp)
	return Duel.IsExistingMatchingCard(c9910166.setfilter,tp,LOCATION_DECK,0,1,nil)
end
function c9910166.filter1(c)
	return not c:IsType(TYPE_FIELD)
end
function c9910166.filter2(c,ft)
	return c:IsType(TYPE_FIELD) or ft>=2
end
function c9910166.beftd2(e,tp)
	local g=Duel.GetMatchingGroup(c9910166.setfilter,tp,LOCATION_DECK,0,tc1)
	if #g==0 then return false end
	local tc1=Duel.GetDecktopGroup(tp,1):GetFirst()
	local tc2
	if c9910166.setfilter(tc1) and Duel.SelectYesNo(tp,aux.Stringid(9910166,0)) then
		if tc1:IsType(TYPE_FIELD) then
			g=g:Filter(c9910166.filter1,tc1)
		else
			g=g:Filter(c9910166.filter2,tc1,Duel.GetLocationCount(tp,LOCATION_SZONE))
		end
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(9910166,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			tc2=g:Select(tp,1,1,tc1)
			Duel.SSet(tp,Group.FromCards(tc1,tc2))
			Duel.ShuffleDeck(tp)
		else
			Duel.DisableShuffleCheck()
			Duel.SSet(tp,tc1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		tc2=g:Select(tp,1,1,nil)
		Duel.SSet(tp,tc2)
		Duel.ShuffleDeck(tp)
	end
	return true
end
