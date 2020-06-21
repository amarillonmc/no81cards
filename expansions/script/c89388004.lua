--彗星魔导士 弗里德里希
local m=89388004
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetRange(LOCATION_PZONE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,m)
    e2:SetCondition(cm.spcon)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetValue(aux.tgoval)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e5:SetValue(aux.indoval)
    c:RegisterEffect(e5)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,m+100000000)
    e3:SetTarget(cm.destg)
    e3:SetOperation(cm.desop)
    c:RegisterEffect(e3)
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_DESTROYED)
    e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e6:SetCountLimit(1,m+200000000)
    e6:SetCondition(cm.pencon)
    e6:SetTarget(cm.pentg)
    e6:SetOperation(cm.penop)
    c:RegisterEffect(e6)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)
    if c:IsSetCard(0xcc20) then return false end
    return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cm.cfilter(c,tp)
    return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0xcc20) and c:GetPreviousControler()==tp
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function cm.tgfilter(c)
    return c:IsSetCard(0xcc20) and c:IsAbleToGrave()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil),1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local n=Duel.GetMatchingGroupCount(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if n>2 then n=2 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,n,nil)
    if not g or g:GetCount()==0 or Duel.SendtoGrave(g,REASON_EFFECT)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g:GetCount(),nil)
    if not dg or dg:GetCount()==0 then return end
    Duel.Destroy(dg,REASON_EFFECT)
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.filter(c)
    return c:IsCode(89388002) and c:IsAbleToDeck()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) and c:IsAbleToHand() end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,99,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)==0 or Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)==0 then return end
    Duel.SendtoHand(c,nil,REASON_EFFECT)
end
