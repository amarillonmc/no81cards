--深海猎人流星一击
function c29048675.initial_effect(c)
	--NegateEffect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29048675,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,29048675+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c29048675.condition)
	e1:SetTarget(c29048675.target)
	e1:SetOperation(c29048675.activate)
	c:RegisterEffect(e1)
	--NegateSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCountLimit(1,29048675+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c29048675.condition1)
	e2:SetTarget(c29048675.target1)
	e2:SetOperation(c29048675.activate1)
	c:RegisterEffect(e2)
	--Activate in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c29048675.handcon)
	c:RegisterEffect(e3)
	--NegateEffect "Arknights-Specter the Unchained":ACTIVATE FROM GRAVE
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29048675,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,29063234)
	e4:SetCost(c29048675.cost)
	e4:SetCondition(c29048675.condition2)
	e4:SetTarget(c29048675.target)
	e4:SetOperation(c29048675.activate2(c29048675.activate))
	e4:SetLabelObject(e1)
	c:RegisterEffect(e4)
	--NegateSummon "Arknights-Specter the Unchained":ACTIVATE FROM GRAVE
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,29063234)
	e5:SetCost(c29048675.cost)
	e5:SetCondition(c29048675.condition3)
	e5:SetTarget(c29048675.target1)
	e5:SetOperation(c29048675.activate2(c29048675.activate1))
	e5:SetLabelObject(e2)
	c:RegisterEffect(e5)
end
--e1 NegateEffect
function c29048675.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FISH) and c:IsSetCard(0x87af)
end
function c29048675.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29048675.cfilter,tp,LOCATION_MZONE,0,nil)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
		and g:GetClassCount(Card.GetCode)>=3
end
function c29048675.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c29048675.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
--e2 NegateSummon
function c29048675.condition1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29048675.cfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>=3 and aux.NegateSummonCondition()
end
function c29048675.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c29048675.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end
--e3 Activate in hand
function c29048675.actfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c29048675.handcon(e)
	return Duel.IsExistingMatchingCard(c29048675.actfilter,0,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c29048675.actfilter,1,LOCATION_MZONE,0,1,nil)
end
--e4 NegateEffect "Arknights-Specter the Unchained":ACTIVATE FROM GRAVE
function c29048675.condition2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29048675.cfilter,tp,LOCATION_MZONE,0,nil)
	return Duel.IsPlayerAffectedByEffect(tp,29063234) and e:GetLabelObject():CheckCountLimit(tp) and rp~=tp and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
		and g:GetClassCount(Card.GetCode)>=3
end
function c29048675.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
end
function c29048675.activate2(op)
	return function(e,tp,eg,ep,ev,re,r,rp)
				op(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				c:CancelToGrave()
				Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
			end
end
--e5 NegateSummon "Arknights-Specter the Unchained":ACTIVATE FROM GRAVE
function c29048675.condition3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29048675.cfilter,tp,LOCATION_MZONE,0,nil)
	return Duel.IsPlayerAffectedByEffect(tp,29063234) and e:GetLabelObject():CheckCountLimit(tp) and g:GetClassCount(Card.GetCode)>=3 and aux.NegateSummonCondition()
end