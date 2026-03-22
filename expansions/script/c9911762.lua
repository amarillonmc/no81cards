--变迁的远古造物
function c9911762.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911762,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911762+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911762.target)
	e1:SetOperation(c9911762.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911762,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9911762+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c9911762.cost)
	e2:SetTarget(c9911762.target2)
	e2:SetOperation(c9911762.activate2)
	c:RegisterEffect(e2)
end
function c9911762.regop(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(9911762)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	return e1
end
function c9911762.lkfilter(c)
	return c:IsSetCard(0xc950) and c:IsLinkSummonable(nil)
end
function c9911762.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local e1=c9911762.regop(e,tp)
		local res=Duel.IsExistingMatchingCard(c9911762.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
		e1:Reset()
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9911762.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=c9911762.regop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911762.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SPSUMMON_COST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetLabelObject(e1)
		e2:SetOperation(c9911762.resetop)
		tc:RegisterEffect(e2)
		Duel.LinkSummon(tp,tc,nil)
	else
		e1:Reset()
	end
end
function c9911762.resetop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	e1:Reset()
	e:Reset()
end
function c9911762.cfilter(c)
	return c:IsFacedown() and c:IsAbleToGraveAsCost()
end
function c9911762.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911762.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9911762.cfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c9911762.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local e1=c9911762.regop(e,tp)
		local res=Duel.IsExistingMatchingCard(c9911762.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
		e1:Reset()
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c9911762.chlimit)
	end
end
function c9911762.chlimit(e,ep,tp)
	return tp==ep
end
function c9911762.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=c9911762.regop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911762.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SPSUMMON_COST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetLabelObject(e1)
		e2:SetOperation(c9911762.resetop)
		tc:RegisterEffect(e2)
		Duel.LinkSummon(tp,tc,nil)
	else
		e1:Reset()
	end
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsSSetable(true) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
