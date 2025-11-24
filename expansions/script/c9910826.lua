--曙龙归来之雷霆
function c9910826.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK+CATEGORY_HANDES+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,9910826)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910826.target)
	e1:SetOperation(c9910826.activate)
	c:RegisterEffect(e1)
	--recycle
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,9910827)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c9910826.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c9910826.thop)
	c:RegisterEffect(e2)
end
function c9910826.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c9910826.gselect(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x6951) and g:FilterCount(Card.IsDiscardable,nil,REASON_EFFECT)==2
end
function c9910826.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6951) and c:IsAbleToDeck()
end
function c9910826.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g1=Duel.GetDecktopGroup(p,3)
	if Duel.Draw(p,d,REASON_EFFECT)==3 then
		local off=1
		local ops={}
		local opval={}
		ops[off]=aux.Stringid(9910826,0)
		opval[off-1]=1
		off=off+1
		local g2=Duel.GetFieldGroup(p,LOCATION_HAND,0)
		if #g2>=2 and g2:CheckSubGroup(c9910826.gselect,2,2) then
			ops[off]=aux.Stringid(9910826,1)
			opval[off-1]=2
			off=off+1
		end
		local op=Duel.SelectOption(p,table.unpack(ops))
		if opval[op]==1 then
			Duel.BreakEffect()
			local g3=Duel.GetMatchingGroup(c9910826.tdfilter,p,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
			g1:Merge(g3)
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local sg1=g1:Select(p,3,3,nil)
			Duel.ShuffleHand(p)
			Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		else
			Duel.BreakEffect()
			Duel.ShuffleHand(p)
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
			local sg2=g2:SelectSubGroup(p,c9910826.gselect,false,2,2)
			if sg2 and #sg2==2 and Duel.SendtoGrave(sg2,REASON_DISCARD+REASON_EFFECT)~=0
				and Duel.IsExistingMatchingCard(aux.TRUE,p,LOCATION_ONFIELD,LOCATION_ONFIELD,1,aux.ExceptThisCard(e))
				and Duel.SelectYesNo(p,aux.Stringid(9910826,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DESTROY)
				local sg3=Duel.GetFieldGroup(p,LOCATION_ONFIELD,LOCATION_ONFIELD):Select(p,1,1,aux.ExceptThisCard(e))
				Duel.HintSelection(sg3)
				Duel.Destroy(sg3,REASON_EFFECT)
			end
		end
	end
end
function c9910826.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and bit.band(r,REASON_DISCARD)~=0
end
function c9910826.thop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c9910826.thcon2)
	e1:SetOperation(c9910826.thop2)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	Duel.RegisterEffect(e1,tp)
end
function c9910826.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()+1
end
function c9910826.cfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c9910826.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910826)
	local g=Duel.GetMatchingGroup(c9910826.cfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=math.floor(g:GetClassCount(Card.GetCode)/2)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_GRAVE,0,ct,ct,nil)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
