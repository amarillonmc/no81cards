--AK-雾林的石棉
function c82568079.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--negate
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_NEGATE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c82568079.negcon)
	e7:SetCost(c82568079.negcost)
	e7:SetTarget(c82568079.negtg)
	e7:SetOperation(c82568079.negop)
	c:RegisterEffect(e7)
	--plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c82568079.pcon)
	e2:SetTarget(c82568079.splimit)
	c:RegisterEffect(e2)
	--battle target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e6:SetValue(c82568079.atlimit)
	c:RegisterEffect(e6)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	
end
function c82568079.ngfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x825)
end
function c82568079.negcon(e,tp,eg,ep,ev,re,r,rp)
	if  re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c82568079.ngfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
	else return false
end
end
function c82568079.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568079.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c82568079.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev) 
end
function c82568079.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c82568079.pcon(e,c,tp,sumtp,sumpos)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x5825)==0
end
function c82568079.atlimit(e,c)
	return c:IsFaceup() and not (c:GetBaseAttack() <= c:GetBaseDefense()) and c:IsSetCard(0x825)
end