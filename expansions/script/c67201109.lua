--百千抉择的吟游诗人 罗兰
function c67201109.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201109,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	--e1:SetCountLimit(1,67201109)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c67201109.spcon)
	e1:SetTarget(c67201109.sptg)
	e1:SetOperation(c67201109.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201109,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_DECK)
	--e2:SetCountLimit(1,67201110)
	e2:SetTarget(c67201109.optg)
	e2:SetOperation(c67201109.opop)
	c:RegisterEffect(e2)   
end
function c67201109.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DRAW)
end
function c67201109.tdfilter(c)
	return c:IsAbleToDeck()
end
function c67201109.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67201109.tdfilter,tp,LOCATION_HAND,0,1,nil) end
end
function c67201109.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c67201109.tdfilter,tp,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()==0 then return end
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		local gg=Duel.GetOperatedGroup():GetCount()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount(),gg)
		e1:SetCondition(c67201109.spcon1)
		e1:SetOperation(c67201109.spop1)
		if Duel.GetCurrentPhase()<=PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c67201109.spfilter1(c,e,tp,lv)
	return c:IsSetCard(0x3670) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(lv)
end
function c67201109.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local e1,e2=e:GetLabel()
	return Duel.GetTurnCount()~=e1
end
function c67201109.spop1(e,tp,eg,ep,ev,re,r,rp)
	local e1,e2=e:GetLabel()
	Duel.Hint(HINT_CARD,0,67201109)
	Duel.Draw(tp,math.floor(e2/2),REASON_EFFECT)
end
--
function c67201109.spfilter(c,e,tp)
	return c:IsSetCard(0x3670) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67201109.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,67201109)==0
	local b2=Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_DECK,1,nil,TYPE_MONSTER)
		and Duel.GetFlagEffect(tp,67201110)==0
	if chk==0 then return b1 or b2 end
end
function c67201109.opop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,67201109)==0
	local b2=Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_DECK,1,nil,TYPE_MONSTER)
		and Duel.GetFlagEffect(tp,67201110)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67201109,1),aux.Stringid(67201109,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67201109,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(67201109,2))+1
	else return end
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,67201109,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67201109,4))
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
		local tc=g:GetFirst()
		if tc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,SEQ_DECKTOP)
			Duel.ConfirmDecktop(tp,1)
		end
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(67201109,4))
		local g=Duel.SelectMatchingCard(1-tp,Card.IsType,1-tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
		local tc=g:GetFirst()
		if tc then
			Duel.ShuffleDeck(1-tp)
			Duel.MoveSequence(tc,SEQ_DECKTOP)
			Duel.ConfirmDecktop(1-tp,1)
		end
		Duel.RegisterFlagEffect(tp,67201110,RESET_PHASE+PHASE_END,0,1)
	end
end


