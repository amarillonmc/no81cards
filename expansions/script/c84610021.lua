--魔法少女たちの夢
function c84610021.initial_effect(c)
    --tohand+search
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)    
    e1:SetCode(EVENT_FREE_CHAIN)    
    e1:SetCost(c84610021.cost)
    e1:SetTarget(c84610021.target)
    e1:SetOperation(c84610021.activate)
    c:RegisterEffect(e1)
end
function c84610021.cfilter(c)
    return (c:IsSetCard(0x3a) or c:IsSetCard(0x10) or (c:IsAttack(1850) and c:IsRace(RACE_SPELLCASTER)) or c:IsSetCard(0x98)) and c:IsDiscardable()
end
function c84610021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610021.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,c84610021.cfilter,1,1,REASON_DISCARD+REASON_COST,nil)
end
function c84610021.thfilter(c)
    return (c:IsCode(84610012) or c:IsCode(84610002) or c:IsCode(84610004) or c:IsCode(84610005))and c:IsAbleToHand()
end
function c84610021.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c84610021.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c84610021.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c84610021.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        ct=Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
    if ct>0 then
        local g2=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
        if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(84610021,0)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
            local sg=g2:Select(tp,1,1,nil)
            Duel.HintSelection(sg)
            local tc=sg:GetFirst()
            if tc:IsImmuneToEffect(e) then return false end
            Duel.Destroy(tc,REASON_RULE)
        end
    end
end
