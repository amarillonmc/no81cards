--崩坏神格 人偶装束
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,75646000)
	c:SetUniqueOnField(1,0,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(s.eqlimit)
	c:RegisterEffect(e2)
	--def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(1000)
	e4:SetCondition(s.hdcon)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetCondition(s.immcon)
	e5:SetValue(s.efilter)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_SZONE,0)
	e5:SetCondition(s.immcon)
	e6:SetTarget(s.imtg)
	e6:SetValue(s.efilter)
	c:RegisterEffect(e6)
	--halve damage
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CHANGE_DAMAGE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(1,0)
	e7:SetCondition(s.hdcon)
	e7:SetValue(s.val)
	c:RegisterEffect(e7)
	--search
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,1))
	e8:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e8:SetCountLimit(3,75646150)
	e8:SetCost(s.thcost)
	e8:SetTarget(s.thtg)
	e8:SetOperation(s.thop)
	c:RegisterEffect(e8)
end
function s.eqlimit(e,c)
	return c:IsSetCard(0x52c0)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x52c0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function s.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=6000
end
function s.val(e,re,dam,r,rp,rc)
	return dam/2
end
function s.immcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>=2000
end
function s.imtg(e,c)
	return c:GetEquipTarget()==(e:GetHandler():GetEquipTarget())
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
		and not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
function s.cfilter(c)
	return aux.IsCodeListed(c,75646000) and c:IsAbleToRemoveAsCost()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.thfilter(c)
	return c:IsSetCard(0x2c0) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end