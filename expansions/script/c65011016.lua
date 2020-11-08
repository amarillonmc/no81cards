--以斯拉的天使 加布里埃尔
if not pcall(function() require("expansions/script/c65011001") end) then require("script/c65011001") end
local m,cm=rscf.DefineCard(65011016,"Israel")
function cm.initial_effect(c)
	rscf.SetSummonCondition(c,false,aux.FALSE)
	aux.AddFusionProcFunRep(c,rsisr.IsFusSet,2,false)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)   
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,"act",{1,m},nil,"de",nil,nil,rsop.target(cm.actfilter,nil,LOCATION_DECK),cm.actop)
	local e2=rsef.I(c,"des",{1,m},"des","tg",LOCATION_MZONE,nil,rscost.reglabel(100),cm.destg,cm.desop)
end
function cm.actfilter(c,e,tp)
	return rsisr.IsSet(c) and c:IsComplexType(TYPE_SPELL,true,TYPE_CONTINUOUS,TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.actop(e,tp)
	rsop.SelectMoveToField_Activate(tp,cm.actfilter,tp,LOCATION_DECK,0,1,1,nil,{},e,tp)
end
function cm.cfilter(c)
	return c:IsFaceup() and rsisr.IsSetS(c) and c:IsAbleToGraveAsCost()
end
function cm.gcheck(g,e,tp)
	local eg=Group.CreateGroup()
	for tc in aux.Next(g) do 
		eg:Merge(tc:GetEquipGroup())
	end
	eg:Merge(g)
	return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,#g,eg)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,0,nil)
	if chkc then return chkc:IsOnField() end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return tg:CheckSubGroup(cm.gcheck,1,2,tp)
	end
	rshint.Select(tp,"tg")
	local tg2=tg:SelectSubGroup(tp,cm.gcheck,false,1,2,tp)
	local ct=Duel.SendtoGrave(tg2,REASON_COST)
	rshint.Select(tp,"des")
	local dg=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function cm.desop(e,tp)
	local tg=rsgf.GetTargetGroup()
	Duel.Destroy(tg,REASON_EFFECT)
end