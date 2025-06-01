--乞巧的一等星 进步的祈愿
function c28361677.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,28361677+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c28361677.cost)
	e1:SetTarget(c28361677.target)
	e1:SetOperation(c28361677.activate)
	c:RegisterEffect(e1)
	--illumination maho
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c28361677.reptg)
	e2:SetValue(c28361677.repval)
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
function c28361677.chkfilter(c)
	return c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c28361677.tgfilter(c)
	return c:IsSetCard(0x284) and c:IsAbleToGrave()
end
function c28361677.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c28361677.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c28361677.chkfilter,tp,LOCATION_HAND,0,nil)
	local ct=Duel.GetMatchingGroupCount(c28361677.tgfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return #g>0 and ct>0 end
	if ct>#g then ct=#g end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g:SelectSubGroup(tp,aux.dabcheck,false,1,ct)
	Duel.ConfirmCards(1-tp,cg)
	Duel.SetTargetCard(cg)
	Duel.ShuffleHand(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c28361677.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):GetCount()
	local g=Duel.GetMatchingGroup(c28361677.tgfilter,tp,LOCATION_DECK,0,nil)
	if #g>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g:Select(tp,ct,ct,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c28361677.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c28361677.actop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRace(RACE_FAIRY) and ep==tp then
		Duel.SetChainLimit(c28361677.chainlm)
	end
end
function c28361677.chainlm(e,rp,tp)
	return tp==rp
end
function c28361677.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x284) and eg:IsContains(c) and (c:IsAbleToHand() or (re:GetHandler():IsFaceupEx() and (re:GetHandler():IsLevelAbove(1) or re:GetHandler():IsRankAbove(1)))) end
	if c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(28361677,0)) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_DECK_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_HAND)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		--c:RegisterFlagEffect(28361677,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_TO_HAND)
		e2:SetCountLimit(1)
		e2:SetOperation(c28361677.chkop)
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
function c28361677.repval(e,c)
	return false
end
function c28361677.chkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.ShuffleHand(tp)
end
