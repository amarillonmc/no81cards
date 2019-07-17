--梦之钢琴师
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400005.initial_effect(c)
	--summon limit
	yume.AddYumeSummonLimit(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c71400005.target1)
	e1:SetCountLimit(1,71400005)
	e1:SetOperation(c71400005.operation1)
	c:RegisterEffect(e1)
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c71400005.condition2)
	e2:SetTarget(c71400005.target2)
	e2:SetOperation(c71400005.operation2)
	c:RegisterEffect(e2)
end
function c71400005.filter1(c,e,sp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c71400005.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400005.filter1,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c71400005.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71400005.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c71400005.condition2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c71400005.filter2(c)
	return c:IsSetCard(0x714)
end
function c71400005.synfilter(c,mg)
	return c:IsSetCard(0x714) and c:IsSynchroSummonable(nil,mg)
end
function c71400005.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c71400005.filter2,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c71400005.synfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71400005.operation2(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c71400005.filter2,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(c71400005.synfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end