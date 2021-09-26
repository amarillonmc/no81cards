--极翼灵兽 Bird Call Each Other
function c45745927.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45745927,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,45745927+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c45745927.condition)
	e1:SetTarget(c45745927.target)
	e1:SetOperation(c45745927.activate)
	c:RegisterEffect(e1)
end
function c45745927.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c45745927.filter(c)
	return c:IsSetCard(0x881) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c45745927.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45745927.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c45745927.spfilter(c,e,tp,code)
	return c:IsSetCard(0x881) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c45745927.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c45745927.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	local res=false
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc)
			res=true
		end
	else
		if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
			res=true
		end
	end
	if res and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c45745927.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,tc:GetCode())
		and Duel.SelectYesNo(tp,aux.Stringid(45745927,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c45745927.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc:GetCode())
		Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
	end
end
