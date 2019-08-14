--天空的水晶部队 无闻的摄影师
function c60151703.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151703,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,60151703)
    e1:SetTarget(c60151703.target)
    e1:SetOperation(c60151703.operation)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151703,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,6011703)
    e3:SetTarget(c60151703.target2)
    e3:SetOperation(c60151703.operation2)
    c:RegisterEffect(e3)
end
function c60151703.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) 
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsPlayerCanSpecialSummonMonster(tp,60151783,0,0x4011,-2,-2,4,RACE_SPELLCASTER,ATTRIBUTE_WIND) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c60151703.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,60151783,0,0x4011,-2,-2,4,RACE_SPELLCASTER,ATTRIBUTE_WIND) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        local tc=g:GetFirst()
        local atk=tc:GetAttack()
        local def=tc:GetDefense()
        local token=Duel.CreateToken(tp,60151783)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(atk)
        token:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_DEFENSE)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        e2:SetValue(def)
        token:RegisterEffect(e2,true)
    end
end
function c60151703.filter(c,e,tp)
    return c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151703.filter2(c,ft)
    if ft==0 then
        return c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
            and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
    else
        return c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
            and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
    end
end
function c60151703.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151703.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,ft)
        and Duel.IsExistingTarget(c60151703.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c60151703.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    local g2=Duel.GetMatchingGroup(c60151703.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,ft)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c60151703.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectMatchingCard(tp,c60151703.filter2,tp,LOCATION_MZONE,0,1,1,nil,ft)
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
        local g=Duel.SelectMatchingCard(tp,c60151703.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,ft)
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
