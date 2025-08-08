--创导龙裔的咒引
dofile("expansions/script/c20000450.lua")
local cm, m = fusf.Initial(fu_GD)
cm.e1 = fuef.A():Cat("TD+DR"):Func("ReDraw_tg,op1")
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct = fu_GD.ToDeck(e, tp)
	if ct == 0 then return end
	fu_GD.DrawReturn(tp, ct)
end