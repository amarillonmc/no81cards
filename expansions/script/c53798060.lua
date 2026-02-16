-- c99999999
local s,id,o=GetID()
function s.initial_effect(c)
	-- Synchro Summon procedure: Tuner + 1+ non-Tuner
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	-- Effect 1: Return banished cards to Deck each time opponent Special Summons from Extra Deck
	-- [Ref: c66425726 Odd-Eyes Pendulumgraph Dragon]
	-- Part A: Immediate resolution (if not resolving a chain)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.tdcon1)
	e1:SetOperation(s.tdop1)
	c:RegisterEffect(e1)
	-- Part B: Register during chain (if resolving a chain)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	-- Part C: Resolve registered events after chain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.tdcon2)
	e3:SetOperation(s.tdop2)
	c:RegisterEffect(e3)

	-- Effect 2: Banish 9 from ED (Cost) to copy stats and effect
	-- [Ref: c21999001 Cipher Biplane (Cost/Target logic)]
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id) -- "This card name's (2) effect can only be used once per turn."
	-- Use specific Cost/Target structure to ensure valid resolution
	e4:SetCost(s.cpcost)
	e4:SetTarget(s.cptg)
	e4:SetOperation(s.cpop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(s.alop)
	c:RegisterEffect(e5)
end

-- Helpers for Effect 1 (Return banished cards)
function s.cfilter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsSummonLocation(LOCATION_EXTRA)
end

function s.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,1-tp) and not Duel.IsChainSolving()
end

function s.tdfilter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end

function s.tdop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_REMOVED,0,nil)
	if #g>=2 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,2,2,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end

function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,1-tp) and Duel.IsChainSolving()
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_CHAIN,0,1)
end

function s.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end

function s.tdop2(e,tp,eg,ep,ev,re,r,rp)
	local n=e:GetHandler():GetFlagEffect(id)
	e:GetHandler():ResetFlagEffect(id)
	local count=n*2
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_REMOVED,0,nil)
	if #g>=count then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,count,count,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end

function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end

function s.rmfilter(c,tp)
	return c:IsFacedown() and c:IsAbleToRemoveAsCost(POS_FACEDOWN) and Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp)
end

function s.rvfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevelBelow(11) and c:IsFacedown()
end

function s.rescon(sg,e,tp,mg)
	return Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_EXTRA,0,1,sg)
end

function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			-- Complex check: Can we pick 9 banishable cards such that a valid target remains?
			return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_EXTRA,0,8,nil,tp)
		else
			-- Fallback simple check
			return Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_EXTRA,0,1,nil)
		end
	end
	
	-- Execution: If Label is set (from cpcost), perform the Cost action here
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		local rg=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_EXTRA,0,8,8,nil,e,tp)
		Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
	end
end

function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			-- Copy Name
			local code=tc:GetOriginalCodeRule()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(code)
			c:RegisterEffect(e1)
			-- Copy Race
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetValue(tc:GetOriginalRace())
			c:RegisterEffect(e2)
			-- Copy Attribute
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e3:SetValue(tc:GetOriginalAttribute())
			c:RegisterEffect(e3)
			
			-- Copy Effects [Ref: c7841112 Savior Star Dragon]
			-- "That described effect can be activated as this card's effect only once."
			Duel.MajesticCopy(c,tc)
		end
	end
end

function s.alop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetOwner()==e:GetOwner() and not re:IsHasProperty(EFFECT_FLAG_INITIAL) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(1,1)
		e1:SetValue(s.aclimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
	end
end
function s.aclimit(e,re,tp)
	return re:GetOwner()==e:GetOwner() and not re:IsHasProperty(EFFECT_FLAG_INITIAL)
end