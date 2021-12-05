local m=53799129
local cm=_G["c"..m]
cm.name="未命名"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_LINK) and not c:IsPublic()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local rc=e:GetLabelObject()
	local ctype=bit.band(rc:GetType(),TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_LINK)
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCondition(cm.recon)
		e1:SetLabel(ctype)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
	end
	Duel.BreakEffect()
	if rc then
		Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	end
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	local rson=0
	local typ=e:GetLabel()
	if typ==TYPE_RITUAL then rson=REASON_RITUAL
	elseif typ==TYPE_FUSION then rson=REASON_FUSION
	elseif typ==TYPE_SYNCHRO then rson=REASON_SYNCHRO
	elseif typ==TYPE_LINK then rson=REASON_LINK end
	return e:GetHandler():IsReason(rson)
end
