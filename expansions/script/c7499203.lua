--艺形虫 印象I-72
local s,id,o=GetID()
--string
s.named_with_ArtlienWorm=1
--string check
function s.ArtlienWorm(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ArtlienWorm
end
--
function s.initial_effect(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.discost)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--redirect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	--e2:SetType(EFFECT_TYPE_QUICK_O)
	--e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.rettg)
	e2:SetOperation(s.retop)
	c:RegisterEffect(e2)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.tfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and s.ArtlienWorm(c) and c:IsFaceup()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsChainDisablable(ev) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.NegateEffect(ev) and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,10))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECKBOT)
		tc:RegisterEffect(e1)
	end
end
function s.cfilter(c)
	return s.ArtlienWorm(c) and c:IsFaceup()
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,9))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_HAND)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_LEAVE_FIELD_P)
		e2:SetCountLimit(1)
		e2:SetLabelObject(tc)
		e2:SetCondition(s.regcon)
		e2:SetOperation(s.regop)
		--e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.thfilter(c)
	return s.ArtlienWorm(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	--[[if tc then Debug.Message("0") end
	if eg then Debug.Message("01") end
	if eg:IsContains(tc) then Debug.Message("1") end]]
	return tc and eg:IsContains(tc) and Duel.GetFlagEffect(0,id)==0
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	--Debug.Message("2")
	--if bit.band(tc:GetDestination(),LOCATION_HAND+LOCATION_EXTRA)~=0 then Debug.Message("3") end
	--if tc:IsLocation(LOCATION_HAND+LOCATION_EXTRA) then Debug.Message("4") end
	local rde={tc:IsHasEffect(EFFECT_LEAVE_FIELD_REDIRECT)}
	local f=0
	for _,te in pairs(rde) do
		f=te:GetValue()
	end
	if not (bit.band(f,LOCATION_HAND+LOCATION_EXTRA)~=0 --tc:IsLocation(LOCATION_HAND+LOCATION_EXTRA) 
	and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)) then return end
	Duel.RegisterFlagEffect(0,id,0,0,1)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	Duel.ResetFlagEffect(0,id)
	e:Reset()
end
