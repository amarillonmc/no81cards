--翻车鱼领域
local m=98740005
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableCounterPermit(0xcc10)
    c:SetCounterLimit(0xcc10,10)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(cm.splimit)
    c:RegisterEffect(e2)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,0))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_FZONE)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCountLimit(1)
    e5:SetTarget(cm.sptg)
    e5:SetOperation(cm.spop)
    c:RegisterEffect(e5)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCost(cm.cost)
    e3:SetTarget(cm.destg)
    e3:SetOperation(cm.desop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,2))
    e4:SetCategory(CATEGORY_NEGATE)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_CHAINING)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTarget(cm.discon)
    e4:SetCost(cm.cost)
    e4:SetTarget(cm.distg)
    e4:SetOperation(cm.disop)
    c:RegisterEffect(e4)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(m,3))
    e6:SetCategory(CATEGORY_COUNTER)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_FZONE)
    e6:SetCost(cm.ctcost)
    e6:SetTarget(cm.cttg)
    e6:SetOperation(cm.ctop)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e7:SetCode(EVENT_ADJUST)
    e7:SetRange(LOCATION_FZONE)
    e7:SetOperation(cm.winop)
    c:RegisterEffect(e7)
end
function cm.winop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():GetCounter(0xcc10)==10 then Duel.Win(tp,0x0) end
end
function cm.splimit(e,c)
    return not c:IsCode(36119641)
end
function cm.spfilter(c,e,tp)
    return c:IsCode(36119641) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and c:GetFlagEffect(m)==0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
    c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
    local n=math.min(Duel.GetMZoneCount(tp),g:GetCount())
    n=math.min(n,3)
    if n<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=g:Select(tp,1,n,nil)
    if sg:GetCount()>0 then
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,36119641) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,36119641)
    Duel.Release(g,REASON_COST)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(m)==0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(m)==0 end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
end
function cm.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,36119641) and c:IsCanAddCounter(0xcc10,1) end
    local n=10
    while not c:IsCanAddCounter(0xcc10,n) do n=n-1 end
    local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,n,nil,36119641)
    Duel.Release(g,REASON_COST)
    e:SetLabel(g:GetCount())
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(m)==0 end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetLabel(),0,0xcc10)
    c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    c:AddCounter(0xcc10,e:GetLabel())
end
