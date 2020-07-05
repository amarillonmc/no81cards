--虚拟水神忍者
if not pcall(function() require("expansions/script/c65020201") end) then require("script/c65020201") end
local m,cm=rscf.DefineCard(65020207,"VrAqua")
function cm.initial_effect(c)
	local e1,e2,e3=rsva.MonsterEffect(c,m,cm.op)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local e1=rsef.FC({c,tp},EVENT_CHAIN_SOLVED,nil,nil,nil,nil,cm.descon,cm.desop,rsreset.pend)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
	return rscon.excard2(rsva.filter_l,LOCATION_MZONE)(e,tp) and loc & LOCATION_MZONE ~=0
end
function cm.desop(e,tp)
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and rsop.SelectYesNo(tp,{m,0}) then
		Duel.Hint(HINT_CARD,0,m)
		rsop.SelectDestroy(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,{})
	end
end