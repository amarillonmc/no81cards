--忘却之都的守卫者
function c98910026.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),4,2)
	c:EnableReviveLimit()
	--activate field
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98910026,0))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,98910026)
	e4:SetCondition(c98910026.accon2)
	e4:SetTarget(c98910026.actg2)
	e4:SetOperation(c98910026.acop2)
	c:RegisterEffect(e4)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_FZONE,LOCATION_FZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,22702055))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e2)
	--negate activate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98910026,0))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,98910126)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(c98910026.condition)
	e5:SetCost(c98910026.cost)
	e5:SetTarget(c98910026.target)
	e5:SetOperation(c98910026.operation)
	c:RegisterEffect(e5)
end
function c98910026.accon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c98910026.actg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=e:GetHandlerPlayer()
	if chk==0 then 
			return Duel.IsExistingMatchingCard(c98910026.filter,p,LOCATION_DECK,0,1,nil,p)
			or (Duel.IsExistingMatchingCard(Card.IsFaceup,p,LOCATION_FZONE,0,1,nil) 
			and Duel.IsExistingMatchingCard(c98910026.thfilter,p,LOCATION_DECK,0,1,nil)) end
	Duel.Hint(HINT_OPSELECTED,1-p,aux.Stringid(98910026,0))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,p,LOCATION_DECK)
end
function c98910026.acop2(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
	b=Duel.IsExistingMatchingCard(Card.IsFaceup,p,LOCATION_FZONE,0,1,nil)
	if b and Duel.IsExistingMatchingCard(c98910026.thfilter,p,LOCATION_DECK,0,1,nil) and (not Duel.IsExistingMatchingCard(c98910026.filter,p,LOCATION_DECK,0,1,nil) or Duel.SelectYesNo(p,aux.Stringid(98910026,2))) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(p,c98910026.thfilter,p,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-p,tc)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(p,aux.NecroValleyFilter(c98910026.filter),p,LOCATION_DECK,0,1,1,nil,p):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(p,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,p,p,LOCATION_FZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(p,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,p,p,Duel.GetCurrentChain())
		end
	end
end
function c98910026.filter(c,tp)
	return c:IsCode(22702055) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c98910026.thfilter(c)
	return aux.IsCodeListed(c,22702055) and c:IsAbleToHand()
end
function c98910026.condition(e,tp,eg,ep,ev,re,r,rp)	
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)  and not e:GetHandler():IsStatus(STATUS_CHAINING) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsLevel,1,nil,5)
end
function c98910026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98910026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c98910026.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end