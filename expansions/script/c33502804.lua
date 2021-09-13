--无言红枫 魔女之旅
function c33502804.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddCodeList(c,33502800)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33502804,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33502804)
	e1:SetCost(c33502804.cost1)
	e1:SetTarget(c33502804.tg1)
	e1:SetOperation(c33502804.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33502804,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c33502804.con2)
	e2:SetTarget(c33502804.tg2)
	e2:SetOperation(c33502804.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c33502804.con3)
	e3:SetOperation(c33502804.op3)
	c:RegisterEffect(e3)
--
end
--
function c33502804.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_HAND)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and not c:IsForbidden() end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CHANGE_TYPE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	e1_1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e1_1)
end
--
function c33502804.tfilter1(c)
	return aux.IsCodeListed(c,33502800) and c:IsAbleToHand()
end
function c33502804.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33502804.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
--
function c33502804.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local lg=Duel.SelectMatchingCard(tp,c33502804.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if lg:GetCount()>0 and Duel.SendtoHand(lg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,lg)
		Duel.ShuffleHand(tp)
		if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end
--
function c33502804.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
--
function c33502804.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Group.CreateGroup()
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<3 then return false end
		sg=Duel.GetDecktopGroup(1-tp,3)
		return sg:FilterCount(Card.IsAbleToDeck,nil)==3
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
--
function c33502804.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<3 then return end
	local sg=Duel.GetDecktopGroup(1-tp,3)
	if Duel.SendtoDeck(sg,tp,2,REASON_EFFECT)>0 then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			local e2_1=Effect.CreateEffect(c)
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetValue(800)
			e2_1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2_1)
			local e2_2=Effect.CreateEffect(c)
			e2_2:SetType(EFFECT_TYPE_SINGLE)
			e2_2:SetCode(EFFECT_IMMUNE_EFFECT)
			e2_2:SetValue(c33502804.efilter2_2)
			e2_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e2_2)
		end
	end
end
function c33502804.efilter2_2(e,re)
	return re:GetOwner()~=e:GetOwner()
end
--
function c33502804.con3(e)
	local c=e:GetHandler()
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
--
function c33502804.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(aux.FALSE)
end
--
