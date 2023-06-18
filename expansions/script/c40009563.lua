--焰之巫女 宗妮
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009563,"BlazeMaiden")
function cm.initial_effect(c)
	local e1 = rsfwh.OvelayFun(c,m)
	local e2,e3 = rsfwh.SummonFun(c,m,CATEGORY_SEARCH+CATEGORY_TOHAND,cm.thtg,cm.thop,0,cm.thtg2,cm.thop2)
end
function cm.thfilter(c)
	return cm.thfilter2(c) or cm.thfilter3(c)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_HAND)
end
function cm.thop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g > 0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.thfilter2(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function cm.thfilter3(c)
	return c:CheckSetCard("Vairina")  and c:IsAbleToHand()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.thfilter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function cm.thop2(e,tp)
	local g1 = Duel.GetMatchingGroup(cm.thfilter2,tp,LOCATION_DECK,0,nil)
	local g2 = Duel.GetMatchingGroup(cm.thfilter3,tp,LOCATION_DECK,0,nil)
	if #g1 <= 0 or #g2 <= 0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg1 = Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg2 = Duel.SelectMatchingCard(tp,cm.thfilter3,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(tg1+tg2,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg1+tg2)
end