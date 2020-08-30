--金黑双生
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(30000240)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,m,nil,nil,"sp,rm","de,dsp",cm.con,nil,rsop.target(cm.spfilter,"sp",rsloc.hdg),cm.act)
	local e2=rsef.FTO(c,EVENT_CHAIN_NEGATED,{m,0},nil,nil,"de",LOCATION_GRAVE,cm.setcon,rscost.cost(1,"dish"),rsop.target(Card.IsSSetable,nil),cm.setop)
	if cm.gf then return end
	cm.gf=true  
	local ge1=rsef.FC({c,0},EVENT_DESTROYED)
	ge1:SetOperation(cm.regop)
	local ge2=rsef.RegisterClone({c,0},ge1,"code",EVENT_REMOVE)
	local ge3=rsef.FC({c,0},EVENT_CHAIN_NEGATED)
	ge3:SetOperation(cm.regop2)
	local ge4=rsef.RegisterClone({c,0},ge3,"code",EVENT_CHAIN_DISABLED) 
end
function cm.cfilter(c,rp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()~=rp
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		if rp==i and eg:IsExists(cm.cfilter,1,nil,rp) then
			Duel.RegisterFlagEffect(1-rp,m,rsreset.pend,0,1)
		end
	end
	for i=0,1 do
		if Duel.GetFlagEffect(i,m)>=2 then 
			Duel.RaiseEvent(eg,m,re,r,rp,ep,ev)
		end
	end
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,m,rsreset.pend,0,1)
	if Duel.GetFlagEffect(ep,m)>=2 then
		Duel.RaiseEvent(re:GetHandler(),m,re,r,1-ep,ep,ev)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp 
end
function cm.spfilter(c,e,tp)
	return c:IsCode(30000231,30000236) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.act(e,tp)
	local c=e:GetHandler()
	local ct,og,tc=rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter),tp,rsloc.hdg,0,1,1,nil,{0,tp,tp,true,false,POS_FACEUP },e,tp)
	if not tc then return end
	if tc:IsCode(30000236) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			local e1=rsef.SV_IMMUNE_EFFECT({c,tc},cm.imval)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE) 
			e2:SetCode(EFFECT_EXTRA_ATTACK)
			e2:SetValue(cm.acval)
			c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_ATTACK)
			e3:SetCondition(cm.cacon)
			c:RegisterEffect(e3)
		end
	end
	if tc:IsOriginalCodeRule(30000231) then
		local mt=getmetatable(tc)
		mt.gainop(tc,tp,false,true)
	end
end 
function cm.imval(e,re)
	return e:GetHandler()~=re:GetOwner()
end
function cm.acval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)-1
end
function cm.cacon(e,tp)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)==0
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	return rp==tp and de and dp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and e:GetHandler()==re:GetHandler() and e:GetHandler():GetReasonEffect()==de
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=rscf.GetSelf(e)
	if not c then return end
	if Duel.SSet(tp,c)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		c:RegisterEffect(e1)
	end
end
