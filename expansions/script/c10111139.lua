function c10111139.initial_effect(c)
	aux.AddCodeList(c,10111128)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10111139+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10111139.cost)
	e1:SetTarget(c10111139.target)
	e1:SetOperation(c10111139.activate)
	c:RegisterEffect(e1)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111139,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101111390)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c10111139.atkcon)
	e2:SetTarget(c10111139.atktg)
	e2:SetOperation(c10111139.atkop)
	c:RegisterEffect(e2)
end
function c10111139.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c10111139.filter1(c)
	return c:IsCode(10111128) and c:IsAbleToHand()
end
function c10111139.filter2(c)
	return c:IsSetCard(0xf008) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10111139.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111139.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c10111139.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c10111139.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c10111139.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c10111139.filter2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
end
function c10111139.cfilter(c)
	local bc=c:GetBattleTarget()
	return c:IsSetCard(0xf008) or (bc and bc:IsSetCard(0xf008))
end
function c10111139.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10111139.cfilter,1,nil)
end
function c10111139.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()~=0
end
function c10111139.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c10111139.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10111139.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10111139.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c10111139.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-ev-1000)
		tc:RegisterEffect(e1)
	end
end