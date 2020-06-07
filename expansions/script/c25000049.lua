--邪恶的暗黑破坏神 黑暗扎基
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000049)
function cm.initial_effect(c)
	rssb.LinkSummonFun(c,5,3) 
	rscf.SetSummonCondition(c,false,aux.linklimit)
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_EXTRA,cm.sprcon,cm.sprop,{m,0})
	local e2,e3=rsef.SV_INDESTRUCTABLE(c,"battle,effect")
	local e4=rsef.QO(c,nil,{m,1},1,"des,dam",nil,LOCATION_MZONE,rscon.phmp,nil,rsop.target2(cm.fun,aux.TRUE,"des",0,LOCATION_ONFIELD,true,true),cm.desop)
end
function cm.sprcon(e,c,tp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	local fg=g:Filter(cm.cfilter,nil)
	return fg:GetClassCount(Card.GetCode)>=12 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToDeckOrExtraAsCost()
end
function cm.sprop(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	Duel.ConfirmCards(1-tp,g)
	local fg=g:Filter(cm.cfilter,nil)
	rshint.Select(tp,"rm")
	--local rg=fg:SelectSubGroup(tp,aux.dncheck,false,12,12)
	local rg=Group.CreateGroup()
	for i=1,12 do 
		local tc=fg:Select(tp,1,1,nil):GetFirst()
		rg:AddCard(tc)
		fg:Remove(Card.IsCode,nil,tc:GetCode())
	end
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
	local e1=rsef.SV_IMMUNE_EFFECT(c,rsval.imes,nil,rsreset.est-RESET_TOFIELD)
	local e2,e3=rsef.SV_LIMIT(c,"ress,resns",nil,nil,rsreset.est-RESET_TOFIELD)
end
function cm.fun(g,e,tp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*800)
end
function cm.desop(e,tp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if #g>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		if ct>0 then
			Duel.Damage(1-tp,ct*800,REASON_EFFECT)
		end
	end
end