--播种者·倒吊
function c9911609.initial_effect(c)
	--spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911609)
	e1:SetTarget(c9911609.sptg)
	e1:SetOperation(c9911609.spop)
	c:RegisterEffect(e1)
	--to hand/spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9911610)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9911609.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9911609.thtg)
	e2:SetOperation(c9911609.thop)
	c:RegisterEffect(e2)
	if not c9911609.global_check then
		c9911609.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c9911609.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911609.checkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c9911609.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c9911609.checkfilter,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),9911609,RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
end
function c9911609.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911609.fselect(g,c)
	return g:IsContains(c)
end
function c9911609.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if #g~=5 then return end
	Duel.SortDecktop(tp,tp,5)
	local ct=g:FilterCount(Card.IsType,nil,TYPE_TUNER)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local sg=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,nil,e,0,tp,false,false)
	if ct>0 and ft>0 and #sg>0 and sg:IsContains(c) and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:SelectSubGroup(tp,c9911609.fselect,false,1,math.min(ct,ft),c)
		if #tg>0 then
			for tc in aux.Next(tg) do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				Duel.HintSelection(Group.FromCards(tc))
				local sel=0
				if tc:IsLevelBelow(ct) then
					sel=Duel.SelectOption(tp,aux.Stringid(9911609,0))
				else
					sel=Duel.SelectOption(tp,aux.Stringid(9911609,0),aux.Stringid(9911609,1))
				end
				local lv=ct
				if sel==1 then
					lv=lv*-1
				end
				local e1=Effect.CreateEffect(c)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(lv)
				tc:RegisterEffect(e1)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c9911609.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911609)>2
end
function c9911609.thfilter(c,e,tp)
	if not (c:IsType(TYPE_TUNER) and c:IsLevelBelow(3)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c9911609.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911609.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c9911609.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c9911609.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
