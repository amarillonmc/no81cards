--阴天气弱画师 库拉
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.hspcon)
	e1:SetValue(s.hspval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--change effect range
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(s.adjustop)
	c:RegisterEffect(e01)]]
end
function s.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function s.getzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_SZONE,0,nil)
	for tc in aux.Next(g) do
		local seq=tc:GetSequence()
		zone=zone|(1<<seq)
		if seq>0 then zone=zone|(1<<(seq-1)) end
		if seq<4 then zone=zone|(1<<(seq+1)) end
	end
	return zone
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=s.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function s.hspval(e,c)
	local tp=c:GetControler()
	return 0,s.getzone(tp)
end
function s.spfilter(c,e,tp)
	return c:IsLevel(3) and c:IsRace(RACE_FAIRY) and c:IsSummonable(true,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) 
		and Duel.GetFlagEffect(tp,id)<ct end
	Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local c=e:GetHandler()
		--
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			local grant_effect={}
			function s.quick_filter(e)
				if e:IsHasType(EFFECT_TYPE_GRANT) and 
				   e:IsHasRange(LOCATION_SZONE) then
					grant_effect[#grant_effect+1]=e
				end
				return false
			end
			local boolean=tc:IsOriginalEffectProperty(s.quick_filter)
			if #grant_effect>0 then
				for _,effect in pairs(grant_effect) do
					local c_effect=effect:Clone()
					local g_effect=c_effect:GetLabelObject()
					if not g_effect then break end
					local g_effect=g_effect:Clone()
					g_effect:SetRange(LOCATION_HAND)
					local condition=effect:GetCondition()
					local target=effect:GetTarget()
					local property=effect:GetProperty()
					c_effect:SetTargetRange(LOCATION_HAND,0)
					c_effect:SetLabelObject(g_effect)
					c_effect:SetProperty(property|EFFECT_FLAG_SET_AVAILABLE)
					c_effect:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
						return Duel.IsPlayerAffectedByEffect(tp,id)~=nil and (not condition or condition(e,tp,eg,ep,ev,re,r,rp))
					end)
					c_effect:SetTarget(function(e,c)
						local c_GetSequence=Card.GetSequence
						Card.GetSequence=(function(c) return 0 end)
						--[[local c_IsType=Card.IsType
						Card.IsType=(function(c,type)
						if type==TYPE_EFFECT then return c_IsType(c,TYPE_MONSTER) end
						return c_IsType(c,type) end)]]
						local boolean=(not target or target(e,c))
						Card.GetSequence=c_GetSequence
						--Card.IsType=c_IsType
						return c:IsType(TYPE_MONSTER) and boolean
					end)
					tc:RegisterEffect(c_effect)
				end
			end
		end
	end
	e:Reset()
end
