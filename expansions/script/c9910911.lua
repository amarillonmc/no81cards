--恶性复活
function c9910911.initial_effect(c)
	aux.AddCodeList(c,9910871)
	aux.AddRitualProcGreater2(c,c9910911.filter,LOCATION_HAND+LOCATION_EXTRA,c9910911.mfilter)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910911.settg)
	e2:SetOperation(c9910911.setop)
	c:RegisterEffect(e2)
end
function c9910911.filter(c)
	return c:IsSetCard(0xc954) and (not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup())
end
function c9910911.mfilter(c)
	return aux.IsCodeListed(c,9910871)
end
function c9910911.setfilter(c)
	return c:IsCode(9910871) and c:IsSSetable()
end
function c9910911.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910911.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c9910911.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910911.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
