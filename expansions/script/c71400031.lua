--梦日记
if not c71400001 then dofile("expansions/script/c71400001.lua") end
function c71400031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetDescription(aux.Stringid(71400031,0))
	e1:SetCountLimit(1,71400031)
	e1:SetTarget(c71400031.tg1)
	e1:SetOperation(c71400031.op1)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetDescription(aux.Stringid(71400031,1))
	e2:SetCountLimit(1,71500031)
	e2:SetCondition(yume.nonYumeCon)
	e2:SetCost(c71400031.cost2)
	e2:SetTarget(c71400031.tg2)
	e2:SetOperation(c71400031.op2)
	c:RegisterEffect(e2)
end
function c71400031.filter1(c)
	return c:IsSetCard(0x714) and not c:IsCode(71400031) and c:IsAbleToHand()
end
function c71400031.filter1a(c)
	return c:IsLocation(LOCATION_REMOVED) and c:IsFacedown()
end
function c71400031.filter1b(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x714) and Duel.IsPlayerCanSendtoDeck(tp,c)
end
function c71400031.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400031.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(c71400031.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local tg=Duel.GetMatchingGroup(c71400031.filter1b,tp,LOCATION_ONFIELD,0,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,tg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c71400031.op1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c71400031.filter1b,tp,LOCATION_ONFIELD,0,e:GetHandler(),tp)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	local g=Duel.SelectMatchingCard(c71400031.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
	if g:GetCount()>0 then
		local cg=g:Filter(c71400031.filter1a,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		if cg:GetCount()>0 then Duel.ConfirmCards(1-tp,cg) end
	end
end
function c71400031.filter2(c)
	return c:IsSetCard(0x3714) and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function c71400031.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400031.filter2,tp,LOCATION_FZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c71400031.filter2,tp,LOCATION_FZONE,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c71400031.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c71400031.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		Duel.SetLP(tp,Duel.GetLP(tp)-1000)
	end
end