--方界防阵
function c93138458.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c93138458.condition)
	e1:SetTarget(c93138458.target)
	e1:SetOperation(c93138458.activate)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_ATTACK)
	e2:SetCost(c93138458.cost)
	e2:SetTarget(c93138458.sptg)
	e2:SetOperation(c93138458.spop)
	c:RegisterEffect(e2)
end
function c93138458.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c93138458.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c93138458.filter(c,tc,e,tp)
	return c:IsCode(tc:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c93138458.selfilter(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c93138458.filter,tp,0x13,0,1,nil,c,e,tp) and c:IsSetCard(0xe3)
end
function c93138458.activate(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.NegateAttack() and Duel.IsExistingMatchingCard(c93138458.selfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(93138457,0)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return false end
	Duel.BreakEffect()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local gg=Group.CreateGroup()
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=Duel.SelectMatchingCard(tp,c93138458.selfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.HintSelection(sg)
	if ft>0 and sg:GetCount()>0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c93138458.filter),tp,0x13,0,nil,sg:GetFirst(),e,tp)
		if g:GetCount()>0 then
			if g:GetCount()<=ft then
				c93138458.sp(g,tp,POS_FACEUP)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local fg=g:Select(tp,ft,ft,nil)
				c93138458.sp(fg,tp,POS_FACEUP)
				g:Sub(fg)
				gg:Merge(g)
			end
		end
	end
	Duel.SpecialSummonComplete()
	Duel.SendtoGrave(gg,REASON_EFFECT)
end
function c93138458.sp(g,tp,pos)
	local sc=g:GetFirst()
	while sc do
		Duel.SpecialSummonStep(sc,0,tp,tp,true,false,pos)
		sc=g:GetNext()
	end
end
function c93138458.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c93138458.spfilter(c,e,sp)
	return c:IsCode(15610297) and c:IsCanBeSpecialSummoned(e,0,sp,false,false,POS_FACEUP_DEFENSE)
end
function c93138458.thfilter(c)
	return c:IsSetCard(0xe3) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c93138458.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c93138458.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c93138458.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c93138458.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 or tg:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)==3 then
		local g=Duel.GetMatchingGroup(c93138458.thfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(93138458,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			g=g:Select(tp,1,1,nil)
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c93138458.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c93138458.splimit(e,c)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end