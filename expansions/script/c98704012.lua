--真帝机 雾动
if not pcall(function() require("expansions/script/c98704001") end) then require("script/c98704001") end
local m=98704012
local cm=_G["c"..m]
cm.mqt=true
function cm.initial_effect(c)
    mqt.SummonWithExtraTributeEffect(c)
    mqt.ChangeLevelEffect(c)
    mqt.ResistanceEffect(c)
    mqt.SearchEffect(c)
    mqt.ReleaseEffect(c,CATEGORY_SEARCH+CATEGORY_TOHAND,cm.tg,cm.op)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetHintTiming(TIMING_END_PHASE)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
end
function cm.filter(c)
    return mqt.ismqt(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_TRIGGER)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1)
        Duel.SpecialSummonComplete()
        if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
            and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,1-tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,0,1-tp,false,false)
            and Duel.SelectYesNo(1-tp,aux.Stringid(m,2)) then
            Duel.BreakEffect()
            local sc=Duel.SelectMatchingCard(1-tp,Card.IsCanBeSpecialSummoned,1-tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,0,1-tp,false,false):GetFirst()
            Duel.SpecialSummonStep(sc,0,1-tp,1-tp,false,false,POS_FACEUP)
            local e2=e1:Clone()
            sc:RegisterEffect(e2)
            Duel.SpecialSummonComplete()
        end
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSummonableCard()
end
