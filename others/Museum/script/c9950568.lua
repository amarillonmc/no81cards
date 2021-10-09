--fete Last Episode
function c9950568.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c9950568.target)
	e1:SetOperation(c9950568.activate)
	c:RegisterEffect(e1)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,9950568)
	e1:SetCost(aux.bfgcost)
	e1:SetCondition(c9950568.condition)
	e1:SetTarget(c9950568.target2)
	e1:SetOperation(c9950568.activate2)
	c:RegisterEffect(e1)
end
function c9950568.filter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950568.xyzfilter(c,mg)
	return c:IsSetCard(0xba5) and c:IsXyzSummonable(mg,2,2)
end
function c9950568.mfilter1(c,mg,exg)
	return mg:IsExists(c9950568.mfilter2,1,c,c,exg)
end
function c9950568.mfilter2(c,mc,exg)
	return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))
end
function c9950568.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c9950568.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(c9950568.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and exg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c9950568.mfilter1,1,1,nil,mg,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c9950568.mfilter2,1,1,tc1,tc1,exg)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
end
function c9950568.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950568.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c9950568.filter2,nil,e,tp)
	if g:GetCount()<2 then return end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local xyzg=Duel.GetMatchingGroup(c9950568.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
function c9950568.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c9950568.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttacker()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and at:IsOnField() and at:GetAttack()>=Duel.GetLP(tp)
		end
end
function c9950568.filter(c,e,tp)
	return c:IsSetCard(0x6ba6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950568.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() and Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
		if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
		if loc==0 then return end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9950568.filter),tp,loc,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9950568,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

