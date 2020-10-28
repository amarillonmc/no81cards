--圆盘生物 布莱克恩多
if not pcall(function() require("expansions/script/c25000119") end) then require("script/c25000119") end
local m,cm=rscf.DefineCard(25000132)
function cm.initial_effect(c)
	local e1=rsufo.ShowFun(c,m,nil,"td,tg",nil,nil,nil,rsop.target(cm.tgfilter,"tg",0,LOCATION_ONFIELD),cm.op,true)   
end
function cm.tgfilter(c)
	return Duel.IsPlayerCanSendtoGrave(c:GetControler(),c)
end 
function cm.op(e,tp)
	local ct,og,tc=rsop.SelectToGrave(tp,cm.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil,{REASON_RULE })
	if tc and tc:IsLocation(LOCATION_GRAVE) and Duel.IsPlayerCanDraw(1-tp,1) and Duel.SelectYesNo(1-tp,aux.Stringid(m,1)) and Duel.Draw(1-tp,1,REASON_EFFECT)>0 then
		rsufo.ToDeck(e,true)
	end
end
