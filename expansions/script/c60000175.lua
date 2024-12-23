--天刻宏耀之锋
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000163)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(cm.desreptg)
	e2:SetValue(cm.desrepval)
	e2:SetOperation(cm.desrepop)
	c:RegisterEffect(e2)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	e0:SetCost(cm.cost)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and (c:IsCode(60000163) or c:IsCode(60000169))
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and not c:IsPublic() end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	
	Duel.Hint(HINT_CARD,0,m)
end
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPublic()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_ONFIELD)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if Duel.SendtoGrave(g,REASON_RULE)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(cm.val)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_PIERCE)
		e3:SetValue(DOUBLE_DAMAGE)
		
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e4:SetTarget(cm.vtg)
		e4:SetReset(RESET_PHASE+PHASE_END)
		e4:SetLabelObject(e1)
		Duel.RegisterEffect(e4,tp)
		local e5=e4:Clone()
		e5:SetLabelObject(e2)
		Duel.RegisterEffect(e5,tp)
		local e6=e4:Clone()
		e6:SetLabelObject(e3)
		Duel.RegisterEffect(e6,tp)
		Duel.Hint(24,0,aux.Stringid(m,4))
	end
end
function cm.val(e,c)
	return c:GetBaseAttack()+c:GetBaseDefense()
end
function cm.vtg(e,c)
	return (c:IsCode(60000163) or c:IsCode(60000169)) and c:IsFaceup()
end












