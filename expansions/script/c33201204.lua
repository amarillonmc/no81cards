--蚀刻圣骑 夜骑赫查特
local s,id,o=GetID()
Duel.LoadScript("c33201200.lua")
function s.initial_effect(c)
	VHisc_Paladin.delayef(c,id,5,0x0)
	VHisc_Paladin.atkdef(c)
end
s.VHisc_RustyPaladin=true

--e1
function s.smfilter(c,e,tp)
	return c.VHisc_RustyPaladin and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.efspop(e,c,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.smfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.smfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end