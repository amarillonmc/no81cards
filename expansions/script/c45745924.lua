--极翼灵兽 勇鸟猛攻
function c45745924.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45745924,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,45745924)
	e1:SetCondition(c45745924.condition)
	e1:SetCost(c45745924.cost)
	e1:SetTarget(c45745924.target)
	e1:SetOperation(c45745924.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c45745924.handcon)
	c:RegisterEffect(e2)   

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(45745924,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(aux.bfgcost)
	e3:SetCountLimit(1,45745924)
	e3:SetTarget(c45745924.sptg)
	e3:SetOperation(c45745924.spop)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(45745924,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(aux.bfgcost)
	e4:SetCountLimit(1,45745924)
	e4:SetTarget(c45745924.target1)
	e4:SetOperation(c45745924.activate1)
	c:RegisterEffect(e4)
end
--e1
function c45745924.filter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsFaceup()
end
function c45745924.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c45745924.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c45745924.cfilter(c,tp)
	return c:IsRace(RACE_WINDBEAST) and (c:IsControler(tp) or c:IsFaceup()) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c45745924.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c45745924.cfilter,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c45745924.cfilter,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c45745924.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c45745924.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--e2
function c45745924.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x88100)
end
function c45745924.handcon(e)
	return Duel.IsExistingMatchingCard(c45745924.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
--e3
function c45745924.filter2(c,e,tp)
	return c:IsSetCard(0x881) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c45745924.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c45745924.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c45745924.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c45745924.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c45745924.splimit)
	Duel.RegisterEffect(e0,tp)
end
function c45745924.splimit(e,c)
	return not c:IsRace(RACE_WINDBEAST)
end
--e4
function c45745924.filter3(c,e,tp)
	return c:IsRace(RACE_WINDBEAST) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c45745924.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c45745924.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c45745924.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c45745924.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp) 
	local tc=g:GetFirst()
	if tc then
	   Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_DISABLE)
	   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	   tc:RegisterEffect(e1)
	   local e2=e1:Clone()
	   e2:SetCode(EFFECT_DISABLE_EFFECT)
	   tc:RegisterEffect(e2)
	   Duel.SpecialSummonComplete()
	end  
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c45745924.splimit1)
	Duel.RegisterEffect(e0,tp)
end
function c45745924.splimit1(e,c)
	return not c:IsRace(RACE_WINDBEAST)
end