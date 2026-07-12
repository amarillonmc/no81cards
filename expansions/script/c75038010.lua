--疫苗龙
function c75038010.initial_effect(c)
	aux.AddCodeList(c,89631139,21082832)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75038010,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75038010) 
	e1:SetCost(c75038010.thcost)
	e1:SetTarget(c75038010.thtg)
	e1:SetOperation(c75038010.thop)
	c:RegisterEffect(e1)
	--attack down
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,75038011)
	e2:SetCost(c75038010.atkcost)
	e2:SetOperation(c75038010.atkop)
	c:RegisterEffect(e2)
end
function c75038010.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end 
end
function c75038010.thfilter(c)
	return aux.IsCodeListed(c,89631139) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c75038010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75038010.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c75038010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75038010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
	end
end
function c75038010.atkfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(100)
end
function c75038010.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,100,true)
		and Duel.IsExistingMatchingCard(c75038010.atkfilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c75038010.atkfilter,tp,0,LOCATION_MZONE,e:GetHandler())
	local tg,atk=g:GetMaxGroup(Card.GetAttack)
	local maxc=math.min(Duel.GetLP(tp),atk,25500)
	local ct=math.floor(maxc/100)
	local t={}
	for i=1,ct do
		t[i]=i*100
	end
	local cost=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,cost,true)
	e:SetLabel(cost)
end
function c75038010.adesfil(c,atk) 
	return c:IsFaceup() and c:IsAttackBelow(atk)  
end 
function c75038010.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c75038010.atkfilter,tp,0,LOCATION_MZONE,aux.ExceptThisCard(e))
	local tc=g:GetFirst()
	local val=e:GetLabel()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end  
	if Duel.IsExistingMatchingCard(c75038010.adesfil,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) then  
		local dg=Duel.SelectMatchingCard(tp,c75038010.adesfil,tp,0,LOCATION_MZONE,1,1,nil,c:GetAttack()) 
		Duel.Destroy(dg,REASON_EFFECT) 
	end 
end


