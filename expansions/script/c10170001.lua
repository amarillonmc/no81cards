--sssss1
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10170001
local cm=_G["c"..m]
if not rsv.StellarPearl then
	rsv.StellarPearl={}
	rssp=rsv.StellarPearl
function rssp.PendulumAttribute(c,ptype)
	aux.EnablePendulumAttribute(c)
	if ptype=="hand" then
		return rssp.HandActivateTypeFun(c)
	elseif ptype=="set" then
		return rssp.SetActivateTypeFun(c)
	end
end
function rssp.actcon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_PZONE) or (c:IsLocation(LOCATION_MZONE) and Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),m)) or (c:IsLocation(LOCATION_MZONE) and c:GetFlagEffect(m)>0)
end
function rssp.HandActivateTypeFun(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa333))
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCondition(rssp.actcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetDescription(aux.Stringid(m,4))
	c:RegisterEffect(e2)
	return e1,e2
end
function rssp.SetActivateTypeFun(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa333))
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetCondition(rssp.actcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetDescription(aux.Stringid(m,5))
	c:RegisterEffect(e2)
	return e1,e2
end
function rssp.ChangeOperationFun(c,code,ctype,con,op,ctlimit)
	local val1=function(e,tp,eg,ep,ev,re,r,rp)
		return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
	end
	local val2=function(e,tp,eg,ep,ev,re,r,rp)
		return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp and re:GetHandler():IsSetCard(0xa333)
	end
	local val=ctype and val2 or val1
	local limit=ctlimit or 1
	local e1,e2=rsef.FC_AttachEffect_Activate(c,{code,0},limit,nil,LOCATION_ONFIELD,rssp.changecon(con,val),op)
	return e1,e2
end
function rssp.ChangeOperationFun2(c,code,ctype,con,op,ctlimit)
	local val1=function(e,tp,eg,ep,ev,re,r,rp)
		return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
	end
	local val2=function(e,tp,eg,ep,ev,re,r,rp)
		return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp and re:GetHandler():IsSetCard(0xa333)
	end
	local val=ctype and val2 or val1
	local limit=ctlimit or 1
	local e1,e2=rsef.FC_AttachEffect_Activate(c,{code,0},limit,nil,LOCATION_MZONE,rssp.changecon(con,val,true),op)
	return e1,e2
end
function rssp.changecon(con,val,bool)
	return function(e,tp,eg,ep,ev,re,r,rp)
		return (bool or rssp.actcon(e)) and (not con or con(e,tp,eg,ep,ev,re,r,rp)) and (not val or val(e,tp,eg,ep,ev,re,r,rp))
	end
end
function rssp.LinkCopyFun(c)
	local e1=rsef.SC(c,EVENT_SPSUMMON_SUCCESS,nil,nil,"cd",rscon.sumtype("link"),rssp.copyop)
	return e1
end
function rssp.copyop(e,tp)
	local f=function(matc)
		return matc:IsSetCard(0xa333) and matc:IsType(TYPE_PENDULUM)
	end
	local c=e:GetHandler()
	local mat=c:GetMaterial()
	if #mat<=0 then return end
	local mat2=mat:Filter(f,nil)
	for tc in aux.Next(mat2) do
		c:CopyEffect(tc:GetOriginalCode(),rsreset.est)
		local mt=getmetatable(tc)
		if mt.copyfunfilter then
			local e1,e2=mt.copyfunfilter(c)
			e1:SetReset(rsreset.est)
			e2:SetReset(rsreset.est)
		end
		c:RegisterFlagEffect(m,rsreset.est,0,1)
	end
end
function rssp.ActivateFun(c,code,cate,cost,fun,op)
	local e1=rsef.ACT(c,nil,nil,{1,code,1},cate)
	rsef.RegisterSolve(e1,nil,rssp.activatecost(cost),rssp.activatetg(fun),rssp.activateop(code,fun,op))
	return e1
end
function rssp.activatecost(cost)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local b1= cost=="dish" and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
		local b2= cost=="lp" and Duel.CheckLPCost(tp,1000)
		local b3=Duel.IsExistingMatchingCard(rscf.FilterFaceUp(Card.IsSetCard,0xa333),tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		if chk==0 then 
			return b1 or b2 or b3
		end
		if b1 then
			local op=rsof.SelectOption(tp,b1,{m,1},b3,{m,3},true)
			if op==1 then
				Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST,nil)
			end
		elseif b2 then
			local op=rsof.SelectOption(tp,b2,{m,2},b3,{m,3},true)
			if op==1 then
				Duel.PayLPCost(tp,1000)
			end
		end
	end
end
function rssp.activatetg(fun)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local g1,g2,b1,b2=fun(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return #g1>0 or #g2>0 end
		local infolist={b1,b2}
		for _,info in pairs(infolist) do
			if info then
				local _,catelist=rsef.GetRegisterCategory(info[1])
				local selecthint=info[2]
				local player=info[3]
				local location=info[4]
				for _,cate in pairs(catelist) do
					Duel.SetOperationInfo(0,cate,nil,0,player,location)
				end
			end
		end
	end
end
function rssp.activateop(code,fun,op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local g1,g2,b1,b2,fun1,fun2=fun(e,tp,eg,ep,ev,re,r,rp,chk)
		g1=g1:Filter(aux.NecroValleyFilter(aux.TRUE),aux.ExceptThisCard(e))
		g2=g2:Filter(aux.NecroValleyFilter(aux.TRUE),aux.ExceptThisCard(e))
		if #g1<=0 and #g2<=0 then return end
		local opt=rsof.SelectOption(tp,#g1>0,{code,0},#g2>0,{code,1})
		if opt==1 and fun1 then fun1(e,tp,eg,ep,ev,re,r,rp) end
		if opt==2 and fun2 then fun2(e,tp,eg,ep,ev,re,r,rp) end
		local selectg= opt==1 and  g1 or g2
		local selecthint= opt==1 and b1[2] or b2[2]
		rsof.SelectHint(tp,selecthint)
		local operationg=selectg:Select(tp,1,1,nil)
		if operationg:GetFirst():IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED) then
			Duel.HintSelection(operationg)
		end
		op(opt,operationg,e,tp,eg,ep,ev,re,r,rp)
	end
end
-------------
end
-------------
if cm then
function cm.initial_effect(c)
	local e1,e2=rssp.PendulumAttribute(c,"hand")
	local e3,e4=rssp.ChangeOperationFun(c,m,false,cm.con,cm.op)
	local e5=rsef.SC(c,EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(cm.sop)
	local e6=rsef.RegisterClone(c,e5,"code",EVENT_SUMMON_SUCCESS)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCanTurnSet() and not re:GetHandler():IsType(TYPE_PENDULUM)
end
function cm.op(e,tp)
	local c=rscf.GetRelationThisCard(e)
	if c and c:IsCanTurnSet() then
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function cm.sop(e,tp)
	if Duel.GetFlagEffect(tp,m)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa333))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
-------------
end