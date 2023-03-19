--FDR-タイダル
function c98730215.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --fusion material
    aux.AddFusionProcFunRep(c,c98730215.ffilter,2,false)
    --monster effect
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c98730215.sprcon)
    e2:SetOperation(c98730215.sprop)
    c:RegisterEffect(e2)
    --syncro limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetValue(c98730215.synlimit)
    c:RegisterEffect(e3)
    --to pzone
    local e4=Effect.CreateEffect(c)
    e4:SetCode(EFFECT_SEND_REPLACE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(c98730215.reptg)
    e4:SetOperation(c98730215.repop)
    c:RegisterEffect(e4)
    --spsummon remove
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e5:SetCountLimit(1,98730215)
    e5:SetCondition(c98730215.rescon)
    e5:SetTarget(c98730215.restg)
    e5:SetOperation(c98730215.resop)
    c:RegisterEffect(e5)
    --equip effect
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_EQUIP)
    e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetValue(1300)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_EQUIP)
    e7:SetCode(EFFECT_UPDATE_DEFENSE)
    e7:SetValue(1000)
    c:RegisterEffect(e7)
    --equip hundler
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_QUICK_O)
    e8:SetCategory(CATEGORY_ATKCHANGE)
    e8:SetCode(EVENT_FREE_CHAIN)
    e8:SetHintTiming(TIMING_DAMAGE_STEP)
    e8:SetRange(LOCATION_GRAVE)
    e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e8:SetCountLimit(1,98730215)
    e8:SetCondition(c98730215.ehcon)
    e8:SetCost(c98730215.ehcost)
    e8:SetTarget(c98730215.ehtg)
    e8:SetOperation(c98730215.ehop)
    c:RegisterEffect(e8)
    --to grave
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCategory(CATEGORY_TOGRAVE)
    e9:SetCountLimit(1,98730215)
    e9:SetTarget(c98730215.tgtg)
    e9:SetOperation(c98730215.tgop)
    c:RegisterEffect(e9)
    --pendulum effect
    --equip
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(98730215,0))
    e10:SetType(EFFECT_TYPE_IGNITION)
    e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e10:SetCategory(CATEGORY_EQUIP)
    e10:SetRange(LOCATION_PZONE)
    e10:SetCountLimit(1,98730216)
    e10:SetTarget(c98730215.eqtg)
    e10:SetOperation(c98730215.eqop)
    c:RegisterEffect(e10)
    --pendulum set
    local e11=Effect.CreateEffect(c)
    e11:SetDescription(aux.Stringid(98730215,1))
    e11:SetCategory(CATEGORY_DESTROY)
    e11:SetType(EFFECT_TYPE_IGNITION)
    e11:SetRange(LOCATION_PZONE)
    e11:SetCountLimit(1,98730216)
    e11:SetCondition(c98730215.pencon)
    e11:SetTarget(c98730215.pentg)
    e11:SetOperation(c98730215.penop)
    c:RegisterEffect(e11)
end

--fusion material
function c98730215.ffilter(c)
    return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WATER)) and not c:IsType(TYPE_FUSION)
end

--special summon rule
function c98730215.fcfilter(c,tp,fc)
    return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WATER)) and not c:IsType(TYPE_FUSION) and c:IsCanBeFusionMaterial(fc)
end
function c98730215.fcfilterx(c,tp,fc)
    local mg=Group.FromCards(c,fc)
    return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WATER)) and not c:IsType(TYPE_FUSION) and c:IsCanBeFusionMaterial(fc)
        and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
        and Duel.IsExistingMatchingCard(c98730215.fcfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,mg,tp,c)
end
function c98730215.sprcon(e,c)
    if c==nil then return true end
    if c:IsFaceup() then return false end
    local tp=c:GetControler()
    local mt=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if mt>0 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 then
        return Duel.IsExistingMatchingCard(c98730215.fcfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,2,c,tp,c)
    elseif mt==0 then
        return Duel.IsExistingMatchingCard(c98730215.fcfilterx,tp,LOCATION_MZONE,0,1,c,tp,c)
            and Duel.IsExistingMatchingCard(c98730215.fcfilter,tp,LOCATION_HAND,0,1,c,tp,c)
    else
        return Duel.IsExistingMatchingCard(c98730215.fcfilterx,tp,LOCATION_MZONE,0,2,c,tp,c)
    end
end
function c98730215.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local c=e:GetHandler()
    local mt=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if mt>0 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 then
        local g=Duel.GetMatchingGroup(c98730215.fcfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg=g:Select(tp,2,2,nil)
        Duel.Remove(sg,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL)
    elseif mt==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g=Duel.SelectMatchingCard(tp,c98730215.fcfilter,tp,LOCATION_MZONE,0,1,1,c)
        local tc=g:GetFirst()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g2=Duel.SelectMatchingCard(tp,c98730215.fcfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,tc)
        g2:AddCard(tc)
        Duel.Remove(g2,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL)
    else
        local g=Duel.GetMatchingGroup(c98730215.fcfilter,tp,LOCATION_MZONE,0,c)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg=g:Select(tp,2,2,nil)
        Duel.Remove(sg,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL)
    end
end

--synchro limit
function c98730215.synlimit(e,c)
    if not c then return false end
    return not (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WATER))
end

--to pzone
function c98730215.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tp=c:GetControler()
    local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0)
    local b2=Duel.CheckLocation(tp,LOCATION_PZONE,1)
    if chk==0 then return c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_SYNCHRO) end
    return b1 or b2
end
function c98730215.repop(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end

--remove spsummon
function c98730215.rescon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function c98730215.spfilter(c,e,tp,lv)
    return c:IsFaceup() and (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WATER))
        and c:IsLevelBelow(lv-1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98730215.restg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c98730215.spfilter(chkc,e,tp,c:GetLevel()) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c98730215.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,c:GetLevel()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c98730215.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,c:GetLevel())
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98730215.resop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
        local lv=c:GetLevel()-tc:GetLevel()
        if lv<1 then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(lv)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e1)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end

--epuip hundler
function c98730215.ehcon(e,tp,eg,ep,ev,re,r,rp)
    local phase=Duel.GetCurrentPhase()
    if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return (a and a:GetControler()==tp and (a:IsRace(RACE_DRAGON) or a:IsAttribute(ATTRIBUTE_WATER)) and a:IsRelateToBattle())
        or (d and d:GetControler()==tp and (d:IsRace(RACE_DRAGON) or d:IsAttribute(ATTRIBUTE_WATER)) and d:IsRelateToBattle())
end
function c98730215.rmfilter(c)
    return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WATER)) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function c98730215.ehcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c98730215.rmfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c98730215.rmfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c98730215.ehtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c98730215.ehop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local a=Duel.GetAttacker()
    if Duel.GetTurnPlayer()~=tp then a=Duel.GetAttackTarget() end
    if not a:IsRelateToBattle() then return end
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Equip(tp,c,a)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(c98730215.eqlimit)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetLabelObject(a)
    c:RegisterEffect(e1)
    --self destroy
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EVENT_DAMAGE_STEP_END)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetOperation(c98730215.mtop)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e2)
end
function c98730215.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c98730215.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Destroy(c,REASON_EFFECT)
end

--tograve
function c98730215.tgfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c98730215.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToExtra() and Duel.IsExistingMatchingCard(c98730215.tgfilter,tp,LOCATION_DECK,0,1,nil) and c:GetEquipTarget() end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c98730215.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c98730215.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoGrave(g,REASON_EFFECT)
        end
    end
end

--equip
function c98730215.filter(c)
    return c:IsFaceup() and (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WATER))
end
function c98730215.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98730215.filter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c98730215.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c98730215.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c98730215.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.SendtoGrave(c,REASON_RULE)
    Duel.Equip(tp,c,tc,true)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetValue(c98730215.eqlimit)
    e1:SetLabelObject(tc)
    c:RegisterEffect(e1)
end

--pendulim set
function c98730215.setfilter(c)
    return not c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c98730215.pencon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c98730215.setfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c98730215.penfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c98730215.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c98730215.penfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c98730215.penop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local pc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,c)
    if Duel.Destroy(pc,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,c98730215.penfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
        end
    end
end
