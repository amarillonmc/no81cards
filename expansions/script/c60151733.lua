--天空的水晶部队 樱花公主
function c60151733.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    --spsummon condition
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(c60151733.splimit)
    c:RegisterEffect(e0)
    --special summon rule
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD)
    e9:SetCode(EFFECT_SPSUMMON_PROC)
    e9:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e9:SetRange(LOCATION_EXTRA)
    e9:SetCondition(c60151733.spcon)
    e9:SetOperation(c60151733.spop)
    c:RegisterEffect(e9)
    --dis
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151733,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetTarget(c60151733.distg)
    e1:SetOperation(c60151733.disop)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151733,1))
    e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,60151733)
    e2:SetTarget(c60151733.rmtg)
    e2:SetOperation(c60151733.rmop)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151733,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1,6011733)
    e3:SetTarget(c60151733.target2)
    e3:SetOperation(c60151733.operation2)
    c:RegisterEffect(e3)
end
function c60151733.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c60151733.ffilter(c)
    return c:IsFusionSetCard(0x3b26) and c:IsFusionType(TYPE_MONSTER)
end
function c60151733.spfilter(c,fc)
    return c60151733.ffilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c60151733.spfilter1(c,tp,g)
    return g:IsExists(c60151733.spfilter2,1,c,tp,c)
end
function c60151733.spfilter2(c,tp,mc)
    return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c60151733.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetReleaseGroup(tp):Filter(c60151733.spfilter,nil,c)
    return g:IsExists(c60151733.spfilter1,1,nil,tp,g)
end
function c60151733.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetReleaseGroup(tp):Filter(c60151733.spfilter,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c60151733.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c60151733.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c60151733.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function c60151733.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    --activate cost
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_ACTIVATE_COST)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(0,1)
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetCost(c60151733.costchk)
    e2:SetOperation(c60151733.costop)
    Duel.RegisterEffect(e2,tp)
end
function c60151733.costchk(e,te_or_c,tp)
    return Duel.CheckLPCost(tp,200)
end
function c60151733.costop(e,tp,eg,ep,ev,re,r,rp)
    Duel.PayLPCost(tp,200)
end
function c60151733.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c60151733.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
            Duel.BreakEffect()
            Duel.Damage(1-tp,800,REASON_EFFECT)
        end
    end
end
function c60151733.filter(c,e,tp)
    return c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151733.filter2(c,ft)
    if ft==0 then
        return c:IsType(TYPE_MONSTER) and c:IsDestructable()
            and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
    else
        return c:IsType(TYPE_MONSTER) and c:IsDestructable()
            and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
    end
end
function c60151733.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151733.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,ft)
        and Duel.IsExistingTarget(c60151733.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c60151733.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    local g2=Duel.GetMatchingGroup(c60151733.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,ft)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c60151733.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectMatchingCard(tp,c60151733.filter2,tp,LOCATION_MZONE,0,1,1,nil,ft)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            if Duel.Destroy(g,REASON_EFFECT)~=0 then
                if tc:IsRelateToEffect(e) then
                    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectMatchingCard(tp,c60151733.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,ft)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            if Duel.Destroy(g,REASON_EFFECT)~=0 then
                if tc:IsRelateToEffect(e) then
                    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    end
end
