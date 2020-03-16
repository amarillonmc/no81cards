--天兵天翼
function c40008656.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c40008656.target)
	e1:SetOperation(c40008656.operation)
	c:RegisterEffect(e1)
	--Actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c40008656.aclimit)
	e3:SetCondition(c40008656.actcon)
	c:RegisterEffect(e3)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c40008656.eqlimit)
	c:RegisterEffect(e2)  
	--double atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetCondition(c40008656.adcon)
	e4:SetValue(c40008656.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_BASE_DEFENSE)
	e5:SetValue(c40008656.defval)
	c:RegisterEffect(e5) 
	--salvage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(40008656,0))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,40008656)
	e6:SetCost(c40008656.thcost)
	e6:SetTarget(c40008656.thtg)
	e6:SetOperation(c40008656.thop)
	c:RegisterEffect(e6) 
end
function c40008656.eqlimit(e,c)
	return c:IsSetCard(0xf11)
end
function c40008656.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf11)
end
function c40008656.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c40008656.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40008656.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c40008656.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c40008656.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c40008656.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:GetHandler():IsImmuneToEffect(e)
end
function c40008656.actcon(e)
	local tc=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc
end
function c40008656.adcon(e)
	return Duel.GetTurnPlayer()~=tp
end
function c40008656.atkval(e,c)
	return c:GetBaseAttack()*2
end
function c40008656.defval(e,c)
	return c:GetBaseDefense()*2
end
function c40008656.cfilter(c)
	return c:IsSetCard(0xf11) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c40008656.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c40008656.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c40008656.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c40008656.thfilter(c)
	return c:IsSetCard(0xf11) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c40008656.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c40008656.thfilter,tp,LOCATION_GRAVE,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function c40008656.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c40008656.thfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	if tg1:GetCount()==2 then
		Duel.SendtoHand(tg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg1)
	end
end

