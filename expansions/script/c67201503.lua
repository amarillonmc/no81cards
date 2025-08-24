--愚者-“源质”
function c67201503.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--revive limit
	c:EnableReviveLimit()
	--aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND)
	aux.AddCodeList(c,67201503,67201509)
	--aux.AddCodeList(c,67201509)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201503,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67201503)
	e1:SetTarget(c67201503.thtg)
	e1:SetOperation(c67201503.thop)
	c:RegisterEffect(e1)
	c67201503.pendulum_effect=e1 
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201503,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c67201503.discon)
	e2:SetTarget(c67201503.distg)
	e2:SetOperation(c67201503.disop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67201503,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,67201504)
	e3:SetTarget(c67201503.pctg)
	e3:SetOperation(c67201503.pcop)
	c:RegisterEffect(e3)  
end
function c67201503.thfilter(c)
	return aux.IsCodeListed(c,67201503) and c:IsAbleToHand()
end
function c67201503.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67201503.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67201503.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67201503.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c67201503.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and Duel.IsChainDisablable(ev)
end
function c67201503.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c67201503.sumtg(e,c)
	return c:IsType(TYPE_MONSTER) and c~=e:GetHandler() and c:IsSetCard(0xa754)
end
function c67201503.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c67201503.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.NegateEffect(ev) and Duel.IsExistingMatchingCard(c67201503.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(67201503,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=Duel.SelectMatchingCard(tp,c67201503.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
--
function c67201503.pcfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsFaceup() and aux.IsCodeListed(c,67201503) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()) then return false end
	local te=c.pendulum_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c67201503.pctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c:IsFaceup() and chkc:IsControler(tp) and c67201503.pcfilter(chkc,e,tp,eg,ep,ev,re,r,rp) end
	local b1=Duel.IsExistingTarget(c67201503.pcfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return Duel.IsExistingTarget(c67201503.pcfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c67201503.pcfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local te=tc.pendulum_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c67201503.pcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) and Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) and tc:IsLocation(LOCATION_PZONE) then   
		local te=tc.pendulum_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
--