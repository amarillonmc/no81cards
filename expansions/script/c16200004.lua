--DD警告
function c16200004.initial_effect(c)
	aux.AddCodeList(c,16200003)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--link summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16200004,2))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,16200004)
	e3:SetCost(c16200004.scost)
	e3:SetTarget(c16200004.stg)
	e3:SetOperation(c16200004.sop)
	c:RegisterEffect(e3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16200004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16200004+100)
	e1:SetCondition(c16200004.condition)
	e1:SetTarget(c16200004.target)
	e1:SetOperation(c16200004.operation)
	c:RegisterEffect(e1)
	--count
	if not c16200004.global_check then
		c16200004.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c16200004.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge3,0)
	end
	--sum limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c16200004.splimit)
	c:RegisterEffect(e5)
end
function c16200004.splimit(e,c,tp,sumtp,sumpos)
	return c:GetOriginalCode()~=16200003
end
function c16200004.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),16200004,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c16200004.cfilter(c,tp)
	return c:IsCode(16200003)
		and c:IsControler(tp) and c:IsReleasable()
end
function c16200004.cfilter1(c)
	return not c:IsCode(16200003)
end
function c16200004.filter(c)
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function c16200004.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c16200004.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c16200004.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c16200004.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16200004.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c16200004.stg1(e,tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c16200004.filter,tp,LOCATION_HAND,0,1,nil) end
end
function c16200004.sop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_RELEASE_SUM)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c16200004.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
function c16200004.relfilter(c)
	return c:IsAbleToRemove()
end
function c16200004.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,16200004)>=5 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c16200004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(c16200004.relfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroupCount(c16200004.relfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,16200003,0,0x4011,0,0,1,RACE_WARRIOR,ATTRIBUTE_DARK) 
		and g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,g2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,g,0,0)
end
function c16200004.operation(e,tp,eg,ep,ev,re,r,rp)
	local g3=Duel.GetMatchingGroup(c16200004.relfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g3:GetCount()>0 and Duel.Remove(g3,POS_FACEDOWN,REASON_EFFECT) then
		local og=Duel.GetOperatedGroup()
		local c=e:GetHandler()
			if og:GetCount()==0 then return end
			local num=og:GetCount()
			if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
				and Duel.IsPlayerCanSpecialSummonMonster(tp,16200003,0,0x4011,0,0,1,RACE_WARRIOR,ATTRIBUTE_DARK) then
				Duel.BreakEffect()
				local ft=num
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
				ft=math.min(ft,(Duel.GetLocationCount(1-tp,LOCATION_MZONE)))
				if ft<=0 then return end
				repeat
				local token=Duel.CreateToken(tp,16200003)
				Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
				ft=ft-1
				until ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(16200004,1))
				Duel.SpecialSummonComplete()
				Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		end
	end
end