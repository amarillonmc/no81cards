--影霊衣の舞姫
function c115273861.initial_effect(c)
    --act limit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(c115273861.chainop)
    c:RegisterEffect(e1)
    --cannot be target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c115273861.tgtg)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    --tohand
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_RELEASE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,115273861)
    e3:SetCondition(c115273861.thcon)
    e3:SetTarget(c115273861.thtg)
    e3:SetOperation(c115273861.thop)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND)
    e4:SetCountLimit(1,115273861)
    e4:SetCost(c115273861.spcost)
    e4:SetTarget(c115273861.sptg)
    e4:SetOperation(c115273861.spop)
    c:RegisterEffect(e4)
end
function c115273861.chainop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsSetCard(0x10b4) and re:IsActiveType(TYPE_RITUAL) then
        Duel.SetChainLimit(c115273861.chainlm)
    end
end
function c115273861.chainlm(e,rp,tp)
    return tp==rp
end
function c115273861.tgtg(e,c)
    return c:IsSetCard(0x10b4) and c:IsType(TYPE_RITUAL)
end
function c115273861.thcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT)~=0
end
function c115273861.thfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x10b4) and c:IsType(TYPE_MONSTER) and not c:IsCode(115273861) and c:IsAbleToHand()
end
function c115273861.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c115273861.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c115273861.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c115273861.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c115273861.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end

function c115273861.costfilter(c)
    return c:IsSetCard(0x10b4) and c:IsDiscardable()
end
function c115273861.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable()
        and Duel.IsExistingMatchingCard(c115273861.costfilter,tp,LOCATION_HAND,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c115273861.costfilter,tp,LOCATION_HAND,0,1,1,c)
    g:AddCard(c)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c115273861.spfilter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x10b4) and c:IsType(TYPE_MONSTER) and not c:IsCode(115273861) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c115273861.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c115273861.spfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c115273861.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c115273861.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c115273861.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CANNOT_ATTACK)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            Duel.SpecialSummonComplete()
        end
    end
end