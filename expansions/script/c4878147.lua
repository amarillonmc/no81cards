local m=4878147
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x48f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	if Duel.IsPlayerAffectedByEffect(tp,4878130) then
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
   end
end
function cm.setfilter1(c,g)
	return g:IsContains(c)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		  if Duel.IsExistingMatchingCard(cm.setfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,cg) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		   local g1=Duel.SelectMatchingCard(tp,cm.setfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cg)
   local tc1=g1:GetFirst()
   if tc1 then
   Duel.SendtoHand(tc1,nil,REASON_EFFECT)
   if Duel.IsPlayerAffectedByEffect(tp,4878130) then
	Duel.Draw(tp,1,REASON_EFFECT)
   end
   end
		  end
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cm.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.splimit(e,c)
	return (not c:IsSetCard(0x48f) and c:IsLocation(LOCATION_DECK)) and (not c:IsSetCard(0x48c) and c:IsLocation(LOCATION_HAND))
end