--圣人的行方 圣白莲
function c60151322.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),6,2,c60151322.ovfilter,aux.Stringid(60151322,0),3,c60151322.xyzop)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151301,1))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c60151322.regcon)
    e1:SetTarget(c60151322.sptg)
    e1:SetOperation(c60151322.spop)
    c:RegisterEffect(e1)
    --EQUIP
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151322,1))
    e2:SetCategory(CATEGORY_DISABLE+CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e2:SetCondition(c60151322.setcon)
    e2:SetCost(c60151322.thcost)
    e2:SetTarget(c60151322.target)
    e2:SetOperation(c60151322.thop)
    c:RegisterEffect(e2)
    local e13=e2:Clone()
    e13:SetDescription(aux.Stringid(60151322,3))
    e13:SetType(EFFECT_TYPE_QUICK_O)
    e13:SetCode(EVENT_FREE_CHAIN)
    e13:SetHintTiming(0,0x1e0)
    e13:SetCondition(c60151322.setcon2)
    c:RegisterEffect(e13)
    --equip effect
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_LEVEL)
    e3:SetValue(3)
    e3:SetCondition(c60151322.con)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_RANK)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetValue(c60151322.atkup)
    e5:SetCondition(c60151322.con)
    c:RegisterEffect(e5)
end
function c60151322.ovfilter(c)
    return c:IsFaceup() and c:GetCode()~=60151322 and (c:GetLevel()==6 or c:GetRank()==6) and c:IsSetCard(0xcb23)
end
function c60151322.xyzop(e,tp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60151322.regcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c60151322.filter2(c,e,tp)
    return not c:IsType(TYPE_XYZ) and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151322.filter3(c,e,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEUP) and c:GetControler()==tp
        and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151322.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151322.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.IsExistingMatchingCard(c60151322.filter3,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
    local g=Duel.GetMatchingGroup(c60151322.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c60151322.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,3))
    local g=Duel.SelectMatchingCard(tp,c60151322.filter3,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        local tc=g:GetFirst()
        if tc:IsImmuneToEffect(e) then return end
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,2))
        local g1=Duel.SelectMatchingCard(tp,c60151322.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
        if g1:GetCount()>0 then
            local tc2=g1:GetFirst()
            if tc2:IsLocation(LOCATION_GRAVE) then Duel.HintSelection(g1) end
            Duel.Equip(tp,tc2,tc,true,true)
            Duel.EquipComplete()
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(c60151322.eqlimit)
            e1:SetLabelObject(tc)
            tc2:RegisterEffect(e1)
        end
    end
end
function c60151322.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c60151322.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c60151322.cfilter(c)
    return c:IsSetCard(0xcb23)
end
function c60151322.setcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(c60151322.cfilter,1,nil)
end
function c60151322.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
        and c:GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=c:GetEquipGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c60151322.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151322.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(c60151322.filter,tp,0,LOCATION_ONFIELD,nil)
    local tg=g:GetMaxGroup(Card.GetAttack)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,tg,1,0,0)
end
function c60151322.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60151322.filter,tp,0,LOCATION_ONFIELD,nil)
    if g:GetCount()>0 then
        if g:GetCount()>0 then
            Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151322,2))
            local sg=g:Select(tp,1,1,nil)
            Duel.HintSelection(sg)
            local tc=sg:GetFirst()
            if tc:IsImmuneToEffect(e) then return end
            Duel.NegateRelatedChain(tc,RESET_TURN_SET)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetValue(RESET_TURN_SET)
            e2:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e2)
            Duel.Equip(tp,tc,e:GetHandler(),false,true)
            Duel.EquipComplete()
            local e3=Effect.CreateEffect(e:GetHandler())
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_EQUIP_LIMIT)
            e3:SetReset(RESET_EVENT+0x1fe0000)
            e3:SetLabelObject(tc)
            e3:SetValue(c60151322.eqlimit2)
            tc:RegisterEffect(e3)
            local e4=Effect.CreateEffect(e:GetHandler())
            e4:SetType(EFFECT_TYPE_FIELD)
            e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e4:SetCode(EFFECT_CANNOT_ACTIVATE)
            e4:SetTargetRange(0,1)
            if Duel.GetTurnPlayer()~=tp then
                e4:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
            else
                e4:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
            end
            e4:SetValue(c60151322.aclimit)
            e4:SetLabel(tc:GetCode())
            Duel.RegisterEffect(e4,tp)
        end
    end
end
function c60151322.eqlimit2(e,c)
    return e:GetOwner()==c
end
function c60151322.aclimit(e,re,tp)
    return re:GetHandler():IsCode(e:GetLabel()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c60151322.cfilter2(c)
    return c:IsSetCard(0xcb23) and c:IsType(TYPE_XYZ)
end
function c60151322.setcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(c60151322.cfilter2,1,nil)
end
function c60151322.con(e,tp,eg,ep,ev,re,r,rp)
    local tg=e:GetHandler():GetEquipTarget()
    return tg:IsSetCard(0xcb23) and tg:IsType(TYPE_MONSTER)
end
function c60151322.atkup(e,c)
    if e:GetHandler():GetEquipTarget():IsType(TYPE_XYZ) then
        return e:GetHandler():GetEquipTarget():GetRank()*100
    else
        return e:GetHandler():GetEquipTarget():GetLevel()*100
    end
end