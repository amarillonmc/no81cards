--测试用卡
local m=87530070
local cm=_G["c"..m]
function c87530070.initial_effect(c)
	 if not cm.global_check then
		cm.global_check=true
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_LEAVE_FIELD)
		e0:SetOperation(cm.regop)
		Duel.RegisterEffect(e0,0)
	end
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Active in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
end
function cm.tyfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.tyfilter,1,nil,0) then
		Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
	end
	if eg:IsExists(cm.tyfilter,1,nil,1) then
		Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1)
	end
end



function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(0,1)
			e1:SetValue(cm.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.aclimit(e,re,tp)
	local rc=re:GetHandler()
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end


function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>0
end








