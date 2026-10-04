--薪焰之理
function c43990971.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)--TIMING_END_PHASE
	e1:SetDescription(aux.Stringid(43990971,0))
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c43990971.settg)
	e1:SetOperation(c43990971.setop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990971,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,43990971)
	--e2:SetCost(c43990971.spcost)
	e2:SetTarget(c43990971.sptg)
	e2:SetOperation(c43990971.spop)
	c:RegisterEffect(e2)
end
function c43990971.setfilter(c)
	return aux.IsCodeListed(c,43990987) and c:GetType()==TYPE_TRAP and c:IsFaceupEx() and c:IsSSetable()
end
function c43990971.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990971.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c43990971.setop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(c43990971.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,1,1,nil)
		Duel.SSet(tp,sg)
		for tc in aux.Next(sg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(43990971,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function c43990971.cfilter(c,e,tp)
	local code,race,attr,lv=c:GetCode(),c:GetRace(),c:GetAttribute(),c:GetLevel()
	return (c:IsControler(tp) or c:IsFaceup()) and (c:GetOriginalType()&TYPE_TRAP)~=0 and c:IsLevelAbove(0) and Duel.IsExistingMatchingCard(c43990971.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,code,race,attr,lv) and Duel.GetMZoneCount(tp,c)>0
end
function c43990971.spfilter(c,e,tp,code,race,attr,lv)
	return c:IsRace(race) and c:IsAttribute(attr) and c:IsLevel(lv) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43990971.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c43990971.cfilter,1,nil,e,tp) and e:IsCostChecked() end
	local tc=Duel.SelectReleaseGroup(tp,c43990971.cfilter,1,1,nil,e,tp):GetFirst()
	e:SetLabel(tc:GetCode(),tc:GetRace(),tc:GetAttribute(),tc:GetLevel())
	Duel.Release(tc,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c43990971.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c43990971.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
