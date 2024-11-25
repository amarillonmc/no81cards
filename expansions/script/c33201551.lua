--ESP爱丽丝 “乐园天使”
local s,id,o=GetID()
Duel.LoadScript("c33201550.lua")
function s.initial_effect(c)
	VHisc_ESP.SpProc(c,id)
	VHisc_ESP.RMC(c,id,0x4+0x200)
end

--e2
function s.filter(c,e,tp)
	return c:IsSetCard(0x3327) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.op(c,e,tp,ct)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,c,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end