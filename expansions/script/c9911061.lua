--恋慕屋敷 幻惑爱奴
function c9911061.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--def position
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_POSITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c9911061.deftg)
	e1:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,9911061)
	e2:SetCost(c9911061.spcost)
	e2:SetTarget(c9911061.sptg)
	e2:SetOperation(c9911061.spop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9911061,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,9911062)
	e3:SetCondition(c9911061.ctcon)
	e3:SetCost(c9911061.ctcost)
	e3:SetTarget(c9911061.cttg)
	e3:SetOperation(c9911061.ctop)
	c:RegisterEffect(e3)
	--register to grave
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c9911061.regop)
	c:RegisterEffect(e4)
	--to hand / pendulem
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9911061,2))
	e5:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_LEAVE_GRAVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1,9911063)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(c9911061.pencon)
	e5:SetCost(c9911061.pencost)
	e5:SetTarget(c9911061.pentg)
	e5:SetOperation(c9911061.penop)
	c:RegisterEffect(e5)
end
function c9911061.deftg(e,c)
	return c:IsFaceup() and c:GetCounter(0x1954)>0
end
function c9911061.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1954,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1954,3,REASON_COST)
end
function c9911061.spfilter(c,e,tp)
	return c:IsSetCard(0x9954) and c:IsLevel(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911061.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911061.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9911061.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911061.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.SelectYesNo(tp,aux.Stringid(9911061,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0):Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
function c9911061.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9911061.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9911061.cfilter(c)
	return c:IsSetCard(0x9954) and not c:IsPublic()
end
function c9911061.addfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsCanAddCounter(0x1954,1)
end
function c9911061.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911061.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c9911061.addfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c9911061.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911061.addfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c9911061.cfilter,tp,LOCATION_HAND,0,1,99,nil)
	Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
	local ct=cg:GetCount()
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		tc:AddCounter(0x1954,1)
	end
end
function c9911061.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(9911061,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c9911061.pencon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(9911061)>0
end
function c9911061.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1954,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1954,1,REASON_COST)
end
function c9911061.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()
		or Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c9911061.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=c:IsAbleToHand()
	local b2=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if not c:IsRelateToEffect(e) or not (b1 or b2) then return end
	if b1 and (not b2 or Duel.SelectOption(tp,1190,1160)==0) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	else
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
