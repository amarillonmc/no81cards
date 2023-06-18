--圣刻龙-蒙龙
function c98920099.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c98920099.val)
	c:RegisterEffect(e1)
	--disable special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920099,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920099)
	e1:SetCondition(c98920099.discon)
	e1:SetCost(c98920099.discost)
	e1:SetTarget(c98920099.distg)
	e1:SetOperation(c98920099.disop)
	c:RegisterEffect(e1)
end
function c98920099.filter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and ((c:IsSetCard(0x69) and c:IsType(TYPE_MONSTER)) or (c:IsType(TYPE_NORMAL) and c:IsRace(RACE_DRAGON)))
end
function c98920099.val(e,c)
	return Duel.GetMatchingGroupCount(c98920099.filter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)*200
end
function c98920099.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c98920099.costfilter(c)
	return c:IsSetCard(0x69) or (c:IsRace(RACE_DRAGON) and c:IsType(TYPE_NORMAL))
end
function c98920099.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c98920099.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c98920099.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c98920099.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c98920099.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end