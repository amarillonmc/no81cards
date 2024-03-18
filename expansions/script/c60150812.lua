--贡献给虚无的灵魂
function c60150812.initial_effect(c)
	--Activate(effect)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c60150812.condition2)
	e4:SetTarget(c60150812.target2)
	e4:SetOperation(c60150812.activate2)
	c:RegisterEffect(e4)
end
function c60150812.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c60150812.cfilter(c)
	return c:IsSetCard(0x3b23) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c60150812.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150812.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if (re:GetHandler():IsAbleToRemove() or re:GetHandler():IsAbleToGrave())
		and re:GetHandler():IsRelateToEffect(re) then
		if e:GetHandler():IsLocation(LOCATION_HAND) and not e:GetHandler():IsFaceup() then Duel.ConfirmCards(1-tp,e:GetHandler()) end
		Duel.SetOperationInfo(0,CATEGORY_REMOVE+CATEGORY_TOGRAVE,eg,1,0,0)
	end
end
function c60150812.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		local tc=eg:GetFirst()
		if tc:IsAbleToRemove() and tc:IsAbleToGrave() then
			if Duel.SelectYesNo(tp,aux.Stringid(60150812,0)) then
				Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
			else
				Duel.SendtoGrave(tc,REASON_EFFECT)
				local g2=Duel.GetOperatedGroup()
				local ct=g2:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
				if ct==1 then
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		elseif not tc:IsAbleToRemove() and tc:IsAbleToGrave() then
			Duel.SendtoGrave(tc,REASON_EFFECT)
			local g2=Duel.GetOperatedGroup()
			local ct=g2:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
			if ct==1 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		elseif tc:IsAbleToRemove() and not tc:IsAbleToGrave() then
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
		local tc3=Duel.GetFieldCard(tp,LOCATION_DECK,0)
		local tc2=Duel.GetFieldCard(1-tp,LOCATION_DECK,0)
		if (tc3:IsAbleToRemove() and tc2:IsAbleToRemove()) and Duel.SelectYesNo(tp,aux.Stringid(60150810,0)) then
			if Duel.SelectYesNo(tp,aux.Stringid(60150810,1)) then
				Duel.BreakEffect()
				Duel.DisableShuffleCheck()
				Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)
			else
				Duel.BreakEffect()
				Duel.DisableShuffleCheck()
				Duel.Remove(tc3,POS_FACEUP,REASON_EFFECT)
			end
		elseif (tc3:IsAbleToRemove() and not tc2:IsAbleToRemove()) and Duel.SelectYesNo(tp,aux.Stringid(60150810,0)) then
			Duel.BreakEffect()
			Duel.DisableShuffleCheck()
			Duel.Remove(tc3,POS_FACEUP,REASON_EFFECT)
		elseif (not tc3:IsAbleToRemove() and tc2:IsAbleToRemove()) and Duel.SelectYesNo(tp,aux.Stringid(60150810,0)) then
			Duel.BreakEffect()
			Duel.DisableShuffleCheck()
			Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)
		end
	end
end 
