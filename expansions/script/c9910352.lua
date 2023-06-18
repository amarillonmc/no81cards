--神树精灵 先代化身
function c9910352.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910352)
	e1:SetCondition(c9910352.spcon)
	e1:SetTarget(c9910352.sptg)
	e1:SetOperation(c9910352.spop)
	c:RegisterEffect(e1)
	--ban
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910353)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCondition(c9910352.bancon)
	e2:SetTarget(c9910352.bantg)
	e2:SetOperation(c9910352.banop)
	c:RegisterEffect(e2)
end
function c9910352.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(9910307,PLAYER_ALL,LOCATION_FZONE)
end
function c9910352.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910352.sumfilter(c)
	return c:IsSetCard(0x3956) and c:IsSummonable(true,nil)
end
function c9910352.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if Duel.IsExistingMatchingCard(c9910352.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910352,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910352.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function c9910352.bancon(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return (tn==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2))
		or (tn==1-tp and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c9910352.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_PLANT)
end
function c9910352.opfilter(c,tp)
	local b1=c:IsAbleToGrave()
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c9910352.cfilter,tp,LOCATION_MZONE,0,1,c)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
	return c:IsSetCard(0x5956) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and (b1 or b2)
end
function c9910352.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910352.opfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c9910352.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c9910352.opfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToGrave()
		local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(c9910352.cfilter,tp,LOCATION_MZONE,0,1,tc)
			and tc:CheckUniqueOnField(tp) and not tc:IsForbidden()
		if b1 and (not b2 or Duel.SelectOption(tp,1191,aux.Stringid(9910352,1))==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sg=Duel.SelectMatchingCard(tp,c9910352.cfilter,tp,LOCATION_MZONE,0,1,1,tc)
			local sc=sg:GetFirst()
			if sc then
				if Duel.Equip(tp,tc,sc) then
					--equip limit
					local e0=Effect.CreateEffect(c)
					e0:SetType(EFFECT_TYPE_SINGLE)
					e0:SetCode(EFFECT_EQUIP_LIMIT)
					e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e0:SetLabelObject(sc)
					e0:SetValue(c9910352.eqlimit)
					e0:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e0)
				end
			end
		end
	end
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c9910352.distg1)
	e1:SetLabel(ac)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c9910352.discon)
	e2:SetOperation(c9910352.disop)
	e2:SetLabel(ac)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c9910352.distg2)
	e3:SetLabel(ac)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c9910352.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c9910352.distg1(e,c)
	local ac=e:GetLabel()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsOriginalCodeRule(ac)
	else
		return c:IsOriginalCodeRule(ac) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
	end
end
function c9910352.distg2(e,c)
	local ac=e:GetLabel()
	return c:IsOriginalCodeRule(ac)
end
function c9910352.discon(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	return re:GetHandler():IsOriginalCodeRule(ac)
end
function c9910352.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
