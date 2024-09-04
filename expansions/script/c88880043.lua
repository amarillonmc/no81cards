--ÌìÔì²ÝÃÁ
function c88880043.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,88880037,LOCATION_REMOVED+LOCATION_GRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88880043,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c88880043.target)
	e1:SetOperation(c88880043.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88880043,1))
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c88880043.cost)
	e2:SetTarget(c88880043.target2)
	e2:SetOperation(c88880043.activate2)
	c:RegisterEffect(e2)	
	--cost
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88880043,2))
	e3:SetCategory(CATEGORY_CONTROL+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c88880043.cost1)
	e3:SetTarget(c88880043.target23)
	e3:SetOperation(c88880043.activate23)
	c:RegisterEffect(e3)	
end
function c88880043.thfilter(c)
	return c:IsSetCard(0xc06) and c:IsAbleToHand()
end
function c88880043.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880043.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88880043.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88880043.thfilter),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c88880043.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c88880043.ntrfilter(c)
	return c:IsControlerCanBeChanged()
end
function c88880043.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(c88880043.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c88880043.ntrfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,LOCATION_MZONE)
end
function c88880043.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88880043.thfilter),tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
	local ctg=Duel.GetMatchingGroup(c88880043.ntrfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and ctg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
			local cttg=ctg:Select(tp,1,1,nil)
			local ctc=cttg:GetFirst()
			local tcp=ctc:GetControler()
			Duel.GetControl(ctc,1-tcp) 
		end
	end
end
function c88880043.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c88880043.ntrfilter(c)
	return c:IsControlerCanBeChanged()
end
function c88880043.target23(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(c88880043.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c88880043.ntrfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,LOCATION_MZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c88880043.chainlm)
	end
end
function c88880043.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function c88880043.activate23(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88880043.thfilter),tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
	local ctg=Duel.GetMatchingGroup(c88880043.ntrfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and ctg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
			local cttg=ctg:Select(tp,1,1,nil)
			local ctc=cttg:GetFirst()
			local tcp=ctc:GetControler()
			Duel.GetControl(ctc,1-tcp) 
		end
	end
end