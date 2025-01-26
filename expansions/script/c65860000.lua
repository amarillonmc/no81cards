--浮华若梦·浮光掠影
function c65860000.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65860000+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65860000.cost)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c65860000.cost1)
	e2:SetOperation(c65860000.operation)
	c:RegisterEffect(e2)
end
function c65860000.costfilter(c)
	return c:IsSetCard(0xa36) and c:IsAbleToHandAsCost()
end
function c65860000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c65860000.costfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_COST)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function c65860000.filter(c)
	return c:IsSetCard(0xa36) and c:IsType(TYPE_MONSTER) and Duel.IsPlayerCanRelease(c:GetControler())
end
function c65860000.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65860000.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c65860000.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.ReleaseRitualMaterial(g)
end
function c65860000.iumfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0xa36)
end
function c65860000.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local g1=Duel.GetMatchingGroup(c65860000.iumfilter,tp,LOCATION_ONFIELD,0,nil)
		if g1:GetCount()>0 then
			Duel.BreakEffect()
			local nc=g1:GetFirst()
			while nc do
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e3:SetRange(LOCATION_MZONE)
				e3:SetCode(EFFECT_IMMUNE_EFFECT)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				e3:SetValue(c65860000.efilter)
				e3:SetOwnerPlayer(tp)
				nc:RegisterEffect(e3)
				nc=g1:GetNext()
			end
		end
end
function c65860000.efilter(e,re,te)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end