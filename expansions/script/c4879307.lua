local m=4879307
local cm=_G["c"..m]
function cm.initial_effect(c)
    --fusion procedure
    c:EnableReviveLimit()
    aux.AddFusionProcMix(c,false,true,cm.matfilter3,cm.matfilter1,cm.matfilter2,nil)
	local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e0:SetValue(1)
    c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetValue(aux.fuslimit)
    c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,0))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e3:SetCondition(cm.rmcon)
    e3:SetTarget(cm.rmtg)
    e3:SetOperation(cm.rmop)
    c:RegisterEffect(e3)
	  local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(44146295,1))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
    e2:SetCondition(cm.descon)
     e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
end
function cm.ffilter(c,e,tp)
    return (c:IsRace(RACE_SPELLCASTER) or c:IsRace(RACE_DRAGON)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.IsExistingMatchingCard(cm.ffilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.check(g)
    return g:FilterCount(Card.IsRace,nil,RACE_SPELLCASTER)<2 and g:FilterCount(Card.IsRace,nil,RACE_DRAGON)<2
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133)
        or Duel.GetMatchingGroupCount(cm.ffilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.GetMatchingGroup(cm.ffilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	local g=tg:SelectSubGroup(tp,cm.check,false,1,2)
	if g then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.matfilter3(c)
    return c:IsRace(RACE_SPELLCASTER)
end
function cm.matfilter1(c)
    return c:IsRace(RACE_DRAGON)
end
function cm.matfilter2(c)
    return c:IsFusionAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(m)==0
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,aux.ExceptThisCard(e))
    if #g1==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
    g1:Merge(g2)
    Duel.HintSelection(g1)
    Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
    end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsPreviousLocation(LOCATION_MZONE)
        and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end