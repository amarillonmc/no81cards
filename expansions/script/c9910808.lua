--创生原核
function c9910808.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6951),2,true)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910808)
	e1:SetCondition(c9910808.thcon1)
	e1:SetCost(c9910808.thcost)
	e1:SetTarget(c9910808.regtg)
	e1:SetOperation(c9910808.regop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9910808.thcon2)
	c:RegisterEffect(e2)
	--release
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9910809)
	e3:SetCondition(c9910808.rlcon)
	e3:SetTarget(c9910808.rltg)
	e3:SetOperation(c9910808.rlop)
	c:RegisterEffect(e3)
end
function c9910808.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(9910808)==0
end
function c9910808.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(9910808)~=0
end
function c9910808.thcfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c9910808.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c9910808.thcfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c9910808.thcfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c9910808.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x6951) end
end
function c9910808.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c9910808.thcon)
	e1:SetOperation(c9910808.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910808.thfilter(c)
	return c:IsSetCard(0x6951) and c:IsAbleToHand()
end
function c9910808.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910808.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function c9910808.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910808)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910808.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9910808.rlcfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c9910808.rlcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910808.rlcfilter,1,e:GetHandler(),tp)
end
function c9910808.rltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsReleasableByEffect() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsReleasableByEffect,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,Card.IsReleasableByEffect,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c9910808.rlop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Release(tc,REASON_EFFECT)
	end
	e:GetHandler():RegisterFlagEffect(9910808,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
end
