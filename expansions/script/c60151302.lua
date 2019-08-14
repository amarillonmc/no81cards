--勇往直前的僧侣 圣白莲
function c60151302.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151301,0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,60151302)
    e1:SetTarget(c60151302.sptg)
    e1:SetOperation(c60151302.spop)
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
    e3:SetCountLimit(1,6011302)
    e3:SetCondition(c60151302.sumcon)
    e3:SetTarget(c60151302.sumtg)
    e3:SetOperation(c60151302.sumop)
    c:RegisterEffect(e3)
    --equip effect
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e4:SetCountLimit(1)
    e4:SetValue(c60151302.valcon)
    e4:SetCondition(c60151302.con)
    c:RegisterEffect(e4)
    --equip effect
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e5:SetCountLimit(1)
    e5:SetValue(c60151302.valcon2)
    e5:SetCondition(c60151302.con)
    c:RegisterEffect(e5)
end
function c60151302.tgfilter(c)
    return c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c60151302.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151302.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60151302.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60151302.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        if Duel.SendtoGrave(g,REASON_EFFECT) then
            if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
            local g=Duel.GetMatchingGroup(c60151302.filter3,tp,LOCATION_ONFIELD,0,nil,e,tp)
            local g1=Duel.GetMatchingGroup(c60151302.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
            if g:GetCount()>0 and g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151302,1)) then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,3))
                local sg=g:Select(tp,1,1,nil)
                Duel.HintSelection(sg)
                local tc=sg:GetFirst()
                if tc:IsImmuneToEffect(e) then return end
                Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,2))
                local sg2=g1:Select(tp,1,1,nil)
                local tc2=sg2:GetFirst()
                if tc2:IsLocation(LOCATION_GRAVE) then Duel.HintSelection(sg2) end
                Duel.Equip(tp,tc2,tc,true,true)
                Duel.EquipComplete()
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_EQUIP_LIMIT)
                e1:SetReset(RESET_EVENT+0x1fe0000)
                e1:SetValue(c60151302.eqlimit)
                e1:SetLabelObject(tc)
                tc2:RegisterEffect(e1)
            end
        end
    end
end
function c60151302.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():GetLocation()~=LOCATION_DECK 
        and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and not e:GetHandler():IsReason(REASON_BATTLE)
end
function c60151302.filter2(c,e,tp)
    return c:GetCode()~=60151302 and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151302.filter3(c,e,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEUP) and c:GetControler()==tp
        and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151302.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151302.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.IsExistingMatchingCard(c60151302.filter3,tp,LOCATION_ONFIELD,0,1,nil,e,tp) 
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    local g=Duel.GetMatchingGroup(c60151302.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c60151302.sumop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,3))
    local g=Duel.SelectMatchingCard(tp,c60151302.filter3,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        local tc=g:GetFirst()
        if tc:IsImmuneToEffect(e) then return end
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,2))
        local g1=Duel.SelectMatchingCard(tp,c60151302.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
        if g1:GetCount()>0 then
            Duel.HintSelection(g1)
            local tc2=g1:GetFirst()
            Duel.Equip(tp,tc2,tc,true,true)
            Duel.EquipComplete()
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(c60151302.eqlimit)
            e1:SetLabelObject(tc)
            tc2:RegisterEffect(e1)
        end
    end
end
function c60151302.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c60151302.filter4(c)
    return c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151302.con(e,tp,eg,ep,ev,re,r,rp)
    local tg=e:GetHandler():GetEquipTarget()
    return tg:IsSetCard(0xcb23) and tg:IsType(TYPE_MONSTER)
end
function c60151302.efilter(e,te)
    return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c60151302.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
function c60151302.valcon2(e,re,r,rp)
    return bit.band(r,REASON_EFFECT)~=0
end