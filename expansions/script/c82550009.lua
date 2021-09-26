--烈冥钢战-大志雷马
function c82550009.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),11,2)
	c:EnableReviveLimit()
	--Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c82550009.attval)
	c:RegisterEffect(e1)
	--Handes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82550009,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,82550009)
	e2:SetCondition(c82550009.condition2)
	e2:SetTarget(c82550009.target2)
	e2:SetOperation(c82550009.activate2)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82550009,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c82550009.descost)
	e3:SetTarget(c82550009.destg)
	e3:SetOperation(c82550009.desop)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c82550009.efilter2)
	c:RegisterEffect(e4)
end
function c82550009.cfilter(c,tp)
	if c:IsRace(RACE_MACHINE) and c:IsAbleToRemoveAsCost() and c:IsFaceup() then 
	local cc=c
	return Duel.IsExistingMatchingCard(c82550009.desfilter,tp,0,LOCATION_MZONE,1,cc,c:GetAttribute())
	end
end
function c82550009.desfilter(c,ac)
	return c:IsAttribute(ac) and c:IsFaceup() 
end
function c82550009.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
	Duel.IsExistingMatchingCard(c82550009.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c82550009.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,1,1,e:GetHandler(),tp)
	e:SetLabel(g:GetFirst():GetAttribute())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c82550009.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ac=e:GetLabel()
	local g=Duel.GetMatchingGroup(c82550009.desfilter,tp,0,LOCATION_MZONE,nil,ac)
	e:SetLabel(ac)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c82550009.desop(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	local g=Duel.GetMatchingGroup(c82550009.desfilter,tp,0,LOCATION_MZONE,nil,ac)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c82550009.rmlimit)
	e1:SetLabel(ac)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c82550009.rmlimit(e,c,tp,r,re)
	return c:IsAttribute(e:GetLabel()) and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsCode(82550009) and r==REASON_COST
end

function c82550009.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and rp==1-tp and re:GetOwner():GetAttribute()&e:GetOwner():GetAttribute()~=0 and
	e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_EFFECT) 
end
function c82550009.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND,nil)
	if chk==0 then return g:GetCount()>0
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,LOCATION_HAND)
end
function c82550009.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND,nil)
	if re:GetHandler():IsRelateToEffect(re) and g:GetCount()>0 and e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST) then
	Duel.Destroy(g,REASON_EFFECT)
   end
end
function c82550009.attval(e,c)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local wg=og:Filter(c82550009.effilter,nil)
	local wbc=wg:GetFirst()
	local att=0
	while wbc do
		att=att|wbc:GetAttribute()
		wbc=wg:GetNext()
	end
	return att
end
function c82550009.effilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c82550009.efilter2(e,te)
	return te:GetOwner()~=e:GetOwner()
		and te:IsActiveType(TYPE_MONSTER) and 
		 te:GetOwner():GetAttribute()&e:GetOwner():GetAttribute()~=0
end