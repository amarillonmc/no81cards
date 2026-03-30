--肆世坏的恢复
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,56099748)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.lcheck(g)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function s.spfilter(c,e,tp,zone)
	return (c:IsSetCard(0x17a) or c:IsCode(56099748)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function s.clfilter(c)
	return c:GetSequence()>4 and c:IsType(TYPE_LINK)
end
function s.getzone(tp)
	local g=Duel.GetMatchingGroup(s.clfilter,tp,LOCATION_MZONE,0,nil)
	local zone=0
	for lc in aux.Next(g) do
		zone=zone|lc:GetLinkedZone()
	end
	return zone&0x1f
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,s.getzone(tp))
	if chk==0 then
		local zone=s.getzone(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
		return ft>2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:CheckSubGroup(s.lcheck,3,3)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,s.lcheck,false,3,3)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,3,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=s.getzone(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or ft<3 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not (c:IsRace(RACE_BEASTWARRIOR) and c:IsType(TYPE_LINK)) and c:IsLocation(LOCATION_EXTRA)
end
