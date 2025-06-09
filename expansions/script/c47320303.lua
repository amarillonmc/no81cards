-- 沉梦的幼王 克萝娜
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddCodeList(c,47320301)
    s.setspell(c)
    s.cntg(c)
    s.backop(c)
end
function s.setspell(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.setcon)
    e1:SetTarget(s.settg)
    e1:SetOperation(s.setop)
    c:RegisterEffect(e1)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsMainPhase()
end
function s.setfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_FIELD+TYPE_QUICKPLAY+TYPE_RITUAL) and aux.IsCodeListed(c,47320301) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SSet(tp,g:GetFirst())
    end
end
function s.cntg(c)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.ctcon)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(s.cttg)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
end
function s.ctcon(e)
    return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,47320301)
end
function s.cttg(e,c)
    return c:IsSetCard(0x3c17) and c:IsType(TYPE_RITUAL)
end
function s.backop(c)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_RELEASE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,id-1000)
    e3:SetTarget(s.btg)
    e3:SetOperation(s.bop)
    c:RegisterEffect(e3)
end
function s.btg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    if chk==0 then return c:IsAbleToDeck() or b1 end
end
function s.bop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    local b2=c:IsAbleToDeck()
    if not (b1 or b2) then return end
    local opt=0
    if b1 and b2 then
        opt=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
    elseif b1 then
        opt=0
    else
        opt=1
    end
    if opt==0 and b1 then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    elseif b2 then
        Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
    end
end
