--E・HEROソリッド
function c115072031.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,115072031)
    e1:SetCost(c115072031.spcost)
    e1:SetTarget(c115072031.sptg)
    e1:SetOperation(c115072031.spop)
    c:RegisterEffect(e1)
    --revive 
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1,115072031)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(c115072031.gvcost)
    e2:SetTarget(c115072031.gvtg)
    e2:SetOperation(c115072031.gvop)
    c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_HAND,0)
    e3:SetTarget(c115072031.etarget)
    c:RegisterEffect(e3)
    --
    local e4=Effect.CreateEffect(c)
    e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_ADD_FUSION_SETCODE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(0xad)
    c:RegisterEffect(e4)
end

function c115072031.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c115072031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c115072031.spfilter(c,e,tp)
    return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and not c:IsCode(115072031) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c115072031.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
        if Duel.IsExistingMatchingCard(c115072031.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
            and Duel.SelectYesNo(tp,aux.Stringid(115072031,1)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=Duel.SelectMatchingCard(tp,c115072031.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end

function c115072031.gvfilter(c,e,tp)
    return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c115072031.gvcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c115072031.gvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c115072031.gvfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c115072031.gvfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c115072031.gvfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c115072031.gvop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end

function c115072031.etarget(e,c)
    return c:IsSetCard(0xa5) and c:IsType(TYPE_QUICKPLAY)
end
