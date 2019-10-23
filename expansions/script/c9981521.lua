--终极铠甲·雷霆铠甲
function c9981521.initial_effect(c)
	 c:EnableCounterPermit(0x52)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),4)
	c:EnableReviveLimit()
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981521,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9981521.ctcon)
	e1:SetTarget(c9981521.cttg)
	e1:SetOperation(c9981521.ctop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9981521.atkcon)
	e2:SetValue(c9981521.atkval)
	c:RegisterEffect(e2)
	--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9981521,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9981521.atkcon)
	e3:SetCost(c9981521.atkcost)
	e3:SetOperation(c9981521.atkop)
	c:RegisterEffect(e3)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9981521,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9981521.negcon)
	e3:SetCost(c9981521.atkcost)
	e3:SetTarget(c9981521.negtg)
	e3:SetOperation(c9981521.negop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981521.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981521.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981521,0))
end
function c9981521.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9981521.cfilter(c,type)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(type)
end
function c9981521.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=0
	for i,type in ipairs({ATTRIBUTE_LIGHT,ATTRIBUTE_DARK,ATTRIBUTE_EARTH,ATTRIBUTE_WATER,ATTRIBUTE_WIND,ATTRIBUTE_FIRE,ATTRIBUTE_DEVINE}) do
		if Duel.IsExistingMatchingCard(c9981521.cfilter,tp,LOCATION_GRAVE,0,1,nil,type) then
			ct=ct+1
		end
	end
	if chk==0 then return ct>0 and e:GetHandler():IsCanAddCounter(0x52,ct) end
end
function c9981521.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local ct=0
	for i,type in ipairs({ATTRIBUTE_LIGHT,ATTRIBUTE_DARK,ATTRIBUTE_EARTH,ATTRIBUTE_WATER,ATTRIBUTE_WIND,ATTRIBUTE_FIRE,ATTRIBUTE_DEVINE}) do
		if Duel.IsExistingMatchingCard(c9981521.cfilter,tp,LOCATION_GRAVE,0,1,nil,type) then
			ct=ct+1
		end
	end
	if ct>0 then
		c:AddCounter(0x52,ct)
	end
end
function c9981521.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c9981521.atkval(e,c)
	return c:GetCounter(0x52)*2000
end
function c9981521.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c9981521.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x52,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x52,1,REASON_COST)
end
function c9981521.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e2:SetValue(2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981521,3))
end
function c9981521.negcon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return not re:GetHandler():IsCode(9981521) and Duel.IsChainNegatable(ev)
end
function c9981521.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c9981521.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981521,3))
	end
end