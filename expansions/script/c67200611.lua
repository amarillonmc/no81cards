--征冥天的唤灵师
function c67200611.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--hyper pendulum splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c67200611.splimit)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200611,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,67200611)
	e1:SetCost(c67200611.thcost)
	e1:SetTarget(c67200611.thtg)
	e1:SetOperation(c67200611.thop)
	c:RegisterEffect(e1)
	--reborn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200611,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,67200611)
	e2:SetCondition(c67200611.spcon)
	e2:SetTarget(c67200611.sptg)
	e2:SetOperation(c67200611.spop)
	c:RegisterEffect(e2)	  
end
--
function c67200611.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
--
function c67200611.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoExtraP(c,tp,REASON_COST)
end
function c67200611.thfilter(c)
	return c:IsSetCard(0x677) and c:IsAbleToHand() and not c:IsCode(67200611)
end
function c67200611.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200611.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200611.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200611.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c67200611.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function c67200611.spfilter(c,e,tp)
	return c:IsSetCard(0x677) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200611.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c67200611.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c67200611.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200611.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			g:GetFirst():RegisterEffect(e1,true)
		end
	end
end
