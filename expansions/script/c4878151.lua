local m=4878151
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x48c),aux.FilterBoolFunction(Card.IsFusionSetCard,0x48f),true)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.lkcon)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.seqtg)
	e3:SetOperation(cm.seqop)
	c:RegisterEffect(e3)
end
function cm.filter1(c)
	return c:IsAbleToGrave() and not c:IsType(TYPE_FIELD)
end
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		  if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_ONFIELD,0,1,nil)
		 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	Duel.SelectTarget(tp,nil,tp,LOCATION_SZONE,0,1,1,nil)
end
function cm.filter2(c,g)
	return g:IsContains(c)
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
 local tc=Duel.GetFirstTarget()
 local cg=tc:GetColumnGroup()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp)
		then return end
	if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(cm.filter2,tp,0,LOCATION_ONFIELD,1,nil,cg) then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
   local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,0,LOCATION_ONFIELD,1,1,nil,cg)
	 if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	end
end
function cm.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x48f) and te:IsActiveType(TYPE_TRAP)
end
function cm.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return  (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,0,1,c) end
	local sg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local sg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
	local ct=math.min(sg:GetCount(Card.IsFacedown),ft)
	local ct1=math.min(sg:GetCount(Card.IsFaceup),ft)
	  Duel.SendtoGrave(sg,REASON_EFFECT)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_HINTMSG_SET)
	  local tc=sg:SelectSubGroup(tp,aux.TRUE,false,ct,ct)
	   Duel.SSet(tp,tc)
	   if tc:IsSetCard(0x48f) then
	   local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
	  end
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	  local tc1=sg:SelectSubGroup(tp,aux.TRUE,false,ct1,ct1)
	  Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	  
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local sg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
	  Duel.SendtoGrave(sg,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg1=sg:SelectSubGroup(tp,aux.TRUE,false,1,ft)
		if sg1 and sg1:GetCount()>0 then
	  local tc=sg:GetFirst()
	  while tc   do
	  if tc:IsPreviousPosition(POS_FACEDOWN) then
	  Duel.SSet(tp,tc)
	  if tc:IsSetCard(0x48f) then
	   local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
	  end
	  tc=sg:GetNext()
	  else
	  if tc:IsPreviousPosition(POS_FACEUP) and (tc:IsType(TYPE_CONTINUOUS) or tc:IsType(TYPE_FIELD)) then
	  if tc:IsType(TYPE_CONTINUOUS) then
	   Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	  end
	  end
	  tc=sg:GetNext()
	  end
	  end
	  end
end