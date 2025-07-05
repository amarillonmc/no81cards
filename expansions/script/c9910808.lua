--耀曙龙 阿瑞瑞亚-重生
function c9910808.initial_effect(c)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910808)
	e1:SetCost(c9910808.thcost)
	e1:SetOperation(c9910808.thop)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e2:SetCondition(c9910808.negcon)
	e2:SetOperation(c9910808.negop)
	c:RegisterEffect(e2)
end
function c9910808.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9910808.thop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c9910808.thcon)
	e1:SetOperation(c9910808.thop2)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	Duel.RegisterEffect(e1,tp)
end
function c9910808.thfilter(c)
	return c:IsSetCard(0x6951) and not c:IsLevel(5) and c:IsAbleToHand()
end
function c9910808.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()+1
end
function c9910808.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910808)
	local ct=math.floor(Duel.GetFieldGroupCount(1-tp,0xe,0)/3)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910808.thfilter,tp,LOCATION_DECK,0,ct,ct,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9910808.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsLocation(LOCATION_MZONE) or c:GetEquipTarget()) and Duel.GetFlagEffect(tp,9910808)==0
		and rp==1-tp and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev)
end
function c9910808.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,9910808)==0 and not Duel.IsChainDisabled(ev)
		and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(9910808,0)) then
		Duel.Hint(HINT_CARD,0,9910808)
		Duel.RegisterFlagEffect(tp,9910808,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		if Duel.NegateEffect(ev) then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
