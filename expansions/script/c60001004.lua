--空中连接 观空者
function c60001004.initial_effect(c)
	--回路连接！
	aux.AddLinkProcedure(c,nil,2,2,c60001004.lcheck)
	c:EnableReviveLimit()
	--攻击力上升
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c60001004.atkval)
	c:RegisterEffect(e1)
	--支付生命值
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c60001004.mtop)
	c:RegisterEffect(e3)
end
function c60001004.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,600) then
		Duel.PayLPCost(tp,600)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function c60001004.atkval(e,c)
	return c:GetLinkedGroupCount()*1000
end