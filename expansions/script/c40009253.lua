--狂风戈
function c40009253.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009253,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40009253)
	e1:SetCost(c40009253.cost)
	e1:SetTarget(c40009253.target)
	e1:SetOperation(c40009253.operation)
	c:RegisterEffect(e1)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009253,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,40009254)
	e3:SetCondition(c40009253.spcon)
	e3:SetTarget(c40009253.drtg)
	e3:SetOperation(c40009253.drop)
	c:RegisterEffect(e3)  
end
function c40009253.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c40009253.filter(c)
	return c:IsSetCard(0xef1d) and c:IsType(TYPE_CONTINUOUS+TYPE_TRAP) and c:IsAbleToHand()
end
function c40009253.tgfilter(c)
	return (c:IsCode(40009154) and c:IsFaceup())
end
function c40009253.aspfilter(c,e,tp)
	return c:IsCode(40009249) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009253.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009253.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40009253.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40009253.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if not Duel.IsExistingMatchingCard(c40009253.tgfilter,tp,LOCATION_MZONE,0,1,nil) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local sg=Duel.GetMatchingGroup(c40009253.aspfilter,tp,LOCATION_DECK,0,nil,e,tp)
			if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40009253,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:Select(tp,1,1,nil)
				Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c40009253.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c40009253.splimit(e,c)
	return not c:IsSetCard(0xbf1d) and c:IsLocation(LOCATION_EXTRA)
end
function c40009253.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c40009253.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c40009253.drop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Draw(tp,1,REASON_EFFECT)
	 Duel.Draw(1-tp,1,REASON_EFFECT)
			Duel.ShuffleHand(tp)
			Duel.ShuffleHand(1-tp)
end
