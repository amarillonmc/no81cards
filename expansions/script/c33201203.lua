--蚀刻圣骑 剑士弗格斯
local s,id,o=GetID()
Duel.LoadScript("c33201200.lua")
function s.initial_effect(c)
	VHisc_Paladin.delayef(c,id,5,0x0)
	VHisc_Paladin.atkdef(c)
end
s.VHisc_RustyPaladin=true

--e1
function s.xyzfilter(c)
	return c.VHisc_RustyPaladin and c:IsXyzSummonable(nil)
end
function s.efspop(e,c,tp)
	if Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_CARD,tp,id)
		local g=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,tg:GetFirst(),nil)
		end
	end
end
