--魔法的先贤 圣白莲
function c60151321.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),3,2)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151301,1))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c60151321.regcon)
    e1:SetTarget(c60151321.sptg)
    e1:SetOperation(c60151321.spop)
    c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151321,0))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,0x1e0)
    e2:SetCost(c60151321.thcost)
    e2:SetOperation(c60151321.thop)
    c:RegisterEffect(e2)
    --equip effect
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_LEVEL)
    e3:SetValue(3)
    e3:SetCondition(c60151321.con)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_RANK)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetValue(c60151321.atkup)
    e5:SetCondition(c60151321.con)
    c:RegisterEffect(e5)
end
function c60151321.regcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c60151321.filter2(c,e,tp)
    return not c:IsType(TYPE_XYZ) and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151321.filter3(c,e,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEUP) and c:GetControler()==tp
        and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151321.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151321.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.IsExistingMatchingCard(c60151321.filter3,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
    local g=Duel.GetMatchingGroup(c60151321.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c60151321.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,3))
    local g=Duel.SelectMatchingCard(tp,c60151321.filter3,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        local tc=g:GetFirst()
        if tc:IsImmuneToEffect(e) then return end
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,2))
        local g1=Duel.SelectMatchingCard(tp,c60151321.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
        if g1:GetCount()>0 then
            local tc2=g1:GetFirst()
            if tc2:IsLocation(LOCATION_GRAVE) then Duel.HintSelection(g1) end
            Duel.Equip(tp,tc2,tc,true,true)
            Duel.EquipComplete()
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(c60151321.eqlimit)
            e1:SetLabelObject(tc)
            tc2:RegisterEffect(e1)
        end
    end
end
function c60151321.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c60151321.dfilter2(c)
    return c:IsType(TYPE_EQUIP)
end
function c60151321.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
        and e:GetHandler():GetEquipGroup():FilterCount(c60151321.dfilter2,nil)>0 end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60151321.dfilter(c,atk)
    return c:IsFaceup()
end
function c60151321.thop(e,tp,eg,ep,ev,re,r,rp)
    local z=e:GetHandler():GetEquipCount()
    local atk=e:GetHandler():GetAttack()
    local g=Duel.GetMatchingGroup(c60151321.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,atk)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151321,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151321,2))
        local sg=g:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        Duel.Destroy(sg,REASON_EFFECT)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e1:SetValue(z*600)
    e:GetHandler():RegisterEffect(e1)
end
function c60151321.con(e,tp,eg,ep,ev,re,r,rp)
    local tg=e:GetHandler():GetEquipTarget()
    return tg:IsSetCard(0xcb23) and tg:IsType(TYPE_MONSTER)
end
function c60151321.atkup(e,c)
    if e:GetHandler():GetEquipTarget():IsType(TYPE_XYZ) then
        return e:GetHandler():GetEquipTarget():GetRank()*100
    else
        return e:GetHandler():GetEquipTarget():GetLevel()*100
    end
end