--植实兽 皮切尔
function c22348208.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348208,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22348208)
	e1:SetTarget(c22348208.sptg)
	e1:SetOperation(c22348208.spop1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348208,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,22348208)
	e2:SetCondition(c22348208.spcon)
	e2:SetTarget(c22348208.sptg)
	e2:SetOperation(c22348208.spop2)
	c:RegisterEffect(e2)
	--Search Card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348208,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c22348208.sccon)
	--e3:SetCost(c22348208.sccost)
	e3:SetTarget(c22348208.sctg)
	e3:SetOperation(c22348208.scop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCountLimit(1,22350205)
	e4:SetDescription(aux.Stringid(22348205,2))
	e4:SetCondition(c22348208.sccon2)
	c:RegisterEffect(e4)
	c22348208.discard_effect=e3
	--count
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_TO_HAND)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCondition(c22348208.checkcon)
		e4:SetOperation(c22348208.checkop)
		c:RegisterEffect(e4)
end
function c22348208.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c22348208.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(22348208,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22348208,5))
end
function c22348208.tgfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:Is(LOCATION_ONFIELD))
end
function c22348208.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348208.tgfilter,1,nil)
end
function c22348208.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22348208.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(22348208,2)) then
		Duel.BreakEffect()
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end
function c22348208.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tg=ag:Filter(Card.IsRelateToEffect,nil,re)
	local g=tg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local gg=g:Filter(Card.IsAbleToHand,nil)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and g:GetCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(22348208,3)) then
		Duel.BreakEffect()
		Duel.SendtoHand(gg,tp,REASON_EFFECT)
	end
end
function c22348208.sccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(22348208)>0
end
function c22348208.sccon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22348205)
end
function c22348208.spfilter(c,e,tp)
	return c:IsLevelAbove(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x707)
end
function c22348208.fselect(g,tp)
	return g:GetClassCount(Card.GetLevel)==1
		and Duel.IsExistingMatchingCard(c22348208.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g,2,2)
end
function c22348208.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,2,2)
end
function c22348208.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c22348208.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and g:CheckSubGroup(c22348208.fselect,2,2,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function c22348208.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22348208.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c22348208.fselect,false,2,2,tp)
	if sg and sg:GetCount()==2 then
		local tc1=sg:GetFirst()
		local tc2=sg:GetNext()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1)
		local e2=e1:Clone()
		tc2:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e3)
		local e4=e3:Clone()
		tc2:RegisterEffect(e4)
		Duel.SpecialSummonComplete()
		Duel.AdjustAll()
		if sg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
		local xyzg=Duel.GetMatchingGroup(c22348208.xyzfilter,tp,LOCATION_EXTRA,0,nil,sg,2,2)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,sg)
		end
	end
end


