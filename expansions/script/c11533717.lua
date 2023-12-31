--遗式唤灵师
function c11533717.initial_effect(c)
	--ritual level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(function(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	if c:IsAttribute(ATTRIBUTE_WATER) then
	  local clv=c:GetLevel()
	  return (lv<<16)+clv
	else return lv end end) 
	c:RegisterEffect(e1) 
	--disable
	--local e1=Effect.CreateEffect(c)   
	--e1:SetType(EFFECT_TYPE_QUICK_O)
	--e1:SetCode(EVENT_FREE_CHAIN) 
	--e1:SetRange(LOCATION_HAND) 
	--e1:SetCondition(c11533717.condition)
	--e1:SetCost(c11533717.cost)
	--e1:SetTarget(c11533717.target)
	--e1:SetOperation(c11533717.operation)
	--c:RegisterEffect(e1) 
	--atk
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)  
	e1:SetCountLimit(1,11533717) 
	e1:SetCost(c11533717.atkcost)
	e1:SetTarget(c11533717.atktg)
	e1:SetOperation(c11533717.atkop)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,21533717) 
	e2:SetTarget(c11533717.sptg)
	e2:SetOperation(c11533717.spop)
	c:RegisterEffect(e2)
end 
function c11533717.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c11533717.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c11533717.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end
function c11533717.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetTarget(function(e,c) 
	return c:IsLevelBelow(2) and c:IsAttribute(ATTRIBUTE_WATER) end)
	e1:SetValue(function(e,te) 
	return te:IsActivated() and te:GetOwnerPlayer()~=e:GetOwnerPlayer() end) 
	e1:SetReset(RESET_PHASE+Duel.GetCurrentPhase()) 
	Duel.RegisterEffect(e1,tp) 
end 
function c11533717.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end 
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end 
function c11533717.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c11533717.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetTarget(function(e,c) 
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_WATER) end) 
	e1:SetValue(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil,ATTRIBUTE_WATER)*300 end)
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp) 
end  
function c11533717.xtdfil(c,e,tp)
	local g=Group.FromCards(c,e:GetHandler())
	return c:IsAbleToDeck() and c:IsAttribute(ATTRIBUTE_WATER) and Duel.IsExistingMatchingCard(c11533717.spfilter,tp,LOCATION_DECK,0,1,g,e,tp) 
end
function c11533717.spfilter(c,e,tp)
	return c:IsSetCard(0x3a) and c:IsLevelBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11533717.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c11533717.xtdfil,tp,LOCATION_GRAVE,0,2,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11533717.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c11533717.xtdfil,tp,LOCATION_GRAVE,0,2,nil,e,tp) then 
		local g=Duel.SelectMatchingCard(tp,c11533717.xtdfil,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)  
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT) and Duel.IsExistingMatchingCard(c11533717.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then 
			local sg=Duel.SelectMatchingCard(tp,c11533717.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp) 
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
		end 
	end 
end


