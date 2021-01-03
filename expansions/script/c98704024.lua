--真帝机的继承
if not pcall(function() require("expansions/script/c98704001") end) then require("script/c98704001") end
local m=98704024
local cm=_G["c"..m]
cm.mqt=true
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --cannot disable summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSummonType,SUMMON_TYPE_NORMAL))
    c:RegisterEffect(e2)
    --draw
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,0))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.drcon)
    e3:SetTarget(cm.drtg)
    e3:SetOperation(cm.drop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCondition(cm.drcon2)
    c:RegisterEffect(e4)
    --tribute summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,1))
    e4:SetCategory(CATEGORY_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCountLimit(1,m+100)
    e4:SetTarget(cm.sumtg)
    e4:SetOperation(cm.sumop)
    c:RegisterEffect(e4)
    --send to grave
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,2))
    e5:SetCategory(CATEGORY_TOGRAVE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e5:SetCode(EVENT_LEAVE_FIELD)
    e5:SetCountLimit(1,m+200)
    e5:SetCondition(cm.lfcon)
    e5:SetTarget(cm.tgtg)
    e5:SetOperation(cm.tgop)
    c:RegisterEffect(e5)
    if not cm.global_check then
        cm.global_check=true
        cm[0]=0
        cm[1]=0
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SUMMON_SUCCESS)
        ge1:SetOperation(cm.checkop)
        Duel.RegisterEffect(ge1,0)
        local ge2=ge1:Clone()
        ge2:SetCode(EVENT_MSET)
        Duel.RegisterEffect(ge2,0)
        local ge3=Effect.CreateEffect(c)
        ge3:SetType(EFFECT_TYPE_FIELD)
        ge3:SetCode(EFFECT_MATERIAL_CHECK)
        ge3:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
        ge3:SetValue(cm.valcheck)
        Duel.RegisterEffect(ge3,0)
        ge1:SetLabelObject(ge3)
        ge2:SetLabelObject(ge3)
        local ge4=Effect.CreateEffect(c)
        ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
        ge4:SetOperation(cm.clearop)
        Duel.RegisterEffect(ge4,0)
    end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    if tc:IsSummonType(SUMMON_TYPE_ADVANCE) then
        local p=tc:GetSummonPlayer()
        cm[p]=cm[p]+e:GetLabelObject():GetLabel()
    end
end
function cm.valcheck(e,c)
    local ct=c:GetMaterial():FilterCount(mqt.ismqt,nil)
    e:SetLabel(ct)
end
function cm.clearop(e,tp,eg,ep,ev,re,r,rp)
    cm[0]=0
    cm[1]=0
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
    return cm[tp]>0
end
function cm.drcon2(e,tp,eg,ep,ev,re,r,rp)
    return cm[tp]>0 and Duel.GetTurnPlayer()==1-tp
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,cm[tp]) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,cm[tp])
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Draw(tp,cm[tp],REASON_EFFECT)
end
function cm.sumfilter(c)
    return c:IsSummonable(true,nil,1) and mqt.ismqt(c)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil,1)
    end
end
function cm.lfcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_ONFIELD) and not (c:IsPreviousPosition(POS_FACEDOWN) and c:IsLocation(LOCATION_DECK))
end
function cm.tgfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsType(TYPE_SPELL+TYPE_TRAP) and chkc:IsAbleToGrave() end
    if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoGrave(tc,REASON_EFFECT)
    end
end
