--于冥界的征战
function c54363163.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54363163,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,54363163+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c54363163.cost)
	e1:SetTarget(c54363163.tgtg)
	e1:SetOperation(c54363163.tgop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(54363163,2))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,54363163+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c54363163.cost1)
	e2:SetTarget(c54363163.rmtg)
	e2:SetOperation(c54363163.rmop)
	c:RegisterEffect(e2)
	--garve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(54363163,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,54363163)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c54363163.tgcost)
	e3:SetTarget(c54363163.tgtg)
	e3:SetOperation(c54363163.tgop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(54363163,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,54363163)
	e4:SetCondition(aux.exccon)
	e4:SetCost(c54363163.rmcost)
	e4:SetTarget(c54363163.rmtg)
	e4:SetOperation(c54363163.rmop)
	c:RegisterEffect(e4)
end
function c54363163.filter(c,e,tp)
	return (c:IsSetCard(0x1400) or c:IsCode(8198620,21435914,22657402,53982768,66547759,75043725,89272878,89732524,96163807,17484499,31467372,40703393,68304813))  and c:IsAbleToDeckOrExtraAsCost()
end
function c54363163.filter1(c,e,tp)
	return (c:IsSetCard(0x38) or c:IsCode(691925,19959563,22201234,24037702,30502181,32233746,35577420,36099620,52665542,57348141,57774843,60431417,61962135,83747250,94886282)) and c:IsAbleToDeckOrExtraAsCost()
end
function c54363163.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c54363163.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rg=Duel.SelectMatchingCard(tp,c54363163.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
end
function c54363163.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c54363163.filter1,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rg=Duel.SelectMatchingCard(tp,c54363163.filter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
end
function c54363163.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c54363163.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.HintSelection(g)
	Duel.SendtoGrave(tc,POS_FACEUP,REASON_EFFECT)
end
function c54363163.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c54363163.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.HintSelection(g)
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
function c54363163.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c54363163.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rg=Duel.SelectMatchingCard(tp,c54363163.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
end
function c54363163.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and  Duel.IsExistingMatchingCard(c54363163.filter1,tp,LOCATION_REMOVED,0,1,e:GetHandler(),e,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)  end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rg=Duel.SelectMatchingCard(tp,c54363163.filter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
end