--真武神集结
function c40009378.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40009378+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c40009378.condition)
	e1:SetTarget(c40009378.target)
	e1:SetOperation(c40009378.activate)
	c:RegisterEffect(e1)	
end
function c40009378.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,nil)
end
function c40009378.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_HAND)
end
function c40009378.thfilter(c,e,tp)
	return c:IsSetCard(0x88) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c40009378.activate(e,tp,eg,ep,ev,re,r,rp)
		local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local sg=Duel.SendtoGrave(hg,REASON_EFFECT)~=0
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c40009378.thfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=g:SelectSubGroup(tp,aux.dncheck,false,1,3)
		if ct>=3
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct		  
			and Duel.SelectOption(tp,1190,1152)==1 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
end