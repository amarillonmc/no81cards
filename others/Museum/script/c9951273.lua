--宝具·开辟之理
function c9951273.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9951273+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9951273.target)
	e1:SetOperation(c9951273.operation)
	c:RegisterEffect(e1)
  --Equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetValue(c9951273.eqlimit)
	c:RegisterEffect(e4)
 --Eraser
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9951273,0))
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,9951273)
	e6:SetCost(c9951273.descost)
	e6:SetTarget(c9951273.erastg)
	e6:SetOperation(c9951273.erasop)
	c:RegisterEffect(e6)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9951273,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,9951273)
	e5:SetCost(c9951273.thcost)
	e5:SetTarget(c9951273.thtg)
	e5:SetOperation(c9951273.thop)
	c:RegisterEffect(e5)
end
function c9951273.eqlimit(e,c)
	return c:IsSetCard(0x9ba5)
end
function c9951273.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9ba5)
end
function c9951273.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9951273.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9951273.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9951273.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9951273.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c9951273.atkcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c9951273.atkval(e,c)
	return math.abs(Duel.GetLP(0)-Duel.GetLP(1))
end
function c9951273.costfilter(c)
	return c:IsSetCard(0x9ba5) and c:IsDiscardable()
end
function c9951273.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.IsExistingMatchingCard(c9951273.costfilter,tp,LOCATION_HAND,0,1,nil) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.DiscardHand(tp,c9951273.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c9951273.thfilter(c)
	return c:IsSetCard(0x9ba5) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(9951273) and c:IsAbleToHand()
end
function c9951273.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951273.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9951273.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9951273.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9951273.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	local tc=e:GetHandler():GetEquipTarget()
	Duel.SetTargetCard(tc)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9951273.erastg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,dg,dg:GetCount(),0,0)
end
function c9951273.erasop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoGrave(dg,REASON_EFFECT)
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951273,0))
end
