--玄化主宰者-许帕里翁
function c72100117.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c72100117.hspcon)
	e1:SetOperation(c72100117.hspop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72100117,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c72100117.condition)
	e2:SetCost(c72100117.cost)
	e2:SetTarget(c72100117.target)
	e2:SetOperation(c72100117.operation)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCondition(c72100117.thcon)
	e4:SetCost(c72100117.thcost)
	e4:SetTarget(c72100117.thtg)
	e4:SetOperation(c72100117.thop)
	c:RegisterEffect(e4)
end
function c72100117.spfilter(c)
	return c:IsSetCard(0x105) and c:IsAbleToRemoveAsCost() and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
end
function c72100117.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=-1 then return false end
	if ft<=0 then
		return Duel.IsExistingMatchingCard(c72100117.spfilter,tp,LOCATION_MZONE,0,1,c)
	else return Duel.IsExistingMatchingCard(c72100117.spfilter,tp,0x16,0,1,c) end
end
function c72100117.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		local g=Duel.SelectMatchingCard(tp,c72100117.spfilter,tp,LOCATION_MZONE,0,1,1,c)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	else
		local g=Duel.SelectMatchingCard(tp,c72100117.spfilter,tp,0x16,0,1,1,c)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c72100117.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsEnvironment(20720928) then return e:GetHandler():GetFlagEffect(72100117)<2
	else return e:GetHandler():GetFlagEffect(72100117)<1 end
end
function c72100117.costfilter(c)
	return c:IsSetCard(0x105) and c:IsAbleToRemoveAsCost()
end
function c72100117.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72100117.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c72100117.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c72100117.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(72100117,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c72100117.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
-----
function c72100117.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetHandler():GetTurnID()+1
end
function c72100117.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),tp,2,REASON_COST)
end
function c72100117.thfilter(c)
	return c:IsSetCard(0x105) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c72100117.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72100117.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72100117.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72100117.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end