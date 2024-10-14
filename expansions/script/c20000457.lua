--曜日之创导龙
dofile("expansions/script/c20000450.lua")
local cm, m = fu_GD.RM_initial()
cm.e1 = fuef.FTO("DR"):CAT("RE"):PRO("DE"):RAN("M"):CTL(1):Func("sd_con,tg1,op1")
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = fugf.Get(tp,"+MSG")
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g = fugf.SelectFilter(tp,"+MSG",nil,nil,1,ev)
	if #g<=0 then return end
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end