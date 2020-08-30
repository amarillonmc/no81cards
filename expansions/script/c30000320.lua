--死之气息
if not pcall(function() require("expansions/script/c30099990") end) then require("script/c30099990") end
local m,cm=rscf.DefineCard(30000320)
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.QO(c,nil,{m,0},{1,m},"dis",nil,LOCATION_SZONE,nil,rscost.reglabel(100),cm.distg,cm.disop)
	local e4=rsef.QO(c,nil,{m,1},{99,m},nil,nil,LOCATION_GRAVE,nil,rscost.cost(cm.tdfilter,"td",LOCATION_REMOVED,LOCATION_REMOVED),rsop.target(Card.IsSSetable,nil),cm.setop)
end
function cm.tgfilter(c)
	return c:FieldPosCheck() and c:IsRace(RACE_ZOMBIE) and c:IsAbleToGraveAsCost()
end
function cm.gcheck(g,tp)
	local g2=Group.CreateGroup()
	for tc in aux.Next(g) do
		g2:Merge(tc:GetEquipGroup())
	end
	return Duel.IsExistingMatchingCard(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,#g,(g+g2))
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if chk==0 then 
		return e:GetLabel()==100 and #g>0 and g:CheckSubGroup(cm.gcheck,1,#g,tp)
	end
	e:SetLabel(0)
	rshint.Select(tp,"tg")
	local cg=g:SelectSubGroup(tp,cm.gcheck,false,1,#g,tp)
	local ct=Duel.SendtoGrave(cg,REASON_COST)
	e:SetValue(ct)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,ct,0,LOCATION_ONFIELD)
end
function cm.disop(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	local ct=e:GetValue()
	rsop.SelectSolve(HINTMSG_DISABLE,tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil,cm.disfun,c,tp)
end
function cm.disfun(g,c,tp)
	for tc in aux.Next(g) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1,e2=rsef.SV_LIMIT({c,tc},"dis,dise",nil,nil,rsreset.est_pend,"cd")
	end
	return true
end
function cm.tdfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsAbleToDeckAsCost()
end 
function cm.setop(e,tp)
	local c=rscf.GetSelf(e)
	if c then Duel.SSet(tp,c) end
end