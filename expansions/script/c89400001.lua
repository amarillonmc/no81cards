--屋代鼠
local m=89400001
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,89400000)
    c:SetSPSummonOnce(m)
    c:EnableReviveLimit()
    c:SetUniqueOnField(1,0,m)
    aux.AddFusionProcFunRep(c,cm.mfilter,1,false)
    aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST)
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(cm.splimit)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(cm.cost)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.descon)
    e3:SetTarget(cm.tgtg)
    e3:SetOperation(cm.tgop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_REMOVE)
    e4:SetCondition(cm.descon2)
    c:RegisterEffect(e4)
end
function cm.mfilter(c)
    return c:IsAttack(0) and c:IsDefense(1800)
end
function cm.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.spfilter(c,ft,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAttack(0) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,ft,e,tp)
    end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,ft,e,tp)
    if g:GetCount()>0 then
        local th=g:GetFirst():IsAbleToHand()
        local sp=ft>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)
        local op=0
        if th and sp then op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
        elseif th then op=0
        else op=1 end
        if op==0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        else
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function cm.filter(c)
    return c:IsLocation(LOCATION_GRAVE) and (c:IsType(TYPE_MONSTER) and c:IsAttack(0) or aux.IsCodeListed(c,89400000) and c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.filter,1,nil)
end
function cm.filter2(c)
    return c:IsLocation(LOCATION_REMOVED) and c:IsFaceup() and (c:IsType(TYPE_MONSTER) and c:IsAttack(0) or aux.IsCodeListed(c,89400000) and c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.filter2,1,nil)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
