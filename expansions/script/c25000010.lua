--根源破灭天使 佐格II
if not pcall(function() require("expansions/script/c25000000") end) then require("script/c25000000") end
local m,cm=rscf.DefineCard(25000010)
function cm.initial_effect(c)
	rszg.XyzSumFun(c,12)
	--local e1=rsef.SV_IMMUNE_EFFECT(c,cm.imval)
	local e7=rsef.SV_CANNOT_BE_TARGET(c,"effect")
	local e8=rsef.SV_INDESTRUCTABLE(c,"effect")
	local e2,e3=rsef.SV_UPDATE(c,"atk,def",cm.adval)
	--local e4=rsef.FV_LIMIT_PLAYER(c,"act",1,nil,{0,1},cm.alcon)
	local e5=rsef.QO(c,nil,{m,0},1,"dis,des,dam",nil,LOCATION_MZONE,nil,rscost.rmxyz(1),rsop.target2(cm.fun,cm.disfilter,"dis",LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c),cm.disop)
	--local e6=rsef.FTO(c,EVENT_PHASE+PHASE_END,{m,1},1,nil,nil,LOCATION_MZONE,cm.matcon,nil,rsop.target(rszg.matfilter,nil,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED),cm.matop)
end
function cm.imval(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER)
end
function cm.adval(e,c)
	return e:GetHandler():GetOverlayCount()*1000
end
function cm.alcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetAttack()/2)
end
function cm.disfilter(c,e,tp)
	return aux.disfilter1(c) and e:GetHandler():IsAttackAbove(1)
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
	local dam=c:GetAttack()/2
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1,e2=rscf.QuickBuff({c,tc},"dis,dise",true)
	Duel.AdjustInstantly(tc)
	if tc:IsDisabled() and not tc:IsImmuneToEffect(e1) and dam>0 then
		local ct=Duel.Damage(1-tp,dam,REASON_EFFECT)
		return tc,ct
	else return 
	end
end
function cm.matcon(e,tp)
	return e:GetHandler():IsType(TYPE_XYZ)
end
function cm.matop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or not c:IsType(TYPE_XYZ) then return end
	rszg.OverlayFun(c)
end
