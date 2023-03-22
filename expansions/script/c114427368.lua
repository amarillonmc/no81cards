--星光天使セイジ
function c114427368.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(114427368,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,114427368)
    e1:SetCost(c114427368.spcost)
    e1:SetTarget(c114427368.sptg)
    e1:SetOperation(c114427368.spop)
    c:RegisterEffect(e1)
    --effect gain
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetCondition(c114427368.effcon)
    e2:SetOperation(c114427368.effop)
    c:RegisterEffect(e2)
end

function c114427368.cfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c114427368.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c114427368.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,c114427368.cfilter,1,1,REASON_COST)
end
function c114427368.thfilter(c)
    return c:IsSetCard(0x86) and c:IsAbleToHand()
end
function c114427368.spfilter(c,e,tp)
    return c:IsSetCard(0x86) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c114427368.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c114427368.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c114427368.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c114427368.thfilter,tp,LOCATION_DECK,0,1,2,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c114427368.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
            and Duel.SelectYesNo(c,aux.Stringid(114427368,1)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=Duel.SelectMatchingCard(tp,c114427368.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
            if g:GetCount()>0 then
                Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
            end
        end
    end
end


function c114427368.effcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_XYZ and e:GetHandler():GetReasonCard():GetMaterial():IsExists(Card.IsPreviousLocation,3,nil,LOCATION_MZONE)
end
function c114427368.effop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,114427368)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    rc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(114427368,3))
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetDescription(aux.Stringid(114427368,2))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c114427368.xyzcost)
    e1:SetTarget(c114427368.xyztg)
    e1:SetOperation(c114427368.xyzop)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    rc:RegisterEffect(e1,true)
    if not rc:IsType(TYPE_EFFECT) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ADD_TYPE)
        e2:SetValue(TYPE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        rc:RegisterEffect(e2,true)
    end
end
function c114427368.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c114427368.xyzfilter(c)
    return c:IsSetCard(0x86) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c114427368.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c114427368.xyzfilter,tp,LOCATION_GRAVE,0,3,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,LOCATION_DECK)
end
function c114427368.xyzop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c114427368.xyzfilter,tp,LOCATION_GRAVE,0,3,3,nil)
    if g:GetCount()==3 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
