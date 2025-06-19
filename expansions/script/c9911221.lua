--浩瀚生态的前线基地
function c9911221.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911221+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9911221.cost)
	e1:SetTarget(c9911221.target)
	e1:SetOperation(c9911221.activate)
	c:RegisterEffect(e1)
end
function c9911221.costfilter(c)
	return c:IsSetCard(0x5958) and c:IsType(TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c9911221.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911221.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9911221.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9911221.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9911211,0x6958,0x4011,1000,1000,2,RACE_MACHINE,ATTRIBUTE_DARK) then
		op=Duel.SelectOption(tp,aux.Stringid(9911221,0),aux.Stringid(9911221,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9911221,1))+1
	end
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		e:SetOperation(c9911221.activate)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	else
		e:SetCategory(0)
		e:SetOperation(c9911221.activate2)
	end
end
function c9911221.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,9911211,0x6958,0x4011,1000,1000,2,RACE_MACHINE,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,9911222)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9911221.activate2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c9911221.effectfilter)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
end
function c9911221.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsType(TYPE_TUNER)
end
