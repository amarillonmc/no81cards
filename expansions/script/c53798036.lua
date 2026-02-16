local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Indes (Effect 1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTarget(s.indtg)
	e1:SetValue(s.indval)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	c:RegisterEffect(e2)
	--Negate (Effect 2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
	--Global Check for Effect 2
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.indtg(e,c)
	return c:IsType(TYPE_MONSTER)
end
function s.indval(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	-- Mark monster if it activates an effect on the field
	if re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE then
		rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function s.desfilter(c)
	-- Filter: Face-up monster, no flag (has not activated effect)
	return c:GetFlagEffect(id)==0
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	-- Condition: Opponent's Normal or Quick-Play Spell
	if rp==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	if not (re:IsActiveType(TYPE_SPELL) and (re:IsActiveType(TYPE_NORMAL) or re:IsActiveType(TYPE_QUICKPLAY))) then return end
	
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
	-- Logic: Opponent can destroy 1 valid monster. If not, negate.
	if #g>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
		local sg=g:Select(1-tp,1,1,nil)
		if #sg>0 then
			Duel.Destroy(sg,REASON_EFFECT)
		else
			Duel.NegateEffect(ev)
		end
	else
		Duel.NegateEffect(ev)
	end
end