--枢冥的契约箱 维尔奇斯
function c67200436.initial_effect(c)
	c:EnableCounterPermit(0x671)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)	
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c67200436.ctcon)
	e1:SetOperation(c67200436.ctop1)
	c:RegisterEffect(e1) 
	--Add counter2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c67200436.addop2)
	c:RegisterEffect(e2)
	--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200436,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,67200436)
	e3:SetCondition(c67200436.pccon)
	e3:SetCost(c67200436.pccost)
	e3:SetTarget(c67200436.pctg)
	e3:SetOperation(c67200436.pcop)
	c:RegisterEffect(e3)
end
--
function c67200436.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsType(TYPE_PENDULUM) and c:IsPreviousSetCard(0x5671)
end
function c67200436.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200436.ctfilter,1,nil,tp)
end
function c67200436.ctop1(e,tp,eg,ep,ev,re,r,rp)
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
--
function c67200436.addop2(e,tp,eg,ep,ev,re,r,rp)
	local count=0
	local c=eg:GetFirst()
	while c~=nil do
		if c~=e:GetHandler() and c:IsOnField() then
			count=count+c:GetCounter(0x671)
		end
		c=eg:GetNext()
	end
	if count>0 then
		e:GetHandler():AddCounter(0x671,count)
	end
end
--
function c67200436.pccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x671)>9
end
function c67200436.pccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c67200436.filter1(c)
	return c:IsSetCard(0x5671) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c67200436.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200436.filter1,tp,LOCATION_DECK,0,1,nil) end
end
function c67200436.pcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c67200436.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end

