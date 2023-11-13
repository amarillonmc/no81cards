--バージェストマ・シフソクタム
function c49811201.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c49811201.target)
    e1:SetOperation(c49811201.activate)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811201,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
    e2:SetCondition(c49811201.spcon)
    e2:SetTarget(c49811201.sptg)
    e2:SetOperation(c49811201.spop)
    c:RegisterEffect(e2)
end
function c49811201.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c49811201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c49811201.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c49811201.filter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c49811201.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c49811201.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
        local g=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.Overlay(tc,g)
        end
    end
end
function c49811201.spcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c49811201.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,49811201,0xd4,TYPES_NORMAL_TRAP_MONSTER,1200,0,2,RACE_AQUA,ATTRIBUTE_WATER) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c49811201.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,49811201,0xd4,TYPES_NORMAL_TRAP_MONSTER,1200,0,2,RACE_AQUA,ATTRIBUTE_WATER) then
        c:AddMonsterAttribute(TYPE_NORMAL)
        Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_IMMUNE_EFFECT)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetValue(c49811201.efilter)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e2,true)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
        e3:SetValue(LOCATION_REMOVED)
        c:RegisterEffect(e3,true)
        Duel.SpecialSummonComplete()
    end
end
function c49811201.efilter(e,re)
    return re:IsActiveType(TYPE_MONSTER)
end