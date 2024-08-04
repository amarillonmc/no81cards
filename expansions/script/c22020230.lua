--人理之诗 无限剑制
function c22020230.initial_effect(c)
	aux.AddCodeList(c,22020220)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22020230.condition)
	e1:SetOperation(c22020230.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c22020230.condition1)
	e2:SetOperation(c22020230.activate1)
	c:RegisterEffect(e2)
	--boost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,22020220))
	e3:SetValue(c22020230.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22020230,2))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,22020230)
	e5:SetCondition(c22020230.drcon)
	e5:SetCost(c22020230.drcost1)
	e5:SetTarget(c22020230.drtg1)
	e5:SetOperation(c22020230.drop1)
	c:RegisterEffect(e5)
	--to hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22020230,3))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,22020230)
	e6:SetCondition(c22020230.thcon)
	e6:SetCost(c22020230.thcost1)
	e6:SetTarget(c22020230.thtg1)
	e6:SetOperation(c22020230.thop1)
	c:RegisterEffect(e6)
	--tohand wuming
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22020230,4))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCountLimit(1,22020230)
	e7:SetCondition(c22020230.drcon1)
	e7:SetCost(c22020230.drcost1)
	e7:SetTarget(c22020230.target)
	e7:SetOperation(c22020230.operation)
	c:RegisterEffect(e7)
	--tohand
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(22020230,5))
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,22020230)
	e8:SetCondition(c22020230.thcon1)
	e8:SetTarget(c22020230.thtg2)
	e8:SetOperation(c22020230.thop2)
	c:RegisterEffect(e8)
end
function c22020230.condition(e)
	return not Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,1,nil,22022090)
end
function c22020230.condition1(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,1,nil,22022090)
end
function c22020230.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SelectOption(tp,aux.Stringid(22020230,0))
end
function c22020230.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SelectOption(tp,aux.Stringid(22020230,1))
end
function c22020230.atkfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xff1)
end
function c22020230.atkval(e,c)
	return Duel.GetMatchingGroupCount(c22020230.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*100
end
function c22020230.cfilter(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c22020230.drcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020230.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22020230.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22020230.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22020230.drop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c22020230.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22020230.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xff1) and c:IsAbleToHand()
end
function c22020230.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c22020230.filter(chkc) end
	local g=Duel.GetMatchingGroup(c22020230.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c22020230.thop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c22020230.drcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,22020380)
end
function c22020230.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020380)
end
function c22020230.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xff1) and c:IsAbleToHand() and not c:IsType(TYPE_FIELD)
end
function c22020230.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020230.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22020230.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22020230.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22020230.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,22020390)
end
function c22020230.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020390)
end
function c22020230.tdfilter(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_SPELL+TYPE_TRAP)  and c:IsAbleToHand()
end
function c22020230.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c22020230.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22020230.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c22020230.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22020230.desfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c22020230.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		local g=Duel.GetMatchingGroup(c22020230.desfilter,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22020230,6)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			Duel.HintSelection(g)
			Duel.SelectOption(tp,aux.Stringid(22020230,7))
			Duel.Destroy(g,REASON_EFFECT)
			Duel.Damage(1-tp,1500,REASON_EFFECT)
		end
	end
	Duel.ConfirmCards(1-tp,g)
end
