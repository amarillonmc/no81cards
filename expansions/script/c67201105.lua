--战前准备的百千抉择
function c67201105.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67201105+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c67201105.target)
	e1:SetOperation(c67201105.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201105,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetCountLimit(1,67201106)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c67201105.optg)
	e2:SetOperation(c67201105.opop)
	c:RegisterEffect(e2)	 
end
function c67201105.filter(c)
	return c:IsSetCard(0x3670) and c:IsType(TYPE_MONSTER)
end
function c67201105.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67201105.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c67201105.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67201105,4))
	local g=Duel.SelectMatchingCard(tp,c67201105.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
end
--
function c67201105.tdfilter(c)
	return c:IsSetCard(0x3670) and c:IsFaceupEx() and c:IsAbleToDeck()
end
function c67201105.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,67201105)==0
	local b2=Duel.IsExistingMatchingCard(c67201105.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil)
		and Duel.GetFlagEffect(tp,67201106)==0
	if chk==0 then return b1 or b2 end
end
function c67201105.opop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,67201105)==0
	local b2=Duel.IsExistingMatchingCard(c67201105.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil)
		and Duel.GetFlagEffect(tp,67201106)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67201105,1),aux.Stringid(67201105,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67201105,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(67201105,2))+1
	else return end
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,67201105,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67201105.tdfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
		local opt=Duel.SelectOption(tp,aux.Stringid(67201105,5),aux.Stringid(67201105,6))
		if opt==0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
		else
			Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,67201106,RESET_PHASE+PHASE_END,0,1)
	end
end
