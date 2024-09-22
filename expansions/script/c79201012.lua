--星钢卫星
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,s.synfilter,aux.NonTuner(s.synfilter),1)
	c:EnableReviveLimit()
	--td
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--re
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.remcost)
	e2:SetTarget(s.remtg)
	e2:SetOperation(s.remop)
	c:RegisterEffect(e2)
end
function s.synfilter(c,e,tp)
	return c:IsSetCard(0x10e3) and c:IsType(TYPE_MONSTER)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x10e3) and c:IsType(TYPE_MONSTER)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cl=c:GetLevel()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and c:IsAbleToDeck() and g:CheckWithSumEqual(Card.GetLevel,cl,1,99)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,g,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cl=c:GetLevel()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil):SelectWithSumEqual(tp,Card.GetLevel,cl,1,99)
		if g:GetCount()==1 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		elseif g:GetCount()>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function s.remcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SendtoDeck(e:GetHandler(),tp,SEQ_DECKSHUFFLE,REASON_COST)  
end
function s.remfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x10e3)
end
function s.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function s.remop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if g then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end