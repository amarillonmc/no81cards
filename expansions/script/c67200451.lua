--术结天缘骑 岚磷结骑
function c67200451.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableCounterPermit(0x671,LOCATION_PZONE+LOCATION_MZONE)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c67200451.excost)
	e1:SetTarget(c67200451.destg)
	e1:SetOperation(c67200451.desop)
	c:RegisterEffect(e1)  
	--add counter
	local e2=Effect.CreateEffect(c)
	--e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c67200451.ctcon)
	--e2:SetTarget(c67200451.cttg)
	e2:SetOperation(c67200451.ctop)
	c:RegisterEffect(e2) 
	--pendulum scale up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetValue(c67200451.scaledown)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e4)	
end
function c67200451.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsType(TYPE_PENDULUM) and c:IsPreviousSetCard(0x5671)
end
function c67200451.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200451.ctfilter,1,nil,tp)
end
function c67200451.actfilter(c,e,tp)
	return c:IsCode(67200400) and c:IsCanBeSpecialSummoned(e,0,tp,tp,false)
end
--function c67200451.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return true end
	--Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x1)
--end
function c67200451.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:GetHandler():AddCounter(0x671,2)
	if Duel.IsExistingMatchingCard(c67200451.actfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and c:GetCounter(0x671)>5 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(67200451,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c67200451.actfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
--
function c67200451.scaledown(e,c)
	local count=c:GetCounter(0x671)
	local a=0
	if count>6 then
		a=6
	else
		a=count
	end
	return -a
end
--
function c67200451.excostfilter(c)
	return c:IsCode(67200400) and c:IsAbleToHandAsCost()
end
function c67200451.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c67200451.excostfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200451.excostfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalLevel())
end
function c67200451.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c67200451.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c67200451.thfilter,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c67200451.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c67200451.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local count=e:GetLabel()
		e:GetHandler():AddCounter(0x671,count)
	end
end
