--争雄的远古造物
function c9910742.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910742+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910742.cost)
	e1:SetTarget(c9910742.target)
	e1:SetOperation(c9910742.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910742,3))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function c9910742.cfilter(c)
	return c:IsFacedown() and c:IsAbleToGraveAsCost()
end
function c9910742.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (not c:IsLocation(LOCATION_HAND)
		or Duel.IsExistingMatchingCard(c9910742.cfilter,tp,LOCATION_ONFIELD,0,1,c)) end
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c9910742.cfilter,tp,LOCATION_ONFIELD,0,1,1,c)
		Duel.SendtoGrave(g,REASON_COST)
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c9910742.desfilter(c)
	return c:IsFaceup() and c:IsLevelBelow(9)
end
function c9910742.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9910742.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910742.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9910742.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetLabel()~=0 then
		e:SetCategory(e:GetCategory()|CATEGORY_DECKDES|CATEGORY_SPECIAL_SUMMON)
	else
		e:SetCategory(e:GetCategory()&~(CATEGORY_DECKDES|CATEGORY_SPECIAL_SUMMON))
	end
end
function c9910742.spfilter(c,e,tp,lv)
	return c:IsSetCard(0xc950) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9910742.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or Duel.Destroy(tc,REASON_EFFECT)==0 then return end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetLabel()~=0 then
		local lv=tc:GetOriginalLevel()
		if lv==0 then return end
		Duel.AdjustAll()
		local g=Duel.GetMatchingGroup(c9910742.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp,lv+1)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(9910742,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
