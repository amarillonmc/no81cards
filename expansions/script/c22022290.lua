--人理之诗 万紫千红·神便鬼毒
function c22022290.initial_effect(c)
	aux.AddCodeList(c,22022280)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022290,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,c22022290)
	e1:SetCondition(c22022290.condition)
	e1:SetOperation(c22022290.activate)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022290,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,c22022291)
	e2:SetCondition(c22022290.condition1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22022290.target)
	e2:SetOperation(c22022290.ctop)
	c:RegisterEffect(e2)
end
function c22022290.cfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1009)>0
end
function c22022290.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22022290.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c22022290.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SelectOption(tp,aux.Stringid(22022290,2))
	Duel.SelectOption(tp,aux.Stringid(22022290,3))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCode(EFFECT_SKIP_BP)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2,tp)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-1000)
	Duel.SelectOption(tp,aux.Stringid(22022290,4))
end
function c22022290.filter(c)
	return c:IsFaceup()
end
function c22022290.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22022290.filter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c22022290.filter,tp,0,LOCATION_MZONE,nil)
end
function c22022290.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,nil,0x1009,1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1009,1)
		tc=g:GetNext()
	end
end
function c22022290.cfilter1(c)
	return c:IsFaceup() and c:IsCode(22022280)
end
function c22022290.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22022290.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end