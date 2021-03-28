--龙界原始龙种后裔 圣魔龙
function c99700287.initial_effect(c)
	c:EnableCounterPermit(0xfd00)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xfd00),aux.FilterBoolFunction(Card.IsFusionSetCard,0xfd04,0xfd07),4,4,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c99700287.splimit)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99700287,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c99700287.ctcon)
	e2:SetTarget(c99700287.cttg)
	e2:SetOperation(c99700287.ctop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c99700287.atkcon)
	e3:SetValue(c99700287.atkval)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99700287,1))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c99700287.discon)
	e4:SetCost(c99700287.discost)
	e4:SetTarget(c99700287.distg)
	e4:SetOperation(c99700287.disop)
	c:RegisterEffect(e4)
	--act limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,1)
	e5:SetCondition(c99700287.effcon)
	e5:SetValue(c99700287.aclimit)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROYE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,99700287)
	e6:SetTarget(c99700287.destg)
	e6:SetOperation(c99700287.desop)
	c:RegisterEffect(e6)
	--spsummon()
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCondition(c99700287.effcon)
	c:RegisterEffect(e8)
	--summon success
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetOperation(c99700287.sumsuc)
	c:RegisterEffect(e9)
end
c99700287.material_type=TYPE_FUSION 
function c99700287.valcheck(e,c)
	e:GetLabelObject():SetLabel(c:GetMaterial():FilterCount(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP))
end
function c99700287.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c99700287.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and se:GetHandler():IsCode(99700285)
end
function c99700287.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c99700287.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) then return end
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c99700287.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c99700287.cfilter(c,type)
	return c:IsSetCard(0xfd00) and c:IsType(type)
end
function c99700287.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=0
	for i,type in ipairs({TYPE_SPELL,TYPE_TRAP,TYPE_MONSTER}) do
		if Duel.IsExistingMatchingCard(c99700287.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,type) then
			ct=ct+1
		end
	end
	if chk==0 then return ct>0 and e:GetHandler():IsCanAddCounter(0xfd00,ct) end
end
function c99700287.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local ct=0
	for i,type in ipairs({TYPE_SPELL,TYPE_TRAP,TYPE_MONSTER}) do
		if Duel.IsExistingMatchingCard(c99700287.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,type) then
			ct=ct+1
		end
	end
	if ct>0 then
		c:AddCounter(0xfd00,ct)
	end
end
function c99700287.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c99700287.atkval(e,c)
	return c:GetCounter(0xfd00)*1500
end
function c99700287.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function c99700287.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xfd00,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xfd00,1,REASON_COST)
end
function c99700287.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if Duel.GetAttacker()==e:GetHandler() then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c99700287.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev)~=0 and e:GetLabel()>0 then
		if c:IsRelateToEffect(e) and c:IsChainAttackable() then
			Duel.ChainAttack()
		end
	end
end
function c99700287.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c99700287.filter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and c:IsType(TYPE_MONSTER)
end
function c99700287.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c99700287.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c99700287.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c99700287.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c99700287.filter,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e),c:GetAttack())
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
	end
end
