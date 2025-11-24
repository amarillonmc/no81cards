--幻叙·灾厄之龙巫女 LV11
function c10200107.initial_effect(c)
    c:EnableReviveLimit()
    -- 不能通常召唤
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.FALSE)
    c:RegisterEffect(e0)
    -- 等级上升
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10200107,0))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_RELEASE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,10200107)
    e1:SetCondition(c10200107.lvcon1a)
    e1:SetOperation(c10200107.lvop1)
    c:RegisterEffect(e1)
    local e1b=e1:Clone()
    e1b:SetCode(EVENT_BE_MATERIAL)
    e1b:SetCondition(c10200107.lvcon1b)
    c:RegisterEffect(e1b)
    -- 10星效果
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10200107,1))
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c10200107.lv10con)
    e2:SetTarget(c10200107.lv10tg)
    e2:SetOperation(c10200107.lv10op)
    c:RegisterEffect(e2)
    -- 11星效果：攻击力翻倍
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_PROPERTY_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_SET_ATTACK_FINAL)
    e3:SetCondition(c10200107.lv11con)
    e3:SetValue(c10200107.atkval)
    c:RegisterEffect(e3)
    -- 11星效果：3次攻击
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_PROPERTY_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_EXTRA_ATTACK)
    e4:SetCondition(c10200107.lv11con)
    e4:SetValue(2)
    c:RegisterEffect(e4)
    -- 升级
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(10200107,2))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c10200107.spcon)
    e5:SetCost(c10200107.spcost)
    e5:SetTarget(c10200107.sptg)
    e5:SetOperation(c10200107.spop)
    c:RegisterEffect(e5)
    local e5b=e5:Clone()
    e5b:SetType(EFFECT_TYPE_QUICK_O)
    e5b:SetCode(EVENT_FREE_CHAIN)
    e5b:SetHintTiming(TIMING_BATTLE_PHASE)
    e5b:SetCondition(c10200107.spcon2)
    c:RegisterEffect(e5b)
end
c10200107.lvup={10200108}
c10200107.lvdn={10200106}
-- 1
function c10200107.lvfilter1(c)
    return c:IsPreviousLocation(LOCATION_MZONE)
end
function c10200107.lvcon1a(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c10200107.lvfilter1,1,nil)
end
function c10200107.lvcon1b(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c10200107.lvfilter1,1,nil) 
        and (r&(REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK))~=0
end
function c10200107.lvop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local ct=eg:FilterCount(c10200107.lvfilter1,nil)
        if ct>0 then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_LEVEL)
            e1:SetValue(ct)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            c:RegisterEffect(e1)
        end
    end
end
-- 2
function c10200107.lv10con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetLevel()>=10
end
function c10200107.lv10tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200107.lv10op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
    if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetTargetRange(1,0)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end
-- 3
function c10200107.lv11con(e)
    return e:GetHandler():GetLevel()>=11
end
function c10200107.atkval(e,c)
    return c:GetBaseAttack()*2
end
-- 4
function c10200107.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetLevel()==11 and Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c10200107.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetLevel()==11 and Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c10200107.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c10200107.spfilter(c,e,tp)
    return c:IsCode(10200108) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c10200107.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
        and Duel.IsExistingMatchingCard(c10200107.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200107.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10200107.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    end
end
