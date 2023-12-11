--雪狱之罪名 阴狠的处决
function c9911361.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9911361)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9911361.target)
	e1:SetOperation(c9911361.activate)
	c:RegisterEffect(e1)
	--discard
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9911362)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9911361.dccon)
	e2:SetCost(c9911361.dccost)
	e2:SetTarget(c9911361.dctg)
	e2:SetOperation(c9911361.dcop)
	c:RegisterEffect(e2)
end
function c9911361.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc956)
end
function c9911361.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9911361.thfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,c9911361.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function c9911361.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=e:GetLabelObject()
	local tc2=g:GetFirst()
	if tc2==tc1 then tc2=g:GetNext() end
	if tc1:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9911361,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_HAND)
		tc1:RegisterEffect(e1,true)
		if tc2 and tc2:IsRelateToEffect(e) and Duel.SendtoHand(tc2,nil,REASON_EFFECT)>0 and tc2:IsLocation(LOCATION_HAND) then
			tc2:RegisterFlagEffect(9911361,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e1)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(tp,9911362,RESET_PHASE+PHASE_END,0,1)
	end
end
function c9911361.dccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911362)==0
end
function c9911361.dccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c9911361.dcfilter(c)
	return c:IsPublic() and c:IsDiscardable(REASON_EFFECT)
end
function c9911361.dctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911361.dcfilter,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c9911361.dcop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardHand(1-tp,c9911361.dcfilter,1,1,REASON_EFFECT+REASON_DISCARD)
end
