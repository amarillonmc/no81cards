--刻兽使·阿尼姆
function c40008544.initial_effect(c)
	c:SetUniqueOnField(1,0,40008544)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c40008544.cost)
	e1:SetTarget(c40008544.target)
	e1:SetOperation(c40008544.operation)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c40008544.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--change atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40008544,0))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(c40008544.atkcon)
	e4:SetTarget(c40008544.damtg)
	e4:SetOperation(c40008544.damop)
	c:RegisterEffect(e4)
	--equip limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EQUIP_LIMIT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(c40008544.eqlimit)
	c:RegisterEffect(e5)
	--to hand
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(40008544,1))
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e8:SetCode(EVENT_TO_GRAVE)
	e8:SetCountLimit(1,40008544)
	e8:SetCondition(c40008544.thcon)
	e8:SetTarget(c40008544.tdtg)
	e8:SetOperation(c40008544.tdop)
	c:RegisterEffect(e8)	 
end
function c40008544.eqlimit(e,c)
	return c:IsSetCard(0xf17)
end
function c40008544.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
	local ec=e:GetHandler():GetEquipTarget()
	if not ec then return false end
	Duel.SetOperationInfo(CATEGORY_RECOVER,0,nil,0,ec:GetControler(),ec:GetLevel()*100)
end
function c40008544.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ec=c:GetEquipTarget()
	Duel.Recover(ec:GetControler(),ec:GetLevel()*100,REASON_EFFECT)
end
function c40008544.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetHandler():GetEquipTarget()
	return tg and eg:IsContains(tg) and Duel.GetAttacker()==tg or Duel.GetAttackTarget()==tg
end
function c40008544.atkval(e,c)
	return c:GetLevel()*100
end
function c40008544.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c40008544.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf17)
end
function c40008544.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c40008544.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40008544.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c40008544.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c40008544.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c40008544.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_LOST_TARGET)
		and not e:GetHandler():GetPreviousEquipTarget():IsLocation(LOCATION_MZONE)
end
function c40008544.thfilter(c)
	return c:IsSetCard(0xf17) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c40008544.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c40008544.thfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToHand()
		and Duel.IsExistingTarget(c40008544.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c40008544.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c40008544.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g=Group.FromCards(c,tc)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end