--索尔比诺之歌
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25001015)
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.QO(c,nil,{m,0},{1,m},nil,nil,LOCATION_SZONE,cm.pcon,nil,nil,cm.pop)
	local e3=rsef.QO(c,nil,{m,1},{1,m},nil,nil,LOCATION_SZONE,nil,nil,rsop.target(cm.pfilter,nil,rsloc.gr),cm.pop2)
	local e4=rsef.QO(c,nil,{m,2},{1,m+100},"rm,tg",nil,LOCATION_HAND,nil,rscost.cost(0,"dish"),rsop.target2(cm.fun,cm.rmfilter,"rm",LOCATION_DECK),cm.rmop)
	local e5=rsef.STO(c,EVENT_TO_GRAVE,{m,0},{1,m+200},nil,"de",cm.pconx,nil,nil,cm.pop)
	local e6=rsef.RegisterClone(c,e5,"code",EVENT_REMOVE)
	local e7=rsef.STO(c,EVENT_TO_GRAVE,{m,1},{1,m+200},nil,"de",cm.xcon,nil,rsop.target(cm.pfilter,nil,rsloc.gr),cm.pop2)
	local e8=rsef.RegisterClone(c,e7,"code",EVENT_REMOVE)
end
function cm.xcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re and re:IsActivated()
end
function cm.pconx(e,tp,...)
	local c=e:GetHandler()
	return cm.pcon(e,tp) and cm.xcon(e,tp,...)
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
end
function cm.rmfilter(c)
	return c:IsComplexType(TYPE_SPELL+TYPE_CONTINUOUS) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function cm.rmop(e,tp)
	rsop.SelectSolve(HINTMSG_SELF,tp,cm.rmfilter,tp,LOCATION_DECK,0,1,1,nil,cm.rmfun,tp)
end
function cm.rmfun(g,tp)
	local tc=g:GetFirst()
	local b1=tc:IsAbleToGrave()
	local b2=tc:IsAbleToRemove()
	local op=rsop.SelectOption(tp,b1,{m,3},b2,{m,4})
	if op==1 then
		return Duel.SendtoGrave(tc,REASON_EFFECT)
	else
		return Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.pcon(e,tp)
	local c=e:GetHandler()
	return not c:IsComplexType(TYPE_SPELL+TYPE_CONTINUOUS) and (c:IsLocation(LOCATION_SZONE) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function cm.pop(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	if not c:IsLocation(LOCATION_SZONE) then
		if not Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return end
	end
	c:CancelToGrave(true)
	local e1=rsef.SV_CHANGE(c,"type",TYPE_SPELL+TYPE_CONTINUOUS)
end
function cm.pfilter(c,e,tp)
	return c:IsComplexType(TYPE_SPELL+TYPE_CONTINUOUS) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsFaceup()
end
function cm.pop2(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	rsop.SelectMoveToField(tp,aux.NecroValleyFilter(cm.pfilter),tp,rsloc.gr,0,1,1,nil,{tp,tp,LOCATION_SZONE,POS_FACEUP,true})
end
