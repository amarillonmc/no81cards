--宇宙忍术
function c9950803.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c9950803.cost)
	e1:SetTarget(c9950803.target)
	e1:SetOperation(c9950803.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9950803,ACTIVITY_SUMMON,c9950803.counterfilter)
	Duel.AddCustomActivityCounter(9950803,ACTIVITY_SPSUMMON,c9950803.counterfilter)
	Duel.AddCustomActivityCounter(9950803,ACTIVITY_FLIPSUMMON,c9950803.counterfilter)
end
function c9950803.counterfilter(c)
	return c:IsSetCard(0x9bd1) or c:IsRace(RACE_INSECT)
end
function c9950803.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(9950803,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(9950803,tp,ACTIVITY_SPSUMMON)==0 
		and Duel.GetCustomActivityCount(9950803,tp,ACTIVITY_FLIPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9950803.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c9950803.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsSetCard(0x9bd1) or c:IsRace(RACE_INSECT)
end
function c9950803.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9950804,0x9bd1,0x4011,1500,0,4,RACE_INSECT,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
end
function c9950803.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9950804,0x9bd1,0x4011,1500,0,4,RACE_INSECT,ATTRIBUTE_WIND) then
		local ct=3
		while ct>0 do
		local token=Duel.CreateToken(tp,9950804)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e2,true)
			ct=ct-1
		end
		Duel.SpecialSummonComplete()
end

