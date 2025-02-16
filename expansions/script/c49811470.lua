--熔岩谷的朝暮
function c49811470.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMING_STANDBY_PHASE)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c49811470.tdcon)
	e1:SetTarget(c49811470.tdtg)
	e1:SetOperation(c49811470.tdop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c49811470.atkcon)
	e2:SetTarget(c49811470.atktg)
	e2:SetOperation(c49811470.atkop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c49811470.setcon)
	e3:SetTarget(c49811470.settg)
	e3:SetOperation(c49811470.setop)
	c:RegisterEffect(e3)
end
function c49811470.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_STANDBY
end
function c49811470.tdfilter(c)
	return c:IsSetCard(0x39) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToDeck()
end
function c49811470.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811470.tdfilter,tp,LOCATION_REMOVED,0,1,nil) and e:GetHandler():GetFlagEffect(49811470)==0 end
	e:GetHandler():RegisterFlagEffect(49811470,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(49811470,0))
	if Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x39):GetClassCount(Card.GetCode)>=3 then
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else e:SetProperty(0) end
end
function c49811470.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c49811470.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,c49811470.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if tg:GetCount()==0 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) and Duel.IsExistingMatchingCard(c49811470.posfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(49811470,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local sg=Duel.SelectMatchingCard(tp,c49811470.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(sg)
		Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
	end
end
function c49811470.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c49811470.atkfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c49811470.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811470.atkfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(49811470)==0 end
	e:GetHandler():RegisterFlagEffect(49811470,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(49811470,0))
	if Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x39):GetClassCount(Card.GetCode)>=3 then
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else e:SetProperty(0) end
end
function c49811470.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c49811470.atkfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,LOCATION_ONFIELD)
		e2:SetTarget(c49811470.disable)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(49811470,2))
	end
end
function c49811470.disable(e,c)
	return c:GetColumnGroup():IsContains(e:GetHandler()) and c:IsControler(1-e:GetHandlerPlayer()) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c49811470.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c49811470.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c49811470.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
