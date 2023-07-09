--蝶梦-「绽」
xpcall(function() require("expansions/script/c71401001") end,function() require("script/c71401001") end)
function c71401002.initial_effect(c)
	yume.AddButterflySpell(c,71401002)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401002,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,71501002)
	e2:SetCondition(c71401002.con2)
	e2:SetCost(c71401002.cost2)
	e2:SetTarget(c71401002.tg2)
	e2:SetOperation(c71401002.op2)
	c:RegisterEffect(e2)
	yume.ButterflyCounter()
end
function c71401002.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c71401002.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	yume.RegButterflyCostLimit(e,tp)
end
function c71401002.filter2(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_DARK) and (c:IsAbleToHand() or not c:IsForbidden() and c:CheckUniqueOnField(tp))
end
function c71401002.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71401002.filter2,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71401002.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c71401002.filter2,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=not tc:IsForbidden() and tc:CheckUniqueOnField(tp)
		if b1 and (not b2 or Duel.SelectOption(tp,1190,aux.Stringid(71401002,1))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
			end
		end
	end
end