local m=53718020
local cm=_G["c"..m]
cm.name="南华灵分 鲲之型"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+66)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(cm.mtop)
	c:RegisterEffect(e3)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,1200,REASON_EFFECT)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,53718006)
end
function cm.dsfilter(c)
	return c:IsFaceup() and ((c:IsLocation(LOCATION_MZONE) and ((bit.band(c:GetOriginalType(),TYPE_SPELL+TYPE_TRAP)~=0 and (not c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanTurnSet()) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and c:IsCanTurnSet())) or (bit.band(c:GetOriginalType(),TYPE_SPELL+TYPE_TRAP)==0 and c:IsCanTurnSet()))) or (c:IsLocation(LOCATION_SZONE) and c:IsSSetable(true))) and not (c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_PZONE))
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(cm.dsfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,cm.dsfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:CancelToGrave()
		Duel.ChangePosition(tc,POS_FACEDOWN)
		local loc=0
		if tc:IsType(TYPE_FIELD) then loc=LOCATION_FZONE
		elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then loc=LOCATION_SZONE end
		if tc:GetOriginalType()&TYPE_MONSTER==0 and tc:IsLocation(LOCATION_MZONE) then Duel.MoveToField(tc,tp,tp,loc,POS_FACEDOWN,false) end
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) then Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) end
	end
end
function cm.cfilter(c)
	return c:IsSetCard(0x953c) and c:IsAbleToDeckAsCost()
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
