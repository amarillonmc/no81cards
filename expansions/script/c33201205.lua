--蚀刻圣骑 教士克兰麦
local s,id,o=GetID()
Duel.LoadScript("c33201200.lua")
function s.initial_effect(c)
	VHisc_Paladin.delayef(c,id,5,0x20000+0x8)
	VHisc_Paladin.atkdef(c)
end
s.VHisc_RustyPaladin=true

--e1
function s.filter(c)
	return c.VHisc_RustyPaladin and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function s.efspop(e,c,tp)
	if Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
