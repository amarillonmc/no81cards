-- 幼王夺还
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,47320301,47320352)
	s.activate(c)
end
function s.activate(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return (c:IsCode(47320352) or aux.IsCodeListed(c,47320352)) and c:IsAbleToGraveAsCost()
end
function s.thspfilter(c,e,tp)
	return aux.IsCodeListed(c,47320301) and c:IsAttack(100) 
		and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
end
function s.synfilter(c)
	return aux.IsCodeListed(c,47320301)
end
function s.syncheck(g,tp,syncard)
	return g:IsExists(s.synfilter,1,nil) and syncard:IsSynchroSummonable(nil,g,#g-1,#g-1) and aux.SynMixHandCheck(g,tp,syncard)
end
function s.spfilter(c,tp,mg)
	return mg:CheckSubGroup(s.syncheck,2,#mg,tp,c)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thspfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		local tc=g:GetFirst()
		local b1=tc:IsAbleToHand()
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,1190,1152)
		elseif b1 then
			op=0
		else
			op=1
		end
		local ct=0
		if op==0 then
			ct=Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			ct=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		if ct<=0 then return end
		local mg=Duel.GetSynchroMaterial(tp)
		if mg:IsExists(Card.GetHandSynchro,1,nil) then
			local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
			if mg2:GetCount()>0 then mg:Merge(mg2) end
		end
		if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,tp,mg) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			local syg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,tp,mg)
			if syg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				local sc=sg:GetFirst()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local tg=mg:SelectSubGroup(tp,s.syncheck,false,2,#mg,tp,sc)
				Duel.SynchroSummon(tp,sc,nil,tg,#tg-1,#tg-1)
			end
		end
	end
end
