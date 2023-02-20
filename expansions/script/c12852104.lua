--转天魔具-魔法剑
function c12852104.initial_effect(c)
	aux.AddCodeList(c,12852102)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c12852104.target)
	e1:SetOperation(c12852104.operation)
	c:RegisterEffect(e1)	
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c12852104.eqlimit)
	c:RegisterEffect(e3)
	--twiceattack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12852104,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,12852106)
	e2:SetCondition(c12852104.thcon)
	e2:SetTarget(c12852104.thtg)
	e2:SetOperation(c12852104.thop)
	c:RegisterEffect(e2)
	--to hand
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(12852104,1))
	e21:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e21:SetType(EFFECT_TYPE_IGNITION)
	e21:SetRange(LOCATION_GRAVE)
	e21:SetCountLimit(1,12852106)
	e21:SetCost(aux.bfgcost)
	e21:SetTarget(c12852104.thtg1)
	e21:SetOperation(c12852104.thop1)
	c:RegisterEffect(e21)
end
function c12852104.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR) or c:IsCode(12852102)
end
function c12852104.eqfilter1(c)
	return c:IsFaceup() and (c:IsRace(RACE_WARRIOR) or c:IsCode(12852102))
end
function c12852104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12852104.eqfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12852104.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c12852104.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c12852104.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end
function c12852104.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler():GetEquipTarget()
end
function c12852104.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12852104.thop(e,tp,eg,ep,ev,re,r,rp)
	tc=e:GetHandler():GetEquipTarget()
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(2500)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	tc:RegisterEffect(e2)
	Duel.ChainAttack()
end
function c12852104.thfilter(c)
	return aux.IsCodeListed(c,12852102) and c:IsAbleToHand()
end
function c12852104.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12852104.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c12852104.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12852104.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if #sg>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end