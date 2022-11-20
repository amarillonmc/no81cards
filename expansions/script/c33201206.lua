--蚀刻圣骑 圣女特丽莎
local s,id,o=GetID()
Duel.LoadScript("c33201200.lua")
function s.initial_effect(c)
	VHisc_Paladin.delayef(c,id,5,0x20000+0x8)
	VHisc_Paladin.atkdef(c)
end
s.VHisc_RustyPaladin=true

--e1
function s.thfilter(c,code)
	return c.VHisc_RustyPaladin and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(code)
end
function s.exfilter(c,tp)
	return c.VHisc_RustyPaladin and c:IsType(TYPE_MONSTER) and not c:IsPublic() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function s.efspop(e,c,tp)
	if Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_HAND,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local exc=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
		Duel.ConfirmCards(1-tp,exc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,exc:GetCode())
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
