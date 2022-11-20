--蚀刻圣骑 尖刺布鲁图斯
local s,id,o=GetID()
Duel.LoadScript("c33201200.lua")
function s.initial_effect(c)
	VHisc_Paladin.delayef(c,id,5,0x1)
	VHisc_Paladin.atkdef(c)
end
s.VHisc_RustyPaladin=true

--e1
function s.exfilter(c)
	return c.VHisc_RustyPaladin and not c:IsPublic()
end
function s.efspop(e,c,tp)
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local exc=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		Duel.ConfirmCards(1-tp,exc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
