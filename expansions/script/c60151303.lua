--妖怪寺中的恶魔 圣白莲
function c60151303.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151301,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,60151303)
    e1:SetTarget(c60151303.sptg)
    e1:SetOperation(c60151303.spop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --Special Summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151301,1))
    e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
    e3:SetCategory(CATEGORY_EQUIP)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetCountLimit(1,6011303)
    e3:SetCondition(c60151303.sumcon)
    e3:SetTarget(c60151303.sumtg)
    e3:SetOperation(c60151303.sumop)
    c:RegisterEffect(e3)
    --equip effect
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetValue(c60151303.tgvalue)
    e4:SetCondition(c60151303.con)
    c:RegisterEffect(e4)
end
function c60151303.tgfilter(c)
    return c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60151303.tgfilter2(c)
    return c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c60151303.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151303.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60151303.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60151303.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        local g1=Duel.GetMatchingGroup(c60151303.tgfilter2,tp,LOCATION_DECK,0,nil)
        if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151303,1)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
            local sg=g1:Select(tp,1,1,nil)
            Duel.SendtoGrave(sg,REASON_EFFECT)
        end
    end
end
function c60151303.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():GetLocation()~=LOCATION_DECK 
        and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and not e:GetHandler():IsReason(REASON_BATTLE)
end
function c60151303.filter2(c,e,tp)
    return c:GetCode()~=60151303 and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151303.filter3(c,e,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEUP) and c:GetControler()==tp
        and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151303.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151303.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.IsExistingMatchingCard(c60151303.filter3,tp,LOCATION_ONFIELD,0,1,nil,e,tp) 
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    local g=Duel.GetMatchingGroup(c60151303.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c60151303.sumop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,3))
    local g=Duel.SelectMatchingCard(tp,c60151303.filter3,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        local tc=g:GetFirst()
        if tc:IsImmuneToEffect(e) then return end
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,2))
        local g1=Duel.SelectMatchingCard(tp,c60151303.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
        if g1:GetCount()>0 then
            Duel.HintSelection(g1)
            local tc2=g1:GetFirst()
            Duel.Equip(tp,tc2,tc,true,true)
            Duel.EquipComplete()
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(c60151303.eqlimit)
            e1:SetLabelObject(tc)
            tc2:RegisterEffect(e1)
        end
    end
end
function c60151303.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c60151303.filter4(c)
    return c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151303.con(e,tp,eg,ep,ev,re,r,rp)
    local tg=e:GetHandler():GetEquipTarget()
    return tg:IsSetCard(0xcb23) and tg:IsType(TYPE_MONSTER)
end
function c60151303.efilter(e,te)
    return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c60151303.tgvalue(e,re,rp)
    return rp~=e:GetHandlerPlayer()
end