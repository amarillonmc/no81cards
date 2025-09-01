--洗衣龙女呼唤
local cm,m=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m+3)
	e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_HAND+LOCATION_SZONE)
	e3:SetOperation(cm.debug)
	c:RegisterEffect(e3)
end
function cm.debug(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local g=Duel.GetMatchingGroup(function(c) return c:GetTurnID()==Duel.GetTurnCount() and c:IsPreviousLocation(LOCATION_DECK) end,tp,LOCATION_GRAVE,0,nil)
	Debug.Message("这个回合从卡组送去自己墓地的卡："..#g.."张")
	for tc in aux.Next(g) do tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3)) end
end
function cm.tdfilter(c,tid)
	return c:GetTurnID()==tid and not c:IsReason(REASON_RETURN) and c:GetPreviousLocation()==LOCATION_DECK and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	local dt=Duel.GetDrawCount(tp)
	if tid==1 then
		dt=1
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DRAW_COUNT)}
		for _,te in pairs(eset) do
			if te:GetValue()>dt then dt=te:GetValue() end
		end
		for _,te in pairs(eset) do
			if te:GetValue()==0 then dt=0 end
		end
	end
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE,0,nil,tid)
	if chk==0 then return #g>0 and dt>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tid=Duel.GetTurnCount()
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE,0,nil,tid)
	if Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)==0 then return end
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	if ct>0 then
		if ct<=16 then
			Duel.SortDecktop(tp,tp,ct)
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451463,2))
			local tc=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK):Select(tp,1,1,nil):GetFirst()
			if not tc then return end
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
		end
		local dt=Duel.GetDrawCount(tp)
		if tid==1 then
			dt=1
			local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DRAW_COUNT)}
			for _,te in pairs(eset) do
				if te:GetValue()>dt then dt=te:GetValue() end
			end
			for _,te in pairs(eset) do
				if te:GetValue()==0 then dt=0 end
			end
		end
		if dt>0 then
			Duel.BreakEffect()
			if Duel.Draw(tp,dt,REASON_EFFECT)>0 and Duel.GetFlagEffect(tp,m)+Duel.GetFlagEffect(1-tp,m)>0 then
				local tg=Duel.GetOperatedGroup()
				for tc in aux.Next(tg) do
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetDescription(aux.Stringid(m,2))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_PUBLIC)
					e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e3=Effect.CreateEffect(e:GetHandler())
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_CANNOT_TRIGGER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
					Duel.ConfirmCards(1-tp,tc)
				end
			end
		end
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) and e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,c)
	if Duel.GetTurnPlayer()==tp then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
	else
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
	end
end