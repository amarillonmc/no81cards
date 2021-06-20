--陷阵营都督
function c9330005.initial_effect(c)
	aux.AddCodeList(c,9330001)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,9330001,aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),1,true,true)
	--change name
	aux.EnableChangeCode(c,9330001,LOCATION_MZONE+LOCATION_GRAVE)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9330005.efilter)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e2)
	--to deck
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9330005,0))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMING_DRAW)
	e6:SetCountLimit(1)
	e6:SetCondition(c9330005.actcon)
	e6:SetTarget(c9330005.tdtg)
	e6:SetOperation(c9330005.tdop)
	c:RegisterEffect(e6)
	--effect gain
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_BE_MATERIAL)
	e7:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e7:SetCondition(c9330005.effcon)
	e7:SetOperation(c9330005.effop)
	c:RegisterEffect(e7)
end
function c9330005.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and not te:GetOwner():IsSetCard(0xaf93)
end
function c9330005.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLevelAbove(7)
end
function c9330005.tdfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToDeck()
end
function c9330005.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9330005.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(9330005,0))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c9330005.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or c:IsLevelBelow(6) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(-3)
	c:RegisterEffect(e1)
	local g=Duel.GetMatchingGroup(c9330005.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,3,nil)
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)>0 then
		local sg2=Duel.GetOperatedGroup()
		if sg2:IsExists(c9330005.tdfilter,1,nil,tp) then Duel.ShuffleDeck(tp) end
		if sg2:IsExists(c9330005.tdfilter,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
		local ct=sg2:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if not sg2:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then return end
			local tc=sg:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				e1:SetTarget(c9330005.distg)
				e1:SetLabelObject(tc)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_CHAIN_SOLVING)
				e2:SetCondition(c9330005.discon)
				e2:SetOperation(c9330005.disop)
				e2:SetLabelObject(tc)
				e2:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e2,tp)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
				e3:SetTarget(c9330005.distg)
				e3:SetLabelObject(tc)
				e3:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e3,tp)
				tc=sg:GetNext()
			end
		if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT) end
	end
end
function c9330005.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and not tc:IsType(TYPE_TRAP)
end
function c9330005.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule()) and not tc:IsType(TYPE_TRAP)
end
function c9330005.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c9330005.effcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_SYNCHRO+REASON_RITUAL)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():GetReasonCard():IsSetCard(0xaf93)
end
function c9330005.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e6=Effect.CreateEffect(rc)
	local e2=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9330005,0))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMING_MAIN_END)
	e6:SetCountLimit(1)
	e6:SetCondition(c9330005.actcon)
	e6:SetTarget(c9330005.tdtg)
	e6:SetOperation(c9330005.tdop)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e6,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end