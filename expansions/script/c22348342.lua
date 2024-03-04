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
	return (c:IsSetCard(0xb70a) or c:IsCode(22348370)) and c:IsAbleToHand()
end
function chuoying.gaixiaoguo4(e,tp,res)
	local c=e:GetHandler()
	local chk=c:IsSetCard(0xd70a)
	if chk and c:GetFlagEffectLabel(22348362)
		and Duel.IsExistingMatchingCard(chuoying.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(22348362,3)) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_CARD,0,22348362)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,chuoying.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=tg:GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end

