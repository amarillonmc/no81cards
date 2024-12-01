--玄机结阵
function c67200976.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200976+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c67200976.condition)
	e1:SetTarget(c67200976.target)
	e1:SetOperation(c67200976.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(67200976,ACTIVITY_CHAIN,c67200976.chainfilter)	
end
function c67200976.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
	return (re:GetActiveType()==TYPE_PENDULUM+TYPE_SPELL and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and bit.band(loc,LOCATION_PZONE)==LOCATION_PZONE and rc:IsSetCard(0x67a))
end
function c67200976.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(67200976,tp,ACTIVITY_CHAIN)~=0
end
function c67200976.setfilter(c)
	return c:IsSetCard(0xc67a) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c67200976.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c67200976.setfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
		and g:GetClassCount(Card.GetCode)>=2 end
end
function c67200976.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) or not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.GetMatchingGroup(c67200976.setfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	local tc1=g1:GetFirst()
	local tc2=g1:GetNext()
	if Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
		if Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
			tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
		tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
end

