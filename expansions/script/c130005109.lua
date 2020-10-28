--赤龙唤士 索菲亚
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005109,"DragonCaller")
function cm.initial_effect(c)
	local e1,e2,e3=rsdc.SynchroFun(c,m,ATTRIBUTE_FIRE,"dis,des",nil,rsop.target2(cm.fun,cm.disfilter,"dis",0,LOCATION_MZONE),cm.disop,cm.limit)   
end
function cm.fun(g,e,tp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.disfilter(c,e,tp)
	return aux.disfilter1(c) and c:GetBaseAttack()<e:GetHandler():GetAttack()
end
function cm.limit(c,rc)
	return rc:IsType(TYPE_MONSTER) and rc:GetBaseAttack()>c:GetBaseAttack()
end
function cm.disop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if not c then return end
	local g=Duel.GetMatchingGroup(cm.disfilter,tp,0,LOCATION_MZONE,nil,e)
	if #g<=0 then return end
	for tc in aux.Next(g) do
		local e1,e2,e3=rsef.SV_LIMIT({c,tc},"dis,dise,distm",nil,nil,rsreset.est)
		Duel.AdjustInstantly(tc)
	end
	if g:IsExists(Card.IsDisabled,1,nil)  then
		local dg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
		if #dg>0 then
			Duel.BreakEffect()
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end