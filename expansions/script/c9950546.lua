--清姬-转身火生三昧
function c9950546.initial_effect(c)
	 aux.AddCodeList(c,9950528,9950555)
	c:EnableReviveLimit()
	--Cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950546.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
 --damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950546,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9950546)
	e1:SetTarget(c9950546.damtg)
	e1:SetOperation(c9950546.damop)
	c:RegisterEffect(e1)
--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950546,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c9950546.condition)
	e1:SetCost(c9950546.cost)
	e1:SetTarget(c9950546.target)
	e1:SetOperation(c9950546.operation)
	c:RegisterEffect(e1)
 c9950546.discard_effect=e1
 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950546,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,99505461)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c9950546.spcon)
	e2:SetTarget(c9950546.sptg)
	e2:SetOperation(c9950546.spop)
	c:RegisterEffect(e2)
end
c9950546.assault_name=9950545
function c9950546.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950546,0))
end
function c9950546.damfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xba5) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9950546.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950546.damfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	local ct=Duel.GetMatchingGroupCount(c9950546.damfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
end
function c9950546.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c9950546.damfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	Duel.Damage(p,ct*300,REASON_EFFECT)
end
function c9950546.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c9950546.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c9950546.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5)
end
function c9950546.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950546.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c9950546.ctfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba5)
end
function c9950546.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c9950546.atkfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(c9950546.ctfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	if tg:GetCount()>0 and g:GetCount()>0 then
		local d=g:GetClassCount(Card.GetCode)*300
		local sc=tg:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(d)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=tg:GetNext()
		end
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950546,0))
end
function c9950546.spfilter(c,e,tp)
	return c:IsCode(9950545)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c9950546.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c9950546.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(c9950546.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c9950546.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 or not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9950546.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end