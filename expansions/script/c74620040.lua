local s,id,o=GetID()
function s.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e0:SetCondition(s.handcon)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_REMOVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id+1)
    e2:SetCondition(s.thcon)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
end
function s.handcon(e)
    return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_NORMAL+TYPE_SPELL,0,0,4,RACE_CYBERSE,ATTRIBUTE_DARK) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.tmfilter(c)
    return c:IsFaceup() and c:GetType()&(TYPE_TRAP+TYPE_CONTINUOUS)==(TYPE_TRAP+TYPE_CONTINUOUS)
        and c:GetOriginalType()&TYPE_MONSTER~=0
end
function s.lkfilter(c,mc)
    return c:IsLinkSummonable(nil,mc)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_NORMAL+TYPE_SPELL,0,0,4,RACE_CYBERSE,ATTRIBUTE_DARK) then return end
    c:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL)
    if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)~=0 then
        if Duel.IsExistingMatchingCard(s.tmfilter,tp,LOCATION_ONFIELD,0,1,nil) then
            local g=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_EXTRA,0,nil,c)
            if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local sg=g:Select(tp,1,1,nil)
                Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
            end
        end
    end
end
function s.thfilter(c)
    return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.thfilter,1,nil)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
        Duel.ConfirmCards(1-tp,c)
        Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
    end
end