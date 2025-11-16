--人理之星 达·芬奇
function c22024870.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xff1),2)
	c:EnableReviveLimit()
	--ng
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c22024870.ngcon)
	e1:SetOperation(c22024870.ngop)
	c:RegisterEffect(e1)
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22024870.tgcon)
	e2:SetOperation(c22024870.tgop)
	c:RegisterEffect(e2)
end
function c22024870.ngcon(e,tp,eg,ep,ev,re,r,rp)
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	return rp==tp and te:GetHandlerPlayer()==1-tp and eg:GetFirst():IsSetCard(0xa991) and Duel.GetFlagEffect(tp,22024870)==0
end
function c22024870.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(22024870,0)) then 
	Duel.Hint(HINT_CARD,0,22024870)
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	Duel.NegateEffect(ev-1)
	Duel.RegisterFlagEffect(tp,22024870,RESET_PHASE+PHASE_END,0,1)
	end
end
function c22024870.tgfil(c,type)
	return c:IsSetCard(0xff1) and c:IsType(type) and c:IsAbleToHand()
end
function c22024870.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	local tc=eg:GetFirst()
	local type=tc:GetType()
	return rp==1-tp and te:GetHandlerPlayer()==tp and te:GetHandler():IsSetCard(0xff1) and Duel.GetFlagEffect(tp,22024871)==0
	and Duel.IsExistingMatchingCard(c22024870.tgfil,tp,LOCATION_DECK,0,1,nil,type)
end
function c22024870.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local type=tc:GetType()
	if Duel.SelectYesNo(tp,aux.Stringid(22024870,1)) then 
	Duel.Hint(HINT_CARD,0,22024870)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22024870.tgfil,tp,LOCATION_DECK,0,1,1,nil,type)
	Duel.SendtoHand(g,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.RegisterFlagEffect(tp,22024871,RESET_PHASE+PHASE_END,0,1)
	end
end