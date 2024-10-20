--溯时降诞-那落迦
function c91300022.initial_effect(c)
	--tezhao
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_ATTACK+TIMING_END_PHASE)
	e1:SetCountLimit(1,91300022)
	e1:SetCost(c91300022.cost)
	e1:SetOperation(c91300022.op)
	c:RegisterEffect(e1)
end
function c91300022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c91300022.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c91300022.drcon)
	e1:SetOperation(c91300022.drop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c91300022.disfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c91300022.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c91300022.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=false
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c91300022.disfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g1:GetCount()>=0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g2=Duel.SelectMatchingCard(tp,c91300022.disfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				if g2:GetCount()>=0 then
					Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
				end
			end
			Duel.SpecialSummonComplete()
			res=true
		end
	end
	if not res then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,tp)
	end
end