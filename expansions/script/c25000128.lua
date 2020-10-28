--圆盘生物 戴莫斯
if not pcall(function() require("expansions/script/c25000119") end) then require("script/c25000119") end
local m,cm=rscf.DefineCard(25000128)
function cm.initial_effect(c)
	local e1=rsufo.ShowFun(c,m,nil,"td,dam,rec",nil,cm.con,nil,rsop.target({cm.damct,"dam",0,1},{cm.damct,"rec"}),cm.op,true)   
end
function cm.con(e,tp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>=8
end
function cm.damct(e,tp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)*500
end
function cm.op(e,tp)
	local ct=cm.damct(e,tp)
	if ct>0 and Duel.Damage(1-tp,ct,REASON_EFFECT)>0 and Duel.Recover(tp,ct,REASON_EFFECT)>0 then
		rsufo.ToDeck(e,true)
	end
end