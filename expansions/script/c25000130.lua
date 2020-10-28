--圆盘生物 希尔巴布尔美
if not pcall(function() require("expansions/script/c25000119") end) then require("script/c25000119") end
local m,cm=rscf.DefineCard(25000130)
function cm.initial_effect(c)
	local e1=rsufo.ShowFun(c,m,nil,"td,tg",nil,cm.con,nil,cm.tg,cm.op,true)   
end
function cm.con(e,tp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
end
function cm.tgfilter(c)
	return Duel.IsPlayerCanSendtoGrave(c:GetControler(),c)
end 
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g-1,1-tp,LOCATION_ONFIELD)
end
function cm.op(e,tp)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_ONFIELD,nil)
	if #g>1 then
		local ct,og=rsgf.SelectToGrave(g,1-tp,aux.TRUE,#g-1,#g-1,nil,{REASON_RULE })
		if ct>0 and og:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
			rsufo.ToDeck(e,true)
		end
	end
end