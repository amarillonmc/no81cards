-- 渊灵涡漩
function c10200019.initial_effect(c)
    -- 卡组特招
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10200019,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,10200019)
    e1:SetTarget(c10200019.tg1)
    e1:SetOperation(c10200019.op1)
    c:RegisterEffect(e1)
    -- 除外检索
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10200019,1))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,10200020)
    e2:SetCondition(aux.exccon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c10200019.tg2)
    e2:SetOperation(c10200019.op2)
    c:RegisterEffect(e2)
end
-- 1
function c10200019.filter(c,e,tp)
    return c:IsSetCard(0xe21) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10200019.filter1(c,e)
    return c:IsSetCard(0xe21) and c:IsDestructable() and c~=e:GetHandler() and c:IsFaceup()
end
function c10200019.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and c10200019.filter1(chkc,e) end
    if chk==0 then return Duel.IsExistingTarget(c10200019.filter1,tp,LOCATION_ONFIELD,0,1,nil,e)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c10200019.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c10200019.filter1,tp,LOCATION_ONFIELD,0,1,1,nil,e)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200019.op1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c10200019.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
    end
end
-- 2
function c10200019.filter2(c)
    return c:IsSetCard(0xe21) and c:IsAbleToHand()
end
function c10200019.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) then
            return false
        end
        return Duel.IsExistingMatchingCard(c10200019.filter2,tp,LOCATION_DECK,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200019.op2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
    if #dg>0 then
        Duel.Destroy(dg,REASON_EFFECT)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c10200019.filter2,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end