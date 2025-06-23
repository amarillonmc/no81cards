--王道踏破·辉
function c22023550.initial_effect(c)
	aux.AddCodeList(c,22023340)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22023340+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22023550.cost)
	e1:SetTarget(c22023550.target)
	e1:SetOperation(c22023550.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(22023550,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22023340)
	e2:SetCondition(c22023550.condition)
	e2:SetTarget(c22023550.thtg)
	e2:SetOperation(c22023550.thop)
	c:RegisterEffect(e2)
end
function c22023550.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xff1) and c:IsAbleToRemoveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c22023550.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023550.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22023550.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c22023550.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.GetFlagEffect(tp,ct)==0 end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(tp,22023340,0,0,0)
		Duel.Hint(HINT_CARD,0,22023340)
	end
end
function c22023550.activate(e,tp,eg,ep,ev,re,r,rp)
		Duel.RegisterFlagEffect(tp,22023340,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,22023340,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,22023340,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,22023340,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,22023340,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,22023340,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,22023340,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,22023340,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,22023340,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,22023340,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,22023340,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,22023340,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_CARD,0,22023550)
end
function c22023550.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023340)>2
end
function c22023550.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c22023550.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end