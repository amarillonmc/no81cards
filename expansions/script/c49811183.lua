--A・O・J ドレッドストル
function c49811183.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    --remove
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811183,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_CONFIRM)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCondition(c49811183.rmcon)
    e1:SetTarget(c49811183.rmtg)
    e1:SetOperation(c49811183.rmop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811183,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(c49811183.spcon)
    e2:SetTarget(c49811183.sptg)
    e2:SetOperation(c49811183.spop)
    c:RegisterEffect(e2)
end
function c49811183.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() and not bc:IsAttribute(ATTRIBUTE_DARK)
end
function c49811183.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=e:GetHandler():GetBattleTarget()
    if chk==0 then return tc and tc:IsControler(1-tp) and tc:IsAbleToRemove(tp,POS_FACEDOWN) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c49811183.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetBattleTarget()
    if tc:IsRelateToBattle() then
        Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
    end
end
function c49811183.spfilter(c,e,tp)
    if not (c:IsCode(26593852) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end
    if c:IsLocation(LOCATION_EXTRA) then
        return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
    else
        return Duel.GetMZoneCount(tp)>0
    end
end
function c49811183.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetReasonPlayer()==1-tp
        and e:GetHandler():IsPreviousControler(tp)
end
function c49811183.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811183.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c49811183.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811183.spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        Duel.SpecialSummonComplete()
    end
end