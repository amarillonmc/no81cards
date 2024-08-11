--念力跃冲者
function c49811325.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49811325,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,49811325)
	e1:SetCost(c49811325.spcost)
	e1:SetTarget(c49811325.sptg)
	e1:SetOperation(c49811325.spop)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811325,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_PAY_LPCOST)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,49811326)
	e2:SetCondition(c49811325.tgcon)
	e2:SetCost(c49811325.tgcost)
	e2:SetTarget(c49811325.tgtg)
	e2:SetOperation(c49811325.tgop)
	c:RegisterEffect(e2)
end
function c49811325.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>1 end
	Duel.Release(c,REASON_COST)
end
function c49811325.filter(c,e,tp)
	return c:IsCode(52430902) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811325.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c49811325.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,49811326,0,TYPES_TOKEN_MONSTER,100,100,2,RACE_PSYCHO,ATTRIBUTE_EARTH,POS_FACEUP)end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c49811325.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811325.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,49811326,0,TYPES_TOKEN_MONSTER,100,100,2,RACE_PSYCHO,ATTRIBUTE_EARTH,POS_FACEUP) then return end
		local token=Duel.CreateToken(tp,49811326)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c49811325.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c49811325.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(49811325)==0 end
	c:RegisterFlagEffect(49811325,RESET_CHAIN,0,1)
end
function c49811325.tgfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToGrave()
end
function c49811325.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811325.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c49811325.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c49811325.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
	end
end