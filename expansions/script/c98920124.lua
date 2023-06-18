--天威龙-反自觉蟠龙
function c98920124.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WYRM),2,4)
	--can not be attack target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(c98920124.atcon)
	e1:SetValue(c98920124.attg)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c98920124.attg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920124,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98920124)
	e3:SetCondition(c98920124.negcon)
	e3:SetCost(c98920124.negcost)
	e3:SetTarget(c98920124.negtg)
	e3:SetOperation(c98920124.negop)
	c:RegisterEffect(e3)
end
function c98920124.atfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_EFFECT)
end
function c98920124.atcon(e)
	return Duel.IsExistingMatchingCard(c98920124.atfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c98920124.attg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c98920124.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c98920124.costfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT) and (c:IsControler(tp) or c:IsFaceup())
end
function c98920124.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c98920124.costfilter,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c98920124.costfilter,1,1,nil,tp)
	e:SetLabelObject(sg:GetFirst())
	Duel.Release(sg,REASON_COST)
end
function c98920124.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabelObject():IsRace(RACE_WYRM) then
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	else
		e:SetProperty(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98920124.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end