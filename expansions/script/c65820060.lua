--源于黑影 时机
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.maintg)
	e1:SetOperation(s.mainop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+65820000)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.mecon2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.gravetg)
	e2:SetOperation(s.graveop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.gravetg)
	e3:SetOperation(s.graveop)
	c:RegisterEffect(e3)
end

s.effect_lixiaoguo=true

function s.consume_use_counter(e,tp)
	for i=0,10 do
		Duel.ResetFlagEffect(tp,EFFECT_FLAG_EFFECT+65820000+i)
	end
	local count=math.max(Duel.GetFlagEffect(tp,65820099)-1,0)
	Duel.ResetFlagEffect(tp,65820099)
	for i=1,count do
		Duel.RegisterFlagEffect(tp,65820099,0,0,1)
	end
	local te=Effect.CreateEffect(e:GetHandler())
	te:SetDescription(aux.Stringid(65820000,count))
	te:SetType(EFFECT_TYPE_FIELD)
	te:SetCode(EFFECT_FLAG_EFFECT+65820000+count)
	te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SET_AVAILABLE)
	te:SetTargetRange(1,0)
	Duel.RegisterEffect(te,tp)
end

function s.cfilter1(c,tp)
	return c:IsSetCard(0x3a32)
end

function s.mecon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter1,1,nil,tp) and ep==tp
end

function s.cfilter11(c)
	return not c:IsHasEffect(EFFECT_LEAVE_FIELD_REDIRECT)
end

function s.maintg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local has_use=Duel.GetFlagEffect(tp,65820099)>0
	local is_flipped=c:GetFlagEffect(65820010)>0
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter11,tp,0,LOCATION_ONFIELD,1,nil) end

	if has_use then s.consume_use_counter(e,tp) end

	if (has_use and not is_flipped) or (not has_use and is_flipped) then
		e:SetLabel(1)
	else
		e:SetLabel(2)
	end
end

function s.mainop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.cfilter11,tp,0,LOCATION_ONFIELD,nil)
	if e:GetLabel()==1 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
			tc:RegisterEffect(e1)
		end
	else
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetValue(LOCATION_GRAVE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
			tc:RegisterEffect(e1)
		end
	end
end

function s.gravetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter11,tp,0,LOCATION_ONFIELD,1,nil) end
end

function s.graveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.cfilter11,tp,0,LOCATION_ONFIELD,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_DECK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		tc:RegisterEffect(e1)
	end
end