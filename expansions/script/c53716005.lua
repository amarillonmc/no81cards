local m=53716005
local cm=_G["c"..m]
cm.name="幻想执行者"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(cm.seqtg)
	e1:SetOperation(cm.seqop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(cm.eftg1)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	local e4=e2:Clone()
	e4:SetTarget(cm.eftg2)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(cm.tdtg)
	e5:SetOperation(cm.tdop)
	local e6=e2:Clone()
	e6:SetTarget(cm.eftg3)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	local e8=e2:Clone()
	e8:SetTarget(cm.eftg4)
	e8:SetLabelObject(e7)
	c:RegisterEffect(e8)
end
function cm.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSynchroType(TYPE_NORMAL)
end
function cm.eftg(e,c)
	return c:GetSequence()<5 and c:IsStatus(STATUS_EFFECT_ENABLED) and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function cm.eftg1(e,c)
	return cm.eftg(e,c) and not c:IsType(TYPE_TRAP) and not c:IsLocation(LOCATION_PZONE)
end
function cm.eftg2(e,c)
	return cm.eftg(e,c) and c:IsType(TYPE_TRAP) and not c:IsLocation(LOCATION_PZONE)
end
function cm.eftg3(e,c)
	return cm.eftg(e,c) and not c:IsType(TYPE_TRAP)
end
function cm.eftg4(e,c)
	return cm.eftg(e,c) and c:IsType(TYPE_TRAP)
end
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)<2 and Duel.GetLocationCount(tp,LOCATION_SZONE,PLAYER_NONE,0)>0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_SZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq-8)
end
function cm.tdfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_FUSION) or bit.band(c:GetType(),0x20004)==0x20004) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
	if chk==0 then return Duel.GetFlagEffect(tp,m)<2 and Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*300)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then Duel.Recover(tp,ct*300,REASON_EFFECT) end
end
