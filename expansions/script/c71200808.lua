--深渊的呼唤VIII 义体再构
Duel.LoadScript("c71200802.lua")
local cm, m = GetID()
function cm.chkf(c,e,tp)
	return c:IsSetCard(0x899) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() 
		or Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP))
end
function cm.chk(e,tp)
	return Duel.IsExistingMatchingCard(cm.chkf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
end
function cm.ex_op(e,tp)
	local g = Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.chkf),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc = g:Select(tp,1,1,nil):GetFirst()
	if not tc then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
Alter_DC8.Initial(CATEGORY_TOHAND,cm.chk,cm.ex_op)