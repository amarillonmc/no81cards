--闪刀姬-泉鸣
function c98920156.initial_effect(c)
	c:SetSPSummonOnce(98920156)
	 --xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1115),4,2,c98920156.ovfilter,aux.Stringid(98920156,1))
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920156,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c98920156.cost)
	e1:SetTarget(c98920156.target)
	e1:SetOperation(c98920156.operation)
	c:RegisterEffect(e1)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c98920156.effcon)
	e3:SetOperation(c98920156.effop)
	c:RegisterEffect(e3)
end
function c98920156.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x115) and c:IsType(TYPE_LINK) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c98920156.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920156.cfilter(c)
	return c:IsSetCard(0x115) and c:IsType(TYPE_SPELL)
end
function c98920156.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920156.cfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c98920156.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c98920156.filter,tp,LOCATION_GRAVE,0,c)
		local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
		if ct>0 and g:GetCount() then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local sg=g:Select(tp,1,ct,nil)
			Duel.HintSelection(sg)
			for tc in aux.Next(sg) do
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=e1:Clone()
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					tc:RegisterEffect(e3)
				end
			end
		end
end
function c98920156.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK and e:GetHandler():GetReasonCard():IsSetCard(0x1115)
end
function c98920156.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(rc:GetBaseAttack()*2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end