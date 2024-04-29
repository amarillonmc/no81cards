chuoying=chuoying or {}
function chuoying.gaixiaoguo1(e,tp,res)
	local c=e:GetHandler()
	local chk=c:IsSetCard(0xd70a)
	if chk and c:GetFlagEffectLabel(22348359)
		and Duel.IsPlayerCanDiscardDeck(tp,3)
		and Duel.SelectYesNo(tp,aux.Stringid(22348359,3)) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_CARD,0,22348359)
		Duel.DiscardDeck(tp,3,REASON_EFFECT)
	end
end
function chuoying.gaixiaoguo2(e,tp,res)
	local c=e:GetHandler()
	local chk=c:IsSetCard(0xd70a)
	if chk and c:GetFlagEffectLabel(22348360)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(22348360,3)) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_CARD,0,22348360)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_GRAVE,1,2,nil)
		Duel.HintSelection(rg)
		if #rg>0 then
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function chuoying.gaixiaoguo3(e,tp,res)
	local c=e:GetHandler()
	local chk=c:IsSetCard(0xd70a)
	if chk and c:GetFlagEffectLabel(22348361)
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(22348361,3)) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_CARD,0,22348361)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(dg)
		if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function chuoying.thfilter(c)
	return (c:IsSetCard(0xb70a) or c:IsCode(22348370)) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function chuoying.gaixiaoguo4(e,tp,res)
	local c=e:GetHandler()
	local chk=c:IsSetCard(0xd70a)
	if chk and c:GetFlagEffectLabel(22348362)
		and Duel.IsExistingMatchingCard(chuoying.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(22348362,3)) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_CARD,0,22348362)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tg=Duel.SelectMatchingCard(tp,chuoying.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=tg:GetFirst()
		if tc then
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
		end
	end
end
function chuoying.disfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.NegateMonsterFilter(c)
end
function chuoying.gaixiaoguo5(e,tp,res)
	local c=e:GetHandler()
	local chk=c:IsSetCard(0xd70a)
	if chk and c:GetFlagEffectLabel(22348413)
		and Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(22348413,3)) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_CARD,0,22348413)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local dg=Duel.SelectMatchingCard(tp,aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local tc=dg:GetFirst()
		Duel.HintSelection(dg)
		if tc:IsFaceup() and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		end
	end
end
function chuoying.gaixiaoguo6(e,tp,res)
	local c=e:GetHandler()
	local chk=c:IsSetCard(0xd70a)
	if chk and c:GetFlagEffectLabel(22348414)
		and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(22348414,3)) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_CARD,0,22348414)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
