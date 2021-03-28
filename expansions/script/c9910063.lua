--着花之月神
function c9910063.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910063,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,9910063)
	e1:SetCost(c9910063.cost1)
	e1:SetTarget(c9910063.target1)
	e1:SetOperation(c9910063.operation1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(9910063,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCost(c9910063.cost2)
	e2:SetTarget(c9910063.target2)
	e2:SetOperation(c9910063.operation2)
	c:RegisterEffect(e2)
	--return to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCost(c9910063.thcost)
	e3:SetTarget(c9910063.thtg)
	e3:SetOperation(c9910063.thop)
	c:RegisterEffect(e3)
end
function c9910063.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9910063.thfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function c9910063.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()~=tp and chkc:IsOnField() and c9910063.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910063.thfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9910063.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c9910063.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)~=0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c9910063.rmfilter(c)
	return c:IsSetCard(0x9951) and c:IsAbleToRemoveAsCost()
end
function c9910063.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c9910063.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c) end
	Duel.SendtoGrave(c,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910063.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9910063.tdfilter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c9910063.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()~=tp and chkc:IsOnField() and c9910063.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910063.tdfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9910063.tdfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c9910063.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)~=0 then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c9910063.cfilter(c)
	return c:IsRace(RACE_FAIRY) and not c:IsPublic()
end
function c9910063.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910063.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c9910063.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c9910063.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetAttackTarget()==c or (Duel.GetAttacker()==c and Duel.GetAttackTarget()~=nil) end
	local g=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c9910063.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local c=Duel.GetAttacker()
	if c:IsRelateToBattle() then g:AddCard(c) end
	c=Duel.GetAttackTarget()
	if c~=nil and c:IsRelateToBattle() then g:AddCard(c) end
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
