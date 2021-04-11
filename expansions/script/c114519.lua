--真知神侍从·米戈
if not pcall(function() require("expansions/script/c114500") end) then require("script/c114500") end
local m,cm = rscf.DefineCard(114519)
function cm.initial_effect(c)
	local e1 = rsef.STO_Flip(c,"sp",{1,m},"sp","de",nil,nil,rsop.target(cm.spfilter,"sp",LOCATION_DECK),cm.spop)
	local e2 = rsef.STO(c,EVENT_TO_GRAVE,"pos",{1,m+100},"pos,se,th","de,tg",nil,nil,rstg.target({cm.pfilter,"pos",LOCATION_MZONE },{"opc",cm.thfilter,"th",LOCATION_DECK }),cm.thop)
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_FLIP) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local spos=0
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) then spos=spos+POS_FACEUP_ATTACK end
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then spos=spos+POS_FACEDOWN_DEFENSE end
		Duel.SpecialSummon(tc,0,tp,tp,false,false,spos)
		if tc:IsFacedown() then
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function cm.pfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function cm.thfilter(c)
	return c:IsSetCard(0xca4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	local tc = rscf.GetTargetCard(Card.IsFacedown)
	if tc and Duel.ChangePosition(tc,Duel.SelectPosition(tp,tc,POS_FACEUP)) > 0 then
		rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	end
end