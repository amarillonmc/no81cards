--辉煌之代行者 许珀里翁
local s,id,o=GetID()
function c98920787.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920787,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920787)
	e1:SetCost(c98920787.spcost)
	e1:SetTarget(c98920787.sptg)
	e1:SetOperation(c98920787.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+o)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)
end
function c98920787.spfilter(c,tp)
	return c:IsReleasable(REASON_COST) and (c:IsControler(tp) or Duel.IsEnvironment(56433456)) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c98920787.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c98920787.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	Duel.Release(tc,REASON_COST)
end
function c98920787.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c98920787.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x44) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and not c:IsCode(id) and not (c:IsAttack(0) and c:IsDefense(0))
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		local upval=tc:GetBaseAttack()
		if tc:GetBaseAttack()<tc:GetBaseDefense() then
			upval=tc:GetBaseDefense()
		end
		Duel.SetLP(tp,Duel.GetLP(tp)-upval)
	end
end