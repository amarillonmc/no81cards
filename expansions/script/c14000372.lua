--穹顶煌刃的扑袭
local m=14000372
local cm=_G["c"..m]
cm.named_with_Skayarder=1
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.actcost)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(cm.scost)
	e2:SetTarget(cm.stg)
	e2:SetOperation(cm.sop)
	c:RegisterEffect(e2)
	--copy effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0x3c0)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e4)
end
function cm.Skay(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Skayarder
end
function cm.handfilter(c)
	return cm.Skay(c) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function cm.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (not e:GetHandler():IsLocation(LOCATION_HAND) or Duel.IsExistingMatchingCard(cm.handfilter,tp,LOCATION_HAND,0,1,e:GetHandler())) end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,cm.handfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
		local tc=g:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
	end
end
function cm.cfilter(c,ft,tp)
	return cm.Skay(c) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function cm.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc1=LOCATION_MZONE
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then loc1=0 end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,loc1,1,nil) end
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g1=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,loc1,1,1,nil)
	g:Merge(g1)
	Duel.Release(g,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return cm.Skay(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,1,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		local code=tc:GetCode()
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,0))
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.cefilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (cm.Skay(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()) then return false end
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local te,te1=m.discard_effect,m.release_effect
	local tg=nil
	if te then
		tg=te:GetTarget()
	elseif te1 then
		tg=te1:GetTarget()
	end
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.cefilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cefilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(g,REASON_COST)
	local tc=g:GetFirst()
	Duel.ClearTargetCard()
	e:SetLabelObject(tc)
	local m=_G["c"..tc:GetCode()]
	local te,te1=m.discard_effect,m.release_effect
	local tg=nil
	if te then
		tg=te:GetTarget()
	end
	if te1 then
		tg=te1:GetTarget()
	end
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),e:GetLabelObject()
	if c:IsRelateToEffect(e) then
		local m=_G["c"..tc:GetCode()]
		local te,te1=m.discard_effect,m.release_effect
		local op=nil
		if te then
			op=te:GetOperation()
		end
		if te1 then
			op=te1:GetOperation()
		end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end