function c98730215.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c98730215.ffilter,2,false)
    aux.EnablePendulumAttribute(c,false)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c98730215.spcon)
    e1:SetOperation(c98730215.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(98730215,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,98730215)
    e2:SetCondition(c98730215.mvcon)
    e2:SetTarget(c98730215.mvtg)
    e2:SetOperation(c98730215.mvop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetValue(c98730215.synlimit)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetCondition(c98730215.rdcon)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LVCHANGE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCountLimit(1,98731215)
    e5:SetCondition(c98730215.effcon)
    e5:SetTarget(c98730215.efftg)
    e5:SetOperation(c98730215.effop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(98730215,0))
    e6:SetCategory(CATEGORY_EQUIP)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetRange(LOCATION_PZONE)
    e6:SetCountLimit(1,98730215)
    e6:SetTarget(c98730215.eqtg)
    e6:SetOperation(c98730215.eqop)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_EQUIP)
    e7:SetCode(EFFECT_UPDATE_ATTACK)
    e7:SetValue(1300)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_EQUIP)
    e8:SetCode(EFFECT_UPDATE_DEFENSE)
    e8:SetValue(1000)
    c:RegisterEffect(e8)
    local e9=Effect.CreateEffect(c)
    e9:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOEXTRA)
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCountLimit(1,98731215)
    e9:SetTarget(c98730215.tgtg)
    e9:SetOperation(c98730215.tgop)
    c:RegisterEffect(e9)
    local e10=Effect.CreateEffect(c)
    e10:SetCategory(CATEGORY_EQUIP)
    e10:SetType(EFFECT_TYPE_QUICK_O)
    e10:SetCode(EVENT_FREE_CHAIN)
    e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e10:SetRange(LOCATION_GRAVE)
    e10:SetCountLimit(1,98731215)
    e10:SetCondition(c98730215.hspcon)
    e10:SetCost(c98730215.hspcost)
    e10:SetTarget(c98730215.hsptg)
    e10:SetOperation(c98730215.hspop)
    c:RegisterEffect(e10)
end
function c98730215.ffilter(c)
    return (c:IsFusionAttribute(ATTRIBUTE_WATER) or c:IsRace(RACE_DRAGON)) and not c:IsType(TYPE_FUSION)
end
function c98730215.spfilter(c,fc)
    return c98730215.ffilter(c) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function c98730215.spfilter1(c,tp,g,tc)
    return g:IsExists(c98730215.spfilter2,1,c,tp,c,tc)
end
function c98730215.spfilter2(c,tp,mc,tc)
    return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc),tc)>0
end
function c98730215.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c98730215.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c)
    return g:IsExists(c98730215.spfilter1,1,nil,tp,g,c)
end
function c98730215.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(c98730215.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g1=g:FilterSelect(tp,c98730215.spfilter1,1,1,nil,tp,g,c)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g2=g:FilterSelect(tp,c98730215.spfilter2,1,1,mc,tp,mc,c)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Remove(g1,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c98730215.mvcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(aux.NOT(Card.IsAttribute),tp,LOCATION_PZONE,0,1,e:GetHandler(),ATTRIBUTE_WATER)
end
function c98730215.mvfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c98730215.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c98730215.mvfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98730215.mvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local pc=Duel.GetMatchingGroup(aux.NOT(Card.IsAttribute),tp,LOCATION_PZONE,0,e:GetHandler(),ATTRIBUTE_WATER):GetFirst()
    if not pc then return end
    if Duel.Destroy(pc,REASON_EFFECT)~=1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c98730215.mvfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,REASON_EFFECT)
    end
end
function c98730215.synlimit(e,c)
    if not c then return false end
    return not (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WATER))
end
function c98730215.rdcon(e)
    local c=e:GetHandler()
    local tp=e:GetHandlerPlayer()
    if c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_SYNCHRO) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_LEAVE_FIELD)
        e1:SetOperation(c98730215.rdop)
        e1:SetReset(RESET_CHAIN)
        Duel.RegisterEffect(e1,tp)
    end
    return false
end
function c98730215.rdop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then
        Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,REASON_EFFECT)
    end
end
function c98730215.effcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c98730215.efffilter(c,e,tp)
    return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WATER)) and c:IsFaceup() and c:GetLevel()<7 and c:GetLevel()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98730215.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c98730215.efffilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c98730215.efffilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c98730215.efffilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98730215.effop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
        local lv=tc:GetLevel()
        if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
            if tc:IsFaceup() then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_LEVEL)
                e1:SetValue(-lv)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                c:RegisterEffect(e1)
            end
        end
    end
end
function c98730215.eqfilter(c)
    return c:IsFaceup() and (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WATER))
end
function c98730215.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98730215.eqfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c98730215.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c98730215.eqfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c98730215.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.SendtoDeck(c,nil,nil,REASON_ADJUST)
    Duel.Equip(tp,c,tc,true)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    e1:SetLabelObject(tc)
    e1:SetValue(c98730215.eqlimit)
    c:RegisterEffect(e1)
end
function c98730215.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c98730215.tgfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c98730215.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c98730215.tgfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsType(TYPE_EQUIP) end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98730215.tgop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SendtoDeck(e:GetHandler(),nil,nil,REASON_EFFECT)~=1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c98730215.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
function c98730215.hspcon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    local phase=Duel.GetCurrentPhase()
    return a and a:GetControler()==tp and (a:IsRace(RACE_DRAGON) or a:IsAttribute(ATTRIBUTE_WATER)) or d and d:GetControler()==tp and (d:IsRace(RACE_DRAGON) or d:IsAttribute(ATTRIBUTE_WATER)) and phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()
end
function c98730215.rfilter(c)
    return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WATER)) and c:IsAbleToRemoveAsCost() and c:IsFaceup()
end
function c98730215.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c98730215.rfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c98730215.rfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c98730215.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    if a and not a:IsRelateToBattle() or d and not d:IsRelateToBattle() then return end
    local tc
    if a and a:GetControler()==tp then
        tc=a
    elseif d and d:GetControler()==tp then
        tc=d
    end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    e:SetLabelObject(tc)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c98730215.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=e:GetLabelObject()
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.Equip(tp,c,tc,true)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetLabelObject(tc)
    e1:SetValue(c98730215.eqlimit)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_DAMAGE_STEP_END)
    e2:SetRange(LOCATION_SZONE)
    e2:SetLabelObject(tc)
    e2:SetCondition(c98730215.sscon)
    e2:SetOperation(c98730215.ssop)
    c:RegisterEffect(e2)
end
function c98730215.sscon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    local tc
    if a and a:GetControler()==tp then
        tc=a
    elseif d and d:GetControler()==tp then
        tc=d
    end
    return tc==e:GetLabelObject() and e:GetHandler():IsType(TYPE_EQUIP)
end
function c98730215.ssop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end