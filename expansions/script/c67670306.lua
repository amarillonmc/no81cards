--重兵装型女子高中生・陸
function c67670306.initial_effect(c)
	--cannot be material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c67670306.limit)
	c:RegisterEffect(e1)   
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e4)
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)	
	--special summon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_HAND)
	e7:SetCountLimit(1,67670306+EFFECT_COUNT_CODE_OATH)
	e7:SetCondition(c67670306.sprcon)
	c:RegisterEffect(e7)   
	--Special Summon
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(67670306,1))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCountLimit(1,67670306*2)
	e8:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e8:SetCost(c67670306.cost)
	e8:SetOperation(c67670306.operation)
	c:RegisterEffect(e8)
end
--special summon
function c67670306.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1b7) and not c:IsCode(67670306)
end
function c67670306.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c67670306.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
--Special Summon
function c67670306.costfilter(c)
	return c:IsSetCard(0x1b7) and c:IsAbleToRemoveAsCost()
end
function c67670306.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c67670306.costfilter,tp,LOCATION_GRAVE,0,c)
	if chk==0 then return c:IsAbleToRemoveAsCost() and #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,1,1,nil)
	sg:AddCard(c)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c67670306.spfilter2(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x1b7) and not c:IsCode(67670306) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c67670306.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67670306.spfilter2),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end