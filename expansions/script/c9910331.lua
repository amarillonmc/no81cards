--潜匿罪恶的匪魔城
function c9910331.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910331+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910331.target)
	e1:SetOperation(c9910331.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c9910331.tgtg)
	e2:SetOperation(c9910331.tgop)
	c:RegisterEffect(e2)
	--race
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9910331.racon)
	e3:SetCost(c9910331.racost)
	e3:SetTarget(c9910331.ratg)
	e3:SetOperation(c9910331.raop)
	c:RegisterEffect(e3)
end
function c9910331.thfilter(c)
	return c:IsSetCard(0x3954) and c:IsAbleToHand()
end
function c9910331.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910331.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910331.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910331.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9910331.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
end
function c9910331.tgfilter(c)
	return (c:IsRace(RACE_WARRIOR+RACE_FIEND) or c:IsType(TYPE_TRAP)) and c:IsAbleToGrave()
end
function c9910331.gselect(g)
	return g:FilterCount(Card.IsRace,nil,RACE_WARRIOR)<2 and g:FilterCount(Card.IsRace,nil,RACE_FIEND)<2
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<2
end
function c9910331.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,5)
	if #g==5 then
		Duel.ConfirmDecktop(tp,5)
		local tg=g:Filter(c9910331.tgfilter,nil)
		if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(9910331,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=tg:SelectSubGroup(tp,c9910331.gselect,false,1,3)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
		end
		Duel.ShuffleDeck(tp)
	end
end
function c9910331.racon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c9910331.cfilter(c)
	return c:IsSetCard(0x3954) and c:IsFacedown()
end
function c9910331.racost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910331.cfilter,tp,LOCATION_ONFIELD,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c9910331.cfilter,tp,LOCATION_ONFIELD,0,3,3,nil)
	Duel.ConfirmCards(1-tp,g)
end
function c9910331.ratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910331,1))
end
function c9910331.raop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetRange(LOCATION_FZONE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetValue(RACE_FIEND)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
