--我忘记了所有不幸，所见皆是奇迹-奎若
function c79034020.initial_effect(c)
   --Destroy
   local e1=Effect.CreateEffect(c)
   e1:SetCategory(CATEGORY_DESTROY)
   e1:SetType(EFFECT_TYPE_IGNITION)
   e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
   e1:SetCost(c79034020.dscost)
   e1:SetTarget(c79034020.dstg)
   e1:SetOperation(c79034020.dsop)
   c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c79034020.twocon)
	c:RegisterEffect(e4)
   --atk up
   local e2=Effect.CreateEffect(c)
   e2:SetType(EFFECT_TYPE_IGNITION)
   e2:SetRange(LOCATION_GRAVE)
   e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
   e2:SetCondition(aux.exccon)
   e2:SetCost(c79034020.atkcost)
   e2:SetTarget(c79034020.atktg)
   e2:SetOperation(c79034020.atkop)
   c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c79034020.twocon)
	c:RegisterEffect(e4)
end
function c79034020.twocon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,79034021)
end
function c79034020.thfilter(c)
	return c:IsSetCard(0xca9) and c:IsLinkAbove(2)
end
function c79034020.thfilter1(c)
	return c:IsSetCard(0xca9)
end
function c79034020.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c79034020.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil,e,tp) and Duel.IsExistingMatchingCard(c79034020.thfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,0)
end
function c79034020.dsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c79034020.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),tp,2,REASON_COST)
end
function c79034020.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79034020.thfilter1,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c79034020.thfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end
function c79034020.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end