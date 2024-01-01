--化学结合-T2O
function c98920219.initial_effect(c)
	aux.AddCodeList(c,85066822,6022371,98920218,58071123,98920217)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c98920219.cost)
	e1:SetTarget(c98920219.target)
	e1:SetOperation(c98920219.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920219,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98920219)
	e2:SetCondition(c98920219.spcon2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98920219.sptg2)
	e2:SetOperation(c98920219.spop2)
	c:RegisterEffect(e2)
end
function c98920219.rfilter(c,tp)
	return c:IsCode(98920217) and ((c:IsLocation(LOCATION_MZONE+LOCATION_HAND) and c:IsReleasable()) or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost()))
end
function c98920219.rrfilter(c,tp)
	return c:IsCode(58071123) and ((c:IsLocation(LOCATION_MZONE+LOCATION_HAND) and c:IsReleasable()) or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost()))
end
function c98920219.fgoal(g,tp)
	return Duel.GetMZoneCount(tp,g)>0 and Duel.CheckReleaseGroupEx(tp,aux.IsInGroup,#g,nil,g)
end
function c98920219.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920219.rfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,2,nil) and Duel.IsExistingMatchingCard(c98920219.rrfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c98920219.rfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,2,2,nil)
	local tc=g:GetFirst()
	while tc do
		 if tc:IsLocation(LOCATION_GRAVE) then 
			  Duel.Remove(tc,POS_FACEUP,REASON_COST)
		 else 
			  Duel.Release(tc,REASON_COST)
		 end
		 tc=g:GetNext()
   end
   local g1=Duel.SelectMatchingCard(tp,c98920219.rrfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
   local tc1=g1:GetFirst()
   if tc1:IsLocation(LOCATION_GRAVE) then 
		 Duel.Remove(tc1,POS_FACEUP,REASON_COST)
   else 
		 Duel.Release(tc1,REASON_COST)
   end
end
function c98920219.filter(c,e,tp)
	return c:IsCode(85066822,6022371,98920218) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c98920219.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then
		e:SetLabel(0)
		return res and Duel.IsExistingMatchingCard(c98920219.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c98920219.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920219.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
function c98920219.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsRace(RACE_SEASERPENT)
end
function c98920219.spcon2(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return (rp==tp and r&REASON_COST>0 and r&REASON_RELEASE>0
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsSetCard(0x100)
		and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND+LOCATION_MZONE) and not eg:IsContains(e:GetHandler())) or eg:IsExists(c98920219.cfilter,1,nil)
end
function c98920219.ssfilter(c,e,tp)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c98920219.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c98920219.ssfilter,nil,tp)
	local ct=g:GetCount()
	if chk==0 then return ct>0 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,ct,0,0)
end
function c98920219.spop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c98920219.ssfilter,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Draw(tp,ct,REASON_EFFECT)
		end
	end
end