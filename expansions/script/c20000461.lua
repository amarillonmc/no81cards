--创导龙裔的咒引
dofile("expansions/script/c20000450.lua")
local cm, m = fuef.initial(fu_GD)
cm.e1 = fuef.A():CAT("TD+DR"):Func("tg1,op1")
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and fugf.GetFilter(tp,"H","AbleTo+Not",{"D",e},1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct = fu_GD.ReturnDeck(e, tp)
	if ct == 0 then return end
	Duel.BreakEffect()
	fu_GD.DrawReturn(tp, ct)
end