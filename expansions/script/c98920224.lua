--薰风的生灵 玛拉
function c98920224.initial_effect(c)
	--syr ss
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920224,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920224)
	e1:SetCost(c98920224.descost)
	e1:SetTarget(c98920224.destg)
	e1:SetOperation(c98920224.desop)
	c:RegisterEffect(e1) 
	--ss2
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920224,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,98920224)
	e1:SetCost(c98920224.cost)
	e1:SetTarget(c98920224.target)
	e1:SetOperation(c98920224.operation)
	c:RegisterEffect(e1)
end
function c98920224.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98920224.spfilter(c,e,tp)
	return c:IsSetCard(0x10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920224.fselect(g,tp)
	return Duel.IsExistingMatchingCard(c98920224.synfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function c98920224.synfilter(c,g)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsSynchroSummonable(nil,g)
end
function c98920224.chkfilter(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c98920224.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=2 then return false end
		local cg=Duel.GetMatchingGroup(c98920224.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg==0 then return false end
		local g=Duel.GetMatchingGroup(c98920224.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return g:CheckSubGroup(c98920224.fselect,2,2,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c98920224.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanSpecialSummonCount(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		local cg=Duel.GetMatchingGroup(c98920224.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg>0 then
			local g=Duel.GetMatchingGroup(c98920224.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectSubGroup(tp,c98920224.fselect,false,2,2,tp)
			if sg then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				local og=Duel.GetOperatedGroup()
				Duel.AdjustAll()
				if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
				local tg=Duel.GetMatchingGroup(c98920224.synfilter,tp,LOCATION_EXTRA,0,nil,og)
				if og:GetCount()==sg:GetCount() and tg:GetCount()>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local rg=tg:Select(tp,1,1,nil)
					Duel.SynchroSummon(tp,rg:GetFirst(),nil,og)
				end
			end
		end
	end
end
function c98920224.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsDiscardable()
end
function c98920224.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c98920224.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,c98920224.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c98920224.filter(c,e,tp)
	return not c:IsCode(98920224) and c:IsSetCard(0x10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_DEFENSE)
end
function c98920224.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920224.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920224.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920224.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_DEFENSE)~=0 and tc:IsFacedown() then
		Duel.ConfirmCards(1-tp,tc)
	end
end