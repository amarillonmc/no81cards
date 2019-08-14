--绘雨 无形的威胁
function c60150631.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),5,4,c60150631.ovfilter,aux.Stringid(60150631,0),4,c60150631.xyzop)
    c:EnableReviveLimit()
    --pendulum set
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c60150631.pctg)
    e1:SetOperation(c60150631.pcop)
    c:RegisterEffect(e1)
    --immune
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c60150631.immunecon)
    e1:SetValue(c60150631.efilter)
    c:RegisterEffect(e1)
    --destroy replace
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetCode(EFFECT_DESTROY_REPLACE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetTarget(c60150631.reptg)
    c:RegisterEffect(e7)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetCondition(c60150631.condition)
    e2:SetOperation(c60150631.operation)
    c:RegisterEffect(e2)
end
function c60150631.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5b21)
end
function c60150631.xyzop(e,tp,chk)
    if chk==0 then return true end
end
function c60150631.pcfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c60150631.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)
    if chk==0 then return b1 and Duel.IsExistingMatchingCard(c60150631.pcfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
end
function c60150631.pcop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local b1=Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)
    if not b1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c60150631.pcfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c60150631.immuneconfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x3b21) and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c60150631.immunecon(e,c,tp)
    return Duel.IsExistingMatchingCard(c60150631.immuneconfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c60150631.efilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c60150631.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    if Duel.SelectYesNo(tp,aux.Stringid(60150631,1)) then
        c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
        return true
    else return false end
end
function c60150631.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc and bc:IsFaceup() 
        and bc:IsRelateToBattle() and e:GetHandler():GetOverlayCount()~=0
end
function c60150631.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    local atk=bc:GetAttack()
    local def=bc:GetDefense()
    if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
        if atk>def then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(atk/2)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            c:RegisterEffect(e1)
        else
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(def/2)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            c:RegisterEffect(e1)
        end
    end
end