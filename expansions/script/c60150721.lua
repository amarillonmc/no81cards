--纯白型歌姬亚瑟
function c60150721.initial_effect(c)
    --summon with no tribute
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60150721,0))
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(c60150721.ntcon)
    e1:SetOperation(c60150721.ntop)
    c:RegisterEffect(e1)
    --3
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1,60150721)
    e2:SetCost(c60150721.cost)
    e2:SetTarget(c60150721.target)
    e2:SetOperation(c60150721.operation)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --4
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_RELEASE)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,6010721)
    e4:SetCondition(c60150721.spcon)
    e4:SetTarget(c60150721.sptg)
    e4:SetOperation(c60150721.spop)
    c:RegisterEffect(e4)
end
c60150721.is_named_with_Million_Arthur=1
function c60150721.IsMillion_Arthur(c)
    local m=_G["c"..c:GetCode()]
    return m and m.is_named_with_Million_Arthur
end
function c60150721.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c60150721.ntop(e,tp,eg,ep,ev,re,r,rp,c)
    --change base attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetReset(RESET_EVENT+0xff0000)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetValue(1900)
    c:RegisterEffect(e1)
end
function c60150721.cfilter(c)
    return c:IsSetCard(0xb22) and c:IsType(TYPE_MONSTER)
end
function c60150721.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupEx(tp,c60150721.cfilter,1,nil) end
    local g=Duel.SelectReleaseGroupEx(tp,c60150721.cfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c60150721.filter(c)
    return ((c:IsSetCard(0xb22) and c:IsType(TYPE_MONSTER)) or (c:IsRace(RACE_FAIRY) and c:IsType(TYPE_NORMAL))) 
        and c:IsAbleToHand()
end
function c60150721.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60150721.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60150721.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60150721.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c60150721.spcon(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler()~=e:GetHandler()
end
function c60150721.spfilter(c,e,tp)
    return c:IsSetCard(0x5b22) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(60150721)
end
function c60150721.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60150721.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsAbleToDeck() end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60150721.spop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsLocation(LOCATION_DECK) then return end
    if e:GetHandler():IsRelateToEffect(e) then
        if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)~=0 then
            if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=Duel.SelectMatchingCard(tp,c60150721.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
            if g:GetCount()>0 then
                Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
            end
        end
    end
end