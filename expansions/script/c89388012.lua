--机怪巨兵操者 「AVANCE」
local m=89388012
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
    local e3=e1:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,m+100000000)
    e2:SetTarget(cm.drtg)
    e2:SetOperation(cm.drop)
    c:RegisterEffect(e2)
end
function cm.filter(c,e,tp)
    return c:IsSetCard(0xcc21) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.drfilter(c)
    return c:IsSetCard(0xcc21) and c:IsFaceup()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=0
    local g=Duel.GetMatchingGroup(cm.drfilter,tp,LOCATION_MZONE,0,nil)
    for i,type in ipairs({TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK}) do
        if g:IsExists(Card.IsType,1,nil,type) then ct=ct+1 end
    end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ct)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local ct=0
    local g=Duel.GetMatchingGroup(cm.drfilter,tp,LOCATION_MZONE,0,nil)
    for i,type in ipairs({TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK}) do
        if g:IsExists(Card.IsType,1,nil,type) then ct=ct+1 end
    end
    Duel.Draw(p,ct,REASON_EFFECT)
end
