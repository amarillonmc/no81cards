local m=15000128
local cm=_G["c"..m]
cm.name="创溯之种-『源』"
function cm.initial_effect(c)
	--send replace 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.r1tg)
	e1:SetValue(cm.rval)
	c:RegisterEffect(e1)
	--send replace 2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.r2tg)
	e2:SetValue(cm.rval)
	c:RegisterEffect(e2)
end
function cm.r1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and Duel.GetLocationCount(c:GetControler(),LOCATION_SZONE)~=0 end
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and Duel.GetLocationCount(c:GetControler(),LOCATION_SZONE)~=0 then
		if Duel.MoveToField(c,c:GetControler(),c:GetControler(),LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			c:RegisterEffect(e1)
		end
		return true
	else return false end
end
function cm.r2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsContains(c) and c:IsLocation(LOCATION_SZONE) and c:IsFaceup() and c:IsAbleToDeck() end
	if c:IsLocation(LOCATION_SZONE) and c:IsFaceup() and c:IsAbleToDeck() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_DECKBOT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e2:SetCode(EVENT_TO_DECK)
		e2:SetCountLimit(1)
		e2:SetOperation(cm.tdop)
		e2:SetReset(RESET_EVENT+RESET_TOFIELD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		return true
	else return false end
end
function cm.rval(e,c)
	return false
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(tp)
end