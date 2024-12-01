--翠帘开幕曲-“BERSER-KEY”
function c67201275.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67201275,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c67201275.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c67201275.target)
	e1:SetOperation(c67201275.activate)
	c:RegisterEffect(e1)  
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201275,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,67201275)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c67201275.tdtg)
	e2:SetOperation(c67201275.tdop)
	c:RegisterEffect(e2)  
end
function c67201275.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_ONFIELD)~=0
end
--
function c67201275.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa67b)
end
function c67201275.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c67201275.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67201275.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c67201275.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c67201275.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		--Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c67201275.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(67201275,2))
	end
end
function c67201275.efilter(e,te)
	return te:IsActivated() and te:GetOwner()~=e:GetOwner() 
end
--
function c67201275.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c67201275.thfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsSSetable()
		and Duel.IsExistingTarget(c67201275.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c67201275.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c67201275.thfilter(c)
	return c:IsSetCard(0xa67b) and c:IsAbleToDeck()
end
function c67201275.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SSet(tp,c)~=0 then
		local tc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
