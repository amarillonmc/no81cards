--银河眼光子虹龙
local m=22348410
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3,c22348410.ovfilter,aux.Stringid(22348410,0))
	c:EnableReviveLimit()
	--xyzlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(c22348410.actcon)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348410,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c22348410.atkcost)
	e3:SetTarget(c22348410.atktg)
	e3:SetOperation(c22348410.atkop)
	c:RegisterEffect(e3)
end
function c22348410.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107b) and c:IsType(TYPE_XYZ)
end
function c22348410.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c22348410.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22348410.atkfilter(c)
	return c:IsFaceup() and not c:IsAttack(c:GetBaseAttack())
end
function c22348410.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348410.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c22348410.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c22348410.atkfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local atk=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
