--Kilimanjaro Flavor
if not pcall(function() require("expansions/script/c700020") end) then require("script/c700020") end
local m,cm = rscf.DefineCard(700021,"Breath")
if rsbh then return end
rsbh = cm
rscf.DefineSet(rsbh,"Breath")
function rsbh.MoveSZone(c,tc,tp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if not tc:IsOnField() and not tc:CheckUniqueOnField(tp) then return end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	tc:RegisterEffect(e1)
end
function cm.grfilter(c,iscontainsset)
	return c:IsComplexType(TYPE_TRAP+TYPE_CONTINUOUS) or (iscontainsset and rsbh.IsSet(c))
end
function rsbh.GetReleaseGroup(tp,iscontainsset,iseffect)
	local rg1 = Duel.GetReleaseGroup(tp)
	local rg2 = Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_SZONE,0,nil)
	local rg3 = (rg1+rg2):Filter(cm.grfilter,nil,iscontainsset)
	if iseffect then 
		rg3 = rg3:Filter(Card.IsReleasableByEffect,nil)
	end
	return rg3
end
function rsbh.ContinuousLimit(e,code,hintcode)
	local con = e:GetCondition() or aux.TRUE 
	local op  = e:GetOperation() or aux.TRUE 
	e:SetCondition(cm.clcon(con,code))
	e:SetOperation(cm.clop(op,code,hintcode))
end
function cm.clcon(con,code)
	return function(e,tp,...)
		return con(e,tp,...) and Duel.GetFlagEffect(tp,code)==0
	end
end
function cm.clop(op,code,hintcode)
	return function(e,tp,...)
		if not Duel.SelectEffectYesNo(tp,e:GetHandler()) then return end
		Duel.RegisterFlagEffect(tp,code,rsreset.pend,0,1)
		rshint.Card(hintcode)
		op(e,tp,...)
	end
end
function rsbh.ExMonFun(c,code,ctlimitzone,spmatct,splimit)
	c:SetUniqueOnField(1,1,code,ctlimitzone)
	local e1 = rscf.SetSummonCondition(c,false,cm.splimitfun)
	local e2 = rscf.AddSpecialSummonProcdure(c,LOCATION_EXTRA,cm.exspcon,nil,cm.exspop,nil,splimit)
	e2:SetLabel(spmatct)
	--local e3 = rsef.FC(c,EVENT_CHAINING,nil,nil,nil,LOCATION_MZONE,cm.exmvcon2,cm.exmvop2)
	--e3:SetLabel(spmatct)
	--rsbh.ContinuousLimit(e3,code,code)
	local e4 = rsef.FC(c,EVENT_CHAINING,nil,nil,nil,LOCATION_SZONE,cm.exspcon2,cm.exspop2)
	rsbh.ContinuousLimit(e4,code+100,code)
	return e1,e2,false,e4
end
function cm.splimitfun(e)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function cm.spmatgcheck(g,c,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function cm.exspcon(e,c,tp)
	local ct = e:GetLabel()
	local rg = rsbh.GetReleaseGroup(tp,true)
	return rg:CheckSubGroup(cm.spmatgcheck,ct,ct,c,tp)
end
function cm.exspop(e,tp)
	local ct = e:GetLabel()
	local rg = rsbh.GetReleaseGroup(tp,true)
	rshint.Select(tp,"res")
	local rg2 = rg:SelectSubGroup(tp,cm.spmatgcheck,false,ct,ct,e:GetHandler(),tp)
	Duel.Release(rg2,REASON_COST)
end
function cm.exmvcon2(e,tp)
	local ct = e:GetLabel()
	local rg = rsbh.GetReleaseGroup(tp,false,true)
	return rg:CheckSubGroup(cm.exgcheck2,ct,ct,tp) 
end
function cm.exrcfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_SZONE)
end
function cm.exgcheck2(g,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or g:IsExists(cm.exrcfilter,1,nil,tp)
end
function cm.exmvop2(e,tp)
	--local ct = e:GetLabel()
	--local c = e:GetHandler()
	--local rg = rsbh.GetReleaseGroup(tp,false,true)
	--rshint.Select(tp,"res")
	--local rg2 = rg:SelectSubGroup(tp,cm.exgcheck2,false,ct,ct,tp)
	--Duel.Release(rg2,REASON_EFFECT)
	rsbh.MoveSZone(c,c,tp)
end
function cm.exspcon2(e,tp)
	local c=e:GetHandler()
	return rscf.spfilter2()(c,e,tp)
end
function cm.exspop2(e,tp)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
--///////
function cm.initial_effect(c)
	c:SetUniqueOnField(1,1,m) 
	local e0 = rsef.ACT(c)
	local e1 = rsef.QO(c,nil,{m,0},1,"sp",nil,LOCATION_SZONE,nil,nil,rsop.target(cm.spfilter,nil,LOCATION_ONFIELD),cm.spop)
	local e2 = rsef.FTO(c,EVENT_MOVE,{m,1},{1,m},nil,"de",rsloc.hdg+LOCATION_REMOVED,cm.mvscon,rscost.cost(cm.mvcfilter,"res",LOCATION_ONFIELD),nil,cm.mvsop)
end
function cm.spfilter(c,e,tp)
	return rsbh.IsSet(c) and c:IsOriginalComplexType(TYPE_MONSTER) and ((c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or (c:IsLocation(LOCATION_SZONE) and rscf.spfilter2()(c,e,tp)))
end
function cm.spop(e,tp)
	local tc = rsop.SelectSolve(HINTMSG_SELF,tp,cm.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,{},e,tp):GetFirst()
	if not tc then return end
	if tc:IsLocation(LOCATION_SZONE) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		rsbh.MoveSZone(e:GetHandler(),tc,tp)
	end
end 
function cm.mvcfilter(c,e,tp)
	return c:IsComplexType(TYPE_TRAP+TYPE_CONTINUOUS) and (c:IsLocation(LOCATION_SZONE) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end 
function cm.mvcfilter2(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and rsbh.IsSet(c) and c:IsOnField()
end
function cm.mvscon(e,tp,eg)
	return eg:IsExists(cm.mvcfilter2,1,nil,tp) and e:GetHandler():CheckUniqueOnField(tp,LOCATION_SZONE)
end
function cm.mvsop(e,tp)
	local tc = rscf.GetSelf(e)
	if not tc then return end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end