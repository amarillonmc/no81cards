--永火连接者恶魔
local m=89387014
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_DARK),2,2,cm.lcheck)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(cm.spcon)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_DRAW)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(cm.spcon)
    e2:SetTargetRange(1,0)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_DRAW_COUNT)
    e3:SetValue(0)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_SEND_REPLACE)
    e4:SetCondition(cm.spcon)
    e4:SetTarget(cm.reptg)
    e4:SetValue(cm.repval)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetTarget(cm.reptg2)
    c:RegisterEffect(e5)
end
function cm.lcheck(g)
    return g:IsExists(Card.IsLinkRace,1,nil,RACE_FIEND)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function cm.spfilter(c,e,tp,zone)
    return c:IsSetCard(0xb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp,zone) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if not cm.spcon(e,tp,eg,ep,ev,re,r,rp) then return end
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and zone~=0 then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
    end
end
function cm.repfilter(c,e,tp)
    return c:GetOwner()==tp and c:GetDestination()==LOCATION_HAND and c:IsSetCard(0xb) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>0 and eg:IsExists(cm.repfilter,nil,1,e,tp) end
    if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        local g=eg:Filter(cm.repfilter,nil,e,tp)
        local ct=g:GetCount()
        if ct>Duel.GetMZoneCount(tp) then ct=Duel.GetMZoneCount(tp) end
        if Duel.IsPlayerAffectedByEffect(tp,59822133) and ct>1 then ct=1 end
        if ct>1 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            g=g:Select(tp,1,ct,nil)
        end
        for tc in aux.Next(g) do
            tc:RegisterFlagEffect(m,RESET_EVENT+RESET_CHAIN,0,1)
        end
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        return true
    else return false end
end
function cm.repval(e,c)
    return c:GetFlagEffect(m)>0
end
function cm.repfilter2(c,tp)
    return c:GetOwner()==tp and c:GetDestination()==LOCATION_HAND and c:IsSetCard(0xb) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(cm.repfilter2,nil,1,tp) end
    if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        local g=eg:Filter(cm.repfilter2,nil,tp)
        local ct=g:GetCount()
        if ct>Duel.GetLocationCount(tp,LOCATION_SZONE) then ct=Duel.GetLocationCount(tp,LOCATION_SZONE) end
        if ct>1 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
            g=g:Select(tp,1,ct,nil)
        end
        for tc in aux.Next(g) do
            tc:RegisterFlagEffect(m,RESET_EVENT+RESET_CHAIN,0,1)
        end
        Duel.SSet(tp,g)
        return true
    else return false end
end
