--律法塔魂的魔王 法墨特
function c79100340.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,79100260,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3a11),1,true,true)
	aux.EnableChangeCode(c,79100260,LOCATION_MZONE+LOCATION_GRAVE)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79100340,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c79100340.descon)
	e1:SetTarget(c79100340.destg)
	e1:SetOperation(c79100340.desop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79100340,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCost(c79100340.descost)
	e2:SetTarget(c79100340.destg)
	e2:SetOperation(c79100340.desop)
	c:RegisterEffect(e2)
end
function c79100340.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c79100340.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c79100340.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
	end
end
function c79100340.rfilter(c,tp)
	return c:IsType(TYPE_FUSION) and (c:IsControler(tp) or c:IsFaceup()) and Duel.GetMZoneCount(tp,c)>0
end
function c79100340.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c79100340.rfilter,1,nil,tp) end
	local rg=Duel.SelectReleaseGroup(tp,c79100340.rfilter,1,1,nil,tp)
	Duel.Release(rg,REASON_COST)
end