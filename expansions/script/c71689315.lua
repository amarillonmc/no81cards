--"总感觉...是个不妙的地方..."
local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,id+id)
    e2:SetCondition(s.setcon)
    e2:SetTarget(s.settg)
    e2:SetOperation(s.setop)
    c:RegisterEffect(e2)
end
function s.tffilter(c,tp)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x593)
        and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.tffilter,tp,LOCATION_DECK,0,nil,tp)
    if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local sg=g:Select(tp,1,1,nil)
        Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        Duel.BreakEffect()
        Duel.DiscardHand(tp,nil,1,1,REASON_DISCARD+REASON_EFFECT,nil)
    end
end
function s.rccfilter(c,tp)
    return c:IsFaceupEx() and c:GetOwner()==1-tp
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsRace(RACE_ILLUSION)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.rccfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.filter(c)
    return c:IsSetCard(0x593) and c:IsFaceupEx() and c:IsAbleToDeck()
end
function s.cfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,1-tp,false,false)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 then
        if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0 then
            Duel.BreakEffect()
            local g0=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
            Duel.ConfirmCards(tp,g0)
            if Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_HAND,1,nil,e,tp) and Duel.GetMZoneCount(tp,nil,1-tp)>0 then
                local tg=Duel.GetMatchingGroup(s.cfilter,tp,0,LOCATION_HAND,nil,e,tp)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local sc=tg:Select(tp,1,1,nil):GetFirst()
                Duel.SpecialSummon(sc,0,1-tp,tp,false,false,POS_FACEUP)
            end
        end
    end
end

