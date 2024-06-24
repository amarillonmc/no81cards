--雷の大剣 サイカ
function c260013020.initial_effect(c)
    c:SetSPSummonOnce(260013020)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c260013020.matfilter,1,1)
    
    --attack twice
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,260013020)   
    e1:SetCondition(c260013020.atkcon)
    e1:SetTarget(c260013020.atktg)
    e1:SetOperation(c260013020.atkop)
    c:RegisterEffect(e1)
    
    --pierce
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_XMATERIAL)
    e2:SetCode(EFFECT_PIERCE)
    e2:SetCondition(c260013020.picon)
    c:RegisterEffect(e2)
end


--【召喚ルール】
function c260013020.matfilter(c,lc,sumtype,tp)
    return c:IsLinkRace(RACE_SPELLCASTER)
end

--【2回攻撃】
function c260013020.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsAbleToEnterBP()
end
function c260013020.atkfilter(c)
    return c:IsFaceup() and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c260013020.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c260013020.atkfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c260013020.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c260013020.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
end
function c260013020.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e1:SetValue(1)
        tc:RegisterEffect(e1)
    end
end


--【X効果】
function c260013020.picon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSetCard(0x943)
end