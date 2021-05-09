--梦终
function c71400020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCondition(c71400020.condition)
	e1:SetTarget(c71400020.target)
	e1:SetOperation(c71400020.operation)
	e1:SetCountLimit(1,71400020+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function c71400020.filter1(c)
	return c:IsSetCard(0x714)
end
function c71400020.filter2(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true)
end
function c71400020.filter3(c,e,tp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400020.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71400020.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>12
end
function c71400020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400020.filter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,tp) and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,g:GetCount(),0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c71400020.operation(e,tp,eg,ep,ev,re,r,rp)
	local fg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),tp)
	if Duel.Remove(fg,POS_FACEUP,REASON_EFFECT)<=0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71400020,1))
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71400020.filter2),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		local flag=Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		if tc:IsSetCard(0x3714) and flag and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c71400020.filter3),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(71400020,0)) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71400020.filter3),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,ft,ft,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end