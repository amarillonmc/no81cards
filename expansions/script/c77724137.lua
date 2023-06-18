--玄奘(注:狸子DIY)
function c77724137.initial_effect(c)
	c:SetUniqueOnField(1,0,77724137)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,77724137)
	e1:SetCost(c77724137.spcost)
	e1:SetTarget(c77724137.sptg)
	e1:SetOperation(c77724137.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c77724137.desreptg)
	e3:SetOperation(c77724137.desrepop)
	c:RegisterEffect(e3)
end
function c77724137.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemoveAsCost()
end
function c77724137.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77724137.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c77724137.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,LOCATION_GRAVE,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c77724137.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77724137.cfilter2(c)
	return c:IsFacedown() or not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c77724137.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemove()
end
function c77724137.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(c77724137.filter,tp,LOCATION_DECK,0,nil)
		if not Duel.IsExistingMatchingCard(c77724137.cfilter2,tp,LOCATION_MZONE,0,1,nil)
			and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(77724137,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c77724137.desrepfilter(c,e)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToDeck()
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and not c:IsImmuneToEffect(e)
end
function c77724137.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c77724137.desrepfilter,tp,LOCATION_MZONE,0,1,c,e) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c77724137.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c77724137.desrepfilter,tp,LOCATION_MZONE,0,1,1,c,e)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_REPLACE)
end
