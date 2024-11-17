--人理之诗 此处无存的幻马
function c22021170.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,22021170)
	e1:SetTarget(c22021170.target)
	e1:SetOperation(c22021170.activate)
	c:RegisterEffect(e1)
	--synchro effect
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e4:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,22021170)
	e4:SetCondition(c22021170.sccon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c22021170.sctg)
	e4:SetOperation(c22021170.scop)
	c:RegisterEffect(e4)
end
function c22021170.filter(c)
	return c:IsFaceup() and c:IsAttackBelow(2000)
end
function c22021170.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22021170.filter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.GetMatchingGroup(c22021170.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c22021170.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22021170.filter,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.SelectOption(tp,aux.Stringid(22021170,0)) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22021171,0,0x4011,2000,2000,4,RACE_WINDBEAST,ATTRIBUTE_WIND) then return end
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,22021171)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
		Duel.SelectOption(tp,aux.Stringid(22021170,1))
	end
end
function c22021170.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c22021170.mfilter(c)
	return (c:IsCode(22021160) or c:IsCode(22021171)) and c:IsType(TYPE_MONSTER)
end
function c22021170.mfilter2(c)
	return c:IsHasEffect(EFFECT_HAND_SYNCHRO) and c:IsType(TYPE_MONSTER)
end
function c22021170.cfilter(c,syn)
	local b1=true
	if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		b1=Duel.CheckTunerMaterial(syn,c,nil,c22021170.mfilter,1,99)
	end
	return b1 and syn:IsSynchroSummonable(c)
end
function c22021170.spfilter(c,mg)
	return mg:IsExists(c22021170.cfilter,1,nil,c)
end
function c22021170.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c22021170.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c22021170.mfilter,tp,LOCATION_MZONE,0,nil)
		local exg=Duel.GetMatchingGroup(c22021170.mfilter2,tp,LOCATION_MZONE,0,nil)
		mg:Merge(exg)
		return Duel.IsExistingMatchingCard(c22021170.spfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22021170.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c22021170.mfilter,tp,LOCATION_MZONE,0,nil)
	local exg=Duel.GetMatchingGroup(c22021170.mfilter2,tp,LOCATION_MZONE,0,nil)
	mg:Merge(exg)
	local g=Duel.GetMatchingGroup(c22021170.spfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:FilterSelect(tp,c22021170.cfilter,1,1,nil,sg:GetFirst())
		Duel.SynchroSummon(tp,sg:GetFirst(),tg:GetFirst())
	end
end
