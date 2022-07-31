--群豪link2 lua by tennojou
local s,id,o=GetID()
if not aux.tz_qh_qechk then
	aux.tz_qh_qechk=true
	_rge=Card.RegisterEffect 
	function Card.RegisterEffect(c,ie,ob) --ReplaceEffect
		local b=ob or false
		if not (c:IsOriginalSetCard(0x17d) and c:IsType(TYPE_PENDULUM))
			or not (ie:IsHasType(EFFECT_TYPE_IGNITION)) then
			return _rge(c,ie,b)
		end
		local n1=_rge(c,ie,b)
		local qe=ie:Clone()
		qe:SetType(EFFECT_TYPE_QUICK_O)
		qe:SetCode(EVENT_FREE_CHAIN)
		qe:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
		if ie:GetCondition() then
			local con=ie:GetCondition()
			qe:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsLocation(LOCATION_MZONE) and Duel.IsPlayerAffectedByEffect(tp,id)
					and con(e,tp,eg,ep,ev,re,r,rp) 
				end)
		else qe:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return e:GetHandler():IsLocation(LOCATION_MZONE) and Duel.IsPlayerAffectedByEffect(tp,id) end)
		end
		local n2=_rge(c,qe,b)
		return n1,n2
	end
end
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x17d),2)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	--TTT
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(id)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(s.adop)
	c:RegisterEffect(e3)
end
function s.filtop(c)
	return c:IsSetCard(0x17d) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local n=0
		if Duel.CheckLocation(tp,LOCATION_PZONE,0) then n=n+1 end
		if Duel.CheckLocation(tp,LOCATION_PZONE,1) then n=n+1 end
		return n>0 and Duel.IsExistingMatchingCard(s.filtop,tp,LOCATION_EXTRA,0,1,nil) 
	end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local n=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then n=n+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then n=n+1 end
	if n<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=Duel.SelectMatchingCard(tp,s.filtop,tp,LOCATION_EXTRA,0,1,n,nil)
	local sc=sg:GetFirst()
	while sc do
		Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,false)
		sc:SetStatus(STATUS_EFFECT_ENABLED,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		sc:RegisterEffect(e1)
		sc=sg:GetNext()
	end
	
end
--
function s.filsn(c)
	return c:IsOriginalSetCard(0x17d) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
		and not c:GetFlagEffectLabel(id)
end
function s.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ng=Duel.GetMatchingGroup(s.filsn,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	local nc=ng:GetFirst()
	while nc do
		nc:RegisterFlagEffect(id,RESETS_STANDARD,0,1)
		nc:ReplaceEffect(nc:GetCode(),0)
		nc=ng:GetNext()
	end
end