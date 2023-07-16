--拟态武装 月星钏
function c67200631.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200631,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,67200631)
	e1:SetTarget(c67200631.pltg)
	e1:SetOperation(c67200631.plop)
	c:RegisterEffect(e1) 
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCountLimit(1,67200632)
	e2:SetValue(c67200631.matval)
	c:RegisterEffect(e2)  
end
function c67200631.plfilter(c)
	return c:IsSetCard(0x667b) and c:IsType(TYPE_MONSTER) and c:IsLevel(3) and not c:IsForbidden()
end
function c67200631.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(c67200631.plfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c67200631.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g2=Duel.SelectMatchingCard(tp,c67200631.plfilter,tp,LOCATION_DECK,0,1,1,nil)
	g2:AddCard(c)
	local tc=g2:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(67200631,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		--indes
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x667b))
		e2:SetValue(c67200631.indct)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(e2)
		tc=g2:GetNext()
	end
end
--
function c67200631.indct(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
---
function c67200631.exmfilter(c)
	return c:IsLocation(LOCATION_SZONE) and c:IsCode(67200631)
end
function c67200631.matval(e,lc,mg,c,tp)
	if not (lc:IsSetCard(0x667b) and lc:IsRace(RACE_PSYCHO)) then return false,nil end
	return true,not mg or not mg:IsExists(c67200631.exmfilter,1,nil)
end
