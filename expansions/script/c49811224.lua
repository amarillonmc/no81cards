--相剣師－軒轅
function c49811224.initial_effect(c)
	--immune
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811224,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,49811224)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c49811224.cost)
    e1:SetTarget(c49811224.imtg)
    e1:SetOperation(c49811224.imop)
    c:RegisterEffect(e1)
    --sp summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811224,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_REMOVE)
    e2:SetCountLimit(1,49811225)
    e2:SetCondition(c49811224.spcon)
    e2:SetTarget(c49811224.sptg)
    e2:SetOperation(c49811224.spop)
    c:RegisterEffect(e2)
    --recover
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811224,3))
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetCountLimit(1,49811226)
    e3:SetCondition(c49811224.reccon)
    e3:SetTarget(c49811224.rectg)
    e3:SetOperation(c49811224.recop)
    c:RegisterEffect(e3)
end
function c49811224.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c49811224.ifilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x16b) or (c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_WRYM)))
end
function c49811224.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c49811224.ifilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c49811224.ifilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c49811224.ifilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c49811224.imop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetValue(c49811224.imfilter)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
function c49811224.imfilter(e,te)
    return te:GetOwner()~=e:GetOwner() and te:IsActiveType(TYPE_MONSTER)
end
function c49811224.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c49811224.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49811224.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,20001444,0x16b,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,4,RACE_WYRM,ATTRIBUTE_WATER)
            and Duel.SelectYesNo(tp,aux.Stringid(49811224,2)) then
                Duel.BreakEffect()
                local token=Duel.CreateToken(tp,49811225)
                Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_FIELD)
                e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
                e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
                e1:SetRange(LOCATION_MZONE)
                e1:SetAbsoluteRange(tp,1,0)
                e1:SetTarget(c49811224.splimit)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                token:RegisterEffect(e1,true)
                Duel.SpecialSummonComplete()
        end
    end
end
function c49811224.splimit(e,c)
    return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c49811224.reccon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c49811224.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1500)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function c49811224.recop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end