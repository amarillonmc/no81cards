--失控磁盘爆破
function c95101242.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c95101242.target)
	e1:SetOperation(c95101242.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95101242,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c95101242.thtg)
	e2:SetOperation(c95101242.thop)
	c:RegisterEffect(e2)
end
function c95101242.tfilter(c,g)
	return c:IsSetCard(0x6bb0) and c:IsFaceup() and (c:IsAttackPos() and g:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) or c:IsDefensePos() and g:IsExists(Card.IsType,1,nil,TYPE_SPELL+TYPE_TRAP))
end
function c95101242.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c95101242.tfilter(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(c95101242.tfilter,tp,LOCATION_MZONE,0,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c95101242.tfilter,tp,LOCATION_MZONE,0,1,1,nil,g)
end
function c95101242.cfilter(c,pos)
	return c:IsSetCard(0x6bb0) and c:IsPosition(pos)
end
function c95101242.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local pos=tc:IsAttackPos() and POS_FACEUP_ATTACK or POS_FACEUP_DEFENSE 
	local ct=Duel.GetMatchingGroupCount(c95101242.cfilter,tp,LOCATION_MZONE,0,nil,pos)
	local g=tc:IsAttackPos() and Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil) or Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,ct,nil)
	if #sg==0 then return end
	Duel.HintSelection(sg)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c95101242.thfilter(c)
	return c:IsSetCard(0x6bb0) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c95101242.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101242.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95101242.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c95101242.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
