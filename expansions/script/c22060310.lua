--闪光No.107 银河眼平行龙
function c22060310.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),9,3,c22060310.ovfilter,aux.Stringid(22060310,0))
	c:EnableReviveLimit()
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22060310,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c22060310.atkcost)
	e1:SetCondition(c22060310.condition)
	e1:SetOperation(c22060310.activate)
	c:RegisterEffect(e1)
	--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22060310,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCost(c22060310.atkcost)
	e2:SetTarget(c22060310.damtg)
	e2:SetOperation(c22060310.atkop)
	c:RegisterEffect(e2)
end
aux.xyz_number[22060310]=107
function c22060310.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107b) and c:IsType(TYPE_XYZ) and c:IsRank(8)
end
function c22060310.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22060310.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c22060310.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_FIELD)
		  e1:SetCode(EFFECT_DISABLE)
		  e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		  e1:SetTarget(c22060310.distg)
		  e1:SetReset(RESET_PHASE+PHASE_END)
		  Duel.RegisterEffect(e1,tp)
		  local e2=Effect.CreateEffect(c)
		  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		  e2:SetCode(EVENT_CHAIN_SOLVING)
		  e2:SetCondition(c22060310.discon)
		  e2:SetOperation(c22060310.disop)
		  e2:SetLabel(rc:GetOriginalCode())
		  e2:SetReset(RESET_PHASE+PHASE_END)
		  Duel.RegisterEffect(e2,tp)
end
function c22060310.distg(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function c22060310.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return (code1==code or code2==code)
end
function c22060310.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c22060310.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=e:GetHandler():GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c22060310.atkop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetHandler():GetAttack()
	Duel.NegateAttack()
	Duel.Damage(1-tp,atk,REASON_EFFECT)
end