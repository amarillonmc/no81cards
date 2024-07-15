--幽骑兵将-火流星
function c46250008.initial_effect(c)
    c:SetSPSummonOnce(46250008)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetValue(c46250008.linklimit)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DAMAGE_STEP_END)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCondition(c46250008.spcon)
    e2:SetTarget(c46250008.sptg)
    e2:SetOperation(c46250008.spop)
    c:RegisterEffect(e2)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_DESTROY+CATEGORY_REMOVE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e4:SetTarget(c46250008.tsptg)
    e4:SetOperation(c46250008.tspop)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e5)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetTarget(c46250008.destg)
    e3:SetOperation(c46250008.desop)
    c:RegisterEffect(e3)
end
function c46250008.linklimit(e,c)
    if not c then return false end
    return not c:IsRace(RACE_WYRM)
end
function c46250008.spcon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return a and a:IsSetCard(0xfc0) or d and d:IsSetCard(0xfc0)
end
function c46250008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetFlagEffect(46250008)==0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:RegisterFlagEffect(46250008,RESET_CHAIN,0,1)
end
function c46250008.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c46250008.spfilter(c,atk)
    return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:GetAttack()<atk and c:IsDestructable() and c:IsAbleToRemove()
end
function c46250008.mzfilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c46250008.tsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c46250008.spfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,LOCATION_MZONE+LOCATION_EXTRA,1,nil,e:GetHandler():GetAttack())
        and Duel.IsPlayerCanSpecialSummonMonster(tp,46250001,0x1fc0,0x4011,1000,0,3,RACE_WYRM,ATTRIBUTE_DARK)end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c46250008.tspop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local n=2
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then n=1 end
    local g=Duel.GetMatchingGroup(c46250008.spfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,LOCATION_MZONE+LOCATION_EXTRA,nil,e:GetHandler():GetAttack())
    if not g then return end
    local dg=nil
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    if ft==1 then
        dg=g:Select(tp,1,1,nil)
        local tc=dg:GetFirst()
        if n==2 and g:IsExists(c46250008.mzfilter,1,tc,tp)
            and Duel.SelectYesNo(tp,aux.Stringid(46250008,0)) then
            if c46250008.mzfilter(tc,tp) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
                local dg2=g:Select(tp,1,1,tc)
                dg:Merge(dg2)
            else
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
                local dg2=g:FilterSelect(tp,c46250008.mzfilter,1,1,tc)
                dg:Merge(dg2)
            end
        end
    elseif ft==0 then
        dg=g:FilterSelect(tp,c46250008.mzfilter,1,n,nil)
    else
        dg=g:Select(tp,1,n,nil)
    end
    n=Duel.Destroy(dg,REASON_EFFECT,LOCATION_REMOVED)
    if n>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,46250001,0x1fc0,0x4011,1000,0,3,RACE_WYRM,ATTRIBUTE_DARK) then
        Duel.BreakEffect()
        for i=1,n do
            Duel.SpecialSummonStep(Duel.CreateToken(tp,46250001),0,tp,tp,false,false,POS_FACEUP)
        end
        Duel.SpecialSummonComplete()
    end
end
function c46250008.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c46250008.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    if not g then return end
    Duel.Destroy(g,REASON_EFFECT)
end
