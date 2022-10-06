--梦刻
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400066,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71400066+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c71400066.tg1)
	e1:SetOperation(c71400066.op1)
	c:RegisterEffect(e1)
	--cost
	local e1a=Effect.CreateEffect(c)
	e1a:SetDescription(aux.Stringid(71400066,1))
	e1a:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1a:SetType(EFFECT_TYPE_ACTIVATE)
	e1a:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1a:SetCode(EVENT_FREE_CHAIN)
	e1a:SetCountLimit(1,71400066+EFFECT_COUNT_CODE_OATH)
	e1a:SetCost(c71400066.cost1a)
	e1a:SetTarget(c71400066.tg1a)
	e1a:SetOperation(c71400066.op1a)
	c:RegisterEffect(e1a)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400066,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c71400066.con2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c71400066.tg2)
	e2:SetOperation(c71400066.op2)
	c:RegisterEffect(e2)
end
function c71400066.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then
		return Duel.CheckLPCost(tp,1000) and yume.YumeFieldCheck(tp,0,0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED) and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c71400066.limit(g:GetFirst()))
	end
end
function c71400066.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c71400066.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,1000) then
		Duel.PayLPCost(tp,1000)
	else
		return
	end
	local tc=Duel.GetFirstTarget()
	if yume.ActivateYumeField(e,tp,0,0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED) and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c71400066.cost1a(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c71400066.filter1a(c,tp)
	return c:IsSetCard(0xa714,0x5714) and c:IsAbleToHand() and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c71400066.tg1a(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then
		return Duel.CheckLPCost(tp,1000) and yume.YumeFieldCheck(tp,0,0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED) and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c71400066.filter1a,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c71400066.limit(g:GetFirst()))
	end
end
function c71400066.op1a(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,1000) then
		Duel.PayLPCost(tp,1000)
	else
		return
	end
	local tc=Duel.GetFirstTarget()
	if yume.ActivateYumeField(e,tp,0,0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED) and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71400066.filter1a),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c71400066.con2(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and yume.nonYumeCon(e,tp)
end
function c71400066.filter2(c)
	return c:IsCode(71400031) and c:IsAbleToHand()
end
function c71400066.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400066.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71400066.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71400066.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end