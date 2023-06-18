--神树勇者 犬吠埼树
function c9910322.initial_effect(c)
	--hand synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910322)
	e1:SetValue(c9910322.matval)
	c:RegisterEffect(e1)
	--Spsummon or Equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,9910323)
	e2:SetCondition(c9910322.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910322.sptg)
	e2:SetOperation(c9910322.spop)
	c:RegisterEffect(e2)
end
function c9910322.matval(e,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_PLANT)
end
function c9910322.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9910322.opfilter(c,e,tp,spchk,eqchk)
	return c:IsSetCard(0x5956) and c:IsType(TYPE_MONSTER)
		and (spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false) or eqchk and c:CheckUniqueOnField(tp) and not c:IsForbidden())
end
function c9910322.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3956)
end
function c9910322.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local eqchk=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(c9910322.cfilter,tp,LOCATION_MZONE,0,1,nil)
		return Duel.IsExistingMatchingCard(c9910322.opfilter,tp,LOCATION_HAND,0,1,nil,e,tp,spchk,eqchk)
	end
end
function c9910322.spop(e,tp,eg,ep,ev,re,r,rp)
	local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local eqchk=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9910322.cfilter,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c9910322.opfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,spchk,eqchk)
	local tc=g:GetFirst()
	if tc then
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and spchk
			and (not eqchk or Duel.SelectOption(tp,1152,aux.Stringid(9910322,0))==0) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sg=Duel.SelectMatchingCard(tp,c9910322.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
			local sc=sg:GetFirst()
			if sc then
				if Duel.Equip(tp,tc,sc) then
					--equip limit
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_EQUIP_LIMIT)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetLabelObject(sc)
					e1:SetValue(c9910322.eqlimit)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
		end
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetCondition(c9910322.tdcon)
	e2:SetOperation(c9910322.tdop)
	e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e2,tp)
end
function c9910322.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c9910322.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()>e:GetLabel()
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
end
function c9910322.gselect(g)
	return g:GetClassCount(Card.GetControler)==#g
end
function c9910322.tdop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	Duel.Hint(HINT_CARD,0,9910322)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,c9910322.gselect,false,1,2)
	if sg then
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
