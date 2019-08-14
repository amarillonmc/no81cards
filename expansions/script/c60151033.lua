--蜕变的愿望
function c60151033.initial_effect(c)
    c:EnableCounterPermit(0x101b)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_DRAW_PHASE)
    e1:SetCountLimit(1,60151033+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c60151033.cost)
    e1:SetOperation(c60151033.operation)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c60151033.target)
    e2:SetOperation(c60151033.operation2)
    c:RegisterEffect(e2)
end
function c60151033.costfilter2(c,e,tp)
    return c:IsSetCard(0x5b23) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER)
end
function c60151033.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151033.costfilter2,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,c60151033.costfilter2,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_COST)
end
function c60151033.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    --
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(0,1)
    e3:SetTarget(c60151033.splimit)
    e:GetHandler():RegisterEffect(e3,tp)
    --
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetLabel(0)
    e1:SetCondition(c60151033.drcon)
    e1:SetOperation(c60151033.drop)
    e:GetHandler():RegisterEffect(e1,tp)
end
function c60151033.splimit(e,c,tp,sumtp,sumpos)
    return c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_LINK) or c:IsType(TYPE_XYZ))
end
function c60151033.cfilter(c,tp)
    return c:IsControler(1-tp) and (c:GetSummonType()==SUMMON_TYPE_XYZ or c:GetSummonType()==SUMMON_TYPE_LINK)
end
function c60151033.drcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c60151033.cfilter,1,nil,tp)
end
function c60151033.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if e:GetLabel()==0 then
        Duel.Hint(HINT_CARD,0,60151033)
        Duel.Recover(tp,1000,REASON_EFFECT)
        e:GetHandler():AddCounter(0x101b,1)
    end
end
function c60151033.filter(c,e,tp,atk)
    return c:IsSetCard(0x5b23) and c:IsRace(RACE_FIEND) 
        and c:GetAttack()<=atk and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c60151033.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60151033.operation2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=e:GetHandler():GetCounter(0x101b)
    local val=ct*1000
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCountFromEx(tp)<=0 
        or not Duel.IsExistingMatchingCard(c60151033.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,val) 
        or c:GetCounter(0x101b)==0 then 
        Duel.Destroy(c,REASON_EFFECT)
    end
    e:GetHandler():RemoveCounter(tp,0x101b,ct,REASON_EFFECT)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60151033.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,val)
    local tc=g:GetFirst()
    if tc:IsType(TYPE_XYZ) then
        if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0 then
            c:CancelToGrave()
            Duel.Overlay(tc,Group.FromCards(c))
        end
    elseif tc:IsType(TYPE_LINK) then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
    end
    local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc2=g2:GetFirst()
    while tc2 do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(0)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc2:RegisterEffect(e1)
        tc2=g2:GetNext()
    end
    if c:IsLocation(LOCATION_SZONE) then
        Duel.Destroy(c,REASON_EFFECT)
    end
end