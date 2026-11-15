local s,id=GetID()
function s.initial_effect(c)
	--①
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--②
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(s.gycost)
	e2:SetTarget(s.gytg)
	e2:SetOperation(s.gyop)
	c:RegisterEffect(e2)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.deckmat(c)
	return c:IsSetCard(0xf5) and c:IsType(TYPE_MONSTER)
end
function s.fusfilter1(c,e,tp,mg)
	return c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(mg,nil,tp)
end
function s.fusfilter2(c,e,tp,mg)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xf5)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(mg,nil,tp)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xf5) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sscheck(e,tp)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	for tc in aux.Next(g) do
		local lv=tc:GetLevel()
		if g:IsExists(function(c2,lv2) return c2:GetLevel()==lv2 end,1,tc,lv) then
			return true
		end
	end
	return false
end
function s.frcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function s.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function s.fuscheck(e,tp)
	local mg=Duel.GetFusionMaterial(tp)
	local dg=Duel.GetMatchingGroup(s.deckmat,tp,LOCATION_DECK,0,nil)
	if Duel.IsExistingMatchingCard(s.fusfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) then return true end
	if dg:GetCount()==0 then return false end
	aux.FCheckAdditional=s.frcheck
	aux.GCheckAdditional=s.gcheck
	local res=Duel.IsExistingMatchingCard(s.fusfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg+dg)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	return res
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=s.fuscheck(e,tp)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonCount(tp,2) and s.sscheck(e,tp)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2})
	e:SetLabel(op)
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local mg=Duel.GetFusionMaterial(tp)
		local dg=Duel.GetMatchingGroup(s.deckmat,tp,LOCATION_DECK,0,nil)
		local g1=Duel.GetMatchingGroup(s.fusfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
		local g2=Duel.GetMatchingGroup(s.fusfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg+dg)
		local sg=g1:Clone()
		for tc in aux.Next(g2) do
			if not sg:IsContains(tc) then sg:AddCard(tc) end
		end
		if sg:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		if not tc then return end
		local mgt=mg
		local exmat=false
		if tc:IsSetCard(0xf5) and dg:GetCount()>0 then
			mgt=mg+dg
			exmat=true
		end
		if exmat then
			aux.FCheckAdditional=s.frcheck
			aux.GCheckAdditional=s.gcheck
		end
		local mat=Duel.SelectFusionMaterial(tp,tc,mgt,nil,tp)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not mat then return end
		tc:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	elseif e:GetLabel()==2 then
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local c1=g1:GetFirst()
		if not c1 then return end
		local lv=c1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,function(c) return s.spfilter(c,e,tp) and c:GetLevel()==lv end,tp,LOCATION_DECK,0,1,1,c1)
		local c2=g2:GetFirst()
		if not c2 then return end
		local sg=Group.FromCards(c1,c2)
		local tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		Duel.AdjustAll()
		if sg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
		local xg=Duel.GetMatchingGroup(function(c)
			return c:IsType(TYPE_XYZ) and c:IsXyzSummonable(sg,2,2)
		end,tp,LOCATION_EXTRA,0,nil)
		if xg:GetCount()>0 and Duel.GetLocationCountFromEx(tp,tp,sg,TYPE_XYZ)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xg:Select(tp,1,1,nil):GetFirst()
			if xyz then Duel.XyzSummon(tp,xyz,sg) end
		end
	end
end
function s.gycost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function s.gyfilter(c)
	return c:IsSetCard(0xf5) and c:IsAbleToDeck()
end
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.gyfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE)
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.gyfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
end
