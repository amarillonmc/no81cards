--花梦-「结」
xpcall(function() require("expansions/script/c71401001") end,function() require("script/c71401001") end)
function c71401012.initial_effect(c)
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71401001,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c71401012.con1)
	e1:SetCountLimit(1,71401012)
	e1:SetCost(yume.ButterflyLimitCost)
	e1:SetTarget(yume.ButterflyPlaceTg)
	e1:SetOperation(yume.ButterflySpellOp)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401012,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,71501012)
	e2:SetCost(yume.ButterflyLimitCost)
	e2:SetTarget(c71401012.tg2)
	e2:SetOperation(c71401012.op2)
	c:RegisterEffect(e2)
	yume.ButterflyCounter()
end
function c71401012.con1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c71401012.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.NegateMonsterFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c71401012.filter2a(c)
	return c:IsFaceup() and c:GetType() & 0x20004==0x20004
end
function c71401012.filter2b(c, tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(4) and (c:IsAbleToHand() or not c:IsForbidden() and c:CheckUniqueOnField(tp))
end
function c71401012.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e) then
		local c=e:GetHandler()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local og=Duel.GetMatchingGroup(c71401012.filter2b,tp,LOCATION_DECK,0,nil, tp)
		if Duel.IsExistingMatchingCard(c71401012.filter2a,tp,LOCATION_ONFIELD,0,1,nil) and og:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71401012,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local oc=og:Select(tp,1,1,nil)
			if oc then
				local b1=oc:IsAbleToHand()
				local b2=not oc:IsForbidden() and oc:CheckUniqueOnField(tp)
				if b1 and (not b2 or Duel.SelectOption(tp,1190,aux.Stringid(71401012,2))==0) then
					Duel.SendtoHand(oc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,oc)
				else
					if Duel.MoveToField(oc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
						local e1=Effect.CreateEffect(c)
						e1:SetCode(EFFECT_CHANGE_TYPE)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
						e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
						oc:RegisterEffect(e1)
					end
				end
			end
		end
	end
end