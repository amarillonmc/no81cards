--那并不久远的树，有你我永远的约定
function c12852107.initial_effect(c)
	aux.AddCodeList(c,12852102)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c12852107.thcost)
	e1:SetTarget(c12852107.target)
	e1:SetOperation(c12852107.activate)
	c:RegisterEffect(e1)	
end
function c12852107.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c12852107.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER) or c:IsCode(12852102)
end
function c12852107.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c12852107.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12852107.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c12852107.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c12852107.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c12852107.efilter)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
		if tc:IsCode(12852102) or aux.IsCodeListed(tc,12852102) then
			local e12=Effect.CreateEffect(c)
			e12:SetType(EFFECT_TYPE_SINGLE)
			e12:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e12:SetValue(1)
			e12:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e12)
		end
	end
end
function c12852107.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end