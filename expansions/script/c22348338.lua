--秽 血 紫 僵  癸 丙
local m=22348338
local c22348338=_G["c"..m]
function c22348338.initial_effect(c)
	--activate cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0xfe,0)
	e1:SetCost(c22348338.costchk)
	e1:SetOperation(c22348338.costop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e2)
	--spsummon cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(0xfe)
	e3:SetCost(c22348338.costchk)
	e3:SetOperation(c22348338.costop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e4)
	--attack cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ATTACK_COST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetCost(c22348338.costchk)
	e5:SetOperation(c22348338.costop)
	c:RegisterEffect(e5)
	--accumulate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_FLAG_EFFECT+22348338)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	c:RegisterEffect(e6)
	--destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c22348338.desreptg)
	e7:SetValue(c22348338.desrepval)
	e7:SetOperation(c22348338.desrepop)
	c:RegisterEffect(e7)
	
end

function c22348338.costchk(e,c,tp)
	local ct=Duel.GetFlagEffect(tp,22348338)
	return Duel.IsPlayerCanDiscardDeckAsCost(tp,ct)
end
function c22348338.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,1,REASON_COST)
end
function c22348338.repfilter(c,tp)
	return c:IsOnField()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c22348338.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c22348338.repfilter,1,nil,tp)
		and Duel.IsPlayerCanDiscardDeck(tp,1) end
	return true
end
function c22348338.desrepval(e,c)
	return c22348338.repfilter(c,e:GetHandlerPlayer())
end
function c22348338.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,22348338)
end
