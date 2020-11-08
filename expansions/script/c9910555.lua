--甜心机仆的欢笑
function c9910555.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910555)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910555.target)
	e1:SetOperation(c9910555.activate)
	c:RegisterEffect(e1)
	--synchro/xyz summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,9910556)
	e2:SetTarget(c9910555.sptg)
	e2:SetOperation(c9910555.spop)
	c:RegisterEffect(e2)
end
function c9910555.spfilter(c,e,tp)
	return c:IsSetCard(0x3951) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910555.filter1(c,id)
	return c:GetTurnID()==id and not c:IsReason(REASON_RETURN)
end
function c9910555.filter2(c,id)
	return c:GetTurnID()<id and not c:IsReason(REASON_RETURN)
end
function c9910555.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910555.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9910555.fselect(g,id)
	return g:FilterCount(c9910555.filter1,nil,id)<2 and g:FilterCount(c9910555.filter2,nil,id)<2
		and g:FilterCount(Card.IsReason,nil,REASON_RETURN)<2
end
function c9910555.activate(e,tp,eg,ep,ev,re,r,rp)
	local id=Duel.GetTurnCount()
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),3)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910555.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c9910555.fselect,false,1,ft,id)
	if sg and sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9910555.xyzfilter(c)
	return c:IsRankBelow(2) and c:IsXyzSummonable(nil)
end
function c9910555.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(Card.IsLevelBelow,tp,LOCATION_MZONE,0,nil,2)
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg) then
			sel=sel+1
		end
		if Duel.IsExistingMatchingCard(c9910555.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) then
			sel=sel+2
		end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910555,0))
		sel=Duel.SelectOption(tp,aux.Stringid(9910555,1),aux.Stringid(9910555,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(9910555,1))
	else
		Duel.SelectOption(tp,aux.Stringid(9910555,2))
	end
	e:SetLabel(sel)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910555.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsLevelBelow,tp,LOCATION_MZONE,0,nil,2)
	local sel=e:GetLabel()
	if sel==1 then
		local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
		end
	else
		local g=Duel.GetMatchingGroup(c9910555.xyzfilter,tp,LOCATION_EXTRA,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,sg:GetFirst(),nil)
		end
	end
end
