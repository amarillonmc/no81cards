--炼金手套
function c9911613.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911613,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9911613.cost1)
	e1:SetTarget(c9911613.target1)
	e1:SetOperation(c9911613.activate1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911613,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(c9911613.condition)
	e2:SetCost(c9911613.cost2)
	e2:SetTarget(c9911613.target2)
	e2:SetOperation(c9911613.activate2)
	c:RegisterEffect(e2)
end
function c9911613.cffilter(c)
	return not c:IsPublic()
end
function c9911613.tgfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsAbleToGrave()
end
function c9911613.gselect1(g,lv)
	return g:GetSum(Card.GetLevel)==lv and aux.dlvcheck(g)
end
function c9911613.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9911613.cffilter,tp,0,LOCATION_HAND,nil)
	local dg=Duel.GetMatchingGroup(c9911613.tgfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return #g>0 and #dg>0 and dg:CheckSubGroup(c9911613.gselect1,1,#g,#g) end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(9911613,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,66)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	Duel.AdjustAll()
	Duel.ShuffleHand(1-tp)
	e:SetLabel(#g)
end
function c9911613.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9911613.activate1(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local dg=Duel.GetMatchingGroup(c9911613.tgfilter,tp,LOCATION_DECK,0,nil)
	if lv<1 or #dg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=dg:SelectSubGroup(tp,c9911613.gselect1,false,1,lv,lv)
	if g and #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c9911613.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9911613.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c9911613.rmfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
end
function c9911613.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function c9911613.gselect2(g,gg)
	return gg:FilterCount(aux.TRUE,g)>=#g
end
function c9911613.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9911613.spfilter(chkc,e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(c9911613.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local gg=Duel.GetMatchingGroup(c9911613.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ct=math.min(ft,#g,#gg)
	if chk==0 then
		if e:GetLabel()==100 then
			return ct>0 and g:CheckSubGroup(c9911613.gselect2,1,ct,gg)
		else return false end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,c9911613.gselect2,false,1,ct,gg)
	local rt=Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,c9911613.spfilter,tp,LOCATION_GRAVE,0,1,rt,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#sg,0,0)
end
function c9911613.activate2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	local og=Duel.GetOperatedGroup()
	for tc in aux.Next(og) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,1)
		e1:SetLabel(tc:GetLevel())
		e1:SetTarget(c9911613.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9911613.splimit(e,c)
	return c:IsLevel(e:GetLabel())
end
