--
local m=115011
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	 --xyz summon
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,2)  
	c:EnableReviveLimit()
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.condition)
	e3:SetCost(cm.drcost)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
end
function cm.mfilter(c,xyzc)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
--e3
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetHandler():GetAttack()
	return atk~=e:GetHandler():GetBaseAttack()
end
function cm.cfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToGraveAsCost()
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and c:GetFlagEffect(m)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
	local dam=Duel.GetMatchingGroup(nil,0,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,dam,0,1-tp,LOCATION_ONFIELD)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dam=Duel.GetMatchingGroup(nil,0,0,LOCATION_ONFIELD,nil)
	Duel.SendtoGrave(dam,REASON_EFFECT)
end