--空牙团的叛逆 布莱克
function c98940006.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_DECK)
	e1:SetCountLimit(1,98940006)
	e1:SetCondition(c98940006.negcon)
	e1:SetTarget(c98940006.negtg)
	e1:SetOperation(c98940006.negop)
	c:RegisterEffect(e1)
--multi attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98940006,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c98940006.atkcon)
	e4:SetTarget(c98940006.atktg)
	e4:SetOperation(c98940006.atkop)
	c:RegisterEffect(e4)
--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98940006,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,98950006)
	e1:SetCost(c98940006.cost)
	e1:SetTarget(c98940006.target)
	e1:SetOperation(c98940006.operation)
	c:RegisterEffect(e1)
end
function c98940006.negcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.IsChainNegatable(ev) and rp==tp and re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x114) and rc:IsLevelBelow(4)
end
function c98940006.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c98940006.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.NegateActivation(ev) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
	end
end
function c98940006.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x114)
end
function c98940006.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c98940006.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c98940006.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local cg=Duel.GetMatchingGroup(c98940006.filter,tp,LOCATION_MZONE,0,nil)
	local ct=cg:GetCount()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c98940006.cfilter(c)
	return c:IsDiscardable() and c:IsSetCard(0x114)
end
function c98940006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98940006.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c98940006.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c98940006.filter1(c,e,tp)
	return c:IsSummonPlayer(1-tp) and (not e or c:IsRelateToEffect(e))
end
function c98940006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and not eg:IsContains(e:GetHandler())
		and eg:IsExists(c98940006.filter1,1,nil,nil,tp) end
	local g=eg:Filter(c98940006.filter1,nil,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98940006.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c98940006.filter1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end