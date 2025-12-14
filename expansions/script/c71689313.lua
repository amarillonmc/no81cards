--"总感觉...有道的发毛的视线..."
local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.setcost)
    e1:SetTarget(s.optg)
    e1:SetOperation(s.opop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1,id+id)
    e2:SetHintTiming(0,TIMING_END_PHASE)
    e2:SetCondition(s.setcon)
    e2:SetCost(s.setcost)
    e2:SetTarget(s.settg)
    e2:SetOperation(s.setop)
    c:RegisterEffect(e2)
    Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.opfilter(c,e,tp,spchk,eqchk)
    return c:IsLevel(8) and c:IsRace(RACE_ILLUSION)
        and (spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false) or eqchk and c:CheckUniqueOnField(tp) and not c:IsForbidden())
end
function s.cfilter(c)
    return c:IsFaceup()
end
function s.optg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        local eqchk=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
            and Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil)
        return Duel.IsExistingMatchingCard(s.opfilter,tp,LOCATION_DECK,0,1,nil,e,tp,spchk,eqchk)
    end
end
function s.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,1-tp,false,false)
end
function s.opop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
    local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    local eqchk=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil)
    local g=Duel.SelectMatchingCard(tp,s.opfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,spchk,eqchk)
    local tc=g:GetFirst()
    if tc then
        if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and spchk
            and (not eqchk or Duel.SelectOption(tp,1152,aux.Stringid(id,2))==0) then
            if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
            and tc:IsLocation(LOCATION_MZONE)
        and Duel.GetMZoneCount(1-tp,nil,1-tp)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,0,LOCATION_HAND,1,nil,e,tp)
        and Duel.SelectYesNo(1-tp,aux.Stringid(id,3)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
        local sc=Duel.SelectMatchingCard(1-tp,s.spfilter,tp,0,LOCATION_HAND,1,1,nil,e,tp):GetFirst()
        Duel.SpecialSummon(sc,0,1-tp,1-tp,false,false,POS_FACEUP)
        end
        else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
            local sg=Duel.SelectMatchingCard(tp,s.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
            local sc=sg:GetFirst()
            if sc then
                if not Duel.Equip(tp,tc,sc) then return end
                --equip limit
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_EQUIP_LIMIT)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e1:SetLabelObject(sc)
                e1:SetValue(s.eqlimit)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e1)
            end
        end
    end
end
function s.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function s.counterfilter(c)
    return c:IsRace(RACE_ILLUSION)
end
function s.rccfilter(c,tp)
    return c:IsFaceupEx() and c:GetOwner()==1-tp
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(s.splimit)
    e1:SetLabelObject(e)
    Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsRace(RACE_ILLUSION)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.rccfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSSetable() end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) and Duel.SSet(tp,c)~=0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
        e1:SetValue(LOCATION_REMOVED)
        c:RegisterEffect(e1)
    end
end
