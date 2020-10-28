--圆盘生物 布莱克多姆
if not pcall(function() require("expansions/script/c25000119") end) then require("script/c25000119") end
local m,cm=rscf.DefineCard(25000126)
function cm.initial_effect(c)
	local e1=rsufo.ShowFun(c,m,nil,"td,dis,atk,def",nil,cm.con,nil,rsop.target(aux.disfilter1,"dis",0,LOCATION_ONFIELD),cm.op,true)   
end
function cm.con(e,tp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>=5
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	local res = false
	for tc in aux.Next(g) do
		local e1,e2=rscf.QuickBuff({c,tc},"dis,dise")
		res = res or not tc:IsImmuneToEffect(e1)
	end
	if not res then return end
	res = false
	g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1,e2=rscf.QuickBuff({c,tc},"atkf,deff",{tc:GetAttack()/2,tc:GetDefense()/2})
		res = res or not tc:IsImmuneToEffect(e1)
	end
	if not res then return end
	rsufo.ToDeck(e,true)
end