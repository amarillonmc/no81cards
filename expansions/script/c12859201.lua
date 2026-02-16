--月见八千代
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.atkcost)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1118)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.tktg)
	e2:SetOperation(s.tkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(function(tc) return tc:IsFaceup() and tc:IsRace(RACE_CYBERSE) end,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(tc) return tc:IsFaceup() and tc:IsRace(RACE_CYBERSE) end,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,12859202,0,TYPES_TOKEN_MONSTER,100,100,1,RACE_CYBERSE,ATTRIBUTE_DARK) and c:IsLevelAbove(2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	local lv=c:GetLevel()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local max=math.min(4,lv-1,ft)
	if max<=0 then return end
	local dec=max
	if max>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		dec=Duel.AnnounceNumber(tp,table.unpack((function(m) local t={} for i=1,m do t[#t+1]=i end return t end)(max)))
	end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then dec=1 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(-dec)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	for i=1,dec do
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then break end
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,12859202,0,TYPES_TOKEN_MONSTER,100,100,1,RACE_CYBERSE,ATTRIBUTE_DARK) then return end
		local token=Duel.CreateToken(tp,12859202)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function s.splimit(e,c)
	return not c:IsRace(RACE_CYBERSE)
end