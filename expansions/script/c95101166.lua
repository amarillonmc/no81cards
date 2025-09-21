--不可思议之国的格林
function c95101166.initial_effect(c)
	aux.AddCodeList(c,95101001)
	--link summon
	aux.AddLinkProcedure(c,c95101166.matfilter,1,1)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95101166)
	e1:SetTarget(c95101166.settg)
	e1:SetOperation(c95101166.setop)
	c:RegisterEffect(e1)
	--change code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95101166+1)
	e2:SetCost(c95101166.cccost)
	e2:SetTarget(c95101166.cctg)
	e2:SetOperation(c95101166.ccop)
	c:RegisterEffect(e2)
end
function c95101166.matfilter(c)
	return aux.IsCodeListed(c,95101001) and c:IsLinkType(TYPE_PENDULUM)
end
function c95101166.setfilter(c)
	return c:IsSetCard(0xbbd) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c95101166.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101166.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c95101166.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c95101166.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then Duel.SSet(tp,g) end
end
function c95101166.cccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c95101166.cctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsCode(95101001) end
end
function c95101166.ccop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(95101001)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
