--混沌的布信
function c11771560.initial_effect(c)
    -- 场地魔法激活
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    -- 1 同调召唤
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(11771560,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_SZONE)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e2:SetCountLimit(1,11771560)
    e2:SetCondition(c11771560.con1)
    e2:SetTarget(c11771560.tg1)
    e2:SetOperation(c11771560.op1)
    c:RegisterEffect(e2)
    -- 2 我方光属性怪兽抗性
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c11771560.tg2)
    e3:SetValue(c11771560.val1)
    e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e3:SetDescription(aux.Stringid(11771560,1))
    c:RegisterEffect(e3)
    -- 3 对方光属性怪兽抗性
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetTarget(c11771560.tg2)
    e4:SetValue(c11771560.val2)
    e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e4:SetDescription(aux.Stringid(11771560,1))
    c:RegisterEffect(e4)
    -- 4 我方暗属性怪兽抗性
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetRange(LOCATION_SZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c11771560.tg3)
    e5:SetValue(c11771560.val3)
    e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e5:SetDescription(aux.Stringid(11771560,2))
    c:RegisterEffect(e5)
    -- 5 对方暗属性怪兽抗性
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetRange(LOCATION_SZONE)
    e6:SetTargetRange(0,LOCATION_MZONE)
    e6:SetTarget(c11771560.tg3)
    e6:SetValue(c11771560.val4)
    e6:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e6:SetDescription(aux.Stringid(11771560,2))
    c:RegisterEffect(e6)
end
-- 1
function c11771560.con1(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c11771560.filter1(c,tp,mg)
    return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsSynchroSummonable(nil,mg)
end
function c11771560.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
        return Duel.IsExistingMatchingCard(c11771560.filter1,tp,LOCATION_EXTRA,0,1,nil,tp,mg)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11771560.op1(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tc=Duel.SelectMatchingCard(tp,c11771560.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp,mg):GetFirst()
    if tc then
        Duel.SynchroSummon(tp,tc,nil,mg)
    end
end
-- 2
function c11771560.tg2(e,c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c11771560.val1(e,te)
    local tc=te:GetHandler()
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and not tc:IsAttribute(ATTRIBUTE_DARK)
end
function c11771560.val2(e,te)
    local tc=te:GetHandler()
    return te:GetOwnerPlayer()==e:GetHandlerPlayer() and not tc:IsAttribute(ATTRIBUTE_DARK)
end
function c11771560.tg3(e,c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c11771560.val3(e,te)
    local tc=te:GetHandler()
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and not tc:IsAttribute(ATTRIBUTE_LIGHT)
end
function c11771560.val4(e,te)
    local tc=te:GetHandler()
    return te:GetOwnerPlayer()==e:GetHandlerPlayer() and not tc:IsAttribute(ATTRIBUTE_LIGHT)
end
