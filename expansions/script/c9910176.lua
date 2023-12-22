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
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910177)
	e2:SetCondition(c9910176.discon)
	e2:SetCost(c9910176.discost)
	e2:SetTarget(c9910176.distg)
	e2:SetOperation(c9910176.disop)
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
	return c:IsRace(RACE_WARRIOR) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsReleasableByEffect()
		and Duel.GetMZoneCount(tp,c)>0
end
function c9910176.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.CheckReleaseGroupEx(tp,c9910176.cfilter,1,nil,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9910178,0,0x4011,1000,1000,3,RACE_WARRIOR,ATTRIBUTE_WIND)
		and Duel.SelectYesNo(tp,aux.Stringid(9910176,0)) then
		Duel.BreakEffect()
		local g=Duel.SelectReleaseGroupEx(tp,c9910176.cfilter,1,1,nil,tp)
		if g:GetCount()>0 and Duel.Release(g,REASON_EFFECT)~=0 then
			token=Duel.CreateToken(tp,9910178)
			if token then Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP) end
		end
	end
end
function c9910176.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsChainNegatable(ev)
end
function c9910176.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,0,2,2,nil)
	Duel.Release(g,REASON_COST)
end
function c9910176.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9910176.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and not rc:IsLocation(LOCATION_REMOVED) and rc:IsAbleToRemove()
		and (Duel.GetCustomActivityCount(9910176,tp,ACTIVITY_CHAIN)~=0
		or Duel.GetCustomActivityCount(9910176,1-tp,ACTIVITY_CHAIN)~=0)
		and Duel.SelectYesNo(tp,aux.Stringid(9910176,1)) then
		Duel.BreakEffect()
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
end
