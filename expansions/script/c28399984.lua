--星雨
function c28399984.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c28399984.cost)
	e1:SetTarget(c28399984.target)
	e1:SetOperation(c28399984.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c28399984.sptg)
	e2:SetOperation(c28399984.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_F)
	e4:SetCode(EVENT_BECOME_TARGET)
	e4:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e4:SetCondition(c28399984.spcon)
	c:RegisterEffect(e4)
end
function c28399984.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c28399984.tgfilter(c)
	return c:IsSetCard(0x284) and c:IsAbleToGrave()
end
function c28399984.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28399984.tgfilter,tp,LOCATION_DECK,0,4,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,4,tp,LOCATION_DECK)
	if e:GetLabelObject():IsSetCard(0x284) then
	   e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	end
end
function c28399984.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c28399984.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,4,4,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c28399984.cfilter(c,e,tp)
	return c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c28399984.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	return eg:IsContains(e:GetHandler()) and re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x284)
end
function c28399984.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c28399984.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sc=Duel.SelectMatchingCard(tp,c28399984.cfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if sc then
		local b1=sc:IsAbleToHand()
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if b1 and b2 then op=Duel.SelectOption(tp,1190,1152)
		elseif b1 then op=0
		else op=1 end
		if op==0 then
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
		else
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c28399984.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c28399984.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsRace(RACE_FAIRY)
end
