--封锁新月世界的机关
function c9911274.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911274+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9911274.cost)
	e1:SetTarget(c9911274.target)
	e1:SetOperation(c9911274.activate)
	c:RegisterEffect(e1)
	--remove grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911274,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c9911274.mvcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9911274.mvtg)
	e2:SetOperation(c9911274.mvop)
	c:RegisterEffect(e2)
end
function c9911274.rmfilter(c)
	return c:IsSetCard(0x9956) and c:IsAbleToRemoveAsCost()
end
function c9911274.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911274.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9911274.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local label=0
	if g:GetFirst():IsLocation(LOCATION_HAND) then label=1 end
	e:SetLabel(label)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9911274.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove(tp,POS_FACEDOWN) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,tp,POS_FACEDOWN) end
	local ct=1
	if e:GetLabel()==1 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,ct,nil,tp,POS_FACEDOWN)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function c9911274.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c9911274.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_MZONE)
		and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=c:GetControler())
end
function c9911274.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9911274.cfilter,1,nil)
end
function c9911274.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil,tp,POS_FACEDOWN)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c9911274.mvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil,tp,POS_FACEDOWN)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
