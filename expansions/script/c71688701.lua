--抒情歌鸲-铜蓝石鶲
local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.spcon)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
    e2:SetCondition(s.efcon)
    e2:SetOperation(s.efop)
    c:RegisterEffect(e2)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.costfilter(c,ec,e,tp)
    if not (c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf7))or c:IsPublic() then return false end
    local g=Group.FromCards(c,ec)
    return g:IsExists(s.tgspfilter,2,nil,g,e,tp)
end
function s.tgspfilter(c,g,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsPublic() and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,c,c,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local sc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,c,c,e,tp):GetFirst()
    Duel.ConfirmCards(1-tp,sc)
    Duel.ShuffleHand(tp)
    sc:CreateEffectRelation(e)
    e:SetLabelObject(sc)
end
function s.filter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.xyzfilter(c,mg)
    return c:IsSetCard(0xf7) and c:IsXyzSummonable(mg,2,2)
end
function s.gcheck(g,exg)
    return exg:IsExists(Card.IsXyzSummonable,1,nil,g)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil,e,tp)
    local exg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
    if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
        and not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and exg:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,2,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local sc=e:GetLabelObject()
    local g=Group.FromCards(c,sc)
    local fg=g:Filter(Card.IsRelateToEffect,nil,e)
    if not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 then
        if fg:GetCount()==2 then
            local tc=fg:GetFirst()
            while tc do
                Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_DISABLE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e1)
                local e2=e1:Clone()
                e2:SetCode(EFFECT_DISABLE_EFFECT)
                e2:SetValue(RESET_TURN_SET)
                tc:RegisterEffect(e2)
                tc=fg:GetNext()
            end
            Duel.SpecialSummonComplete()
            Duel.AdjustAll()
            if fg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)==2 then
                local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
                if xyzg:GetCount()>0 then
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                    local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
                    Duel.XyzSummon(tp,xyz,g)
                end
            end
        end
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetTarget(s.splimit)
        e1:SetReset(RESET_PHASE+PHASE_END+2)
        Duel.RegisterEffect(e1,tp)
    end
end
function s.splimit(e,c)
    return not c:IsRace(RACE_WINDBEAST) and c:IsLocation(LOCATION_EXTRA)
end
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_XYZ and e:GetHandler():GetReasonCard():IsAttribute(ATTRIBUTE_WIND)
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    local e1=Effect.CreateEffect(rc)
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(s.atkval)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1,true)
    if not rc:IsType(TYPE_EFFECT) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ADD_TYPE)
        e2:SetValue(TYPE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        rc:RegisterEffect(e2,true)
    end
end
function s.atkval(e,c)
    return e:GetHandler():GetOverlayCount()*100
end