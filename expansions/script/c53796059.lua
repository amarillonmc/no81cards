local m=53796059
local cm=_G["c"..m]
cm.name="无尽生长"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:GetHandler():IsLocation(LOCATION_HAND) then ft=ft-1 end
		return ft>4 and Duel.IsExistingMatchingCard(cm.stfilter,tp,LOCATION_GRAVE,0,5,nil)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<5 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.stfilter),tp,LOCATION_GRAVE,0,5,5,nil)
	if #g>0 then Duel.SSet(tp,g) end
end
