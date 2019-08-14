--鲁格·贝奥武夫-兽化模式
function c1007014.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x20f),10,2)
	c:EnableReviveLimit()
	--des
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(1007014,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c1007014.con)
	e1:SetCost(c1007014.cost)
	e1:SetTarget(c1007014.dddtg)
	e1:SetOperation(c1007014.dddop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1007014,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(c1007014.retg)
	e2:SetOperation(c1007014.reop)
	c:RegisterEffect(e2)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetCondition(c1007014.immcon)
	e6:SetValue(c1007014.efilter)
	c:RegisterEffect(e6)
	--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetValue(function(e,re)
		return e:GetHandler():GetOverlayCount()>0 and e:GetOwnerPlayer()~=re:GetOwnerPlayer()
			and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
	end)
	c:RegisterEffect(e7)
end
function c1007014.filter1(c)
	return c:IsCode(1007013)
end
function c1007014.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c1007014.filter1,1,nil)
end
function c1007014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1007014.filter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsDestructable()
end
function c1007014.dddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1007014.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c1007014.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c1007014.dddop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1007014.filter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c1007014.immcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c1007014.efilter(e,te)
	if te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() then
		local lv=e:GetHandler():GetRank()
		local ec=te:GetOwner()
		if ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<=lv
		else
			return ec:GetOriginalLevel()<=lv
		end
	end
	return false
end
function c1007014.refilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsFaceup() and c:IsAbleToGrave()
end
function c1007014.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1007014.refilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c1007014.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1007014.refilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 and g:GetFirst():IsFaceup() and g:GetFirst():GetAttack()>0 then
	   Duel.SendtoGrave(g,REASON_EFFECT)
	   Duel.Recover(tp,g:GetFirst():GetAttack(),REASON_EFFECT)
	end
end
