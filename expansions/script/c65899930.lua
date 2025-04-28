--冲进厕所！
function c65899930.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65899930.target)
	e1:SetOperation(c65899930.activate)
	c:RegisterEffect(e1)
end
function c65899930.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function c65899930.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local ec=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler()):GetFirst()
	if ec then
	if ec:IsType(TYPE_XYZ) and ec:GetOverlayCount()>0 then
	local mg=ec:GetOverlayGroup()
	Duel.SendtoGrave(mg,REASON_RULE)
	end
		Duel.Exile(ec,0)
		Duel.RaiseEvent(ec,EVENT_LEAVE_FIELD,e,REASON_EFFECT,tp,nil,nil)
	end
end