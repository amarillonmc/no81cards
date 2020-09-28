--超量機神王グレート・マグナス
local m=18402543
local cm=_G["c"..m]
function cm.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,12,3)
    c:EnableReviveLimit()
    --to deck
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(cm.tdcon)
    e1:SetCost(cm.tdcost)
    e1:SetTarget(cm.tdtg)
    e1:SetOperation(cm.tdop)
    c:RegisterEffect(e1)
    --immune
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(cm.imcon)
    e2:SetValue(cm.efilter)
    c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_TO_HAND)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(0,1)
    e3:SetCondition(cm.drcon)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_DRAW)
    e4:SetCondition(cm.drcon)
    e4:SetTargetRange(0,1)
    c:RegisterEffect(e4)
    --spsummon
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_DELAY)
    e6:SetCode(EVENT_TO_GRAVE)
    e6:SetTarget(cm.sptg)
    e6:SetOperation(cm.spop)
    c:RegisterEffect(e6)
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=2 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.ofilter(c,e)
    return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    if sg:GetCount()>0 then
        Duel.HintSelection(sg)
        if c:IsHasEffect(89387017) and c:IsRelateToEffect(e) and not sg:IsExists(aux.NOT(cm.ofilter),nil,1,e) and Duel.SelectYesNo(tp,aux.Stringid(89387017,0)) then
            for tc in aux.Next(sg) do
                local og=tc:GetOverlayGroup()
                if og:GetCount()>0 then
                    Duel.SendtoGrave(og,REASON_RULE)
                end
            end
            Duel.Overlay(c,sg)
        else
            Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
        end
    end
end
function cm.imcon(e)
    return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=4
end
function cm.efilter(e,te)
    return not te:GetOwner():IsSetCard(0xdc)
end
function cm.drcon(e)
    return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=6
end
function cm.spfilter(c,e,tp)
    return c:IsSetCard(0x20dc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
        return not Duel.IsPlayerAffectedByEffect(tp,59822133)
            and Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and g:GetClassCount(Card.GetCode)>2
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
    if ft>2 and g:GetClassCount(Card.GetCode)>2 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g1=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
        Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
    end
end
