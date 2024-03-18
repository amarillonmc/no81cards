--天符「大日如来的光辉」
function c60151352.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_MSET,TIMING_SSET,TIMING_END_PHASE)
	e1:SetCountLimit(1,60151352+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c60151352.condition)
    e1:SetTarget(c60151352.target)
    e1:SetOperation(c60151352.operation)
    c:RegisterEffect(e1)
	--
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(c60151352.negcon)
    e2:SetCost(c60151352.negcost)
    e2:SetTarget(c60151352.target2)
    e2:SetOperation(c60151352.activate2)
    c:RegisterEffect(e2)
end
function c60151352.atkfilter1(c)
    return c:IsFacedown()
end
function c60151352.atkfilter2(c)
    return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function c60151352.condition(e,tp,eg,ep,ev,re,r,rp)
    local ct1=Duel.GetMatchingGroupCount(c60151352.atkfilter1,tp,0,LOCATION_ONFIELD,nil)
    local ct2=Duel.GetMatchingGroupCount(c60151352.atkfilter2,tp,LOCATION_ONFIELD,0,nil)
    return ct2>=ct1
end
function c60151352.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151352.atkfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(c60151352.atkfilter1,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c60151352.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60151352.atkfilter1,tp,0,LOCATION_ONFIELD,nil)
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c60151352.negcon(e,tp,eg,ep,ev,re,r,rp)
    return aux.exccon(e) and Duel.GetTurnPlayer()==tp
end
function c60151352.cfilter(c)
    return c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c60151352.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(c60151352.cfilter,tp,LOCATION_ONFIELD,0,2,nil) end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60151352.cfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c60151352.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60151352.activate2(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end