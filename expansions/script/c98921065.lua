--赐福神鸟
function c98921065.initial_effect(c)
	c:SetSPSummonOnce(98921065)	
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),3,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921065,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c98921065.cost)
	e1:SetTarget(c98921065.target)
	e1:SetOperation(c98921065.operation)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c98921065.tdcon)
	e2:SetTarget(c98921065.tdtg)
	e2:SetOperation(c98921065.tdop)
	c:RegisterEffect(e2)
end
function c98921065.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c98921065.filter(c)
	return c:IsRace(RACE_SPELLCASTER+RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevel(3) and c:IsAbleToHand()
end
function c98921065.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921065.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98921065.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98921065.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98921065.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()==0
end
function c98921065.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c98921065.sfilter(c,e,tp)
	return c:IsCode(96305350) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98921065.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsRank(3) and c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98921065.xfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c98921065.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)>0
		and Duel.IsEnvironment(98921067) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c98921065.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
			and Duel.GetMatchingGroup(c98921065.xfilter,tp,LOCATION_GRAVE,0,nil):GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98921065,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local ssg=Duel.GetMatchingGroup(c98921065.xfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil)
			local sg=Duel.SelectMatchingCard(tp,c98921065.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			local tc=sg:GetFirst()
			if ssg:GetCount()>1 then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			   local sssg=ssg:Select(tp,2,2,nil)
			   Duel.Overlay(tc,sssg)
		   end
		end
end