--秽惧黄昏 霍斯迪格
function c22060380.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),5,2,c22060380.ovfilter,aux.Stringid(22060380,0),2,c22060380.xyzop)
	c:EnableReviveLimit()
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c22060380.ctcon)
	e1:SetOperation(c22060380.ctop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22060380,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,22060380)
	e2:SetCost(c22060380.cost)
	e2:SetTarget(c22060380.destg)
	e2:SetOperation(c22060380.desop)
	c:RegisterEffect(e2)

	if not c22060380.global_check then
		c22060380.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c22060380.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c22060380.checkop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		Duel.RegisterFlagEffect(ep,22060380,RESET_PHASE+PHASE_END,0,1)
	end
end
function c22060380.ovfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_XYZ) and c:IsSetCard(0xff5)
end
function c22060380.xyzop(e,tp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.GetFlagEffect(1-tp,22060380)~=0 and Duel.GetFlagEffect(tp,22060351)==0 end
	Duel.RegisterFlagEffect(tp,22060351,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c22060380.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_EFFECT)~=0
end
function c22060380.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22060380)
	local c=e:GetHandler()
	--buff stats
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(200)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c22060380.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22060380.filter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and not c:IsSetCard(0xff5)
end
function c22060380.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22060380.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c22060380.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*200)
end
function c22060380.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c22060380.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c:GetAttack())
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*200,REASON_EFFECT)
	end
end
