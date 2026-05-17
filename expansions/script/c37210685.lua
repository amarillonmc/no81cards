--幻魔女 尼库拉
function c11210685.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11210685,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES+CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11210685)
	e1:SetCost(c11210685.descost)
	e1:SetTarget(c11210685.destg)
	e1:SetOperation(c11210685.desop)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11210685,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11210685+1)
	e2:SetTarget(c11210685.cttg)
	e2:SetOperation(c11210685.ctop)
	c:RegisterEffect(e2)
end
function c11210685.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c11210685.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c11210685.thfilter(c,tc,tp)
	return c:IsRace(tc:GetRace()) and c:IsAttribute(tc:GetAttribute()) and not c:IsCode(tc:GetCode()) and c:IsAbleToHand(tp) and aux.NecroValleyFilter()(c)
end
function c11210685.setfilter(c,tc)
	return not c:IsCode(tc:GetCode()) and c:IsType(TYPE_TRAP) and c:IsSSetable(true) and aux.NecroValleyFilter()(c)
end
function c11210685.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e))
	if g:GetCount()==0 then return end
	Duel.HintSelection(g)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if Duel.Destroy(g,REASON_EFFECT)==0 or not c:IsRelateToChain() then return end
	local b1=Duel.IsExistingMatchingCard(c11210685.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tc,tp) and c:IsAbleToDeck() and tc:IsType(TYPE_MONSTER)
	local b2=Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsType(TYPE_SPELL)
	local b3=c:IsDiscardable(REASON_EFFECT) and Duel.IsExistingMatchingCard(c11210685.setfilter,tp,LOCATION_GRAVE,0,1,nil,tc) and (Duel.GetLocationCount(0,LOCATION_SZONE)>0 or Duel.GetLocationCount(1,LOCATION_SZONE)>0) and tc:IsType(TYPE_TRAP)
	if not (b1 or b2 or b3) or not Duel.SelectYesNo(tp,aux.Stringid(11210685,0)) then return end
	Duel.BreakEffect()
	if b1 then
		if Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)==0 or not c:IsLocation(LOCATION_DECK) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c11210685.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tc,tp)
		Duel.HintSelection(tg)
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
	elseif b2 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	elseif b3 then
		Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectMatchingCard(tp,c11210685.setfilter,tp,LOCATION_GRAVE,0,1,1,nil,tc)
		Duel.HintSelection(sg)
		local p=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tp or 1-tp
		if Duel.GetLocationCount(0,LOCATION_SZONE)>0 and Duel.GetLocationCount(1,LOCATION_SZONE)>0 then
			if Duel.SelectOption(tp,aux.Stringid(11210685,1),aux.Stringid(11210685,2))==1 then p=1-tp end
		end
		Duel.SSet(tp,sg,p)
	end
end
function c11210685.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c11210685.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.GetControl(g,tp)
	end
end
