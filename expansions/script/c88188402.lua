--无助的请求
function c88188402.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c88188402.target)
	e1:SetOperation(c88188402.activate)
	c:RegisterEffect(e1)
end
function c88188402.thfilter(c,tp)
	return c:IsAbleToHand(tp)
end
function c88188402.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(c88188402.thfilter,tp,0,LOCATION_DECK,1,nil,tp) then sel=sel+1 end
		if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsPlayerCanDraw(tp,1) then sel=sel+2 end
		if Duel.IsPlayerCanDraw(tp,1) then sel=sel+4 end
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA)>1 and Duel.IsPlayerCanDraw(tp,1) then sel=sel+8 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(88188402,0))
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,1))
		sel=Duel.SelectOption(1-tp,aux.Stringid(88188402,2),aux.Stringid(88188402,4))
		if sel==1 then
			local sel=sel+1
		end
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,1))
		sel=Duel.SelectOption(1-tp,aux.Stringid(88188402,3),aux.Stringid(88188402,4))+1
	elseif sel==3 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,1))
		sel=Duel.SelectOption(1-tp,aux.Stringid(88188402,2),aux.Stringid(88188402,3),aux.Stringid(88188402,4))
	elseif sel==4 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,1))
		sel=Duel.SelectOption(1-tp,aux.Stringid(88188402,4),aux.Stringid(88188402,5))+2
	elseif sel==5 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,1))
		sel=Duel.SelectOption(1-tp,aux.Stringid(88188402,2),aux.Stringid(88188402,4),aux.Stringid(88188402,5))
		if sel>0 then
			local sel=sel+1
		end
	elseif sel==6 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,1))
		sel=Duel.SelectOption(1-tp,aux.Stringid(88188402,3),aux.Stringid(88188402,4),aux.Stringid(88188402,5))+1
	elseif sel==7 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,1))
		sel=Duel.SelectOption(1-tp,aux.Stringid(88188402,2),aux.Stringid(88188402,3),aux.Stringid(88188402,4),aux.Stringid(88188402,5))
	elseif sel==8 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,1))
		sel=Duel.SelectOption(1-tp,aux.Stringid(88188402,4),aux.Stringid(88188402,6))+2
		if sel==3 then
			local sel=sel+1
		end
	elseif sel==9 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,1))
		sel=Duel.SelectOption(1-tp,aux.Stringid(88188402,2),aux.Stringid(88188402,4),aux.Stringid(88188402,6))
		if sel==1 then
			local sel=sel+1
		elseif sel==2 then
			local sel=sel+2
		end
	elseif sel==10 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,1))
		sel=Duel.SelectOption(1-tp,aux.Stringid(88188402,3),aux.Stringid(88188402,4),aux.Stringid(88188402,6))+1
		if sel==2 then
			local sel=sel+2
		end
	elseif sel==11 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,1))
		sel=Duel.SelectOption(1-tp,aux.Stringid(88188402,2),aux.Stringid(88188402,3),aux.Stringid(88188402,4),aux.Stringid(88188402,6))
		if sel==3 then
			local sel=sel+1
		end
	elseif sel==12 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,1))
		sel=Duel.SelectOption(1-tp,aux.Stringid(88188402,4),aux.Stringid(88188402,5),aux.Stringid(88188402,6))+2
	elseif sel==13 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,1))
		sel=Duel.SelectOption(1-tp,aux.Stringid(88188402,2),aux.Stringid(88188402,4),aux.Stringid(88188402,5),aux.Stringid(88188402,6))
		if sel>0 then
			local sel=sel+1
		end
	elseif sel==14 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,1))
		sel=Duel.SelectOption(1-tp,aux.Stringid(88188402,3),aux.Stringid(88188402,4),aux.Stringid(88188402,5),aux.Stringid(88188402,6))+1
	elseif sel==15 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,1))
		sel=Duel.SelectOption(1-tp,aux.Stringid(88188402,2),aux.Stringid(88188402,3),aux.Stringid(88188402,4),aux.Stringid(88188402,5),aux.Stringid(88188402,6))
	end
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)
	elseif sel==1 then
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif sel==2 then
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1000)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
	elseif sel==3 then
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif sel==4 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	end
	Duel.SetChainLimit(c88188402.chainlm)
end
function c88188402.chainlm(e,ep,tp)
	return tp==ep and 1-tp==ep
end
function c88188402.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==0 then
		local th=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(88188402,7))
		local g=Duel.SelectMatchingCard(1-tp,c88188402.thfilter,tp,0,LOCATION_DECK,1,th,nil,tp)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif sel==1 then
		local dis=Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		if dis>0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	elseif sel==2 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	elseif sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(88188402,8))
		sel=Duel.SelectOption(tp,aux.Stringid(88188402,9),aux.Stringid(88188402,10))
		if sel==0 then
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Draw(p,d,REASON_EFFECT)
		else
			Duel.SetLP(tp,Duel.GetLP(tp)-500)
		end
	else
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,nil)
		if #g>0 then
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
