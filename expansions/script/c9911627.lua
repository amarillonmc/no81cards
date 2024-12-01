--死溢之毒瘴
function c9911627.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_POSITION+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911627)
	e1:SetTarget(c9911627.target)
	e1:SetOperation(c9911627.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9911627)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9911627.sptg)
	e2:SetOperation(c9911627.spop)
	c:RegisterEffect(e2)
end
function c9911627.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and (c:IsAbleToHand() or c:IsCanTurnSet())
end
function c9911627.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9911627.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9911627.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9911627.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c9911627.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c9911627.cfilter(c)
	return c:IsFaceupEx() and c:IsCode(9911601,9911614)
end
function c9911627.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local res=false
	if tc:IsAbleToHand() and (not c9911627.posfilter(tc) or Duel.SelectOption(1-tp,1104,aux.Stringid(9911627,0))==0) then
		res=Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND)
	else
		res=Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)>0
	end
	local ct=Duel.GetMatchingGroupCount(c9911627.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if res and ct>0 and Duel.IsPlayerCanDraw(tp,ct) and Duel.SelectYesNo(tp,aux.Stringid(9911627,1)) then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
function c9911627.spfilter(c,e,tp)
	return c:IsSetCard(0xc954) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9911627.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(c9911627.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9911627.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9911627.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
			tc:CompleteProcedure()
		end
	end
end
