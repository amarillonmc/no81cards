--人理之诗 女神的拥抱
function c22023730.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023730,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e1:SetCondition(c22023730.spcon)
	e1:SetTarget(c22023730.target)
	e1:SetOperation(c22023730.desop)
	c:RegisterEffect(e1)
end
function c22023730.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22023730,3))
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c22023730.chainlm)   
	end
end
function c22023730.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER)
end
function c22023730.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=3
end
function c22023730.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsType(TYPE_FIELD)
end
function c22023730.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local opt=0
	if g1:GetCount()>0 and Duel.IsExistingMatchingCard(c22023730.filter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(22023730,1),aux.Stringid(22023730,2))
	elseif g1:GetCount()>0 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(22023730,1))
	elseif Duel.IsExistingMatchingCard(c22023730.filter,tp,LOCATION_DECK,0,1,nil) then
		opt=Duel.SelectOption(1-tp,aux.Stringid(22023730,2))+1
	else return end
	if opt==0 then
		local dg=g1:RandomSelect(1-tp,1)
		Duel.SelectOption(tp,aux.Stringid(22023730,4))
		Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(1-tp,c22023730.filter,1-tp,LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		Duel.SelectOption(tp,aux.Stringid(22023730,4))
		if tc and Duel.SSet(1-tp,tc)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1,true)
		end
	end
end