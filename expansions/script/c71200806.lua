--深渊的呼唤VIII 采集速巡
Duel.LoadScript("c71200802.lua")
local cm, m = GetID()
function cm.chkf(c)
	return c:IsSetCard(0x899) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.chk(e,tp)
	return Duel.IsExistingMatchingCard(cm.chkf,tp,LOCATION_DECK,0,1,nil)
end
function cm.ex_op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local c = Duel.SelectMatchingCard(tp,cm.chkf,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not c then return end
	Duel.SSet(tp,c)
end
Alter_DC8.Initial(0,cm.chk,cm.ex_op)