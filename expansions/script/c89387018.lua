--暗黑界的龙神 德莱波尔
local m=89387018
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddLinkProcedure(c,cm.matfilter,2,3)
    c:EnableReviveLimit()
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,0))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.condition)
    e3:SetTarget(cm.target)
    e3:SetOperation(cm.operation)
    c:RegisterEffect(e3)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(cm.rmtarget)
    e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
    e1:SetValue(LOCATION_REMOVED)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,m+100000000)
    e2:SetCondition(cm.thcon)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
end
function cm.matfilter(c)
    return c:IsLinkAttribute(ATTRIBUTE_DARK) and c:IsLinkRace(RACE_FIEND)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function cm.filter(c)
    return c:IsSetCard(0x6) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local c=e:GetHandler()
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,c)
    local tc=g:GetFirst()
    if tc then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
        Duel.ShuffleHand(tp)
        Duel.BreakEffect()
        Duel.DiscardHand(tp,Card.IsSetCard,1,1,REASON_EFFECT+REASON_DISCARD,nil,0x6)
    end
end
function cm.rmtarget(e,c)
    return not c:IsSetCard(0x6)
end
function cm.cfilter(c,tp)
    return c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==1-tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    local des=eg:GetFirst()
    if des:IsReason(REASON_BATTLE) then
        local rc=des:GetReasonCard()
        return rc and rc:IsSetCard(0x6) and rc:IsControler(tp) and rc:IsRelateToBattle()
    elseif re then
        local rc=re:GetHandler()
        return eg:IsExists(cm.cfilter,1,nil,tp) and rc and rc:IsSetCard(0x6) and rc:IsControler(tp) and re:IsActiveType(TYPE_MONSTER)
    end
    return false
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local mg=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
    local sg=eg:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
    if chk==0 then return sg and sg:GetCount()==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=sg:GetCount() end
    if mg and mg:GetCount()>0 then
        local dmg=mg:GetSum(Card.GetBaseAttack)
        Duel.SetTargetPlayer(1-tp)
        Duel.SetTargetParam(dmg)
        Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dmg)
    end
    if sg and sg:GetCount()>0 then
        Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,sg:GetCount())
    end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local mg=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
    local sg=eg:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
    if mg and mg:GetCount()>0 then
        local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
        Duel.Damage(p,d,REASON_EFFECT)
    end
    if sg and sg:GetCount()>0 then
        Duel.DiscardHand(1-tp,aux.TRUE,sg:GetCount(),sg:GetCount(),REASON_EFFECT+REASON_DISCARD,nil)
    end
end
