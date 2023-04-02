QutryYx = {}

function QutryYx.ExtraEffectSelect(e,tp,res)
	local c=e:GetHandler()
	if not c:IsOriginalSetCard(0x5954) or not (e:IsActiveType(TYPE_MONSTER) or e:IsHasType(EFFECT_TYPE_ACTIVATE)) then return end
	local tep=nil
	local ct=Duel.GetCurrentChain()
	if ct>1 then tep=Duel.GetChainInfo(Duel.GetCurrentChain()-1,CHAININFO_TRIGGERING_PLAYER) end
	local te1=Duel.IsPlayerAffectedByEffect(tp,9910951)
	local b1=te1 and Duel.IsExistingMatchingCard(QutryYx.Filter1,tp,LOCATION_DECK,0,1,nil) and not c:IsCode(9910951)
	local te2=Duel.IsPlayerAffectedByEffect(tp,9910953)
	local b2=te2 and Duel.IsExistingMatchingCard(QutryYx.Filter2,tp,LOCATION_DECK,0,1,nil) and not c:IsCode(9910953)
	local te3=Duel.IsPlayerAffectedByEffect(tp,9910955)
	local b3=te3 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and not c:IsCode(9910955)
	local te4=Duel.IsPlayerAffectedByEffect(tp,9910957)
	local b4=te4 and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP)
		and not c:IsCode(9910957)
	local te5=Duel.IsPlayerAffectedByEffect(tp,9910963)
	local b5=te5 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) and tep and tep==1-tp
	local te6=Duel.IsPlayerAffectedByEffect(tp,9910964)
	local b6=te6 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,tp,POS_FACEDOWN)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil,tp,POS_FACEDOWN) and tep and tep==1-tp
	local te7=Duel.IsPlayerAffectedByEffect(tp,9910965)
	local b7=te7 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,nil) and tep and tep==1-tp
	if not (b1 or b2 or b3 or b4 or b5 or b6 or b7) or not Duel.IsExistingMatchingCard(QutryYx.Filter0,tp,LOCATION_REMOVED,0,2,nil)
		or not Duel.SelectYesNo(tp,aux.Stringid(9910950,0)) then return end
	local op=0
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(9910950,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(9910950,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(9910950,3)
		opval[off-1]=3
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(9910950,4)
		opval[off-1]=4
		off=off+1
	end
	if off>3 and (b5 or b6 or b7) then
		ops[off]=aux.Stringid(9910950,8)
		op=Duel.SelectOption(tp,table.unpack(ops))
		if op==off-1 then
			op=0
			off=1
			ops={}
			opval={}
		end
	end
	if b5 then
		ops[off]=aux.Stringid(9910950,5)
		opval[off-1]=5
		off=off+1
	end
	if b6 then
		ops[off]=aux.Stringid(9910950,6)
		opval[off-1]=6
		off=off+1
	end
	if b7 then
		ops[off]=aux.Stringid(9910950,7)
		opval[off-1]=7
		off=off+1
	end
	if op==0 then op=Duel.SelectOption(tp,table.unpack(ops)) end
	if res then Duel.BreakEffect() end
	if opval[op]==1 then
		Duel.Hint(HINT_CARD,0,9910951)
		if QutryYx.ToDeck(tp,2) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,QutryYx.Filter1,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
		te1:UseCountLimit(tp)
	elseif opval[op]==2 then
		Duel.Hint(HINT_CARD,0,9910953)
		if QutryYx.ToDeck(tp,2) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,QutryYx.Filter2,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
		te2:UseCountLimit(tp)
	elseif opval[op]==3 then
		Duel.Hint(HINT_CARD,0,9910955)
		if QutryYx.ToDeck(tp,2) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
		te3:UseCountLimit(tp)
	elseif opval[op]==4 then
		Duel.Hint(HINT_CARD,0,9910957)
		if QutryYx.ToDeck(tp,2) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
		te4:UseCountLimit(tp)
	elseif opval[op]==5 then
		Duel.Hint(HINT_CARD,0,9910963)
		if QutryYx.ToDeck(tp,2) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #g>0 then
				local tc=g:GetFirst()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
				end
				Duel.AdjustInstantly()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
		te5:UseCountLimit(tp)
	elseif opval[op]==6 then
		Duel.Hint(HINT_CARD,0,9910964)
		if QutryYx.ToDeck(tp,2) then
			local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil,tp,POS_FACEDOWN)
			local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil,tp,POS_FACEDOWN)
			if g1:GetCount()>0 and g2:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg1=g1:Select(tp,1,1,nil)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg2=g2:Select(tp,1,1,nil)
				sg1:Merge(sg2)
				Duel.HintSelection(sg1)
				Duel.Remove(sg1,POS_FACEDOWN,REASON_EFFECT)
			end
		end
		te6:UseCountLimit(tp)
	elseif opval[op]==7 then
		Duel.Hint(HINT_CARD,0,9910965)
		if QutryYx.ToDeck(tp,2) then
			local turnp=Duel.GetTurnPlayer()
			local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,turnp,LOCATION_EXTRA,0,nil)
			local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,turnp,0,LOCATION_EXTRA,nil)
			Duel.Hint(HINT_SELECTMSG,turnp,HINTMSG_TOGRAVE)
			local sg1=g1:Select(turnp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,1-turnp,HINTMSG_TOGRAVE)
			local sg2=g2:Select(1-turnp,1,1,nil)
			sg1:Merge(sg2)
			if sg1:GetCount()>0 then
				Duel.SendtoGrave(sg1,REASON_EFFECT)
			end
		end
		te7:UseCountLimit(tp)
	end
end
function QutryYx.Filter0(c)
	return c:IsFacedown() and c:IsSetCard(0x5954) and c:IsAbleToDeck()
end
function QutryYx.Filter1(c)
	return c:IsSetCard(0x5954) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function QutryYx.Filter2(c)
	return c:IsSetCard(0x5954) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function QutryYx.ToDeck(tp,ct)
	local oct=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,QutryYx.Filter0,tp,LOCATION_REMOVED,0,ct,ct,nil)
	if #g==ct then
		oct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	return oct==ct
end
