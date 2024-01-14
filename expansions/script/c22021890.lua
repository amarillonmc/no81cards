--人理之诗 银之键
function c22021890.initial_effect(c)


	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c22021890.spcost)
	e1:SetTarget(c22021890.target)
	e1:SetOperation(c22021890.activate)
	c:RegisterEffect(e1)
end
function c22021890.cfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c22021890.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(REASON_COST,tp,c22021890.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(REASON_COST,tp,c22021890.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c22021890.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22021890,0,TYPE_NORMAL,0,0,9,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22021890.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22021890,0,TYPE_NORMAL,0,0,9,RACE_FIEND,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end