--Dimension Kick
function c9980824.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9980824.cost)
	e1:SetTarget(c9980824.target)
	e1:SetOperation(c9980824.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980824,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,9980824)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c9980824.thcon)
	e2:SetTarget(c9980824.thtg)
	e2:SetOperation(c9980824.thop)
	c:RegisterEffect(e2)
end
function c9980824.filter(c)
	return c:IsSetCard(0x9bcd) and c:IsDiscardable()
end
function c9980824.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(c9980824.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9980824.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c9980824.filter(c)
	return c:IsFaceup() and c:IsAttackBelow(3000) and c:IsAbleToRemove()
end
function c9980824.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c9980824.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980824.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9980824.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9980824.rfilter(c,tc)
	return c:IsCode(tc:GetCode()) and c:IsAbleToRemove()
end
function c9980824.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0 then
		local rg=Duel.GetMatchingGroup(c9980824.rfilter,tp,0,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_ONFIELD,nil,tc)
		if #rg>0 then
			Duel.BreakEffect()
			Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
			Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980824,0))
		end
	end
end
function c9980824.rccfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9bcd)
end
function c9980824.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and Duel.IsExistingMatchingCard(c9980824.rccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9980824.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9980824.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980824,0))
	end
end
