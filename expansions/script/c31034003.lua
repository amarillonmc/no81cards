--Speedgear R4-P1D
function c31034003.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, 31034003+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c31034003.spcon)
	c:RegisterEffect(e1)
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c31034003.sycon)
	e2:SetOperation(c31034003.syop)
	c:RegisterEffect(e2)
end

function c31034003.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(Card.IsCode, c:GetControler(), LOCATION_MZONE, 0, 1, nil, 31034001)
end

function c31034003.sycon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r == REASON_SYNCHRO and c:GetReasonCard():IsAttribute(ATTRIBUTE_WIND)
end

function c31034003.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep == 1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end

function c31034003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk == 0 then return c:IsDefenseAbove(600) end
end

function c31034003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:GetDefense() < 600
		or Duel.GetCurrentChain() ~= ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(-600)
	c:RegisterEffect(e1)
	if not c:IsHasEffect(EFFECT_REVERSE_UPDATE) then
		local ct=Duel.GetCurrentChain()
		local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tep == 1-tp then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_IMMUNE_EFFECT)
			e2:SetRange(LOCATION_MZONE)
			e2:SetValue(c31034003.efilter)
			e2:SetLabelObject(te)
			e2:SetReset(RESET_EVENT+RESET_CHAIN)
			c:RegisterEffect(e2, true)
		end
	end
end

function c31034003.efilter(e,re)
	return re == e:GetLabelObject()
end

function c31034003.syop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31034003, 0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1, true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c31034003.condition)
	e2:SetTarget(c31034003.target)
	e2:SetOperation(c31034003.operation)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e2, true)
end