local m=4878201
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,m)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	--local e2=Effect.CreateEffect(c)
    --e2:SetType(EFFECT_TYPE_FIELD)
    --e2:SetRange(LOCATION_SZONE)
    --e2:SetTargetRange(0,LOCATION_MZONE)
    --e2:SetTarget(cm.distg)
    --e2:SetCode(EFFECT_DISABLE)
    --c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_END_PHASE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(cm.seqtg)
    e2:SetOperation(cm.seqop)
    c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_CHAIN_SOLVING)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCondition(cm.discon)
    e5:SetOperation(cm.disop)
    c:RegisterEffect(e5)
end
function cm.seqfilter(c)
    local tp=c:GetControler()
    return c:IsFaceup() and c:IsSetCard(0x48f) and c:IsAbleToGrave()
end
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
          if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) end
    if chk==0 then return Duel.IsExistingTarget(cm.seqfilter,tp,LOCATION_SZONE,0,1,nil)
         end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
    Duel.SelectTarget(tp,cm.seqfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
 local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp)
    then return end
    Duel.SendtoGrave(tc,REASON_RULE)
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function cm.matlimit(e,c)
    local face=c:GetColumnGroup()
    return face:IsExists(cm.matfilter,1,nil,e:GetHandlerPlayer())
end
function cm.matfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x48c) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function cm.ggfilter(c,tp)
    return c:IsSetCard(0x48c) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function cm.desfilter(c,tp)
    local g=c:GetColumnGroup()
    return g:IsExists(cm.ggfilter,1,nil,tp)
end
function cm.matlimit(e,c)
    local face=c:GetColumnGroup()
    return face:IsExists(cm.matfilter,1,nil,e:GetHandlerPlayer())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_MZONE,nil,tp)
    return re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and #g>0
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end
