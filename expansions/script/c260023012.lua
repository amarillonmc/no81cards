--最高検事総長のジャッジメント
function c260023012.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,2,c260023012.lcheck)
    c:EnableReviveLimit()
    
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,260023012)
    e1:SetCondition(c260023012.thcon)
    e1:SetTarget(c260023012.thtg)
    e1:SetOperation(c260023012.thop)
    c:RegisterEffect(e1)
    
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(260023012,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,260024012)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c260023012.sptg)
    e2:SetOperation(c260023012.spop)
    c:RegisterEffect(e2)
    
    --effect gain
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
    e3:SetCondition(c260023012.effcon)
    e3:SetOperation(c260023012.effop)
    c:RegisterEffect(e3)
end
    

--【召喚条件】
function c260023012.lcheck(g)
    return g:IsExists(Card.IsLinkSetCard,1,nil,0x2045)
end


--【サーチ】
function c260023012.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsSummonType(SUMMON_TYPE_LINK)
end
function c260023012.thfilter(c)
    return c:IsSetCard(0x942) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c260023012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c260023012.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c260023012.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c260023012.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end


--【特殊召喚】
function c260023012.spfilter(c,e,tp)
    return c:IsCode(260023001) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c260023012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c260023012.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c260023012.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c260023012.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

--【攻撃アップ】
function c260023012.effcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_LINK and e:GetHandler():GetReasonCard():IsRace(RACE_FIEND)
end
function c260023012.effop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    local e1=Effect.CreateEffect(rc)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(1000)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1,true)
end