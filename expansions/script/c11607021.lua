--璀璨原钻对撞
function c11607021.initial_effect(c)
    --通常魔法
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,11607021+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c11607021.tg)
    e1:SetOperation(c11607021.op)
    c:RegisterEffect(e1)
end
function c11607021.filter(c)
    return c:IsSetCard(0x6225) and c:IsType(TYPE_MONSTER)
end
function c11607021.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c11607021.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) 
        and Duel.IsExistingMatchingCard(c11607021.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCode()) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11607021.thfilter(c,code)
    return c:IsSetCard(0x6225) and c:IsAbleToHand() and not c:IsCode(11607021)
end
function c11607021.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,c11607021.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
        local code=e:GetHandler():GetCode()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=Duel.SelectMatchingCard(tp,c11607021.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
        if sg:GetCount()>0 then
            Duel.SendtoHand(sg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,sg)
        end
    end
end
