--无休止的征伐
function c60152016.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60152016,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c60152016.con)
	e2:SetTarget(c60152016.target)
	e2:SetOperation(c60152016.activate)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60152016,1))
	e3:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetCondition(c60152016.condition)
	e3:SetTarget(c60152016.target2)
	e3:SetOperation(c60152016.activate2)
	c:RegisterEffect(e3)
end
function c60152016.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0
end
function c60152016.spfilter2(c)
	return c:IsReleasable()
end
function c60152016.filter(c)
	return c:IsSetCard(0x6b25) and c:IsType(TYPE_MONSTER)
end
function c60152016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c60152016.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60152016,0))
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60152016.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)~=0 then
			Duel.BreakEffect()
			local tc=g:GetFirst()
			if (tc:IsSetCard(0x6b25) and tc:IsType(TYPE_MONSTER)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x6b25)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,c60152016.filter,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end
	end
end
function c60152016.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0 
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c60152016.filter2(c)
	return c:IsSetCard(0x6b25) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c60152016.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60152016.filter2,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return Duel.IsExistingMatchingCard(c60152016.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) 
		and Duel.GetMZoneCount(tp,g,tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60152097,0,0x4011,0,0,10,RACE_PYRO,ATTRIBUTE_FIRE) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60152016,1))
	local g=Duel.GetMatchingGroup(c60152016.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c60152016.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetMZoneCount(tp)<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c60152016.filter2,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			if Duel.Release(g,REASON_EFFECT)~=0 then
				Duel.BreakEffect()
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ct=2
				if ft>ct then ft=ct end
				if ft<=0 then return end
				if not Duel.IsPlayerCanSpecialSummonMonster(tp,60152097,0,0x4011,0,0,10,RACE_PYRO,ATTRIBUTE_FIRE) then return end
				local ctn=true
				while ft>0 and ctn do
					local token=Duel.CreateToken(tp,60152097)
					Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
					ft=ft-1
					if ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(60152016,2)) then ctn=false end
				end
				Duel.SpecialSummonComplete()
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c60152016.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			if Duel.Release(g,REASON_EFFECT)~=0 then
				Duel.BreakEffect()
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ct=2
				if ft>ct then ft=ct end
				if ft<=0 then return end
				if not Duel.IsPlayerCanSpecialSummonMonster(tp,60152097,0,0x4011,0,0,10,RACE_PYRO,ATTRIBUTE_FIRE) then return end
				local ctn=true
				while ft>0 and ctn do
					local token=Duel.CreateToken(tp,60152097)
					Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
					ft=ft-1
					if ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(60152016,2)) then ctn=false end
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
end