--溟界王-阿隆拉
function c98921081.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_REPTILE),8,2)
	c:EnableReviveLimit()	
	--spsummon2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98921081,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98921081)
	e3:SetCondition(c98921081.spcon2)
	e3:SetTarget(c98921081.sptg2)
	e3:SetOperation(c98921081.spop2)
	c:RegisterEffect(e3)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921081,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98921081)
	e2:SetCost(c98921081.spcost)
	e2:SetTarget(c98921081.sptg)
	e2:SetOperation(c98921081.spop)
	c:RegisterEffect(e2)
end
function c98921081.cfilter2(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousControler(1-tp)
end
function c98921081.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98921081.cfilter2,1,nil,tp)
end
function c98921081.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c98921081.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98921081.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(c98921081.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if ct<=0 or not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	local count=c:RemoveOverlayCard(tp,1,ct,REASON_EFFECT)
	if count<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98921081.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,count,count,nil)
	Duel.HintSelection(g)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_REMOVED,1,nil,tp)
		and Duel.SelectYesNo(1-tp,aux.Stringid(98921081,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_REMOVED,1,1,nil,tp)
		Duel.SendtoGrave(g,REASON_RETURN)
	end
end
function c98921081.tgfilter(c,tp)
	return c:IsAbleToHand(1-tp)
end
function c98921081.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c98921081.spfilter(c,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and Duel.GetMZoneCount(tp,c)>0 and c:IsReleasable(REASON_COST)
end
function c98921081.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921081.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98921081.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c98921081.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98921081.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e1)
			local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98921081.mfilter),tp,LOCATION_GRAVE,0,nil)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98921081,1)) then
			   Duel.BreakEffect()
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			   local mg=g:Select(tp,1,1,nil)
			   Duel.Overlay(c,mg)
		   end
		end
	end
end
function c98921081.mfilter(c)
	return c:IsRace(RACE_REPTILE) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end