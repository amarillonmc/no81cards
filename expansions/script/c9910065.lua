--月神的天桥
function c9910065.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910065.target)
	e1:SetOperation(c9910065.activate)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910065)
	e2:SetTarget(c9910065.mattg)
	e2:SetOperation(c9910065.matop)
	c:RegisterEffect(e2)
end
function c9910065.cfilter(c)
	return c:IsRace(RACE_FAIRY) and not c:IsPublic()
end
function c9910065.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c9910065.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingMatchingCard(c9910065.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingTarget(c9910065.tgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=1
	if Duel.IsExistingTarget(c9910065.tgfilter,tp,0,LOCATION_ONFIELD,2,nil) then ct=2 end
	local g=Duel.GetMatchingGroup(c9910065.cfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dabcheck,false,1,ct)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectTarget(tp,c9910065.tgfilter,tp,0,LOCATION_ONFIELD,#sg,#sg,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tg,#tg,0,0)
end
function c9910065.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c9910065.matfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsType(TYPE_XYZ)
end
function c9910065.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910065.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910065.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9910065.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9910065.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c9910065.discon)
	e1:SetOperation(c9910065.disop)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910065,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(1,1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c9910065.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,9910065)<1
end
function c9910065.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910065)
	Duel.RegisterFlagEffect(tp,9910065,RESET_PHASE+PHASE_END,0,1)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
	e:Reset()
end
