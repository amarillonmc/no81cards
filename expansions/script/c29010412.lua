--疑心暗鬼
function c29010412.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c29010412.mfilter,1,1)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29010412,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,29010412)
	e1:SetCondition(c29010412.thcon)
	e1:SetTarget(c29010412.thtg)
	e1:SetOperation(c29010412.thop)
	c:RegisterEffect(e1)  
	--apply effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29010412,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19010412)
	e2:SetTarget(c29010412.efftg)
	e2:SetOperation(c29010412.effop)
	c:RegisterEffect(e2)  
end
function c29010412.mfilter(c)
	return c:IsSetCard(0x7a1)
end
function c29010412.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c29010412.thfilter(c)
	return c:IsCode(29010407) and c:IsAbleToHand()
end
function c29010412.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29010412.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29010412.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29010412.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c29010412.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x7a1) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:IsLocation(LOCATION_GRAVE)) then return false end
	local te=c.battle_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c29010412.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c29010412.efffilter(chkc,e,tp,eg,ep,ev,re,r,rp) end
	if chk==0 then return Duel.IsExistingTarget(c29010412.efffilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c29010412.efffilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	local tc=g:GetFirst()
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local te=tc.discard_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c29010412.effop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		local te=tc.discard_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		Duel.BreakEffect()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end





