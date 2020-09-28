--晶元极壁龙
local m=89387000
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),2,99,cm.lcheck)
    c:EnableReviveLimit()
    c:SetUniqueOnField(1,0,m)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,1))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(cm.thtg)
    e1:SetOperation(cm.thop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_BATTLE_DESTROYED)
    e2:SetCondition(cm.regcon)
    e2:SetOperation(cm.regop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(cm.regcon2)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_CUSTOM+m)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(cm.sptg)
    e4:SetOperation(cm.spop)
    c:RegisterEffect(e4)
end
function cm.lfilter(c)
    return c:GetLink()==4 and c:IsRace(RACE_CYBERSE)
end
function cm.lcheck(g)
    return g:IsExists(cm.lfilter,1,nil)
end
function cm.tfilter(c,lg,flag)
    return lg:IsContains(c) and c:IsRace(RACE_CYBERSE) and c:IsType((TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK)&~flag)
end
function cm.thfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and cm.thfilter(chkc) end
    if chk==0 then return eg:IsExists(cm.tfilter,1,nil,e:GetHandler():GetLinkedGroup(),Duel.GetFlagEffectLabel(tp,m)) and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
    local flag=Duel.GetFlagEffectLabel(tp,m)
    if not flag then flag=0 end
    local sg=eg:Filter(cm.tfilter,nil,e:GetHandler():GetLinkedGroup(),flag)
    local sum=flag
    for sc in aux.Next(sg) do sum=sum|sc:GetType() end
    e:SetLabel(sum)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
    Duel.ResetFlagEffect(tp,m)
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1,e:GetLabel())
end
function cm.spfilter(c,e,tp,tc)
    return c:IsRace(tc:GetRace()) and c:IsAttribute(tc:GetAttribute()) and c:GetAttack()==tc:GetAttack() and not c:IsCode(tc:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.cfilter(c,e,tp,zone)
    local seq=c:GetPreviousSequence()
    if c:GetPreviousControler()~=tp then seq=seq+16 end
    return c:IsPreviousLocation(LOCATION_MZONE) and bit.extract(zone,seq)~=0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:GetCount()==1 and eg:IsExists(cm.cfilter,1,nil,e,tp,e:GetHandler():GetLinkedZone())
end
function cm.cfilter2(c,e,tp,zone)
    return c:IsReason(REASON_EFFECT) and cm.cfilter(c,tp,zone) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function cm.regcon2(e,tp,eg,ep,ev,re,r,rp)
    return eg:GetCount()==1 and eg:IsExists(cm.cfilter2,1,nil,e,tp,e:GetHandler():GetLinkedZone())
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RaiseEvent(eg,EVENT_CUSTOM+m,e,0,tp,0,0)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    e:SetLabelObject(eg:GetFirst())
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabelObject())
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end
end
