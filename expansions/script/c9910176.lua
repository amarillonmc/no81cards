--匪魔追缉者 挫锐射手
function c9910176.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910176)
	e1:SetCondition(c9910176.spcon)
	e1:SetTarget(c9910176.sptg)
	e1:SetOperation(c9910176.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910177)
	e2:SetCondition(c9910176.descon)
	e2:SetCost(c9910176.descost)
	e2:SetTarget(c9910176.destg)
	e2:SetOperation(c9910176.desop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(9910176,ACTIVITY_CHAIN,c9910176.chainfilter)
end
function c9910176.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_TRAP)
end
function c9910176.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function c9910176.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910176.cfilter(c,tp)
	return c:IsRace(RACE_WARRIOR) and Duel.GetMZoneCount(tp,c)>0 and c:IsReleasableByEffect()
end
function c9910176.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.CheckReleaseGroupEx(tp,c9910176.cfilter,1,c,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9910178,0,0x4011,1000,1000,3,RACE_WARRIOR,ATTRIBUTE_WIND)
		and Duel.SelectYesNo(tp,aux.Stringid(9910176,0)) then
		Duel.BreakEffect()
		local g=Duel.SelectReleaseGroupEx(tp,c9910176.cfilter,1,1,c,tp)
		if g:GetCount()>0 and Duel.Release(g,REASON_EFFECT)~=0 then
			token=Duel.CreateToken(tp,9910178)
			if token then Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP) end
		end
	end
end
function c9910176.descon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c9910176.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_TOKEN) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_TOKEN)
	Duel.Release(g,REASON_COST)
end
function c9910176.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and rc:IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
end
function c9910176.desop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and Duel.Destroy(rc,REASON_EFFECT)~=0
		and (Duel.GetCustomActivityCount(9910176,tp,ACTIVITY_CHAIN)~=0
		or Duel.GetCustomActivityCount(9910176,1-tp,ACTIVITY_CHAIN)~=0)
		and Duel.IsChainNegatable(ev) and Duel.SelectYesNo(tp,aux.Stringid(9910176,1)) then
		Duel.BreakEffect()
		Duel.NegateActivation(ev)
	end
end
