--心象风景 制裁
function c19209563.initial_effect(c)
	aux.AddCodeList(c,19209511,19209539)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c19209563.condition)
	e1:SetTarget(c19209563.target)
	e1:SetOperation(c19209563.activate)
	c:RegisterEffect(e1)
end
function c19209563.chkfilter(c)
	return c:IsCode(19209511) and c:IsFaceup()
end
function c19209563.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209563.chkfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,1,nil)
end
function c19209563.tefilter(c)
	return c:IsSetCard(0x3b50) and c:IsType(TYPE_PENDULUM)
end
function c19209563.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209563.tefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c19209563.rmfilter(c)
	return c:IsCode(19209539) and c:IsAbleToRemove() and c:IsFaceupEx()
end
function c19209563.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19209563,0))
	local g=Duel.SelectMatchingCard(tp,c19209563.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoExtraP(g,nil,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c19209563.rmfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(19209563,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19209563.rmfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
