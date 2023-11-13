--バッグ・パック
function c49811199.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetDescription(aux.Stringid(49811199,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c49811199.cost)
    e1:SetTarget(c49811199.target)
    e1:SetOperation(c49811199.activate)
    c:RegisterEffect(e1)
end
function c49811199.lcfilter(c)
    return c:GetType()==TYPE_TRAP and not c:IsPublic()
end
function c49811199.srfilter(c,code)
    return c:GetType()==TYPE_TRAP and not c:IsCode(code) and c:IsAbleToHand()
end
function c49811199.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811199.lcfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,c49811199.lcfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.ConfirmCards(1-tp,g)
    e:SetLabel(g:GetFirst():GetCode())
end
function c49811199.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c49811199.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local code=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c49811199.srfilter,tp,LOCATION_DECK,0,1,1,nil,code)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SSET)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    Duel.RegisterEffect(e1,tp)
    Duel.AddCustomActivityCounter(49811199,ACTIVITY_CHAIN,c49811199.chainfilter)
end
function c49811199.chainfilter(re,tp,cid)
    return false
end