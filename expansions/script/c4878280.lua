local m=4878280
local cm=_G["c"..m]
function cm.initial_effect(c)
aux.AddCodeList(c,4878196)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_ACTIVATE)
    e4:SetCode(EVENT_CHAINING)
	 e4:SetCountLimit(1,m)
    e4:SetCondition(cm.spcon1)
    e4:SetTarget(cm.target2)
    e4:SetOperation(cm.activate2)
    c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,m)
    e2:SetHintTiming(0,TIMING_END_PHASE)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(cm.target)
    e2:SetOperation(cm.activate)
    c:RegisterEffect(e2)
end
function cm.tgfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:IsSetCard(0xae5a)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
function cm.spfilter(c)
    return c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,4878196)
        and (c:IsLocation(LOCATION_MZONE) and c:IsFaceup())
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_MZONE,0,1,nil) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
         Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
    end
end