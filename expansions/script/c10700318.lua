--内核的泛式升华
function c10700318.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10700318+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10700318.cost)
	e1:SetOperation(c10700318.activate)
	c:RegisterEffect(e1)  
	--protection
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79086452,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,0x11e0)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(aux.exccon)
	e2:SetCountLimit(1,10700319)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10700318.sptg)
	e2:SetOperation(c10700318.spop)
	c:RegisterEffect(e2)  
end
function c10700318.ngfilter1(c)
	return c:IsSetCard(0xf39) and c:IsAbleToGraveAsCost()
end
function c10700318.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700318.ngfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10700318.ngfilter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10700318.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c10700318.efftg)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10700318.efftg(e,c)
	return c:IsSetCard(0xf39) and c:IsType(TYPE_MONSTER)
end
function c10700318.filter(c,e,tp)
	return c:IsSetCard(0xf39) and c:IsLevel(1) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10700318.xyzfilter(c,mg,ct)
	return c:IsXyzSummonable(mg,2,ct)
end
function c10700318.fgoal(sg,exg)
	return aux.dncheck(sg) and exg:IsExists(Card.IsXyzSummonable,1,nil,sg,#sg,#sg)
end
function c10700318.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c10700318.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local exg=Duel.GetMatchingGroup(c10700318.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg,ct)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ct>1 and mg:CheckSubGroup(c10700318.fgoal,2,ct,exg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:SelectSubGroup(tp,c10700318.fgoal,false,2,ct,exg)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,sg1:GetCount(),0,0)
end
function c10700318.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10700318.spfilter(c,mg,ct)
	return c:IsXyzSummonable(mg,ct,ct)
end
function c10700318.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c10700318.filter2,nil,e,tp)
	local ct=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local xyzg=Duel.GetMatchingGroup(c10700318.spfilter,tp,LOCATION_EXTRA,0,nil,g,ct)
	if ct>=2 and xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end