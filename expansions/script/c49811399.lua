--バグキング・スーパーエクスプローダー
local s,id=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,3,2,s.ovfilter,aux.Stringid(id,0),99)
	c:EnableReviveLimit()
	--activate in hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.handcost)
	e1:SetTarget(s.acttg)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetValue(id)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(id)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(s.discon)
	e4:SetTarget(s.disable)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
end
function s.ovfilter(c,e,tp,xyzc)
	return c:IsFaceup() and c:IsLevel(3) and not (c:GetOwner()==xyzc:GetOwner())
end
function s.acttg(e,c)
	return c:GetType()==TYPE_TRAP
end
function s.similarfilter(c,tp)
	return c:IsHasEffect(id) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function s.handcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	local g=Duel.GetMatchingGroup(s.similarfilter,tp,LOCATION_MZONE,0,c,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
		local tc=(g+c):Select(tp,1,1,nil):GetFirst()
		tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	else
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,ev,REASON_EFFECT)
end
function s.confilter(c,tp)
	return c:GetType()&TYPE_XYZ~=0
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.confilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)
	return g:GetClassCount(Card.GetCode)>=2
end
function s.disable(e,c)
	local value=math.abs(Duel.GetLP(0)-Duel.GetLP(1))
	return (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) and c:IsFaceup() and c:GetAttack()<=value
end