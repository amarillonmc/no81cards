--神便鬼毒酒
function c22022300.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022300,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_ATTACK)
	e1:SetTarget(c22022300.target)
	e1:SetOperation(c22022300.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022300,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,22022300)
	e2:SetCondition(c22022300.negcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22022300.destg)
	e2:SetOperation(c22022300.desop)
	c:RegisterEffect(e2)
end
function c22022300.filter(c)
	return c:IsFaceup()
end
function c22022300.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22022300.filter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c22022300.filter,tp,0,LOCATION_MZONE,nil)
end
function c22022300.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,nil,0x1009,1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1009,1)
		tc=g:GetNext()
	end
end
function c22022300.negcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.GetTurnPlayer()==tp
end
function c22022300.filter1(c)
	return c:IsFaceup() and c:GetCounter(0x1009)>0
end
function c22022300.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22022300.filter1,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c22022300.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c22022300.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c22022300.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
