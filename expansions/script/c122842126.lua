function c122842126.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCost(c122842126.cost)
    e1:SetTarget(c122842126.target)
    e1:SetOperation(c122842126.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,122842126)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c122842126.thtg)
    e2:SetOperation(c122842126.thop)
    c:RegisterEffect(e2)
end
function c122842126.cfilter(c)
    return c:IsSetCard(0xd2) and c:IsDestructable()
end
function c122842126.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c122842126.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    Duel.Destroy(Duel.SelectMatchingCard(tp,c122842126.cfilter,tp,LOCATION_HAND,0,1,1,nil),REASON_COST+REASON_EFFECT)
end
function c122842126.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c122842126.activate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function c122842126.thfilter(c)
    return c:IsSetCard(0xd2) and c:IsAbleToHand()
end
function c122842126.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c122842126.thfilter,tp,LOCATION_DECK,0,3,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c122842126.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c122842126.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>=3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg=g:Select(tp,3,3,nil)
        Duel.ConfirmCards(1-tp,sg)
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
        local tg=sg:Select(1-tp,1,1,nil)
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tg)
    end
end