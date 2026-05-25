--合辛的■■■■
function c17337719.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c17337719.cost)
	e1:SetTarget(c17337719.target)
	e1:SetOperation(c17337719.activate)
	c:RegisterEffect(e1)
	if not c17337719.global_check then
		c17337719.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(c17337719.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c17337719.costfilter(c,tp)
	return c:IsCode(17337700) and c:IsAbleToHandAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c17337719.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17337719.costfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,c17337719.costfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
function c17337719.spfilter(c,e,tp)
	return c:IsCode(17337716) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17337719.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetMZoneCount(tp)>0 or e:IsCostChecked())
		and Duel.IsExistingMatchingCard(c17337719.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end--Duel.IsPlayerAffectedByEffect(tp,59822133)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c17337719.activate(e,tp,eg,ep,ev,re,r,rp)
	--disable
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c17337719.distg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--spsummon
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c17337719.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c17337719.distg(e,c)
	return c:IsOriginalCodeRule(17337700,17337708) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c17337719.cfilter(c)
	return c:GetPreviousCodeOnField()==17337708 and c:IsPreviousPosition(POS_FACEUP) and not c:IsReason(REASON_RULE)
end
function c17337719.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c17337719.cfilter,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		if tc:GetReasonPlayer()~=tc:GetPreviousControler() then
			Duel.RegisterFlagEffect(tc:GetPreviousControler(),17337719,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
