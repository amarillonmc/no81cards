--感情的摩天楼
function c60151357.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151357,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1,60151357)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCost(c60151357.negcost)
    e3:SetTarget(c60151357.sptg)
    e3:SetOperation(c60151357.spop)
    c:RegisterEffect(e3)
    --special summon2
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151357,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1,6011357)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTarget(c60151357.target)
    e3:SetOperation(c60151357.activate)
    c:RegisterEffect(e3)
end
function c60151357.cfilter(c)
    return c:IsAbleToGraveAsCost()
end
function c60151357.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151357.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60151357.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c60151357.filter(c,e,tp)
    return c:IsSetCard(0xcb23) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151357.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60151357.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60151357.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60151357.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c60151357.filter1(c,e,tp)
    if c:IsType(TYPE_XYZ) then
        local rk=c:GetRank()
        return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb23) and not c:IsType(TYPE_LINK)
            and Duel.IsExistingMatchingCard(c60151357.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk)
    else
        local rk=c:GetLevel()
        return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb23) and not c:IsType(TYPE_LINK)
            and Duel.IsExistingMatchingCard(c60151357.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk)
    end
end
function c60151357.filter2(c,e,tp,mc,rk)
    return c:GetRank()==rk and c:IsSetCard(0xcb23) and mc:IsCanBeXyzMaterial(c)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c60151357.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c60151357.filter1(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingTarget(c60151357.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c60151357.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60151357.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
    if tc:IsType(TYPE_XYZ) then
        local rk=tc:GetRank()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c60151357.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,rk)
        local sc=g:GetFirst()
        if sc then
            local mg=tc:GetOverlayGroup()
            if mg:GetCount()~=0 then
                Duel.Overlay(sc,mg)
            end
            sc:SetMaterial(Group.FromCards(tc))
            Duel.Overlay(sc,Group.FromCards(tc))
            Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
            sc:CompleteProcedure()
        end
    else
        local rk=tc:GetLevel()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c60151357.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,rk)
        local sc=g:GetFirst()
        if sc then
            local mg=tc:GetOverlayGroup()
            if mg:GetCount()~=0 then
                Duel.Overlay(sc,mg)
            end
            sc:SetMaterial(Group.FromCards(tc))
            Duel.Overlay(sc,Group.FromCards(tc))
            Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
            sc:CompleteProcedure()
        end 
    end
end