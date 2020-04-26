--桃绯之舞
function c9910504.initial_effect(c)
	aux.AddCodeList(c,9910501,9910503)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9910504.target)
	e1:SetOperation(c9910504.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910504)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910504.thtg)
	e2:SetOperation(c9910504.thop)
	c:RegisterEffect(e2)
end
function c9910504.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>c:GetBaseAttack()
end
function c9910504.atkfilter2(c,e)
	return c:IsFaceup() and c:GetAttack()>c:GetBaseAttack() and not c:IsImmuneToEffect(e)
		and not c:IsHasEffect(EFFECT_REVERSE_UPDATE)
end
function c9910504.filter(c)
	return c:IsSetCard(0xa950)
end
function c9910504.atkdiff(c)
	return math.abs(c:GetBaseAttack()-c:GetAttack())
end
function c9910504.filter2(c,e,tp,atkg)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0xa950) or Duel.GetLocationCount(tp,LOCATION_MZONE)==0
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	return atkg:CheckWithSumGreater(c9910504.atkdiff,c:GetLevel()*100,1,99)
end
function c9910504.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local atkg=Duel.GetMatchingGroup(c9910504.atkfilter,tp,LOCATION_MZONE,0,nil)
		local b1=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c9910504.filter,e,tp,mg,nil,Card.GetLevel,"Greater")
		local b2=Duel.IsExistingMatchingCard(c9910504.filter2,tp,LOCATION_HAND,0,1,nil,e,tp,atkg)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9910504.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local atkg=Duel.GetMatchingGroup(c9910504.atkfilter2,tp,LOCATION_MZONE,0,nil,e)
	local g1=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,nil,c9910504.filter,e,tp,mg,nil,Card.GetLevel,"Greater")
	local g2=Duel.GetMatchingGroup(c9910504.filter2,tp,LOCATION_HAND,0,nil,e,tp,atkg)
	g1:Merge(g2)
	if g1:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	if not g2:IsContains(tc) or Duel.SelectOption(tp,aux.Stringid(9910504,0),aux.Stringid(9910504,1))==0 then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local atkg2=atkg:SelectWithSumGreater(tp,c9910504.atkdiff,tc:GetLevel()*100,1,99,nil)
		if atkg2:GetCount()==0 then return end
		local sc=atkg2:GetFirst()
		while sc do
			local diff=math.abs(sc:GetBaseAttack()-sc:GetAttack())
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-diff)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			sc=atkg2:GetNext()
		end
		tc:SetMaterial(nil)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c9910504.thfilter(c)
	return c:IsCode(9910501,9910503) and c:IsAbleToHand()
end
function c9910504.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910504.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910504.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910504.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
