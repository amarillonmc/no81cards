--巨石遗物·图列尔
function c98920060.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c98920060.lcheck)
	c:EnableReviveLimit()
--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,98920060)
	e1:SetTarget(c98920060.rtg)
	e1:SetCondition(c98920060.rscon)
	e1:SetOperation(c98920060.rop)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c98920060.thcon)
	e2:SetTarget(c98920060.thtg)
	e2:SetOperation(c98920060.thop)
	c:RegisterEffect(e2)
end
function c98920060.lcheck(g)
	return g:IsExists(Card.IsType,1,nil,TYPE_RITUAL)
end
function c98920060.mfilter(c,e)
	return c:IsFaceup() and c:GetLevel()>0 and not c:IsImmuneToEffect(e) and c:IsReleasable()
end
function c98920060.mfilter2(c,tc,tp)
	if c:IsControler(tp) and c:GetSequence()<5 or Duel.GetMZoneCount(tp)>0 then return c:GetRitualLevel(tc) else return 0 end
end
function c98920060.filter(c,e,tp,m)
	if bit.band(c:GetOriginalType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or not c:IsSetCard(0x138) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil,tp)
	end
	return mg:CheckWithSumGreater(c98920060.mfilter2,c:GetLevel(),c,tp)
end
function c98920060.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c98920060.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
		local mg2=Duel.GetMatchingGroup(c98920060.mfilter,tp,0,LOCATION_MZONE,nil,e)
		mg1:Merge(mg2)
		return Duel.IsExistingMatchingCard(c98920060.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c98920060.rop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mg1=Duel.GetRitualMaterial(tp)
	mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
	local mg2=Duel.GetMatchingGroup(c98920060.mfilter,tp,0,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c98920060.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1)
	local tc=tg:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectWithSumGreater(tp,c98920060.mfilter2,tc:GetLevel(),tc,tp)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c98920060.descfilter(c,lg)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsSummonType(SUMMON_TYPE_RITUAL) and lg:IsContains(c)
end
function c98920060.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c98920060.descfilter,1,nil,lg)
end
function c98920060.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98920060.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end