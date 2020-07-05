--CiNo.96 骇影
function c79029532.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,5)
	c:EnableReviveLimit()
	--Pos Change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_POSITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c79029532.target)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)
	--must atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c79029532.maop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_MSET)
	c:RegisterEffect(e4)
	--cannot target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--get indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e7:SetCountLimit(1)
	e7:SetCost(c79029532.cost)
	e7:SetOperation(c79029532.giop)
	c:RegisterEffect(e7)
	--atk
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_BATTLE_CONFIRM)
	e8:SetOperation(c79029532.atkop)
	c:RegisterEffect(e8)
end
function c79029532.target(e,c)
	return c:IsLocation(LOCATION_MZONE)
end
function c79029532.maop(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst():GetControler()==tp then return end
	local fid=e:GetHandler():GetRealFieldID()
	local tc=eg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_MUST_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_MUST_ATTACK_MONSTER)
			e2:SetValue(c79029532.atklimit)
			e2:SetLabel(fid)
			tc:RegisterEffect(e2)
	 tc=eg:GetNext()
end
end
function c79029532.atklimit(e,c)
	return c:GetRealFieldID()==e:GetLabel()
end
function c79029532.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029532.giop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(c79029532.efilter)
	e1:SetRange(LOCATION_MZONE)
end
function c79029532.efilter(e,te,tp)
	return te:GetOwner():GetControler()~=tp
end  
function c79029532.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetBattleTarget()==nil then return end
	Duel.Hint(HINT_CARD,0,79029532)
	local tc=c:GetBattleTarget()
	local atk=tc:GetAttack()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(0)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(atk)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e4)
end



