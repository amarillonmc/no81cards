--术结天缘 米克什阿娜
function c67200416.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableCounterPermit(0x671,LOCATION_PZONE+LOCATION_MZONE)
	--search
	local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c67200416.ctcon)
	--e1:SetTarget(c67200416.cttg)
	e1:SetOperation(c67200416.ctop1)
	c:RegisterEffect(e1)  
	--add counter
	local e2=Effect.CreateEffect(c)
	--e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c67200416.ctcon)
	--e2:SetTarget(c67200416.cttg)
	e2:SetOperation(c67200416.ctop)
	c:RegisterEffect(e2)  
	--pendulum scale up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetValue(c67200416.scaledown)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e4)	
end
function c67200416.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsType(TYPE_PENDULUM) and c:IsPreviousSetCard(0x5671)
end
function c67200416.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200416.ctfilter,1,nil,tp)
end
function c67200416.actfilter(c,e,tp)
	return c:IsSetCard(0x5671) and c:IsCanBeSpecialSummoned(e,0,tp,tp,false) and c:IsFaceup()
end

function c67200416.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:GetHandler():AddCounter(0x671,2)
	if Duel.IsExistingMatchingCard(c67200416.actfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and c:GetCounter(0x671)>5 and c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(67200416,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c67200416.actfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
--
function c67200416.scaledown(e,c)
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

function c67200416.ctop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x671,1)>0 then
		local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x671,1)
		local ct=g:GetCount()
		if ct>0 then
			local tc=g:GetFirst()
			while tc do
				tc:AddCounter(0x671,1)
				tc=g:GetNext()
			end
		end
	end
end