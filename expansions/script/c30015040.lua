--归墟溃散
local m=30015040
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--activate
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_ACTIVATE)
	e30:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e30)
	--Effect 1
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCondition(cm.thcon)
	e0:SetOperation(cm.thop)
	c:RegisterEffect(e0)
	--Effect 2 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_GRAVE_ACTION+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(ors.recost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e13=Effect.CreateEffect(c)
	e13:SetCategory(CATEGORY_TOGRAVE+CATEGORY_GRAVE_ACTION+CATEGORY_REMOVE)
	e13:SetType(EFFECT_TYPE_QUICK_O)
	e13:SetCode(EVENT_FREE_CHAIN)
	e13:SetRange(LOCATION_SZONE)
	e13:SetCountLimit(1)
	e13:SetCondition(cm.con)
	e13:SetCost(ors.recost)
	e13:SetTarget(cm.tg)
	e13:SetOperation(cm.op)
	c:RegisterEffect(e13)
	--Effect 3 
	--Effect 3 
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EVENT_LEAVE_FIELD_P)
	e20:SetOperation(ors.lechk)
	c:RegisterEffect(e20)
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_REMOVE)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(cm.orscon)
	e21:SetTarget(cm.orstg)
	e21:SetOperation(cm.orsop)
	c:RegisterEffect(e21)
	local e32=Effect.CreateEffect(c)
	e32:SetCategory(CATEGORY_REMOVE)
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e32:SetCode(EVENT_CHAIN_NEGATED)
	e32:SetProperty(EFFECT_FLAG_DELAY)
	e32:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e32:SetCondition(cm.tthcon)
	e32:SetTarget(cm.tthtg)
	e32:SetOperation(cm.tthop)
	c:RegisterEffect(e32)
	local e33=e32:Clone()
	e33:SetCode(EVENT_CUSTOM+30015500)
	e33:SetCondition(cm.tthcon2)
	c:RegisterEffect(e33) 
end
c30015040.isoveruins=true
--Effect 1
function cm.th(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetDrawCount(tp)>0 and Duel.IsExistingMatchingCard(cm.th,tp,LOCATION_REMOVED,0,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		aux.DrawReplaceCount=0
		aux.DrawReplaceMax=dt
	end
	aux.DrawReplaceCount=aux.DrawReplaceCount+1
	if aux.DrawReplaceCount<=aux.DrawReplaceMax then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
		local mg=Duel.GetMatchingGroup(cm.th,tp,LOCATION_REMOVED,0,nil)
		if #mg>0 then 
			local ct=ors[tp]+2
			if ct>#mg then ct=#mg end
			if ct==#mg then
				Duel.SendtoHand(mg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,mg)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=mg:RandomSelect(tp,ct)
				if #sg==0 then return false end
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end
--Effect 2
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetTurnPlayer()~=tp
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler(),tp,POS_FACEDOWN) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tp,POS_FACEDOWN)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	local dt=Duel.GetDrawCount(tp)
	Debug.Message(dt)   
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil,tp,POS_FACEDOWN)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
--Effect 3 
function cm.orscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.orstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	if ct>0 then
		local rc=c:GetReasonCard()
		local re=c:GetReasonEffect()
		if not rc and re then
			local sc=re:GetHandler()
			if not rc then
				Duel.SetTargetCard(sc)
				sg:AddCard(sc)
			end
		end 
		if rc then 
			Duel.SetTargetCard(rc)
			sg:AddCard(rc)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
end
function cm.orsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	end
	if ct==1 then
		local sc=Duel.GetFirstTarget() 
		ors.ptorm(e,tp,sc,exchk)
	end
end
--negop--
function cm.tthcon(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	local dc=de:GetHandler()
	if de and de~=nil and dc:IsControler(1-tp) then
		e:SetLabelObject(dc)
	end
	return rp==tp and de and de~=nil and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and e:GetHandler()==re:GetHandler() and e:GetHandler():GetReasonEffect()==de
end
function cm.tthcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==re:GetHandler() and c:GetReasonEffect()==nil
end
function cm.tthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(30015500)
	local dc=e:GetLabelObject()
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	if ct>0 then
		Duel.SetTargetParam(1) 
	end
	if dc and dc~=nil then
		Duel.SetTargetCard(dc)
		sg:AddCard(dc)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
end
function cm.tthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=e:GetLabelObject()
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	end
	if dc and dc~=nil then
		local sc=Duel.GetFirstTarget() 
		ors.ptorm(e,tp,sc,exchk)
	end
end