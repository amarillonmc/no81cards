--拟态武装 魔女之匙
function c67200673.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200673,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67200673)
	e1:SetCost(c67200673.plcost)
	e1:SetTarget(c67200673.pltg)
	e1:SetOperation(c67200673.plop)
	c:RegisterEffect(e1) 
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCountLimit(1,67200674)
	e2:SetValue(c67200673.matval)
	c:RegisterEffect(e2)	 
end
function c67200673.costfilter(c)
	return c:IsSetCard(0x667b) and c:IsType(TYPE_MONSTER) and not c:IsCode(67200673) and c:IsAbleToGraveAsCost()
end
function c67200673.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200673.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67200673.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c67200673.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c67200673.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(67200673,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e1,true)
	end
end
---
function c67200673.exmfilter(c)
	return c:IsLocation(LOCATION_SZONE) and c:IsCode(67200673)
end
function c67200673.matval(e,lc,mg,c,tp)
	if not (lc:IsSetCard(0x667b) and (lc:IsAttribute(ATTRIBUTE_LIGHT) or lc:IsAttribute(ATTRIBUTE_WATER))) then return false,nil end
	return true,not mg or not mg:IsExists(c67200673.exmfilter,1,nil)
end