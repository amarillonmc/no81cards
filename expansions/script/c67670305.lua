--重兵装型女子高中生・伍
function c67670305.initial_effect(c)
	--cannot be material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c67670305.limit)
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
	e7:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e7:SetCountLimit(1,67670305+EFFECT_COUNT_CODE_OATH)
	e7:SetCondition(c67670305.spcon)
	e7:SetOperation(c67670305.spop)
	c:RegisterEffect(e7)  
	--to grave
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(67670305,1))
	e8:SetCategory(CATEGORY_TOGRAVE)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCountLimit(1,67670305*2)
	e8:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e8:SetCost(c67670305.cost)
	e8:SetOperation(c67670305.operation)
	c:RegisterEffect(e8)   
end
function c67670305.limit(e,c,sumtype)
	if not c then return false end
	return not c:IsSetCard(0x1b7)
end
--special summon
function c67670305.spfilter(c)
	return c:IsSetCard(0x1b7) and not c:IsCode(67670305) and (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_HAND)) and c:IsAbleToRemoveAsCost()
end
function c67670305.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c67670305.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,c)
end
function c67670305.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c67670305.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--to grave
function c67670305.costfilter(c)
	return c:IsSetCard(0x1b7) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c67670305.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c67670305.costfilter,tp,LOCATION_GRAVE,0,c)
	if chk==0 then return c:IsAbleToRemoveAsCost() and #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,1,1,nil)
	sg:AddCard(c)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c67670305.spfilter2(c,e,tp)
	return c:IsSetCard(0x1b7) and not c:IsCode(67670305) and c:IsAbleToHand()
end
function c67670305.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67670305.spfilter2,tp,LOCATION_DECK,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end