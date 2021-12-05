local m=15000936
local cm=_G["c"..m]
cm.name="夭亡死蔷薇-窒息"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000936)
	aux.AddCodeList(c,15000920)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--imm
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,15000936)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(cm.immcon)
	e1:SetOperation(cm.immop)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetOperation(cm.chainop)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(1,1)
	e3:SetValue(1)
	e3:SetCondition(cm.actcon)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetCondition(cm.regcon)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spcfilter,1,nil)
end
function cm.spcfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_EXTRA) and c:IsCode(15000936)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,15000936,RESET_PHASE+PHASE_END,0,1)
end
function cm.immcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFlagEffect(tp,15000936)~=0 or Duel.GetFlagEffect(1-tp,15000936)~=0) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,15000920)
end
function cm.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.etarget)
	e3:SetValue(cm.efilter)
	e3:SetReset(RESET_CHAIN)
	e3:SetLabelObject(re)
	Duel.RegisterEffect(e3,tp)
end
function cm.etarget(e,c)
	return c:IsCode(15000920)
end
function cm.efilter(e,re)
	local te=e:GetLabelObject()
	return re==te
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.SetChainLimit(cm.chainlm)
end
function cm.chainlm(e,rp,tp)
	return tp~=rp or e:GetHandler():IsSetCard(0x3f3f)
end
function cm.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and cm.cfilter(a,tp)) or (d and cm.cfilter(d,tp))
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsCode(15000920) and c:IsControler(tp)
end