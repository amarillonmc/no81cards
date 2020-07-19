--黑钢国际·行动-领点占据
function c79029219.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,79029219)
	e1:SetTarget(c79029219.target)
	e1:SetOperation(c79029219.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCountLimit(1,7902922099999)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c79029219.sgcost)
	e2:SetTarget(c79029219.sgtg)
	e2:SetOperation(c79029219.sgop)
	c:RegisterEffect(e2)
end
function c79029219.fil(c)
	return c:GetSequence()<=4
end
function c79029219.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029219.fil,tp,LOCATION_MZONE,0,1,nil) and (not Duel.IsExistingMatchingCard(c79029219.bfil1,tp,LOCATION_MZONE,0,1,nil) or not Duel.IsExistingMatchingCard(c79029219.bfil2,tp,LOCATION_MZONE,0,1,nil)) end
	local g=Duel.SelectMatchingCard(tp,c79029219.fil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetTargetCard(g)
end
function c79029219.bfil1(c)
	return c:GetSequence()==6
end
function c79029219.bfil2(c)
	return c:GetSequence()==5
end
function c79029219.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local op=0 
	local b1=not Duel.IsExistingMatchingCard(c79029219.bfil1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=not Duel.IsExistingMatchingCard(c79029219.bfil2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if b1 and b2 then
	op=Duel.SelectOption(tp,aux.Stringid(79029219,1),aux.Stringid(79029219,0))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(79029219,1))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(79029219,0))+1
	else
	return false
	end
	if op==0 then
	Duel.MoveSequence(tc,6)
	else
	Duel.MoveSequence(tc,5)
end
end
function c79029219.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c79029219.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_DECK,0,1,nil,0x1904) end
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_DECK,0,1,1,nil,0x1904)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,tp,0)
end
function c79029219.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1904) and c:GetLevel()>=9
end
function c79029219.ghfilter(c)
	return c:GetSequence()>4
end
function c79029219.sgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SendtoGrave(tc,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c79029219.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c79029219.ghfilter,tp,0,LOCATION_MZONE,1,nil) then
	if Duel.SelectYesNo(tp,aux.Stringid(79029219,2)) then
	local g=Duel.SelectMatchingCard(tp,c79029219.ghfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	Duel.Destroy(g,REASON_EFFECT)
end
end
end





