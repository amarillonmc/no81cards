--居合斩！溯流从心
function c65830010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK+CATEGORY_TODECK+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65830010+EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(c65830010.target)
	e1:SetOperation(c65830010.activate)
	c:RegisterEffect(e1)
end


function c65830010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c65830010.filter(c)
	return c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_EFFECT)
end
function c65830010.activate(e,tp,eg,ep,ev,re,r,rp)
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
			e1:SetValue(c65830010.aclimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local g=Duel.GetMatchingGroup(c65830010.filter,tp,0,LOCATION_EXTRA,nil) 
			Duel.ConfirmCards(tp,g) 
			local dg=g:Select(tp,1,1,nil) 
			local ttc=dg:GetFirst()
			local rg=Group.CreateGroup()
			Duel.HintSelection(dg)
			Duel.Remove(dg,POS_FACEDOWN,REASON_EFFECT)
			local rg=Group.CreateGroup()
			local tpe=ttc:GetType()
			if bit.band(tpe,TYPE_TOKEN)==0 then
				local g1=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,nil,ttc:GetCode())
				rg:Merge(g1)
			end
			if rg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
			end
		else
			Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
		end
	end
end
function c65830010.aclimit(e,re,tp)
	return re:GetHandler():IsCode(65830010)
end