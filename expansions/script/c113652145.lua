function c113652145.initial_effect(c)
    c:EnableReviveLimit()
    aux.EnablePendulumAttribute(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
    e1:SetCondition(c113652145.spcon)
    e1:SetOperation(c113652145.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE+LOCATION_PZONE)
    e2:SetCode(EFFECT_SELF_DESTROY)
    e2:SetCondition(c113652145.descon)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c113652145.thcon)
    e3:SetTarget(c113652145.thtg)
    e3:SetOperation(c113652145.thop)
    c:RegisterEffect(e3)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetTarget(c113652145.ftg)
    e5:SetOperation(c113652145.fop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_EQUIP)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e6:SetRange(LOCATION_PZONE)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e6:SetCode(EVENT_REMOVE)
    e6:SetCondition(c113652145.tgcon)
    e6:SetTarget(c113652145.tgtg)
    e6:SetOperation(c113652145.tgop)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(113652145,0))
    e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e7:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c113652145.rcon)
    e7:SetOperation(c113652145.rop)
    c:RegisterEffect(e7)
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_SINGLE)
    ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    ea:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(ea)
end
function c113652145.spfilter(c)
    return c:IsSetCard(0x99) and not c:IsCode(113652145) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c113652145.spfilter2(c,tp)
    return c:IsHasEffect(48829461,tp) and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c113652145.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local b1=Duel.IsExistingMatchingCard(c113652145.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(c113652145.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
    return c:IsLocation(LOCATION_HAND) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and b1 or b2) or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0 and b1
end
function c113652145.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c113652145.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(c113652145.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
    if c:IsLocation(LOCATION_HAND) and b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(48829461,0))) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local tg=Duel.SelectMatchingCard(tp,c113652145.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
        local te=tg:GetFirst():IsHasEffect(48829461,tp)
        te:UseCountLimit(tp)
        Duel.Remove(tg,POS_FACEUP,REASON_COST)
    else
        local tg=Duel.SelectMatchingCard(tp,c113652145.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
        Duel.Remove(tg:GetFirst(),POS_FACEUP,REASON_COST)
    end
end
function c113652145.descon(e)
    local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
    local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
    return (f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown())
end
function c113652145.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c113652145.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDestructable() end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c113652145.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Destroy(c,REASON_EFFECT)
end
function c113652145.disable(e,c)
    return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and c:IsPosition(POS_FACEUP_DEFENSE)
end
function c113652145.ffilter(c,tp)
    return c:IsCode(27564031) and c:GetActivateEffect():IsActivatable(tp)
end
function c113652145.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c113652145.ffilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c113652145.fop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstMatchingCard(c113652145.ffilter,tp,LOCATION_DECK,0,nil,tp)
    if tc then
        local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
        if fc then
            Duel.SendtoGrave(fc,REASON_RULE)
            Duel.BreakEffect()
        end
        Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
        Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
    end
end
function c113652145.tgcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return eg:GetCount()==1 and tc:IsPreviousLocation(LOCATION_DECK+LOCATION_EXTRA) and tc:IsControler(tp) and tc:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c113652145.tgfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x23) and c:GetEquipCount()==0
end
function c113652145.eqfilter(c,tc)
    if not (c:IsAttribute(tc:GetAttribute()) and c:IsRace(tc:GetRace()) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()) then return false end
    if c:IsType(TYPE_LINK) then
        return false
    elseif c:IsType(TYPE_XYZ) then
        return c:GetOriginalRank()<=8
    else
        return c:GetOriginalLevel()<=8
    end
end
function c113652145.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c113652145.tgfilter(chkc) end
    if chk==0 then return e:GetHandler():IsRelateToEffect(e)
        and Duel.IsExistingMatchingCard(c113652145.eqfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,eg:GetFirst()) 
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c113652145.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c113652145.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:GetEquipCount()>0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local sg=Duel.SelectMatchingCard(tp,c113652145.eqfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,eg:GetFirst())
    if sg:GetCount()==0 then return end
    local sc=sg:GetFirst()
    Duel.Equip(tp,sc,tc,true)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    e1:SetValue(c113652145.eqlimit)
    e1:SetLabelObject(tc)
    sc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EFFECT_CHANGE_CODE)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    e2:SetValue(53025096)
    sc:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CHANGE_TYPE)
    e3:SetValue(TYPE_XYZ)
    sc:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_POSITION)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCondition(c113652145.poscon)
    e4:SetOperation(c113652145.posop)
    sc:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetRange(LOCATION_SZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c113652145.disable)
    e5:SetCode(EFFECT_DISABLE)
    sc:RegisterEffect(e5)
    Duel.BreakEffect()
    tc:CopyEffect(sc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,1)
end
function c113652145.eqlimit(e,c)
    return e:GetLabelObject()==c
end
function c113652145.poscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipTarget()
end
function c113652145.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local ec=c:GetEquipTarget()
    if ec then
        Duel.ChangePosition(ec,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
    end
end
function c113652145.rfilter(c)
    return c:IsSetCard(0x23) and c:IsAbleToGrave()
end
function c113652145.rcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ)
        and Duel.IsExistingMatchingCard(c113652145.rfilter,tp,LOCATION_DECK,0,1,nil)
end
function c113652145.rop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c113652145.rfilter,tp,LOCATION_DECK,0,1,bit.band(ev,0xffff),nil)
    Duel.SendtoGrave(g,REASON_EFFECT)
end