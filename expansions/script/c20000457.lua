--曜日之创导龙
dofile("expansions/script/c20000450.lua")
local cm, m = fu_GD.RInitial()
cm.e1 = fuef.FTO("DR"):Cat("RE"):Pro("DE"):Ran("M"):Ctl(1):Func("SelfDraw_con,tg1,op1")
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = fugf.Get(tp, "+MSG")
	if chk==0 then return #g > 0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g = fugf.Select(tp, "+MSG", "Gchk", nil, 1, ev)
	Duel.Remove(g, POS_FACEUP, REASON_EFFECT)
end