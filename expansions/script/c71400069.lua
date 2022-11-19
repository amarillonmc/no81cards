--血、脓、锖
function c71400069.initial_effect(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400069,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c71400069.con1)
	e1:SetCost(c71400069.cost1)
	e1:SetTarget(c71400069.tg1)
	e1:SetOperation(c71400069.op1)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400069,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c71400069.con2)
	e2:SetCost(c71400069.cost2)
	e2:SetTarget(c71400069.tg2)
	e2:SetOperation(c71400069.op2)
	c:RegisterEffect(e2)
	if not c71400069.global_check then
		c71400069.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EFFECT_SEND_REPLACE)
		ge1:SetTarget(c71400069.reptg)
		Duel.RegisterEffect(ge1,0)
	end
end
function c71400069.filtercon1(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_LINK)
end
function c71400069.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71400069.filtercon1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	return yume.IsYumeFieldOnField(tp) and #g>0 and g:GetSum(Card.GetLink)>=4 and Duel.IsChainNegatable(ev)
end
function c71400069.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c71400069.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp,POS_FACEDOWN) end
end
function c71400069.filter1(c)
	return c:IsCode(71400038) and c:IsAbleToHand()
end
function c71400069.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e))
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tg=Duel.GetMatchingGroup(c71400069.filter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)>0 and tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71400069,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=tg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c71400069.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.CheckLPCost(tp,1000) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.PayLPCost(tp,1000)
end
function c71400069.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=eg:GetSum(Card.GetLink)
		for i=1,ct do
			Duel.RegisterFlagEffect(0,71400069,RESET_PHASE+PHASE_END,0,1)
		end
		return false
	end
	return false
end
function c71400069.filter2(c)
	return c:IsSetCard(0x714) and not c:IsCode(71400069) and c:IsAbleToGrave()
end
function c71400069.con2(e,tp,eg,ep,ev,re,r,rp)
	return yume.IsYumeFieldOnField(tp) and Duel.GetFlagEffect(0,71400069)>=4
end
function c71400069.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400069.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c71400069.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c71400069.filter2,tp,LOCATION_DECK,0,1,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end