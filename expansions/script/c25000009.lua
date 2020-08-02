--根源破灭天使 佐格
if not pcall(function() require("expansions/script/c25000000") end) then require("script/c25000000") end
local m,cm=rscf.DefineCard(25000009)
function cm.initial_effect(c)
	local e1=rszg.XyzSumFun(c,m,11,25000010)
	local e2=rsef.SV_CANNOT_BE_TARGET(c,"effect")
	local e3=rsef.QO(c,nil,{m,0},{1,m+600},"dis,des,dam",nil,LOCATION_MZONE,nil,rscost.rmxyz(1),rsop.target2(cm.fun,aux.disfilter1,"dis",LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c),cm.disop)
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function cm.disop(e,tp)
	local tc,ct=rsop.SelectSolve(HINTMSG_FACEUP,tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e),{cm.disfun,e:GetHandler(),tp})
	if ct and ct>0 then
		Duel.BreakEffect()
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.disfun(g,c,tp)
	local tc=g:GetFirst()
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1,e2=rscf.QuickBuff({c,tc},"dis,dise",true)
	Duel.AdjustInstantly(tc)
	if tc:IsDisabled() and not tc:IsImmuneToEffect(e1) then
		local ct=Duel.Damage(1-tp,1500,REASON_EFFECT)
		return tc,ct
	else return 
	end
end