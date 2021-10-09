--风都复仇者eternal·大道克己
function c9980771.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WARRIOR),3,3,c9980771.lcheck)
	c:EnableReviveLimit()
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980771,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c9980771.descon)
	e2:SetTarget(c9980771.destg)
	e2:SetOperation(c9980771.desop)
	c:RegisterEffect(e2)
	--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9980771,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1)
	e4:SetCondition(c9980771.condition)
	e4:SetTarget(c9980771.target)
	e4:SetOperation(c9980771.operation)
	c:RegisterEffect(e4)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980771,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c9980771.rmtg)
	e3:SetOperation(c9980771.rmop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980771.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980771.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980771,0))
end
function c9980771.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3bc2)
end
function c9980771.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
function c9980771.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9980771.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,aux.ExceptThisCard(e))
	Duel.Destroy(g,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980771,3))
end
function c9980771.condition(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetHandler():GetAttack()
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and c:IsAttackBelow(atk) and Duel.IsChainNegatable(ev)
end
function c9980771.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9980771.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980771,3))
	end
end
function c9980771.filter(c)
	return c:IsSetCard(0x9bc1) and c:IsAbleToRemove()
end
function c9980771.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c9980771.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) 
			and not Duel.IsExistingMatchingCard(c9980771.chkfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	end
	local g=Duel.GetMatchingGroup(c9980771.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*300)
end
function c9980771.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9980771.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
		Duel.Damage(1-tp,ct*300,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980771,3))
	end
end
