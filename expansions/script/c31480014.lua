local m=31480014
local cm=_G["c"..m]
cm.name="星辰降落之地"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	if c:IsPreviousLocation(LOCATION_GRAVE) and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
		Duel.SSet(p,c)
		local lp=Duel.GetLP(p)
		Duel.SetLP(p,lp-500)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,nil,1)
	end
end