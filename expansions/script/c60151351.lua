--醒悟的世界
function c60151351.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151351,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c60151351.target)
    e1:SetOperation(c60151351.activate)
    c:RegisterEffect(e1)
end
function c60151351.filter1(c,e,tp)
    if c:IsType(TYPE_XYZ) then
        local rk=c:GetRank()
        return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb23) and not c:IsType(TYPE_LINK)
            and Duel.IsExistingMatchingCard(c60151351.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+3)
    else
        local rk=c:GetLevel()
        return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb23) and not c:IsType(TYPE_LINK)
            and Duel.IsExistingMatchingCard(c60151351.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+3)
    end
end
function c60151351.filter2(c,e,tp,mc,rk)
    return c:GetRank()==rk and c:IsSetCard(0xcb23) and mc:IsCanBeXyzMaterial(c)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and not c:IsType(TYPE_LINK)
end
function c60151351.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c60151351.filter1(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingTarget(c60151351.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c60151351.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60151351.spfilter(c,rk2)
    if c:IsType(TYPE_XYZ) then
        return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb23) and c:GetRank()<rk2 and not c:IsType(TYPE_LINK)
    else
        return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb23) and c:GetLevel()<rk2 and not c:IsType(TYPE_LINK)
    end
end
function c60151351.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
    if tc:IsType(TYPE_XYZ) then
        local rk=tc:GetRank()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c60151351.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,rk+3)
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
            local rk2=sc:GetRank()
            local g1=Duel.GetMatchingGroup(c60151351.spfilter,tp,LOCATION_EXTRA,0,nil,rk2)
            if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151351,1)) then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151351,2))
                local sg=g1:Select(tp,1,1,nil)
                Duel.Overlay(sc,sg)
            end
        end
    else
        local rk=tc:GetLevel()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c60151351.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,rk+3)
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
            local rk2=sc:GetRank()
            local g1=Duel.GetMatchingGroup(c60151351.spfilter,tp,LOCATION_EXTRA,0,nil,rk2)
            if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151351,1)) then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151351,2))
                local sg=g1:Select(tp,1,1,nil)
                Duel.Overlay(sc,sg)
            end
        end 
    end
end