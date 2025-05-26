--监查的百千抉择
function c67201137.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e0)	
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201137,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,67201137)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c67201137.tkcon)
	e1:SetCost(c67201137.atkcost2)
	e1:SetTarget(c67201137.target)
	e1:SetOperation(c67201137.operation)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201137,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,67201138)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c67201137.tkcon)
	e2:SetTarget(c67201137.tktg)
	e2:SetOperation(c67201137.tkop)
	c:RegisterEffect(e2)
end
function c67201137.costfilter(c)
	return c:IsSetCard(0x3670) and c:IsDiscardable() and c:IsType(TYPE_MONSTER)
end
function c67201137.atkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67201137.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c67201137.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c67201137.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end
function c67201137.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(tp,1)
	Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
end

--
function c67201137.cfilter(c)
	return c:IsPreviousLocation(LOCATION_DECK)
end
function c67201137.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67201137.cfilter,1,nil)
end
function c67201137.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c67201137.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end