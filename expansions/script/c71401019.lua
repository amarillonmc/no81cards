--花梦-「荧」
if not c71401001 then dofile("expansions/script/c71401001.lua") end
function c71401019.initial_effect(c)
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71401001,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,71401019)
	e1:SetCost(yume.ButterflyLimitCost)
	e1:SetTarget(yume.ButterflyPlaceTg)
	e1:SetOperation(yume.ButterflySpellOp)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401019,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,71501019)
	e2:SetCondition(c71401019.con2)
	e2:SetCost(c71401019.cost2)
	e2:SetTarget(c71401019.tg2)
	e2:SetOperation(c71401019.op2)
	c:RegisterEffect(e2)
	yume.ButterflyCounter()
end
function c71401019.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c71401019.filterc2(c,tp,ec)
	if not c:IsRace(RACE_SPELLCASTER) and c:IsLevel(4) and c:IsFaceup() and c:IsAbleToHandAsCost() then
		return false
	end
	local e1=Effect.CreateEffect(ec)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local res=Duel.IsExistingMatchingCard(c71401019.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,c:GetCode())
	e1:Reset()
	return res
end
function c71401019.filter2(c,code)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevel(4) and not c:IsCode(code) and c:IsSummonable(true,nil)
end
function c71401019.filter2a(c,code)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevel(4) and not c:IsCode(code)
end
function c71401019.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c71401019.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsPlayerCanAdditionalSummon(tp) and Duel.GetFlagEffect(tp,71401019)==0
			and Duel.IsExistingMatchingCard(c71401019.filterc2,tp,LOCATION_MZONE,0,1,nil,tp,e:GetHandler())
			and Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local rc=Duel.SelectMatchingCard(tp,c71401019.filterc2,tp,LOCATION_MZONE,0,1,1,nil,tp,e:GetHandler()):GetFirst()
	e:SetLabel(rc:GetCode())
	Duel.SendtoHand(rc,nil,REASON_COST)
	yume.RegButterflyCostLimit(e,tp)
end
function c71401019.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,71401019)~=0 then return end
	local code=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(71401019,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(c71401019.filter2a,code))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,71401019,RESET_PHASE+PHASE_END,0,1)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c71401019.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,code)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end