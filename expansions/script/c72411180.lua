--马纳历亚龙人公主·古蕾娅
function c72411180.initial_effect(c)
	aux.AddCodeList(c,72411020,72411030)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c72411180.lcheck)
	c:EnableReviveLimit()   
  --[[as spellcaster
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(0xff)
	e0:SetValue(RACE_SPELLCASTER)
	c:RegisterEffect(e0)]]
	--des
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER,TIMING_MSET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c72411180.cost2)
	e2:SetTarget(c72411180.target2)
	e2:SetOperation(c72411180.operation2)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,72411180)
	e3:SetCost(c72411180.cost3)
	e3:SetTarget(c72411180.target3)
	e3:SetOperation(c72411180.operation3)
	c:RegisterEffect(e3)
end
function c72411180.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x5729)
end
--e2
function c72411180.costfilter(c)
	return c:IsCode(72411020) and c:IsDiscardable(REASON_COST)
end
function c72411180.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72411180.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c72411180.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c72411180.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c72411180.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		 Duel.Destroy(g,REASON_EFFECT)
end
--e3
function c72411180.cfilter(c,tp)
	return c:IsCode(72411030) and c:IsDiscardable(REASON_COST) 
end
function c72411180.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72411180.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c72411180.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c72411180.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c72411180.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
