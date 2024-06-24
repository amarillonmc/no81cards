--Return To Hell
function c260023025.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,260023025+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c260023025.target)
    e1:SetOperation(c260023025.activate)
    c:RegisterEffect(e1)
end
    

--【特殊召喚】
function c260023025.tgfilter(c,e,tp)
    return c:IsSetCard(0x2045) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c260023025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp)
        and c260023025.tgfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and Duel.IsExistingTarget(c260023025.tgfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c260023025.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c260023025.linkfilter(c)
    return c:IsLinkSummonable(nil) and c:IsRace(RACE_FIEND)
end
function c260023025.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) or Duel.GetMZoneCount(tp)<1
        or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
    local g=Duel.GetMatchingGroup(c260023025.linkfilter,tp,LOCATION_EXTRA,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(260023025,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc=g:Select(tp,1,1,nil):GetFirst()
        Duel.LinkSummon(tp,tc,nil)
    end
end

