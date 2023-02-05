--火山蝎
function c98920233.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,98920233)
	e2:SetCost(c98920233.cost)
	e2:SetCondition(c98920233.spcon)
	e2:SetTarget(c98920233.sptg)
	e2:SetOperation(c98920233.spop)
	c:RegisterEffect(e2)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920233,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,98920233)
	e1:SetCost(c98920233.cost1)
	e1:SetTarget(c98920233.tg)
	e1:SetOperation(c98920233.op)
	c:RegisterEffect(e1)
end
function c98920233.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c98920233.filter(c,e,tp)
	return c:IsSetCard(0x32) or c:IsSetCard(0xb9) and c:IsAbleToHand()
end
function c98920233.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c98920233.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920233.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920233.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.NegateAttack() then return end
	local sg=Duel.SelectMatchingCard(tp,c98920233.filter,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
	   Duel.SendtoHand(sg,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,sg)
	end
end
function c98920233.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c98920233.filter1(c)
	return c:IsSetCard(0x32) and c:IsAbleToHand()
end
function c98920233.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920233.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98920233.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLocation(LOCATION_GRAVE) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920233.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end