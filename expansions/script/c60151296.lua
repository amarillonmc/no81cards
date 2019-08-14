--太极生两仪
function c60151296.initial_effect(c)
    --add code
    local e99=Effect.CreateEffect(c)
    e99:SetType(EFFECT_TYPE_SINGLE)
    e99:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e99:SetCode(EFFECT_ADD_CODE)
    e99:SetValue(60151299)
    c:RegisterEffect(e99)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,60151296)
    e1:SetTarget(c60151296.target)
    e1:SetOperation(c60151296.operation)
    c:RegisterEffect(e1)
    --salvage
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,60151296)
    e2:SetCost(c60151296.cost)
    e2:SetTarget(c60151296.tg)
    e2:SetOperation(c60151296.op)
    c:RegisterEffect(e2)
end
function c60151296.filter(c,e,tp,m)
    if not c:IsSetCard(0xab23) or bit.band(c:GetType(),0x81)~=0x81
        or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) or c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    if c.mat_filter then
        mg=mg:Filter(c.mat_filter,nil)
    end
    return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c60151296.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp)
        mg:RemoveCard(e:GetHandler())
        if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then
            return Duel.IsExistingMatchingCard(c60151296.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
        else
            return Duel.IsExistingMatchingCard(c60151296.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
        end
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c60151296.operation(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetRitualMaterial(tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then
        local tg=Duel.SelectMatchingCard(tp,c60151296.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
        local tc=tg:GetFirst()
        if tc then
            if tc:IsLocation(LOCATION_GRAVE) then Duel.HintSelection(tg) end
            mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
            if tc.mat_filter then
                mg=mg:Filter(tc.mat_filter,nil)
            end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
            tc:SetMaterial(mat)
            Duel.ReleaseRitualMaterial(mat)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
            tc:CompleteProcedure()
        end
    else
        local tg=Duel.SelectMatchingCard(tp,c60151296.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
        local tc=tg:GetFirst()
        if tc then
            mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
            if tc.mat_filter then
                mg=mg:Filter(tc.mat_filter,nil)
            end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
            tc:SetMaterial(mat)
            Duel.ReleaseRitualMaterial(mat)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
            tc:CompleteProcedure()
        end
    end
end
function c60151296.condition3(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c60151296.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c60151296.thfilter(c,e,tp)
    return c:IsSetCard(0xab23) and not c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151296.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c60151296.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c60151296.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60151296.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c60151296.sumlimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c60151296.sumlimit(e,c)
    return not c:IsSetCard(0xab23)
end