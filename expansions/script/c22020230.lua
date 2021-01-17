--人理之诗 无限剑制
function c22020230.initial_effect(c)
	aux.AddCodeList(c,22020220)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c22020230.cost0)
	c:RegisterEffect(e1)
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,22020220))
	e2:SetValue(1500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--tohand ex
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22020230,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,22020230)
	e4:SetCondition(c22020230.spcon2)
	e4:SetCost(c22020230.cost)
	e4:SetTarget(c22020230.target)
	e4:SetOperation(c22020230.operation)
	c:RegisterEffect(e4)
	--todeck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22020230,2))
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,22020230)
	e5:SetCondition(c22020230.con1)
	e5:SetTarget(c22020230.rettg)
	e5:SetOperation(c22020230.retop)
	c:RegisterEffect(e5)
	--tohand ubw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22020230,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1,22020230)
	e6:SetCondition(c22020230.spcon1)
	e6:SetCost(c22020230.cost)
	e6:SetTarget(c22020230.target0)
	e6:SetOperation(c22020230.operation0)
	c:RegisterEffect(e6)
	--todeck
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22020230,3))
	e7:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,22020230)
	e7:SetCondition(c22020230.con2)
	e7:SetTarget(c22020230.tdtg)
	e7:SetOperation(c22020230.tdop)
	c:RegisterEffect(e7)
end
function c22020230.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Debug.Message("My whole life was unlimited blade works!")
end
function c22020230.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,22020390)
end
function c22020230.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020390)
end
function c22020230.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,22020380)
end
function c22020230.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020380)
end
function c22020230.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
	Debug.Message("TRACE.ON!")
end
function c22020230.filter(c)
	return c:IsSetCard(0x3ff1) and not c:IsCode(22020230) and c:IsAbleToHand()
end
function c22020230.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020230.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22020230.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22020230.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22020230.filter1(c)
	return c:IsSetCard(0x3ff1) and c:IsAbleToDeck()
end
function c22020230.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22020230.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22020230.filter1,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c22020230.filter1,tp,LOCATION_GRAVE,0,1,99,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*200)
end
function c22020230.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if ct>0 then
		Duel.Damage(1-tp,ct*200,REASON_EFFECT)
	end
end
function c22020230.filter0(c)
	return c:IsSetCard(0x3ff1) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c22020230.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020230.filter0,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22020230.operation0(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22020230.filter0,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22020230.tdfilter(c)
	return c:IsSetCard(0x3ff1) and c:IsAbleToDeck()
end
function c22020230.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c22020230.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22020230.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c22020230.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c22020230.desfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c22020230.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
		local g=Duel.GetMatchingGroup(c22020230.desfilter,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22020230,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
			Duel.Damage(1-tp,1500,REASON_EFFECT)
		end
	end
end
