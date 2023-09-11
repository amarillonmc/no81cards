--超级量子召唤 阿尔方连锁
function c98920067.initial_effect(c)
--active1 XyzSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920067,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98920067+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98920067.target)
	e1:SetOperation(c98920067.activate)
	c:RegisterEffect(e1)
--active2 LinkSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920067,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,98920067+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c98920067.target1)
	e2:SetOperation(c98920067.activate1)
	c:RegisterEffect(e2)
end
function c98920067.filter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920067.xyzfilter(c,mg,ct)
	return c:IsXyzSummonable(mg,2,2)
end
function c98920067.fgoal(sg,exg)
	return sg:IsExists(Card.IsSetCard,1,nil,0xdc) and exg:IsExists(Card.IsXyzSummonable,1,nil,sg,2,2)
end
function c98920067.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c98920067.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<2 then return end
	local exg=Duel.GetMatchingGroup(c98920067.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg,ct)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ct>1 and mg:CheckSubGroup(c98920067.fgoal,2,2,exg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:SelectSubGroup(tp,c98920067.fgoal,false,2,2,exg)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,sg1:GetCount(),0,0)
end
function c98920067.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920067.spfilter(c,mg,ct)
	return c:IsXyzSummonable(mg,ct,ct)
end
function c98920067.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c98920067.filter2,nil,e,tp)
	local ct=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	Duel.AdjustAll() 
	if g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<ct then return end
	local xyzg=Duel.GetMatchingGroup(c98920067.spfilter,tp,LOCATION_EXTRA,0,nil,g,ct)
	if ct>=2 and xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end  
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c98920067.splimit)
	e2:SetLabel(xyzg:GetFirst():GetCode())
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp) 
end
function c98920067.splimit(e,c)
	return not (c:IsRace(RACE_MACHINE) or c:IsCode(e:GetLabel())) and c:IsLocation(LOCATION_EXTRA)
end
function c98920067.ffilter(c,e,tp)
	return c:IsSetCard(0x10dc) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920067.lkfilter(c,g)
	return c:IsLinkSummonable(g,nil,g:GetCount(),g:GetCount())
end
function c98920067.fgoal1(sg,exg)
	return Duel.IsExistingMatchingCard(c98920067.lkfilter,tp,LOCATION_EXTRA,0,1,nil,sg) and aux.dncheck(sg)
end
function c98920067.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c98920067.ffilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local exg=Duel.GetMatchingGroup(c98920067.lkfilter,tp,LOCATION_EXTRA,0,nil,mg,ct)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ct>1 and mg:CheckSubGroup(c98920067.fgoal1,2,ct,exg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:SelectSubGroup(tp,c98920067.fgoal1,false,2,ct,exg)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,sg1:GetCount(),0,0)
end
function c98920067.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920067.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c98920067.filter2,nil,e,tp)
	local ct=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local og=Duel.GetOperatedGroup()
	Duel.AdjustAll()   
	if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<ct then return end
	local lkg=Duel.GetMatchingGroup(c98920067.lkfilter,tp,LOCATION_EXTRA,0,nil,og)
	if og:GetCount()>=2 and lkg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=lkg:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,rg:GetFirst(),og,nil,#og,#og)
	end   
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetLabel(lkg:GetFirst():GetCode())
	e2:SetTarget(c98920067.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end