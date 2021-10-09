--降临卡片·火焰风暴
function c9980594.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9980594.condition)
	e1:SetTarget(c9980594.target)
	e1:SetOperation(c9980594.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9980594)
	e2:SetCondition(c9980594.setcon)
	e2:SetTarget(c9980594.settg)
	e2:SetOperation(c9980594.setop)
	c:RegisterEffect(e2)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980594,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c9980594.tdcon)
	e2:SetTarget(c9980594.tdtg)
	e2:SetOperation(c9980594.tdop)
	c:RegisterEffect(e2)
end
function c9980594.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bca)
end
function c9980594.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9980594.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c9980594.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		if re:GetHandler():IsType(TYPE_MONSTER) then
			Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,re:GetHandler():GetBaseAttack())
		end
	end
end
function c9980594.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)
		and Duel.Destroy(eg,REASON_EFFECT)~=0 and re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler():GetBaseAttack()>0 then
		Duel.BreakEffect()
		Duel.Recover(tp,re:GetHandler():GetBaseAttack(),REASON_EFFECT)
	end
end
function c9980594.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_REVEAL) 
end
function c9980594.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9980594.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
	end
end
function c9980594.rccfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bca)
end
function c9980594.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and Duel.IsExistingMatchingCard(c9980594.rccfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c9980594.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c9980594.tdop(e,tp,eg,ep,ev,re,r,rp)
   if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end