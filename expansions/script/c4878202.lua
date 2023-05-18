local m=4878202
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DISABLE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.distg)
    e1:SetOperation(cm.disop)
    c:RegisterEffect(e1)
	   local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m)
    e2:SetHintTiming(0,TIMING_END_PHASE)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(cm.seqtg)
    e2:SetOperation(cm.seqop)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e3:SetCondition(cm.actcon)
    c:RegisterEffect(e3)
end
function cm.seqfilter(c)
    local tp=c:GetControler()
    return c:GetSequence()<5 and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
end
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.seqfilter(chkc) and chkc~=c end
    if chk==0 then return Duel.IsExistingTarget(cm.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
    Duel.SelectTarget(tp,cm.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local ttp=tc:GetControler()
    if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e)
        or Duel.GetLocationCount(ttp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
    local p1,p2
    if tc:IsControler(tp) then
        p1=LOCATION_MZONE
        p2=0
    else
        p1=0
        p2=LOCATION_MZONE
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local seq=math.log(Duel.SelectDisableField(tp,1,p1,p2,0),2)
    if tc:IsControler(1-tp) then seq=seq-16 end
    Duel.MoveSequence(tc,seq)
end
function cm.ggfilter(c,tp)
    g=c:GetColumnGroup()
    return g:IsExists(cm.cfilter,1,nil,tp)
end
function cm.cfilter(c,tp)
    return not (c:IsSetCard(0x48f) and c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and c:IsControler(tp))
end
function cm.sprfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x48f)
end
function cm.actcon(e)
    return Duel.IsExistingMatchingCard(cm.ggfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(cm.sprfilter,tp,LOCATION_SZONE,0,1,nil)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.NegateEffectMonsterFilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
    local g=Duel.SelectTarget(tp,aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	   local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
		if not c:IsRelateToEffect(e) or not c:IsFaceup() or tc:IsImmuneToEffect(e) then return end
        Duel.AdjustInstantly()
		
		if tc:IsDisabled() and tc:IsControler(1-tp) and  Duel.SelectYesNo(tp,aux.Stringid(m,2))  then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
  if tc1 then
            local s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
    local nseq=math.log(bit.rshift(s,16),2)
     Duel.MoveSequence(tc1,nseq)
    end
	end
	end
end
function cm.ggfilter1(c,tp)
    return c:IsSetCard(0x48f) and c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and c:IsControler(tp)
end
function cm.desfilter(c,tp)
    local g=c:GetColumnGroup()
    return g:IsExists(cm.ggfilter1,1,nil,tp)
end