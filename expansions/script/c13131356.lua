--魔玩具·剪刀狐
local m=13131356
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,30068120,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa9),1,true,true)
	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION
)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(cm.costcon)
	e3:SetValue(cm.actlimit)
	c:RegisterEffect(e3)

	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(cm.reptg)
	c:RegisterEffect(e7)
end
function cm.cfilter(c)
	return c:IsSetCard(0xc3) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function cm.costcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.actlimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_HAND
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT) and c:GetAttack()~=0 end
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	local preatk=c:GetAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-1000)
	c:RegisterEffect(e1)
		return true
	else return false end
end