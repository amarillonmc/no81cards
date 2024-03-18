--星空闪耀 流星洛书
function c50001006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(50001006,2)) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,50001006)   
	e1:SetTarget(c50001006.actg) 
	e1:SetOperation(c50001006.acop) 
	c:RegisterEffect(e1)  
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(50001006,3)) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,50001006)   
	e1:SetTarget(c50001006.tddrtg) 
	e1:SetOperation(c50001006.tddrop) 
	c:RegisterEffect(e1)  
end
c50001006.SetCard_WK_StarS=true   
function c50001006.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and (c.SetCard_WK_StarS or c:IsSetCard(0x3a04)) end,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c.SetCard_WK_StarS end,tp,LOCATION_MZONE,0,1,1,nil)  
end 
function c50001006.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then   
		--pos 
		local e1=Effect.CreateEffect(c) 
		e1:SetDescription(aux.Stringid(50001006,1))
		e1:SetCategory(CATEGORY_TODECK)
		e1:SetType(EFFECT_TYPE_QUICK_O) 
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)   
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)  
		e1:SetTarget(c50001006.distg)
		e1:SetOperation(c50001006.disop)
		tc:RegisterEffect(e1) 
	end 
end 
function c50001006.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD)
end 
function c50001006.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) then 
		local tc=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst() 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
		end
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end 
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(50001006,0)) then 
			local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil) 
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) 
		end 
	end
end
function c50001006.filter(c)
	return c:IsType(TYPE_MONSTER) and (c.SetCard_WK_StarS or c:IsSetCard(0x3a04)) and c:IsAbleToDeck()
end
function c50001006.tddrtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingTarget(c50001006.filter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c50001006.filter,tp,LOCATION_REMOVED,0,3,99,nil) 
	e:SetLabel(g:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c50001006.tddrop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local x=e:GetLabel()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=x then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==x then 
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end








