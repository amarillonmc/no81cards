--遗迹探索的百千抉择
function c67201122.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67201122)
	e1:SetTarget(c67201122.target)
	e1:SetOperation(c67201122.activate)
	c:RegisterEffect(e1)  
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201122,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetCountLimit(1,67201123)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c67201122.optg)
	e2:SetOperation(c67201122.opop)
	c:RegisterEffect(e2)	 
end
function c67201122.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c67201122.seefilter(c)
	return c:IsSetCard(0x3670) and c:IsType(TYPE_MONSTER)
end
function c67201122.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	local g=Duel.GetDecktopGroup(tp,5)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(c67201122.seefilter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67201122,4))
		local sg=g:FilterSelect(tp,c67201122.seefilter,1,1,nil)
		--Duel.DisableShuffleCheck()
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.SortDecktop(tp,tp,5)
	--end
	else
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
--
function c67201122.tdfilter(c)
	return c:IsSetCard(0x3670) and c:IsFaceupEx() and c:IsAbleToDeck()
end
function c67201122.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,67201122)==0
	local b2=Duel.IsExistingMatchingCard(c67201122.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil)
		and Duel.GetFlagEffect(tp,67201123)==0
	if chk==0 then return b1 or b2 end
end
function c67201122.opop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,67201122)==0
	local b2=Duel.IsExistingMatchingCard(c67201122.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil)
		and Duel.GetFlagEffect(tp,67201123)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67201122,1),aux.Stringid(67201122,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67201122,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(67201122,2))+1
	else return end
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,67201122,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67201122.tdfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
		local opt=Duel.SelectOption(tp,aux.Stringid(67201122,5),aux.Stringid(67201122,6))
		if opt==0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
		else
			Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,67201123,RESET_PHASE+PHASE_END,0,1)
	end
end
