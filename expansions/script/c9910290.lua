--星幽沟通
function c9910290.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910290+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910290.cost)
	e1:SetTarget(c9910290.target)
	e1:SetOperation(c9910290.activate)
	c:RegisterEffect(e1)
end
function c9910290.rfilter(c,e,tp)
	return c:IsSetCard(0x957) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c9910290.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c9910290.spfilter(c,e,tp,code)
	return c:IsSetCard(0x957) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9910290.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp,true,true)
end
function c9910290.filter2(c,e,tp,flag1,flag2)
	local b1=flag1 and c:IsLocation(LOCATION_DECK) and c:IsSetCard(0x957) and c:IsAbleToHand()
		and not c:IsCode(9910290)
	local b2=flag2 and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
	return b1 or b2
end
function c9910290.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9910290.rfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c9910290.rfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.Release(g,REASON_COST)
end
function c9910290.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c9910290.chainlm)
	end
end
function c9910290.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER) or e:GetHandler():IsType(TYPE_PENDULUM)
end
function c9910290.thfilter(c)
	return c:IsSetCard(0x957) and c:IsAbleToHand()
end
function c9910290.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910290.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
	if g:GetCount()==0 or Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g1=Duel.GetMatchingGroup(c9910290.filter2,tp,LOCATION_DECK,0,nil,e,tp,true,false)
	local g2=Duel.GetMatchingGroup(c9910290.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp,false,true)
	if #g1+#g2==0 then return end
	Duel.BreakEffect()
	if #g1>0 and (#g2==0 or Duel.SelectOption(tp,aux.Stringid(9910290,0),aux.Stringid(9910290,1))==0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g1:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g2:Select(tp,1,1,nil):GetFirst()
		if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
