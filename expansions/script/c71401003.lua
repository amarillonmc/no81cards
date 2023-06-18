--蝶忆-「染」
xpcall(function() require("expansions/script/c71401001") end,function() require("script/c71401001") end)
function c71401003.initial_effect(c)
	yume.AddButterflyTrap(c,71401003)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401003,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,71501003)
	e2:SetCondition(c71401003.con2)
	e2:SetCost(c71401003.cost2)
	e2:SetTarget(c71401003.tg2)
	e2:SetOperation(c71401003.op2)
	c:RegisterEffect(e2)
	yume.ButterflyCounter()
end
function c71401003.con2(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c71401003.filterc2(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c71401003.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71401003.filterc2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71401003.filterc2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	yume.RegButterflyCostLimit(e,tp)
end
function c71401003.filter2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and (c:IsAbleToHand() or not c:IsForbidden() and c:CheckUniqueOnField(tp))
end
function c71401003.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71401003.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c71401003.filter2a(c)
	return c:IsAbleToRemove() and c:IsFaceup()
end
function c71401003.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c71401003.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=not tc:IsForbidden() and tc:CheckUniqueOnField(tp)
		local flag=0
		if b1 and (not b2 or Duel.SelectOption(tp,1190,aux.Stringid(71401003,1))==0) then
			flag=Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
				flag=1
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
			end
		end
		local rg=Duel.GetMatchingGroup(c71401003.filter2a,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if flag>0 and rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71401003,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local srg=rg:Select(tp,1,1,nil)
			Duel.Remove(srg,POS_FACEUP,REASON_EFFECT)
		end
	end
end