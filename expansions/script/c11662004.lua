--炎星祖-猫头宁
local m=11662004
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddLinkProcedure(c,cm.matfilter,1,1)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.setcon)
    e1:SetTarget(cm.settg)
    e1:SetOperation(cm.setop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,2))
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(cm.lvtg)
    e2:SetOperation(cm.lvop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_CHAIN_SOLVING)
    e3:SetCondition(cm.condition1)
    e3:SetOperation(cm.handes)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCode(m)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(1,0)
    c:RegisterEffect(e4)
end
cm[0]=0
function cm.matfilter(c)
    return c:IsLinkSetCard(0x79) and not c:IsLinkType(TYPE_LINK)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.setfilter(c)
    return c:IsSetCard(0x7c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.tgfilter(c)
    return c:IsSetCard(0x79,0x7c) and c:IsAbleToGrave()
end
function cm.spfilter(c,e,tp)
    return c:IsSetCard(0x79) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
    if not g or g:GetCount()==0 or Duel.SSet(tp,g)==0 then return end
    Duel.BreakEffect()
    if Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local tg=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
        Duel.SendtoGrave(tg,REASON_EFFECT)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.filter1(c)
    return c:IsFaceup() and c:IsSetCard(0x79) and c:GetLevel()>0
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter1(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local lv=tc:GetLevel()
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_CHANGE_LEVEL)
        e2:SetTarget(aux.TRUE)
        e2:SetTargetRange(LOCATION_MZONE,0)
        e2:SetValue(lv)
        e2:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e2,tp)
    end
end
function cmcfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x79) and c:IsType(TYPE_SYNCHRO)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cmcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.desfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function cm.handes(e,tp,eg,ep,ev,re,r,rp)
    local id=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
    if ep==tp or id==cm[0] or not re:IsActiveType(TYPE_MONSTER) then return end
    cm[0]=id
    if Duel.IsExistingMatchingCard(cm.desfilter,1-tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(m,3)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(1-tp,cm.desfilter,1-tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil)
        Duel.SendtoGrave(g,REASON_EFFECT)
        Duel.BreakEffect()
    else
        Duel.NegateEffect(ev)
    end
end
