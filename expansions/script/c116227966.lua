--星遗物的起动
local m=116227966
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e3=e1:Clone()
    e3:SetRange(LOCATION_DECK)
    e3:SetTarget(cm.target2)
    e3:SetOperation(cm.activate2)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_ACTIVATE_COST)
    e4:SetRange(LOCATION_DECK)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(1,0)
    e4:SetTarget(cm.actarget)
    e4:SetOperation(cm.costop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_SPSUMMON_PROC_G)
    e5:SetRange(LOCATION_DECK)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e5)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m+1)
    e2:SetCondition(cm.rmcon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(cm.rmtg)
    e2:SetOperation(cm.rmop)
    c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp)
    return c:IsSetCard(0x10c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tffilter(c)
    return c:IsSetCard(0xfe) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
        if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and ft>0 and Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_DECK,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()<=0 then return end
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local tc=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function cm.actarget(e,te,tp)
    return te:GetHandler()==e:GetHandler()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function cm.cfilter(c)
    return c:GetColumnGroupCount()>0
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
        if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
        return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and ft>0 and Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_DECK,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()<=0 then return end
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local tc=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function cm.egfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsPreviousSetCard(0x10c) and c:GetReasonPlayer()==1-tp
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.egfilter,1,nil,tp)
end
function cm.fselect(g,tp)
    return Duel.IsExistingMatchingCard(cm.lkfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function cm.lkfilter(c,g)
    return c:IsSetCard(0x10c) and c:IsLinkSummonable(g,nil,g:GetCount(),g:GetCount())
end
function cm.chkfilter(c,tp)
    return c:IsType(TYPE_LINK) and c:IsSetCard(0x10c) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if ft<=0 then return false end
        if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
        local cg=Duel.GetMatchingGroup(cm.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
        if #cg==0 then return false end
        local _,maxlink=cg:GetMaxGroup(Card.GetLink)
        if maxlink>ft then maxlink=ft end
        local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
        return g:CheckSubGroup(cm.fselect,1,maxlink,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
    local cg=Duel.GetMatchingGroup(cm.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
    local _,maxlink=cg:GetMaxGroup(Card.GetLink)
    if ft>0 and maxlink then
        if maxlink>ft then maxlink=ft end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:SelectSubGroup(tp,cm.fselect,false,1,maxlink,tp)
        if not sg then return end
        local tc=sg:GetFirst()
        while tc do
            Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetValue(RESET_TURN_SET)
            tc:RegisterEffect(e2)
            tc=sg:GetNext()
        end
        Duel.SpecialSummonComplete()
        local og=Duel.GetOperatedGroup()
        Duel.AdjustAll()
        if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<sg:GetCount() then return end
        local tg=Duel.GetMatchingGroup(cm.lkfilter,tp,LOCATION_EXTRA,0,nil,og)
        if og:GetCount()==sg:GetCount() and tg:GetCount()>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local rg=tg:Select(tp,1,1,nil)
            Duel.LinkSummon(tp,rg:GetFirst(),og,nil,#og,#og)
        end
    end
end
