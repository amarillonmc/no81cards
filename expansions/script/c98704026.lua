--真帝机的复活
if not pcall(function() require("expansions/script/c98704001") end) then require("script/c98704001") end
local m=98704026
local cm=_G["c"..m]
cm.mqt=true
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_END_PHASE)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
    --cannot be target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(cm.indtg)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(TIMING_END_PHASE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCost(cm.spcost)
    e3:SetTarget(cm.sptg)
    e3:SetOperation(cm.spop)
    c:RegisterEffect(e3)
    --summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,1))
    e4:SetCategory(CATEGORY_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetHintTiming(0,TIMING_END_PHASE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCondition(cm.sumcon)
    e4:SetCost(cm.sumcost)
    e4:SetTarget(cm.sumtg)
    e4:SetOperation(cm.sumop)
    c:RegisterEffect(e4)
    --release
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,2))
    e5:SetCategory(CATEGORY_TOGRAVE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e5:SetCode(EVENT_LEAVE_FIELD)
    e5:SetCountLimit(1,m)
    e5:SetCondition(cm.lfcon)
    e5:SetTarget(cm.tgtg)
    e5:SetOperation(cm.tgop)
    c:RegisterEffect(e5)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local op=0
    local off=1
    local ops={}
    local opval={}
    e:SetLabel(0)
    if cm.spcost(e,tp,eg,ep,ev,re,r,rp,0) and cm.sptg(e,tp,eg,ep,ev,re,r,rp,0) then
        ops[off]=aux.Stringid(m,0)
        opval[off]=1
        off=off+1
    end
    if cm.sumcon(e,tp,eg,ep,ev,re,r,rp) and cm.sumcost(e,tp,eg,ep,ev,re,r,rp,0) and cm.sumtg(e,tp,eg,ep,ev,re,r,rp,0) then
        ops[off]=aux.Stringid(m,1)
        opval[off]=2
        off=off+1
    end
    if off~=1 then
        local op=Duel.SelectOption(tp,aux.Stringid(m,3),table.unpack(ops))
        if opval[op]==1 then
            e:SetCategory(CATEGORY_SPECIAL_SUMMON)
            e:SetLabel(1)
            Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
            cm.sptg(e,tp,eg,ep,ev,re,r,rp,1)
        elseif opval[op]==2 then
            e:SetCategory(CATEGORY_SUMMON)
            e:SetLabel(2)
            Duel.RegisterFlagEffect(tp,m+100,RESET_PHASE+PHASE_END,0,1)
            cm.sumtg(e,tp,eg,ep,ev,re,r,rp,1)
        end
    end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local op=e:GetLabel()
    if op==0 then return end
    if op==1 then
        cm.spop(e,tp,eg,ep,ev,re,r,rp)
    elseif op==2 then
        cm.sumop(e,tp,eg,ep,ev,re,r,rp)
    end
end
function cm.indtg(e,c)
    return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.cfilter(c)
    return mqt.ismqt(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function cm.spfilter(c,e,tp)
    return mqt.ismqt(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    local ct=Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_ONFIELD,0,nil)
    if ct>ft then ct=ft end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
    if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetTargetRange(1,0)
        Duel.RegisterEffect(e1,tp)
    end
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function cm.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,m+100)==0 end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.RegisterFlagEffect(tp,m+100,RESET_PHASE+PHASE_END,0,1)
end
function cm.sumfilter(c)
    return c:IsSummonable(true,nil,1) and mqt.ismqt(c)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil,1)
    end
end
function cm.lfcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_ONFIELD) and not (c:IsPreviousPosition(POS_FACEDOWN) and c:IsLocation(LOCATION_DECK))
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsReleasableByEffect() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsReleasableByEffect,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectTarget(tp,Card.IsReleasableByEffect,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Release(tc,REASON_EFFECT)
    end
end
