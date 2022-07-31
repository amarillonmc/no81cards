local m=31400036
local cm=_G["c"..m]
cm.name="圣刻神龙-末日龙"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,99)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.econ)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.econ)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.getlrfilter(c)
  if c:IsLevelAbove(0) then
	return c:GetLevel()
  end
  if c:IsRankAbove(0) then
	return c:GetRank()
  end
end
function cm.mfilter(c,xyzc)
	return c:IsRace(RACE_DRAGON) and (c:IsLevelAbove(0) or c:IsRankAbove(0))
end
function cm.xyzcheck(g)
	return g:GetClassCount(cm.getlrfilter)==1
end
function cm.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,1-tp,LOCATION_MZONE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	Duel.Release(Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,0,LOCATION_MZONE,1,1,nil),REASON_EFFECT)
end