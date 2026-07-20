--命定之刻天之将临
local s,id,o=GetID()
function s.initial_effect(c)
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetCondition(s.handcon)
    c:RegisterEffect(e2)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(s.cost1)
    e1:SetTarget(s.tg1)
    e1:SetOperation(s.op1)
    c:RegisterEffect(e1)
    Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
s.has_text_type=TYPE_DUAL
function s.handcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(s.nondualfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.nondualfilter(c)
    return not c:IsType(TYPE_DUAL) or c:IsFacedown()
end
function s.counterfilter(c)
    return c:IsType(TYPE_DUAL)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(s.splimit)
    Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,tp,sumtp,sumpos)
    return not c:IsType(TYPE_DUAL)
end
function s.retfilter(c)
    return c:IsAbleToDeck() or c:IsAbleToExtra()
end
function s.spfilter(c,e,tp)
    return c:IsType(TYPE_DUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local bA=Duel.IsExistingMatchingCard(s.retfilter,tp,LOCATION_ONFIELD,0,1,nil)
    local bB=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
    if chk==0 then return bA or bB end
end

function s.op1(e,tp,eg,ep,ev,re,r,rp)
    local gA=Duel.GetMatchingGroup(s.retfilter,tp,LOCATION_ONFIELD,0,nil)
    if #gA>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg=gA:Select(tp,0,#gA,nil)
        if #sg>0 then
            Duel.HintSelection(sg)
            Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
        end
    end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local gB=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
    if #gB>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=gB:Select(tp,0,1,nil)
        local tc=sg:GetFirst()
        if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
            and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
            local g=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,true,nil)
            local sc=g:GetFirst()
            if sc then
                Duel.Summon(tp,sc,true,nil)
            end
        end
    end
end