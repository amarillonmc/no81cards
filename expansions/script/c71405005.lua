--棱镜世界的赤之一片-艾佩鲁休
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),aux.NonTuner(nil),1)
	--banish from grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--currently e2 cannot be implemented
	--banish from field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+100000)
	e3:SetCondition(s.con3)
	e3:SetTarget(s.tg3)
	e3:SetCost(s.cost1)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetType(EFFECT_TYPE_QUICK_O)
	e3a:SetCode(EVENT_FREE_CHAIN)
	e3a:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3a:SetCondition(s.con3a)
	c:RegisterEffect(e3a)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c:GetMaterial():GetCount()==0 or Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	if c:GetMaterial():GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function s.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0x716) and c:IsType(TYPE_MONSTER)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function s.con3a(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end