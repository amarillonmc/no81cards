--伊尔米涅特音乐会
function c28322511.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,28322511+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c28322511.cost)
	e1:SetTarget(c28322511.target)
	e1:SetOperation(c28322511.activate)
	c:RegisterEffect(e1)
	--illumination maho
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c28322511.reptg)
	e2:SetValue(c28322511.repval)
	c:RegisterEffect(e2)
	--illumination SetCode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetValue(0x283)
	c:RegisterEffect(e3)
end
function c28322511.chkfilter(c)
	return c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c28322511.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28322511.chkfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28322511.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c28322511.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c28322511.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp,PHASE_END,1)~=0 and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28322511,2))
	end
end
function c28322511.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x284) and eg:IsContains(c) and (c:IsAbleToHand() or (re:GetHandler():IsFaceupEx() and (re:GetHandler():IsLevelAbove(1) or re:GetHandler():IsRankAbove(1)))) end
	if c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(28322511,0)) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_DECK_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_HAND)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		--c:RegisterFlagEffect(28322511,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_TO_HAND)
		e2:SetCountLimit(1)
		e2:SetOperation(c28322511.chkop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOHAND+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		return true
	else
		local rc=re:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		rc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RANK)
		rc:RegisterEffect(e2)
	return false end
end
function c28322511.repval(e,c)
	return false
end
function c28322511.chkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.ShuffleHand(tp)
end
