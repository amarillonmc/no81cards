--爆城强者
function c72100103.initial_effect(c)
	---special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c72100103.spcon)
	e1:SetOperation(c72100103.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c72100103.defval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCountLimit(3,72100103)
	e3:SetCondition(c72100103.atcon)
	e3:SetCost(c72100103.atcost)
	e3:SetOperation(c72100103.atop)
	c:RegisterEffect(e3)
end
function c72100103.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c72100103.spcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c72100103.spfilter,tp,LOCATION_HAND,0,nil)
	if not c:IsAbleToGraveAsCost() or Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY) then
		g:RemoveCard(c)
	end
	return g:CheckWithSumGreater(Card.GetLevel,5)
end
function c72100103.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c72100103.spfilter,c:GetControler(),LOCATION_HAND,0,nil)
	if not c:IsAbleToGraveAsCost() or Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY) then
		g:RemoveCard(c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=g:SelectWithSumGreater(tp,Card.GetLevel,5)
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
end
-----
function c72100103.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c72100103.defval(e,c)
	return Duel.GetMatchingGroupCount(c72100103.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*400
end
-----
function c72100103.costfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToGraveAsCost()
end
function c72100103.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
		and Duel.GetAttacker()==c and c:IsChainAttackable(0)
		and not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,c)
end
function c72100103.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72100103.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c72100103.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c72100103.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end