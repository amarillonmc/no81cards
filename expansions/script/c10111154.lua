function c10111154.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10111154.spcon1)
	e1:SetCost(c10111154.cost)
	e1:SetTarget(c10111154.target)
	e1:SetOperation(c10111154.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10111154)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c10111154.spcon)
	e2:SetTarget(c10111154.sptg)
	e2:SetOperation(c10111154.spop)
	c:RegisterEffect(e2)
end
function c10111154.filter2(c)
	return c:IsCode(56099748) and c:IsFaceup()
end
function c10111154.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10111154.filter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c10111154.cfilter(c)
	return c:IsFaceup() and c:IsCode(56099748)
end
function c10111154.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local g=Duel.GetMatchingGroup(c10111154.cfilter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return g:GetCount()>0 and g:FilterCount(Card.IsAbleToGraveAsCost,nil)==g:GetCount() end
	Duel.SendtoGrave(g,REASON_COST)
end
function c10111154.filter(c,tp)
	return (c:IsFacedown() or c:IsControler(1-tp) or not c:IsCode(56099748)) and c:IsType(TYPE_EFFECT+TYPE_SPELL+TYPE_TRAP)
end
function c10111154.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then
			return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),TYPE_EFFECT+TYPE_SPELL+TYPE_TRAP)
		end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c10111154.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp)
	end
	e:SetLabel(0)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),TYPE_EFFECT+TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c10111154.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e),TYPE_EFFECT+TYPE_SPELL+TYPE_TRAP)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c10111154.filter1(c,e,tp)
	return aux.IsCodeListed(c,56099748) and c:IsAbleToHand()
end
function c10111154.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c10111154.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111154.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10111154.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.NegateAttack() then return end
	local sg=Duel.SelectMatchingCard(tp,c10111154.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
	   Duel.SendtoHand(sg,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,sg)
	end
end