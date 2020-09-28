--魔玩具·武力奇美拉
local m=89387011
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,nil,2,2,cm.spcheck)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(cm.target3)
    e3:SetOperation(cm.operation3)
    c:RegisterEffect(e3)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(cm.thcon)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(cm.chainop)
    c:RegisterEffect(e1)
end
function cm.spcheck(g)
    local f1=g:IsExists(Card.IsLinkSetCard,1,nil,0xad) and 1 or 0
    local f2=g:IsExists(Card.IsLinkSetCard,1,nil,0xa9) and 1 or 0
    local f3=g:IsExists(Card.IsLinkSetCard,1,nil,0xc3) and 1 or 0
    return f1+f2+f3==2
end
function cm.filter(c)
    return c:IsSetCard(0xa9) and c:IsSummonable(true,nil)
end
function cm.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil)
    if not g or g:GetCount()==0 then return end
    Duel.Summon(tp,g:GetFirst(),true,nil)
end
function cm.descfilter(c,lg)
    return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0xad) and c:IsSummonType(SUMMON_TYPE_FUSION) and lg:IsContains(c)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    local lg=e:GetHandler():GetLinkedGroup()
    return eg:IsExists(cm.descfilter,1,nil,lg)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if rc:IsSetCard(0xad,0xa9,0xc3) then
        Duel.SetChainLimit(cm.chainlm)
    end
end
function cm.chainlm(e,rp,tp)
    return tp==rp
end
