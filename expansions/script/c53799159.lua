local m=53799159
local cm=_G["c"..m]
cm.name="酒饮旅之里"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Draw(tp,1,REASON_EFFECT)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetLabel(re:GetHandler():GetCode())
		e2:SetValue(cm.aclimit)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.aclimit(e,re,tp)
	local ac=e:GetLabel()
	return re:GetHandler():IsOriginalCodeRule(ac)
end

