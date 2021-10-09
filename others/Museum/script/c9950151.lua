--幽谷之渊
function c9950151.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9950151.target)
	e1:SetOperation(c9950151.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(c9950151.eqlimit)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c9950151.efilter)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e5:SetValue(c9950151.valcon)
	e5:SetCountLimit(1)
	c:RegisterEffect(e5)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9950151,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCode(EVENT_BATTLED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c9950151.descon)
	e4:SetTarget(c9950151.destg)
	e4:SetOperation(c9950151.desop)
	c:RegisterEffect(e4)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950151,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9950151)
	e2:SetCost(c9950151.thcost)
	e2:SetTarget(c9950151.thtg)
	e2:SetOperation(c9950151.thop)
	c:RegisterEffect(e2)
end
function c9950151.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5)
end
function c9950151.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9950151.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950151.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9950151.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9950151.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c9950151.eqlimit(e,c)
	return c:IsSetCard(0xba5) and c:GetControler()==e:GetHandler():GetControler()
end
function c9950151.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c9950151.valcon(e,re,r,rp)
	return r==REASON_BATTLE
end
function c9950151.descon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if ec~=Duel.GetAttacker() and ec~=Duel.GetAttackTarget() then return false end
	local tc=ec:GetBattleTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsFaceup() 
end
function c9950151.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function c9950151.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c9950151.thfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9950151.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950151.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950151.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9950151.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9950151.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
