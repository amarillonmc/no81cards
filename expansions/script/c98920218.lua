--水龙-超载
function c98920218.initial_effect(c) 
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c98920218.splimit)
	c:RegisterEffect(e1)
	--change name
	aux.EnableChangeCode(c,85066822,LOCATION_HAND+LOCATION_GRAVE)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920218,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98920218.discon)
	e3:SetTarget(c98920218.distg)
	e3:SetOperation(c98920218.disop)
	c:RegisterEffect(e3)
	--disable summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920218,1))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON)
	e2:SetCondition(c98920218.condition2)
	e2:SetCost(c98920218.cost2)
	e2:SetTarget(c98920218.target2)
	e2:SetOperation(c98920218.operation2)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(98920218,2))
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
end
function c98920218.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc and sc:IsType(TYPE_SPELL+TYPE_TRAP) and sc:IsSetCard(0x100)
end
function c98920218.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c98920218.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98920218.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c98920218.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c98920218.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98920218.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c98920218.sfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c98920218.sfilter(c,e,tp)
	return (c:GetOriginalCode()==6022371 or c:GetOriginalCode()==85066822) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_DEFENSE)
end
function c98920218.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	if Duel.Destroy(eg,REASON_EFFECT)==0 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920218.sfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end