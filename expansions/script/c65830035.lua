--居合斩！断汝筋骨
function c65830035.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65830035+EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(c65830035.target)
	e1:SetOperation(c65830035.activate)
	c:RegisterEffect(e1)
end


function c65830035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c65830035.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ShuffleDeck(c:GetControler())
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		if tc:IsSetCard(0xa33) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c65830035.aclimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(),tp,0,LOCATION_REMOVED+LOCATION_GRAVE,0,3,nil)
	if g:GetCount()~=0 then
		Duel.HintSelection(g)
		local ttc=g:GetFirst()
		while ttc do
		Duel.NegateRelatedChain(ttc,RESET_TURN_SET)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EFFECT_DISABLE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		ttc:RegisterEffect(e4)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ttc:RegisterEffect(e2)
		if ttc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			ttc:RegisterEffect(e3)
		end
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(ttc,RESET_TURN_SET)
		ttc=g:GetNext()
		end
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
		else
			Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
		end
	end
end
function c65830035.aclimit(e,re,tp)
	return re:GetHandler():IsCode(65830035)
end