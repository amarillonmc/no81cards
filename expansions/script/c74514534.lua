--人偶·西勒诺斯
function c74514534.initial_effect(c)
	aux.EnableDualAttribute(c)
	--look
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74514534,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c74514534.con1)
	e1:SetCost(c74514534.cost1)
	e1:SetTarget(c74514534.target)
	e1:SetOperation(c74514534.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(c74514534.con2)
	e2:SetCost(c74514534.cost2)
	c:RegisterEffect(e2)
end
function c74514534.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDualState() and not Duel.IsPlayerAffectedByEffect(tp,74590055)
end
function c74514534.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c74514534.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDualState() and aux.dscon() and Duel.IsPlayerAffectedByEffect(tp,74590055)
end
function c74514534.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Recover(tp,1000,REASON_COST)
end
function c74514534.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=2 end
end
function c74514534.operation(e,tp,eg,ep,ev,re,r,rp)
	local d1=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local d2=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if #d1==0 or #d2==0 then return end
	Duel.ConfirmCards(tp,d2)
	Duel.ConfirmCards(1-tp,d1)
	Duel.BreakEffect()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(74514534,1))
		local tc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(74514534,1))
		local tc2=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		Duel.ShuffleDeck(1-tp)
		Duel.MoveSequence(tc2,SEQ_DECKTOP)
		Duel.ConfirmDecktop(1-tp,1)
	end
end
