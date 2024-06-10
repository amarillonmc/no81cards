--逆流的回忆
local m=33703047
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,33703047)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.actcon)
	e1:SetCost(cm.actcost)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PREDRAW)
	e2:UseCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_DAMAGE)
	e0:SetLabel(0)
	e0:SetOperation(cm.calop)
	c:RegisterEffect(e0)
	--tohand grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabel(0)
	e3:SetCondition(cm.sgcon)
	e3:SetTarget(cm.sgtg)
	e3:SetOperation(cm.sgop)
	c:RegisterEffect(e3)
	e3:SetLabelObject(e0)
end
function cm.calop(e,tp,eg,ep,ev,re,r,rp)
	local temp = e:GetLabel()
	e:SetLabel(temp+ev)
	if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_END then
	e:SetLabel(0)
	end
end
function cm.sgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetFieldGroup(tp,LOCATION_HAND,0):GetCount()==0) and e:GetLabelObject():GetLabel()~=0
end
function cm.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.sgop(e,tp,eg,ep,ev,re,r,rp)
	local temp =math.floor((e:GetLabelObject():GetLabel())/100)
	local g=Duel.GetDecktopGroup(tp,Duel.GetFieldGroupCount(tp,temp,0))
	Duel.SendtoGrave(g,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.regcon)
	e1:SetTarget(cm.regtg)
	e1:SetOperation(cm.regop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY,1)
	Duel.RegisterEffect(e1,tp)
	e:GetHandler():SetLabel(1)

end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	 	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	 	return g:GetCount()>=5
end
function cm.regtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetCount()>=5  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,5,0,LOCATION_GRAVE)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>=5 then 
		local tc=g:GetFirst()
		local temp=0
		while tc do
			if temp ==5 then 
				break
			end
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
			temp=temp+1
			Duel.ConfirmCards(1-tp,tc)
			tc=g:GetNext()
		end
		aux.DrawReplaceCount=0
	end
end


function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	local tp = e:GetHandlerPlayer()
	return (Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0))
end
function cm.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0 and g:GetCount()<5
end
function cm.thfilter(c)
	return c:IsLocation(LOCATION_DECKBOT)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		aux.DrawReplaceCount=0
		aux.DrawReplaceMax=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	aux.DrawReplaceCount=aux.DrawReplaceCount+1
	if aux.DrawReplaceCount>aux.DrawReplaceMax or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	--local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	local sg=g:GetFirst()
	if g:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end