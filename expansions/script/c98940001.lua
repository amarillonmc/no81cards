--圣魔兽 塞勒凯特
function c98940001.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98940001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98940001)
	e1:SetCost(c98940001.spcost)
	e1:SetTarget(c98940001.sptg)
	e1:SetOperation(c98940001.spop)
	c:RegisterEffect(e1)
	 --tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98950001)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c98940001.target)
	e1:SetOperation(c98940001.activate)
	c:RegisterEffect(e1)
end
function c98940001.cfilter1(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGraveAsCost()
end
function c98940001.cfilter2(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGraveAsCost()
end
function c98940001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(c98940001.cfilter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c98940001.cfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c98940001.cfilter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c98940001.cfilter2,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c98940001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98940001.setfilter(c)
	return c:IsCode(29762407) and not c:IsForbidden()
end
function c98940001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		c:CompleteProcedure()
		local g=Duel.GetMatchingGroup(c98940001.setfilter,tp,LOCATION_DECK,0,nil)
		if  Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0
		and Duel.SelectYesNo(tp,aux.Stringid(98940001,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g:Select(tp,1,1,nil)
			Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c98940001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c98940001.tgfilter(c)
	return (c:IsCode(17484499) or aux.IsCodeListed(c,17484499))
end
function c98940001.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ct=Duel.GetMatchingGroup(c98940001.tgfilter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)~=0 and Duel.IsPlayerCanDiscardDeck(1-tp,ct) then
		local g=Duel.GetDecktopGroup(1-tp,ct)
		Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
		local rc=g:GetFirst()
		while rc do
			if rc:IsLocation(LOCATION_HAND) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(1,1)
				e1:SetValue(c98940001.aclimit)
				e1:SetLabel(rc:GetCode())
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
			rc=g:GetNext()
		end
	end
end
function c98940001.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
