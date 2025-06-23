--策略 产能提效
function c65809101.initial_effect(c)
    -- 卡组·墓地检索
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(65809101,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c65809101.target)
    e1:SetOperation(c65809101.activate)
    c:RegisterEffect(e1)
end
function c65809101.filter1(c)
    return c:IsSetCard(0xca30) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c65809101.filter2(c)
    return c:IsSetCard(0xca30,0xaa30) and c:IsAbleToHand()
end
function c65809101.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(c65809101.filter1,tp,LOCATION_MZONE,0,1,nil)
            and Duel.IsExistingMatchingCard(c65809101.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c65809101.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local rg=Duel.SelectMatchingCard(tp,c65809101.filter1,tp,LOCATION_MZONE,0,1,1,nil)
    if rg:GetCount()>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 then
        local g=Duel.GetMatchingGroup(c65809101.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
        if g:GetCount()>=2 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg=g:Select(tp,2,2,nil)
            Duel.SendtoHand(sg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,sg)
        end
    end
end
