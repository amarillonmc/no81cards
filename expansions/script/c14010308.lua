--问候
local m=14010308
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCondition(cm.limcon)
	e1:SetTarget(cm.limtg)
	e1:SetOperation(cm.limop)
	c:RegisterEffect(e1)
	--timing chk
	if cm.call==nil then
		cm.call=true
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_CHAIN_SOLVED)
		e2:SetCondition(cm.callcon1)
		e2:SetOperation(cm.callchk1)
		Duel.RegisterEffect(e2,0)
	end
end
function cm.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(cm.chainlm)
end
function cm.chainlm(re,rp,tp)
	return re:GetHandler():IsOnField()
end
function cm.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCondition(cm.actcon)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.actcon(e,c)
	local tp=e:GetOwnerPlayer()
	return not Duel.IsPlayerAffectedByEffect(tp,m) and not Duel.IsPlayerAffectedByEffect(1-tp,m)
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsOnField()
end
function cm.callcon1(e,tp,eg,ep,ev,re,r,rp)
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_ANNOUNCE)
	return ex 
end
function cm.callchk1(e,tp,eg,ep,ev,re,r,rp)
	local p,code=Duel.GetChainInfo(ev,CHAININFO_TARGET_PARAM,CHAININFO_TARGET_PARAM)
	local tp=e:GetOwnerPlayer()
	if code and code~=0 then
		local e_t=Effect.CreateEffect(e:GetHandler())
		e_t:SetType(EFFECT_TYPE_FIELD)
		e_t:SetCode(m)
		e_t:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		if p==tp then
			e_t:SetTargetRange(1,0)
		elseif p==1-tp then
			e_t:SetTargetRange(0,1)
		else
			e_t:SetTargetRange(1,1)
		end
		e_t:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e_t,tp)
	end
end