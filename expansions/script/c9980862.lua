--装甲骑士·西瓜武装
function c9980862.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9980862.target)
	e1:SetOperation(c9980862.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c9980862.eqlimit)
	c:RegisterEffect(e2)
	--Atk Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(c9980862.value)
	c:RegisterEffect(e3)
	--Pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9980862,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(c9980862.rmcon)
	e4:SetTarget(c9980862.rmtg)
	e4:SetOperation(c9980862.rmop)
	c:RegisterEffect(e4)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9980862,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,9980862)
	e6:SetCondition(c9980862.thcon)
	e6:SetTarget(c9980862.thtg)
	e6:SetOperation(c9980862.thop)
	c:RegisterEffect(e6)
end
function c9980862.eqlimit(e,c)
	return c:IsSetCard(0x6bc2)
end
function c9980862.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bc2)
end
function c9980862.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9980862.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980862.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9980862.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c9980862.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c9980862.value(e,c)
	return c:GetBaseAttack()*2
end
function c9980862.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function c9980862.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=eg:GetFirst():GetBattleTarget()
	e:SetLabelObject(bc)
	if chk==0 then return bc:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,bc) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,bc:GetControler(),LOCATION_GRAVE)
end
function c9980862.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsAbleToRemove() then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,bc)
		if g:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		sg:AddCard(bc)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c9980862.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9980862.thfilter(c)
	return c:IsSetCard(0x6bc2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9980862.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980862.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9980862.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980862.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
