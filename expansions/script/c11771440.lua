--征伐的死君
function c11771440.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c11771440.mfilter1,aux.NonTuner(c11771440.mfilter2),1)
	c:EnableReviveLimit()
	--indestructible
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(1)
	e1:SetTarget(c11771440.indfilter)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e11)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11771440)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c11771440.tgcost)
	e2:SetTarget(c11771440.tgtg)
	e2:SetOperation(c11771440.tgop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,11771440+1)
	e3:SetCondition(c11771440.spcon)
	e3:SetTarget(c11771440.sptg)
	e3:SetOperation(c11771440.spop)
	c:RegisterEffect(e3)
end
function c11771440.mfilter1(c)
	return c:GetOriginalRace()&(RACE_ZOMBIE)>0
end
function c11771440.mfilter2(c)
	return c:GetOriginalRace()&(RACE_ZOMBIE)>0 and c:IsSynchroType(TYPE_SYNCHRO)
end
function c11771440.indfilter(e,c)
	return c:GetOriginalRace()&(RACE_ZOMBIE)>0
end
function c11771440.rfilter(c,tp)
	return c:IsRace(RACE_ZOMBIE) and (c:IsControler(tp) or c:IsFaceup())
end
function c11771440.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c11771440.rfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c11771440.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c11771440.tgfilter(c)
	return c:GetOriginalRace()&(RACE_ZOMBIE)==0 and c:IsAbleToGrave()
end
function c11771440.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c11771440.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c11771440.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11771440.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c11771440.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c11771440.rmfilter(c)
	return c:IsAbleToRemove() and c:GetOriginalRace()&(RACE_ZOMBIE)>0
end
function c11771440.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c11771440.rmfilter,tp,LOCATION_GRAVE,0,3,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,LOCATION_GRAVE)
end
function c11771440.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11771440.rmfilter),tp,LOCATION_GRAVE,0,3,3,aux.ExceptThisCard(e))
	if #g==3 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==3 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end