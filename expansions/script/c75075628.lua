--授予人类安宁之梦
function c75075628.initial_effect(c)
    c:SetUniqueOnField(1,0,2648201)
	-- Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    -- 抗性赋予
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetRange(LOCATION_SZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCondition(c75075628.imcon)
    e1:SetValue(c75075628.efilter)
    c:RegisterEffect(e1)
    -- 发动场地
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(75075628,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c75075628.con3)
    e2:SetTarget(c75075628.tg3)
    e2:SetOperation(c75075628.op3)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
end
-- 2
function c75075628.imcon(e)
    return Duel.GetCurrentPhase()==PHASE_STANDBY
end
function c75075628.efilter(e,te)
    return not te:GetHandler():IsSetCard(0x5754)
end
-- 3
function c75075628.cfilter(c)
    return c:IsSetCard(0x5754) and c:IsType(TYPE_MONSTER)
end
function c75075628.con3(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c75075628.cfilter,1,nil)
end
function c75075628.ffilter(c)
    return c:IsSetCard(0x5754) and c:IsType(TYPE_FIELD)
end
function c75075628.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c75075628.ffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOFIELD,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c75075628.op3(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c75075628.ffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
    end
end
