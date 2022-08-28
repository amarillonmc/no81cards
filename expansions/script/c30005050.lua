--虚冥幽魄
local m=30005050
local cm=_G["c"..m]
function cm.initial_effect(c)
	--not chaining
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(0xff)
	e3:SetOperation(cm.chainop)
	c:RegisterEffect(e3)
	--hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_MOVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.hdcon)
	e1:SetTarget(cm.hdtg)
	c:RegisterEffect(e1) 
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,1))
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_MOVE)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCondition(cm.hdcon3)
	e11:SetTarget(cm.hdtg3)
	c:RegisterEffect(e11) 
end
--not chaining
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler()==e:GetHandler() then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
--hand
function cm.cfilter(c,tp)
	return c:IsPreviousControler(tp) 
	 and c:IsPreviousLocation(LOCATION_HAND) 
end
function cm.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and rp==1-tp
end
function cm.hdcon3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsPreviousControler(tp) and rp==1-tp
end
function cm.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local trs=Duel.GetTurnPlayer()==e:GetHandler():GetControler()
	local tro=Duel.GetTurnPlayer()~=e:GetHandler():GetControler()
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return c:IsDiscardable(REASON_EFFECT) 
		and (trs and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c))
		or (tro and ph~=PHASE_MAIN2 and ph~=PHASE_END) end
	if Duel.GetTurnPlayer()==e:GetHandler():GetControler() then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
		e:SetOperation(cm.tohand)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
	else
		e:SetCategory(CATEGORY_DRAW)
		e:SetOperation(cm.draw)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
	end
end
function cm.tohand(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,c)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.draw(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local trp=Duel.GetTurnPlayer()
	local tsp=e:GetHandlerPlayer()
	if Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)==0 then return end
	Debug.Message(Duel.GetTurnCount()) 
	if Duel.GetTurnCount()==1 then
		if  ph~=PHASE_END then
			Duel.SkipPhase(trp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(trp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(trp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(trp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
			Duel.SkipPhase(trp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,trp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE_START+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetCondition(cm.ddcon)
			e2:SetOperation(cm.ddop)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tsp)
		end
	else
		if ph~=PHASE_MAIN2 and ph~=PHASE_END then
			Duel.SkipPhase(trp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(trp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
			if not Duel.IsPlayerAffectedByEffect(trp,EFFECT_SKIP_BP) and not Duel.IsPlayerAffectedByEffect(trp,EFFECT_CANNOT_BP) then
				Duel.SkipPhase(trp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			end
			local e12=Effect.CreateEffect(c)
			e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e12:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
			e12:SetCountLimit(1)
			e12:SetOwnerPlayer(trp)
			e12:SetOperation(cm.bkop)
			e12:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e12,trp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE_START+PHASE_MAIN2)
			e2:SetCountLimit(1)
			e2:SetCondition(cm.ddcon)
			e2:SetOperation(cm.ddop)
			e2:SetReset(RESET_PHASE+PHASE_MAIN2)
			Duel.RegisterEffect(e2,tsp)
		end
	end
end
function cm.bkop(e,tp,eg,ep,ev,re,r,rp)
	local tsp=e:GetOwnerPlayer()
	local ph=Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE,1)
	Duel.RegisterEffect(e1,tsp)
end
function cm.ddcon(e)
	local c=e:GetHandler()
	local tp=e:GetOwnerPlayer()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	g:RemoveCard(c)
	local ct=5-#g
	e:SetLabel(ct)
	return ct>0 and Duel.IsPlayerCanDraw(tp,ct)
end
function cm.ddop(e,tp,eg,ep,ev,re,r,rp)
	local tsp=e:GetOwnerPlayer()
	local ct=e:GetLabel()
	if Duel.SelectYesNo(tsp,aux.Stringid(m,0)) then
		Duel.Draw(tsp,ct,REASON_EFFECT)
	end
end
function cm.hdtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local trs=Duel.GetTurnPlayer()==e:GetHandler():GetControler()
	local tro=Duel.GetTurnPlayer()~=e:GetHandler():GetControler()
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return (trs and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c))
		or (tro and ph~=PHASE_MAIN2 and ph~=PHASE_END) end
	if Duel.GetTurnPlayer()==e:GetHandler():GetControler() then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
		e:SetOperation(cm.tohand3)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	else
		e:SetCategory(CATEGORY_DRAW)
		e:SetOperation(cm.draw3)
	end
end
function cm.tohand3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,c)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.draw3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local trp=Duel.GetTurnPlayer()
	local tsp=e:GetHandlerPlayer()
	if Duel.GetTurnCount()==1 then
		if  ph~=PHASE_END then
			Duel.SkipPhase(trp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(trp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(trp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(trp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
			Duel.SkipPhase(trp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,trp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE_START+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetCondition(cm.ddcon)
			e2:SetOperation(cm.ddop)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tsp)
		end
	else
		if ph~=PHASE_MAIN2 and ph~=PHASE_END then
			Duel.SkipPhase(trp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(trp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
			if not Duel.IsPlayerAffectedByEffect(trp,EFFECT_SKIP_BP) and not Duel.IsPlayerAffectedByEffect(trp,EFFECT_CANNOT_BP) then
				Duel.SkipPhase(trp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			end
			local e12=Effect.CreateEffect(c)
			e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e12:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
			e12:SetCountLimit(1)
			e12:SetOwnerPlayer(trp)
			e12:SetOperation(cm.bkop)
			e12:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e12,trp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE_START+PHASE_MAIN2)
			e2:SetCountLimit(1)
			e2:SetCondition(cm.ddcon)
			e2:SetOperation(cm.ddop)
			e2:SetReset(RESET_PHASE+PHASE_MAIN2)
			Duel.RegisterEffect(e2,tsp)
		end
	end
end