--圆盘生物 布莱克卡戎
if not pcall(function() require("expansions/script/c25000119") end) then require("script/c25000119") end
local m,cm=rscf.DefineCard(25000131)
function cm.initial_effect(c)
	local e1=rsufo.ShowFun(c,m,nil,"td,dr",nil,nil,nil,rsop.target2(cm.fun,Card.IsAbleToDeck,"td",0,rsloc.og),cm.op,true)   
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,0)
end
function cm.op(e,tp)
	local ct,og,tc=rsop.SelectToDeck(tp,Card.IsAbleToDeck,tp,0,rsloc.og,1,1,nil,{tp,2,REASON_EFFECT })
	if tc and tc:IsLocation(rsloc.de) and rsufo.ToDeck(e) and Duel.IsPlayerCanDraw(1-tp,1) and Duel.SelectYesNo(1-tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end