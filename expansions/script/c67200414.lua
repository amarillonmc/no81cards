--术结天缘 卡特莉特
function c67200414.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableCounterPermit(0x671,LOCATION_PZONE+LOCATION_MZONE)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200414,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,67200414)
	e1:SetCost(c67200414.excost)
	e1:SetTarget(c67200414.sptg)
	e1:SetOperation(c67200414.spop)
	c:RegisterEffect(e1)  
	--add counter
	local e2=Effect.CreateEffect(c)
	--e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c67200414.ctcon)
	--e2:SetTarget(c67200414.cttg)
	e2:SetOperation(c67200414.ctop)
	c:RegisterEffect(e2) 
	--pendulum scale up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetValue(c67200414.scaleup)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e4)	
end
--
function c67200414.excostfilter(c)
	return c:IsSetCard(0x5671) and c:IsAbleToHandAsCost() and c:IsType(TYPE_PENDULUM)
end
function c67200414.mfilter(c,tp)
	--local tp=c:GetControler()
	return c:GetSequence()<5 and c:IsLocation(LOCATION_MZONE) 
end
function c67200414.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200414.excostfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local rg=Duel.GetMatchingGroup(c67200414.excostfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		g=rg:Select(tp,1,1,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		g=rg:FilterSelect(tp,c67200414.mfilter,1,1,nil,tp)
	end
	Duel.SendtoHand(g,nil,REASON_COST)
	e:SetLabel(g:GetFirst():GetBaseAttack())
end
function c67200414.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsCanAddCounter(tp,0x671,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200414.acfilter(c)
	return c:IsSetCard(0x5671) and not c:IsForbidden() and c:IsType(TYPE_PENDULUM)
end
function c67200414.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then   
		if e:GetHandler():AddCounter(0x671,1)~=0 then
			Duel.BreakEffect()
			if Duel.IsExistingMatchingCard(c67200414.acfilter,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.SelectYesNo(tp,aux.Stringid(67200414,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local g=Duel.SelectMatchingCard(tp,c67200414.acfilter,tp,LOCATION_DECK,0,1,1,nil)
				local tc=g:GetFirst()
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		end
	end
end

--
function c67200414.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsType(TYPE_PENDULUM) and c:IsPreviousSetCard(0x5671)
end
function c67200414.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200414.ctfilter,1,nil,tp)
end
function c67200414.actfilter(c,e,tp)
	return c:IsSetCard(0x5671) and c:IsCanBeSpecialSummoned(e,0,tp,tp,false) and c:IsType(TYPE_PENDULUM)
end
--function c67200414.cttg(e,tp,eg,ep,ev,re,r,rp,chk)

function c67200414.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:GetHandler():AddCounter(0x671,2)
	if Duel.IsExistingMatchingCard(c67200414.actfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and c:GetCounter(0x671)>5 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(67200414,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c67200414.actfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
--
function c67200414.scaleup(e,c)
	local count=c:GetCounter(0x671)
	local a=0
	if count>6 then
		a=6
	else
		a=count
	end
	return a
end